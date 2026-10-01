import importlib.util
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('atlas_catalog', ROOT / 'scripts/anatomy/catalog.py')
catalog = importlib.util.module_from_spec(spec)
spec.loader.exec_module(catalog)
body_spec = importlib.util.spec_from_file_location('atlas_body', ROOT / 'scripts/anatomy/build_body.py')
body = importlib.util.module_from_spec(body_spec)
body_spec.loader.exec_module(body)


class CatalogValidationTest(unittest.TestCase):
    def fixture(self):
        return {'schemaVersion': 1, 'references': [{'id': 'male'}],
                'assets': [{'id': 'male-skeletal', 'file': 'male-skeletal.glb',
                            'sha256': 'a' * 64}],
                'structures': [{'id': 'bone', 'name': 'Femur', 'reference': 'male',
                                'systems': ['skeletal'], 'asset': 'male-skeletal',
                                'meshes': ['FJ1'], 'source': 'bodyparts3d',
                                'bounds': [[0, 0, 0], [1, 1, 1]]}]}

    def test_valid_subset_and_required_category_coverage(self):
        catalog.validate(self.fixture(), required_systems={'skeletal'})
        with self.assertRaisesRegex(ValueError, 'Empty systems'):
            catalog.validate(self.fixture())

    def test_duplicate_structure_cannot_shadow_another_mesh(self):
        value = self.fixture()
        value['structures'].append(dict(value['structures'][0]))
        with self.assertRaisesRegex(ValueError, 'Duplicate'):
            catalog.validate(value, required_systems={'skeletal'})
    def test_rectus_femoris_is_a_thigh_muscle_not_an_eye_structure(self):
        self.assertEqual(body.named_system('FJ1433', 'Right rectus femoris'), 'muscular')

    def test_obj_coordinates_and_independent_normals_preserve_orientation(self):
        text = 'v 1000 0 0\nv 0 1000 0\nv 0 0 1000\nvn 0 0 1\nf 1//1 2//1 3//1\n'
        positions, normals, indices, bounds = body.parse_obj(text)
        self.assertEqual(positions, [1, 0, 0, 0, 0, -1, 0, 1, 0])
        self.assertEqual(normals, [0, 1, 0] * 3)
        self.assertEqual(indices, [0, 1, 2])
        self.assertEqual(bounds, [[0, 0, -1], [1, 1, 0]])

    def test_missing_asset_and_invalid_bounds_fail(self):
        value = self.fixture()
        value['structures'][0]['asset'] = 'missing'
        with self.assertRaisesRegex(ValueError, 'asset'):
            catalog.validate(value, required_systems={'skeletal'})
        value = self.fixture()
        value['structures'][0]['bounds'][0][0] = float('nan')
        with self.assertRaisesRegex(ValueError, 'bounds'):
            catalog.validate(value, required_systems={'skeletal'})

    def test_source_geometry_and_checksum_are_required(self):
        for key in ('source', 'meshes'):
            value = self.fixture()
            value['structures'][0][key] = [] if key == 'meshes' else ''
            with self.assertRaises(ValueError):
                catalog.validate(value, required_systems={'skeletal'})
        value = self.fixture()
        value['assets'][0]['sha256'] = 'unchecked'
        with self.assertRaisesRegex(ValueError, 'checksum'):
            catalog.validate(value, required_systems={'skeletal'})


if __name__ == '__main__':
    unittest.main()
