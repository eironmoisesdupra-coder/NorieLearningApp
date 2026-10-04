import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../norie_app_context.dart';
import '../norie_mascot_controller.dart';
import '../norie_mascot_state.dart';
import '../voice/norie_voice_controller.dart';
import 'norie_tutorial_models.dart';
import 'norie_tutorial_store.dart';

class NorieTutorialCoordinator extends ChangeNotifier {
  NorieTutorialCoordinator({
    required this.controller,
    required this.store,
    this.voiceController,
  });

  final NorieMascotController controller;
  final NorieTutorialStore store;
  final NorieVoiceController? voiceController;

  final Map<String, List<GlobalKey>> _targets = {};
  final Map<GlobalKey, VoidCallback> _focusActions = {};
  bool _notificationScheduled = false;

  NorieTutorialDefinition? _activeDefinition;
  int _currentIndex = 0;
  int _focusGeneration = 0;
  bool _autoRecentering = false;
  bool _disposed = false;
  bool _showingContents = false;

  bool get showingContents => _showingContents;

  void browse({NorieTutorialDefinition? section}) {
    if (_disposed) return;
    _focusGeneration++;
    _activeDefinition = NorieTutorialCatalog.complete;
    _currentIndex = 0;
    final index = _activeDefinition!.steps
        .indexWhere((step) => step.id == section?.steps.firstOrNull?.id);
    if (index >= 0) _currentIndex = index;
    showContents();
  }

  void showContents() {
    if (!isActive || _disposed) return;
    final stepId = currentStep?.id;
    _activeDefinition = NorieTutorialCatalog.complete;
    final index =
        _activeDefinition!.steps.indexWhere((step) => step.id == stepId);
    _currentIndex = index < 0 ? 0 : index;
    _showingContents = true;
    unawaited(voiceController?.stop());
    _notify();
  }

  NorieTutorialDefinition? get activeDefinition => _activeDefinition;
  bool get isActive => _activeDefinition != null;

  NorieTutorialStep? get currentStep {
    final definition = _activeDefinition;
    if (definition == null || definition.steps.isEmpty) return null;
    if (_currentIndex < 0 || _currentIndex >= definition.steps.length) {
      return null;
    }
    return definition.steps[_currentIndex];
  }

  int get currentIndex => _currentIndex;
  int get stepCount => _activeDefinition?.steps.length ?? 0;
  bool get isLastStep => isActive && _currentIndex == stepCount - 1;

  Future<bool> startIfNeeded(NorieTutorialDefinition definition) async {
    if (_disposed ||
        isActive ||
        definition.steps.isEmpty ||
        await store.isComplete(definition.id)) {
      return false;
    }
    if (_disposed || isActive) return false;
    _start(definition);
    return true;
  }

  Future<void> replay(NorieTutorialDefinition definition) async {
    if (_disposed || definition.steps.isEmpty) return;
    _start(definition);
  }

  void goTo(int index) {
    if (!isActive || index < 0 || index >= stepCount || _disposed) return;
    _showingContents = false;
    _currentIndex = index;
    _activateStep();
    _notify();
  }

  void previous() => goTo(_currentIndex - 1);

  Future<void> next() async {
    final definition = _activeDefinition;
    if (definition == null) return;

    if (_currentIndex >= definition.steps.length - 1) {
      await _finish(markComplete: true);
      return;
    }

    _currentIndex++;
    _activateStep();
    _notify();
  }

  Future<void> skip() async {
    await _finish(markComplete: true);
  }

  void dismissWithoutCompletion() {
    FocusManager.instance.primaryFocus?.unfocus();
    _focusGeneration++;
    _activeDefinition = null;
    _currentIndex = 0;
    unawaited(voiceController?.stop());
    controller.idle();
    _notify();
  }

  void registerTarget(String id, GlobalKey key, {VoidCallback? onFocus}) {
    final keys = _targets.putIfAbsent(id, () => []);
    if (!keys.contains(key)) keys.add(key);
    if (onFocus != null) _focusActions[key] = onFocus;
    if (currentStep?.targetId == id ||
        id == 'tour.${currentStep?.destination?.name}') {
      _scheduleFocusForCurrentStep();
      _notify();
    }
  }

  void unregisterTarget(String id, GlobalKey key) {
    _focusActions.remove(key);
    if (_targets[id]?.remove(key) ?? false) {
      if (_targets[id]!.isEmpty) _targets.remove(id);
      if (currentStep?.targetId == id) _notify();
    }
  }

