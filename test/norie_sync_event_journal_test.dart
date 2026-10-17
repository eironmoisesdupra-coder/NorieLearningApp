import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/sync/norie_sync_event_journal.dart';

Map<String, dynamic> event(String id,
        {String entity = 'science-1',
        String at = '2026-10-17T00:00:00Z',
        Map<String, dynamic>? data}) =>
    {
      'id': id,
      'type': 'lesson_completed',
      'entity_id': entity,
      'occurred_at': at,
      'data': data ?? <String, dynamic>{},
    };
Map<String, dynamic> state(List<Map<String, dynamic>> events) =>
    {'version': 1, 'events': events};

void main() {
  test('explicit reload replaces a prior fixture without leaking old receipts',
      () async {
    String? disk = jsonEncode(state([event('old-owner')]));
    final journal = NorieSyncEventJournal(
        read: () async => disk,
        write: (value) async {
          disk = value;
          return true;
        });
    await journal.load();
    disk = null;
    await journal.load(force: true);
    expect(journal.events, isEmpty);
    journal.record(type: 'lesson_completed', entityId: 'new', eventId: 'new');
    await journal.flush();
    expect((jsonDecode(disk!)['events'] as List).single['id'], 'new');
  });
  test('restart restores immutable facts and stable receipt is idempotent',
      () async {
    String? disk;
    final journal = NorieSyncEventJournal(
        read: () async => disk,
        write: (value) async {
          disk = value;
          return true;
        });
    final nested = <String, dynamic>{
      'scores': <int>[2, 3]
    };
    final first = journal.record(
        type: 'lesson_completed',
        entityId: 'science-1',
        eventId: 'attempt-1',
        data: nested);
    (nested['scores'] as List<int>)[0] = 99;
    final duplicate = journal.record(
        type: 'lesson_completed',
        entityId: 'science-1',
        eventId: 'attempt-1',
        data: {
          'scores': [2, 3]
        });
    expect(identical(first, duplicate), isTrue);
    expect(() => (first.data['scores'] as List).add(4), throwsUnsupportedError);
    await journal.flush();
    final restarted =
        NorieSyncEventJournal(read: () async => disk, write: (_) async => true);
    await restarted.load();
    expect(restarted.events.single.data, {
      'scores': [2, 3]
    });
    expect(restarted.permanentFacts['lesson_completed'], ['science-1']);
  });

  test('merge converges independent of argument order and timestamp ties', () {
    final a = state([event('z'), event('a')]);
    final b = state([event('b'), event('a')]);
    final ab = NorieSyncEventJournal.merge(a, b);
    expect(ab, NorieSyncEventJournal.merge(b, a));
    expect((ab['events'] as List).map((e) => e['id']), ['a', 'b', 'z']);
    expect(NorieSyncEventJournal.merge(ab, ab), ab);
  });

  test('independent devices deduplicate a stable fact using earliest timestamp',
      () {
    final first = state([event('fact', at: '2026-10-17T01:00:00Z')]);
    final second = state([event('fact', at: '2026-10-17T02:00:00Z')]);
    final merged = NorieSyncEventJournal.merge(first, second);
    expect(merged, NorieSyncEventJournal.merge(second, first));
    expect((merged['events'] as List).single['occurred_at'],
        '2026-10-17T01:00:00.000Z');
    expect((merged['events'] as List).length, 1);
  });

  test(
      'a stable receipt recorded before loading retains its original disk time',
      () async {
    String? disk = jsonEncode(state([event('fact')]));
    final journal = NorieSyncEventJournal(
        read: () async => disk,
        write: (value) async {
          disk = value;
          return true;
        });
    journal.record(
        type: 'lesson_completed', entityId: 'science-1', eventId: 'fact');
    await journal.flush();
    expect(journal.events.single.occurredAt, DateTime.utc(2026, 10, 17));
    expect((jsonDecode(disk!)['events'] as List).length, 1);
  });

  test('journal byte bound rejects a union while each device fits individually',
      () {
    final first = state(
        List.generate(4200, (i) => event('a-$i', data: {'note': 'x' * 200})));
    final second = state(
        List.generate(4200, (i) => event('b-$i', data: {'note': 'x' * 200})));
    NorieSyncEventJournal.validateState(first);
    NorieSyncEventJournal.validateState(second);
    expect(() => NorieSyncEventJournal.merge(first, second),
        throwsFormatException);
  });

  test('conflicting event IDs fail in both directions before mutation',
      () async {
    final a = state([event('same')]);
    final b = state([event('same', entity: 'different')]);
    expect(() => NorieSyncEventJournal.merge(a, b), throwsFormatException);
    expect(() => NorieSyncEventJournal.merge(b, a), throwsFormatException);
    final journal =
        NorieSyncEventJournal(read: () async => null, write: (_) async => true);
    journal.applyValidatedState(a);
    expect(
        () => journal.record(
            type: 'lesson_completed', entityId: 'different', eventId: 'same'),
        throwsFormatException);
    expect(journal.events.single.entityId, 'science-1');
    await journal.flush();
  });

  test('strict schema rejects unknown keys, non-JSON and oversized data', () {
    for (final invalid in [
      {'version': 1, 'events': [], 'owner': 'untrusted'},
      state([
        {...event('a'), 'extra': true}
      ]),
      state([
        {...event('a'), 'type': 'arbitrary_reward'}
      ]),
      state([
        event('a', data: {'bad': double.nan})
      ]),
      state([
        event('a', data: {'bad': DateTime.utc(2026)})
      ]),
      state([
        event('a', data: {'large': 'x' * 20000})
      ]),
      state([event('a'), event('a')]),
    ]) {
      expect(() => NorieSyncEventJournal.validateState(invalid),
          throwsFormatException);
    }
  });

  test('union overflow preserves every accepted receipt and surfaces failure',
      () async {
    final full = state(List.generate(
        NorieSyncEventJournal.maxEvents, (i) => event('receipt-$i')));
    expect(() => NorieSyncEventJournal.merge(full, state([event('new')])),
        throwsFormatException);
    final journal =
        NorieSyncEventJournal(read: () async => null, write: (_) async => true);
    journal.applyValidatedState(full);
    expect(
        () => journal.record(
            type: 'lesson_completed', entityId: 'new', eventId: 'new'),
        throwsFormatException);
    expect(journal.events.length, NorieSyncEventJournal.maxEvents);
    expect(journal.lastError, isNotNull);
    await journal.flush();
  });

  test('write failure remains observable until explicit retry succeeds',
      () async {
    var success = false;
    String? disk;
    final journal = NorieSyncEventJournal(
        read: () async => null,
        write: (value) async {
          if (success) disk = value;
          return success;
        });
    journal.record(type: 'reward_claimed', entityId: 'reward-1', eventId: 'r1');
    await expectLater(journal.flush(), throwsStateError);
    expect(journal.hasPendingWrites, isTrue);
    success = true;
    journal.record(type: 'reward_claimed', entityId: 'reward-2', eventId: 'r2');
    await expectLater(journal.flush(), throwsStateError);
    await journal.flush(retry: true);
    expect(journal.hasPendingWrites, isFalse);
    expect(journal.lastError, isNull);
    expect((jsonDecode(disk!)['events'] as List).length, 2);
  });

  test('record during load unions disk state before saving', () async {
    final read = Completer<String?>();
    String? disk;
    final journal = NorieSyncEventJournal(
        read: () => read.future,
        write: (value) async {
          disk = value;
          return true;
        });
    final loading = journal.load();
    journal.record(type: 'lesson_completed', entityId: 'new', eventId: 'new');
    read.complete(jsonEncode(state([event('old')])));
    await loading;
    await journal.flush();
    expect(journal.events.map((e) => e.id), unorderedEquals(['old', 'new']));
    expect((jsonDecode(disk!)['events'] as List).length, 2);
  });

  test('reset invalidates delayed load and serializes behind old-account write',
      () async {
    final read = Completer<String?>();
    String? disk;
    final journal = NorieSyncEventJournal(
        read: () => read.future,
        write: (value) async {
          disk = value;
          return true;
        });
    final loading = journal.load();
    journal.reset();
    journal.record(
        type: 'season_reward_earned', entityId: 'b-reward', eventId: 'b');
    read.complete(jsonEncode(state([event('a')])));
    await loading;
    await journal.flush();
    expect(journal.events.map((e) => e.id), ['b']);
    expect((jsonDecode(disk!)['events'] as List).single['id'], 'b');

    final pending = Completer<void>();
    final started = Completer<void>();
    var hold = true;
    final second = NorieSyncEventJournal(
        read: () async => null,
        write: (value) async {
          if (hold) {
            hold = false;
            started.complete();
            await pending.future;
          }
          disk = value;
          return true;
        });
    second.record(type: 'lesson_completed', entityId: 'a', eventId: 'a');
    await started.future;
    second.reset();
    second.record(type: 'lesson_completed', entityId: 'b', eventId: 'b');
    pending.complete();
    await second.flush();
    expect((jsonDecode(disk!)['events'] as List).map((e) => e['id']), ['b']);
  });

  test('invalid disk is reported rather than overwritten by a new receipt',
      () async {
    var writes = 0;
    final journal = NorieSyncEventJournal(
        read: () async => '{broken',
        write: (_) async {
          writes++;
          return true;
        });
    journal.record(type: 'lesson_completed', entityId: 'new', eventId: 'new');
    await expectLater(journal.flush(), throwsFormatException);
    expect(writes, 0);
    expect(journal.hasPendingWrites, isTrue);
    expect(journal.lastError, isNotNull);
  });
}
