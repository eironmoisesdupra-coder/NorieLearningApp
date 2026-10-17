"""Signing orchestration tests with a simulated signer, not certificate evidence."""
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest
from unittest.mock import patch
import zipfile

RELEASE = Path(__file__).resolve().parents[1] / 'scripts/release'
sys.path.insert(0, str(RELEASE))
spec = importlib.util.spec_from_file_location('sign_candidate', RELEASE / 'sign_candidate.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
from production_aab import write_provenance


class AabSigningTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.source = self.root / 'tested.aab'
        with zipfile.ZipFile(self.source, 'w') as archive:
            archive.writestr('BundleConfig.pb', b'config')
            archive.writestr('base/manifest/AndroidManifest.xml', b'manifest')
            archive.writestr('base/assets/lesson', b'offline lesson')
            archive.writestr('META-INF/DEBUG.SF', b'old signature')
        self.metadata = self.root / 'tested.json'
        write_provenance(self.source, self.metadata, 'a'*40, '0.13.0+17')
        self.target = self.root / 'signed.aab'

    def sign(self):
        return m.sign_android_bundle(self.source, self.metadata, self.target,
            'a'*40, '0.13.0+17', self.root / 'key', 'upload', 'b'*64)

    def fake_signer(self, arguments):
        self.assertIn('-storepass:env', arguments)
        self.assertIn('NORIE_ANDROID_KEYSTORE_PASSWORD', arguments)
        self.assertIn('-keypass:env', arguments)
        self.assertNotIn('actual password', arguments)
        unsigned = Path(arguments[-2])
        with zipfile.ZipFile(unsigned) as archive:
            self.assertNotIn('META-INF/DEBUG.SF', archive.namelist())
        shutil.copyfile(unsigned, self.target)
        return ''

    def test_validates_tested_binding_and_preserves_payload_before_accepting_signer(self):
        self.assertTrue(hasattr(m, 'sign_android_bundle'), 'AAB signing orchestrator missing')
        original = self.source.read_bytes()
        with patch.object(m, 'run', side_effect=self.fake_signer), \
             patch.object(m, 'verify_aab') as verify:
            self.assertEqual(self.sign(), 'b'*64)
            verify.assert_called_once_with(self.target, 'b'*64)
        self.assertEqual(self.source.read_bytes(), original)

    def test_bad_tested_binding_rejects_before_external_signer(self):
        self.assertTrue(hasattr(m, 'sign_android_bundle'), 'AAB signing orchestrator missing')
        data = json.loads(self.metadata.read_text(encoding='utf8'))
        data['revision'] = 'c'*40
        self.metadata.write_text(json.dumps(data), encoding='utf8')
        with patch.object(m, 'run') as run, self.assertRaises(ValueError):
            self.sign()
        run.assert_not_called()

    def test_changed_payload_and_wrong_certificate_are_rejected(self):
        self.assertTrue(hasattr(m, 'sign_android_bundle'), 'AAB signing orchestrator missing')
        def changed(arguments):
            self.fake_signer(arguments)
            with zipfile.ZipFile(self.target, 'a') as archive:
                archive.writestr('base/assets/injected', b'bad')
            return ''
        with patch.object(m, 'run', side_effect=changed), patch.object(m, 'verify_aab'), self.assertRaises(ValueError):
            self.sign()
        self.assertFalse(self.target.exists(), 'Rejected candidate must be cleaned up')
        with patch.object(m, 'run', side_effect=self.fake_signer), \
             patch.object(m, 'verify_aab', side_effect=ValueError('wrong pin')), self.assertRaises(ValueError):
            self.sign()

if __name__ == '__main__': unittest.main()
