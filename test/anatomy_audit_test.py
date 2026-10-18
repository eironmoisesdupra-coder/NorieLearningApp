"""Contract tests for the executable, offline source/editorial audit."""
import copy
import json
from pathlib import Path
import subprocess
import shutil
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SYSTEMS = 'skeletal articular muscular cardiovascular arterial venous nervous lymphatic respiratory digestive urinary reproductive endocrine integumentary sensory'.split()
REQUIRED_INPUTS = (
    'bp3d-complete.zip', 'isa_parts_list_e.txt', 'isa_element_parts.txt',
    'isa_inclusion_relation_list.txt', 'partof_parts_list_e.txt',
    'partof_element_parts.txt', 'partof_inclusion_relation_list.txt',
    'hra-female.glb', 'z-lymphatic.glb', 'z-joints.glb', 'z-skeletal.glb',
    'z-visceral.glb', 'ear-atlas.json',
    'ear-Model_9_Cochlear_Nerve.vtk',
    'ear-Model_21_Internal_Jugular_Vein.vtk',
    'ear-Model_17_Stapes_Bone.vtk', 'ear-Model_4_Tympanic_Membrane.vtk',
    'ear-Model_10_Labyrinth.vtk', 'ear-Model_14_Incus_Bone.vtk',
    'ear-Model_24_Internal_Carotid_Artery.vtk',
    'ear-Model_23_Osseous_Spiral_Lamina.vtk',
    'ear-Model_140_Malleus_Bone.vtk',
    'ear-Model_19_Tensor_Tympani_Muscle.vtk',
    'ear-Model_25_Vestibular_Nerve.vtk', 'ear-Model_5_Facial_Nerve.vtk',
    'ear-Model_28_Stapedius_Muscle.vtk', 'ear-Model_12_Fenestra_Rotunda.vtk',
)


def copy_provenance(folder):
    (folder / 'assets/anatomy').mkdir(parents=True)
    (folder / 'scripts/anatomy').mkdir(parents=True)
    for name in ('ATTRIBUTION.md', 'SPL_EAR_LICENSE.txt',
                 'Z_ANATOMY_EXPORT_LICENSE.txt', 'Z_ANATOMY_NOTICE.txt',
                 'Z_ANATOMY_UPSTREAM_LICENSE.txt'):
        shutil.copyfile(ROOT / 'assets/anatomy' / name,
                        folder / 'assets/anatomy' / name)
    shutil.copyfile(ROOT / 'scripts/anatomy/sources.json',
                    folder / 'scripts/anatomy/sources.json')


def fixture():
    structures = [dict(id=f'bp-{system}', name=f'{system} part',
                       ontology='FMA123', reference='male', systems=[system],
                       asset=f'male-{system}', source='bodyparts3d',
                       meshes=[system], bounds=[[0, 0, 0], [1, 1, 1]])
                  for system in SYSTEMS]
    structures.append(dict(id='hra-bone', name='Female bone', ontology='UBERON:0001',
                           reference='female', systems=['skeletal'],
                           asset='female-skeletal', source='hra-female',
                           meshes=['bone'], bounds=[[0, 0, 0], [1, 1, 1]]))
    return dict(schemaVersion=1,
                references=[dict(id='male'), dict(id='female')],
                assets=[dict(id=s['asset'], file=s['asset'] + '.glb',
                             sha256='a' * 64) for s in structures],
                structures=structures)


