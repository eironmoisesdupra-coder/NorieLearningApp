import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_mascot_controller.dart';
import 'package:norie_learning/core/mascot/norie_mascot_state.dart';

void main() {
  group('NorieMascotController', () {
    late _FakeMascotScheduler scheduler;
    late NorieMascotController controller;

    setUp(() {
      scheduler = _FakeMascotScheduler();
      controller = NorieMascotController(scheduler: scheduler);
    });

    tearDown(() {
      controller.dispose();
    });

    test('correct reaction returns to idle after transient duration', () {
      controller.correct();

      expect(controller.state, NorieMascotState.correct);

      scheduler.elapse(const Duration(milliseconds: 699));
      expect(controller.state, NorieMascotState.correct);

      scheduler.elapse(const Duration(milliseconds: 1));
      expect(controller.state, NorieMascotState.idle);
    });

    test('high priority celebration replaces lower priority idle reaction', () {
      controller.think();
      expect(controller.state, NorieMascotState.thinking);

      controller.celebrate(level: NorieCelebrationLevel.perfect);

      expect(controller.state, NorieMascotState.celebrating);
      expect(controller.celebrationLevel, NorieCelebrationLevel.perfect);
    });

    test('latest queued transient event wins after current event finishes', () {
      controller.celebrate();
      controller.correct();
      controller.idea();

      expect(controller.state, NorieMascotState.celebrating);

      scheduler.elapse(const Duration(milliseconds: 1600));

      expect(controller.state, NorieMascotState.idea);

      scheduler.elapse(const Duration(milliseconds: 900));
      expect(controller.state, NorieMascotState.idle);
    });

    test('stop speaking clears reactions queued behind speech', () {
      controller.speak('Here is some help.');
      controller.correct();

      controller.stopSpeaking();
      expect(controller.state, NorieMascotState.idle);

      controller.idea();
      scheduler.elapse(const Duration(milliseconds: 900));

      expect(controller.state, NorieMascotState.idle);
    });

    test('hide clears queued events and speech', () {
      controller.speak('Try the Learn tab.');
      controller.celebrate();
      controller.correct();

      controller.hide();

      expect(controller.state, NorieMascotState.hidden);
      expect(controller.speech, isNull);
      expect(controller.targetId, isNull);

      scheduler.elapse(const Duration(seconds: 10));
      expect(controller.state, NorieMascotState.hidden);
    });

    test('rapid consecutive events never leave controller in transient state', () {
      controller.correct();
      controller.idea();
      controller.nervous();
      controller.scared();
      controller.challengeMode();
      controller.correct();

      scheduler.elapse(const Duration(seconds: 10));

      expect(
        {
          NorieMascotState.entering,
          NorieMascotState.idea,
          NorieMascotState.correct,
          NorieMascotState.celebrating,
          NorieMascotState.nervous,
          NorieMascotState.scared,
          NorieMascotState.challenge,
          NorieMascotState.exiting,
        },
        isNot(contains(controller.state)),
      );
    });
  });
}

class _FakeMascotScheduler implements NorieMascotScheduler {
  Duration _elapsed = Duration.zero;
  final List<_ScheduledCallback> _callbacks = [];

  @override
  NorieMascotTimer schedule(Duration delay, void Function() callback) {
    final item = _ScheduledCallback(_elapsed + delay, callback);
    _callbacks.add(item);
    return _FakeMascotTimer(() => item.cancelled = true);
  }

  void elapse(Duration duration) {
    final target = _elapsed + duration;

    while (true) {
      final due = _callbacks
          .where((item) => !item.cancelled && item.when <= target)
          .toList()
        ..sort((a, b) => a.when.compareTo(b.when));

      if (due.isEmpty) break;

      final next = due.first;
      next.cancelled = true;
      _elapsed = next.when;
      next.callback();
    }

    _elapsed = target;
  }
}

class _ScheduledCallback {
  _ScheduledCallback(this.when, this.callback);

  final Duration when;
  final void Function() callback;
  bool cancelled = false;
}

class _FakeMascotTimer implements NorieMascotTimer {
  _FakeMascotTimer(this._onCancel);

  final void Function() _onCancel;
  bool _cancelled = false;

  @override
  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _onCancel();
  }
}
