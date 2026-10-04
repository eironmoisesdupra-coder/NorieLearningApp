import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/audio/norie_audio_manager.dart';
import 'package:norie_learning/core/audio/norie_audio_backend.dart';

class RecordingBackend implements NorieAudioBackend, GestureAudioBackend {
  int gestureCalls = 0;
  @override
  Future<void> unlockFromGesture() {
    gestureCalls++;
    return Future<void>.value();
  }

  bool rejectNextStart = false;
  Completer<void>? sfxStarted;
  Completer<void>? releaseSfx;
  final events = <String>[];
  final levels = <int, double>{};
  final positions = StreamController<MusicPosition>.broadcast();
  @override
  Stream<MusicPosition> get musicPositions => positions.stream;
  @override
  Future<void> preload(List<String> assets) async {}
  @override
  Future<void> playSfx(String asset, double volume) async {
    sfxStarted?.complete();
    await releaseSfx?.future;
    events.add(asset);
  }

  @override
  Future<void> stopSfx() async {
    events.add('stopSfx');
  }

  @override
  Future<void> startMusic(int channel, String asset) async {
    if (rejectNextStart) {
      rejectNextStart = false;
      throw StateError('autoplay blocked');
    }
    events.add('start:$channel:$asset');
  }

  @override
  Future<void> setMusicVolume(int channel, double volume) async {
    levels[channel] = volume;
  }

  @override
  Future<void> pauseMusic(int channel) async {
    events.add('pause:$channel');
  }

  @override
  Future<void> resumeMusic(int channel) async {
    events.add('resume:$channel');
  }

  @override
  Future<void> stopMusic(int channel) async {
    events.add('stop:$channel');
  }

  @override
  Future<void> dispose() async {
    await positions.close();
  }
}

