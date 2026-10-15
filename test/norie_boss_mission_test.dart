import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/content/domain/norie_boss_mission.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/quiz/quiz_result_summary.dart';

class _BossSavePreferences extends InMemorySharedPreferencesStore {
  _BossSavePreferences() : super.empty();
  bool fail = true;
  @override
  Future<bool> setValue(String type, String key, Object value) =>
      fail ? Future.value(false) : super.setValue(type, key, value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('failed durable boss save is reported and retry persists same receipt',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = _BossSavePreferences();
    SharedPreferencesStorePlatform.instance = prefs;
    final progress = NorieAdventureProgress();
    final boss = NorieBossMission.forPath('Science', 'g1').first;
    final answers = [
      for (var i = 0; i < 5; i++)
        QuizAnswerRecord(
            questionId: 'q$i',
            prompt: 'p',
            response: 'a',
            correctAnswer: 'a',
            explanation: 'e',
            correct: true)
    ];
    await expectLater(
        progress.recordAttempt(
            topicId: boss.id, attemptId: 'same', answers: answers),
        throwsStateError);
    expect(await prefs.getAll(), isEmpty);
    prefs.fail = false;
    expect(
        await progress.recordAttempt(
            topicId: boss.id, attemptId: 'same', answers: answers),
        isTrue);
    final restored = NorieAdventureProgress();
    await restored.load();
    expect(restored.trophyIds, {boss.id});
    expect((restored.exportState()['receipts'] as List).length, 1);
  });
  test('every real path has bounded bosses covering every lesson once', () {
    var paths = 0;
    for (final subject in NorieFoundationCurriculum.supportedSubjects) {
      for (final grade
          in NorieFoundationCurriculum.availableGradeLevels(subject)) {
        paths++;
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        final bosses = NorieBossMission.forPath(subject, grade.id);
        expect(bosses.expand((b) => b.topics).map((t) => t.id),
            topics.map((t) => t.id));
        expect(bosses.map((b) => b.id).toSet().length, bosses.length);
        for (final boss in bosses) {
          expect(boss.topics.length, inInclusiveRange(1, 5));
          expect(boss.isReady({}), isFalse);
          expect(boss.isReady(boss.topics.map((t) => t.id).toSet()), isTrue);
          expect(boss.isReady(boss.topics.skip(1).map((t) => t.id).toSet()),
              isFalse);
          for (var seed = 0; seed < 5; seed++) {
            final items = boss.questions(random: Random(seed));
            expect(items.length, inInclusiveRange(5, 10));
            expect(items.map((q) => q.id).toSet().length, items.length);
            for (final topic in boss.topics) {
              expect(
                  items.any(
                      (q) => topic.challenge.rounds.any((a) => a.id == q.id)),
                  isTrue);
              expect(
                  items.any(
                      (q) => topic.quiz.questions.any((a) => a.id == q.id)),
                  isTrue);
            }
          }
        }
        expect(NorieBossMission.forPath(subject, grade.id).map((b) => b.id),
            bosses.map((b) => b.id));
      }
    }
    expect(paths, 41);
    expect(NorieBossMission.forPath('Filipino', 'g2'), isEmpty);
    expect(NorieBossMission.forPath('Unknown', 'g1'), isEmpty);
  });

  test('boss pass saves one permanent card without granting lesson evidence',
      () async {
    SharedPreferences.setMockInitialValues({});
    final progress = NorieAdventureProgress();
    final boss = NorieBossMission.forPath('Science', 'g1').first;
    List<QuizAnswerRecord> answers(int correct) => [
          for (var i = 0; i < 5; i++)
            QuizAnswerRecord(
                questionId: 'q$i',
                prompt: 'p',
                response: 'a',
                correctAnswer: 'a',
                explanation: 'e',
                correct: i < correct)
        ];
    await progress.recordAttempt(
        topicId: boss.id, attemptId: 'fail', answers: answers(3));
    expect(progress.trophyIds, isNot(contains(boss.id)));
    await progress.recordAttempt(
        topicId: boss.id, attemptId: 'pass', answers: answers(4));
    expect(progress.trophyIds, contains(boss.id));
    expect(progress.trophyIds, {boss.id});
    final earnedAt = (progress.exportState()['trophies'] as Map)[boss.id];
    await progress.recordAttempt(
        topicId: boss.id, attemptId: 'pass', answers: answers(4));
    expect((progress.exportState()['trophies'] as Map)[boss.id], earnedAt);
    expect(
        boss.topics.every((t) => progress.evidenceFor(t.id) == null), isTrue);
    final restored = NorieAdventureProgress();
    await restored.load();
    expect(restored.trophyIds, contains(boss.id));
    final revision = restored.ownershipRevision;
    restored.applyValidatedState(NorieAdventureProgress.emptyState);
    expect(
        await restored.recordAttempt(
            topicId: boss.id,
            attemptId: 'stale',
            answers: answers(5),
            expectedRevision: revision),
        isFalse);
    expect(restored.trophyIds, isEmpty);
    final merged = NorieAdventureProgress.mergePermanent(
        restored.exportState(), progress.exportState());
    expect((merged['trophies'] as Map).keys, contains(boss.id));
  });
}
