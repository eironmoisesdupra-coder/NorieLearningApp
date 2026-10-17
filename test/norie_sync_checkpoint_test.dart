import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';
import 'norie_economy_store_test.dart'
    show legacy, checkpoint, result, deviceA, deviceB;

void main() {
  test(
      'claim tombstone suppresses projection but keeps operation until origin sequence covered',
      () async {
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    store.reward('lesson:shared', xp: 10);
    await store.applyServerResult(
        result(checkpoint(xp: 110, claims: ['lesson:shared'])),
        stillCurrent: () => true);
    expect(store.totalXp, 110);
    expect(store.pendingOperations, hasLength(1));
    await store.applyServerResult(
        result(checkpoint(
            xp: 110, seq: 2, claims: ['lesson:shared'], devices: {deviceA: 1})),
        stillCurrent: () => true);
    expect(store.pendingOperations, isEmpty);
  });
  test('server checkpoint write failure keeps pending operations recoverable',
      () async {
    var fail = false;
    String? disk;
    final store = NorieEconomyStore(
        read: () async => disk,
        write: (v) async {
          if (fail) return false;
          disk = v;
          return true;
        },
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    store.reward('lesson:one', xp: 10);
    await store.flush();
    fail = true;
    await expectLater(
        store.applyServerResult(
            result(checkpoint(xp: 110, devices: {deviceA: 1})),
            stillCurrent: () => true),
        throwsStateError);
    expect(store.pendingOperations, hasLength(1));
    expect(store.active, isFalse);
    fail = false;
    await store.flush(retry: true);
    final restarted = NorieEconomyStore(
        read: () async => disk,
        write: (_) async => true,
        deviceIdFactory: () => deviceB);
    await restarted.load(legacy(xp: 0, credits: 0));
    expect(restarted.totalXp, 110);
    expect(restarted.pendingOperations, hasLength(1));
  });
  test(
      'concurrent reward during checkpoint I/O is included in durable envelope',
      () async {
    var gated = false;
    String? disk;
    final started = Completer<void>(), release = Completer<void>();
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
    store.reward('lesson:one', xp: 10);
    await store.flush();
    gated = true;
    final applying = store.applyServerResult(
        result(checkpoint(xp: 110, devices: {deviceA: 1})),
        stillCurrent: () => true);
    await started.future;
    store.reward('lesson:two', xp: 20);
    release.complete();
    await applying;
    await store.flush();
    expect(store.totalXp, 130);
    expect(store.pendingOperations, hasLength(1));
    final envelope = jsonDecode(disk!) as Map;
    expect(envelope['checkpoint']['total_xp'], 110);
    expect(envelope['pending'], hasLength(1));
  });
  test(
      'retired origin rotation is durable while pending reward identities remain unchanged',
      () async {
    var factory = deviceA;
    String? disk;
    final store = NorieEconomyStore(
        read: () async => disk,
        write: (v) async {
          disk = v;
          return true;
        },
        deviceIdFactory: () => factory);
    await store.load(legacy());
    store.reward('lesson:one', xp: 10);
    final old = store.pendingOperations.single;
    factory = deviceB;
    await store.recoverRetiredDevice(stillCurrent: () => true);
    expect(store.deviceId, deviceB);
    expect(store.nextSeq, 1);
    expect(store.pendingOperations.single, old);
    expect((jsonDecode(disk!) as Map)['device_id'], deviceB);
  });
  test('older checkpoints and differing epochs cannot replace a durable ledger',
      () async {
    final store = NorieEconomyStore(
        read: () async => null,
        write: (_) async => true,
        deviceIdFactory: () => deviceA);
    await store.load(legacy());
    await store.applyServerResult(result(checkpoint(seq: 2)),
        stillCurrent: () => true);
    await expectLater(
        store.applyServerResult(result(checkpoint(seq: 1)),
            stillCurrent: () => true),
        throwsFormatException);
    final other = checkpoint(seq: 3);
    other['epoch'] = 'other';
    await expectLater(
        store.applyServerResult(result(other), stillCurrent: () => true),
        throwsFormatException);
    store.applyLegacy(legacy(xp: 9999, credits: 9999));
    expect(store.totalXp, 100);
  });
}