class AnatomyAuditTest(unittest.TestCase):
    def run_audit(self, value=None, teaching=None, extra=()):
        with tempfile.TemporaryDirectory() as folder:
            folder = Path(folder)
            catalog, output = folder / 'catalog.json', folder / 'report.json'
            catalog.write_text(json.dumps(value if value is not None else fixture()))
            command = [sys.executable, str(ROOT / 'scripts/anatomy/audit.py'),
                       '--catalog', str(catalog), '--output', str(output), *extra]
            if teaching is not None:
                path = folder / 'teaching.json'
                path.write_text(json.dumps(teaching))
                command.extend(['--teaching', str(path)])
            result = subprocess.run(command, capture_output=True, text=True)
            report = json.loads(output.read_text()) if output.exists() else {}
            return result, report

    def test_all_fifteen_filters_have_reference_specific_counts(self):
        result, report = self.run_audit()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['summary']['selectableParts'], 16)
        self.assertEqual(report['references']['male']['selectableParts'], 15)
        self.assertEqual(report['references']['female']['systems']['skeletal'], 1)
        self.assertEqual(report['references']['female']['systems']['muscular'], 0)
        self.assertEqual(report['systems']['skeletal'], 2)
        for system in SYSTEMS[1:]:
            self.assertEqual(report['systems'][system], 1, system)
        self.assertEqual(report['summary']['teaching'],
                         {'missing': 16, 'review': 0, 'approved': 0})
        part = report['structures'][0]
        for key in ('id', 'name', 'reference', 'systems', 'source', 'ontology',
                    'license', 'sourceUrls', 'teaching'):
            self.assertIn(key, part)

    def test_critical_invalid_catalogs_fail_and_write_evidence(self):
        for field, bad in [('reference', 'made-up'), ('systems', ['magic']),
                           ('source', 'unknown'), ('asset', 'unknown'),
                           ('name', ''), ('id', '')]:
            with self.subTest(field=field):
                value = fixture()
                value['structures'][0][field] = bad
                result, report = self.run_audit(value)
                self.assertEqual(result.returncode, 1, result.stderr)
                self.assertTrue(report['errors'])

    def test_cross_reference_asset_is_critical(self):
        value = fixture()
        value['structures'][0]['asset'] = 'female-skeletal'
        result, report = self.run_audit(value)
        self.assertEqual(result.returncode, 1)
        self.assertTrue(any('provenance' in e for e in report['errors']))

    def test_invalid_or_wrong_source_identifier_is_critical(self):
        for identifier in ('bp-part/../../escape', 'hra-wrong-source'):
            value = fixture()
            value['structures'][0]['id'] = identifier
            result, report = self.run_audit(value)
            self.assertEqual(result.returncode, 1)
            self.assertTrue(report['errors'])

    def test_all_detail_scenes_keep_their_own_source_boundaries(self):
        value = fixture()
        details = [
            ('z-lymphatic', 'lymphatic', 'detail-lymphatic', 'za-lymph-0', 'lymphatic'),
            ('z-joints', 'joints', 'detail-joints', 'za-detail-joints-0', 'articular'),
            ('z-skeletal', 'joints', 'detail-joint-bones', 'za-detail-joint-bones-0', 'skeletal'),
            ('z-visceral', 'glands', 'detail-glands', 'za-detail-glands-0', 'endocrine'),
            ('spl-ear', 'ear', 'detail-ear', 'spl-ear-example', 'sensory'),
        ]
        value['references'].extend(dict(id=r) for r in ('lymphatic', 'joints', 'glands', 'ear'))
        for source, reference, asset, identifier, system in details:
            value['assets'].append(dict(id=asset, file=asset + '.glb', sha256='a' * 64))
            value['structures'].append(dict(id=identifier, name='Detail part',
                source=source, reference=reference, asset=asset, systems=[system],
                meshes=['part'], bounds=[[0, 0, 0], [1, 1, 1]]))
        result, report = self.run_audit(value)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['references']['joints']['selectableParts'], 2)
        self.assertEqual(report['references']['ear']['systems']['sensory'], 1)
        self.assertEqual(report['references']['male']['systems']['sensory'], 1)
        value['structures'][-1]['reference'] = 'female'
        result, report = self.run_audit(value)
        self.assertEqual(result.returncode, 1)

    def test_duplicate_references_and_structure_ids_cannot_shadow(self):
        for key in ('references', 'structures'):
            value = fixture()
            value[key].append(copy.deepcopy(value[key][0]))
            result, report = self.run_audit(value)
            self.assertEqual(result.returncode, 1)
            self.assertTrue(report['errors'])

    def test_orphan_unlicensed_asset_fails_even_when_unused(self):
        value = fixture()
        value['assets'].append(dict(id='unlicensed', file='unlicensed.glb', sha256='a' * 64))
        result, report = self.run_audit(value)
        self.assertEqual(result.returncode, 1)
        self.assertTrue(any('license' in e for e in report['errors']))

    def test_retained_orphan_ear_asset_requires_its_license_notice(self):
        value = fixture()
        value['assets'].append(dict(id='detail-ear', file='detail-ear.glb', sha256='a' * 64))
        with tempfile.TemporaryDirectory() as folder:
            folder = Path(folder)
            copy_provenance(folder)
            (folder / 'assets/anatomy/SPL_EAR_LICENSE.txt').unlink()
            result, report = self.run_audit(value, extra=['--provenance-root', str(folder)])
            self.assertEqual(result.returncode, 1)
            self.assertTrue(any('provenance/license' in e for e in report['errors']))

    def test_every_source_input_pin_is_required_even_for_retained_orphan_assets(self):
        value = fixture()
        for asset in ('detail-ear', 'detail-lymphatic', 'detail-joints',
                      'detail-joint-bones', 'detail-glands'):
            value['assets'].append(dict(id=asset, file=asset + '.glb', sha256='a' * 64))
        for missing in REQUIRED_INPUTS:
            with self.subTest(missing=missing), tempfile.TemporaryDirectory() as folder:
                folder = Path(folder)
                copy_provenance(folder)
                path = folder / 'scripts/anatomy/sources.json'
                manifest = json.loads(path.read_text())
                manifest['files'] = [pin for pin in manifest['files'] if pin['file'] != missing]
                path.write_text(json.dumps(manifest))
                result, report = self.run_audit(value, extra=['--provenance-root', str(folder)])
                self.assertEqual(result.returncode, 1)
                self.assertIn('Missing checksum-pinned source provenance: ' + missing,
                              report['errors'])

    def test_missing_ontology_is_reported_without_inventing_an_id(self):
        value = fixture()
        value['structures'][0]['ontology'] = '-'
        result, report = self.run_audit(value)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['structures'][0]['ontologyStatus'], 'missing')
        self.assertEqual(report['structures'][0]['ontology'], '-')

    def test_source_fma_colon_ids_are_preserved(self):
        value = fixture()
        value['structures'][0]['ontology'] = 'FMA:73166'
        result, report = self.run_audit(value)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['structures'][0]['ontology'], 'FMA:73166')

    def test_self_claimed_human_or_ai_reviewer_never_approves_content(self):
        for reviewer in ({'type': 'human', 'name': 'Best reviewer'},
                         {'type': 'ai', 'name': 'AI medical expert'}):
            teaching = {'schemaVersion': 1, 'structures': [
                {'id': 'bp-skeletal', 'reference': 'male', 'status': 'approved',
                 'reviewer': reviewer, 'version': '1', 'claims': [
                     {'text': 'An unverified assertion', 'sources': []}]}]}
            result, report = self.run_audit(teaching=teaching)
            self.assertEqual(result.returncode, 0, result.stderr)
            part = report['structures'][0]['teaching']
            self.assertEqual(part['status'], 'review')
            self.assertIn('human_approval_pending', part['flags'])
            self.assertIn('claim_sources_missing', part['flags'])
            self.assertIn('objectives_missing', part['flags'])
            self.assertEqual(report['summary']['teaching']['approved'], 0)

    def test_unknown_teaching_id_remains_unreviewed(self):
        result, report = self.run_audit(teaching={'schemaVersion': 1, 'structures': [
            {'id': 'invented-bone', 'reference': 'male', 'status': 'approved'}]})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(report['unmatchedTeaching'][0]['status'], 'unreviewed')
        self.assertEqual(report['summary']['teaching']['missing'], 16)

    def test_teaching_wrong_reference_is_a_critical_error(self):
        result, report = self.run_audit(teaching={'schemaVersion': 1, 'structures': [
            {'id': 'bp-skeletal', 'reference': 'female'}]})
        self.assertEqual(result.returncode, 1)
        self.assertTrue(any('reference' in e for e in report['errors']))

    def test_hostile_metadata_is_reported_without_crashing(self):
        for records in ('approved', [None], [{'id': ['bp-skeletal']}],
                        [{'id': 'bp-skeletal', 'reference': 'male', 'claims': 'yes'}],
                        [{'id': 'bp-skeletal', 'reference': 'male',
                          'claims': [{'text': 'claim', 'sources': ['javascript:alert(1)']}]}]):
            with self.subTest(records=records):
                result, report = self.run_audit(teaching={'schemaVersion': 1, 'structures': records})
                self.assertEqual(result.returncode, 1, result.stderr)
                self.assertTrue(report['errors'])
                self.assertNotIn('Traceback', result.stderr)

    def test_empty_license_evidence_fails(self):
        with tempfile.TemporaryDirectory() as folder:
            result, report = self.run_audit(extra=['--provenance-root', folder])
            self.assertEqual(result.returncode, 1)
            self.assertTrue(any('provenance' in e for e in report['errors']))

    def test_required_source_notice_cannot_be_empty(self):
        value = fixture()
        value['references'].append(dict(id='ear'))
        value['assets'].append(dict(id='detail-ear', file='detail-ear.glb', sha256='a' * 64))
        value['structures'].append(dict(id='spl-ear-example', name='Ear part',
            source='spl-ear', reference='ear', asset='detail-ear', systems=['sensory'],
            meshes=['part'], bounds=[[0, 0, 0], [1, 1, 1]]))
        with tempfile.TemporaryDirectory() as folder:
            folder = Path(folder)
            (folder / 'assets/anatomy').mkdir(parents=True)
            (folder / 'scripts/anatomy').mkdir(parents=True)
            for name in ('ATTRIBUTION.md', 'SPL_EAR_LICENSE.txt'):
                shutil.copyfile(ROOT / 'assets/anatomy' / name,
                                folder / 'assets/anatomy' / name)
            shutil.copyfile(ROOT / 'scripts/anatomy/sources.json',
                            folder / 'scripts/anatomy/sources.json')
            (folder / 'assets/anatomy/SPL_EAR_LICENSE.txt').write_text('')
            result, report = self.run_audit(value, extra=['--provenance-root', str(folder)])
            self.assertEqual(result.returncode, 1)
            self.assertTrue(any('Empty provenance/license notice' in e for e in report['errors']))


if __name__ == '__main__':
    unittest.main()
