import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class NorieSupabase {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lafuuwoohizgwnrbbgqj.supabase.co',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_OiH83RLCfyWZ1uzjRw240Q_dY9FwV-W',
  );

  static const appUrl =
      'https://eironmoisesdupra-coder.github.io/NorieLearningApp/';

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
