import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';

void main() {
  final data = <String, dynamic>{
    'schemaVersion': 1,
    'references': [
      {'id': 'male', 'label': 'Adult male', 'description': 'Reference'}
    ],
    'structures': [
      {
        'id': 'femur-r',
        'name': 'Right femur',
        'reference': 'male',
        'systems': ['skeletal'],
        'asset': 'male-skeletal',
        'source': 'bodyparts3d',
        'ontology': 'FMA24474'
      },
      {
        'id': 'heart',
        'name': 'Heart',
        'reference': 'male',
        'systems': ['cardiovascular'],
        'asset': 'male-heart',
        'source': 'bodyparts3d'
      },
    ],
  };
  test('search stays within selected reference and systems', () {
    final catalog = AnatomyAtlasCatalog.fromJson(data);
    expect(catalog.search('male', {'skeletal'}, 'FEMUR').single.id, 'femur-r');
    expect(catalog.search('male', {'skeletal'}, 'heart'), isEmpty);
    expect(catalog.search('female', {'skeletal'}, ''), isEmpty);
  });
  test('duplicate IDs and unsupported schema fail explicitly', () {
    expect(() => AnatomyAtlasCatalog.fromJson({...data, 'schemaVersion': 2}),
        throwsFormatException);
    expect(
        () => AnatomyAtlasCatalog.fromJson({
              ...data,
              'structures': [
                ...(data['structures'] as List),
                (data['structures'] as List).first,
              ]
            }),
        throwsFormatException);
  });
}
