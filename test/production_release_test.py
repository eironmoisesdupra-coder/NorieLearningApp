import importlib.util
import json
from pathlib import Path
import tempfile
import zipfile
import stat
import unittest
from unittest.mock import patch

path = Path(__file__).resolve().parents[1] / 'scripts/release/production_release.py'
spec = importlib.util.spec_from_file_location('production_release', path)
m = importlib.util.module_from_spec(spec)
if path.exists(): spec.loader.exec_module(m)

class ProductionReleaseTest(unittest.TestCase):
    def test_missing_credentials_and_untrusted_execution_fail_closed(self):
        self.assertTrue(hasattr(m, 'validate_environment'), 'production credential gate is missing')
        for env in ({}, {'GITHUB_ACTIONS':'true','GITHUB_EVENT_NAME':'pull_request','GITHUB_REF':'refs/heads/develop'}, {'GITHUB_ACTIONS':'true','GITHUB_EVENT_NAME':'workflow_dispatch','GITHUB_REF':'refs/heads/develop','NORIE_PROTECTED_ENVIRONMENT':'production'}):
            with self.assertRaises(ValueError): m.validate_environment('android', env)

    def test_temporary_secret_is_removed_even_when_signing_fails(self):
        self.assertTrue(hasattr(m, 'secret_file'), 'temporary credential cleanup is missing')
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory)/'key'
            with self.assertRaises(RuntimeError):
                with m.secret_file('YWJj', target):
                    self.assertEqual(target.read_bytes(), b'abc')
                    raise RuntimeError('signing failed')
            self.assertFalse(target.exists())

    def test_secret_does_not_overwrite_existing_file_or_leave_invalid_base64(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory)/'key'; target.write_bytes(b'existing')
            with self.assertRaises(FileExistsError):
                with m.secret_file('YWJj',target): pass
            self.assertEqual(target.read_bytes(),b'existing')
            target.unlink()
            with self.assertRaises(ValueError):
                with m.secret_file('not base64!',target): pass
            self.assertFalse(target.exists())

    def test_windows_archive_rejects_traversal_and_symlinks(self):
        self.assertTrue(hasattr(m,'extract_windows_archive'),'safe Windows extraction helper missing')
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); archive=root/'app.zip'; out=root/'output'; out.mkdir()
            for name, mode in [('../escaped.exe',0),('NorieLearning/link.exe',stat.S_IFLNK | 0o777)]:
                with zipfile.ZipFile(archive,'w') as stream:
                    entry=zipfile.ZipInfo(name); entry.external_attr=mode<<16
                    stream.writestr(entry,b'payload')
                with self.assertRaises(ValueError): m.extract_windows_archive(archive,out)
            self.assertFalse((root/'escaped.exe').exists())
            with zipfile.ZipFile(archive,'w') as stream: stream.writestr('NorieLearning/app.exe',b'bytes')
            m.extract_windows_archive(archive,out)
            self.assertEqual((out/'NorieLearning/app.exe').read_bytes(),b'bytes')

    def test_signer_requires_exact_pinned_fingerprint(self):
        self.assertTrue(hasattr(m, 'check_fingerprint'), 'pinned signer check is missing')
        m.check_fingerprint('AA:'*31+'AA', 'a'*64)
        for value in ('', 'b'*64, 'a'*40):
            with self.assertRaises(ValueError): m.check_fingerprint(value, 'a'*64)

    def test_production_binding_rejects_preview_source_version_and_bytes(self):
        self.assertTrue(hasattr(m, 'validate_binding'), 'production source binding is missing')
        with tempfile.TemporaryDirectory() as directory:
            file = Path(directory)/'app.apk'; file.write_bytes(b'abc')
            binding = dict(revision='a'*40, version='0.12.0+16', channel='production-candidate', assets=[dict(name='app.apk',sha256='ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad')])
            m.validate_binding(binding, file, 'a'*40, '0.12.0+16')
            for key, value in [('revision','b'*40),('version','0.11.0+15'),('channel','preview')]:
                with self.assertRaises(ValueError): m.validate_binding({**binding,key:value},file,'a'*40,'0.12.0+16')
            file.write_bytes(b'changed')
            with self.assertRaises(ValueError): m.validate_binding(binding,file,'a'*40,'0.12.0+16')

    def test_actual_apk_verifier_output_requires_one_pinned_signer(self):
        self.assertTrue(hasattr(m, 'verify_android'))
        with patch.object(m, 'run', return_value='Signer #1 certificate SHA-256 digest: ' + 'a'*64) as command:
            m.verify_android(Path('app.apk'), 'a'*64)
            self.assertEqual(command.call_args.args[0][:3], ['apksigner', 'verify', '--verbose'])
        for output in ('unsigned', 'Signer #1 certificate SHA-256 digest: '+'b'*64, 'Signer #1 certificate SHA-256 digest: '+'a'*64+'\nSigner #2 certificate SHA-256 digest: '+'a'*64):
            with patch.object(m, 'run', return_value=output), self.assertRaises(ValueError):
                m.verify_android(Path('app.apk'), 'a'*64)

    def test_windows_rejects_invalid_signature_missing_timestamp_and_wrong_pin(self):
        self.assertTrue(hasattr(m, 'verify_windows'))
        valid = dict(status='Valid',timestamp_valid=True,sha256='a'*64)
        with patch.object(m, 'run', return_value=json.dumps(valid)):
            m.verify_windows(Path('app.exe'),'a'*64)
        for change in (dict(status='NotSigned'),dict(timestamp_valid=False),dict(sha256='b'*64)):
            with patch.object(m, 'run', return_value=json.dumps({**valid,**change})), self.assertRaises(ValueError):
                m.verify_windows(Path('app.exe'),'a'*64)

if __name__ == '__main__': unittest.main()
