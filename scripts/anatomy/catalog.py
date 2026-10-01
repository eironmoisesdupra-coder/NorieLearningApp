"""Build-time atlas integrity checks. No runtime network or third-party dependencies."""
import math
import re
import json
import hashlib
import struct
from pathlib import Path

SYSTEMS = frozenset('skeletal articular muscular cardiovascular arterial venous nervous lymphatic respiratory digestive urinary reproductive endocrine integumentary sensory'.split())


def validate(value, required_systems=SYSTEMS):
    if value.get('schemaVersion') != 1:
        raise ValueError('Unsupported atlas schema')
    references = {item['id'] for item in value['references']}
    assets = {}
    for item in value['assets']:
        if item['id'] in assets:
            raise ValueError('Duplicate asset ID')
        if not re.fullmatch(r'[a-zA-Z0-9_-]+\.glb', item['file']):
            raise ValueError('Unsafe asset filename')
        if not re.fullmatch(r'[0-9a-f]{64}', item.get('sha256', '')):
            raise ValueError('Invalid asset checksum')
        assets[item['id']] = item
    ids, covered = set(), set()
    for item in value['structures']:
        if item['id'] in ids:
            raise ValueError('Duplicate structure ID: ' + item['id'])
        ids.add(item['id'])
        if item['reference'] not in references:
            raise ValueError('Unknown reference')
        if item['asset'] not in assets:
            raise ValueError('Unknown asset')
        if not item.get('source') or not item.get('meshes') or not item.get('name'):
            raise ValueError('Structure requires source, name and geometry')
        systems = set(item['systems'])
        if not systems or not systems <= SYSTEMS:
            raise ValueError('Unknown or empty structure systems')
        covered.update(systems)
        bounds = item.get('bounds', [])
        if (len(bounds) != 2 or any(len(row) != 3 for row in bounds)
                or any(not math.isfinite(n) for row in bounds for n in row)
                or any(bounds[0][i] > bounds[1][i] for i in range(3))
                or bounds[0] == bounds[1]):
            raise ValueError('Invalid structure bounds')
    if missing := set(required_systems) - covered:
        raise ValueError('Empty systems: ' + ', '.join(sorted(missing)))


def validate_files(value, folder):
    validate(value)
    geometry = {}
    for asset in value['assets']:
        data = (folder / asset['file']).read_bytes()
        if hashlib.sha256(data).hexdigest() != asset['sha256']:
            raise ValueError('Asset checksum mismatch: ' + asset['file'])
        if data[:4] != b'glTF' or struct.unpack_from('<I', data, 8)[0] != len(data):
            raise ValueError('Invalid GLB container')
        doc = json.loads(data[20:20 + struct.unpack_from('<I', data, 12)[0]])
        nodes = {}
        for node in doc['nodes']:
            if 'mesh' not in node:
                continue
            mesh = doc['meshes'][node['mesh']]
            if not any(doc['accessors'][p['attributes']['POSITION']]['count'] >= 3 for p in mesh['primitives']):
                continue
            nodes[node['name']] = node.get('extras', {}).get('atlasStructure')
        geometry[asset['id']] = nodes
    for item in value['structures']:
        for name in item['meshes']:
            if geometry[item['asset']].get(name) != item['id']:
                raise ValueError('Missing selectable mesh: ' + item['id'])
    return len(value['structures'])


if __name__ == '__main__':
    folder = Path(__file__).resolve().parents[2] / 'assets/anatomy'
    value = json.loads((folder / 'atlas-catalog.json').read_text())
    print(f'Validated {validate_files(value, folder)} selectable structures across all 15 systems.')
