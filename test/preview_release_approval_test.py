"""Exercise actual source/approval gates against an isolated Git repository."""
import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest


class PreviewApprovalTest(unittest.TestCase):
    def setUp(self):
        spec = importlib.util.spec_from_file_location(
            "preview_approval", Path(__file__).parents[1] / "scripts/release/preview_approval.py")
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.git("init", "-q", "-b", "develop")
        self.git("config", "user.name", "Test fixture")
        self.git("config", "user.email", "fixture@example.invalid")
        (self.root / "pubspec.yaml").write_text("version: 0.19.0+25\n")
        self.git("add", "pubspec.yaml")
        self.git("commit", "-qm", "fixture")
        self.sha = self.git("rev-parse", "HEAD")
        self.git("update-ref", "refs/remotes/origin/develop", self.sha)

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], text=True).strip()

    def authorize(self, **overrides):
        args = dict(root=self.root, revision=self.sha, tag="v0.19.0", approved="true",
                    event="workflow_dispatch", ref="refs/heads/develop")
        args.update(overrides)
        return self.module.authorize(**args)

    def test_exact_explicitly_approved_develop_source_is_accepted(self):
        self.assertEqual(self.authorize(), self.sha)

    def test_push_missing_approval_and_wrong_ref_are_denied(self):
        for change in ({"event": "push"}, {"approved": "false"},
                       {"approved": ""}, {"ref": "refs/heads/main"},
                       {"ref": "refs/tags/v0.19.0"}):
            with self.subTest(change=change), self.assertRaises(ValueError):
                self.authorize(**change)

    def test_abbreviated_unknown_or_different_source_is_denied(self):
        for revision in (self.sha[:7], "0" * 40, "HEAD", self.sha.upper()):
            with self.subTest(revision=revision), self.assertRaises(ValueError):
                self.authorize(revision=revision)

    def test_wrong_version_tag_is_denied(self):
        with self.assertRaises(ValueError):
            self.authorize(tag="v0.18.0")

    def test_commit_outside_verified_develop_is_denied(self):
        (self.root / "unmerged.txt").write_text("unmerged fixture")
        self.git("add", "unmerged.txt")
        self.git("commit", "-qm", "unmerged")
        with self.assertRaises(ValueError):
            self.authorize(revision=self.git("rev-parse", "HEAD"))

    def test_version_is_taken_from_the_pinned_commit_not_working_files(self):
        (self.root / "pubspec.yaml").write_text("version: 9.9.9+99\n")
        self.assertEqual(self.authorize(), self.sha)
        with self.assertRaises(ValueError):
            self.authorize(tag="v9.9.9")


if __name__ == "__main__":
    unittest.main()
