import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/seasonal/data/norie_seasonal_catalog.dart';
import 'package:norie_learning/features/seasonal/data/norie_seasonal_store.dart';
import 'package:norie_learning/features/seasonal/presentation/norie_seasonal_hub_screen.dart';

void main() {
  final season = NorieSeasonalCatalog.seasons.single;
  final all = season.missions.expand((m) => m.topicIds).toSet();
  test('delayed save does not publish into B or a new A session', () async {
    final entered = Completer<void>(), release = Completer<void>();
    final disk = <String, String>{};
    final s = NorieSeasonalStore(
        read: (k) async => disk[k],
        write: (k, v) async {
          if (!entered.isCompleted) {
            entered.complete();
            await release.future;
          }
          disk[k] = v;
          return true;
        },
        clock: () => DateTime.utc(2026, 10, 17));
    s.bindOwner('A');
    final saving = s.claim(season, all);
    await entered.future;
    s.bindOwner('B');
    s.bindOwner('A');
    release.complete();
    expect(await saving, isFalse);
    expect(s.earnedRewards, isEmpty);
    await s.load();
    expect(s.earnedRewards, isEmpty);
  });
  test('sync apply invalidates queued loading; merge is commutative', () async {
    final a = Completer<void>();
    final disk = <String, String>{};
    final s = NorieSeasonalStore(read: (k) async {
      await a.future;
      return null;
    }, write: (k, v) async {
      disk[k] = v;
      return true;
    });
    final pending = s.load();
    await Future<void>.delayed(Duration.zero);
    final state = {
      'version': 1,
      'receipts': [
        {
          'season_id': season.id,
          'reward_id': season.rewardId,
          'claimed_at': '2026-10-17T00:00:00.000Z'
        }
      ]
    };
    final later = {
      'version': 1,
      'receipts': [
        {
          'season_id': season.id,
          'reward_id': season.rewardId,
          'claimed_at': '2026-10-18T00:00:00.000Z'
        }
      ]
    };
    s.applyValidatedState(state);
    a.complete();
    await pending;
    await s.flush();
    expect(s.earnedRewards, {season.rewardId});
    expect(NorieSeasonalStore.merge(state, later),
        NorieSeasonalStore.merge(later, state));
    expect(NorieSeasonalStore.merge(state, later), state);
    expect(s.exportState().containsKey('owner'), isFalse);
  });
  test('no reward for incomplete or upcoming missions; force rereads storage',
      () async {
    final disk = <String, String>{};
    var now = season.startsAt.subtract(const Duration(seconds: 1));
    final s = NorieSeasonalStore(
        read: (k) async => disk[k],
        write: (k, v) async {
          disk[k] = v;
          return true;
        },
        clock: () => now);
    expect(await s.claim(season, all), isFalse);
    now = season.startsAt;
    expect(await s.claim(season, {}), isFalse);
    await s.claim(season, all);
    disk.clear();
    await s.load(force: true);
    expect(s.earnedRewards, isEmpty);
  });
  testWidgets(
      '320px and 160 percent text: lessons open and active keepsake claims',
      (tester) async {
    tester.view.physicalSize = const Size(320, 880);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final s = NorieSeasonalStore(
        read: (k) async => null,
        write: (k, v) async => true,
        clock: () => DateTime.utc(2026, 10, 17));
    String? opened;
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: NorieSeasonalHubScreen(
            store: s,
            clock: () => DateTime.utc(2026, 10, 17),
            completedTopics: () => all,
            onOpenTopic: (t) => opened = t.id)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final lesson =
        find.byKey(const ValueKey('science.g1.living-nonliving-things'));
    await tester.scrollUntilVisible(lesson, 200);
    await tester.pumpAndSettle();
    await tester.tap(lesson);
    expect(opened, 'science.g1.living-nonliving-things');
    await tester.scrollUntilVisible(find.text('Claim keepsake'), 250);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Claim keepsake'));
    await tester.pumpAndSettle();
    expect(s.earnedRewards, {season.rewardId});
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    s.dispose();
  });
  testWidgets(
      'archive keeps lessons and earned reward but removes claim action',
      (tester) async {
    final s = NorieSeasonalStore(
        read: (k) async => null,
        write: (k, v) async => true,
        clock: () => DateTime.utc(2026, 10, 17));
    await s.claim(season, all);
    await tester.pumpWidget(MaterialApp(
        home: NorieSeasonalHubScreen(
            store: s, clock: () => season.endsAt, completedTopics: () => all)));
    await tester.pumpAndSettle();
    expect(find.text('Archived'), findsOneWidget);
    expect(find.text('Claim keepsake'), findsNothing);
    await tester.scrollUntilVisible(
        find.text('Keepsake earned: ${season.rewardLabel}'), 250);
    expect(find.text('Keepsake earned: ${season.rewardLabel}'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    s.dispose();
  });
}
