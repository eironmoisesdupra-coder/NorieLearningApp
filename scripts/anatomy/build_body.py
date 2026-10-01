"""Convert official BodyParts3D OBJ archive to named, meter-scale GLBs.

The source uses x/right, y/posterior, z/superior in millimeters. Output is glTF
x/right, y/superior, z/anterior in meters. No source geometry is synthesized.
"""
import argparse
from array import array
from collections import defaultdict
import csv
import hashlib
import json
from pathlib import Path
import re
import struct
import zipfile

COLORS = {
    'skeletal': [0.89, 0.85, 0.71], 'articular': [0.40, 0.79, 0.87],
    'muscular': [0.68, 0.23, 0.23], 'cardiovascular': [0.70, 0.22, 0.28],
    'arterial': [0.90, 0.20, 0.24], 'venous': [0.24, 0.43, 0.86],
    'nervous': [0.93, 0.76, 0.35], 'lymphatic': [0.30, 0.74, 0.40],
    'respiratory': [0.83, 0.55, 0.60], 'digestive': [0.78, 0.49, 0.30],
    'urinary': [0.68, 0.28, 0.29], 'reproductive': [0.87, 0.57, 0.63],
    'endocrine': [0.81, 0.50, 0.83], 'integumentary': [0.73, 0.55, 0.41],
    'sensory': [0.64, 0.81, 0.86],
}

# Source 4.0 includes individual OBJ parts absent from its downloadable inclusion
# tables. These rules are restricted to explicit anatomical names; unnamed parts
# remain excluded and are reported for review instead of being guessed.
NAME_RULES = [
    ('venous', r'\b(vein|veins|venous|vena cava)\b'),
    ('arterial', r'\b(artery|arteries|arterial|aorta|pulmonary trunk|celiac trunk|costocervical trunk|thyrocervical trunk|plantar arch|deep palmar arch)\b'),
    ('nervous', r'\b(nerve|ganglion|commissure|colliculus|fornix|corpus callosum|amygdala|caudate nucleus|choroid plexus|globus pallidus|interpeduncular fossa|lamina terminalis|geniculate body|mammillary body|optic chiasm|optic tract|midbrain|putamen|stria|thalamus|gyrus|telencephalon|tentorium cerebelli|interventricular foramen)\b'),
    ('sensory', r'\b(eye|eyeball|retina|ciliaris|ciliary|external ear|lateral rectus|medial rectus|tendinous ring)\b'),
    ('skeletal', r'\b(sternum|manubrium|xiphoid|tooth)\b'),
    ('integumentary', r'\b(eyebrow|hair)\b'),
    ('digestive', r'\b(sublingual gland|liver|hepatovenous|lip)\b'),
    ('respiratory', r'\b(epiglottis|epiglottic|conus elasticus|thyrohyoid|cricothyroid|vocal ligament)\b'),
    ('articular', r'\b(cartilage|retinaculum|interosseous membrane)\b'),
    ('muscular', r'\b(head|pectoralis|deltoid|trapezius|longus colli|intertransversarii|interspinales|iliococcygeus|pubococcygeus|puborectalis|rectus femoris|vastus|levatores|lumbricals|interossei|tendon|tendinous arch|iliotibial tract|linea alba|raphe|aryepiglotticus)\b'),
]


def named_system(mesh_id, name):
    if mesh_id == 'FJ2428':  # Source FMA13884, ventricular wall in the thorax.
        return 'cardiovascular'
    for system, pattern in NAME_RULES:
        if re.search(pattern, name, re.IGNORECASE):
            return system
    return None


