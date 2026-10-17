"""Real CLI regression tests; fixtures are synthetic, never certification."""
import copy
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
DART = os.environ.get("DART") or shutil.which("dart")
GATES = ["production_android_signing", "production_windows_signing", "physical_device_matrix", "preview_to_production_migration", "classroom_real_wifi", "privacy_policy_published", "account_deletion_flow", "content_rating_completed", "store_graphics_ready", "support_contact_ready", "package_size_reviewed", "accessibility_regression", "data_safety_privacy_declarations"]

class StoreReadinessTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not DART:
            raise RuntimeError("Set DART to a standalone Dart SDK executable")
        # Compile once; each assertion still executes the real standalone CLI.
        cls.compiled = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.compiled.cleanup)
        cls.snapshot = str(Path(cls.compiled.name) / "store_readiness.dill")
        result = subprocess.run([str(DART), "compile", "kernel", "tool/store_readiness.dart", "-o", cls.snapshot], cwd=ROOT, capture_output=True, text=True)
        if result.returncode:
            raise RuntimeError(result.stdout + result.stderr)

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.manifest = self.directory / "readiness.json"
        self.data = dict(format="norie-store-readiness", version=1, source_revision="", app_version="", artifact_sha256=dict(android="", windows=""), gates=[dict(id=i, required=True, status="not_tested", evidence=None, review=None) for i in GATES])

    def invoke(self, *args, raw=None):
        self.manifest.write_text(json.dumps(self.data) if raw is None else raw, encoding="utf-8")
        return subprocess.run([str(DART), self.snapshot, str(self.manifest), *args], cwd=ROOT, capture_output=True, text=True)

    def passing(self):
        self.data.update(source_revision="a" * 40, app_version="0.13.0+17", artifact_sha256=dict(android="b"*64, windows="c"*64))
        for gate in self.data["gates"]:
            path = gate["id"] + ".txt"
            text = "Synthetic CLI evidence fixture for " + gate["id"] + "\nAndroid SHA256: " + "b"*64 + "\nWindows SHA256: " + "c"*64
            (self.directory / path).write_text(text, encoding="utf-8", newline="")
            gate.update(status="pass", evidence=path, review=dict(origin="human", reviewer="Synthetic test operator", reviewed_at="2026-01-01T01:00:00Z", decision="pass", gate_id=gate["id"], source_revision=self.data["source_revision"], app_version=self.data["app_version"], artifact_sha256=copy.deepcopy(self.data["artifact_sha256"]), evidence_path=path, evidence_text=text))

    def test_pending_manifest_schema_reports_blockers_but_strict_rejects(self):
        report = self.directory / "report.json"
        result = self.invoke("--check-schema", "--json-report", str(report))
        self.assertEqual(result.returncode, 0, result.stderr)
        value = json.loads(report.read_text())
        self.assertTrue(value["schema_valid"])
        self.assertFalse(value["ready"])
        self.assertEqual(value["blockers"], GATES)
        self.assertEqual(self.invoke().returncode, 1)
        self.assertEqual(self.invoke("--require-ready").returncode, 1)

    def test_invalid_json_and_root_always_reject_with_report(self):
        for raw in ("{", "[]", "null", "1", '{}'):
            with self.subTest(raw=raw):
                report = self.directory / "report.json"
                result = self.invoke("--check-schema", "--json-report", str(report), raw=raw)
                self.assertEqual(result.returncode, 2, result.stderr)
                self.assertFalse(json.loads(report.read_text())["schema_valid"])

    def test_exact_gate_schema_cannot_be_bypassed(self):
        original = copy.deepcopy(self.data)
        changes = [lambda d: d["gates"].pop(), lambda d: d["gates"].append(copy.deepcopy(d["gates"][0])), lambda d: d["gates"][0].update(id="unknown"), lambda d: d["gates"][0].update(required=False), lambda d: d["gates"][0].update(required="true"), lambda d: d["gates"][0].update(status="approved"), lambda d: d["gates"][0].pop("status"), lambda d: d["gates"][0].update(typo="ignored"), lambda d: d.update(version=True), lambda d: d.update(typo="ignored")]
        for change in changes:
            self.data = copy.deepcopy(original)
            change(self.data)
            with self.subTest(data=self.data):
                self.assertEqual(self.invoke("--check-schema").returncode, 2)

    def test_pass_requires_actual_evidence_and_human_review(self):
        self.data["gates"][0].update(status="pass")
        self.assertEqual(self.invoke("--check-schema").returncode, 2)
        self.passing()
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        original = copy.deepcopy(self.data)
        changes = [lambda g: g.update(evidence="missing.txt"), lambda g: g.update(evidence="../outside.txt"), lambda g: g.update(review=None), lambda g: g["review"].update(origin="ci"), lambda g: g["review"].update(gate_id="other"), lambda g: g["review"].update(source_revision="b"*40), lambda g: g["review"].update(app_version="0.12.0+16"), lambda g: g["review"].update(artifact_sha256=dict(android="d"*64, windows="c"*64)), lambda g: g["review"].update(evidence_path="other.txt"), lambda g: g["review"].update(evidence_text="stale evidence"), lambda g: g["review"].update(reviewer=""), lambda g: g["review"].update(reviewed_at="2999-01-01T00:00:00Z"), lambda g: g["review"].update(reviewed_at="2026-01-01"), lambda g: g["review"].update(decision="pending")]
        for change in changes:
            self.data = copy.deepcopy(original)
            change(self.data["gates"][0])
            with self.subTest(gate=self.data["gates"][0]):
                self.assertEqual(self.invoke("--check-schema").returncode, 2)

    def test_evidence_is_bounded_nonempty_and_bound_to_reviewed_bytes(self):
        self.passing()
        path = self.directory / self.data["gates"][0]["evidence"]
        for content in ("", "   ", "x" * (65536 + 1), "Modified evidence after review"):
            path.write_text(content, encoding="utf-8")
            self.assertEqual(self.invoke("--check-schema").returncode, 2)

    def test_failed_and_blocked_statuses_are_valid_but_not_ready(self):
        for status in ("fail", "blocked"):
            self.data["gates"][0]["status"] = status
            self.assertEqual(self.invoke("--check-schema").returncode, 0)
            self.assertEqual(self.invoke().returncode, 1)

    def test_json_report_requires_a_path_not_an_option(self):
        self.manifest.write_text(json.dumps(self.data), encoding="utf-8")
        result = subprocess.run([str(DART), self.snapshot, str(self.manifest), "--check-schema", "--json-report", "--require-ready"], cwd=self.directory, capture_output=True, text=True)
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertFalse((self.directory / "--require-ready").exists())

    def test_report_cannot_overwrite_input_and_usage_errors_reject(self):
        for args in (("--check-schema", "--require-ready"), ("--unknown",), ("--json-report",), ("--json-report", str(self.manifest))):
            result = self.invoke(*args)
            self.assertEqual(result.returncode, 2, result.stdout)
            self.assertEqual(json.loads(self.manifest.read_text()), self.data)

    def test_pass_requires_build_and_signed_artifact_bindings(self):
        self.passing()
        original = copy.deepcopy(self.data)
        changes = [dict(source_revision=""), dict(source_revision="not-a-sha"), dict(app_version=""), dict(app_version="0.13.0"), dict(artifact_sha256=dict(android="", windows="c"*64)), dict(artifact_sha256=dict(android="b"*64, windows="bad"))]
        for change in changes:
            self.data = copy.deepcopy(original)
            self.data.update(change)
            self.assertEqual(self.invoke("--check-schema").returncode, 2)

    def test_evidence_snapshot_preserves_actual_line_endings(self):
        self.passing()
        gate = self.data["gates"][0]
        text = gate["review"]["evidence_text"].replace("\n", "\r\n")
        (self.directory / gate["evidence"]).write_bytes(text.encode("utf-8"))
        gate["review"]["evidence_text"] = text
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stdout)
        gate["review"]["evidence_text"] = text.replace("\r\n", "\n")
        self.assertEqual(self.invoke().returncode, 2)

    def test_report_preserves_evidence_even_when_manifest_validation_fails(self):
        for invalid in (False, True):
            self.passing()
            evidence = self.directory / self.data["gates"][0]["evidence"]
            original = evidence.read_bytes()
            if invalid:
                self.data["gates"][0]["status"] = "invalid"
            result = self.invoke("--json-report", str(evidence))
            self.assertEqual(result.returncode, 2, result.stdout)
            self.assertEqual(evidence.read_bytes(), original)
            self.assertFalse(json.loads(result.stdout)["ready"])

    def test_report_preserves_hardlinked_evidence_and_manifest(self):
        self.passing()
        evidence = self.directory / self.data["gates"][0]["evidence"]
        original = evidence.read_bytes()
        alias = self.directory / "evidence-hardlink.json"
        os.link(evidence, alias)
        result = self.invoke("--json-report", str(alias))
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertEqual(evidence.read_bytes(), original)
        self.invoke("--check-schema")
        manifest_original = self.manifest.read_bytes()
        manifest_alias = self.directory / "manifest-hardlink.json"
        os.link(self.manifest, manifest_alias)
        result = self.invoke("--json-report", str(manifest_alias))
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertEqual(self.manifest.read_bytes(), manifest_original)

    def test_report_preserves_symlinked_evidence(self):
        self.passing()
        evidence = self.directory / self.data["gates"][0]["evidence"]
        original = evidence.read_bytes()
        alias = self.directory / "evidence-link.json"
        try:
            alias.symlink_to(evidence)
        except OSError:
            self.skipTest("OS does not permit symlink creation")
        result = self.invoke("--json-report", str(alias))
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertEqual(evidence.read_bytes(), original)

    def test_report_preserves_review_references_in_invalid_schema(self):
        self.passing()
        review_path = self.directory / "review-only.txt"
        review_path.write_bytes(b"review evidence must survive")
        self.data["gates"][0]["review"]["evidence_path"] = review_path.name
        result = self.invoke("--json-report", str(review_path))
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertEqual(review_path.read_bytes(), b"review evidence must survive")

    def test_report_preserves_normalized_manifest_alias(self):
        (self.directory / "subdirectory").mkdir()
        alias = self.directory / "subdirectory" / ".." / self.manifest.name
        result = self.invoke("--json-report", str(alias))
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertEqual(json.loads(self.manifest.read_text()), self.data)
        if os.name == "nt":
            result = self.invoke("--json-report", str(self.manifest).swapcase())
            self.assertEqual(result.returncode, 2, result.stdout)
            self.assertEqual(json.loads(self.manifest.read_text()), self.data)

    def test_checked_in_manifest_is_pending_and_not_certification(self):
        data = json.loads((ROOT / "store/readiness.json").read_text())
        self.assertEqual({g["id"] for g in data["gates"]}, set(GATES))
        self.assertTrue(all(g["status"] == "not_tested" for g in data["gates"]))
        self.data = data
        self.assertEqual(self.invoke("--check-schema").returncode, 0)
        self.assertEqual(self.invoke().returncode, 1)

if __name__ == "__main__":
    unittest.main()
