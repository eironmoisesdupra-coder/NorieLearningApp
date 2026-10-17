import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_progress_backup.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';

void main() {
  final progress = NorieProgression.instance;
  setUp(() async {
    progress.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await progress.resetForNewAccount();
  });
  tearDown(() => progress.flushPendingSaves());

  test('one assessment receipt persists exactly one combined reward', () async {
    expect(progress.reward('assessment:one', xp: 80, credits: 3), isTrue);
    expect(progress.reward('assessment:one', xp: 80, credits: 3), isFalse);
    await progress.flushPendingSaves();
    await progress.load();
    expect(progress.totalXp, 80);
    expect(progress.credits, 3);
    expect(NorieEconomyStore.instance.pendingOperations, hasLength(1));
    expect(progress.addXp(80, claimKey: 'assessment:one').amount, 0);
  });

  test('portable backup includes operations without funded device identity',
      () {
    progress.reward('card:deck:q', xp: 5, credits: 1);
    final state = progress.exportCloudState();
    final decoded =
        NorieProgressBackup.decode(NorieProgressBackup.encode(state));
    final economy = decoded['economy_state'] as Map;
    expect(economy['pending'], hasLength(1));
    expect(economy.containsKey('reservation'), isFalse);
    expect(economy.containsKey('device_id'), isFalse);
  });

  test('daily and weekly rewards use separate stable receipts', () {
    for (var day = 19; day <= 23; day++) {
      progress.recordChallengeCompletion(
          mode: NorieChallengeMode.daily,
          correct: 5,
          total: 5,
          completedAt: DateTime(2026, 10, day));
    }
    final claims = NorieEconomyStore.instance.pendingOperations
        .map((operation) => operation['claim_key'])
        .toSet();
    expect(claims, contains('weekly:2026-10-19'));
    expect(
        claims,
        containsAll(
            ['daily:2026-10-19', 'daily:2026-10-20', 'daily:2026-10-21']));
  });

  test('legacy scalar mirrors cannot inflate an imported operation envelope',
      () async {
    progress.reward('assessment:canonical', xp: 80, credits: 3);
    final state = progress.exportCloudState();
    state['total_xp'] = 9000;
    state['credits'] = 9000;
    await progress.importCloudState(state);
    expect(progress.totalXp, 80);
    expect(progress.credits, 3);
  });

  test('quarantined reward storage still permits saving lesson completion',
      () async {
    await progress.flushPendingSaves();
    final recovery = progress.exportCloudState()..remove('economy_state');
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(NorieEconomyStore.storageKey, '{broken');
    await progress.load();
    expect(NorieEconomyStore.instance.available, isFalse);
    final completion = progress.recordLessonCompletion(
        quizScore: 1, challengeScore: 0, topicId: 'science.offline.recovery');
    expect(completion.creditsAwarded, 0);
    expect(progress.addXp(10, claimKey: 'assessment:paused').amount, 0);
    expect(progress.completedTopicIds, contains('science.offline.recovery'));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(preferences.getInt('norie.completedLessons'), 1);
    expect(preferences.getString(NorieEconomyStore.storageKey), '{broken');
    await expectLater(progress.flushPendingSaves(), throwsStateError);
    expect(await progress.importCloudState(recovery, restoreEconomy: true),
        isTrue);
    expect(NorieEconomyStore.instance.available, isTrue);
  });
}
