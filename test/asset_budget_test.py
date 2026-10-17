"""Behavior tests for the release asset/artifact audit (stdlib only)."""
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts/release/asset_budget.py'
CONFIG = SCRIPT.with_name('package-budgets.json')


class AssetBudgetTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.write('pubspec.yaml', b'flutter:\n  assets:\n    - assets/anatomy/\n    - assets/audio/\n  fonts:\n    - family: Example\n      fonts:\n        - asset: assets/fonts/font.ttf\n')
        self.write('assets/fonts/font.ttf', b'font')
        self.write('assets/anatomy/model.glb', b'model')
        self.write('assets/audio/music.mp3', b'music')
        self.budgets = {'schema': 1, 'limits_bytes': {'android': 10, 'windows': 20, 'single_asset': 10}, 'baseline': {}}
        self.config = self.root / 'budgets.json'
        self.config.write_text(json.dumps(self.budgets))

    def write(self, name, data):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        return path

    def run_audit(self, *args):
        result = subprocess.run([sys.executable, str(SCRIPT), '--root', str(self.root), '--budgets', str(self.config), '--json-output', str(self.root / 'report.json'), *args], capture_output=True, text=True)
        report = json.loads((self.root / 'report.json').read_text()) if (self.root / 'report.json').exists() else None
        return result, report

    def test_inventory_declared_roots_only_and_deterministic_duplicates(self):
        self.write('assets/anatomy/copy.glb', b'model')
        for name in ['anatomy_viewer/node_modules/big.js', 'build/web/app.js', 'assets/unused.dat', 'assets/anatomy/node_modules/dev.js', 'assets/anatomy/build/dev.dat', 'assets/anatomy/.gitkeep', 'assets/anatomy/.cache/dev.dat']:
            self.write(name, b'x' * 100)
        result, report = self.run_audit()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['source_assets']['total_bytes'], 19)
        self.assertEqual(report['source_assets']['file_count'], 4)
        self.assertEqual(report['duplicate_candidates'][0]['paths'], ['assets/anatomy/copy.glb', 'assets/anatomy/model.glb'])
        self.assertEqual(report['duplicate_candidates'][0]['potential_saved_bytes'], 5)
        self.assertEqual(report['packages']['android']['status'], 'not_measured')
        first = (self.root / 'report.json').read_bytes()
        self.run_audit()
        self.assertEqual(first, (self.root / 'report.json').read_bytes())

    def test_symlinks_never_count_or_escape(self):
        outside = self.write('outside.dat', b'secret' * 100)
        try:
            (self.root / 'assets/anatomy/link.glb').symlink_to(outside)
            (self.root / 'assets/audio/linked').symlink_to(self.root / 'assets/anatomy', target_is_directory=True)
        except OSError:
            self.skipTest('OS does not permit symlink creation')
        result, report = self.run_audit()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['source_assets']['total_bytes'], 14)
        self.assertEqual(len(report['source_assets']['excluded_symlinks']), 2)

    def test_artifact_exact_bytes_hash_portable_paths_and_boundary(self):
        path = self.write('private/device/build.apk', b'1234567890')
        result, report = self.run_audit('--android', str(path), '--fail-on-growth')
        self.assertEqual(result.returncode, 0, result.stderr)
        artifact = report['packages']['android']
        self.assertEqual(artifact['bytes'], 10)
        self.assertEqual(artifact['sha256'], hashlib.sha256(b'1234567890').hexdigest())
        self.assertEqual(artifact['path'], 'build.apk')
        self.assertNotIn(str(self.root), json.dumps(report))
        self.assertEqual(report['violations'], [])

    def test_violations_visible_without_enforcement_and_enforced_on_request(self):
        apk = self.write('app.apk', b'x' * 11)
        self.write('assets/anatomy/large.glb', b'x' * 12)
        result, report = self.run_audit('--android', str(apk))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual({v['kind'] for v in report['violations']}, {'android', 'single_asset'})
        self.assertIn('exceeds', result.stdout)
        result, _ = self.run_audit('--android', str(apk), '--fail-on-growth')
        self.assertEqual(result.returncode, 1)

    def test_supplied_missing_empty_or_directory_artifact_is_error_even_soft_mode(self):
        empty = self.write('empty.apk', b'')
        for path in [self.root / 'missing.apk', empty, self.root / 'assets']:
            with self.subTest(path=path.name):
                result, report = self.run_audit('--android', str(path))
                self.assertEqual(result.returncode, 2)
                self.assertEqual(report['packages']['android']['status'], 'error')
                self.assertTrue(report['errors'])
                self.assertNotIn(str(self.root), json.dumps(report))

    def test_missing_declared_asset_is_error(self):
        (self.root / 'assets/fonts/font.ttf').unlink()
        result, report = self.run_audit()
        self.assertEqual(result.returncode, 2)
        self.assertIn('assets/fonts/font.ttf', ' '.join(report['errors']))

    def test_windows_and_single_asset_boundaries_use_exact_bytes(self):
        zip_path = self.write('portable.zip', b'x' * 20)
        self.write('assets/anatomy/boundary.glb', b'x' * 10)
        result, report = self.run_audit('--windows', str(zip_path), '--fail-on-growth')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['packages']['windows']['bytes'], 20)
        self.assertEqual(report['violations'], [])
        zip_path.write_bytes(b'x' * 21)
        result, report = self.run_audit('--windows', str(zip_path), '--fail-on-growth')
        self.assertEqual(result.returncode, 1)
        self.assertEqual(report['violations'][0]['kind'], 'windows')

    @unittest.skipUnless(sys.platform == 'win32', 'Windows junction handling')
    def test_windows_junction_is_excluded(self):
        junction = self.root / 'assets/anatomy/junction'
        result = subprocess.run(['cmd', '/c', 'mklink', '/J', str(junction), str(self.root / 'assets/fonts')], capture_output=True, text=True)
        if result.returncode:
            self.skipTest('OS does not permit junction creation')
        # rmdir removes the junction itself, never its target.
        self.addCleanup(lambda: junction.rmdir() if junction.exists() else None)
        result, report = self.run_audit()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['source_assets']['total_bytes'], 14)
        self.assertIn('assets/anatomy/junction', report['source_assets']['excluded_symlinks'])

    def test_report_never_overwrites_any_input_file_or_alias(self):
        artifact = self.write('release.apk', b'actual package')
        original_config = self.config.read_bytes()
        for source in [artifact, self.config, self.root / 'pubspec.yaml', self.root / 'assets/anatomy/model.glb']:
            with self.subTest(source=source.name):
                original = source.read_bytes()
                result, _ = self.run_audit('--android', str(artifact), '--json-output', str(source))
                self.assertEqual(result.returncode, 2, result.stdout)
                self.assertEqual(source.read_bytes(), original)
                alias = self.root / ('alias-' + source.name)
                alias.hardlink_to(source)
                result, _ = self.run_audit('--android', str(artifact), '--json-output', str(alias))
                self.assertEqual(result.returncode, 2, result.stdout)
                self.assertEqual(source.read_bytes(), original)
                alias.unlink()
        self.assertEqual(self.config.read_bytes(), original_config)

    def test_unsupported_flow_font_declarations_fail_closed(self):
        self.write('pubspec.yaml', b'flutter:\n  assets:\n    - assets/anatomy/\n  fonts:\n    - family: Example\n      fonts:\n        - {asset: assets/fonts/font.ttf}\n')
        result, report = self.run_audit()
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertTrue(report['errors'])

    def test_unreadable_source_directory_is_an_error_not_an_empty_inventory(self):
        spec = importlib.util.spec_from_file_location('asset_budget_test_subject', SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        actual_scandir = module.os.scandir
        forbidden = self.root / 'assets/anatomy'
        def scandir(path):
            if Path(path) == forbidden:
                raise PermissionError('private path must not appear in reports')
            return actual_scandir(path)
        errors = []
        with patch.object(module.os, 'scandir', side_effect=scandir):
            module.inventory(self.root, errors)
        self.assertTrue(errors)
        self.assertIn('assets/anatomy', ' '.join(errors))
        self.assertNotIn('private path', ' '.join(errors))
        self.assertNotIn(str(self.root), ' '.join(errors))

    def test_invalid_budget_cannot_disable_checks(self):
        for invalid in [0, -1, True, '10', 1.5]:
            with self.subTest(invalid=invalid):
                self.budgets['limits_bytes']['android'] = invalid
                self.config.write_text(json.dumps(self.budgets))
                result, _ = self.run_audit()
                self.assertEqual(result.returncode, 2)

    def test_reviewed_budget_baseline(self):
        config = json.loads(CONFIG.read_text())
        self.assertEqual(config['limits_bytes'], {'android': 240 * 1024**2, 'windows': 330 * 1024**2, 'single_asset': 80 * 1024**2})
        self.assertEqual(config['baseline']['source_sha'], '6364ff7c043a465653e13cc8108a4be08ee3b312')
        self.assertEqual(config['baseline']['packages']['android']['bytes'], 229384836)
        self.assertEqual(config['baseline']['packages']['windows']['bytes'], 315112049)


if __name__ == '__main__':
    unittest.main()
