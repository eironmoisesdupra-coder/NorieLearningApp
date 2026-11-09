import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/audio/norie_audio_manager.dart';

Future<void> prepareAtlasWidgetTest() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({
    'norie.totalXp': 0,
    'norie.credits': 0,
    'norie.audio.musicEnabled': false,
    'norie.audio.sfxEnabled': false
  });
  await SharedPreferences.getInstance();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'), (_) async => null);
  messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global/events'),
      (_) async => null);
  messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'), (call) async {
    if (call.method == 'create') {
      final id = (call.arguments as Map)['playerId'];
      messenger.setMockMethodCallHandler(
          MethodChannel('xyz.luan/audioplayers/events/$id'), (_) async => null);
    }
    return null;
  });
  NorieProgression.instance.resetAsyncQueuesForTesting();
  await NorieProgression.instance.load();
  await NorieAudioManager.instance.load();
}

/// Wait for real preference operations, without waiting on the 3D spinner.
Future<void> waitForAtlasIo(WidgetTester tester) async {
  for (var i = 0; i < 100; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 1)));
    final busy = find.byWidgetPredicate((w) =>
        w is CircularProgressIndicator &&
            w.semanticsLabel == 'Opening saved quiz' ||
        w is LinearProgressIndicator &&
            w.semanticsLabel == 'Saving quiz progress');
    if (busy.evaluate().isEmpty) {
      await tester.pump(const Duration(milliseconds: 50));
      return;
    }
  }
  throw TestFailure('Atlas local IO did not settle.');
}
