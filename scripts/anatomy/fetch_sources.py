"""Fetch checksum-pinned anatomy sources into the ignored build cache."""
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
import math
from pathlib import Path
import shutil
import time
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[2]
CACHE = ROOT / 'build/anatomy-research'


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def fetch(entry):
    target = CACHE / entry['file']
    if target.exists() and digest(target) == entry['sha256']:
        print('Verified cached', entry['file'], flush=True)
        return
    print('Fetching', entry['file'], flush=True)
    pending = target.with_suffix(target.suffix + '.download')
    for attempt in range(3):
        try:
            # The archive host throttles long single-stream transfers. Range
            # requests stay bounded and every chunk must have the exact length.
            if entry['bytes'] > 50_000_000 and 'dbarchive.' in entry['url']:
                chunk_size = math.ceil(entry['bytes'] / 12)
                def part(index):
                    start = index * chunk_size
                    end = min(entry['bytes'], start + chunk_size) - 1
                    request = Request(entry['url'], headers={'Range': f'bytes={start}-{end}'})
                    with urlopen(request, timeout=120) as response:
                        if response.status != 206:
                            raise ValueError('Source must honor ranged download')
                        data = response.read()
                    if len(data) != end - start + 1:
                        raise ValueError('Incomplete source range')
                    return data
                with ThreadPoolExecutor(max_workers=12) as pool, pending.open('wb') as out:
                    for data in pool.map(part, range(12)):
                        out.write(data)
            else:
                with urlopen(entry['url'], timeout=120) as response, pending.open('wb') as out:
                    shutil.copyfileobj(response, out)
            if pending.stat().st_size != entry['bytes'] or digest(pending) != entry['sha256']:
                raise ValueError('Anatomy source checksum mismatch: ' + entry['file'])
            pending.replace(target)
            return
        except Exception:
            if attempt == 2:
                raise
            time.sleep(2)


if __name__ == '__main__':
    CACHE.mkdir(parents=True, exist_ok=True)
    manifest = json.loads((Path(__file__).parent / 'sources.json').read_text())
    for source in manifest['files']:
        fetch(source)
