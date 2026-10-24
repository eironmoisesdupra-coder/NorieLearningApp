import hashlib
import io
import json
from pathlib import Path
import struct
import tempfile
import unittest
from unittest.mock import patch
from urllib.error import HTTPError
import zipfile

from scripts.anatomy import legacy_models as recovery


def sha(value):
    return hashlib.sha256(value).hexdigest()


def asar(entries):
    files = {}
    data = b''
    for path, content in entries.items():
        parent = files
        segments = path.split('/')
        for part in segments[:-1]:
            parent = parent.setdefault(part, {'files': {}})['files']
        parent[segments[-1]] = {'size': len(content), 'offset': str(len(data))}
        data += content
    header = json.dumps({'files': files}).encode()
    padding = b'\0' * ((4 - len(header) % 4) % 4)
    size = len(header) + len(padding) + 8
    return struct.pack('<4I', 4, size, size - 4, len(header)) + header + padding + data


class RecoveryTests(unittest.TestCase):
    def archive(self, root, entries):
        archive = root / 'release.zip'
        with zipfile.ZipFile(archive, 'w') as package:
            package.writestr('NorieLearning-win32-x64/resources/app.asar', asar(entries))
        return archive

    def test_exact_published_bytes_recovered_without_extracting_executable(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            body = b'glTF synthetic fixture bytes'
            archive = self.archive(root, {'web/assets/assets/anatomy/test.glb': body,
                'main.cjs': b'throw new Error("must never execute")'})
            out = root / 'assets'
            recovery.restore_release_archive(archive, out,
                expected_sha=sha(archive.read_bytes()), models={'test.glb': sha(body)})
            self.assertEqual((out / 'test.glb').read_bytes(), body)
            self.assertEqual(sorted(p.name for p in out.iterdir()), ['test.glb'])

    def test_bad_archive_hash_preserves_existing_asset(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            archive = self.archive(root, {'web/assets/assets/anatomy/test.glb': b'bad'})
            out = root / 'assets'; out.mkdir(); (out / 'test.glb').write_bytes(b'keep')
            with self.assertRaises(ValueError):
                recovery.restore_release_archive(archive, out,
                    expected_sha='0' * 64, models={'test.glb': sha(b'bad')})
            self.assertEqual((out / 'test.glb').read_bytes(), b'keep')

    def test_wrong_model_or_missing_part_preserves_all_old_assets(self):
        for entries in [{'web/assets/assets/anatomy/a.glb': b'wrong'},
                {'web/assets/assets/anatomy/a.glb': b'new-a'}]:
            with self.subTest(entries=entries), tempfile.TemporaryDirectory() as d:
                root = Path(d); archive = self.archive(root, entries)
                out = root / 'assets'; out.mkdir()
                (out / 'a.glb').write_bytes(b'old-a'); (out / 'b.glb').write_bytes(b'old-b')
                with self.assertRaises(ValueError):
                    recovery.restore_release_archive(archive, out,
                        expected_sha=sha(archive.read_bytes()), models={'a.glb': sha(b'new-a'), 'b.glb': sha(b'new-b')})
                self.assertEqual((out / 'a.glb').read_bytes(), b'old-a')
                self.assertEqual((out / 'b.glb').read_bytes(), b'old-b')

    def test_asar_bounds_and_links_fail_closed(self):
        for record in [{'size': 50, 'offset': '9999'}, {'size': -1, 'offset': '0'},
                {'size': 1, 'offset': '-1'}, {'link': '/etc/passwd'}, {'unpacked': True, 'size':1, 'offset':'0'}]:
            with self.subTest(record=record), tempfile.TemporaryDirectory() as d:
                root = Path(d)
                header = json.dumps({'files': {'web': {'files': {'assets': {'files': {'assets': {'files': {'anatomy': {'files': {'x.glb': record}}}}}}}}}}).encode()
                data = struct.pack('<4I', 4, len(header)+8, len(header)+4, len(header)) + header + b'x'
                asset = root / 'app.asar'; asset.write_bytes(data)
                with asset.open('rb') as stream, self.assertRaises(ValueError):
                    recovery.read_asar_asset(stream, 'web/assets/assets/anatomy/x.glb')

    def test_failed_download_closes_windows_handle_before_removing_temp(self):
        original_factory = tempfile.NamedTemporaryFile
        original_unlink = Path.unlink
        opened = set()
        class TrackedTemporary:
            def __init__(self, *args, **kwargs):
                self.file = original_factory(*args, **kwargs)
            def __enter__(self):
                opened.add(Path(self.file.name))
                return self.file
            def __exit__(self, *args):
                self.file.__exit__(*args)
                opened.remove(Path(self.file.name))
        def windows_unlink(path, *args, **kwargs):
            if path in opened:
                raise PermissionError('Windows forbids deleting open files')
            return original_unlink(path, *args, **kwargs)
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            with patch.object(recovery.tempfile, 'NamedTemporaryFile', TrackedTemporary), \
                    patch.object(Path, 'unlink', windows_unlink), \
                    patch.object(recovery, 'urlopen', side_effect=HTTPError('https://fixture.test', 404, 'gone', None, None)):
                with self.assertRaises(HTTPError):
                    recovery.download_verified('https://fixture.test', root/'model', '0'*64)
            self.assertEqual(list(root.iterdir()), [])

    def test_unexpected_zip_path_or_ambiguous_member_is_not_extracted(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); archive=root/'release.zip'
            with zipfile.ZipFile(archive,'w') as package:
                package.writestr('../../app.asar', b'bad')
            with self.assertRaises(ValueError):
                recovery.restore_release_archive(archive, root/'out', expected_sha=sha(archive.read_bytes()), models={'a.glb':'0'*64})
            self.assertFalse((root/'out').exists())

if __name__ == '__main__':
    unittest.main()
