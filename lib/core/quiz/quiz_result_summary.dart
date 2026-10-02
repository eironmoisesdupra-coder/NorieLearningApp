import 'dart:convert';

/// Actual answer evidence. Self-rated recall and unanswered items stay explicit.
class QuizAnswerRecord {
  const QuizAnswerRecord(
      {required this.questionId,
      required this.prompt,
      required this.response,
      required this.correctAnswer,
      required this.explanation,
      required this.correct,
      this.conceptId,
      this.conceptLabel,
      this.selfRated = false,
      this.unanswered = false});
  final String questionId, prompt, response, correctAnswer, explanation;
  final bool correct, selfRated, unanswered;
  final String? conceptId, conceptLabel;
}

enum QuizPerformanceTier {
  perfect,
  excellent,
  great,
  goodProgress,
  keepPracticing,
  reviewRecommended
}

class QuizResultSummary {
  QuizResultSummary(
      {required this.attemptId,
      required this.historyKey,
      required this.title,
      required this.correctCount,
      required this.totalCount,
      required this.xpEarned,
      required List<QuizAnswerRecord> answers,
      this.gradeLevel,
      this.isComplete = true})
      : answers = List.unmodifiable(answers),
        assert(totalCount >= 0),
        assert(correctCount >= 0 && correctCount <= totalCount);
  final String attemptId, historyKey, title;
  final int correctCount, totalCount, xpEarned;
  final int? gradeLevel;
  final bool isComplete;
  final List<QuizAnswerRecord> answers;
  double get percentage =>
      totalCount == 0 ? 0 : correctCount / totalCount * 100;
  bool get isPerfect =>
      isComplete && totalCount > 0 && correctCount == totalCount;
  bool get isYoung =>
      gradeLevel != null && gradeLevel! <= 2 && gradeLevel! >= 1;
  QuizPerformanceTier get tier {
    if (isPerfect) return QuizPerformanceTier.perfect;
    if (percentage >= 90) return QuizPerformanceTier.excellent;
    if (percentage >= 80) return QuizPerformanceTier.great;
    if (percentage >= 70) return QuizPerformanceTier.goodProgress;
    if (percentage >= 50) return QuizPerformanceTier.keepPracticing;
    return QuizPerformanceTier.reviewRecommended;
  }

  List<QuizAnswerRecord> get mistakes =>
      answers.where((a) => !a.correct || a.unanswered).toList(growable: false);
  Map<String, List<QuizAnswerRecord>> get _concepts {
    final result = <String, List<QuizAnswerRecord>>{};
    for (final a in answers) {
      if (a.conceptId?.trim().isNotEmpty == true &&
          a.conceptLabel?.trim().isNotEmpty == true) {
        (result[a.conceptId!] ??= []).add(a);
      }
    }
    return result;
  }

  List<String> get reviewConcepts {
    final groups = _concepts.values
        .where((g) => g.any((a) => !a.correct || a.unanswered))
        .toList();
    groups.sort((a, b) => b
        .where((a) => !a.correct || a.unanswered)
        .length
        .compareTo(a.where((a) => !a.correct || a.unanswered).length));
    return groups
        .take(2)
        .map((g) => g.first.conceptLabel!)
        .toList(growable: false);
  }

  List<String> get strongConcepts => _concepts.values
      .where((g) =>
          g.length >= 2 &&
          g.every((a) => a.correct && !a.unanswered && !a.selfRated))
      .take(2)
      .map((g) => g.first.conceptLabel!)
      .toList(growable: false);
  String get heading => !isComplete
      ? 'Practice paused'
      : totalCount == 0
          ? 'Practice ready'
          : switch (tier) {
              QuizPerformanceTier.perfect => 'Perfect run!',
              QuizPerformanceTier.excellent => 'Excellent work!',
              QuizPerformanceTier.great => 'Great work!',
              QuizPerformanceTier.goodProgress => 'Good progress!',
              QuizPerformanceTier.keepPracticing => 'Keep practicing',
              QuizPerformanceTier.reviewRecommended =>
                'Let\u2019s learn together'
            };
  String get message {
    if (!isComplete) return 'You can return to the lesson and keep learning.';
    if (totalCount == 0) {
      return 'There are no scored questions in this activity.';
    }
    if (isYoung) {
      final pool = switch (tier) {
        QuizPerformanceTier.perfect => [
            'All right! \u{1F31F}',
            'You got every one!'
          ],
        QuizPerformanceTier.excellent => [
            'Great job! \u{1F31F}',
            'So many right answers!'
          ],
        QuizPerformanceTier.great => [
            'You did it! \u{1F31F}',
            'Most answers were right!'
          ],
        QuizPerformanceTier.goodProgress => [
            'Keep going!',
            'Let us check the tricky ones.'
          ],
        QuizPerformanceTier.keepPracticing => [
            'Let us practice together.',
            'Try the tricky ones with Norie.'
          ],
        QuizPerformanceTier.reviewRecommended => [
            'Let us learn together.',
            'Read the lesson with Norie.'
          ],
      };
      return pool[attemptId.codeUnits.fold(0, (a, b) => a + b) % pool.length];
    }
    final pool = switch (tier) {
      QuizPerformanceTier.perfect => [
          'Every answer was correct this time.',
          'Full marks on this attempt. Well done!'
        ],
      QuizPerformanceTier.excellent => [
          'A strong result. Check the few ideas you missed.',
          'Excellent accuracy on this attempt.'
        ],
      QuizPerformanceTier.great => [
          'Strong progress. Let\u2019s polish the tricky ideas.',
          'You answered most items correctly.'
        ],
      QuizPerformanceTier.goodProgress => [
          'A quick review can strengthen your understanding.',
          'Good progress. Revisit the questions that were tricky.'
        ],
      QuizPerformanceTier.keepPracticing => [
          'Let\u2019s review the tricky parts together.',
          'Practice gives you another chance to build this skill.'
        ],
      QuizPerformanceTier.reviewRecommended => [
          'Review the lesson, then try again.',
          'Let\u2019s take another look at this lesson together.'
        ]
    };
    return pool[attemptId.codeUnits.fold(0, (a, b) => a + b) % pool.length];
  }
}

/// Order-independent, collision-free serialization of the caller's exact question
/// identities/content and type. Does not use process-dependent Dart hashCode.
String quizHistoryKey(String scope, Iterable<String> questionSignatures) =>
    jsonEncode([scope, questionSignatures.toList()..sort()]);
