import 'dart:async';

import 'package:flutter/material.dart';

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

  final Map<String, GlobalKey> _targets = <String, GlobalKey>{};

  NorieTutorialDefinition? _activeDefinition;
  int _currentIndex = 0;
  int _focusGeneration = 0;
  bool _disposed = false;

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
    if (definition.steps.isEmpty || await store.isComplete(definition.id)) {
      return false;
    }
    _start(definition);
    return true;
  }

  Future<void> replay(NorieTutorialDefinition definition) async {
    if (definition.steps.isEmpty) return;
    _start(definition);
  }

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
    _focusGeneration++;
    _activeDefinition = null;
    _currentIndex = 0;
    unawaited(voiceController?.stop());
    controller.idle();
    _notify();
  }

  void registerTarget(String id, GlobalKey key) {
    _targets[id] = key;
    if (currentStep?.targetId == id) {
      _scheduleFocusForCurrentStep();
      _notify();
    }
  }

  void unregisterTarget(String id, GlobalKey key) {
    if (identical(_targets[id], key)) {
      _targets.remove(id);
      if (currentStep?.targetId == id) _notify();
    }
  }

  Rect? targetRect(String? targetId) {
    if (targetId == null) return null;
    final key = _targets[targetId];
    final context = key?.currentContext;
    final renderObject = context?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return null;

    final topLeft = renderObject.localToGlobal(Offset.zero);
    return topLeft & renderObject.size;
  }

  Future<void> focusCurrentTarget({
    Duration duration = const Duration(milliseconds: 360),
  }) async {
    final step = currentStep;
    final targetId = step?.targetId;
    if (step == null || targetId == null || _disposed) return;

    final key = _targets[targetId];
    final context = key?.currentContext;
    if (context == null) return;

    final generation = ++_focusGeneration;

    await Scrollable.ensureVisible(
      context,
      alignment: .5,
      duration: duration,
      curve: Curves.easeOutCubic,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );

    if (_disposed || generation != _focusGeneration) return;
    _notify();
  }

  void handleTutorialScrollEnd() {
    if (!isActive || currentStep?.targetId == null || _disposed) return;
    unawaited(
      focusCurrentTarget(
        duration: const Duration(milliseconds: 260),
      ),
    );
  }

  void _start(NorieTutorialDefinition definition) {
    _focusGeneration++;
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
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _focusGeneration++;
    _targets.clear();
    super.dispose();
  }
}
