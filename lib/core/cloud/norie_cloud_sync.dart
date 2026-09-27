import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/norie_account_service.dart';
import '../progression/norie_progression.dart';
import 'supabase_config.dart';

enum NorieCloudSyncStatus {
  localOnly,
  signedOut,
  syncing,
  synced,
  error,
}

class NorieCloudSync extends ChangeNotifier {
  NorieCloudSync._();

  static final NorieCloudSync instance = NorieCloudSync._();

  Timer? _debounce;
  bool _initialized = false;
  bool _applyingRemote = false;
  bool _syncInProgress = false;
  NorieCloudSyncStatus _status = NorieCloudSyncStatus.localOnly;
  String? _message;
  DateTime? _lastSyncedAt;

  static const _cloudOwnerKey = 'norie.cloudOwnerUserId';

  NorieCloudSyncStatus get status => _status;
  String? get message => _message;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  bool get isSyncing => _status == NorieCloudSyncStatus.syncing;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final account = NorieAccountService.instance;
    final progression = NorieProgression.instance;

    account.addListener(_handleAccountChange);
    progression.addListener(_handleProgressionChange);

    if (!NorieSupabase.isInitialized) {
      _setStatus(NorieCloudSyncStatus.localOnly);
      return;
    }

    if (!account.isSignedIn) {
      _setStatus(NorieCloudSyncStatus.signedOut);
      return;
    }

    await syncNow();
  }

  void _handleAccountChange() {
    if (!NorieSupabase.isInitialized) {
      _setStatus(NorieCloudSyncStatus.localOnly);
      return;
    }

    if (!NorieAccountService.instance.isSignedIn) {
      _debounce?.cancel();
      _setStatus(NorieCloudSyncStatus.signedOut);
      return;
    }

    unawaited(syncNow());
  }

  void _handleProgressionChange() {
    if (_applyingRemote ||
        !NorieAccountService.instance.isSignedIn ||
        !NorieSupabase.isInitialized) {
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 900),
      () => unawaited(uploadLocal()),
    );
  }

  Future<void> syncNow() async {
    if (_syncInProgress) return;

    final client = NorieSupabase.client;
    final user = NorieAccountService.instance.user;
    if (client == null) {
      _setStatus(NorieCloudSyncStatus.localOnly);
      return;
    }
    if (user == null) {
      _setStatus(NorieCloudSyncStatus.signedOut);
      return;
    }

    _syncInProgress = true;
    _setStatus(NorieCloudSyncStatus.syncing);

    try {
      final row = await client
          .from('learner_state')
          .select('state, updated_at')
          .eq('user_id', user.id)
          .maybeSingle();

      final prefs = await SharedPreferences.getInstance();
      final localOwner = prefs.getString(_cloudOwnerKey);
      final switchingAccounts =
          localOwner != null && localOwner.isNotEmpty && localOwner != user.id;

      if (row == null) {
        if (switchingAccounts) {
          _applyingRemote = true;
          try {
            await NorieProgression.instance.resetForNewAccount();
          } finally {
            _applyingRemote = false;
          }
        }
        await _uploadForUser(user.id);
      } else {
        final rawState = row['state'];
        final cloudState = rawState is Map
            ? Map<String, dynamic>.from(rawState)
            : <String, dynamic>{};
        final cloudUpdatedAt = DateTime.tryParse(
          row['updated_at']?.toString() ?? '',
        )?.toUtc();

        final localModified = NorieProgression.instance.lastModifiedAt;
        final cloudIsNewer = cloudUpdatedAt != null &&
            cloudUpdatedAt.isAfter(localModified);

        if (switchingAccounts || (cloudIsNewer && cloudState.isNotEmpty)) {
          _applyingRemote = true;
          try {
            await NorieProgression.instance.importCloudState(
              cloudState,
              remoteModifiedAt: cloudUpdatedAt,
            );
          } finally {
            _applyingRemote = false;
          }
        } else {
          await _uploadForUser(user.id);
        }
      }

      await prefs.setString(_cloudOwnerKey, user.id);

      _lastSyncedAt = DateTime.now().toUtc();
      _message = null;
      _setStatus(NorieCloudSyncStatus.synced);
    } catch (error) {
      _message = _friendlyError(error);
      _setStatus(NorieCloudSyncStatus.error);
    } finally {
      _syncInProgress = false;
    }
  }

  Future<void> uploadLocal() async {
    if (_syncInProgress) return;

    final client = NorieSupabase.client;
    final user = NorieAccountService.instance.user;
    if (client == null || user == null) return;

    _syncInProgress = true;
    _setStatus(NorieCloudSyncStatus.syncing);

    try {
      await _uploadForUser(user.id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cloudOwnerKey, user.id);
      _lastSyncedAt = DateTime.now().toUtc();
      _message = null;
      _setStatus(NorieCloudSyncStatus.synced);
    } catch (error) {
      _message = _friendlyError(error);
      _setStatus(NorieCloudSyncStatus.error);
    } finally {
      _syncInProgress = false;
    }
  }

  Future<void> _uploadForUser(String userId) async {
    final client = NorieSupabase.client;
    if (client == null) return;

    final progression = NorieProgression.instance;
    final modifiedAt = progression.lastModifiedAt.millisecondsSinceEpoch == 0
        ? DateTime.now().toUtc()
        : progression.lastModifiedAt;

    await client.from('learner_state').upsert(
      {
        'user_id': userId,
        'state': progression.exportCloudState(),
        'updated_at': modifiedAt.toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }

  void _setStatus(NorieCloudSyncStatus value) {
    if (_status == value && value != NorieCloudSyncStatus.error) return;
    _status = value;
    notifyListeners();
  }

  static String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('learner_state')) {
      return 'Cloud tables are not ready yet. Apply the Norie Supabase migration.';
    }
    return 'Cloud sync could not complete. Local progress is still safe.';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
