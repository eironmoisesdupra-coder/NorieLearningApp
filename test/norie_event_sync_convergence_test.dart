import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/cloud/norie_cloud_sync.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';

Map<String, dynamic> _copy(Map<String, dynamic> value) =>
    Map<String, dynamic>.from(jsonDecode(jsonEncode(value)) as Map);

Object? _canonical(Object? value) {
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return {for (final key in keys) key: _canonical(value[key])};
  }
  if (value is List) return value.map(_canonical).toList();
  return value;
}

Map<String, dynamic> _snapshot({List<String> facts = const [], int xp = 0}) => {
      ..._copy(NorieProgression.instance.exportCloudState()),
      'total_xp': xp,
      'credits': 7,
      'modified_at': '2026-10-17T00:00:00Z',
      'sync_event_journal': {
        'version': 1,
        'events': [
          for (final fact in facts)
            {
              'id': fact,
              'type': 'lesson_completed',
              'entity_id': fact,
              'occurred_at': '2026-10-17T00:00:00Z',
              // Receipt metadata must never become an additional reward.
              'data': {'claimed_xp': 999},
            },
        ],
      },
    };

List<String> _factIds(Map<String, dynamic> state) =>
    (((state['sync_event_journal'] as Map)['events']) as List)
        .map((event) => event['id'] as String)
        .toList();

class _Changes extends ChangeNotifier {
  void emit() => notifyListeners();
}

/// Real production merge and coordinator with independent device snapshots.
/// The boundary models the database's owner check and atomic JSON comparison.
class _Device extends NorieCloudSyncBackend {
  _Device(this.server, this.local);
  final Map<String, Map<String, dynamic>> server;
  Map<String, dynamic> local;
  @override
  final _Changes accountChanges = _Changes();
  @override
  final _Changes accessChanges = _Changes();
  @override
  final _Changes progressionChanges = _Changes();
  @override
  bool get isConfigured => true;
  @override
  bool get isAllowed => true;
  @override
  String? userId = 'learner-a';
  String owner = 'learner-a';
  String? pendingRestore;
  Completer<void>? blockNextFetch;
  Completer<void>? fetchStarted;
  Future<void> Function()? beforeNextCas;
  int casCalls = 0;
  final writes = <String>[];
  Object? fetchError;

  @override
  DateTime get modifiedAt => DateTime.parse(local['modified_at'] as String);
  @override
  Map<String, dynamic> exportState() => _copy(local);
  @override
  Map<String, dynamic> mergePermanentCollections(
          Map<String, dynamic> primary, Map<String, dynamic> secondary) =>
      NorieProgression.mergePermanentCollections(primary, secondary);
  @override
  Future<Map<String, dynamic>?> fetchState(String user) async {
    if (fetchError != null) throw fetchError!;
    final captured = server[user] == null ? null : _copy(server[user]!);
    final gate = blockNextFetch;
    blockNextFetch = null;
    if (gate != null) {
      fetchStarted?.complete();
      await gate.future;
    }
    return captured == null
        ? null
        : {'state': captured, 'updated_at': '2026-10-17T00:00:00Z'};
  }

  @override
  Future<void> uploadState(
      String user, Map<String, dynamic> state, DateTime modified) async {
    throw StateError('Unconditional upload is forbidden.');
  }

  @override
  Future<bool> uploadStateIfUnchanged(String user, Map<String, dynamic> state,
      DateTime modified, Map<String, dynamic>? expectedState) async {
    casCalls++;
    final callback = beforeNextCas;
    beforeNextCas = null;
    await callback?.call();
    if (user != userId) throw StateError('learner_owner_mismatch');
    if (jsonEncode(_canonical(expectedState)) !=
        jsonEncode(_canonical(server[user]))) {
      return false;
    }
    server[user] = _copy(state);
    writes.add(user);
    return true;
  }

  @override
  Future<String?> readOwner() async => owner;
  @override
  Future<String?> readPendingRestore() async => pendingRestore;
  @override
  Future<void> writePendingRestore(
      String? user, bool Function() current) async {
    if (current()) pendingRestore = user;
  }

  @override
  Future<void> writeOwner(String user, bool Function() current) async {
    if (current()) owner = user;
  }

  @override
  Future<bool> importState(Map<String, dynamic> state, DateTime? modified,
      bool Function() current) async {
    if (!current()) return false;
    local = _copy(state);
    progressionChanges.emit();
    return true;
  }

  @override
  Future<void> resetState(bool Function() current) async {
    if (!current()) return;
    local = _snapshot();
    progressionChanges.emit();
  }

