import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/audio/norie_audio_manager.dart';
import 'package:norie_learning/core/audio/norie_audio_settings_screen.dart';
import 'norie_audio_manager_test.dart' show RecordingBackend;

void main() {
  testWidgets('audio settings fit a small phone and update persistent controls',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final audio = NorieAudioManager(backend: RecordingBackend());
    await audio.load();
    tester.view.resetPhysicalSize();
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
        MaterialApp(home: NorieAudioSettingsScreen(manager: audio)));
    expect(find.text('Music available offline'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(Switch).at(1));
    await tester.pumpAndSettle();
    expect(audio.sfxEnabled, false);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('norie.audio.sfxEnabled'), false);
    await tester.pumpWidget(const SizedBox());
    audio.dispose();
  });
}
