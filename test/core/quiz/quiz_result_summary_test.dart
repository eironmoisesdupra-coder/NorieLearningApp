import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/quiz/quiz_result_summary.dart';
import 'package:norie_learning/core/quiz/quiz_result_history.dart';

QuizResultSummary result(String id, int correct,
        {int total = 10, bool complete = true, String key = 'quiz'}) =>
    QuizResultSummary(
        attemptId: id,
        historyKey: key,
        title: 'Fractions',
        correctCount: correct,
        totalCount: total,
        xpEarned: 0,
        isComplete: complete,
        answers: const []);
void main() {
  test('learner histories isolate comparisons and rare perfect celebrations',
      () async {
    SharedPreferences.setMockInitialValues({});
    final first = QuizResultHistory(learnerId: 'learner-a');
    final second = QuizResultHistory(learnerId: 'learner-b');
    final day = DateTime(2026, 10, 2);
    await first.record(result('one', 5), now: day);
    expect((await first.record(result('perfect', 10), now: day)).specialPerfect,
        true);
    final isolated = await second.record(result('perfect', 10), now: day);
    expect(isolated.previousPercentage, isNull);
    expect(isolated.isNew, true);
    expect(isolated.specialPerfect, true);
    expect((await first.record(result('next', 10), now: day)).specialPerfect,
        false);
    expect(
        (await QuizResultHistory().record(result('local', 5)))
            .previousPercentage,
        isNull);
  });
  test('one attempt can record distinct scopes without false deduplication',
      () async {
    SharedPreferences.setMockInitialValues({});
    final history = QuizResultHistory();
    await history.record(result('same', 5, key: 'quiz'));
    final other = await history.record(result('same', 10, key: 'lesson'));
    expect(other.isNew, true);
    expect(other.previousPercentage, isNull);
    expect(
        (await history.record(result('same', 10, key: 'lesson'))).isNew, false);
  });
  test('concurrent duplicate completions record only once', () async {
    SharedPreferences.setMockInitialValues({});
    final comparisons = await Future.wait(List.generate(
        4, (_) => QuizResultHistory().record(result('concurrent', 10))));
    expect(comparisons.where((c) => c.isNew).length, 1);
    expect(comparisons.where((c) => c.specialPerfect).length, 1);
  });
  test('young messages vary by attempt and remain short with real star text',
      () {
    final messages = <String>{};
    for (final id in ['a', 'b']) {
      messages.add(QuizResultSummary(
          attemptId: id,
          historyKey: 'q',
          title: 'Q',
          correctCount: 10,
          totalCount: 10,
          xpEarned: 0,
          gradeLevel: 1,
          answers: const []).message);
    }
    expect(messages.length, 2);
    expect(messages.any((m) => m.contains('\u{1F31F}')), true);
    expect(messages.every((m) => m.length < 40 && !m.contains('?')), true);
  });
  test('empty and incomplete attempts never enter comparable history',
      () async {
    SharedPreferences.setMockInitialValues({});
    final history = QuizResultHistory();
    expect((await history.record(result('empty', 0, total: 0))).isNew, false);
    expect((await history.record(result('partial', 10, complete: false))).isNew,
        false);
    expect(
        (await history.record(result('real', 5))).previousPercentage, isNull);
  });
  test('history has bounded storage and survives malformed optional fields',
      () async {
    SharedPreferences.setMockInitialValues({
      QuizResultHistory.storageKey:
          '[{"id":"old","key":"quiz","percentage":20,"previous":"broken"}]'
    });
    final history = QuizResultHistory();
    expect((await history.record(result('old', 2))).previousPercentage, isNull);
    for (var i = 0; i < 205; i++) {
      await history.record(result('id$i', 5));
    }
    final prefs = await SharedPreferences.getInstance();
    expect(
        (jsonDecode(prefs.getString(QuizResultHistory.storageKey)!) as List)
            .length,
        200);
  });
  test(
      'percentage tiers are independent of item counts and reject empty perfection',
      () {
    expect(result('a', 9).tier, QuizPerformanceTier.excellent);
    expect(result('b', 18, total: 20).tier, QuizPerformanceTier.excellent);
    expect(result('a', 10).tier, QuizPerformanceTier.perfect);
    expect(result('a', 8).tier, QuizPerformanceTier.great);
    expect(result('a', 7).tier, QuizPerformanceTier.goodProgress);
    expect(result('a', 5).tier, QuizPerformanceTier.keepPracticing);
    expect(result('a', 4).tier, QuizPerformanceTier.reviewRecommended);
    expect(result('a', 0, total: 0).isPerfect, false);
    expect(result('a', 10, complete: false).isPerfect, false);
  });
  test(
      'concept evidence limits priorities and requires repeat evidence for strength',
      () {
    final answers = List.generate(
        5,
        (i) => QuizAnswerRecord(
            questionId: '$i',
            prompt: 'Q',
            response: 'A',
            correctAnswer: 'B',
            explanation: 'Why',
            correct: i == 0,
            conceptId: 'c$i',
            conceptLabel: 'Concept $i'));
    final summary = QuizResultSummary(
        attemptId: 'a',
        historyKey: 'q',
        title: 'Q',
        correctCount: 1,
        totalCount: 5,
        xpEarned: 0,
        answers: answers);
    expect(summary.reviewConcepts.length, 2);
    expect(summary.strongConcepts, isEmpty);
    expect(() => summary.answers.add(answers.first), throwsUnsupportedError);
  });
  test('signature comparison ignores shuffle but distinguishes question sets',
      () {
    expect(
        quizHistoryKey('mcq', ['b', 'a']), quizHistoryKey('mcq', ['a', 'b']));
    expect(quizHistoryKey('mcq', ['a']), isNot(quizHistoryKey('mcq', ['b'])));
  });
  test('history persists comparable previous attempts and records once',
      () async {
    SharedPreferences.setMockInitialValues({});
    final history = QuizResultHistory();
    final first =
        await history.record(result('a', 5), now: DateTime(2026, 10, 2));
    expect(first.previousPercentage, isNull);
    final next =
        await history.record(result('b', 10), now: DateTime(2026, 10, 2));
    expect(next.previousPercentage, 50);
    expect(next.improvement, 50);
    expect(next.specialPerfect, true);
    final duplicate = await QuizResultHistory()
        .record(result('b', 10), now: DateTime(2026, 10, 2));
    expect(duplicate.isNew, false);
    expect(duplicate.specialPerfect, false);
    expect(duplicate.previousPercentage, 50);
    expect(
        (await history.record(result('c', 10), now: DateTime(2026, 10, 2)))
            .specialPerfect,
        false);
    expect(
        (await history.record(result('d', 10), now: DateTime(2026, 10, 3)))
            .specialPerfect,
        true);
    expect(
        (await history.record(result('e', 7, key: 'other'))).previousPercentage,
        isNull);
  });
}
