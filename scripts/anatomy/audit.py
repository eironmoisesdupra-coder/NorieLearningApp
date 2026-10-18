"""Offline provenance and editorial inventory; never a medical approval service.

License mappings below transcribe assets/anatomy/ATTRIBUTION.md and the named,
checksum-pinned inputs in sources.json. Geometry/checksum validation remains in
catalog.py; this companion checks attribution and cross-reference boundaries.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
from urllib.parse import urlsplit

try:
    from .catalog import SYSTEMS, validate
except ImportError:
    from catalog import SYSTEMS, validate

ROOT = Path(__file__).resolve().parents[2]
CC_BY = 'https://creativecommons.org/licenses/by/4.0/'
CC_SA = 'https://creativecommons.org/licenses/by-sa/4.0/'
Z_URL = 'https://github.com/nqwrc/3d-anatomy/tree/8ca3b7421bcfbe88b85859eb1983d5cf79f21749'
Z_NOTICES = ('Z_ANATOMY_EXPORT_LICENSE.txt', 'Z_ANATOMY_NOTICE.txt',
             'Z_ANATOMY_UPSTREAM_LICENSE.txt')
BODY_INPUTS = ('bp3d-complete.zip',) + tuple(
    f'{kind}_{table}.txt' for kind in ('isa', 'partof')
    for table in ('parts_list_e', 'element_parts', 'inclusion_relation_list'))
EAR_INPUTS = ('ear-atlas.json',
    'ear-Model_9_Cochlear_Nerve.vtk',
    'ear-Model_21_Internal_Jugular_Vein.vtk',
    'ear-Model_17_Stapes_Bone.vtk', 'ear-Model_4_Tympanic_Membrane.vtk',
    'ear-Model_10_Labyrinth.vtk', 'ear-Model_14_Incus_Bone.vtk',
    'ear-Model_24_Internal_Carotid_Artery.vtk',
    'ear-Model_23_Osseous_Spiral_Lamina.vtk',
    'ear-Model_140_Malleus_Bone.vtk',
    'ear-Model_19_Tensor_Tympani_Muscle.vtk',
    'ear-Model_25_Vestibular_Nerve.vtk', 'ear-Model_5_Facial_Nerve.vtk',
    'ear-Model_28_Stapedius_Muscle.vtk', 'ear-Model_12_Fenestra_Rotunda.vtk')

# Source identity, allowed reference/assets, attribution evidence and pinned input.
PROVENANCE = {
    'bodyparts3d': dict(reference='male', assets=tuple('male-' + s for s in SYSTEMS),
        license='CC BY 4.0', licenseUrl=CC_BY,
        sourceUrls=['https://dbarchive.biosciencedbc.jp/en/bodyparts3d/download.html'],
        attributionToken='Detailed atlas: BodyParts3D 4.0',
        pinnedFiles=BODY_INPUTS, notices=()),
    'hra-female': dict(reference='female', assets=tuple('female-' + s for s in SYSTEMS),
        license='CC BY 4.0', licenseUrl=CC_BY,
        sourceUrls=['https://lod.humanatlas.io/ref-organ/united-female/v1.10/'],
        attributionToken='Detailed atlas: Human Reference Atlas female reference',
        pinnedFiles=('hra-female.glb',), notices=()),
    'spl-ear': dict(reference='ear', assets=('detail-ear',),
        license='3D Slicer Contribution and Software License Agreement 1.0',
        licenseUrl='https://www.openanatomy.org/atlas-pages/atlas-spl-inner-ear.html',
        sourceUrls=['https://www.openanatomy.org/atlas-pages/atlas-spl-inner-ear.html'],
        attributionToken='Detailed atlas: SPL inner and middle ear',
        pinnedFiles=EAR_INPUTS, notices=('SPL_EAR_LICENSE.txt',)),
}
ID_PREFIXES = {'bodyparts3d': 'bp-', 'hra-female': 'hra-',
    'z-lymphatic': 'za-lymph-', 'z-joints': 'za-detail-joints-',
    'z-skeletal': 'za-detail-joint-bones-', 'z-visceral': 'za-detail-glands-',
    'spl-ear': 'spl-ear-'}
for _source, _reference, _asset, _input in (
        ('z-lymphatic', 'lymphatic', 'detail-lymphatic', 'z-lymphatic.glb'),
        ('z-joints', 'joints', 'detail-joints', 'z-joints.glb'),
        ('z-skeletal', 'joints', 'detail-joint-bones', 'z-skeletal.glb'),
        ('z-visceral', 'glands', 'detail-glands', 'z-visceral.glb')):
    PROVENANCE[_source] = dict(reference=_reference, assets=(_asset,),
        license='CC BY-SA 4.0 (retained upstream notices apply)', licenseUrl=CC_SA,
        sourceUrls=[Z_URL], attributionToken='Z-Anatomy',
        pinnedFiles=(_input,), notices=Z_NOTICES)

EDITORIAL_FIELDS = ('gradeBand', 'objectives', 'explanation', 'diagram',
    'workedExample', 'guidedExample', 'reasoning', 'commonMistakes', 'recap',
    'practice', 'masteryItems', 'feedback', 'version')
LIMITATIONS = [
    'Counts are selectable model parts, including segments, groups and alternative references; they are not unique whole organs.',
    'Neither body reference is an exhaustive anatomy atlas. The female reference has partial musculoskeletal coverage.',
    'Lymphatic scenes do not include the complete distributed lymph-vessel network.',
    'Sensory detail includes a combined labyrinth, not separately segmented cochlear microanatomy.',
    'Skin is modeled at body/organ scale, without complete follicle or sweat-gland microanatomy.',
    'Detail scenes retain their own source coordinates and must not be superimposed on body references.',
    'Automated/source checks do not establish medical accuracy or human subject-matter approval.',
]


def _text(value):
    return isinstance(value, str) and bool(value.strip())


def _url(value):
    if not _text(value):
        return False
    parsed = urlsplit(value)
    return parsed.scheme == 'https' and bool(parsed.hostname) and not parsed.username


def _provenance_errors(root, sources):
    errors, evidence = [], {}
    try:
        path = root / 'assets/anatomy/ATTRIBUTION.md'
        attribution = path.read_text(encoding='utf-8')
        evidence['attributionSha256'] = hashlib.sha256(path.read_bytes()).hexdigest()
        pins_path = root / 'scripts/anatomy/sources.json'
        pins = json.loads(pins_path.read_text(encoding='utf-8'))
        pins = {item['file']: item for item in pins['files']}
        evidence['sourceManifestSha256'] = hashlib.sha256(pins_path.read_bytes()).hexdigest()
        for source in sorted(sources):
            policy = PROVENANCE.get(source)
            if policy is None:
                continue
            if (policy['attributionToken'] not in attribution or
                    policy['licenseUrl'] not in attribution):
                errors.append(f'Missing provenance/license attribution for {source}')
            for name in policy['pinnedFiles']:
                pin = pins.get(name, {})
                if not (_url(pin.get('url')) and
                        re.fullmatch('[0-9a-f]{64}', pin.get('sha256', ''))):
                    errors.append(f'Missing checksum-pinned source provenance: {name}')
            for name in policy['notices']:
                if not (root / 'assets/anatomy' / name).read_text(encoding='utf-8').strip():
                    errors.append(f'Empty provenance/license notice: {name}')
    except (OSError, ValueError, KeyError, TypeError) as error:
        errors.append(f'Cannot verify provenance/license evidence: {error}')
    return errors, evidence


def _teaching_records(value, structures, errors):
    if value is None:
        return {}, []
    if (not isinstance(value, dict) or value.get('schemaVersion') != 1 or
            not isinstance(value.get('structures'), list)):
        errors.append('Invalid teaching schema: expected schemaVersion 1 and structures list')
        return {}, []
    records, unmatched = {}, []
    for record in value['structures']:
        if not isinstance(record, dict) or not _text(record.get('id')):
            errors.append('Teaching record requires a string ID')
            continue
        identifier = record['id']
        if identifier in records:
            errors.append(f'Duplicate teaching ID: {identifier}')
            continue
        if identifier not in structures:
            unmatched.append(dict(id=identifier, status='unreviewed',
                                  flags=['unknown_catalog_id', 'human_approval_pending']))
            continue
        if record.get('reference') != structures[identifier]['reference']:
            errors.append(f'Teaching reference mismatch: {identifier}')
        records[identifier] = record
    return records, unmatched


def _editorial(record, identifier, errors):
    if record is None:
        return dict(status='missing', flags=['authored_teaching_missing',
                                            'human_approval_pending'])
    flags = ['human_approval_pending', 'pedagogical_quality_requires_human_review']
    for field in EDITORIAL_FIELDS:
        value = record.get(field)
        if not (_text(value) or
                isinstance(value, list) and value and all(_text(v) for v in value)):
            flags.append(field + '_missing')
    claims = record.get('claims', [])
    if not isinstance(claims, list):
        errors.append(f'Claims must be a list: {identifier}')
        claims = []
    if not claims:
        flags.append('claims_missing')
    for claim in claims:
        if not isinstance(claim, dict) or not _text(claim.get('text')):
            errors.append(f'Invalid claim: {identifier}')
            continue
        urls = claim.get('sources', [])
        if not isinstance(urls, list) or any(not _url(url) for url in urls):
            errors.append(f'Invalid claim sources: {identifier}')
        if not urls:
            flags.append('claim_sources_missing')
        flags.append('source_authority_and_claim_support_require_human_review')
    if not isinstance(record.get('reviewer'), dict):
        flags.append('reviewer_missing')
    # No trusted reviewer roster or externally verified signoff exists yet.
    # A JSON label (including reviewer.type=human) cannot grant approval.
    return dict(status='review', requestedStatus=record.get('status', 'draft'),
                flags=sorted(set(flags)),
                authoredDescription=record.get('explanation'),
                claims=claims, reviewer=record.get('reviewer'),
                version=record.get('version'))


def build_report(value, teaching=None, provenance_root=ROOT):
    report = dict(schemaVersion=1, auditKind='automated-source-and-editorial-inventory',
        humanApprovalConfigured=False, errors=[], limitations=LIMITATIONS,
        references={}, systems={s: 0 for s in sorted(SYSTEMS)}, structures=[],
        unmatchedTeaching=[], summary=dict(selectableParts=0, assets=0,
            ontologyMissing=0, teaching=dict(missing=0, review=0, approved=0)))
    errors = report['errors']
    try:
        validate(value)
        references = value['references']
        if len({r['id'] for r in references}) != len(references):
            errors.append('Duplicate reference ID')
        if any(not _text(r['id']) for r in references):
            errors.append('Empty reference ID')
        assets = {a['id']: a for a in value['assets']}
        sources = set()
        for asset in assets.values():
            asset_sources = {source for source, policy in PROVENANCE.items()
                             if asset['id'] in policy['assets']}
            if not asset_sources:
                errors.append(f'Unknown asset license provenance: {asset["id"]}')
            # A retained model still requires its own notices and source inputs,
            # even when no selectable structure happens to reference it.
            sources.update(asset_sources)
            if asset['file'] != asset['id'] + '.glb':
                errors.append(f'Asset file/provenance mismatch: {asset["id"]}')
        structures = {s['id']: s for s in value['structures']}
        records, report['unmatchedTeaching'] = _teaching_records(teaching, structures, errors)
        sources.update(s['source'] for s in value['structures'])
        provenance_errors, report['evidence'] = _provenance_errors(Path(provenance_root), sources)
        errors.extend(provenance_errors)
        for reference in references:
            report['references'][reference['id']] = dict(selectableParts=0,
                systems={s: 0 for s in sorted(SYSTEMS)}, sources={})
        for structure in value['structures']:
            identifier = structure['id']
            if not _text(identifier) or not _text(structure['name']):
                errors.append('Empty structure ID or name')
            elif (not re.fullmatch(r'[A-Za-z0-9_.:-]+', identifier) or
                    not identifier.startswith(ID_PREFIXES.get(structure['source'], '\x00'))):
                errors.append(f'Invalid structure ID/source provenance: {identifier}')
            policy = PROVENANCE.get(structure['source'])
            if policy is None:
                errors.append(f'Unknown source/license provenance: {identifier}')
            elif (policy['reference'] != structure['reference'] or
                    structure['asset'] not in policy['assets']):
                errors.append(f'Cross-reference asset/source provenance mismatch: {identifier}')
            ontology = structure.get('ontology', '')
            ontology_status = 'missing' if ontology in ('', '-', None) else 'source-provided'
            if ontology_status == 'missing':
                report['summary']['ontologyMissing'] += 1
            elif not isinstance(ontology, str) or not re.fullmatch(r'(FMA:?\d+|UBERON:\d+)', ontology):
                errors.append(f'Invalid ontology identifier: {identifier}')
            editorial = _editorial(records.get(identifier), identifier, errors)
            report['structures'].append(dict(
                id=identifier, name=structure['name'], reference=structure['reference'],
                systems=structure['systems'], asset=structure['asset'],
                source=structure['source'], ontology=ontology, ontologyStatus=ontology_status,
                synonyms=structure.get('synonyms', []),
                license=policy['license'] if policy else None,
                licenseUrl=policy['licenseUrl'] if policy else None,
                sourceUrls=policy['sourceUrls'] if policy else [], teaching=editorial))
            report['summary']['teaching'][editorial['status']] += 1
            reference = report['references'][structure['reference']]
            reference['selectableParts'] += 1
            source = structure['source']
            reference['sources'][source] = reference['sources'].get(source, 0) + 1
            for system in set(structure['systems']):
                report['systems'][system] += 1
                reference['systems'][system] += 1
        report['summary']['selectableParts'] = len(value['structures'])
        report['summary']['assets'] = len(assets)
    except (KeyError, TypeError, ValueError, AttributeError) as error:
        errors.append(f'Invalid catalog: {error}')
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--catalog', type=Path, default=ROOT / 'assets/anatomy/atlas-catalog.json')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--teaching', type=Path)
    parser.add_argument('--provenance-root', type=Path, default=ROOT)
    args = parser.parse_args()
    try:
        value = json.loads(args.catalog.read_text(encoding='utf-8'))
        teaching = json.loads(args.teaching.read_text(encoding='utf-8')) if args.teaching else None
        report = build_report(value, teaching, args.provenance_root)
    except (OSError, ValueError) as error:
        report = dict(schemaVersion=1, errors=[f'Cannot read audit input: {error}'])
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(f'Anatomy audit: {len(report["errors"])} critical errors; report: {args.output}')
    return 1 if report['errors'] else 0


if __name__ == '__main__':
    raise SystemExit(main())
