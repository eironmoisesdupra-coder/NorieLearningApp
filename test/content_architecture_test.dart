import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

void main() {
  group('Reusable content architecture', () {
    test('Atomic Structure keeps the current lesson assessment sizes', () {
      final topic = NorieContentCatalog.atomicStructure;

      expect(topic.quiz.questions, hasLength(5));
      expect(topic.challenge.rounds, hasLength(3));
      expect(topic.lesson.completionXp, 50);
      expect(topic.quiz.xpPerCorrect, 20);
      expect(topic.challenge.xpPerCorrect, 25);
      expect(topic.totalAssessmentAttempts, 8);
    });

    test('all available questions have valid correct-answer indexes', () {
      for (final subject in NorieContentCatalog.subjects) {
        for (final category in subject.categories) {
          for (final topic in category.topics.where((item) => item.available)) {
            for (final question in topic.quiz.questions) {
              expect(
                question.hasValidAnswer,
                isTrue,
                reason: '${topic.id} quiz question ${question.id}',
              );
            }
            for (final round in topic.challenge.rounds) {
              expect(
                round.hasValidAnswer,
                isTrue,
                reason: '${topic.id} challenge round ${round.id}',
              );
            }
          }
        }
      }
    });

    test('topic JSON round-trip preserves reusable content', () {
      final original = NorieContentCatalog.atomicStructure;
      final restored = NorieTopicContent.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.subject, original.subject);
      expect(restored.category, original.category);
      expect(restored.title, original.title);
      expect(restored.lesson.heading, original.lesson.heading);
      expect(
        restored.lesson.sections.length,
        original.lesson.sections.length,
      );
      expect(
        restored.quiz.questions.map((item) => item.prompt),
        original.quiz.questions.map((item) => item.prompt),
      );
      expect(
        restored.challenge.rounds.map((item) => item.correctIndex),
        original.challenge.rounds.map((item) => item.correctIndex),
      );
    });

    test('catalog lookup resolves stable topic IDs', () {
      final topic = NorieContentCatalog.topicById(
        'science.chemistry.atomic-structure',
      );

      expect(topic, isNotNull);
      expect(topic!.title, 'Atomic Structure');
      expect(
        NorieContentCatalog.topicById('missing.topic'),
        isNull,
      );
    });
  });
}