def memberships(folder):
    mappings = {}
    for kind in ('isa', 'partof'):
        groups = defaultdict(set)
        with (folder / f'{kind}_element_parts.txt').open(encoding='utf-8') as stream:
            for row in csv.DictReader(stream, delimiter='\t'):
                groups[row['concept id']].add(row['element file id'])
        mappings[kind] = groups
    roots = {
        'skeletal': [('isa', 'FMA5018')],
        'articular': [('isa', 'FMA25624'), ('isa', 'FMA55107')],
        'muscular': [('isa', 'FMA5022')],
        'cardiovascular': [('partof', 'FMA7088')],
        'arterial': [('isa', 'FMA50720')], 'venous': [('isa', 'FMA50723')],
        'nervous': [('partof', 'FMA7157'), ('isa', 'FMA65132')],
        'lymphatic': [('isa', 'FMA7196'), ('isa', 'FMA71193')],
        'respiratory': [('partof', 'FMA7158')],
        'digestive': [('partof', 'FMA7152')], 'urinary': [('partof', 'FMA7159')],
        'reproductive': [('isa', key) for key in ('FMA7210', 'FMA9600', 'FMA18247',
            'FMA18255', 'FMA19234', 'FMA19386', 'FMA19617', 'FMA19618')],
        'endocrine': [('partof', 'FMA9668'), ('isa', 'FMA7198')],
        'integumentary': [('partof', 'FMA72979')],
        'sensory': [('partof', 'FMA54449'), ('partof', 'FMA54450')],
    }
    parents = defaultdict(set)
    for kind in ('isa', 'partof'):
        with (folder / f'{kind}_inclusion_relation_list.txt').open(encoding='utf-8') as stream:
            for row in csv.DictReader(stream, delimiter='\t'):
                parents[row['child id']].add(row['parent id'])
    def concept_systems(concept):
        seen, pending = set(), [concept]
        while pending:
            current = pending.pop()
            if current in seen:
                continue
            seen.add(current)
            pending.extend(parents[current] - seen)
        return {system for system, keys in roots.items() if any(key in seen for _, key in keys)}
    return ({system: set().union(*(mappings[kind][key] for kind, key in keys))
             for system, keys in roots.items()}, concept_systems)


