import 'dart:async';

import 'package:flutter/foundation.dart';

import '../account/norie_account_service.dart';
import '../cloud/supabase_config.dart';

enum NorieDemoAccessStatus {
  signedOut,
  checking,
  allowed,
  denied,
  error,
}

class NorieDemoAccessService extends ChangeNotifier {
  NorieDemoAccessService._();

  static final NorieDemoAccessService instance = NorieDemoAccessService._();

  bool _initialized = false;
  bool _checking = false;
  NorieDemoAccessStatus _status = NorieDemoAccessStatus.signedOut;
  String? _message;

  NorieDemoAccessStatus get status => _status;
  String? get message => _message;
  bool get isAllowed => _status == NorieDemoAccessStatus.allowed;
  bool get isChecking => _status == NorieDemoAccessStatus.checking;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    NorieAccountService.instance.addListener(_handleAccountChanged);
    await refresh();
  }

  void _handleAccountChanged() {
    unawaited(refresh());
  }

  Future<void> refresh() async {
    if (_checking) return;

    final account = NorieAccountService.instance;
    final client = NorieSupabase.client;
    final email = account.email?.trim().toLowerCase();

    if (!account.isSignedIn || email == null || email.isEmpty) {
      _message = null;
      _setStatus(NorieDemoAccessStatus.signedOut);
      return;
    }

    if (client == null) {
      _message = 'Private demo access could not be verified.';
      _setStatus(NorieDemoAccessStatus.error);
      return;
    }

    _checking = true;
    _setStatus(NorieDemoAccessStatus.checking);

    try {
      final row = await client
          .from('demo_access')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      if (row == null) {
        _message =
            'This account is not approved for the private Norie demo.';
        _setStatus(NorieDemoAccessStatus.denied);
      } else {
        _message = null;
        _setStatus(NorieDemoAccessStatus.allowed);
      }
    } catch (_) {
      _message =
          'Norie could not verify private demo access right now.';
      _setStatus(NorieDemoAccessStatus.error);
    } finally {
      _checking = false;
    }
  }

  void _setStatus(NorieDemoAccessStatus value) {
    _status = value;
    notifyListeners();
  }
}
