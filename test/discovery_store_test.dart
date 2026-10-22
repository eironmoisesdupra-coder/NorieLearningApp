import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/discovery/data/discovery_store.dart';
import 'package:norie_learning/features/discovery/domain/discovery_mission.dart';

class Memory {
  final values = <String, String>{};
  final owner = ValueNotifier<String?>(null);
  bool fail = false;
  Completer<void>? pause;
  DiscoveryStore store() => DiscoveryStore(
      ownerId: () => owner.value,
      ownerChanges: owner,
      read: (key) async => values[key],
      write: (key, value) async {
        await pause?.future;
        if (fail) throw StateError('storage unavailable');
        values[key] = value;
      });
}

Future<void> complete(DiscoveryStore store) async {
  for (final clue in DiscoveryClue.values) {
    expect(await store.inspect(clue), true);
  }
  expect(await store.continueMission(), true);
  expect(await store.runTrial(warm: true), true);
  expect(await store.runTrial(warm: false), true);
  expect(await store.continueMission(), true);
  expect(
      await store.conclude(
          evaporation: true, evidence: DiscoveryEvidence.controlledComparison),
      true);
  expect(await store.applyAnswer(correct: true), true);
}

void main() {
  test('restart and reload preserve revision lifetime assistance and attempts',
      () async {
    final m = Memory();
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    await s.requestHint();
    for (final c in DiscoveryClue.values) {
      await s.inspect(c);
    }
    await s.continueMission();
    await s.runTrial(warm: true);
    await s.runTrial(warm: false);
    await s.continueMission();
    await s.conclude(
        evaporation: true, evidence: DiscoveryEvidence.controlledComparison);
    await s.applyAnswer(correct: false);
    await s.reset();
    final reloaded = m.store();
    addTearDown(reloaded.dispose);
    await reloaded.initialize();
    expect(reloaded.assisted, true);
    expect(reloaded.applicationAttempts, 1);
    await complete(reloaded);
    expect(reloaded.journalEntry!['assisted'], true);
    expect(reloaded.journalEntry!['attempts'], 2);
  });

  test('failed stale-write compensation quarantines completion until recovery',
      () async {
    final owner = ValueNotifier<String?>('review-recovery-A');
    addTearDown(owner.dispose);
    final values = <String, String>{};
    final wrote = Completer<void>(), release = Completer<void>();
    bool completing = false, failRecovery = true;
    int phase = 0;
    DiscoveryStore create() => DiscoveryStore(
        ownerId: () => owner.value,
        ownerChanges: owner,
        read: (key) async => values[key],
        write: (key, value) async {
          if (completing && phase++ == 0) {
            values[key] = value;
            wrote.complete();
            await release.future;
            return;
          }
          if (completing && failRecovery) {
            throw StateError('recovery disk error');
          }
          values[key] = value;
        });
    final s = create();
    addTearDown(s.dispose);
    await s.initialize();
    for (final c in DiscoveryClue.values) {
      await s.inspect(c);
    }
    await s.continueMission();
    await s.runTrial(warm: true);
    await s.runTrial(warm: false);
    await s.continueMission();
    await s.conclude(
        evaporation: true, evidence: DiscoveryEvidence.controlledComparison);
    completing = true;
    final saved = s.applyAnswer(correct: true);
    await wrote.future;
    owner.value = 'review-recovery-B';
    owner.value = 'review-recovery-A';
    release.complete();
    expect(await saved, false);
    await s.initialize();
    final blocked = !s.ready &&
        s.error != null &&
        !s.state.complete &&
        s.journalEntry == null;
    // Recover before assertions so a failing regression cannot contaminate
    // unrelated tests through the deliberately retained owner recovery queue.
    failRecovery = false;
    await s.retry();
    expect(blocked, true);
    expect(s.state.stage, DiscoveryStage.apply);
    expect(s.journalEntry, isNull);
    expect(await s.applyAnswer(correct: true), true);
  });

  test('another owner is not marked busy by an old generation save', () async {
    final m = Memory();
    m.owner.value = 'A';
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    m.pause = Completer<void>();
    final saved = s.inspect(DiscoveryClue.dryTable);
    await Future<void>.delayed(Duration.zero);
    m.owner.value = 'B';
    await s.initialize();
    final busy = s.busy;
    m.pause!.complete();
    await saved;
    expect(busy, false);
  });

  test('retry never replays the previous learners failed action', () async {
    String? owner = 'A';
    final values = <String, String>{};
    bool fail = true;
    final s = DiscoveryStore(
        ownerId: () => owner,
        read: (key) async => values[key],
        write: (key, value) async {
          if (fail) throw StateError('disk');
          values[key] = value;
        });
    addTearDown(s.dispose);
    await s.initialize();
    await s.inspect(DiscoveryClue.dryTable);
    owner = 'B';
    fail = false;
    await s.retry();
    expect(s.state.clues, isEmpty);
    expect(values, isEmpty);
  });

  test('saved observations resume for the same owner only', () async {
    final m = Memory();
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    await s.inspect(DiscoveryClue.dryTable);
    final reloaded = m.store();
    addTearDown(reloaded.dispose);
    await reloaded.initialize();
    expect(reloaded.state.clues, {DiscoveryClue.dryTable});
    m.owner.value = 'B';
    await s.initialize();
    expect(s.state.clues, isEmpty);
    m.owner.value = null;
    await s.initialize();
    expect(s.state.clues, {DiscoveryClue.dryTable});
  });

  test('completion and replay retain one journal entry without economy data',
      () async {
    final m = Memory();
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    await complete(s);
    final entry = s.journalEntry;
    expect(entry, isNotNull);
    expect(await s.applyAnswer(correct: true), false);
    expect(await s.reset(), true);
    expect(s.state.stage, DiscoveryStage.inspect);
    await complete(s);
    expect(s.journalEntry, entry);
    final raw = m.values.values.single;
    expect(raw, isNot(contains('credits')));
    expect(raw, isNot(contains('totalXp')));
    expect(raw, isNot(contains('mastery')));
  });

  test('failed completion never displays a durable journal; retry is once-only',
      () async {
    final m = Memory();
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    for (final clue in DiscoveryClue.values) {
      await s.inspect(clue);
    }
    await s.continueMission();
    await s.runTrial(warm: true);
    await s.runTrial(warm: false);
    await s.continueMission();
    await s.conclude(
        evaporation: true, evidence: DiscoveryEvidence.controlledComparison);
    m.fail = true;
    expect(await s.applyAnswer(correct: true), false);
    expect(s.state.complete, false);
    expect(s.journalEntry, isNull);
    expect(s.error, isNotNull);
    m.fail = false;
    expect(await s.retry(), true);
    expect(s.state.complete, true);
    expect(s.journalEntry, isNotNull);
  });

  test('A to B to A while a write is pending rejects stale continuation',
      () async {
    final m = Memory();
    m.owner.value = 'A';
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    m.pause = Completer<void>();
    final saving = s.inspect(DiscoveryClue.dryTable);
    await Future<void>.delayed(Duration.zero);
    m.owner.value = 'B';
    m.owner.value = 'A';
    m.pause!.complete();
    expect(await saving, false);
    await s.initialize();
    // The old generation must compensate its uncancellable write before A's
    // new generation reloads; no new-generation evidence is manufactured.
    expect(m.values.keys.every((k) => !k.contains('account.B')), true);
    expect(s.journalEntry, isNull);
    expect(s.ready, true);
    expect(s.state.clues, isEmpty);
  });

  test('temporary mode cannot race a still-pending initial read', () async {
    final read = Completer<String?>();
    final s = DiscoveryStore(
        ownerId: () => null, read: (_) => read.future, write: (_, __) async {});
    addTearDown(s.dispose);
    final loaded = s.initialize();
    s.continueTemporarily();
    final temporary = s.temporary, ready = s.ready;
    read.complete(null);
    await loaded;
    expect(temporary, false);
    expect(ready, false);
    expect(s.ready, true);
  });

  test('corrupt data is retained and temporary play never overwrites it',
      () async {
    final m = Memory();
    m.values[DiscoveryStore.storageKeyFor(null)] = '{broken';
    final s = m.store();
    addTearDown(s.dispose);
    await s.initialize();
    expect(s.ready, false);
    expect(s.error, isNotNull);
    expect(await s.inspect(DiscoveryClue.dryTable), false);
    s.continueTemporarily();
    expect(s.temporary, true);
    expect(await s.inspect(DiscoveryClue.dryTable), true);
    expect(m.values.values.single, '{broken');
  });

  test('owner mismatch and oversized envelopes are rejected before mutation',
      () async {
    final m = Memory();
    final original = m.store();
    await original.initialize();
    await original.inspect(DiscoveryClue.dryTable);
    original.dispose();
    final key = DiscoveryStore.storageKeyFor(null);
    final raw = jsonDecode(m.values[key]!) as Map<String, dynamic>;
    m.values[key] = jsonEncode({...raw, 'owner': 'other'});
    final wrong = m.store();
    addTearDown(wrong.dispose);
    await wrong.initialize();
    expect(wrong.ready, false);
    expect(wrong.state.clues, isEmpty);
    m.values[key] = 'x' * 32769;
    final large = m.store();
    addTearDown(large.dispose);
    await large.initialize();
    expect(large.ready, false);
    expect(large.state.complete, false);
  });

  test('two live clients serialize fresh evidence instead of losing clues',
      () async {
    final m = Memory();
    final a = m.store();
    final b = m.store();
    addTearDown(a.dispose);
    addTearDown(b.dispose);
    await a.initialize();
    await b.initialize();
    await Future.wait([
      a.inspect(DiscoveryClue.dryTable),
      b.inspect(DiscoveryClue.openContainer)
    ]);
    final fresh = m.store();
    addTearDown(fresh.dispose);
    await fresh.initialize();
    expect(fresh.state.clues,
        {DiscoveryClue.dryTable, DiscoveryClue.openContainer});
  });

  test('accepted save can finish after navigation disposes its store',
      () async {
    final m = Memory();
    final s = m.store();
    await s.initialize();
    m.pause = Completer<void>();
    final saved = s.inspect(DiscoveryClue.dryTable);
    await Future<void>.delayed(Duration.zero);
    s.dispose();
    m.pause!.complete();
    await saved;
    final fresh = m.store();
    addTearDown(fresh.dispose);
    await fresh.initialize();
    expect(fresh.state.clues, {DiscoveryClue.dryTable});
  });
}