class Glb:
    def __init__(self, system):
        self.data = bytearray()
        self.doc = {'asset': {'version': '2.0', 'generator': 'NorieLearning BodyParts3D converter'},
                    'scene': 0, 'scenes': [{'nodes': []}], 'nodes': [], 'meshes': [],
                    'accessors': [], 'bufferViews': [], 'buffers': [],
                    'materials': [{'pbrMetallicRoughness': {'baseColorFactor': COLORS[system] + [1],
                                                         'metallicFactor': 0, 'roughnessFactor': .8},
                                   'doubleSided': True}]}

    def accessor(self, values, code, component, kind, bounds=None):
        while len(self.data) % 4:
            self.data.append(0)
        raw = array(code, values).tobytes()
        view = len(self.doc['bufferViews'])
        self.doc['bufferViews'].append({'buffer': 0, 'byteOffset': len(self.data), 'byteLength': len(raw)})
        self.data.extend(raw)
        acc = {'bufferView': view, 'componentType': component, 'count': len(values) // (3 if kind == 'VEC3' else 1), 'type': kind}
        if bounds:
            acc.update(min=bounds[0], max=bounds[1])
        result = len(self.doc['accessors'])
        self.doc['accessors'].append(acc)
        return result

    def add(self, mesh_id, positions, normals, indices, bounds):
        attributes = {'POSITION': self.accessor(positions, 'f', 5126, 'VEC3', bounds)}
        if len(normals) == len(positions):
            attributes['NORMAL'] = self.accessor(normals, 'f', 5126, 'VEC3')
        mesh = len(self.doc['meshes'])
        self.doc['meshes'].append({'name': mesh_id, 'primitives': [{'attributes': attributes,
            'indices': self.accessor(indices, 'I', 5125, 'SCALAR'), 'material': 0}]})
        self.doc['scenes'][0]['nodes'].append(len(self.doc['nodes']))
        self.doc['nodes'].append({'name': mesh_id, 'mesh': mesh})

    def write(self, path):
        while len(self.data) % 4:
            self.data.append(0)
        self.doc['buffers'] = [{'byteLength': len(self.data)}]
        meta = json.dumps(self.doc, separators=(',', ':')).encode()
        meta += b' ' * (-len(meta) % 4)
        blob = struct.pack('<4sII', b'glTF', 2, 28 + len(meta) + len(self.data))
        blob += struct.pack('<II', len(meta), 0x4e4f534a) + meta
        blob += struct.pack('<II', len(self.data), 0x004e4942) + self.data
        path.write_bytes(blob)


def parse_obj(text):
    vertices, normals, faces = [], [], []
    for line in text.splitlines():
        parts = line.split()
        if not parts:
            continue
        if parts[0] in ('v', 'vn'):
            x, y, z = map(float, parts[1:4])
            target = vertices if parts[0] == 'v' else normals
            scale = .001 if parts[0] == 'v' else 1
            target.append((x * scale, z * scale, -y * scale))
        elif parts[0] == 'f':
            polygon = [tuple(int(n) if n else 0 for n in item.split('/')) for item in parts[1:]]
            for i in range(1, len(polygon) - 1):
                faces.extend((polygon[0], polygon[i], polygon[i + 1]))
    # OBJ normal indices are independent from vertex indices. Preserve each pair.
    pairs, positions, out_normals, indices = {}, [], [], []
    for face in faces:
        vi = face[0] - 1 if face[0] > 0 else len(vertices) + face[0]
        ni = face[2] if len(face) > 2 else 0
        key = (vi, ni)
        if key not in pairs:
            pairs[key] = len(pairs)
            positions.extend(vertices[vi])
            if ni:
                out_normals.extend(normals[ni - 1 if ni > 0 else len(normals) + ni])
        indices.append(pairs[key])
    bounds = [[min(positions[i::3]) for i in range(3)], [max(positions[i::3]) for i in range(3)]]
    return positions, out_normals, indices, bounds


def build(folder, output):
    output.mkdir(parents=True, exist_ok=True)
    groups, concept_systems = memberships(folder)
    writers = {system: Glb(system) for system in groups}
    structures, unclassified = [], []
    priority = ['arterial', 'venous', 'skeletal', 'articular', 'sensory', 'muscular',
                'reproductive', 'urinary', 'cardiovascular', 'nervous', 'lymphatic',
                'endocrine', 'respiratory', 'digestive', 'integumentary']
    with zipfile.ZipFile(folder / 'bp3d-complete.zip') as archive:
        for filename in sorted(archive.namelist()):
            if not filename.endswith('.obj'):
                continue
            mesh_id = Path(filename).stem
            text = archive.read(filename).decode('utf-8')
            name = re.search(r'# English name[ \t]*:[ \t]*([^\r\n]*)', text).group(1).strip()
            ontology = re.search(r'# Concept ID[ \t]*:[ \t]*([^\r\n]*)', text).group(1).strip()
            inherited = concept_systems(ontology) if ontology else set()
            systems = [system for system in priority if mesh_id in groups[system] or system in inherited]
            if not systems and (named := named_system(mesh_id, name)):
                systems = [named]
            if not name:
                systems = []
            if not systems:
                unclassified.append({'mesh': mesh_id, 'name': name, 'ontology': ontology})
                continue
            primary = systems[0]
            # Anatomical organ membership does not make its vessels or muscles
            # part of the organ-only layer. Preserve explicit endocrine overlap.
            systems = [primary] + (['digestive'] if primary == 'endocrine' and 'pancrea' in name.lower() else [])
            positions, normals, indices, bounds = parse_obj(text)
            writers[primary].add(mesh_id, positions, normals, indices, bounds)
            structures.append({'id': 'bp-' + mesh_id, 'name': name, 'ontology': ontology,
                'systems': systems, 'reference': 'male', 'asset': 'male-' + primary,
                'meshes': [mesh_id], 'bounds': bounds, 'source': 'bodyparts3d'})
    for system, writer in writers.items():
        if writer.doc['nodes']:
            writer.write(output / f'male-{system}.glb')
    (output / 'body-catalog.json').write_text(json.dumps(structures, indent=2), encoding='utf-8')
    (output / 'unclassified.json').write_text(json.dumps(unclassified, indent=2), encoding='utf-8')
    print(f'Converted {len(structures)} structures; {len(unclassified)} require classification review.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('source', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    build(args.source, args.output)
