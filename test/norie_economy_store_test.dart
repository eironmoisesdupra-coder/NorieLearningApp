import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';

const deviceA = '11111111-1111-4111-8111-111111111111';
const deviceB = '22222222-2222-4222-8222-222222222222';
Map<String, dynamic> legacy({int xp = 100, int credits = 80}) => {
      'total_xp': xp,
      'credits': credits,
      'owned_shop_items': <String>[],
      'streak_shields': 2,
    };
Map<String, dynamic> checkpoint(
        {int xp = 100,
        int credits = 80,
        int seq = 1,
        Map<String, int> devices = const {},
        List<String> claims = const []}) =>
    {
      'id': 'checkpoint-$seq',
      'epoch': 'epoch-one',
      'through_seq': seq,
      'total_xp': xp,
      'credits': credits,
      'owned_shop_items': <String>[],
      'streak_shields': 2,
      'claim_keys': claims,
      'device_sequences': devices,
    };
Map<String, dynamic> result(Map<String, dynamic> cp,
        {Map<String, dynamic>? reservation,
        List<String> accepted = const [],
        List<Map<String, dynamic>> rejected = const []}) =>
    {
      'version': 1,
      'checkpoint': cp,
      'reservation': reservation,
      'accepted': accepted,
      'rejected': rejected,
      'device_seq': 0,
      'must_recover': false,
    };

