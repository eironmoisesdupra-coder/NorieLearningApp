"""Synthetic bundle structure/payload checks; never production signing evidence."""
import importlib.util
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
import warnings
import zipfile

SCRIPT = Path(__file__).resolve().parents[1] / "scripts/release/production_aab.py"
spec = importlib.util.spec_from_file_location("production_aab", SCRIPT)
m = importlib.util.module_from_spec(spec)
if SCRIPT.exists():
    spec.loader.exec_module(m)

REVISION = "a" * 40
VERSION = "0.13.0+17"
REQUIRED = {"BundleConfig.pb": b"synthetic config", "base/manifest/AndroidManifest.xml": b"synthetic protobuf manifest", "base/dex/classes.dex": b"synthetic dex"}

class ProductionAabTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.artifact = self.root / "preview.aab"
        self.metadata = self.root / "tested.json"
        self.bundle(self.artifact)

    def bundle(self, path, entries=None):
        with zipfile.ZipFile(path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
            for name, value in (REQUIRED if entries is None else entries).items():
                entry = zipfile.ZipInfo(name)
                # ZipInfo normalizes backslashes on Windows; preserve raw ZIP
                # names so unsafe-path tests exercise actual malicious bytes.
                entry.filename = name
                entry.orig_filename = name
                entry.compress_type = zipfile.ZIP_DEFLATED
                archive.writestr(entry, value)
        return path

    def provenance(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
        return json.loads(self.metadata.read_text())

    def test_exact_provenance_and_validated_metadata_file_or_mapping(self):
        data = self.provenance()
        self.assertEqual(data, dict(schema=1, format="norie-tested-aab", revision=REVISION, version=VERSION, bytes=self.artifact.stat().st_size, sha256=hashlib.sha256(self.artifact.read_bytes()).hexdigest()))
        m.validate_provenance(self.artifact, data, REVISION, VERSION)
        m.validate_provenance(self.artifact, self.metadata, REVISION, VERSION)

    def test_binding_schema_source_version_hash_and_size_reject(self):
        data = self.provenance()
        for change in (dict(schema=True), dict(format="preview"), dict(revision="b"*40), dict(version="0.12.0+16"), dict(sha256="b"*64), dict(bytes=0), dict(bytes=True), dict(bytes=data["bytes"]+1), dict(unexpected="ignored")):
            with self.subTest(change=change), self.assertRaises(ValueError):
                m.validate_provenance(self.artifact, {**data, **change}, REVISION, VERSION)
        for revision, version in (("short", VERSION), (REVISION, "0.13.0")):
            with self.assertRaises(ValueError):
                m.validate_provenance(self.artifact, data, revision, version)
        with self.assertRaises(ValueError):
            m.validate_provenance(self.artifact, {k:v for k,v in data.items() if k != "sha256"}, REVISION, VERSION)
        self.artifact.write_bytes(b"changed input")
        with self.assertRaises(ValueError):
            m.validate_provenance(self.artifact, data, REVISION, VERSION)

    def test_required_bundle_entries_and_unsafe_names_reject(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        bad_entries = [{"base/dex/classes.dex": b"no manifest"}, {**REQUIRED, "BundleConfig.pb": b""}]
        bad_entries += [{**REQUIRED, name: b"unsafe"} for name in ("../escape", "/absolute", "base/../escape", "C:/escape", "base\\escape", "base//escape", "./escape")]
        for entries in bad_entries:
            with self.subTest(entries=list(entries)):
                self.bundle(self.artifact, entries)
                with self.assertRaises(ValueError):
                    m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
                self.assertFalse(self.metadata.exists())

    def test_symlinks_duplicate_names_and_file_directory_conflicts_reject(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        for extra in ("symlink", "duplicate", "conflict"):
            self.bundle(self.artifact)
            with warnings.catch_warnings(), zipfile.ZipFile(self.artifact, "a") as archive:
                warnings.simplefilter("ignore", UserWarning)
                if extra == "symlink":
                    link = zipfile.ZipInfo("base/assets/link")
                    link.create_system = 3
                    link.external_attr = (stat.S_IFLNK | 0o777) << 16
                    archive.writestr(link, "../../outside")
                elif extra == "duplicate":
                    archive.writestr("BundleConfig.pb", b"duplicate")
                else:
                    archive.writestr("base/dex", b"conflicting file")
            with self.subTest(extra=extra), self.assertRaises(ValueError):
                m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
            self.assertFalse(self.metadata.exists())

    def test_corrupt_compressed_payload_is_rejected_without_output(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        with zipfile.ZipFile(self.artifact) as archive:
            entry = archive.getinfo("base/dex/classes.dex")
            offset = entry.header_offset + 30 + len(entry.filename.encode("utf-8")) + len(entry.extra)
        damaged = bytearray(self.artifact.read_bytes())
        damaged[offset:offset + entry.compress_size] = b"\xff" * entry.compress_size
        self.artifact.write_bytes(damaged)
        with self.assertRaises(ValueError):
            m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
        self.assertFalse(self.metadata.exists())

    def test_encrypted_or_non_android_compression_entries_reject(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        # Set the encryption flag in the central entry; no keys are generated.
        damaged = bytearray(self.artifact.read_bytes())
        central = damaged.index(b"PK\x01\x02")
        damaged[central + 8] |= 1
        self.artifact.write_bytes(damaged)
        with self.assertRaises(ValueError):
            m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
        self.bundle(self.artifact)
        with zipfile.ZipFile(self.artifact, "a") as archive:
            archive.writestr("base/assets/unsupported", b"fixture", compress_type=zipfile.ZIP_BZIP2)
        with self.assertRaises(ValueError):
            m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
        self.assertFalse(self.metadata.exists())

    def test_provenance_json_rejects_duplicate_keys_unknown_root_and_oversize(self):
        data = self.provenance()
        valid = json.dumps(data)
        for text in ("[]", "null", "{", valid.replace('"schema": 1', '"schema": 1, "schema": 1'), " " * 65537):
            self.metadata.write_text(text, encoding="utf-8")
            with self.subTest(text=text[:50]), self.assertRaises(ValueError):
                m.validate_provenance(self.artifact, self.metadata, REVISION, VERSION)

    def test_bundle_caps_accept_exact_boundaries(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        with patch.object(m, "MAX_ARCHIVE_BYTES", self.artifact.stat().st_size), patch.object(m, "MAX_ENTRIES", len(REQUIRED)), patch.object(m, "MAX_ENTRY_BYTES", max(map(len, REQUIRED.values()))), patch.object(m, "MAX_TOTAL_BYTES", sum(map(len, REQUIRED.values()))):
            data = self.provenance()
            m.validate_provenance(self.artifact, data, REVISION, VERSION)

    def test_archive_entry_count_and_decompressed_size_caps_fail_closed(self):
        self.assertTrue(hasattr(m, "write_provenance"), "AAB provenance helper missing")
        for constant, value in (("MAX_ARCHIVE_BYTES", 1), ("MAX_ENTRIES", 1), ("MAX_ENTRY_BYTES", 1), ("MAX_TOTAL_BYTES", 1)):
            with self.subTest(constant=constant), patch.object(m, constant, value), self.assertRaises(ValueError):
                m.write_provenance(self.artifact, self.metadata, REVISION, VERSION)
        self.assertFalse(self.metadata.exists())

    def test_strip_only_direct_jar_signatures_preserving_payload_and_notices(self):
        self.assertTrue(hasattr(m, "prepare_unsigned"), "AAB signature preparation helper missing")
        kept = {**REQUIRED, "META-INF/LICENSE": b"license", "META-INF/services/example": b"service", "META-INF/nested/KEEP.SF": b"nested data", "base/assets/MANIFEST.MF": b"asset", "META-INF/SIG-custom": b"retain unspecified metadata"}
        signatures = {"META-INF/MANIFEST.MF": b"old manifest", "META-INF/DEBUG.SF": b"debug sf", "META-INF/DEBUG.RSA": b"debug rsa", "META-INF/OTHER.DSA": b"old dsa", "META-INF/THIRD.EC": b"old ec", "meta-inf/LOWER.sf": b"case-insensitive signing metadata"}
        self.bundle(self.artifact, {**kept, **signatures})
        target = self.root / "unsigned.aab"
        source_bytes = self.artifact.read_bytes()
        m.prepare_unsigned(self.artifact, target)
        self.assertEqual(self.artifact.read_bytes(), source_bytes)
        with zipfile.ZipFile(target) as archive:
            self.assertEqual(set(archive.namelist()), set(kept))
            self.assertEqual({name: archive.read(name) for name in archive.namelist()}, kept)
        m.validate_same_payload(self.artifact, target)

    def test_signer_added_directory_headers_do_not_change_file_payload(self):
        self.assertTrue(hasattr(m, "validate_same_payload"), "AAB payload comparison helper missing")
        signed = self.bundle(self.root / "signed.aab", {**REQUIRED, "META-INF/": b"", "META-INF/RELEASE.SF": b"signature fixture"})
        m.validate_same_payload(self.artifact, signed)

    def test_payload_comparison_ignores_only_signatures_and_rejects_tampering(self):
        self.assertTrue(hasattr(m, "validate_same_payload"), "AAB payload comparison helper missing")
        signed = self.bundle(self.root / "signed.aab", {**REQUIRED, "META-INF/MANIFEST.MF": b"new manifest", "META-INF/RELEASE.SF": b"new sf", "META-INF/RELEASE.RSA": b"new signature"})
        m.validate_same_payload(self.artifact, signed)
        variants = [{**REQUIRED, "base/dex/classes.dex": b"X" * len(REQUIRED["base/dex/classes.dex"])}, {k:v for k,v in REQUIRED.items() if k != "base/dex/classes.dex"}, {**REQUIRED, "base/assets/injected": b"injection"}]
        for entries in variants:
            self.bundle(signed, entries)
            with self.assertRaises(ValueError):
                m.validate_same_payload(self.artifact, signed)

    def test_outputs_never_overwrite_existing_inputs_or_hardlinks(self):
        self.assertTrue(hasattr(m, "prepare_unsigned"), "AAB signature preparation helper missing")
        original = self.artifact.read_bytes()
        for target in (self.artifact, self.root / "hardlink.aab"):
            if target != self.artifact:
                os.link(self.artifact, target)
            with self.assertRaises((ValueError, FileExistsError)):
                m.prepare_unsigned(self.artifact, target)
            with self.assertRaises((ValueError, FileExistsError)):
                m.write_provenance(self.artifact, target, REVISION, VERSION)
            self.assertEqual(self.artifact.read_bytes(), original)

    def test_cli_provenance_and_invalid_bundle_failure(self):
        result = subprocess.run([sys.executable, str(SCRIPT), "provenance", str(self.artifact), "--revision", REVISION, "--version", VERSION, "--output", str(self.metadata)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.metadata.read_text())["format"], "norie-tested-aab")
        self.artifact.write_bytes(b"not a bundle")
        self.metadata.unlink()
        result = subprocess.run([sys.executable, str(SCRIPT), "provenance", str(self.artifact), "--revision", REVISION, "--version", VERSION, "--output", str(self.metadata)], capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.metadata.exists())

if __name__ == "__main__":
    unittest.main()
