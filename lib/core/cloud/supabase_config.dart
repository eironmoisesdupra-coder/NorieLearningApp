import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class NorieSupabase {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool _initialized = false;

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
  static bool get isInitialized => _initialized;

  static SupabaseClient? get client {
    if (!_initialized) return null;
    return Supabase.instance.client;
  }

  static Future<bool> initialize() async {
    if (_initialized) return true;
    if (!isConfigured) return false;

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: publishableKey,
      );
      _initialized = true;
      return true;
    } catch (_) {
      _initialized = false;
      return false;
    }
  }
}
