import 'package:flutter/widgets.dart';

import 'norie_app_context.dart';
import 'norie_mascot_controller.dart';
import 'tutorial/norie_tutorial_coordinator.dart';

class NorieMascotScope extends InheritedWidget {
  const NorieMascotScope({
    required this.controller,
    required this.contextSnapshot,
    required this.assistantVisible,
    required this.tutorialCoordinator,
    required this.setContext,
    required this.showAssistant,
    required this.hideAssistant,
    required super.child,
    super.key,
  });

  final NorieMascotController controller;
  final NorieContextSnapshot contextSnapshot;
  final bool assistantVisible;
  final NorieTutorialCoordinator tutorialCoordinator;
  final ValueChanged<NorieContextSnapshot> setContext;
  final VoidCallback showAssistant;
  final VoidCallback hideAssistant;

  static NorieMascotScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<NorieMascotScope>();
    assert(scope != null, 'No NorieMascotScope found in this context.');
    return scope!;
  }

  static NorieMascotScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NorieMascotScope>();
  }

  @override
  bool updateShouldNotify(covariant NorieMascotScope oldWidget) {
    return oldWidget.controller != controller ||
        oldWidget.contextSnapshot != contextSnapshot ||
        oldWidget.assistantVisible != assistantVisible;
  }
}
