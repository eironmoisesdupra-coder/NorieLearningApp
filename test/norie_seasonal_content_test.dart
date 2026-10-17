import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/seasonal/data/norie_seasonal_catalog.dart';
import 'package:norie_learning/features/seasonal/data/norie_seasonal_store.dart';
import 'package:norie_learning/features/seasonal/domain/norie_seasonal_models.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  final season = NorieSeasonalCatalog.seasons.single;
  final completed = season.missions.expand((m) => m.topicIds).toSet();
  final now = DateTime.utc(2026, 10, 17);
  test('published missions resolve authored lessons in a single grade', () {
    expect(season.missions.map((m) => m.gradeId).toSet(), {'g1'});
    for (final m in season.missions) {
      final topics = NorieFoundationCurriculum.topicsFor(m.subject, m.gradeId);
      for (final id in m.topicIds) {
        expect(topics.where((t) => t.id == id), hasLength(1));
        expect(
            NorieFoundationCurriculum.isAuthored(
                topics.singleWhere((t) => t.id == id)),
            isTrue);
      }
    }
  });
  test('UTC start inclusive and end exclusive', () {
    expect(
        season.statusAt(
            season.startsAt.subtract(const Duration(microseconds: 1))),
        NorieSeasonStatus.upcoming);
    expect(season.statusAt(season.startsAt), NorieSeasonStatus.active);
    expect(season.statusAt(season.endsAt), NorieSeasonStatus.archived);
  });
  test('claims serialize, persist, survive restart and cannot claim archived',
      () async {
    final disk = <String, String>{};
    NorieSeasonalStore make() => NorieSeasonalStore(
        read: (k) async => disk[k],
        write: (k, v) async {
          disk[k] = v;
          return true;
        },
        clock: () => now);
    final s = make();
    await s.load();
    expect(
        await Future.wait(
            [s.claim(season, completed), s.claim(season, completed)]),
        [true, false]);
    final restarted = make();
    await restarted.load();
    expect(restarted.earnedRewards, {season.rewardId});
    final expired = NorieSeasonalStore(
        read: (k) async => null,
        write: (k, v) async => true,
        clock: () => season.endsAt);
    expect(await expired.claim(season, completed), isFalse);
  });
  test('failed save grants nothing and retry is safe', () async {
    var succeeds = false;
    final s = NorieSeasonalStore(
        read: (k) async => null,
        write: (k, v) async => succeeds,
        clock: () => now);
    await expectLater(s.claim(season, completed), throwsStateError);
    expect(s.earnedRewards, isEmpty);
    succeeds = true;
    expect(await s.claim(season, completed), isTrue);
  });
  test('load save races and A B A isolate owners and pending completions',
      () async {
    final disk = <String, String>{};
    final gate = Completer<void>();
    var block = true;
    final s = NorieSeasonalStore(
        read: (k) async {
          if (block) {
            block = false;
            await gate.future;
          }
          return disk[k];
        },
        write: (k, v) async {
          disk[k] = v;
          return true;
        },
        clock: () => now);
    s.bindOwner('A');
    final a = s.load();
    await Future<void>.delayed(Duration.zero);
    final pending = s.claim(season, completed);
    s.bindOwner('B');
    s.bindOwner('A');
    gate.complete();
    await a;
    expect(await pending, isFalse);
    expect(s.earnedRewards, isEmpty);
    expect(await s.claim(season, completed), isTrue);
    s.bindOwner('B');
    await s.load();
    expect(s.earnedRewards, isEmpty);
    s.bindOwner('A');
    await s.load();
    expect(s.earnedRewards, {season.rewardId});
  });
  test('portable backup validation and external guards preserve receipts',
      () async {
    final disk = <String, String>{};
    final s = NorieSeasonalStore(
        read: (k) async => disk[k],
        write: (k, v) async {
          disk[k] = v;
          return true;
        },
        clock: () => now);
    s.bindOwner('A');
    await s.claim(season, completed);
    final backup = s.exportState();
    await s.reset();
    expect(s.earnedRewards, isEmpty);
    await s.applyState(backup);
    expect(s.earnedRewards, {season.rewardId});
    s.bindOwner('B');
    expect(await s.applyState(backup, stillCurrent: () => false), isFalse);
    expect(s.earnedRewards, isEmpty);
    await s.applyState(backup);
    expect(s.earnedRewards, {season.rewardId});
    expect(
        () => NorieSeasonalStore.validatedState({
              'version': 1,
              'owner': 'B',
              'receipts': [{}]
            }),
        throwsFormatException);
  });
  test('flush queued behind a claim cannot overwrite its new receipt',
      () async {
    final reading = Completer<void>();
    final store = NorieSeasonalStore(
      read: (key) async {
        await reading.future;
        return null;
      },
      write: (key, value) async => true,
      clock: () => now,
    );
    final claim = store.claim(season, completed);
    final flushing = store.flush();
    reading.complete();
    expect(await claim, isTrue);
    await flushing;
    expect(store.earnedRewards, {season.rewardId});
  });
  test('flushing unchanged receipts never dirties progress listeners',
      () async {
    final store = NorieSeasonalStore(
        read: (key) async => null,
        write: (key, value) async => true,
        clock: () => now);
    await store.load();
    var notifications = 0;
    store.addListener(() => notifications++);
    await store.flush();
    expect(notifications, 0);
    await store.claim(season, completed);
    expect(notifications, 1);
    await store.flush();
    await store.flush();
    expect(notifications, 1);
  });
  test('late claim write after external account guard expires restores disk',
      () async {
    final entered = Completer<void>(), release = Completer<void>();
    final disk = <String, String>{};
    var current = true, first = true;
    final store = NorieSeasonalStore(
        read: (key) async => disk[key],
        write: (key, value) async {
          if (first) {
            first = false;
            entered.complete();
            await release.future;
          }
          disk[key] = value;
          return true;
        },
        clock: () => now);
    final claim = store.claim(season, completed, stillCurrent: () => current);
    await entered.future;
    current = false;
    release.complete();
    expect(await claim, isFalse);
    final restarted = NorieSeasonalStore(
        read: (key) async => disk[key], write: (key, value) async => true);
    await restarted.load();
    expect(restarted.earnedRewards, isEmpty);
  });
  test('new snapshot reset wins a claim already writing to disk', () async {
    final entered = Completer<void>(), release = Completer<void>();
    final disk = <String, String>{};
    var first = true;
    final store = NorieSeasonalStore(
        read: (key) async => disk[key],
        write: (key, value) async {
          if (first) {
            first = false;
            entered.complete();
            await release.future;
          }
          disk[key] = value;
          return true;
        },
        clock: () => now);
    final claim = store.claim(season, completed);
    await entered.future;
    store.applyValidatedState(NorieSeasonalStore.emptyState());
    release.complete();
    expect(await claim, isFalse);
    final restarted = NorieSeasonalStore(
        read: (key) async => disk[key], write: (key, value) async => true);
    await restarted.load();
    expect(restarted.earnedRewards, isEmpty);
  });
}
