import hashlib
import importlib.util
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


SPEC = importlib.util.spec_from_file_location(
    'music_assets', Path(__file__).resolve().parents[1] / 'scripts/fetch_music_assets.py')
music = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(music)


class MusicAssetsTest(unittest.TestCase):
    def setUp(self):
        self.data = b'ID3licensed fixture'
        self.track = dict(file='song.mp3', bytes=len(self.data),
                          sha256=hashlib.sha256(self.data).hexdigest(),
                          download='https://opengameart.org/sites/default/files/song.mp3')

    def test_valid_cache_never_downloads(self):
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            (folder / 'song.mp3').write_bytes(self.data)
            with patch.object(music, 'urlopen') as download:
                music.fetch_track(self.track, folder)
                download.assert_not_called()

    def test_bad_cache_is_replaced_only_with_verified_download(self):
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            target = folder / 'song.mp3'
            target.write_bytes(b'bad cache')
            with patch.object(music, 'urlopen', return_value=io.BytesIO(b'bad response')):
                with self.assertRaises(ValueError):
                    music.fetch_track(self.track, folder)
            self.assertEqual(target.read_bytes(), b'bad cache')
            with patch.object(music, 'urlopen', return_value=io.BytesIO(self.data)):
                music.fetch_track(self.track, folder)
            self.assertEqual(target.read_bytes(), self.data)

    def test_original_tracks_require_exact_bundled_bytes_and_never_download(self):
        original = {key: value for key, value in self.track.items() if key != 'download'}
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            target = folder / 'song.mp3'
            with patch.object(music, 'urlopen') as download:
                with self.assertRaisesRegex(ValueError, 'Bundled music'):
                    music.fetch_track(original, folder, bundled=True)
                target.write_bytes(b'changed recording')
                with self.assertRaisesRegex(ValueError, 'checksum mismatch'):
                    music.fetch_track(original, folder, bundled=True)
                self.assertEqual(target.read_bytes(), b'changed recording')
                target.write_bytes(self.data)
                music.fetch_track(original, folder, bundled=True)
                download.assert_not_called()

    def test_rejects_unsafe_paths_urls_and_hashes_before_downloading(self):
        with tempfile.TemporaryDirectory() as directory:
            for changes in [dict(file='../song.mp3'), dict(file='C:/song.mp3'),
                            dict(file='folder\\song.mp3'), dict(sha256='bad'),
                            dict(download='http://opengameart.org/song.mp3'),
                            dict(download='https://example.org/song.mp3')]:
                with self.subTest(changes=changes), patch.object(music, 'urlopen') as download:
                    with self.assertRaises(ValueError):
                        music.fetch_track({**self.track, **changes}, Path(directory))
                    download.assert_not_called()

    def test_build_verifies_both_classic_and_adventure_manifests(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            audio = root / 'assets/audio'
            audio.mkdir(parents=True)
            classic = dict(license='CC0-1.0', tracks=[
                dict(file=f'classic_{index}.mp3') for index in range(5)])
            adventure = dict(origin='original-synthesis', license='CC0-1.0', tracks=[
                dict(file=f'adventure_{index}.mp3') for index in range(5)])
            (audio / 'music-classic-manifest.json').write_text(
                json.dumps(classic), encoding='utf-8')
            (audio / 'music-manifest.json').write_text(
                json.dumps(adventure), encoding='utf-8')
            checked = []

            def record(track, folder, *, bundled=False):
                checked.append((track['file'], bundled))

            with patch.object(music, 'ROOT', root), patch.object(
                    music, 'fetch_track', side_effect=record):
                music.main()

            self.assertEqual(len(checked), 10)
            self.assertEqual(checked[:5], [
                (f'classic_{index}.mp3', False) for index in range(5)])
            self.assertEqual(checked[5:], [
                (f'adventure_{index}.mp3', True) for index in range(5)])


if __name__ == '__main__':
    unittest.main()
