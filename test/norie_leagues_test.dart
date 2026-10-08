import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/leaderboards/data/norie_league_cache.dart';
import 'package:norie_learning/features/leaderboards/domain/norie_league_models.dart';
import 'package:norie_learning/features/leaderboards/presentation/norie_leaderboards_screen.dart';
import 'package:norie_learning/core/quiz/quiz_result_history.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';

class _FailingLeaguePreferences extends InMemorySharedPreferencesStore {
  _FailingLeaguePreferences() : super.empty();
  @override
  Future<bool> setValue(String type, String key, Object value) async => false;
  @override
  Future<bool> remove(String key) async => false;
}

NorieLeagueSnapshot board(String nickname) => NorieLeagueSnapshot(
        cohortId: 'private',
        title: 'Private Science',
        subject: 'science',
        grade: 'g1',
        seasonEnd: DateTime.utc(2026, 11),
        fetchedAt: DateTime.utc(2026, 10, 8),
        rows: [
          NorieLeagueRow(
              memberId: 'one', nickname: nickname, points: 10, isMe: true)
        ]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
      'false cache writes fail visibly and do not retain optimistic saved standings',
      () async {
    final store = _FailingLeaguePreferences();
    SharedPreferencesStorePlatform.instance = store;
    final cache = NorieLeagueCache();
    await expectLater(
        cache.write('account-a', [board('Learner abc123')]), throwsStateError);
    expect(await cache.read('account-a'), isEmpty);
    await expectLater(
        cache.writeBadges(
            'account-a',
            NorieLeagueBadgeShelf(
                fetchedAt: DateTime.utc(2026, 10, 8), badges: const [])),
        throwsStateError);
    expect(await cache.readBadges('account-a'), isNull);
    await expectLater(cache.clear('account-a'), throwsStateError);
    expect(await store.getAll(), isEmpty);
  });
  test(
      'cache isolates guest and account standings, preserves refresh timestamp',
      () async {
    final cache = NorieLeagueCache();
    await cache.write('account-a', [board('Learner abc123')]);
    expect(await cache.read('account-b'), isEmpty);
    expect(await cache.read('guest'), isEmpty);
    final restored = (await cache.read('account-a')).single;
    expect(restored.fetchedAt, DateTime.utc(2026, 10, 8));
    expect(restored.rows.single.nickname, 'Learner abc123');
    await cache.clear('account-a');
    expect(await cache.read('account-a'), isEmpty);
  });
  test('malformed cache is empty and never fabricated as a board', () async {
    SharedPreferences.setMockInitialValues(
        {NorieLeagueCache.keyFor('account-a'): '{broken'});
    expect(await NorieLeagueCache().read('account-a'), isEmpty);
  });
  test('rank ties and nearby positions always include the current member', () {
    final rows = List.generate(
        20,
        (i) => NorieLeagueRow(
            memberId: '$i',
            nickname: 'Learner $i',
            points: (20 - i) * 10,
            isMe: i == 15));
    final nearby = nearbyLeagueRows(rows);
    expect(nearby.length, 5);
    expect(nearby.any((r) => r.isMe), isTrue);
    expect(leagueRank(rows, rows[15]), 16);
    final tied = [
      const NorieLeagueRow(memberId: 'a', nickname: 'A', points: 10),
      const NorieLeagueRow(memberId: 'b', nickname: 'B', points: 10),
      const NorieLeagueRow(memberId: 'c', nickname: 'C', points: 0)
    ];
    expect(tied.map((r) => leagueRank(tied, r)), [1, 1, 3]);
  });
  test(
      'tier thresholds do not change account XP and permanent badge cache is owner isolated',
      () async {
    expect(NorieLeagueTier.forPoints(19).title, 'Explorer');
    expect(NorieLeagueTier.forPoints(20).title, 'Pathfinder');
    expect(NorieLeagueTier.forPoints(30).title, 'Scholar');
    expect(NorieLeagueTier.forPoints(40).title, 'Specialist');
    expect(NorieLeagueTier.forPoints(60).nextFloor, isNull);
    final cache = NorieLeagueCache();
    final badge = NorieLeagueBadge(
        id: 'badge',
        cohortId: 'private',
        seasonId: 'season',
        tier: 'Explorer',
        title: 'Explorer league emblem',
        earnedAt: DateTime.utc(2026, 10, 8));
    await cache.writeBadges(
        'account-a',
        NorieLeagueBadgeShelf(
            fetchedAt: DateTime.utc(2026, 10, 9), badges: [badge]));
    expect(await cache.readBadges('account-b'), isNull);
    expect((await cache.readBadges('account-a'))!.badges.single.title,
        'Explorer league emblem');
    await cache.clear('account-a');
    expect((await cache.readBadges('account-a'))!.badges.single.id, 'badge',
        reason: 'Deleting a display preserves earned emblems');
  });
  testWidgets(
      '320px large text keeps guest bests and every private league tab usable',
      (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({
      QuizResultHistory.storageKey: jsonEncode([
        {
          'id': 'local-attempt',
          'key': jsonEncode([
            'Living things practice',
            ['q1', 'q2']
          ]),
          'percentage': 80
        },
      ])
    });
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!),
        home: const NorieLeaderboardsScreen()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Living things practice'), 200);
    expect(find.text('80%'), findsOneWidget);
    expect(find.textContaining('verified seasonal points'), findsNothing);
    for (final tab in [
      'Subject Rankings',
      'Friends / Class',
      'Hall of Achievements',
      'My League'
    ]) {
      await tester.scrollUntilVisible(find.text(tab).hitTestable(), -100);
      await tester.tap(find.text(tab).hitTestable());
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, tab))
              .selected,
          isTrue);
      expect(tester.takeException(), isNull,
          reason: '$tab must work at 320px with large text');
    }
  });
  testWidgets('guest screen does not display another account cached standings',
      (tester) async {
    await NorieLeagueCache()
        .write('different-account', [board('Learner abc123')]);
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark, home: const NorieLeaderboardsScreen()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Learner abc123'), findsNothing);
    expect(find.textContaining('approved account'), findsOneWidget);
  });
}
