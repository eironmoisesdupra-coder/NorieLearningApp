import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/cloud/norie_cloud_sync.dart';

class _Changes extends ChangeNotifier {
  void emit() => notifyListeners();
}

/// Models one learner on two devices: remote is independently changed by A,
/// while the coordinator under test owns device B's local choices and rewards.
class _CollectionsBackend extends NorieCloudSyncBackend {
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
  String? userId = 'learner';
  String? owner = 'learner';
  String? pendingRestore;
  Set<String> localRewards = {'base'};
  String localAppearance = 'default';
  Map<String, dynamic> remote = {
    'rewards': ['base'],
    'appearance': 'default',
  };
  final uploads = <Map<String, dynamic>>[];
  Future<void> Function()? waitForFetch;
  Future<void> Function()? beforeNextCas;
  int casCalls = 0;
  @override
  DateTime get modifiedAt => DateTime.utc(2026, 10, 8);
  @override
  Map<String, dynamic> exportState() => {
        'rewards': localRewards.toList()..sort(),
        'appearance': localAppearance,
      };
  @override
  Map<String, dynamic> mergePermanentCollections(
          Map<String, dynamic> primary, Map<String, dynamic> secondary) =>
      {
        ...primary,
        'rewards': {
          ...List<String>.from(primary['rewards']),
          ...List<String>.from(secondary['rewards']),
        }.toList()
          ..sort(),
      };
  @override
  Future<Map<String, dynamic>?> fetchState(String user) async {
    await waitForFetch?.call();
    return {
      'state': Map<String, dynamic>.of(remote),
      // Even a newer server snapshot must not replace an explicit local edit.
      'updated_at': '2026-10-09T00:00:00Z',
    };
  }

  @override
  Future<void> uploadState(
      String user, Map<String, dynamic> state, DateTime modified) async {
    remote = Map<String, dynamic>.of(state);
    uploads.add(Map<String, dynamic>.of(state));
  }

  @override
  Future<bool> uploadStateIfUnchanged(String user, Map<String, dynamic> state,
      DateTime modified, Map<String, dynamic>? expectedState) async {
    casCalls++;
    final before = beforeNextCas;
    beforeNextCas = null;
    await before?.call();
    // Model the RPC's bound p_user_id check at execution time, not merely a
    // client guard before the asynchronous request started.
    if (user != userId) throw StateError('learner_owner_mismatch');
    // Fixture maps use a stable insertion order; the production SQL compares
    // jsonb structurally instead of comparing serialized strings.
    if (jsonEncode(expectedState) != jsonEncode(remote)) return false;
    await uploadState(user, state, modified);
    return true;
  }

  @override
  Future<String?> readOwner() async => owner;
  @override
  Future<String?> readPendingRestore() async => pendingRestore;
  @override
  Future<void> writeOwner(String user, bool Function() stillCurrent) async {
    if (stillCurrent()) owner = user;
  }

  @override
  Future<void> writePendingRestore(
      String? user, bool Function() stillCurrent) async {
    if (stillCurrent()) pendingRestore = user;
  }

  @override
  Future<bool> importState(Map<String, dynamic> state, DateTime? modified,
      bool Function() stillCurrent) async {
    if (!stillCurrent()) return false;
    localRewards = Set<String>.from(state['rewards']);
    localAppearance = state['appearance'] as String;
    progressionChanges.emit();
    return true;
  }

  @override
  Future<void> resetState(bool Function() stillCurrent) async {
    if (!stillCurrent()) return;
    localRewards.clear();
    localAppearance = 'default';
    progressionChanges.emit();
  }

  void edit(String reward, String appearance) {
    localRewards.add(reward);
    localAppearance = appearance;
    progressionChanges.emit();
  }
}

void main() {
  test('CAS conflict refetches and preserves the third-device trophy',
      () async {
    final backend = _CollectionsBackend();
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    backend.uploads.clear();
    final callsBefore = backend.casCalls;
    backend.remote = {
      'rewards': ['base', 'device-a-trophy'],
      'appearance': 'device-a-look',
    };
    backend.edit('device-b-trophy', 'device-b-look');
    backend.beforeNextCas = () async {
      backend.remote = {
        'rewards': ['base', 'device-a-trophy', 'device-c-trophy'],
        'appearance': 'device-c-look',
      };
    };

    await sync.uploadLocal();

    expect(backend.casCalls - callsBefore, 2);
    expect(backend.uploads, hasLength(1),
        reason: 'The rejected stale snapshot must never become a saved result');
    const trophies = [
      'base',
      'device-a-trophy',
      'device-b-trophy',
      'device-c-trophy'
    ];
    expect(backend.remote['rewards'], unorderedEquals(trophies));
    expect(backend.localRewards, unorderedEquals(trophies));
    expect(backend.remote['appearance'], 'device-b-look');
    expect(backend.localAppearance, 'device-b-look');
    expect(sync.status, NorieCloudSyncStatus.synced);
    expect(sync.hasPendingChanges, false);
  });

  test('session changes at RPC execution cannot save captured learner state',
      () async {
    final backend = _CollectionsBackend();
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    backend.uploads.clear();
    final savedBefore = Map<String, dynamic>.of(backend.remote);
    backend.edit('private-local-trophy', 'private-local-look');
    backend.beforeNextCas = () async {
      backend.userId = null;
      backend.accountChanges.emit();
    };

    await sync.uploadLocal();

    expect(backend.uploads, isEmpty);
    expect(backend.remote, savedBefore);
    expect(sync.status, NorieCloudSyncStatus.signedOut);
    expect(sync.lastSyncedAt, isNull);
  });

  test('ordinary dirty upload preserves other-device rewards and local look',
      () async {
    final backend = _CollectionsBackend();
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    backend.uploads.clear();
    backend.remote = {
      'rewards': ['base', 'device-a-trophy'],
      'appearance': 'device-a-look',
    };
    backend.edit('device-b-trophy', 'device-b-look');

    // This is the debounce path, deliberately not the manual reconcile API.
    await sync.uploadLocal();

    expect(backend.remote['rewards'],
        unorderedEquals(['base', 'device-a-trophy', 'device-b-trophy']));
    expect(backend.localRewards,
        unorderedEquals(['base', 'device-a-trophy', 'device-b-trophy']));
    expect(backend.remote['appearance'], 'device-b-look');
    expect(backend.localAppearance, 'device-b-look');
    expect(sync.status, NorieCloudSyncStatus.synced);
  });

  test('edit during reconciliation preserves all rewards and newest local look',
      () async {
    final backend = _CollectionsBackend();
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    backend.remote = {
      'rewards': ['base', 'device-a-trophy'],
      'appearance': 'device-a-look',
    };
    backend.edit('device-b-trophy', 'device-b-look');
    final entered = Completer<void>();
    final release = Completer<void>();
    backend.waitForFetch = () async {
      backend.waitForFetch = null;
      entered.complete();
      await release.future;
    };
    final operation = sync.syncNow();
    await entered.future;
    backend.edit('during-read-trophy', 'latest-local-look');
    release.complete();
    await operation;

    const expected = [
      'base',
      'device-a-trophy',
      'device-b-trophy',
      'during-read-trophy'
    ];
    expect(backend.remote['rewards'], unorderedEquals(expected));
    expect(backend.localRewards, unorderedEquals(expected));
    expect(backend.remote['appearance'], 'latest-local-look');
    expect(backend.localAppearance, 'latest-local-look');
    expect(sync.status, NorieCloudSyncStatus.synced);
  });
}