void main() {
  test('manual baseline-only legacy restore cannot erase an activated ledger',
      () async {
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    final old = store.exportState();
    await store.applyServerResult(result(checkpoint(xp: 300, credits: 40)),
        stillCurrent: () => true);
    store.applyValidatedState(old);
    expect(store.active, isTrue);
    expect(store.totalXp, 300);
    expect(store.credits, 40);
    await store.flush();
  });
  test('ordinary checkpoint imports cannot reopen a consumed local allowance',
      () async {
    final now = DateTime.utc(2026, 10, 17);
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        clock: () => now,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    final budget = <String, dynamic>{
      'id': 'budget-one',
      'device_id': deviceA,
      'limit': 30,
      'spent': 0,
      'shield_limit': 2,
      'shields_spent': 0,
      'expires_at': now.add(const Duration(days: 7)).toIso8601String()
    };
    await store.applyServerResult(result(checkpoint(), reservation: budget),
        stillCurrent: () => true);
    store.spend(20, requiresReservation: true);
    store.applyValidatedState({
      'version': 1,
      'baseline': store.baseline,
      'checkpoint': checkpoint(credits: 60, seq: 2, devices: {deviceA: 1}),
      'pending': []
    }, preserveLocalPending: true);
    expect(store.offlineCreditRemaining, 0);
    expect(store.reservation, isNull);
    await store.flush();
  });
  test('same reservation cannot regress cumulative settlement counters',
      () async {
    final now = DateTime.utc(2026, 10, 17);
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        clock: () => now,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    final budget = <String, dynamic>{
      'id': 'budget-one',
      'device_id': deviceA,
      'limit': 40,
      'spent': 20,
      'shield_limit': 2,
      'shields_spent': 1,
      'expires_at': now.add(const Duration(days: 7)).toIso8601String()
    };
    await store.applyServerResult(result(checkpoint(), reservation: budget),
        stillCurrent: () => true);
    final stale = {...budget, 'spent': 0};
    await expectLater(
        store.applyServerResult(result(checkpoint(seq: 2), reservation: stale),
            stillCurrent: () => true),
        throwsFormatException);
    expect(store.offlineCreditRemaining, 20);
  });
  test('corrupt economy is quarantined while legacy balances remain readable',
      () async {
    var writes = 0;
    final store = NorieEconomyStore(
        read: () async => 'broken json',
        write: (_) async {
          writes++;
          return true;
        },
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    expect(store.available, isFalse);
    await store.load(legacy(), force: true);
    expect(store.totalXp, 100);
    expect(store.credits, 80);
    expect(store.reward('lesson:one', xp: 10), isFalse);
    await expectLater(store.flush(retry: true), throwsStateError);
    expect(writes, 0);
    store.reset(legacy(xp: 20, credits: 10));
    await store.flush();
    expect(store.available, isTrue);
  });
  test('one atomic envelope survives restart over stale compatibility scalars',
      () async {
    String? disk;
    final store = NorieEconomyStore(
        read: () async => disk,
        write: (value) async {
          disk = value;
          return true;
        },
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    expect(store.reward('lesson:one', xp: 50, credits: 10), isTrue);
    expect(store.reward('lesson:one', xp: 50, credits: 10), isFalse);
    await store.flush();
    final restarted = NorieEconomyStore(
        read: () async => disk,
        write: (_) async => true,
        deviceIdFactory: () => deviceB);
    await restarted.load(legacy(xp: 0, credits: 0));
    expect(restarted.totalXp, 150);
    expect(restarted.credits, 90);
    expect(restarted.deviceId, deviceA);
    expect(restarted.nextSeq, 2);
    expect((jsonDecode(disk!) as Map)['pending'], hasLength(1));
  });
  test('failed writes remain sticky until an explicit durable retry', () async {
    var fail = true;
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => !fail,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    store.reward('lesson:one', xp: 10);
    await expectLater(store.flush(), throwsStateError);
    fail = false;
    store.reward('lesson:two', xp: 20);
    await expectLater(store.flush(), throwsStateError);
    await store.flush(retry: true);
    expect(store.lastError, isNull);
    expect(store.totalXp, 130);
  });
  test('portable backup cannot clone device identity or a spending allowance',
      () async {
    final now = DateTime.utc(2026, 10, 17);
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        clock: () => now,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    await store.applyServerResult(
        result(checkpoint(), reservation: {
          'id': 'budget-one',
          'device_id': deviceA,
          'limit': 80,
          'spent': 0,
          'shield_limit': 2,
          'shields_spent': 0,
          'expires_at': now.add(const Duration(days: 7)).toIso8601String(),
        }),
        stillCurrent: () => true);
    expect(store.spend(20, itemId: 'frame-one', requiresReservation: true),
        isTrue);
    expect(store.ownedShopItems, isNot(contains('frame-one')));
    final backup = store.exportState();
    expect(backup.keys,
        unorderedEquals(['version', 'baseline', 'checkpoint', 'pending']));
    final restored = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        clock: () => now,
        deviceIdFactory: () => deviceB);
    await restored.load(legacy());
    restored.applyValidatedState(backup);
    expect(restored.deviceId, deviceB);
    expect(restored.pendingOperations.first['device_id'], deviceA);
    expect(restored.offlineCreditRemaining, 0);
    expect(restored.spend(1, requiresReservation: true), isFalse);
    await store.flush();
    await restored.flush();
  });
  test('allowance excludes pending spends and expires at the exact boundary',
      () async {
    var now = DateTime.utc(2026, 10, 17);
    final expiry = now.add(const Duration(days: 7));
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        clock: () => now,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    await store.applyServerResult(
        result(checkpoint(), reservation: {
          'id': 'budget-one',
          'device_id': deviceA,
          'limit': 30,
          'spent': 0,
          'shield_limit': 1,
          'shields_spent': 0,
          'expires_at': expiry.toIso8601String(),
        }),
        stillCurrent: () => true);
    expect(store.spend(20, requiresReservation: true), isTrue);
    expect(store.offlineCreditRemaining, 10);
    expect(store.spend(11, requiresReservation: true), isFalse);
    now = expiry;
    expect(store.spend(1, requiresReservation: true), isFalse);
    expect(store.consumeShield(requiresReservation: true), isFalse);
    await store.flush();
  });
  test('server acceptance cannot compact an uncovered pending operation',
      () async {
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    store.reward('lesson:one', xp: 10);
    final operation = store.pendingOperations.single;
    await expectLater(
        store.applyServerResult(
            result(checkpoint(xp: 110), accepted: [operation['id'] as String]),
            stillCurrent: () => true),
        throwsFormatException);
    expect(store.pendingOperations, hasLength(1));
    expect(store.active, isFalse);
    await store.flush();
  });
  test('covered reward is projected exactly once after checkpoint and restart',
      () async {
    String? disk;
    final store = NorieEconomyStore(
        read: () async => disk,
        write: (v) async {
          disk = v;
          return true;
        },
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    store.reward('lesson:one', xp: 10, credits: 5);
    await store.applyServerResult(
        result(checkpoint(
            xp: 110,
            credits: 85,
            devices: {deviceA: 1},
            claims: ['lesson:one'])),
        stillCurrent: () => true);
    expect(store.pendingOperations, isEmpty);
    expect(store.totalXp, 110);
    expect(store.reward('lesson:one', xp: 10), isFalse);
    final restored = NorieEconomyStore(
        read: () async => disk,
        write: (_) async => true,
        deviceIdFactory: () => deviceB);
    await restored.load(legacy());
    expect(restored.totalXp, 110);
    expect(restored.credits, 85);
  });
  test('late account guard compensates a physical checkpoint write', () async {
    String? disk;
    var gated = false;
    var current = true;
    final started = Completer<void>();
    final release = Completer<void>();
    final store = NorieEconomyStore(
        read: () async => disk,
        write: (v) async {
          if (gated) {
            gated = false;
            started.complete();
            await release.future;
          }
          disk = v;
          return true;
        },
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    await store.flush();
    gated = true;
    final applying = store.applyServerResult(result(checkpoint(xp: 999)),
        stillCurrent: () => current);
    await started.future;
    current = false;
    release.complete();
    await applying;
    expect(store.totalXp, 100);
    expect(store.active, isFalse);
    expect((jsonDecode(disk!) as Map)['checkpoint'], isNull);
  });
}
