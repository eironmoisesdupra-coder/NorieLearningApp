import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

void main() {
  test('old questions stay untagged and authored concepts round trip', () {
    final old = <String, dynamic>{
      'id': 'growth',
      'prompt': 'Which grows?',
      'options': ['Plant', 'Rock'],
      'correct_index': 0,
      'explanation': 'Plants grow.',
    };
    expect(NorieQuestionContent.fromJson(old).conceptId, isNull);
    final tagged = NorieQuestionContent.fromJson({
      ...old,
      'concept_id': 'living-growth',
      'concept_label': 'Growth of living things',
    });
    final restored = NorieQuestionContent.fromJson(tagged.toJson());
    expect(restored.conceptId, 'living-growth');
    expect(restored.conceptLabel, 'Growth of living things');
  });
}
