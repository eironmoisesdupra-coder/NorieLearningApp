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
  bool _emailConfirmationRequired = false;
  bool _passwordRecovery = false;
  String? _pendingEmail;

  User? get user => _user;
  String? get displayName => _displayName;
  String? get email => _user?.email;
  String? get pendingEmail => _pendingEmail;
  NorieAccountStatus get status => _status;
  String? get message => _message;
  bool get isSignedIn => _user != null;
  bool get isCloudConfigured => NorieSupabase.isConfigured;
  bool get isCloudReady => NorieSupabase.isInitialized;
  bool get emailConfirmationRequired => _emailConfirmationRequired;
  bool get isPasswordRecovery => _passwordRecovery;

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
      if (event.event == AuthChangeEvent.passwordRecovery) {
        _passwordRecovery = true;
      }

      _user = event.session?.user;
      if (_user == null) {
        _displayName = null;
        _status = NorieAccountStatus.signedOut;
      } else {
        _status = NorieAccountStatus.signedIn;
        _emailConfirmationRequired = false;
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

    final normalizedEmail = email.trim().toLowerCase();
    _pendingEmail = normalizedEmail;
    _emailConfirmationRequired = false;
    _setWorking();

    try {
      final response = await client.auth.signInWithPassword(
        email: normalizedEmail,
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
      final friendly = _friendlyAuthError(error.message);
      if (error.message.toLowerCase().contains('email not confirmed')) {
        _emailConfirmationRequired = true;
      }
      return _setError(friendly);
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

    final normalizedEmail = email.trim().toLowerCase();
    _pendingEmail = normalizedEmail;
    _emailConfirmationRequired = false;
    _setWorking();

    try {
      final approved = await isDemoEmailApproved(normalizedEmail);
      if (!approved) {
        return _setError(
          'This email is not approved for the private Norie demo.',
        );
      }

      final response = await client.auth.signUp(
        email: normalizedEmail,
        password: password,
        emailRedirectTo: NorieSupabase.appUrl,
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
        _user = null;
        _status = NorieAccountStatus.signedOut;
        _emailConfirmationRequired = true;
        _message =
            'Account created. Confirm your email, then return to Norie and sign in.';
      }

      notifyListeners();
      return _message;
    } on AuthException catch (error) {
      return _setError(_friendlyAuthError(error.message));
    } catch (_) {
      return _setError('Unable to create the account right now.');
    }
  }

  Future<bool> isDemoEmailApproved(String email) async {
    final client = NorieSupabase.client;
    if (client == null) return false;

    try {
      final result = await client.rpc(
        'is_demo_email_approved',
        params: {'candidate_email': email.trim().toLowerCase()},
      );
      return result == true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> resendConfirmation([String? email]) async {
    final client = NorieSupabase.client;
    if (client == null) {
      return 'Cloud sync is unavailable right now.';
    }

    final target = (email ?? _pendingEmail ?? '').trim().toLowerCase();
    if (target.isEmpty || !target.contains('@')) {
      return 'Enter the email address you used to create the account.';
    }

    try {
      await client.auth.resend(
        type: OtpType.signup,
        email: target,
      );
      _pendingEmail = target;
      _emailConfirmationRequired = true;
      _message = 'Confirmation email resent. Check your inbox and spam folder.';
      notifyListeners();
      return null;
    } on AuthException catch (error) {
      return _friendlyAuthError(error.message);
    } catch (_) {
      return 'Could not resend the confirmation email right now.';
    }
  }

  Future<String?> requestPasswordReset(String email) async {
    final client = NorieSupabase.client;
    if (client == null) {
      return 'Cloud sync is unavailable right now.';
    }

    final target = email.trim().toLowerCase();
    if (target.isEmpty || !target.contains('@')) {
      return 'Enter a valid email address first.';
    }

    try {
      await client.auth.resetPasswordForEmail(
        target,
        redirectTo: NorieSupabase.appUrl,
      );
      _message =
          'Password reset email sent. Open the link to return to Norie.';
      notifyListeners();
      return null;
    } on AuthException catch (error) {
      return _friendlyAuthError(error.message);
    } catch (_) {
      return 'Could not send the password reset email right now.';
    }
  }

  Future<String?> updatePassword(String newPassword) async {
    final client = NorieSupabase.client;
    if (client == null || client.auth.currentSession == null) {
      return 'Open the password-reset link from your email first.';
    }

    if (newPassword.length < 8) {
      return 'Use a password with at least 8 characters.';
    }

    _setWorking();
    try {
      await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _passwordRecovery = false;
      _status = NorieAccountStatus.signedIn;
      _message = 'Password updated successfully.';
      notifyListeners();
      return null;
    } on AuthException catch (error) {
      return _setError(_friendlyAuthError(error.message));
    } catch (_) {
      return _setError('Could not update your password right now.');
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
    _emailConfirmationRequired = false;
    _passwordRecovery = false;
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

  void clearMessage() {
    _message = null;
    notifyListeners();
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

  static String _friendlyAuthError(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('email not confirmed')) {
      return 'Email not confirmed yet. Confirm it from your inbox or resend the confirmation email below.';
    }
    if (lower.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('user already registered')) {
      return 'An account already exists for this email. Try signing in instead.';
    }
    if (lower.contains('rate limit') ||
        lower.contains('too many requests') ||
        lower.contains('security purposes')) {
      return 'Too many requests. Wait a little before trying again.';
    }
    if (lower.contains('password')) {
      return message;
    }

    return message;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
