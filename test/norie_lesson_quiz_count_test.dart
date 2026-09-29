import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';

void main() {
  test('every released chemistry lesson has 20 quiz questions', () {
    for (final topic in NorieContentCatalog.chemistryTopics) {
      expect(
        topic.quiz.questions.length,
        20,
        reason: '${topic.title} must ship with a 20-item lesson quiz.',
      );
      expect(
        topic.quiz.questions.map((question) => question.id).toSet().length,
        20,
        reason: '${topic.title} must not contain duplicate quiz IDs.',
      );
    }
  });
}
