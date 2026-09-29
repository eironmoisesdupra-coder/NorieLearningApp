import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../norie_app_context.dart';
import 'norie_voice_policy.dart';

class NorieVoiceController extends ChangeNotifier {
  NorieVoiceController({AudioPlayer? player}) : _player = player;

  static const preferenceKey = 'norie.mascot.voiceEnabled';

  AudioPlayer? _player;
  bool _enabled = false;
  bool _disposed = false;

  bool get enabled => _enabled;

  Future<void> loadEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(preferenceKey) ?? false;
    _notify();
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(preferenceKey, value);
    if (!value) {
      await stop();
    }
    _notify();
  }

  Future<void> playAsset(
    String assetPath, {
    required NorieAppArea area,
  }) async {
    if (!NorieVoicePolicy.canAutoPlay(area, userEnabled: _enabled)) return;

    final normalized = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;
    if (normalized.trim().isEmpty) return;

    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource(normalized));
    } catch (_) {
      // Voice is optional. Text and animation remain the authoritative UX.
    }
  }

  Future<void> stop() async {
    final player = _player;
    if (player == null) return;
    try {
      await player.stop();
    } catch (_) {
      // Optional audio failure must not affect the app.
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    final player = _player;
    _player = null;
    if (player != null) {
      unawaited(player.dispose());
    }
    super.dispose();
  }
}
