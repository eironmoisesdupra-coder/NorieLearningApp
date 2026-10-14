import 'dart:math';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_adaptive_learning.dart';

void main() {
  final topic = NorieFoundationCurriculum.topicsFor('Science', 'g8').first;

  test(
      'weak recent evidence produces guided repair focused on priority concepts',
      () {
    final plan = NorieAdaptiveLearningPolicy.recommend(
      topic: topic,
      evidence: const NorieLessonEvidence(
        lastPercent: 50,
        bestPercent: 70,
        priorityConcepts: ['Key concept'],
      ),
    );
    expect(plan.band, NorieAdaptiveBand.guided);
    expect(plan.needsRemediation, isTrue);
    expect(plan.questionCount, 5);
  });

  test('strong retained evidence produces stretch practice', () {
    final plan = NorieAdaptiveLearningPolicy.recommend(
      topic: topic,
      evidence: NorieLessonEvidence(
        lastPercent: 90,
        bestPercent: 95,
        firstPassedAt: DateTime.utc(2026, 1, 1),
        retainedAt: DateTime.utc(2026, 1, 3),
      ),
    );
    expect(plan.band, NorieAdaptiveBand.stretch);
    expect(plan.isStretch, isTrue);
  });

  test('adaptive selection stays bounded and never duplicates questions', () {
    final plan = NorieAdaptiveLearningPolicy.recommend(topic: topic);
    final questions = NorieAdaptiveLearningPolicy.selectQuestions(
      topic,
      plan,
      random: Random(4),
    );
    expect(questions.length, lessThanOrEqualTo(5));
    expect(questions.map((q) => q.id).toSet(), hasLength(questions.length));
  });
  test('recent moderate evidence overrides an older best and retained pass',
      () {
    final plan = NorieAdaptiveLearningPolicy.recommend(
        topic: topic,
        evidence: NorieLessonEvidence(
            lastPercent: 75,
            bestPercent: 100,
            retainedAt: DateTime.utc(2026, 1, 1)));
    expect(plan.band, NorieAdaptiveBand.standard);
  });
  test('priority concepts are selected before unrelated foundation items', () {
    final bank = [
      for (var i = 0; i < 10; i++)
        NorieQuestionContent(
            id: 'item-$i',
            prompt: 'Example $i',
            options: const ['A', 'B'],
            correctIndex: 0,
            explanation: 'A',
            conceptLabel: i == 9 ? 'Priority' : 'Other')
    ];
    final fixture = NorieTopicContent.fromJson({
      ...topic.toJson(),
      'quiz': {'questions': bank.map((q) => q.toJson()).toList()},
      'challenge': {...topic.challenge.toJson(), 'rounds': <dynamic>[]}
    });
    final plan = NorieAdaptiveLearningPolicy.recommend(
        topic: fixture,
        evidence: const NorieLessonEvidence(
            lastPercent: 50, priorityConcepts: ['Priority']));
    for (final band in NorieAdaptiveBand.values) {
      final recommendation = NorieAdaptiveRecommendation(
          band: band,
          title: plan.title,
          reason: plan.reason,
          priorityConcepts: plan.priorityConcepts,
          questionCount: plan.questionCount);
      for (var seed = 0; seed < 20; seed++) {
        expect(
            NorieAdaptiveLearningPolicy.selectQuestions(fixture, recommendation,
                    random: Random(seed))
                .first
                .id,
            'item-9');
      }
    }
  });
  test('external practice plans cannot bypass the five-question maximum', () {
    const plan = NorieAdaptiveRecommendation(
        band: NorieAdaptiveBand.standard,
        title: '',
        reason: '',
        priorityConcepts: [],
        questionCount: 99);
    expect(
        NorieAdaptiveLearningPolicy.selectQuestions(topic, plan), hasLength(5));
  });
}
