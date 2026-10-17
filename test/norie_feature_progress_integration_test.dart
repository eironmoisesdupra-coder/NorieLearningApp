import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_progress_backup.dart';
import 'package:norie_learning/core/sync/norie_sync_event_journal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final progress = NorieProgression.instance;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await progress.load();
    await progress.resetForNewAccount();
  });
  tearDown(() async => progress.flushPendingSaves(retry: true));
  test('new feature state participates in portable backups and restart',
      () async {
    progress.recordLessonCompletion(
        quizScore: 1, challengeScore: 0, topicId: 'science.g1.test');
    final state = progress.exportCloudState();
    expect(
        state.keys,
        containsAll(
            ['sync_event_journal', 'classroom_state', 'seasonal_state']));
    expect(NorieSyncEventJournal.instance.permanentFacts['lesson_completed'],
        contains('science.g1.test'));
    final encoded = NorieProgressBackup.encode(state);
    expect(NorieProgressBackup.decode(encoded), state);
    await progress.flushPendingSaves();
    await progress.load();
    expect(progress.exportCloudState()['sync_event_journal'],
        state['sync_event_journal']);
  });
  test('bad optional journal never prevents the offline library loading',
      () async {
    await progress.flushPendingSaves(retry: true);
    SharedPreferences.setMockInitialValues(
        {'norie.sync.events.v1': '{broken', 'norie.totalXp': 87});
    await progress.load();
    expect(progress.totalXp, 87);
    await expectLater(progress.flushPendingSaves(), throwsStateError);
    await progress.resetForNewAccount();
  });
  test('legacy import preserves balances without replay and accepts new work',
      () async {
    final legacy = {
      ...progress.exportCloudState(),
      'total_xp': 123,
      'credits': 17
    };
    for (final key in [
      'sync_event_journal',
      'classroom_state',
      'seasonal_state'
    ]) {
      legacy.remove(key);
    }
    expect(await progress.importCloudState(legacy), true);
    expect(progress.totalXp, 123);
    expect(progress.credits, 17);
    expect(NorieSyncEventJournal.instance.events, isEmpty);
    progress.addXp(5);
    await progress.flushPendingSaves();
    expect(progress.totalXp, 128);
    expect(await progress.importCloudState(progress.exportCloudState()), true);
    expect(progress.totalXp, 128,
        reason: 'Import never replays numeric awards');
  });
  test(
      'failed optional load blocks retry before damaged seasonal storage is overwritten',
      () async {
    await progress.flushPendingSaves(retry: true);
    SharedPreferences.setMockInitialValues({
      'norie.seasonal.v1.guest': '{damaged-seasonal',
      'norie.totalXp': 87,
    });
    await progress.load();
    expect(progress.totalXp, 87);
    await expectLater(
        progress.flushPendingSaves(retry: true), throwsStateError);
    expect(
        (await SharedPreferences.getInstance())
            .getString('norie.seasonal.v1.guest'),
        '{damaged-seasonal');
    await progress.resetForNewAccount();
  });
  test(
      'assessment receipts and completed lesson facts survive same-owner merge once',
      () async {
    final base = progress.exportCloudState();
    expect(progress.claimAssessmentAttempt('a:attempt'), true);
    progress.recordLessonCompletion(
        quizScore: 1, challengeScore: 0, topicId: 'lesson-a');
    progress.addXp(25);
    final a = progress.exportCloudState();
    await progress.importCloudState(base);
    expect(progress.claimAssessmentAttempt('b:attempt'), true);
    progress.recordLessonCompletion(
        quizScore: 1, challengeScore: 0, topicId: 'lesson-b');
    progress.addXp(40);
    final b = progress.exportCloudState();
    final ab = NorieProgression.mergePermanentCollections(a, b);
    final ba = NorieProgression.mergePermanentCollections(b, a);
    expect(ab['sync_event_journal'], ba['sync_event_journal']);
    expect(ab['total_xp'], 40,
        reason:
            'Legacy scalar read model remains conservative, not additive replay');
    expect(ab['completed_topic_ids'], containsAll(['lesson-a', 'lesson-b']));
    await progress.importCloudState(ab);
    expect(progress.claimAssessmentAttempt('a:attempt'), false);
    expect(progress.claimAssessmentAttempt('b:attempt'), false);
    final before = progress.totalXp;
    await progress
        .importCloudState(NorieProgression.mergePermanentCollections(ab, ba));
    expect(progress.totalXp, before);
  });
  test('bad journal is rejected before changing existing learning state',
      () async {
    progress.addXp(17);
    final bad = {
      ...progress.exportCloudState(),
      'total_xp': 500,
      'sync_event_journal': {
        'version': 1,
        'events': ['invalid']
      }
    };
    await expectLater(progress.importCloudState(bad), throwsFormatException);
    expect(progress.totalXp, 17);
  });
  test('account reset clears all extension data and rejects late restore',
      () async {
    progress.recordLessonCompletion(
        quizScore: 1, challengeScore: 0, topicId: 'private-old-owner');
    final old = progress.exportCloudState();
    expect(await progress.resetForNewAccount(), true);
    expect(NorieSyncEventJournal.instance.events, isEmpty);
    expect(
        await progress.importCloudState(old, stillCurrent: () => false), false);
    expect(progress.completedTopicIds, isEmpty);
  });
}
