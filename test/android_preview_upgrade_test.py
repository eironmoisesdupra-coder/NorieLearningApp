"""Exercise the compatibility CLI; Android SDK subprocesses are boundary fakes."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'scripts/release/android_preview_upgrade.py'
PREVIOUS = '4168b181761eb975fd329c2d21f0d8f19a8840067705e96888a405d23b1ce2b6'
DIFFERENT = '1a40723df64d4c1a5dd32ba90d49919df1be2dff1b503ed2f18f6c60e600c9a1'


class PreviewUpgradeTest(unittest.TestCase):
    def invoke(self, fingerprint=PREVIOUS, package='com.example.norie_learning', invalid=False, require=True):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)
            apk = path / 'fixture.apk'; apk.write_bytes(b'only a subprocess boundary fixture')
            signer = path / 'apksigner'
            signer.write_text('#!' + sys.executable + '\nimport sys\n'
                              + ('sys.exit(1)\n' if invalid else f'print("Signer #1 certificate SHA-256 digest: {fingerprint}")\n'))
            signer.chmod(0o755)
            aapt = path / 'aapt'
            aapt.write_text('#!' + sys.executable + f'\nprint("package: name=\'{package}\' versionCode=\'25\' versionName=\'0.19.0\'")\n')
            aapt.chmod(0o755)
            output = path / 'report.json'
            command = [sys.executable, str(SCRIPT), '--apk', str(apk), '--apksigner', str(signer), '--aapt', str(aapt), '--report', str(output)]
            if require: command.append('--require-compatible')
            result = subprocess.run(command, capture_output=True, text=True)
            return result, json.loads(output.read_text()) if output.exists() else None

    def test_matching_signer_and_package_can_pass_the_publication_gate(self):
        result, report = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(report['compatible'])
        self.assertEqual(report['version_code'], 25)

    def test_different_debug_key_blocks_publication(self):
        result, report = self.invoke(fingerprint=DIFFERENT)
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertFalse(report['compatible'])

    def test_package_change_is_not_a_progress_preserving_upgrade(self):
        result, report = self.invoke(package='com.example.another')
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertFalse(report['compatible'])

    def test_build_can_report_a_known_mismatch_without_publishing(self):
        result, report = self.invoke(fingerprint=DIFFERENT, require=False)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(report['compatible'])

    def test_failed_cryptographic_verification_never_produces_success(self):
        result, report = self.invoke(invalid=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(report)

    def test_malformed_signer_output_is_rejected(self):
        result, report = self.invoke(fingerprint='missing')
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(report)


if __name__ == '__main__':
    unittest.main()
