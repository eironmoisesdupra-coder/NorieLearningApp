import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../cloud/supabase_config.dart';

enum NorieAccountStatus {
  localOnly,
  signedOut,
  signedIn,
  working,
  error,
}

class NorieAccountService extends ChangeNotifier {
  NorieAccountService._();

  static final NorieAccountService instance = NorieAccountService._();

  StreamSubscription<AuthState>? _authSubscription;
  User? _user;
  String? _displayName;
  NorieAccountStatus _status = NorieAccountStatus.localOnly;
  String? _message;

  User? get user => _user;
  String? get displayName => _displayName;
  String? get email => _user?.email;
  NorieAccountStatus get status => _status;
  String? get message => _message;
  bool get isSignedIn => _user != null;
  bool get isCloudConfigured => NorieSupabase.isConfigured;
  bool get isCloudReady => NorieSupabase.isInitialized;

  Future<void> initialize() async {
    if (!NorieSupabase.isInitialized) {
      _status = NorieAccountStatus.localOnly;
      notifyListeners();
      return;
    }

    final client = NorieSupabase.client!;
    _user = client.auth.currentUser;
    _status = _user == null
        ? NorieAccountStatus.signedOut
        : NorieAccountStatus.signedIn;

    if (_user != null) {
      await _loadProfile();
    }

    _authSubscription?.cancel();
    _authSubscription = client.auth.onAuthStateChange.listen((event) async {
      _user = event.session?.user;
      if (_user == null) {
        _displayName = null;
        _status = NorieAccountStatus.signedOut;
        _message = null;
      } else {
        _status = NorieAccountStatus.signedIn;
        await _loadProfile();
      }
      notifyListeners();
    });

    notifyListeners();
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final client = NorieSupabase.client;
    if (client == null) {
      return 'Cloud sync is not configured for this build yet.';
    }

    _setWorking();
    try {
      final response = await client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      _user = response.user;
      if (_user == null) {
        return _setError('Sign-in did not return a user session.');
      }

      _status = NorieAccountStatus.signedIn;
      _message = null;
      await _loadProfile();
      notifyListeners();
      return null;
    } on AuthException catch (error) {
      return _setError(error.message);
    } catch (_) {
      return _setError('Unable to sign in right now.');
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final client = NorieSupabase.client;
    if (client == null) {
      return 'Cloud sync is not configured for this build yet.';
    }

    _setWorking();
    try {
      final response = await client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'display_name': displayName.trim(),
        },
      );

      _user = response.user;
      _displayName = displayName.trim();

      if (_user != null && response.session != null) {
        await client.from('profiles').upsert(
          {
            'id': _user!.id,
            'display_name': _displayName,
          },
          onConflict: 'id',
        );
        _status = NorieAccountStatus.signedIn;
        _message = null;
      } else {
        _status = NorieAccountStatus.signedOut;
        _message =
            'Account created. Check your email if confirmation is required.';
      }

      notifyListeners();
      return _message;
    } on AuthException catch (error) {
      return _setError(error.message);
    } catch (_) {
      return _setError('Unable to create the account right now.');
    }
  }

  Future<String?> updateDisplayName(String value) async {
    final client = NorieSupabase.client;
    final currentUser = _user;
    if (client == null || currentUser == null) {
      return 'Sign in before updating your profile.';
    }

    final normalized = value.trim();
    if (normalized.isEmpty) return 'Display name cannot be empty.';

    try {
      await client.from('profiles').upsert(
        {
          'id': currentUser.id,
          'display_name': normalized,
        },
        onConflict: 'id',
      );
      _displayName = normalized;
      notifyListeners();
      return null;
    } catch (_) {
      return 'Could not update the display name.';
    }
  }

  Future<void> signOut() async {
    final client = NorieSupabase.client;
    if (client != null) {
      await client.auth.signOut();
    }
    _user = null;
    _displayName = null;
    _status = NorieSupabase.isInitialized
        ? NorieAccountStatus.signedOut
        : NorieAccountStatus.localOnly;
    _message = null;
    notifyListeners();
  }

  Future<void> _loadProfile() async {
    final client = NorieSupabase.client;
    final currentUser = _user;
    if (client == null || currentUser == null) return;

    try {
      final row = await client
          .from('profiles')
          .select('display_name')
          .eq('id', currentUser.id)
          .maybeSingle();

      final value = row?['display_name'] as String?;
      _displayName = value?.trim().isNotEmpty == true
          ? value!.trim()
          : (currentUser.userMetadata?['display_name'] as String?);
    } catch (_) {
      _displayName =
          currentUser.userMetadata?['display_name'] as String?;
    }
  }

  void _setWorking() {
    _status = NorieAccountStatus.working;
    _message = null;
    notifyListeners();
  }

  String _setError(String message) {
    _status = NorieAccountStatus.error;
    _message = message;
    notifyListeners();
    return message;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
