"""Fetch licensed build-time music assets; the packaged app plays them offline."""
import hashlib
import json
from pathlib import Path
import re
import tempfile
from urllib.parse import urlsplit
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parents[1]


def fetch_track(track, folder):
    name, digest, size = track['file'], track['sha256'], track['bytes']
    url = urlsplit(track['download'])
    if (not re.fullmatch(r'[a-z0-9_]+\.mp3', name)
            or not re.fullmatch(r'[a-f0-9]{64}', digest)
            or not isinstance(size, int) or isinstance(size, bool) or size <= 0
            or url.scheme != 'https' or url.netloc != 'opengameart.org'
            or not url.path.startswith('/sites/default/files/')
            or url.query or url.fragment):
        raise ValueError('Invalid music manifest entry')
    folder = folder.resolve()
    folder.mkdir(parents=True, exist_ok=True)
    target = folder / name
    if target.is_symlink() or target.resolve().parent != folder:
        raise ValueError('Unsafe music asset path')
    if (target.is_file() and target.stat().st_size == size
            and hashlib.sha256(target.read_bytes()).hexdigest() == digest):
        print(f'Verified cached {name}')
        return
    request = Request(track['download'], headers={'User-Agent': 'NorieLearning-build/1.0'})
    temporary = None
    try:
        with urlopen(request, timeout=120) as response:
            with tempfile.NamedTemporaryFile(dir=folder, suffix='.download', delete=False) as output:
                temporary = Path(output.name)
                received = 0
                checksum = hashlib.sha256()
                while chunk := response.read(1024 * 1024):
                    received += len(chunk)
                    if received > size:
                        raise ValueError(f'Music size mismatch: {name}')
                    checksum.update(chunk)
                    output.write(chunk)
        if received != size or checksum.hexdigest() != digest:
            raise ValueError(f'Music checksum or size mismatch: {name}')
        temporary.replace(target)
        print(f'Downloaded and verified {name}')
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def main():
    manifest = json.loads((ROOT / 'assets/audio/music-manifest.json').read_text(encoding='utf-8'))
    tracks = manifest['tracks']
    if manifest['license'] != 'CC0-1.0' or len({track['file'] for track in tracks}) != len(tracks):
        raise ValueError('Invalid licensed music manifest')
    for track in tracks:
        fetch_track(track, ROOT / 'assets/audio/music')


if __name__ == '__main__':
    main()
