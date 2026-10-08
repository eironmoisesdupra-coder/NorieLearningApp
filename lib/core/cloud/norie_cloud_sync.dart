import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../account/norie_account_service.dart';
import '../account/norie_demo_access_service.dart';
import '../progression/norie_progression.dart';
import 'supabase_config.dart';

enum NorieCloudSyncStatus {
  localOnly,
  signedOut,
  syncing,
  pending,
  synced,
  error
}

/// Injectable boundary for deterministic account-switch/network-race tests.
abstract class NorieCloudSyncBackend {
  Listenable get accountChanges;
  Listenable get accessChanges;
  Listenable get progressionChanges;
  bool get isConfigured;
  bool get isAllowed;
  String? get userId;
  DateTime get modifiedAt;
  Map<String, dynamic> exportState();
  Future<Map<String, dynamic>?> fetchState(String userId);
  Future<void> uploadState(
      String userId, Map<String, dynamic> state, DateTime modified);
  Future<String?> readOwner();
  Future<String?> readPendingRestore() async => null;
  Future<void> writePendingRestore(
      String? userId, bool Function() stillCurrent) async {}
  Future<void> writeOwner(String userId, bool Function() stillCurrent);
  Future<void> importState(Map<String, dynamic> state, DateTime? modified,
      bool Function() stillCurrent);
  Future<void> resetState(bool Function() stillCurrent);
}

class NorieCloudSync extends ChangeNotifier {
  NorieCloudSync({NorieCloudSyncBackend? backend})
      : _backend = backend ?? _SupabaseSyncBackend();
  static final NorieCloudSync instance = NorieCloudSync();
  final NorieCloudSyncBackend _backend;
  Timer? _debounce;
  bool _initialized = false;
  bool _disposed = false;
  bool _syncInProgress = false;
  bool _pending = false;
  bool _needsReconcile = true;
  bool _hasPendingChanges = false;
  int _generation = 0;
  int _revision = 0;
  int _syncedRevision = 0;
  String? _contextUser;
  String? _localOwner;
  String? _reconciledUser;
  String? _awaitingRestoreUser;
  bool _contextAllowed = false;
  bool _contextConfigured = false;
  NorieCloudSyncStatus _status = NorieCloudSyncStatus.localOnly;
  String? _message;
  DateTime? _lastSyncedAt;

  NorieCloudSyncStatus get status => _status;
  String? get message => _message;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  bool get isSyncing => _status == NorieCloudSyncStatus.syncing;
  bool get hasPendingChanges => _hasPendingChanges;
  bool get _eligible =>
      !_disposed &&
      _backend.isConfigured &&
      _backend.isAllowed &&
      _backend.userId != null;

  /// Captures every account/access transition, including A -> B -> A.
  bool Function() captureSessionGuard() {
    _refreshContext();
    final generation = _generation;
    return () {
      _refreshContext();
      return !_disposed && generation == _generation;
    };
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _backend.accountChanges.addListener(_handleContextChange);
    _backend.accessChanges.addListener(_handleContextChange);
    _backend.progressionChanges.addListener(_handleProgressionChange);
    await syncNow();
  }

  void _refreshContext() {
    if (_contextUser == _backend.userId &&
        _contextAllowed == _backend.isAllowed &&
        _contextConfigured == _backend.isConfigured) {
      return;
    }
    _generation++;
    _contextUser = _backend.userId;
    _contextAllowed = _backend.isAllowed;
    _contextConfigured = _backend.isConfigured;
    _reconciledUser = null;
    _awaitingRestoreUser = null;
    _needsReconcile = true;
    _pending = _eligible;
    _debounce?.cancel();
    _message = null;
    _lastSyncedAt = null;
    if (!_eligible) _setUnavailable();
  }

  void _handleContextChange() {
    _refreshContext();
    if (_eligible) unawaited(syncNow());
  }

  void _setUnavailable() {
    _message = null;
    _lastSyncedAt = null;
    _setStatus(_backend.isConfigured
        ? NorieCloudSyncStatus.signedOut
        : NorieCloudSyncStatus.localOnly);
  }

  bool _current(int generation, String user) =>
      !_disposed &&
      generation == _generation &&
      _eligible &&
      _backend.userId == user;

