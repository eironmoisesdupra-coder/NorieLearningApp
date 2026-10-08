import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../account/norie_account_service.dart';
import '../account/norie_demo_access_service.dart';
import '../progression/norie_progression.dart';
import '../progression/norie_progress_backup.dart';
import 'supabase_config.dart';

enum NorieCloudSyncStatus {
  localOnly,
  signedOut,
  syncing,
  pending,
  synced,
  error
}

Object? _canonicalSnapshot(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((key) => key.toString()).toList()..sort();
    return {for (final key in keys) key: _canonicalSnapshot(value[key])};
  }
  if (value is List) return value.map(_canonicalSnapshot).toList();
  return value;
}

bool _sameSnapshot(Map<String, dynamic> a, Map<String, dynamic> b) =>
    jsonEncode(_canonicalSnapshot(a)) == jsonEncode(_canonicalSnapshot(b));

/// Injectable boundary for deterministic account-switch/network-race tests.
abstract class NorieCloudSyncBackend {
  Listenable get accountChanges;
  Listenable get accessChanges;
  Listenable get progressionChanges;
  bool get isConfigured;
  bool get isAllowed;
  String? get userId;
  DateTime get modifiedAt;
  bool get requiresGuestTransfer => false;
  Future<void> saveGuestRecovery(
      Map<String, dynamic> state, bool Function() stillCurrent) async {}
  Future<String?> readGuestRecovery() async => null;
  Map<String, dynamic> exportState();
  Map<String, dynamic> mergePermanentCollections(
          Map<String, dynamic> primary, Map<String, dynamic> secondary) =>
      primary;
  Future<Map<String, dynamic>?> fetchState(String userId);
  Future<void> uploadState(
      String userId, Map<String, dynamic> state, DateTime modified);
  Future<bool> uploadStateIfUnchanged(String userId, Map<String, dynamic> state,
      DateTime modified, Map<String, dynamic>? expectedState) async {
    await uploadState(userId, state, modified);
    return true;
  }

