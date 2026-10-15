import 'dart:convert';
import 'dart:math';

import '../data/norie_foundation_curriculum.dart';
import 'norie_content_models.dart';
import 'norie_review_quest.dart';

/// An optional chapter checkpoint using the chapter's actual authored items.
/// Completion is local learning evidence, never a verified league score.
class NorieBossMission {
  NorieBossMission._(
      {required this.id,
      required this.subject,
      required this.gradeId,
      required this.chapterNumber,
      required List<NorieTopicContent> topics})
      : topics = List.unmodifiable(topics);

  final String id, subject, gradeId;
  final int chapterNumber;
  final List<NorieTopicContent> topics;
  String get title => 'Chapter $chapterNumber Boss Mission';

  bool isReady(Set<String> completedTopicIds) =>
      topics.isNotEmpty &&
      topics.every((t) => completedTopicIds.contains(t.id));

  List<NorieQuestionContent> questions({Random? random}) =>
      NorieReviewQuestPolicy.chapterQuestions(topics, random: random);

  static List<NorieBossMission> forPath(String subject, String gradeId) {
    final names = NorieFoundationCurriculum.supportedSubjects
        .where((name) => name.toLowerCase() == subject.toLowerCase());
    if (names.isEmpty) return const [];
    final canonical = names.first;
    if (!NorieFoundationCurriculum.availableGradeLevels(canonical)
        .any((g) => g.id == gradeId)) {
      return const [];
    }
    final topics = NorieFoundationCurriculum.topicsFor(canonical, gradeId)
        .where((t) => t.available && NorieFoundationCurriculum.isAuthored(t))
        .toList(growable: false);
    final bosses = <NorieBossMission>[];
    for (var start = 0; start < topics.length; start += 5) {
      final chapter = topics.sublist(start, min(start + 5, topics.length));
      // IDs, not wording or random item order: typo fixes keep earned cards.
      // Earlier complete chapters keep their identity when paths expand.
      final content = [
        for (final t in chapter) ...[
          t.id,
          ...t.quiz.questions.map((q) => q.id),
          ...t.challenge.rounds.map((q) => q.id)
        ]
      ]..sort();
      var hash = 2166136261;
      for (final byte in utf8.encode(content.join('|'))) {
        hash = ((hash ^ byte) * 16777619) & 0xffffffff;
      }
      final number = start ~/ 5 + 1;
      bosses.add(NorieBossMission._(
          id: 'boss:${canonical.toLowerCase()}.$gradeId:chapter-$number:${hash.toRadixString(16)}',
          subject: canonical,
          gradeId: gradeId,
          chapterNumber: number,
          topics: chapter));
    }
    return List.unmodifiable(bosses);
  }
}