  Rect? targetRect(String? targetId) {
    if (targetId == null) return null;
    final key = _targetKey(targetId);
    final context = key?.currentContext;
    final renderObject = context?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return null;
    }
    var hidden = false;
    context?.visitAncestorElements((element) {
      if (element.widget is Offstage && (element.widget as Offstage).offstage) {
        hidden = true;
      }
      return !hidden;
    });
    if (hidden) return null;

    final topLeft = renderObject.localToGlobal(Offset.zero);
    return topLeft & renderObject.size;
  }

  GlobalKey? _targetKey(String id) {
    for (final key in (_targets[id] ?? <GlobalKey>[]).reversed) {
      final context = key.currentContext;
      if (context == null) continue;
      var hidden = false;
      context.visitAncestorElements((element) {
        if (element.widget is Offstage &&
            (element.widget as Offstage).offstage) {
          hidden = true;
        }
        return !hidden;
      });
      if (!hidden) return key;
    }
    final destination = currentStep?.destination;
    if (destination != null && id != 'tour.${destination.name}') {
      return _targetKey('tour.${destination.name}');
    }
    return null;
  }

  Future<void> focusCurrentTarget({
    Duration duration = const Duration(milliseconds: 360),
  }) async {
    final step = currentStep;
    final targetId = step?.targetId;
    if (step == null || targetId == null || _disposed) return;

    final key = _targetKey(targetId);
    final context = key?.currentContext;
    if (context == null) return;

    final generation = ++_focusGeneration;

    await Scrollable.ensureVisible(
      context,
      alignment: .2,
      duration: duration,
      curve: Curves.easeOutCubic,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );

    if (_disposed || generation != _focusGeneration) return;
    _focusActions[key]?.call();
    _notify();
  }

  void handleTutorialScrollEnd() {
    if (!isActive ||
        currentStep?.targetId == null ||
        _disposed ||
        _autoRecentering) {
      return;
    }

    _autoRecentering = true;
    unawaited(
      focusCurrentTarget(
        duration: const Duration(milliseconds: 260),
      ).whenComplete(() {
        _autoRecentering = false;
      }),
    );
  }

  void _start(NorieTutorialDefinition definition) {
    _focusGeneration++;
    _showingContents = false;
    _activeDefinition = definition;
    _currentIndex = 0;
    _activateStep();
    _notify();
  }

  void _activateStep() {
    final step = currentStep;
    if (step == null) return;

    switch (step.mascotState) {
      case NorieMascotState.pointing:
        controller.point(step.targetId ?? step.id);
      case NorieMascotState.thinking:
        controller.think();
      case NorieMascotState.searching:
        controller.searching();
      case NorieMascotState.nervous:
        controller.nervous();
      case NorieMascotState.scared:
        controller.scared();
      case NorieMascotState.challenge:
        controller.challengeMode();
      case NorieMascotState.celebrating:
        controller.celebrate();
      case NorieMascotState.correct:
        controller.correct();
      case NorieMascotState.idea:
        controller.idea();
      case NorieMascotState.entering:
        controller.enter();
      case NorieMascotState.exiting:
        controller.exit();
      case NorieMascotState.hidden:
        controller.hide();
      case NorieMascotState.idle:
        controller.idle();
      case NorieMascotState.guiding:
      case NorieMascotState.speaking:
        controller.guide();
    }

    final voiceAsset = step.voiceAsset;
    final voice = voiceController;
    if (voiceAsset != null && voice != null) {
      unawaited(
        voice.playAsset(
          voiceAsset,
          area: NorieAppArea.tutorial,
        ),
      );
    }

    _scheduleFocusForCurrentStep();
  }

  void _scheduleFocusForCurrentStep() {
    final stepId = currentStep?.id;
    if (stepId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_disposed || currentStep?.id != stepId) return;
      unawaited(focusCurrentTarget());
    });
  }

  Future<void> _finish({required bool markComplete}) async {
    final definition = _activeDefinition;
    if (definition == null) return;
    FocusManager.instance.primaryFocus?.unfocus();

    if (markComplete) {
      await store.markComplete(definition.id);
    }

    _focusGeneration++;
    _activeDefinition = null;
    _currentIndex = 0;
    unawaited(voiceController?.stop());
    controller.idle();
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    if (WidgetsBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationScheduled) return;
      _notificationScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationScheduled = false;
        if (!_disposed) notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _focusGeneration++;
    _targets.clear();
    _focusActions.clear();
    super.dispose();
  }
}
