import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/cloud/norie_cloud_sync.dart';

class _Notifier extends ChangeNotifier {
  void emit() => notifyListeners();
}

class _Backend extends NorieCloudSyncBackend {
  @override
  final _Notifier accountChanges = _Notifier();
  @override
  final _Notifier accessChanges = _Notifier();
  @override
  final _Notifier progressionChanges = _Notifier();
  @override
  bool isConfigured = true;
  @override
  bool isAllowed = true;
  @override
  String? userId = 'alice';
  String? owner;
  String? pendingRestore;
  @override
  bool requiresGuestTransfer = false;
  Map<String, dynamic>? guestRecovery;
  Future<void> Function()? recoveryWrite;
  @override
  Future<void> saveGuestRecovery(
      Map<String, dynamic> state, bool Function() stillCurrent) async {
    await recoveryWrite?.call();
    if (stillCurrent()) guestRecovery = Map.of(state);
  }

  int local = 1;
  int imports = 0;
  final uploads = <Map<String, dynamic>>[];
  Future<Map<String, dynamic>?> Function(String)? fetch;
  Future<void> Function()? upload;
  @override
  DateTime get modifiedAt => DateTime.utc(2026, 1, 1);
  @override
  Map<String, dynamic> exportState() => {'points': local};
  @override
  Future<Map<String, dynamic>?> fetchState(String id) async => fetch?.call(id);
  @override
  Future<String?> readOwner() async => owner;
  @override
  Future<String?> readPendingRestore() async => pendingRestore;
  @override
  Future<void> writePendingRestore(
      String? userId, bool Function() stillCurrent) async {
    if (stillCurrent()) pendingRestore = userId;
  }

  @override
  Future<void> writeOwner(String id, bool Function() stillCurrent) async {
    if (stillCurrent()) owner = id;
  }

  @override
  Future<void> uploadState(
      String id, Map<String, dynamic> state, DateTime modified) async {
    uploads.add({'user': id, ...state});
    await upload?.call();
  }

  @override
  Future<bool> importState(Map<String, dynamic> state, DateTime? modified,
      bool Function() stillCurrent) async {
    if (!stillCurrent()) return false;
    imports++;
    local = state['points'] as int;
    progressionChanges.emit();
    return true;
  }

  @override
  Future<void> resetState(bool Function() stillCurrent) async {
    if (stillCurrent()) local = 0;
  }

  void edit(int value) {
    local = value;
    progressionChanges.emit();
  }

  void signOut() {
    userId = null;
    accountChanges.emit();
  }
}

