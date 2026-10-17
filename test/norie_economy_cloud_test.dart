import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/sync/norie_economy_cloud.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';

class _Store extends NorieEconomyStore {
  final log = <String>[];
  Map<String, dynamic>? savedCheckpoint;
  String identity = '00000000-0000-0000-0000-000000000011';
  @override
  String get deviceId => identity;
  @override
  Map<String, dynamic> get baseline => {'total_xp': 100, 'credits': 0};
  @override
  Map<String, dynamic>? get checkpoint => savedCheckpoint;
  @override
  List<Map<String, dynamic>> get pendingOperations => [];
  @override
  Future<void> flush({bool retry = false}) async {
    log.add('flush');
  }

  @override
  Future<void> recoverRetiredDevice(
      {required bool Function() stillCurrent}) async {
    if (stillCurrent()) identity = '00000000-0000-0000-0000-000000000012';
    log.add('rotate');
  }
}

void main() {
  final cp = <String, dynamic>{
    'epoch': 'epoch',
    'id': 'epoch:1',
    'through_seq': 1
  };
  test(
      'checkpoint reaches durable storage before acknowledgment and compaction',
      () async {
    final store = _Store();
    final adapter = NorieEconomyCloud(
        store: store,
        legacyState: () => {
              'total_xp': 150,
              'economy_state': {'private': true}
            },
        rpc: (name, parameters) async {
          store.log.add(name);
          if (name == 'norie_economy_sync') {
            expect((parameters['p_baseline'] as Map)['total_xp'], 100);
            expect(
                ((parameters['p_baseline'] as Map)['legacy_state'] as Map)
                    .containsKey('economy_state'),
                false);
            return {'checkpoint': cp, 'must_recover': false};
          }
          if (name == 'norie_economy_ack') {
            expect(store.savedCheckpoint, cp);
            return true;
          }
          return {};
        },
        apply: (result, current) async {
          expect(current(), true);
          store.log.add('persist');
          store.savedCheckpoint = cp;
        });
    await adapter.reconcile('learner', () => true);
    expect(store.log, [
      'flush',
      'norie_economy_sync',
      'persist',
      'flush',
      'norie_economy_ack',
      'norie_economy_compact'
    ]);
  });

  test('failed durable application never acknowledges or compacts', () async {
    final calls = <String>[];
    final adapter = NorieEconomyCloud(
        store: _Store(),
        legacyState: () => {},
        rpc: (name, parameters) async {
          calls.add(name);
          return {'checkpoint': cp};
        },
        apply: (result, current) async {
          throw StateError('disk full');
        });
    await expectLater(
        adapter.reconcile('learner', () => true), throwsStateError);
    expect(calls, ['norie_economy_sync']);
  });

  test('account switch during request cannot apply or acknowledge old learner',
      () async {
    var current = true;
    var applied = false;
    final calls = <String>[];
    final adapter = NorieEconomyCloud(
        store: _Store(),
        legacyState: () => {},
        rpc: (name, parameters) async {
          calls.add(name);
          current = false;
          return {'checkpoint': cp};
        },
        apply: (result, guard) async {
          applied = true;
        });
    await adapter.reconcile('learner', () => current);
    expect(applied, false);
    expect(calls, ['norie_economy_sync']);
  });

  test(
      'retired installation rotates before retry and never acknowledges retired identity',
      () async {
    final store = _Store();
    var syncs = 0;
    final adapter = NorieEconomyCloud(
        store: store,
        legacyState: () => {},
        rpc: (name, parameters) async {
          if (name == 'norie_economy_sync') {
            syncs++;
            return {'must_recover': syncs == 1, 'checkpoint': cp};
          }
          if (name == 'norie_economy_ack') {
            expect(parameters['p_device_id'], endsWith('12'));
            return true;
          }
          return {};
        },
        apply: (result, guard) async {
          store.savedCheckpoint = cp;
        });
    await adapter.reconcile('learner', () => true);
    expect(syncs, 2);
    expect(store.log, contains('rotate'));
  });
}