  void _handleProgressionChange() {
    if (_disposed) return;
    _revision++;
    if (!_syncInProgress && _awaitingRestoreUser == _backend.userId) {
      // Offline work now belongs to this learner; a restart must preserve it
      // instead of forcing the deferred cloud snapshot over the local edits.
      _awaitingRestoreUser = null;
      final generation = _generation;
      final user = _backend.userId;
      if (user != null) {
        unawaited(_backend.writePendingRestore(
            null, () => _current(generation, user)));
      }
    }
    _hasPendingChanges = true;
    _pending = true;
    if (!_eligible || _syncInProgress) return;
    _setStatus(NorieCloudSyncStatus.pending);
    _scheduleUpload();
  }

  void _scheduleUpload() {
    _debounce?.cancel();
    _debounce = Timer(
        const Duration(milliseconds: 900), () => unawaited(uploadLocal()));
  }

  Future<void> syncNow() => _request(reconcile: true);
  Future<void> uploadLocal() => _request(reconcile: false);

  Future<void> _request({required bool reconcile}) async {
    if (_disposed) return;
    _refreshContext();
    if (!_eligible) {
      _setUnavailable();
      return;
    }
    _pending = true;
    _needsReconcile |= reconcile || _reconciledUser != _backend.userId;
    if (_syncInProgress) return;
    _debounce?.cancel();
    _syncInProgress = true;
    try {
      // Drain one follow-up immediately. Continuing user edits are debounced;
      // failures wait for an explicit retry or a subsequent local change.
      for (var pass = 0; pass < 2 && _pending && _eligible; pass++) {
        _pending = false;
        final shouldReconcile = _needsReconcile;
        _needsReconcile = false;
        final generation = _generation;
        final user = _backend.userId!;
        _hasPendingChanges = true;
        _setStatus(NorieCloudSyncStatus.syncing);
        try {
          await _syncOnce(generation, user, reconcile: shouldReconcile);
        } catch (error) {
          if (_current(generation, user)) {
            _pending = true;
            _needsReconcile |= shouldReconcile;
            _message = _friendlyError(error);
            _setStatus(NorieCloudSyncStatus.error);
            break;
          }
        }
      }
    } finally {
      _syncInProgress = false;
      if (_eligible && _pending && _status != NorieCloudSyncStatus.error) {
        _setStatus(NorieCloudSyncStatus.pending);
        _scheduleUpload();
      }
    }
  }

  Future<void> _syncOnce(int generation, String user,
      {required bool reconcile}) async {
    bool current() => _current(generation, user);
    var shouldUpload = true;
    var acknowledgedRevision = _revision;
    if (reconcile) {
      final owner = await _backend.readOwner();
      if (!current()) return;
      _awaitingRestoreUser ??= await _backend.readPendingRestore();
      if (!current()) return;
      _localOwner ??= owner ?? user;
      if (_localOwner != user) {
        // Isolate the new learner even when the cloud is offline. Remember that
        // a remote restore is still due, rather than treating this reset as a
        // newer device snapshot on the next retry.
        await _backend.writePendingRestore(user, current);
        if (!current()) return;
        await _backend.resetState(current);
        if (!current()) return;
        _localOwner = user;
        _awaitingRestoreUser = user;
        await _backend.writeOwner(user, current);
        if (!current()) return;
      }
      final switching = _awaitingRestoreUser == user;
      final revisionBeforeRead = _revision;
      final row = await _backend.fetchState(user);
      if (!current()) return;
      final rawState = row?['state'];
      final state =
          rawState is Map ? Map<String, dynamic>.from(rawState) : null;
      final modified =
          DateTime.tryParse(row?['updated_at']?.toString() ?? '')?.toUtc();
      final newer = modified != null && modified.isAfter(_backend.modifiedAt);
      final unchanged =
          _revision == revisionBeforeRead && _revision == _syncedRevision;
      if (row != null && (state == null || state.isEmpty)) {
        throw const FormatException('Invalid saved learning state.');
      }
      if ((switching && _revision == revisionBeforeRead) ||
          (newer && unchanged && state != null)) {
        if (!current()) return;
        if (state == null) {
          await _backend.resetState(current);
        } else {
          // A reading/map edit made while import prepares must stay local.
          await _backend.importState(state, modified,
              () => current() && _revision == revisionBeforeRead);
        }
        if (!current()) return;
        shouldUpload = state == null || _pending;
        acknowledgedRevision = _revision;
      }
      if (!current()) return;
      _reconciledUser = user;
      await _backend.writePendingRestore(null, current);
      if (!current()) return;
      _awaitingRestoreUser = null;
    }
    if (shouldUpload) {
      if (!current()) return;
      acknowledgedRevision = _revision;
      final state = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(_backend.exportState())) as Map);
      final modified = _backend.modifiedAt.millisecondsSinceEpoch == 0
          ? DateTime.now().toUtc()
          : _backend.modifiedAt;
      await _backend.uploadState(user, state, modified);
      if (!current()) return;
    }
    if (!current()) return;
    await _backend.writeOwner(user, current);
    if (!current()) return;
    _localOwner = user;
    if (_revision != acknowledgedRevision || _needsReconcile) {
      _pending = true;
      return;
    }
    _pending = false;
    _hasPendingChanges = false;
    _syncedRevision = _revision;
    _lastSyncedAt = DateTime.now().toUtc();
    _message = null;
    _setStatus(NorieCloudSyncStatus.synced);
  }

  void _setStatus(NorieCloudSyncStatus value) {
    if (_disposed) return;
    _status = value;
    notifyListeners();
  }

  static String _friendlyError(Object error) => error
          .toString()
          .contains('learner_state')
      ? 'Cloud tables are not ready yet. Apply the Norie Supabase migration.'
      : 'Cloud sync could not complete. Local progress is still safe.';

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _debounce?.cancel();
    if (_initialized) {
      _backend.accountChanges.removeListener(_handleContextChange);
      _backend.accessChanges.removeListener(_handleContextChange);
      _backend.progressionChanges.removeListener(_handleProgressionChange);
    }
    super.dispose();
  }
}

