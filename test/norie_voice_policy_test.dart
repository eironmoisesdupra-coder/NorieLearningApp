import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/mascot/norie_app_context.dart';
import 'package:norie_learning/core/mascot/voice/norie_voice_controller.dart';
import 'package:norie_learning/core/mascot/voice/norie_voice_policy.dart';

void main() {
  group('NorieVoicePolicy', () {
    test('quiz never auto-plays voice', () {
      expect(
        NorieVoicePolicy.canAutoPlay(
          NorieAppArea.quiz,
          userEnabled: true,
        ),
        isFalse,
      );
    });

    test('tutorial and help require user opt-in', () {
      expect(
        NorieVoicePolicy.canAutoPlay(
          NorieAppArea.tutorial,
          userEnabled: false,
        ),
        isFalse,
      );
      expect(
        NorieVoicePolicy.canAutoPlay(
          NorieAppArea.tutorial,
          userEnabled: true,
        ),
        isTrue,
      );
      expect(
        NorieVoicePolicy.canAutoPlay(
          NorieAppArea.help,
          userEnabled: true,
        ),
        isTrue,
      );
    });
  });

  group('NorieVoiceController preference', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('voice preference defaults to disabled', () async {
      final controller = NorieVoiceController();
      addTearDown(controller.dispose);

      await controller.loadEnabled();

      expect(controller.enabled, isFalse);
    });

    test('voice preference persists after enabling', () async {
      final controller = NorieVoiceController();
      addTearDown(controller.dispose);

      await controller.setEnabled(true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('norie.mascot.voiceEnabled'), isTrue);
      expect(controller.enabled, isTrue);
    });
  });
}
