import hashlib
import importlib.util
import io
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


if __name__ == '__main__':
    unittest.main()
