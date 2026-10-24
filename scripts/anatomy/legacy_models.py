"""Recover the exact already-published legacy models when their mirror is gone.

Never substitutes geometry. Both the published package and extracted model bytes
must match independent pins; no executable or arbitrary archive member is run.
Detailed atlas source downloads/builds remain in the existing pipeline.
"""
import hashlib
import json
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
from urllib.error import HTTPError, URLError
from urllib.request import urlopen
import zipfile

ROOT = Path(__file__).resolve().parents[2]
RELEASE_URL = ('https://github.com/eironmoisesdupra-coder/NorieLearningApp/'
               'releases/download/v0.18.0/NorieLearning-Windows.zip')
RELEASE_SHA = 'd65b2530084e9b6832e7ce0cb3fbeb8bc08c18142ba6da6468de51702452c959'
RELEASE_SOURCE = 'ed9472dbb437127abd8fd09931a86879d4df5ec5'
SOURCE_COMMIT = 'e4d76fbb424d15e1364963528a082a78fa359161'
SOURCE_URL = ('https://raw.githubusercontent.com/yamz8/human-body-simulator/'
              + SOURCE_COMMIT + '/public/models/overview-skeleton.glb')
SOURCE_SHA = '253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce'
ORGANS_URL = ('https://github.com/yamz8/human-body-simulator/raw/'
              'refs/heads/main/public/models/anatomy-organs.glb')
MODEL_SHA = {
    'overview-skeleton.glb': '5cff2708bf15083a034cd4aa0f47361432be1e60687ef0f9993dc4fb3cae78d1',
    'anatomy-organs.glb': 'fa0f8a32e6f1fdc8f8c469f81409289b0141cebe5d37e3e0048a134cf8bf6eb6',
}
ASAR_MEMBER = 'NorieLearning-win32-x64/resources/app.asar'


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def read_asar_asset(stream, asset_path):
    parts = asset_path.split('/')
    if any(p in ('', '.', '..') or '\\' in p for p in parts):
        raise ValueError('Unsafe ASAR asset path')
    stream.seek(0, 2)
    total = stream.tell()
    stream.seek(0)
    raw = stream.read(16)
    if len(raw) != 16:
        raise ValueError('Truncated ASAR header')
    pickle_size, header_size, payload_size, length = struct.unpack('<4I', raw)
    start = 8 + header_size
    if (pickle_size != 4 or header_size < 8 or payload_size != header_size - 4
            or length < 2 or length > 8_000_000 or length > header_size - 8
            or start > total):
        raise ValueError('Invalid ASAR bounds')
    try:
        entry = json.loads(stream.read(length))
        for part in parts:
            entry = entry['files'][part]
        if entry.get('link') is not None or entry.get('unpacked'):
            raise ValueError('Linked/unpacked asset is not eligible')
        size = entry['size']
        offset = int(entry['offset'])
        if type(size) is not int or size <= 0 or size > 100_000_000 or offset < 0 or start + offset + size > total:
            raise ValueError('Invalid ASAR asset bounds')
        stream.seek(start + offset)
        result = stream.read(size)
        if len(result) != size:
            raise ValueError('Truncated ASAR model')
        return result
    except (KeyError, TypeError, json.JSONDecodeError) as error:
        raise ValueError('Missing or malformed ASAR model') from error