  Future<String?> readOwner();
  Future<String?> readPendingRestore() async => null;
  Future<void> writePendingRestore(
      String? userId, bool Function() stillCurrent) async {}
  Future<void> writeOwner(String userId, bool Function() stillCurrent);
  Future<bool> importState(Map<String, dynamic> state, DateTime? modified,
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
  String? _guestDecisionUser;
  bool _guestChoiceInProgress = false;
  Map<String, dynamic>? _guestRecoveryState;
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
  bool get guestTransferPending =>
      _eligible && _guestDecisionUser == _backend.userId;
  bool get guestTransferInProgress => _guestChoiceInProgress;
  Future<String?> readGuestRecovery() => _backend.readGuestRecovery();
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
    _guestDecisionUser = null;
    _guestRecoveryState = null;
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
        unawaited(_backend
            .writePendingRestore(null, () => _current(generation, user))
            .catchError((Object _) {
          if (_current(generation, user)) {
            _needsReconcile = true;
            _pending = true;
            _message =
                'Account recovery could not be saved. Local progress is still safe.';
            _setStatus(NorieCloudSyncStatus.error);
          }
        }));
      }
    }
    _hasPendingChanges = true;
    _pending = true;
    if (guestTransferPending || _guestChoiceInProgress) return;
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

  /// The caller explicitly chooses whether this account adopts guest learning.
  Future<bool> resolveGuestTransfer({required bool transferLocal}) async {
    _refreshContext();
    if (!guestTransferPending || _guestChoiceInProgress) return false;
    final generation = _generation;
    final user = _backend.userId!;
    final revision = _revision;
    bool current() => _current(generation, user) && _revision == revision;
    final guest = Map<String, dynamic>.from(
        jsonDecode(jsonEncode(_backend.exportState())) as Map);
    _guestChoiceInProgress = true;
    _debounce?.cancel();
    notifyListeners();
    try {
      await _backend.saveGuestRecovery(_guestRecoveryState ?? guest, current);
      if (!current()) return false;
      _guestRecoveryState ??= guest;
      if (transferLocal) {
        final row = await _backend.fetchState(user);
        if (!current()) return false;
        final raw = row?['state'];
        if (row != null && (raw is! Map || raw.isEmpty)) {
          throw const FormatException('Invalid saved learning state.');
        }
        final adopted = raw is Map
            ? _backend.mergePermanentCollections(
                guest, Map<String, dynamic>.from(raw))
            : guest;
        // Once the user opts in, their guest completion receipts may join this account.
        await _backend.writeOwner(user, current);
        if (!current()) return false;
        _localOwner = user;
        await _backend.importState(adopted, DateTime.now().toUtc(), current);
        if (!_current(generation, user)) return false;
      } else {
        await _backend.writePendingRestore(user, current);
        if (!current()) return false;
        // Reserve the in-memory owner before reset so a session switch isolates it.
        _localOwner = user;
        await _backend.resetState(current);
        if (!_current(generation, user)) return false;
        await _backend.writeOwner(user, () => _current(generation, user));
        if (!_current(generation, user)) return false;
        _awaitingRestoreUser = user;
      }
      bool sessionCurrent() => _current(generation, user);
      if (!sessionCurrent()) return false;
      _localOwner = user;
      _guestDecisionUser = null;
      _syncedRevision = _revision;
      _needsReconcile = true;
      _pending = true;
      _guestChoiceInProgress = false;
      await syncNow();
      return sessionCurrent();
    } catch (error) {
      if (_current(generation, user)) {
        _message = _guestRecoveryState != null
            ? 'The guest choice could not finish. Your local recovery copy is safe; retry before syncing.'
            : 'Could not preserve a guest recovery copy. Guest progress is still on this device; retry before syncing.';
        _setStatus(NorieCloudSyncStatus.error);
      }
      return false;
    } finally {
      _guestChoiceInProgress = false;
      if (!_disposed) notifyListeners();
      if (!_disposed && generation != _generation && _eligible) await syncNow();
    }
  }

  Future<void> _request({required bool reconcile}) async {
    if (_disposed) return;
    _refreshContext();
    if (!_eligible) {
      _setUnavailable();
      return;
    }
    if (guestTransferPending || _guestChoiceInProgress) return;
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
      if (_eligible &&
          _pending &&
          !guestTransferPending &&
          !_guestChoiceInProgress &&
          _status != NorieCloudSyncStatus.error) {
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
      if (owner == null &&
          _localOwner == null &&
          _awaitingRestoreUser != null) {
        // A crash may occur after recording a discard choice but before reset.
        // Clear unowned guest state before any account restore or offline edit.
        await _backend.resetState(current);
        if (!current()) return;
        await _backend.writePendingRestore(user, current);
        if (!current()) return;
        await _backend.writeOwner(user, current);
        if (!current()) return;
        _localOwner = user;
        _awaitingRestoreUser = user;
      }
      if (owner == null &&
          _localOwner == null &&
          _awaitingRestoreUser == null &&
          _backend.requiresGuestTransfer) {
        _guestDecisionUser = user;
        _pending = false;
        _needsReconcile = true;
        _message =
            'Choose whether to transfer this device’s guest progress before account sync.';
        _setStatus(NorieCloudSyncStatus.pending);
        return;
      }
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
      var state = rawState is Map ? Map<String, dynamic>.from(rawState) : null;
      final modified =
          DateTime.tryParse(row?['updated_at']?.toString() ?? '')?.toUtc();
      final newer = modified != null && modified.isAfter(_backend.modifiedAt);
      final unchanged =
          _revision == revisionBeforeRead && _revision == _syncedRevision;
      var mergedCollections = false;
      if (!switching && owner == user && unchanged && state != null) {
        final primary = newer ? state : _backend.exportState();
        final secondary = newer ? _backend.exportState() : state;
        final merged = _backend.mergePermanentCollections(primary, secondary);
        mergedCollections = !_sameSnapshot(merged, primary);
        if (mergedCollections) state = merged;
      }
      if (row != null && (state == null || state.isEmpty)) {
        throw const FormatException('Invalid saved learning state.');
      }
      if ((switching && _revision == revisionBeforeRead) ||
          ((newer || mergedCollections) && unchanged && state != null)) {
        if (!current()) return;
        if (state == null) {
          await _backend.resetState(current);
        } else {
          // A reading/map edit made while import prepares must stay local.
          await _backend.importState(state, modified,
              () => current() && _revision == revisionBeforeRead);
        }
        if (!current()) return;
        shouldUpload = mergedCollections || state == null || _pending;
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
      // Every upload reads current server ownership collections, including
      // automatic reconnects with dirty local state. Keep explicit local looks.
      final latest = await _backend.fetchState(user);
      if (!current()) return;
      final rawExpected = latest?['state'];
      if (latest != null && (rawExpected is! Map || rawExpected.isEmpty)) {
        throw const FormatException('Invalid saved learning state.');
      }
      final expected =
          rawExpected is Map ? Map<String, dynamic>.from(rawExpected) : null;
      final revisionBeforeMerge = _revision;
      final local = _backend.exportState();
      final merged = expected == null
          ? local
          : _backend.mergePermanentCollections(local, expected);
      if (!_sameSnapshot(merged, local)) {
        final applied = await _backend.importState(
            merged, null, () => current() && _revision == revisionBeforeMerge);
        if (!current()) return;
        if (!applied) {
          _pending = true;
          _needsReconcile = true;
          return;
        }
      }
      acknowledgedRevision = _revision;
      final state = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(_backend.exportState())) as Map);
      final modified = _backend.modifiedAt.millisecondsSinceEpoch == 0
          ? DateTime.now().toUtc()
          : _backend.modifiedAt;
      final saved = await _backend.uploadStateIfUnchanged(
          user, state, modified, expected);
      if (!current()) return;
      if (!saved) {
        // Another device saved after our read. Refetch and union before retry;
        // never announce account synchronization for a rejected write.
        _pending = true;
        _needsReconcile = true;
        return;
      }
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
  @override
  Map<String, dynamic> mergePermanentCollections(
          Map<String, dynamic> primary, Map<String, dynamic> secondary) =>
      NorieProgression.mergePermanentCollections(primary, secondary);
  static const _ownerKey = 'norie.cloudOwnerUserId';
  static const _pendingRestoreKey = 'norie.cloudPendingRestoreUserId';
  static const _guestRecoveryKey = 'norie.guestProgressRecovery.v1';
  @override
  bool get requiresGuestTransfer {
    final progress = NorieProgression.instance;
    final state = progress.exportCloudState();
    final appearance = state['profile_appearance'] as Map?;
    final value = appearance?['appearance'] as Map?;
    final journey = state['lesson_journey'] as Map?;
    final adventure = state['adventure_progress'] as Map?;
    return progress.totalXp > 0 ||
        progress.completedLessons > 0 ||
        progress.studySessions > 0 ||
        progress.questionsAnswered > 0 ||
        progress.completedTopicIds.isNotEmpty ||
        journey?['last_topic_id'] != null ||
        (journey?['reading_offsets'] as Map?)?.isNotEmpty == true ||
        (adventure?['trophies'] as Map?)?.isNotEmpty == true ||
        (adventure?['evidence'] as Map?)?.isNotEmpty == true ||
        progress.ownedShopItems.isNotEmpty ||
        progress.credits > 0 ||
        (appearance?['presets'] as List?)?.isNotEmpty == true ||
        value?['avatar'] != 'norie' ||
        value?['palette'] != 'explorer' ||
        value?['frame'] != 'explorer' ||
        value?['pose'] != 'welcome' ||
        value?['accent'] != 0 ||
        (value?['showcase'] as List?)?.isNotEmpty == true;
  }

  @override
  Future<void> saveGuestRecovery(
      Map<String, dynamic> state, bool Function() stillCurrent) async {
    final backup = NorieProgressBackup.encode(state);
    final prefs = await SharedPreferences.getInstance();
    if (!stillCurrent()) return;
    if (!await prefs.setString(_guestRecoveryKey, backup)) {
      throw StateError('Could not preserve guest progress.');
    }
  }

  @override
  Future<String?> readGuestRecovery() async =>
      (await SharedPreferences.getInstance()).getString(_guestRecoveryKey);
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
  Future<bool> uploadStateIfUnchanged(String userId, Map<String, dynamic> state,
          DateTime modified, Map<String, dynamic>? expectedState) async =>
      await NorieSupabase.client!
          .rpc('norie_save_learner_state_guarded', params: {
        'p_user_id': userId,
        'p_state': state,
        'p_modified': modified.toIso8601String(),
        'p_expected_state': expectedState,
      }) ==
      true;

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
    final saved = userId == null
        ? await prefs.remove(_pendingRestoreKey)
        : await prefs.setString(_pendingRestoreKey, userId);
    if (!saved) {
      await prefs.reload();
      throw StateError('Could not save the account recovery marker.');
    }
  }

  @override
  Future<void> writeOwner(String userId, bool Function() stillCurrent) async {
    final prefs = await SharedPreferences.getInstance();
    if (!stillCurrent()) return;
    if (!await prefs.setString(_ownerKey, userId)) {
      await prefs.reload();
      throw StateError('Could not save the active account owner.');
    }
  }

  @override
  Future<bool> importState(Map<String, dynamic> state, DateTime? modified,
      bool Function() stillCurrent) async {
    return await NorieProgression.instance.importCloudState(state,
        remoteModifiedAt: modified, stillCurrent: stillCurrent);
  }

  @override
  Future<void> resetState(bool Function() stillCurrent) async {
    await NorieProgression.instance
        .resetForNewAccount(stillCurrent: stillCurrent);
  }
}
