import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

SPEC = importlib.util.spec_from_file_location('release_tools', Path(__file__).resolve().parents[1] / 'scripts/release/prepare_release.py')
module = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(module)

class ReleaseToolsTest(unittest.TestCase):
    def test_rejects_untrusted_or_failed_runs_and_older_success(self):
        good = dict(id=1, run_number=1, run_attempt=1, event='push', head_branch='develop', head_sha='a'*40, conclusion='success', status='completed', head_repository={'full_name': 'owner/repo'})
        self.assertEqual(module.select_run([good], 'a'*40, 'owner/repo')['id'], 1)
        for field, value in [('event', 'pull_request'), ('head_sha', 'b'*40), ('head_branch', 'main'), ('conclusion', 'failure'), ('head_repository', {'full_name':'fork/repo'})]:
            with self.subTest(field=field), self.assertRaises(ValueError):
                module.select_run([{**good, field:value}], 'a'*40, 'owner/repo')
        with self.assertRaises(ValueError):
            module.select_run([good, {**good, 'id':2, 'run_number':2, 'conclusion':'failure'}], 'a'*40, 'owner/repo')

    def test_metadata_hashes_actual_bytes_and_rejects_missing_package(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'NorieLearning-Windows.zip').write_bytes(b'abc')
            (root/'NorieLearning-Android.apk').write_bytes(b'abc')
            data = module.metadata(root, '0.5.0+8', 'v0.5.0', 'a'*40)
            self.assertEqual(data['revision'], 'a'*40)
            self.assertEqual(data['assets'][0]['sha256'], 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad')
            self.assertEqual(data['assets'][0]['bytes'], 3)
            (root/'NorieLearning-Android.apk').unlink()
            with self.assertRaises(FileNotFoundError): module.metadata(root, '0.5.0+8', 'v0.5.0', 'a'*40)

    def test_version_and_revision_are_validated(self):
        for version, tag, revision in [('0.5.0+8','v0.4.0','a'*40), ('0.5.0+8','v0.5.0','short')]:
            with self.assertRaises(ValueError): module.metadata(Path('.'), version, tag, revision)

if __name__ == '__main__': unittest.main()
