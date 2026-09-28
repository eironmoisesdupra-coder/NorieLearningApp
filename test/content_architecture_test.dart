import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/content/data/norie_content_repository.dart';
import 'package:norie_learning/features/content/domain/norie_content_access.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

void main() {
  group('Reusable content architecture', () {
    test('Chemistry has four playable curriculum topics', () {
      final topics = NorieContentCatalog.chemistryTopics;

      expect(topics, hasLength(4));
      expect(
        topics.map((topic) => topic.title),
        [
          'Atomic Structure',
          'Periodic Table',
          'Chemical Bonding',
          'Acids & Bases',
        ],
      );
      expect(topics.every((topic) => topic.available), isTrue);
    });

    test('every Chemistry topic keeps the reusable assessment structure', () {
      for (final topic in NorieContentCatalog.chemistryTopics) {
        expect(
          topic.quiz.questions,
          hasLength(5),
          reason: topic.title,
        );
        expect(
          topic.challenge.rounds,
          hasLength(3),
          reason: topic.title,
        );
        expect(topic.lesson.completionXp, 50);
        expect(topic.quiz.xpPerCorrect, 20);
        expect(topic.challenge.xpPerCorrect, 25);
        expect(topic.totalAssessmentAttempts, 8);
      }
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

    test('Chemistry prerequisite chain unlocks in order', () {
      final atomic = NorieContentCatalog.atomicStructure;
      final periodic = NorieContentCatalog.periodicTable;
      final bonding = NorieContentCatalog.chemicalBonding;
      final acids = NorieContentCatalog.acidsBases;

      expect(
        NorieContentAccess.isUnlocked(atomic, <String>{}),
        isTrue,
      );
      expect(
        NorieContentAccess.isUnlocked(periodic, <String>{}),
        isFalse,
      );
      expect(
        NorieContentAccess.isUnlocked(
          periodic,
          {atomic.id},
        ),
        isTrue,
      );
      expect(
        NorieContentAccess.isUnlocked(
          bonding,
          {atomic.id},
        ),
        isFalse,
      );
      expect(
        NorieContentAccess.isUnlocked(
          bonding,
          {atomic.id, periodic.id},
        ),
        isTrue,
      );
      expect(
        NorieContentAccess.isUnlocked(
          acids,
          {atomic.id, periodic.id, bonding.id},
        ),
        isTrue,
      );
    });

    test('topic JSON round-trip preserves prerequisite and content', () {
      final original = NorieContentCatalog.acidsBases;
      final restored = NorieTopicContent.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.subject, original.subject);
      expect(restored.category, original.category);
      expect(restored.title, original.title);
      expect(
        restored.prerequisiteTopicId,
        original.prerequisiteTopicId,
      );
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

    test('bundled repository supports offline Chemistry fallback', () async {
      const repository = BundledNorieContentRepository();
      final topics = await repository.getTopicsForCategory('chemistry');

      expect(topics, hasLength(4));
      expect(topics.first.id, NorieContentCatalog.atomicStructure.id);
      expect(topics.last.id, NorieContentCatalog.acidsBases.id);
    });
  });
}
