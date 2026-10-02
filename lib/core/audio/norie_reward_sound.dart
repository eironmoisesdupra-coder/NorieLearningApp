import 'package:flutter/services.dart';
import 'norie_audio_manager.dart';

abstract final class NorieRewardSound {
  static Future<void> playCoin() async {
    await HapticFeedback.lightImpact();
    await NorieAudioManager.instance.playLevelUp();
  }
}
