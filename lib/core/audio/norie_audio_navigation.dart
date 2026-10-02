import 'package:flutter/widgets.dart';
import 'norie_audio_manager.dart';

/// Route transitions cover menu, subject, grade, lesson and settings navigation
/// without duplicating callbacks across every button. Quiz result dialogs own
/// their completion sound, so popup routes and replacements stay silent here.
class NorieAudioNavigation extends NavigatorObserver {
  NorieAudioNavigation({NorieAudioManager? manager})
      : _audio = manager ?? NorieAudioManager.instance;
  final NorieAudioManager _audio;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null && route is PageRoute) _audio.playUiOpen();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) _audio.playUiBack();
  }
}
