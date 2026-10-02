import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'norie_audio_backend.dart';

NorieAudioBackend createBackend() => BrowserAudioBackend();

/// Reuses six media elements so Safari can unlock each inside a real gesture.
/// Unlike the plugin's web player this does not create private AudioContexts
/// later, after an asynchronous asset load has lost the browser's activation.
class BrowserAudioBackend implements NorieAudioBackend, GestureAudioBackend {
  final _music = List.generate(2, (_) => web.HTMLAudioElement());
  final _sfx = List.generate(4, (_) => web.HTMLAudioElement());
  final _positions = StreamController<MusicPosition>.broadcast();
  final _subscriptions = <StreamSubscription<web.Event>>[];
  final _priming = <web.HTMLAudioElement, Future<void>>{};
  final _primed = <web.HTMLAudioElement>{};
  int _nextSfx = 0;
  bool _disposed = false;

  BrowserAudioBackend() {
    for (var i = 0; i < _music.length; i++) {
      final player = _music[i];
      void emit(web.Event _) {
        if (_disposed || !player.duration.isFinite) return;
        _positions.add(MusicPosition(
          i,
          Duration(milliseconds: (player.currentTime * 1000).round()),
          Duration(milliseconds: (player.duration * 1000).round()),
        ));
      }

      _subscriptions.add(player.onTimeUpdate.listen(emit));
      _subscriptions.add(player.onEnded.listen(emit));
    }
  }

  @override
  Stream<MusicPosition> get musicPositions => _positions.stream;

  @override
  Future<void> unlockFromGesture() {
    // A single silent PCM sample is browser transport priming, not a soundtrack.
    const silence = 'data:audio/wav;base64,'
        'UklGRiYAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YQIAAAAAAA==';
    final pending = <Future<void>>[];
    for (final player in [..._music, ..._sfx]) {
      if (_primed.contains(player) || _priming.containsKey(player)) continue;
      player.src = silence;
      player.volume = 0;
      // Issue every play() before yielding; each element needs gesture approval.
      final future = player.play().toDart.then((_) {
        player.pause();
        if (!_disposed) _primed.add(player);
      }).catchError((Object _) {
        // A subsequent pointer/key gesture will retry this element.
      }).whenComplete(() {
        _priming.remove(player);
      });
      _priming[player] = future;
      pending.add(future);
    }
    return Future.wait(pending);
  }

  String _assetUrl(String asset) =>
      Uri.base.resolve('assets/assets/$asset').toString();

  @override
  Future<void> preload(List<String> assets) async {
    // Bundled files remain available through Flutter's offline asset cache.
    // Do not change primed players' sources or fetch music on startup.
  }

  Future<void> _play(
      web.HTMLAudioElement player, String asset, double volume) async {
    await _priming[player];
    if (_disposed) return;
    player.pause();
    player.src = _assetUrl(asset);
    player.volume = volume;
    player.currentTime = 0;
    await player.play().toDart;
  }

  @override
  Future<void> playSfx(String asset, double volume) =>
      _play(_sfx[_nextSfx++ % _sfx.length], asset, volume);

  @override
  Future<void> stopSfx() async {
    for (final player in _sfx) {
      player.pause();
      player.currentTime = 0;
    }
  }

  @override
  Future<void> startMusic(int channel, String asset) =>
      _play(_music[channel], asset, 0);

  @override
  Future<void> setMusicVolume(int channel, double volume) async {
    _music[channel].volume = volume;
  }

  @override
  Future<void> pauseMusic(int channel) async => _music[channel].pause();

  @override
  Future<void> resumeMusic(int channel) async {
    await _music[channel].play().toDart;
  }

  @override
  Future<void> stopMusic(int channel) async {
    _music[channel].pause();
    _music[channel].currentTime = 0;
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    for (final player in [..._music, ..._sfx]) {
      player.pause();
      player.removeAttribute('src');
      player.load();
    }
    await _positions.close();
  }
}
