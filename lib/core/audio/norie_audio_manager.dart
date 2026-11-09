import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'norie_audio_backend.dart';

enum NorieAudioContext { menu, lesson, quiz, anatomy }

enum NorieAudioTheme { classic, spaceAdventure }

class NorieAudioManager extends ChangeNotifier {
  NorieAudioManager(
      {NorieAudioBackend? backend,
      List<String>? playlist,
      Random? random})
      : _backend = backend ?? createNorieAudioBackend(),
        _playlistOverride = playlist == null ? null : List.unmodifiable(playlist),
        _playlist = List.unmodifiable(
            playlist ?? musicForTheme(NorieAudioTheme.classic)),
        _random = random ?? Random() {
    _positionSubscription = _backend.musicPositions.listen(_onPosition);
  }
  static final instance = NorieAudioManager();
  static const classicMusic = [
    'audio/music/synthwave_4k.mp3',
    'audio/music/vaporware.mp3',
    'audio/music/lifewave_2k.mp3',
    'audio/music/synthwave_15k.mp3',
    'audio/music/synthwave_421k.mp3'
  ];
  static const expectedMusic = [
    'audio/music/norie_starbound.mp3',
    'audio/music/norie_bright_horizons.mp3',
    'audio/music/norie_discovery_run.mp3',
    'audio/music/norie_cosmic_trail.mp3',
    'audio/music/norie_next_frontier.mp3'
  ];
  static const List<String> availableMusic = classicMusic;
  static List<String> musicForTheme(NorieAudioTheme theme) =>
      theme == NorieAudioTheme.classic ? classicMusic : expectedMusic;
  static const crossfadeDuration = Duration(milliseconds: 2500);
  final NorieAudioBackend _backend;
  final List<String>? _playlistOverride;
  List<String> _playlist;
  final Random _random;
  NorieAudioTheme _theme = NorieAudioTheme.classic;
  late final StreamSubscription<MusicPosition> _positionSubscription;
  final _contexts = <Object, NorieAudioContext>{};
  final _lastEffects = <String, DateTime>{};
  Future<void>? _loading;
  Future<void> _transport = Future.value();
  Future<void> _effects = Future.value();
  SharedPreferences? _prefs;
  Timer? _fadeTimer, _duckTimer;
  bool _disposed = false,
      _unlocked = false,
      _foreground = true,
      _started = false,
      _transitioning = false;
  bool _musicEnabled = true, _sfxEnabled = true, _quietLessons = true;
  double _musicVolume = .3, _sfxVolume = .68, _duck = 1;
  final _weights = [0.0, 0.0];
  int _activeChannel = 0, _track = -1;
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get quietLessons => _quietLessons;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  NorieAudioTheme get theme => _theme;
  bool get musicAvailable => _playlist.isNotEmpty;
  String get musicStatus =>
      musicAvailable ? 'Music available offline' : 'Soundtrack coming soon';
  double get effectiveMusicVolume {
    final context =
        _contexts.isEmpty ? NorieAudioContext.menu : _contexts.values.last;
    final gain = switch (context) {
      NorieAudioContext.lesson => _quietLessons ? .5 : 1.0,
      NorieAudioContext.quiz => .65,
      NorieAudioContext.anatomy => .8,
      NorieAudioContext.menu => 1.0
    };
    return _musicEnabled && _foreground ? _musicVolume * gain * _duck : 0;
  }

  Future<void> _switchTheme() async {
    if (!_started) return;
    _fadeTimer?.cancel();
    var outgoing = _activeChannel;
    final other = 1 - outgoing;
    if (_transitioning && _weights[other] > _weights[outgoing]) {
      outgoing = other;
    }
    final incoming = 1 - outgoing;
    _transitioning = false;
    if (!_unlocked || !_musicEnabled || !_foreground) {
      await _backend.stopMusic(0);
      await _backend.stopMusic(1);
      _weights[0] = 0;
      _weights[1] = 0;
      _started = false;
      _activeChannel = 0;
      return;
    }
    await _backend.stopMusic(incoming);
    _weights[outgoing] = 1;
    _weights[incoming] = 0;
    await _backend.setMusicVolume(outgoing, effectiveMusicVolume);
    _track = _random.nextInt(_playlist.length);
    try {
      await _backend.startMusic(incoming, _playlist[_track]);
      _activeChannel = incoming;
      _beginFade(outgoing, incoming);
    } catch (_) {
      _started = false;
      _unlocked = false;
      rethrow;
    }
  }

