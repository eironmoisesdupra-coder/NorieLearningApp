import 'dart:math';

import '../../../core/progression/norie_adventure_progress.dart';
import 'norie_content_models.dart';

enum NorieAdaptiveBand { guided, standard, stretch }

class NorieAdaptiveRecommendation {
  const NorieAdaptiveRecommendation({
    required this.band,
    required this.title,
    required this.reason,
    required this.priorityConcepts,
    required this.questionCount,
  });

  final NorieAdaptiveBand band;
  final String title;
  final String reason;
  final List<String> priorityConcepts;
  final int questionCount;

  bool get needsRemediation => band == NorieAdaptiveBand.guided;
  bool get isStretch => band == NorieAdaptiveBand.stretch;
}

/// Local, explainable adaptation only.
///
/// This policy never changes XP, rank, league points, earned access, or
/// permanent rewards. It only chooses the shape of the learner's next
/// optional practice set from already-authored questions.
abstract final class NorieAdaptiveLearningPolicy {
  static NorieAdaptiveRecommendation recommend({
    required NorieTopicContent topic,
    NorieLessonEvidence? evidence,
  }) {
    final concepts = List<String>.unmodifiable(
        (evidence?.priorityConcepts ?? const []).take(2));
    final last = evidence?.lastPercent ?? -1;
    final retained = evidence?.retainedAt != null;

    if (last >= 0 && (last < 65 || concepts.isNotEmpty && last < 80)) {
      return NorieAdaptiveRecommendation(
        band: NorieAdaptiveBand.guided,
        title: 'Guided repair',
        reason: concepts.isEmpty
            ? 'Rebuild the lesson with a short, lower-load practice set before another independent attempt.'
            : 'Focus on ${concepts.join(' and ')} before retrying the full independent set.',
        priorityConcepts: concepts,
        questionCount: 5,
      );
    }

    if (last >= 90 || retained && last >= 80) {
      return NorieAdaptiveRecommendation(
        band: NorieAdaptiveBand.stretch,
        title: 'Stretch challenge',
        reason:
            'Your recent evidence is strong. Try authored transfer questions that apply the lesson in a new context.',
        priorityConcepts: concepts,
        questionCount: 5,
      );
    }

    return NorieAdaptiveRecommendation(
      band: NorieAdaptiveBand.standard,
      title: 'Standard practice',
      reason:
          'Build confidence with authored practice. Use a lesson assessment or later review to demonstrate mastery.',
      priorityConcepts: concepts,
      questionCount: 5,
    );
  }

  static List<NorieQuestionContent> selectQuestions(
    NorieTopicContent topic,
    NorieAdaptiveRecommendation plan, {
    Random? random,
  }) {
    final rng = random ?? Random();
    final bank = <NorieQuestionContent>[
      ...topic.quiz.questions,
      ...topic.challenge.rounds,
    ];

    bool priority(NorieQuestionContent q) =>
        plan.priorityConcepts.isNotEmpty &&
        plan.priorityConcepts.contains(q.conceptLabel);

    final preferred = switch (plan.band) {
      NorieAdaptiveBand.guided => bank
          .where((q) =>
              priority(q) ||
              q.difficulty == 'foundation' ||
              q.difficulty == 'intermediate')
          .toList(),
      NorieAdaptiveBand.standard =>
        bank.where((q) => q.difficulty != 'advanced' || priority(q)).toList(),
      NorieAdaptiveBand.stretch => bank
          .where((q) =>
              q.difficulty == 'advanced' ||
              topic.challenge.rounds.any((c) => c.id == q.id))
          .toList(),
    };

    final targeted = bank.where(priority).toList()..shuffle(rng);
    final remaining = preferred.where((q) => !priority(q)).toList()
      ..shuffle(rng);
    final fallback = [...bank]..shuffle(rng);
    final seen = <String>{};
    return <NorieQuestionContent>[
      ...targeted,
      ...remaining,
      ...fallback,
    ]
        .where((q) => seen.add(q.id))
        .take(plan.questionCount.clamp(0, 5))
        .toList(growable: false);
  }
}