def restore_release_archive(archive, output, *, expected_sha=RELEASE_SHA, models=None):
    models = MODEL_SHA if models is None else models
    if digest(archive) != expected_sha:
        raise ValueError('Published snapshot archive checksum mismatch')
    pending = {}
    with zipfile.ZipFile(archive) as package:
        if package.namelist().count(ASAR_MEMBER) != 1:
            raise ValueError('Missing or ambiguous published ASAR')
        member = package.getinfo(ASAR_MEMBER)
        if member.file_size > 600_000_000:
            raise ValueError('Published ASAR exceeds budget')
        with tempfile.TemporaryFile() as asar, package.open(member) as source:
            shutil.copyfileobj(source, asar)
            for name, expected in models.items():
                if Path(name).name != name or '/' in name or '\\' in name:
                    raise ValueError('Unsafe output name')
                body = read_asar_asset(asar, 'web/assets/assets/anatomy/' + name)
                if hashlib.sha256(body).hexdigest() != expected or body[:4] != b'glTF':
                    raise ValueError('Published model checksum/format mismatch: ' + name)
                pending[name] = body
    # Validate every member before touching any existing model. Each individual
    # replacement is atomic and contains exactly the previously shipped bytes.
    output.mkdir(parents=True, exist_ok=True)
    for name, body in pending.items():
        temporary = None
        try:
            with tempfile.NamedTemporaryFile(dir=output, prefix=name + '.', delete=False) as target:
                temporary = Path(target.name)
                target.write(body)
                target.flush()
            temporary.replace(output / name)
        finally:
            if temporary is not None:
                temporary.unlink(missing_ok=True)


def download_verified(url, target, expected_sha):
    if target.is_file() and digest(target) == expected_sha:
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as out:
            temporary = Path(out.name)
            with urlopen(url, timeout=120) as response:
                size = 0
                while chunk := response.read(1024 * 1024):
                    size += len(chunk)
                    if size > 500_000_000:
                        raise ValueError('Model download exceeds budget')
                    out.write(chunk)
            out.flush()
        if digest(temporary) != expected_sha:
            raise ValueError('Anatomy download checksum mismatch')
        temporary.replace(target)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def main():
    assets = ROOT / 'assets/anatomy'
    cache = ROOT / 'build/anatomy-legacy'
    cache.mkdir(parents=True, exist_ok=True)
    route = 'verified-output-cache'
    if not all((assets / name).is_file() and digest(assets / name) == expected
               for name, expected in MODEL_SHA.items()):
        try:
            source = cache / 'overview-skeleton-source.glb'
            download_verified(SOURCE_URL, source, SOURCE_SHA)
            subprocess.run([sys.executable, str(ROOT / 'scripts/build_full_skeleton.py'),
                            str(source), str(assets / 'overview-skeleton.glb')], check=True)
            download_verified(ORGANS_URL, assets / 'anatomy-organs.glb', MODEL_SHA['anatomy-organs.glb'])
            route = 'checksum-pinned-upstream'
        except (HTTPError, URLError) as error:
            if isinstance(error, HTTPError) and error.code not in (404, 410, 429, 500, 502, 503, 504):
                raise
            print('Legacy mirror unavailable; restoring exact licensed published snapshot.', flush=True)
            snapshot = cache / 'NorieLearning-v0.18.0-Windows.zip'
            download_verified(RELEASE_URL, snapshot, RELEASE_SHA)
            restore_release_archive(snapshot, assets)
            route = 'checksum-pinned-published-snapshot'
    for name, expected in MODEL_SHA.items():
        if digest(assets / name) != expected:
            raise ValueError('Legacy model changed: ' + name)
    subprocess.run([sys.executable, str(ROOT / 'scripts/inspect_glb_bounds.py'),
                    str(assets / 'overview-skeleton.glb')], check=True)
    report = {'schema': 1, 'route': route,
        'expected_upstream': {'skeleton_url': SOURCE_URL, 'skeleton_source_sha256': SOURCE_SHA,
                              'organs_url': ORGANS_URL},
        'published_snapshot': {'url': RELEASE_URL, 'sha256': RELEASE_SHA, 'source_commit': RELEASE_SOURCE},
        'models': MODEL_SHA,
        'notice': 'Byte integrity and build provenance only; not anatomical identity or medical approval.'}
    (ROOT / 'build/anatomy-legacy-provenance.json').write_text(json.dumps(report, indent=2) + '\n')
    print('Verified unchanged legacy model bytes (' + route + ').', flush=True)


if __name__ == '__main__':
    main()