  void edit(Map<String, dynamic> state) {
    local = _copy(state);
    progressionChanges.emit();
  }

  void switchTo(String user) {
    userId = user;
    accountChanges.emit();
  }
}

void main() {
  test('two offline device journals converge without replaying XP or credits',
      () async {
    final server = {'learner-a': _snapshot()};
    final a = _Device(server, _snapshot());
    final b = _Device(server, _snapshot());
    final syncA = NorieCloudSync(backend: a);
    final syncB = NorieCloudSync(backend: b);
    addTearDown(syncA.dispose);
    addTearDown(syncB.dispose);
    await syncA.initialize();
    await syncB.initialize();
    a.edit(_snapshot(facts: ['a'], xp: 100));
    b.edit(_snapshot(facts: ['b'], xp: 200));
    await syncA.uploadLocal();
    await syncB.uploadLocal();
    await syncA.syncNow();
    for (final snapshot in [a.local, b.local, server['learner-a']!]) {
      expect(_factIds(snapshot), ['a', 'b']);
      expect(snapshot['total_xp'], 200,
          reason:
              'Migration retains guarded snapshot maximum, not scalar CRDT.');
      expect(snapshot['credits'], 7);
    }
    await syncA.syncNow();
    await syncB.syncNow();
    expect(_factIds(server['learner-a']!), ['a', 'b']);
    expect(server['learner-a']!['total_xp'], 200);
    expect(syncA.status, NorieCloudSyncStatus.synced);
    expect(syncB.status, NorieCloudSyncStatus.synced);
  });

  test(
      'CAS conflict refetch retains a third device receipt before acknowledgement',
      () async {
    final server = {'learner-a': _snapshot()};
    final device = _Device(server, _snapshot());
    final sync = NorieCloudSync(backend: device);
    addTearDown(sync.dispose);
    await sync.initialize();
    device.edit(_snapshot(facts: ['local'], xp: 100));
    server['learner-a'] = _snapshot(facts: ['remote'], xp: 150);
    final before = device.casCalls;
    device.beforeNextCas = () async {
      server['learner-a'] = _snapshot(facts: ['remote', 'third'], xp: 250);
    };
    await sync.uploadLocal();
    expect(device.casCalls - before, 2);
    expect(_factIds(server['learner-a']!), ['local', 'remote', 'third']);
    expect(_factIds(device.local), ['local', 'remote', 'third']);
    expect(server['learner-a']!['total_xp'], 250);
    expect(sync.status, NorieCloudSyncStatus.synced);
  });

  test(
      'an old-client core update preserves sidecar receipts without scalar replay',
      () async {
    final legacy = _snapshot(xp: 150)
      ..remove('sync_event_journal')
      ..remove('classroom_state')
      ..remove('seasonal_state');
    final upgraded = _snapshot(facts: ['new-client-fact'], xp: 100);
    final server = {'learner-a': legacy};
    final device = _Device(server, upgraded);
    final sync = NorieCloudSync(backend: device);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(_factIds(device.local), ['new-client-fact']);
    expect(device.local['total_xp'], 150);
    expect(_factIds(server['learner-a']!), ['new-client-fact']);
    expect(server['learner-a']!['credits'], 7);
  });

  test('A to B to A invalidates a delayed read from the first A session',
      () async {
    final server = {
      'learner-a': _snapshot(facts: ['old-a']),
      'learner-b': _snapshot(facts: ['private-b']),
    };
    final device = _Device(server, _snapshot());
    final sync = NorieCloudSync(backend: device);
    addTearDown(sync.dispose);
    await sync.initialize();
    final gate = Completer<void>();
    final started = Completer<void>();
    device.blockNextFetch = gate;
    device.fetchStarted = started;
    final pending = sync.syncNow();
    await started.future;
    device.switchTo('learner-b');
    device.switchTo('learner-a');
    server['learner-a'] = _snapshot(facts: ['old-a', 'latest-a']);
    gate.complete();
    await pending;
    await sync.syncNow();
    expect(_factIds(device.local), ['latest-a', 'old-a']);
    expect(_factIds(server['learner-b']!), ['private-b']);
    expect(device.writes, isNot(contains('learner-b')));
    expect(sync.status, NorieCloudSyncStatus.synced);
  });

  test('missing bundle RPC gives the migration action and never uploads',
      () async {
    final device = _Device({}, _snapshot())
      ..fetchError =
          StateError('Could not find public.norie_get_learner_bundle');
    final sync = NorieCloudSync(backend: device);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(sync.status, NorieCloudSyncStatus.error);
    expect(sync.message, contains('migration'));
    expect(device.casCalls, 0);
  });
}
