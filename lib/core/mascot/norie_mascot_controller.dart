import 'dart:async';

import 'package:flutter/foundation.dart';

import 'norie_mascot_state.dart';

abstract interface class NorieMascotTimer {
  void cancel();
}

abstract interface class NorieMascotScheduler {
  NorieMascotTimer schedule(Duration delay, VoidCallback callback);
}

class NorieMascotController extends ChangeNotifier {
  NorieMascotController({NorieMascotScheduler? scheduler})
      : _scheduler = scheduler ?? const _TimerMascotScheduler();

  static const _enterDuration = Duration(milliseconds: 550);
  static const _correctDuration = Duration(milliseconds: 700);
  static const _ideaDuration = Duration(milliseconds: 900);
  static const _nervousDuration = Duration(milliseconds: 900);
  static const _scaredDuration = Duration(milliseconds: 900);
  static const _challengeDuration = Duration(milliseconds: 1000);
  static const _celebrateDuration = Duration(milliseconds: 1600);
  static const _exitDuration = Duration(milliseconds: 450);

  final NorieMascotScheduler _scheduler;

  NorieMascotState _state = NorieMascotState.idle;
  NorieMascotPriority _priority = NorieMascotPriority.idle;
  String? _speech;
  String? _targetId;
  NorieCelebrationLevel? _celebrationLevel;
  NorieMascotTimer? _activeTimer;
  NorieMascotEvent? _queuedEvent;
  bool _disposed = false;

  NorieMascotState get state => _state;
  String? get speech => _speech;
  String? get targetId => _targetId;
  NorieCelebrationLevel? get celebrationLevel => _celebrationLevel;

  void enter() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.entering,
        priority: NorieMascotPriority.feedback,
        duration: _enterDuration,
      ),
      force: _state == NorieMascotState.hidden,
    );
  }

  void exit() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.exiting,
        priority: NorieMascotPriority.hidden,
        duration: _exitDuration,
      ),
      force: true,
    );
  }

  void idle() {
    _activate(
      const NorieMascotEvent(
        state: NorieMascotState.idle,
        priority: NorieMascotPriority.idle,
      ),
    );
  }

  void guide() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.guiding,
        priority: NorieMascotPriority.guide,
      ),
    );
  }

  void point(String targetId) {
    _dispatch(
      NorieMascotEvent(
        state: NorieMascotState.pointing,
        priority: NorieMascotPriority.guide,
        targetId: targetId,
      ),
    );
  }

  void think() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.thinking,
        priority: NorieMascotPriority.ambient,
      ),
    );
  }

  void idea() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.idea,
        priority: NorieMascotPriority.feedback,
        duration: _ideaDuration,
      ),
    );
  }

  void correct() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.correct,
        priority: NorieMascotPriority.feedback,
        duration: _correctDuration,
      ),
    );
  }

  void celebrate({
    NorieCelebrationLevel level = NorieCelebrationLevel.standard,
  }) {
    _dispatch(
      NorieMascotEvent(
        state: NorieMascotState.celebrating,
        priority: NorieMascotPriority.celebration,
        duration: _celebrateDuration,
        celebrationLevel: level,
      ),
    );
  }

  void nervous() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.nervous,
        priority: NorieMascotPriority.challenge,
        duration: _nervousDuration,
      ),
    );
  }

  void scared() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.scared,
        priority: NorieMascotPriority.challenge,
        duration: _scaredDuration,
      ),
    );
  }

  void challengeMode() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.challenge,
        priority: NorieMascotPriority.challenge,
        duration: _challengeDuration,
      ),
    );
  }

  void searching() {
    _dispatch(
      const NorieMascotEvent(
        state: NorieMascotState.searching,
        priority: NorieMascotPriority.ambient,
      ),
    );
  }

  void speak(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      stopSpeaking();
      return;
    }

    _dispatch(
      NorieMascotEvent(
        state: NorieMascotState.speaking,
        priority: NorieMascotPriority.guide,
        speech: trimmed,
      ),
    );
  }

  void stopSpeaking() {
    if (_state != NorieMascotState.speaking && _speech == null) return;
    _queuedEvent = null;
    idle();
  }

  void hide() {
    _queuedEvent = null;
    _activeTimer?.cancel();
    _activeTimer = null;
    _state = NorieMascotState.hidden;
    _priority = NorieMascotPriority.hidden;
    _speech = null;
    _targetId = null;
    _celebrationLevel = null;
    _notify();
  }

  void _dispatch(NorieMascotEvent event, {bool force = false}) {
    if (_disposed) return;

    if (force || event.priority.index >= _priority.index) {
      _activate(event);
      return;
    }

    _queuedEvent = event;
  }

  void _activate(NorieMascotEvent event) {
    if (_disposed) return;

    _activeTimer?.cancel();
    _activeTimer = null;

    _state = event.state;
    _priority = event.priority;
    _speech = event.speech;
    _targetId = event.targetId;
    _celebrationLevel = event.celebrationLevel;
    _notify();

    final duration = event.duration;
    if (duration != null) {
      _activeTimer = _scheduler.schedule(duration, _completeActiveEvent);
    }
  }

  void _completeActiveEvent() {
    if (_disposed) return;

    _activeTimer = null;

    if (_state == NorieMascotState.exiting) {
      _queuedEvent = null;
      _state = NorieMascotState.hidden;
      _priority = NorieMascotPriority.hidden;
      _speech = null;
      _targetId = null;
      _celebrationLevel = null;
      _notify();
      return;
    }

    final queued = _queuedEvent;
    _queuedEvent = null;
    if (queued != null) {
      _activate(queued);
      return;
    }

    _state = NorieMascotState.idle;
    _priority = NorieMascotPriority.idle;
    _speech = null;
    _targetId = null;
    _celebrationLevel = null;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _activeTimer?.cancel();
    _activeTimer = null;
    _queuedEvent = null;
    super.dispose();
  }
}

class _TimerMascotScheduler implements NorieMascotScheduler {
  const _TimerMascotScheduler();

  @override
  NorieMascotTimer schedule(Duration delay, VoidCallback callback) {
    return _DartMascotTimer(Timer(delay, callback));
  }
}

class _DartMascotTimer implements NorieMascotTimer {
  const _DartMascotTimer(this._timer);

  final Timer _timer;

  @override
  void cancel() => _timer.cancel();
}
