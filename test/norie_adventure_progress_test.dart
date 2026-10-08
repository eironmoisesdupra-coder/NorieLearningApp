import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/quiz/quiz_result_summary.dart';

List<QuizAnswerRecord> answers(int correct, {bool selfRated = false}) => [
      for (var i = 0; i < 5; i++)
        QuizAnswerRecord(
            questionId: 'q$i',
            prompt: 'p$i',
            response: 'a',
            correctAnswer: 'a',
            explanation: 'e',
            correct: i < correct,
            selfRated: selfRated,
            conceptId: 'c${i % 2}',
            conceptLabel: 'Concept ${i % 2}'),
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NorieAdventureProgress progress;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    progress = NorieAdventureProgress();
  });
  test(
      'whole-path mastery requires completion and retained evidence for every real lesson',
      () async {
    final ids = ['science.g1.a', 'science.g1.b'];
    void refresh() => progress.registerGradeCompletions(
        subject: 'Science',
        gradeId: 'g1',
        originalTopicIds: ids,
        currentTopicIds: ids,
        completedTopicIds: ids.toSet());
    final first = DateTime.utc(2026, 10, 8);
    refresh();
    expect(progress.trophyIds, isNot(contains('path-mastery:science.g1')));
    for (final id in ids) {
      await progress.recordAttempt(
          topicId: id, attemptId: 'first', answers: answers(5), at: first);
      await progress.recordAttempt(
          topicId: id,
          attemptId: 'later',
          answers: answers(4),
          at: first.add(const Duration(days: 1)),
          delayedReview: true);
      refresh();
      if (id == ids.first) {
        expect(progress.trophyIds, isNot(contains('path-mastery:science.g1')));
      }
    }
    expect(progress.trophyIds, contains('path-mastery:science.g1'));
    final snapshot = progress.exportState();
    progress.registerGradeCompletions(
        subject: 'Science',
        gradeId: 'g1',
        originalTopicIds: ids,
        currentTopicIds: [...ids, 'science.g1.c'],
        completedTopicIds: ids.toSet());
    await progress.flush();
    expect(progress.exportState()['trophies'], snapshot['trophies']);
  });
  test(
      'independent stars require five answers, 80 percent and later independent evidence',
      () async {
    final first = DateTime.utc(2026, 10, 8);
    await progress.recordAttempt(
        topicId: 'science.g1.a',
        attemptId: 'first',
        answers: answers(4),
        at: first);
    expect(progress.starCount('science.g1.a', completed: true), 2);
    await progress.recordAttempt(
        topicId: 'science.g1.a',
        attemptId: 'too-soon',
        answers: answers(5),
        at: first.add(const Duration(hours: 23)),
        delayedReview: true);
    expect(progress.starCount('science.g1.a', completed: true), 2);
    await progress.recordAttempt(
        topicId: 'science.g1.a',
        attemptId: 'later',
        answers: answers(4),
        at: first.add(const Duration(hours: 24)),
        delayedReview: true);
    expect(progress.starCount('science.g1.a', completed: true), 3);
    final restored = NorieAdventureProgress();
    await restored.load();
    expect(restored.starCount('science.g1.a', completed: true), 3);
  });
  test(
      'self-rated answers, repeated IDs and stale ownership never certify a star',
      () async {
    await progress.recordAttempt(
        topicId: 'a', attemptId: 'self', answers: answers(5, selfRated: true));
    expect(progress.starCount('a', completed: false), 0);
    await progress.recordAttempt(
        topicId: 'a',
        attemptId: 'duplicate',
        answers: List.filled(5, answers(5).first));
    expect(progress.starCount('a', completed: false), 0);
    final revision = progress.ownershipRevision;
    await progress.reset();
    expect(
        await progress.recordAttempt(
            topicId: 'a',
            attemptId: 'old-account',
            answers: answers(5),
            expectedRevision: revision),
        false);
    expect(progress.evidenceFor('a'), null);
  });
  test('migration and expansion preserve trophy receipts without replay awards',
      () async {
    progress.registerGradeCompletions(
        subject: 'Science',
        gradeId: 'g1',
        originalTopicIds: ['a', 'b', 'c', 'd', 'e'],
        currentTopicIds: ['a', 'b', 'c', 'd', 'e', 'f'],
        completedTopicIds: {'a', 'b', 'c', 'd', 'e'});
    expect(progress.trophyIds, contains('grade:science.g1'));
    expect(progress.trophyIds.length, 1);
    progress.registerGradeCompletions(
        subject: 'Science',
        gradeId: 'g1',
        originalTopicIds: ['a', 'b', 'c', 'd', 'e'],
        currentTopicIds: ['a', 'b', 'c', 'd', 'e', 'f'],
        completedTopicIds: {'a', 'b', 'c', 'd', 'e', 'f'});
    final count = progress.trophyIds.length;
    progress.registerGradeCompletions(
        subject: 'Science',
        gradeId: 'g1',
        originalTopicIds: ['a', 'b', 'c', 'd', 'e'],
        currentTopicIds: ['a', 'b', 'c', 'd', 'e', 'f'],
        completedTopicIds: {'a', 'b', 'c', 'd', 'e', 'f'});
    expect(progress.trophyIds.length, count);
    expect(progress.trophyIds, contains('grade:science.g1'));
    await progress.flush();
    final restored = NorieAdventureProgress();
    await restored.load();
    expect(restored.trophyIds, progress.trophyIds);
  });
  test('malformed evidence is rejected before replacing existing progress',
      () async {
    await progress.recordAttempt(
        topicId: 'a', attemptId: 'valid', answers: answers(5));
    expect(
        () =>
            progress.applyValidatedState(NorieAdventureProgress.validateState({
              'version': 1,
              'evidence': {
                'a': {'first_passed_at': 'bad'}
              },
              'trophies': {},
              'receipts': []
            })),
        throwsFormatException);
    expect(progress.starCount('a', completed: true), 2);
  });
  test('rounding a score to 80 percent cannot certify a below-threshold pass',
      () async {
    await progress.recordAttempt(topicId: 'rounding', attemptId: 'a', answers: [
      for (var i = 0; i < 174; i++)
        QuizAnswerRecord(
            questionId: 'q$i',
            prompt: 'p',
            response: 'a',
            correctAnswer: 'a',
            explanation: 'e',
            correct: i < 139)
    ]);
    expect(progress.evidenceFor('rounding')!.lastPercent, 80);
    expect(progress.evidenceFor('rounding')!.firstPassedAt, isNull);
  });
}
