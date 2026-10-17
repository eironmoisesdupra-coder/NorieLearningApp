import json
import os
from pathlib import Path
import subprocess
import shutil
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
DART = os.environ.get('DART') or shutil.which('dart')
class CertificationTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not DART:
            raise RuntimeError('Dart SDK not found. Put dart on PATH or set DART to the SDK executable before running certification tool tests.')
    def invoke(self, *args, env=None):
        return subprocess.run([str(DART), *args],cwd=ROOT,capture_output=True,text=True,env=env)
    def test_template_cannot_be_mistaken_for_certification(self):
        self.assertTrue((ROOT/'tool/device_certification.dart').exists(),'matrix generator missing')
        with tempfile.TemporaryDirectory() as directory:
            report=Path(directory)/'report.json'
            result=self.invoke('tool/device_certification.dart',str(report))
            self.assertEqual(result.returncode,0,result.stderr)
            data=json.loads(report.read_text())
            self.assertEqual(len(data['devices']),5)
            self.assertTrue(all(r['status']=='not_tested' for d in data['devices'] for r in d['results']))
            result=self.invoke('tool/verify_device_certification.dart',str(report),'a'*40,'0.12.0+16','b'*64,'c'*64)
            self.assertNotEqual(result.returncode,0)
    def test_complete_reports_bind_every_device_and_evidence_to_build(self):
        self.assertTrue((ROOT/'tool/device_certification.dart').exists(),'matrix generator missing')
        with tempfile.TemporaryDirectory() as directory:
            report=Path(directory)/'report.json'; evidence=Path(directory)/'photo.txt'; evidence.write_text('Human captured evidence fixture')
            self.invoke('tool/device_certification.dart',str(report))
            data=json.loads(report.read_text())
            data.update(source_revision='a'*40,app_version='0.12.0+16',origin='human_physical',operator='Test operator',started_at='2026-10-17T01:00:00Z',completed_at='2026-10-17T02:00:00Z')
            for d in data['devices']:
                d.update(label='Hardware fixture',os_version='OS fixture',ram_gb=4,screen='1280x720',physical=True,artifact_sha256=('b' if d['platform']=='android' else 'c')*64)
                for r in d['results']: r.update(status='pass',notes='Observed scenario on fixture',elapsed_ms=123,evidence='photo.txt')
            env={k:v for k,v in os.environ.items() if k not in ('CI','GITHUB_ACTIONS')}
            def verify():
                report.write_text(json.dumps(data)); return self.invoke('tool/verify_device_certification.dart',str(report),'a'*40,'0.12.0+16','b'*64,'c'*64,env=env)
            self.assertEqual(verify().returncode,0)
            original=json.loads(json.dumps(data))
            for mutate in (lambda: data['devices'].pop(),lambda: data['devices'][0].update({'class':'unknown','platform':None,'artifact_sha256':'c'*64}),lambda: data['devices'][0]['results'].pop(),lambda: data.update(source_revision='d'*40),lambda: data['devices'][0].update(artifact_sha256='d'*64),lambda: data['devices'][0]['results'][0].update(evidence='missing.txt')):
                data=json.loads(json.dumps(original)); mutate(); self.assertNotEqual(verify().returncode,0)
            data=original; report.write_text(json.dumps(data)); env['CI']='true'
            result=self.invoke('tool/verify_device_certification.dart',str(report),'a'*40,'0.12.0+16','b'*64,'c'*64,env=env)
            self.assertNotEqual(result.returncode,0)
if __name__=='__main__': unittest.main()