void main() {
  test('production playlist contains five bundled music tracks', () {
    expect(NorieAudioManager.availableMusic, hasLength(5));
    expect(NorieAudioManager.availableMusic.toSet(), hasLength(5));
    for (final asset in NorieAudioManager.availableMusic) {
      expect(asset, startsWith('audio/music/'));
      expect(asset, endsWith('.mp3'));
    }
  });
  test('browser priming starts synchronously and retries on later gestures',
      () async {
    final backend = RecordingBackend();
    final audio = NorieAudioManager(backend: backend);
    final first = audio.unlock();
    expect(backend.gestureCalls, 1);
    await first;
    final second = audio.unlock();
    expect(backend.gestureCalls, 2);
    await second;
    audio.dispose();
  });
  test(
      'zero volume stops an effect after pending startup and skips queued effects',
      () async {
    SharedPreferences.setMockInitialValues({});
    final backend = RecordingBackend()
      ..sfxStarted = Completer<void>()
      ..releaseSfx = Completer<void>();
    final audio = NorieAudioManager(backend: backend, playlist: const []);
    await audio.unlock();
    final playing = audio.playUiTap();
    await backend.sfxStarted!.future;
    final queued = audio.playUiSelect();
    final muting = audio.setSfxVolume(0);
    await Future<void>.delayed(Duration.zero);
    backend.releaseSfx!.complete();
    await Future.wait([playing, queued, muting]);
    expect(backend.events, ['audio/sfx/ui_tap.mp3', 'stopSfx']);
    await audio.playUiBack();
    expect(backend.events.last, 'stopSfx');
    audio.dispose();
  });
  test('muting while an effect starts stops it after startup completes',
      () async {
    SharedPreferences.setMockInitialValues({});
    final backend = RecordingBackend()
      ..sfxStarted = Completer<void>()
      ..releaseSfx = Completer<void>();
    final audio = NorieAudioManager(backend: backend);
    await audio.load();
    await audio.unlock();
    final playing = audio.playUiTap();
    await backend.sfxStarted!.future;
    final muting = audio.setSfxEnabled(false);
    await Future<void>.delayed(Duration.zero);
    backend.releaseSfx!.complete();
    await playing;
    await muting;
    expect(backend.events.last, 'stopSfx');
    audio.dispose();
  });
  testWidgets(
      'mute and background suspend a crossfade, resume does not restart',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final backend = RecordingBackend();
    final audio = NorieAudioManager(backend: backend, playlist: ['one', 'two']);
    await audio.load();
    await audio.unlock();
    await tester.pump(const Duration(seconds: 3));
    backend.positions.add(
        const MusicPosition(0, Duration(seconds: 8), Duration(seconds: 10)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await audio.setMusicEnabled(false);
    await audio.setForeground(false);
    await tester.pump(const Duration(seconds: 4));
    expect(backend.events, isNot(contains('stop:0')));
    expect(audio.effectiveMusicVolume, 0);
    await audio.setMusicEnabled(true);
    expect(audio.effectiveMusicVolume, 0);
    await audio.setForeground(true);
    await tester.pump(const Duration(seconds: 3));
    expect(backend.events.where((e) => e.startsWith('start:')).length, 2);
    expect(backend.events, contains('stop:0'));
    expect(backend.levels[0], 0);
    expect(backend.levels[1], closeTo(.3, .001));
    audio.dispose();
  });
  test(
      'nested contexts restore reading gain and every effect maps to its local asset',
      () async {
    SharedPreferences.setMockInitialValues({});
    final backend = RecordingBackend();
    final audio = NorieAudioManager(backend: backend, playlist: const []);
    await audio.load();
    await audio.unlock();
    final reading = audio.enterContext(NorieAudioContext.lesson);
    final quiz = audio.enterContext(NorieAudioContext.quiz);
    expect(audio.effectiveMusicVolume, closeTo(.195, .001));
    audio.leaveContext(quiz);
    expect(audio.effectiveMusicVolume, .15);
    audio.leaveContext(reading);
    for (final play in [
      audio.playUiTap,
      audio.playUiSelect,
      audio.playUiOpen,
      audio.playUiBack,
      audio.playQuizSelect,
      audio.playCorrect,
      audio.playWrong,
      audio.playChallengeStart,
      audio.playComplete,
      audio.playAchievement,
      audio.playLevelUp,
      audio.playPerfect
    ]) {
      await play();
    }
    expect(backend.events.toSet(), {
      'audio/sfx/ui_tap.mp3',
      'audio/sfx/ui_select.mp3',
      'audio/sfx/ui_open.mp3',
      'audio/sfx/ui_back.mp3',
      'audio/sfx/quiz_select.mp3',
      'audio/sfx/correct.mp3',
      'audio/sfx/wrong.mp3',
      'audio/sfx/challenge_start.mp3',
      'audio/sfx/complete.mp3',
      'audio/sfx/achievement.mp3',
      'audio/sfx/level_up.mp3',
      'audio/sfx/perfect.mp3'
    });
    audio.dispose();
  });
  test('failed autoplay can retry on a later gesture', () async {
    SharedPreferences.setMockInitialValues({});
    final backend = RecordingBackend()..rejectNextStart = true;
    final audio = NorieAudioManager(backend: backend, playlist: ['one']);
    await audio.load();
    await audio.unlock();
    await audio.unlock();
    expect(backend.events.where((e) => e.startsWith('start:')).length, 1);
    audio.dispose();
  });
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('preferences persist independently and clamp volume', () async {
    final a = NorieAudioManager(backend: RecordingBackend());
    await a.load();
    await a.setMusicEnabled(false);
    await a.setSfxVolume(2);
    await a.setMusicVolume(-1);
    await a.setQuietLessons(false);
    final b = NorieAudioManager(backend: RecordingBackend());
    await b.load();
    expect(b.musicEnabled, false);
    expect(b.sfxEnabled, true);
    expect(b.sfxVolume, 1);
    expect(b.musicVolume, 0);
    expect(b.quietLessons, false);
    a.dispose();
    b.dispose();
  });
  test(
      'feedback selects correct asset, suppresses duplicates and respects mute',
      () async {
    final backend = RecordingBackend();
    final a = NorieAudioManager(backend: backend, playlist: const []);
    await a.load();
    await a.unlock();
    await a.playCorrect();
    await a.playCorrect();
    await a.playWrong();
    expect(backend.events.where((e) => e.endsWith('.mp3')),
        ['audio/sfx/correct.mp3', 'audio/sfx/wrong.mp3']);
    await a.setSfxEnabled(false);
    await a.playUiTap();
    expect(backend.events.last, 'stopSfx');
    a.dispose();
  });
  test('music waits for gesture, context attenuates and resume preserves track',
      () async {
    final backend = RecordingBackend();
    final a = NorieAudioManager(backend: backend, playlist: ['one', 'two']);
    await a.load();
    expect(backend.events, isEmpty);
    await a.unlock();
    expect(backend.events.where((e) => e.startsWith('start:')).length, 1);
    final token = a.enterContext(NorieAudioContext.lesson);
    expect(a.effectiveMusicVolume, closeTo(.15, .001));
    a.leaveContext(token);
    expect(a.effectiveMusicVolume, closeTo(.3, .001));
    await a.setForeground(false);
    await a.setForeground(true);
    expect(backend.events.where((e) => e.startsWith('start:')).length, 1);
    expect(backend.events, contains('resume:0'));
    a.dispose();
  });
  testWidgets('production rotation plays all five before repeating',
      (tester) async {
    final backend = RecordingBackend();
    final audio = NorieAudioManager(backend: backend);
    await audio.load();
    expect(backend.events, isEmpty);
    await audio.unlock();
    await tester.pump(const Duration(seconds: 3));
    for (var transition = 0; transition < 10; transition++) {
      backend.positions.add(MusicPosition(transition % 2,
          const Duration(seconds: 98), const Duration(seconds: 100)));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
    }
    final tracks = backend.events
        .where((event) => event.startsWith('start:'))
        .map((event) => event.split(':').last)
        .toList();
    expect(tracks, hasLength(11));
    expect(tracks.take(5).toSet(), NorieAudioManager.availableMusic.toSet());
    expect(tracks.skip(5).take(5), tracks.take(5));
    expect(tracks.last, tracks.first);
    expect(backend.levels.values.where((volume) => volume > 0), hasLength(1));
    audio.dispose();
  });
  testWidgets('playlist crossfades without repeating and ducks temporarily',
      (tester) async {
    final backend = RecordingBackend();
    final a = NorieAudioManager(backend: backend, playlist: ['one', 'two']);
    await a.load();
    await a.unlock();
    await a.playCorrect();
    expect(a.effectiveMusicVolume, closeTo(.195, .001));
    await tester.pump(const Duration(seconds: 1));
    expect(a.effectiveMusicVolume, .3);
    backend.positions.add(
        const MusicPosition(0, Duration(seconds: 8), Duration(seconds: 10)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    final starts = backend.events.where((e) => e.startsWith('start:')).toList();
    expect(starts.length, 2);
    expect(starts[0].split(':').last, isNot(starts[1].split(':').last));
    expect(backend.events, contains('stop:0'));
    a.dispose();
  });
}