class _SupabaseSyncBackend extends NorieCloudSyncBackend {
  static const _ownerKey = 'norie.cloudOwnerUserId';
  static const _pendingRestoreKey = 'norie.cloudPendingRestoreUserId';
  @override
  Listenable get accountChanges => NorieAccountService.instance;
  @override
  Listenable get accessChanges => NorieDemoAccessService.instance;
  @override
  Listenable get progressionChanges => NorieProgression.instance;
  @override
  bool get isConfigured => NorieSupabase.isInitialized;
  @override
  bool get isAllowed => NorieDemoAccessService.instance.isAllowed;
  @override
  String? get userId => NorieAccountService.instance.user?.id;
  @override
  DateTime get modifiedAt => NorieProgression.instance.lastModifiedAt;
  @override
  Map<String, dynamic> exportState() =>
      NorieProgression.instance.exportCloudState();
  @override
  Future<Map<String, dynamic>?> fetchState(String userId) async =>
      NorieSupabase.client!
          .from('learner_state')
          .select('state, updated_at')
          .eq('user_id', userId)
          .maybeSingle();
  @override
  Future<void> uploadState(
      String userId, Map<String, dynamic> state, DateTime modified) async {
    await NorieSupabase.client!.from('learner_state').upsert({
      'user_id': userId,
      'state': state,
      'updated_at': modified.toIso8601String(),
    }, onConflict: 'user_id');
  }

  @override
  Future<String?> readOwner() async =>
      (await SharedPreferences.getInstance()).getString(_ownerKey);
  @override
  Future<String?> readPendingRestore() async =>
      (await SharedPreferences.getInstance()).getString(_pendingRestoreKey);
  @override
  Future<void> writePendingRestore(
      String? userId, bool Function() stillCurrent) async {
    final prefs = await SharedPreferences.getInstance();
    if (!stillCurrent()) return;
    if (userId == null) {
      await prefs.remove(_pendingRestoreKey);
    } else {
      await prefs.setString(_pendingRestoreKey, userId);
    }
  }

  @override
  Future<void> writeOwner(String userId, bool Function() stillCurrent) async {
    final prefs = await SharedPreferences.getInstance();
    if (stillCurrent()) await prefs.setString(_ownerKey, userId);
  }

  @override
  Future<void> importState(Map<String, dynamic> state, DateTime? modified,
      bool Function() stillCurrent) async {
    await NorieProgression.instance.importCloudState(state,
        remoteModifiedAt: modified, stillCurrent: stillCurrent);
  }

  @override
  Future<void> resetState(bool Function() stillCurrent) async {
    await NorieProgression.instance
        .resetForNewAccount(stillCurrent: stillCurrent);
  }
}
