import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/norie_accessibility_settings.dart';

class NorieAccessibilityScope extends InheritedWidget {
  const NorieAccessibilityScope({
    required this.readingFocus,
    required super.child,
    super.key,
  });

  final bool readingFocus;

  static bool readingFocusOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<NorieAccessibilityScope>()
          ?.readingFocus ??
      false;

  @override
  bool updateShouldNotify(NorieAccessibilityScope oldWidget) =>
      readingFocus != oldWidget.readingFocus;
}

/// Composes device preferences with OS preferences above every route and overlay.
class NorieAccessibilityHost extends StatefulWidget {
  const NorieAccessibilityHost({required this.child, this.store, super.key});

  final Widget child;
  final NorieAccessibilitySettings? store;

  @override
  State<NorieAccessibilityHost> createState() => _NorieAccessibilityHostState();
}

class _NorieAccessibilityHostState extends State<NorieAccessibilityHost> {
  NorieAccessibilitySettings get store =>
      widget.store ?? NorieAccessibilitySettings.instance;

  @override
  void initState() {
    super.initState();
    unawaited(store.load());
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final profile = store.value;
          final os = MediaQuery.of(context);
          final contrast = os.highContrast || profile.highContrast;
          final bold = os.boldText || profile.boldText;
          final media = os.copyWith(
            textScaler: profile.textScale == 1
                ? os.textScaler
                : _MultipliedTextScaler(os.textScaler, profile.textScale),
            boldText: bold,
            highContrast: contrast,
            disableAnimations: os.disableAnimations || profile.reducedMotion,
            accessibleNavigation:
                os.accessibleNavigation || profile.reducedMotion,
          );
          return MediaQuery(
            data: media,
            child: Theme(
              data: NorieTheme.withAccessibility(Theme.of(context),
                  highContrast: contrast),
              child: NorieAccessibilityScope(
                readingFocus: profile.readingFocus,
                child: widget.child,
              ),
            ),
          );
        },
      );
}

// Scale the OS result, retaining nonlinear accessibility scaling curves.
class _MultipliedTextScaler extends TextScaler {
  const _MultipliedTextScaler(this.system, this.multiplier);
  final TextScaler system;
  final double multiplier;

  @override
  double scale(double fontSize) => system.scale(fontSize) * multiplier;

  @override
  double get textScaleFactor => scale(14) / 14;

  @override
  bool operator ==(Object other) =>
      other is _MultipliedTextScaler &&
      other.system == system &&
      other.multiplier == multiplier;

  @override
  int get hashCode => Object.hash(system, multiplier);
}
