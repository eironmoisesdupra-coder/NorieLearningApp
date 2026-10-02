import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'norie_audio_backend_factory.dart'
    if (dart.library.js_interop) 'norie_audio_web_backend.dart'
    as platform_backend;

NorieAudioBackend createNorieAudioBackend() => platform_backend.createBackend();

/// Called directly from the gesture, before preferences or assets are awaited.
abstract interface class GestureAudioBackend {
  Future<void> unlockFromGesture();
}

class MusicPosition {
  const MusicPosition(this.channel, this.position, this.duration);
  final int channel;
  final Duration position;
  final Duration duration;
}

abstract interface class NorieAudioBackend {
  Stream<MusicPosition> get musicPositions;
  Future<void> preload(List<String> assets);
  Future<void> playSfx(String asset, double volume);
  Future<void> stopSfx();
  Future<void> startMusic(int channel, String asset);
  Future<void> setMusicVolume(int channel, double volume);
  Future<void> pauseMusic(int channel);
  Future<void> resumeMusic(int channel);
  Future<void> stopMusic(int channel);
  Future<void> dispose();
}

/// Players are allocated once, lazily after a gesture. AssetCache warms common
/// effects; a bounded four-player pool allows selection and feedback to overlap.
class AssetAudioBackend implements NorieAudioBackend {
  final _cache = AudioCache();
  final _positions = StreamController<MusicPosition>.broadcast();
  final _subscriptions = <StreamSubscription<dynamic>>[];
  final _music = <AudioPlayer>[];
  final _sfx = <AudioPlayer>[];
  final _durations = <int, Duration>{};
  int _nextSfx = 0;
  @override
  Stream<MusicPosition> get musicPositions => _positions.stream;
  void _initialize() {
    if (_music.isNotEmpty) return;
    for (var i = 0; i < 2; i++) {
      final player = AudioPlayer();
      _music.add(player);
      _subscriptions
          .add(player.onDurationChanged.listen((d) => _durations[i] = d));
      _subscriptions.add(player.onPositionChanged.listen((p) {
        final d = _durations[i];
        if (d != null) _positions.add(MusicPosition(i, p, d));
      }));
      _subscriptions.add(player.onPlayerComplete.listen((_) {
        final d = _durations[i] ?? Duration.zero;
        _positions.add(MusicPosition(i, d, d));
      }));
    }
    _sfx.addAll(List.generate(4, (_) => AudioPlayer()..audioCache = _cache));
  }

  @override
  Future<void> preload(List<String> assets) async {
    _initialize();
    for (final asset in assets) {
      try {
        await _cache.load(asset);
      } catch (_) {/* Optional asset. */}
    }
  }

  @override
  Future<void> playSfx(String asset, double volume) async {
    _initialize();
    final player = _sfx[_nextSfx++ % _sfx.length];
    await player.stop();
    await player.play(AssetSource(asset), volume: volume);
  }

  @override
  Future<void> stopSfx() async {
    for (final p in _sfx) {
      await p.stop();
    }
  }

  @override
  Future<void> startMusic(int channel, String asset) async {
    _initialize();
    _durations.remove(channel);
    await _music[channel].play(AssetSource(asset), volume: 0);
  }

  @override
  Future<void> setMusicVolume(int channel, double volume) async {
    if (_music.isNotEmpty) await _music[channel].setVolume(volume);
  }

  @override
  Future<void> pauseMusic(int channel) async {
    if (_music.isNotEmpty) await _music[channel].pause();
  }

  @override
  Future<void> resumeMusic(int channel) async {
    if (_music.isNotEmpty) await _music[channel].resume();
  }

  @override
  Future<void> stopMusic(int channel) async {
    if (_music.isNotEmpty) await _music[channel].stop();
  }

  @override
  Future<void> dispose() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    for (final p in [..._music, ..._sfx]) {
      await p.dispose();
    }
    await _positions.close();
  }
}
