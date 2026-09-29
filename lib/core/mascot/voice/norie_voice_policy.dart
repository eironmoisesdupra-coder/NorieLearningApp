import '../norie_app_context.dart';

abstract final class NorieVoicePolicy {
  static bool canAutoPlay(
    NorieAppArea area, {
    required bool userEnabled,
  }) {
    if (!userEnabled) return false;
    return area == NorieAppArea.tutorial || area == NorieAppArea.help;
  }
}