  Future<void> load() => _loading ??= _load();
  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    _musicEnabled = _prefs!.getBool('norie.audio.musicEnabled') ?? true;
    _sfxEnabled = _prefs!.getBool('norie.audio.sfxEnabled') ?? true;
    _quietLessons = _prefs!.getBool('norie.audio.quietLessons') ?? true;
    _musicVolume = _clamp(_prefs!.getDouble('norie.audio.musicVolume') ?? .3);
    _sfxVolume = _clamp(_prefs!.getDouble('norie.audio.sfxVolume') ?? .68);
    _theme = _prefs!.getString('norie.audio.theme') == 'spaceAdventure'
        ? NorieAudioTheme.spaceAdventure
        : NorieAudioTheme.classic;
    _playlist =
        List.unmodifiable(_playlistOverride ?? musicForTheme(_theme));
    _notify();
  }

  double _clamp(double value) =>
      value.isFinite ? value.clamp(0, 1).toDouble() : 0;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> setTheme(NorieAudioTheme value) async {
    await load();
    if (_theme == value) return;
    _theme = value;
    _playlist = List.unmodifiable(_playlistOverride ?? musicForTheme(value));
    _notify();
    await _prefs!.setString('norie.audio.theme', value.name);
    if (_unlocked) {
      await _queueEffect(_backend.stopSfx);
      unawaited(_safe(() => _backend.preload(_commonEffects)));
    }
    await _queue(_switchTheme);
  }

  List<String> get _commonEffects => [
        _effectAsset('ui_tap'),
        _effectAsset('quiz_select'),
        _effectAsset('correct'),
        _effectAsset('wrong')
      ];

  Future<void> _safe(Future<void> Function() action) async {
    try {
      if (!_disposed) await action();
    } catch (_) {/* Audio must never block learning. */}
  }

  Future<void> _queue(Future<void> Function() action) =>
      _transport = _transport.then((_) => _safe(action));
  Future<void> _queueEffect(Future<void> Function() action) =>
      _effects = _effects.then((_) => _safe(action));
  Future<void> unlock() async {
    if (_disposed) return;
    final backend = _backend;
    // Start browser priming synchronously within the pointer/key callback.
    final priming = backend is GestureAudioBackend
        ? (backend as GestureAudioBackend).unlockFromGesture()
        : Future<void>.value();
    unawaited(priming.catchError((Object _) {}));
    if (_disposed || _unlocked) return;
    _unlocked = true;
    await load();
    unawaited(_safe(() => _backend.preload(_commonEffects)));
    await _queue(_syncMusic);
  }

  Future<void> setMusicEnabled(bool value) async {
    await load();
    _musicEnabled = value;
    _notify();
    await _prefs!.setBool('norie.audio.musicEnabled', value);
    await _queue(_syncMusic);
  }

  Future<void> setSfxEnabled(bool value) async {
    await load();
    _sfxEnabled = value;
    _notify();
    await _prefs!.setBool('norie.audio.sfxEnabled', value);
    if (!value) await _queueEffect(_backend.stopSfx);
  }

  Future<void> setMusicVolume(double value) async {
    await load();
    _musicVolume = _clamp(value);
    _notify();
    await _prefs!.setDouble('norie.audio.musicVolume', _musicVolume);
    await _queue(_applyVolumes);
  }

  Future<void> setSfxVolume(double value) async {
    await load();
    _sfxVolume = _clamp(value);
    _notify();
    await _prefs!.setDouble('norie.audio.sfxVolume', _sfxVolume);
    if (_sfxVolume == 0) await _queueEffect(_backend.stopSfx);
  }

  Future<void> setQuietLessons(bool value) async {
    await load();
    _quietLessons = value;
    _notify();
    await _prefs!.setBool('norie.audio.quietLessons', value);
    await _queue(_applyVolumes);
  }

  Object enterContext(NorieAudioContext context) {
    final token = Object();
    _contexts[token] = context;
    unawaited(_queue(_applyVolumes));
    return token;
  }

  void leaveContext(Object token) {
    _contexts.remove(token);
    unawaited(_queue(_applyVolumes));
  }

  Future<void> setForeground(bool value) async {
    _foreground = value;
    if (!value) await _queueEffect(_backend.stopSfx);
    await _queue(_syncMusic);
  }

  Future<void> _syncMusic() async {
    if (!_unlocked || _playlist.isEmpty) return;
    if (!_musicEnabled || !_foreground) {
      if (_started) {
        await _backend.pauseMusic(0);
        await _backend.pauseMusic(1);
      }
      return;
    }
    if (!_started) {
      _track = _random.nextInt(_playlist.length);
      try {
        await _backend.startMusic(_activeChannel, _playlist[_track]);
      } catch (_) {
        _unlocked = false;
        rethrow;
      }
      _started = true;
      _beginFade(null, _activeChannel);
    } else {
      for (var i = 0; i < 2; i++) {
        if (_weights[i] > 0 || i == _activeChannel) {
          await _backend.resumeMusic(i);
        }
      }
      await _applyVolumes();
    }
  }

  Future<void> _applyVolumes() async {
    if (!_started) return;
    for (var i = 0; i < 2; i++) {
      await _backend.setMusicVolume(i, effectiveMusicVolume * _weights[i]);
    }
  }

  void _onPosition(MusicPosition event) {
    if (!_started ||
        !_foreground ||
        !_musicEnabled ||
        _transitioning ||
        event.channel != _activeChannel) {
      return;
    }
    if (event.duration > Duration.zero &&
        event.duration - event.position <= crossfadeDuration) {
      _transitioning = true;
      unawaited(_queue(() async {
        final old = _activeChannel;
        final next = (_track + 1) % _playlist.length;
        final channel = 1 - old;
        try {
          await _backend.startMusic(channel, _playlist[next]);
          _track = next;
          _activeChannel = channel;
          _beginFade(old, channel);
        } catch (_) {
          _transitioning = false;
          rethrow;
        }
      }));
    }
  }

  void _beginFade(int? old, int incoming) {
    _fadeTimer?.cancel();
    var elapsed = 0;
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_foreground || !_musicEnabled) return;
      elapsed += 50;
      final progress =
          (elapsed / crossfadeDuration.inMilliseconds).clamp(0.0, 1.0);
      _weights[incoming] = progress;
      if (old != null) _weights[old] = 1 - progress;
      unawaited(_queue(_applyVolumes));
      if (progress >= 1) {
        timer.cancel();
        if (old != null) unawaited(_queue(() => _backend.stopMusic(old)));
        _transitioning = false;
      }
    });
  }

  Future<void> _effect(String name, double gain, {bool duck = false}) async {
    await load();
    if (!_unlocked ||
        !_foreground ||
        !_sfxEnabled ||
        _sfxVolume <= 0 ||
        _disposed) {
      return;
    }
    final now = DateTime.now();
    final previous = _lastEffects[name];
    if (previous != null && now.difference(previous).inMilliseconds < 140) {
      return;
    }
    _lastEffects[name] = now;
    if (duck) {
      _duck = .65;
      _duckTimer?.cancel();
      _duckTimer = Timer(const Duration(milliseconds: 800), () {
        _duck = 1;
        unawaited(_queue(_applyVolumes));
      });
      unawaited(_queue(_applyVolumes));
    }
    await _queueEffect(() async {
      if (_sfxEnabled && _foreground && _sfxVolume > 0) {
        await _backend.playSfx(_effectAsset(name), _sfxVolume * gain);
      }
    });
  }

  String _effectAsset(String name) =>
      'audio/sfx/${_theme == NorieAudioTheme.classic ? 'classic/' : ''}$name.mp3';

  Future<void> playUiTap() => _effect('ui_tap', .45);
  Future<void> playUiSelect() => _effect('ui_select', .55);
  Future<void> playUiOpen() => _effect('ui_open', .55);
  Future<void> playUiBack() => _effect('ui_back', .45);
  Future<void> playQuizSelect() => _effect('quiz_select', .6);
  Future<void> playCorrect() => _effect('correct', 1, duck: true);
  Future<void> playWrong() => _effect('wrong', .9, duck: true);
  Future<void> playChallengeStart() =>
      _effect('challenge_start', .85, duck: true);
  Future<void> playComplete() => _effect('complete', .9, duck: true);
  Future<void> playAchievement() => _effect('achievement', .9, duck: true);
  Future<void> playLevelUp() => _effect('level_up', .9, duck: true);
  Future<void> playPerfect() => _effect('perfect', .9, duck: true);
  @override
  void dispose() {
    _disposed = true;
    _fadeTimer?.cancel();
    _duckTimer?.cancel();
    unawaited(_positionSubscription.cancel());
    unawaited(Future.wait([_transport, _effects])
        .then((_) => _backend.dispose())
        .catchError((Object _) {}));
    super.dispose();
  }
}
