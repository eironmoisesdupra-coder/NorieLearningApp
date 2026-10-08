import 'dart:math';
import '../../../core/progression/norie_adventure_progress.dart';
import 'norie_content_models.dart';
import '../data/norie_foundation_curriculum.dart';

enum NorieReviewQuestKind { mistakeDrill, retainedReview, chapter }

abstract final class NorieReviewQuestPolicy {
  static List<NorieQuestionContent> select(
      NorieTopicContent topic, NorieReviewQuestKind kind,
      {Random? random}) {
    if (!NorieFoundationCurriculum.isAuthored(topic)) return const [];
    final bank = [...topic.quiz.questions, ...topic.challenge.rounds];
    final evidence = NorieAdventureProgress.instance.evidenceFor(topic.id);
    final missed = evidence?.missedQuestionIds.toSet() ?? <String>{};
    final labels = evidence?.priorityConcepts.toSet() ?? <String>{};
    // Equivalent items from actual missed concepts come before exact repeats.
    final fresh = bank
        .where((q) => labels.contains(q.conceptLabel) && !missed.contains(q.id))
        .toList()
      ..shuffle(random);
    final repeats = bank.where((q) => missed.contains(q.id)).toList()
      ..shuffle(random);
    final rest = bank
        .where((q) =>
            !fresh.any((a) => a.id == q.id) &&
            !repeats.any((a) => a.id == q.id))
        .toList()
      ..shuffle(random);
    final candidates = kind == NorieReviewQuestKind.mistakeDrill
        ? [...fresh, ...repeats]
        : [...rest, ...fresh, ...repeats];
    final ids = <String>{};
    return candidates
        .where((q) => ids.add(q.id))
        .take(5)
        .toList(growable: false);
  }

  static List<NorieQuestionContent> chapterQuestions(
      List<NorieTopicContent> topics,
      {Random? random}) {
    final source = topics
        .where((topic) =>
            topic.available && NorieFoundationCurriculum.isAuthored(topic))
        .toList();
    final result = <NorieQuestionContent>[];
    // Two independent questions per real lesson; one is a transfer item.
    for (final topic in source) {
      final practice = [...topic.quiz.questions]..shuffle(random);
      final transfer = [...topic.challenge.rounds]..shuffle(random);
      if (practice.isNotEmpty) result.add(practice.first);
      if (transfer.isNotEmpty) result.add(transfer.first);
    }
    // Focused chapters use real authored items, never the adjacent previews.
    if (result.length < 5) {
      final extra = [
        for (final topic in source) ...[
          ...topic.quiz.questions,
          ...topic.challenge.rounds
        ]
      ]..shuffle(random);
      for (final question in extra) {
        if (!result.any((item) => item.id == question.id)) result.add(question);
        if (result.length >= 5) break;
      }
    }
    result.shuffle(random);
    final ids = <String>{};
    return result.where((q) => ids.add(q.id)).toList(growable: false);
  }
}