void main() {
  Map<String, dynamic> remote(int points) => {
        'state': {'points': points},
        'updated_at': '2026-10-01T00:00:00Z',
      };

  test('signout invalidates a delayed read before importing or claiming sync',
      () async {
    final backend = _Backend();
    final read = Completer<Map<String, dynamic>?>();
    backend.fetch = (_) => read.future;
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    final operation = sync.initialize();
    backend.signOut();
    read.complete(remote(99));
    await operation;
    expect(backend.imports, 0);
    expect(backend.local, 1);
    expect(backend.uploads, isEmpty);
    expect(backend.owner, isNull);
    expect(sync.status, NorieCloudSyncStatus.signedOut);
    expect(sync.lastSyncedAt, isNull);
    expect(sync.message, isNull);
  });

  test('access revocation invalidates the pending operation', () async {
    final backend = _Backend();
    final read = Completer<Map<String, dynamic>?>();
    backend.fetch = (_) => read.future;
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    final operation = sync.initialize();
    backend.isAllowed = false;
    backend.accessChanges.emit();
    read.complete(remote(99));
    await operation;
    expect(backend.imports, 0);
    expect(sync.status, NorieCloudSyncStatus.signedOut);
  });

  test('local edits during read cannot be overwritten by remote snapshot',
      () async {
    final backend = _Backend();
    final read = Completer<Map<String, dynamic>?>();
    backend.fetch = (_) => read.future;
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    final operation = sync.initialize();
    backend.edit(7);
    read.complete(remote(99));
    await operation;
    expect(backend.imports, 0);
    expect(backend.local, 7);
    expect(backend.uploads.last['points'], 7);
    expect(sync.status, NorieCloudSyncStatus.synced);
  });

  test('edits during upload get a follow-up upload before synced status',
      () async {
    final backend = _Backend();
    final uploadStarted = Completer<void>();
    final releaseUpload = Completer<void>();
    backend.upload = () async {
      if (!uploadStarted.isCompleted) {
        uploadStarted.complete();
        await releaseUpload.future;
      }
    };
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    final operation = sync.initialize();
    await uploadStarted.future;
    backend.edit(8);
    expect(sync.status, isNot(NorieCloudSyncStatus.synced));
    releaseUpload.complete();
    await operation;
    expect(backend.uploads.map((item) => item['points']), [1, 8]);
    expect(sync.status, NorieCloudSyncStatus.synced);
    expect(sync.hasPendingChanges, isFalse);
  });

  test('account switch discards old read and reconciles the new user',
      () async {
    final backend = _Backend()..owner = 'alice';
    final oldRead = Completer<Map<String, dynamic>?>();
    backend.fetch = (id) async => id == 'alice' ? oldRead.future : remote(22);
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    final operation = sync.initialize();
    backend.userId = 'bob';
    backend.accountChanges.emit();
    oldRead.complete(remote(99));
    await operation;
    expect(backend.local, 22);
    expect(backend.owner, 'bob');
    expect(backend.imports, 1);
    expect(backend.uploads.single, {'user': 'bob', 'points': 22});
  });

  test(
      'failure keeps pending data, retry succeeds, signout clears status details',
      () async {
    final backend = _Backend()
      ..fetch = (_) => Future.error(StateError('offline'));
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(sync.status, NorieCloudSyncStatus.error);
    expect(sync.hasPendingChanges, isTrue);
    backend.fetch = null;
    await sync.syncNow();
    expect(sync.status, NorieCloudSyncStatus.synced);
    expect(sync.lastSyncedAt, isNotNull);
    backend.signOut();
    expect(sync.status, NorieCloudSyncStatus.signedOut);
    expect(sync.lastSyncedAt, isNull);
    expect(sync.message, isNull);
  });
  test('offline account switch immediately isolates local learning state',
      () async {
    final backend = _Backend()
      ..owner = 'alice'
      ..userId = 'bob';
    backend.fetch = (_) => Future.error(StateError('offline'));
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(backend.local, 0);
    expect(backend.owner, 'bob');
    expect(sync.status, NorieCloudSyncStatus.error);
    backend.fetch = (_) async => remote(22);
    await sync.syncNow();
    expect(backend.local, 22);
    expect(sync.status, NorieCloudSyncStatus.synced);
  });

  test('new learner edits during account restore read are preserved', () async {
    final backend = _Backend()
      ..owner = 'alice'
      ..userId = 'bob';
    final started = Completer<void>();
    final read = Completer<Map<String, dynamic>?>();
    backend.fetch = (_) {
      if (!started.isCompleted) started.complete();
      return read.future;
    };
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    final operation = sync.initialize();
    await started.future;
    expect(backend.local, 0);
    backend.edit(7);
    read.complete(remote(22));
    await operation;
    expect(backend.local, 7);
    expect(backend.imports, 0);
    expect(backend.uploads.last, {'user': 'bob', 'points': 7});
  });

  test('offline account restore marker survives sync restart', () async {
    final backend = _Backend()
      ..owner = 'alice'
      ..userId = 'bob';
    backend.fetch = (_) => Future.error(StateError('offline'));
    final first = NorieCloudSync(backend: backend);
    await first.initialize();
    first.dispose();
    expect(backend.pendingRestore, 'bob');
    backend.fetch = (_) async => remote(22);
    final restarted = NorieCloudSync(backend: backend);
    addTearDown(restarted.dispose);
    await restarted.initialize();
    expect(backend.local, 22);
    expect(backend.pendingRestore, isNull);
  });
  test('guest progress never uploads or claims an owner before a decision',
      () async {
    final backend = _Backend()..requiresGuestTransfer = true;
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(sync.guestTransferPending, true);
    expect(backend.owner, isNull);
    expect(backend.uploads, isEmpty);
    backend.edit(7);
    await sync.uploadLocal();
    expect(backend.uploads, isEmpty);
    expect(await sync.resolveGuestTransfer(transferLocal: true), true);
    expect(backend.guestRecovery, {'points': 7});
    expect(backend.owner, 'alice');
    expect(backend.uploads.last, {'user': 'alice', 'points': 7});
    expect(sync.guestTransferPending, false);
  });
  test('choosing account progress preserves guest recovery and restores remote',
      () async {
    final backend = _Backend()
      ..requiresGuestTransfer = true
      ..fetch = (_) async => remote(22);
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(await sync.resolveGuestTransfer(transferLocal: false), true);
    expect(backend.guestRecovery, {'points': 1});
    expect(backend.local, 22);
    expect(backend.owner, 'alice');
    expect(backend.uploads.where((item) => item['points'] == 1), isEmpty);
  });
  test(
      'account change during guest recovery cannot adopt data for another user',
      () async {
    final backend = _Backend()..requiresGuestTransfer = true;
    final started = Completer<void>(), release = Completer<void>();
    backend.recoveryWrite = () async {
      started.complete();
      await release.future;
    };
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    final choice = sync.resolveGuestTransfer(transferLocal: true);
    await started.future;
    backend.userId = 'bob';
    backend.accountChanges.emit();
    release.complete();
    expect(await choice, false);
    await sync.syncNow();
    expect(backend.owner, isNull);
    expect(backend.uploads, isEmpty);
    expect(backend.local, 1);
    expect(sync.guestTransferPending, true);
  });
  test('remote-account choice discards the old read after switching accounts',
      () async {
    final backend = _Backend()..requiresGuestTransfer = true;
    final started = Completer<void>();
    final release = Completer<Map<String, dynamic>?>();
    backend.fetch = (id) {
      if (id == 'alice') {
        started.complete();
        return release.future;
      }
      return Future.value(remote(22));
    };
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    final choice = sync.resolveGuestTransfer(transferLocal: false);
    await started.future;
    backend.userId = 'bob';
    backend.accountChanges.emit();
    release.complete(remote(99));
    expect(await choice, false);
    expect(backend.guestRecovery, {'points': 1});
    expect(backend.local, 22);
    expect(backend.owner, 'bob');
    expect(
        backend.uploads
            .any((item) => item['user'] == 'bob' && item['points'] == 99),
        false);
  });
  test(
      'interrupted guest discard resets unowned data before an offline restore',
      () async {
    final backend = _Backend()
      ..requiresGuestTransfer = true
      ..pendingRestore = 'alice'
      ..local = 13
      ..fetch = (_) => Future.error(StateError('offline'));
    final sync = NorieCloudSync(backend: backend);
    addTearDown(sync.dispose);
    await sync.initialize();
    expect(backend.local, 0);
    expect(backend.owner, 'alice');
    expect(backend.pendingRestore, 'alice');
    expect(backend.uploads, isEmpty);
    expect(sync.status, NorieCloudSyncStatus.error);
  });
}
