import 'package:flutter/material.dart';

abstract final class NorieColors {
  static const background = Color(0xFF071126);
  static const surface = Color(0xFF101B36);
  static const surfaceElevated = Color(0xFF172440);
  static const primary = Color(0xFF5B5CE2);
  static const cyan = Color(0xFF22D3EE);
  static const violet = Color(0xFFA855F7);
  static const magenta = Color(0xFFEC4899);
  static const green = Color(0xFF22C55E);
  static const orange = Color(0xFFF59E0B);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF9CA9C4);
  static const border = Color(0xFF263656);
}

abstract final class NorieTheme {
  static ThemeData withAccessibility(
    ThemeData base, {
    required bool highContrast,
  }) {
    final theme = base.copyWith(
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        for (final platform in TargetPlatform.values)
          platform: _AccessibleTransitions(
              base.pageTransitionsTheme.builders[platform] ??
                  const ZoomPageTransitionsBuilder()),
      }),
    );
    if (!highContrast) return theme;
    final scheme = theme.colorScheme.copyWith(
      primary: const Color(0xFFBCBDFF),
      onPrimary: NorieColors.background,
      primaryContainer: const Color(0xFF36377D),
      onPrimaryContainer: Colors.white,
      secondary: NorieColors.cyan,
      onSecondary: NorieColors.background,
      onSecondaryContainer: Colors.white,
      surface: NorieColors.background,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white,
      outline: Colors.white,
      outlineVariant: const Color(0xFFC2CCE0),
      error: const Color(0xFFFFB4AB),
      onError: NorieColors.background,
    );
    return theme.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: NorieColors.background,
      textTheme: theme.textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white),
      dividerColor: scheme.outline,
      disabledColor: const Color(0xFFB8BED0),
      cardTheme: theme.cardTheme.copyWith(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(16)))),
      inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: NorieColors.cyan, width: 2))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white))),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              foregroundColor: scheme.onPrimary,
              backgroundColor: scheme.primary)),
      switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? NorieColors.background
                  : Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? NorieColors.cyan
                  : NorieColors.surface),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.white)),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: NorieColors.primary,
      brightness: Brightness.dark,
      surface: NorieColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: NorieColors.background,
      fontFamily: 'sans-serif',
      fontFamilyFallback: const [
        'NorieScienceText',
        'NorieScienceSymbols',
        'NorieEmoji'
      ],
      cardTheme: const CardThemeData(
        color: NorieColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: NorieColors.surface,
        indicatorColor: Color(0x335B5CE2),
      ),
    );
  }
}

class _AccessibleTransitions extends PageTransitionsBuilder {
  const _AccessibleTransitions(this.standard);
  final PageTransitionsBuilder standard;

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context)) {
      return child;
    }
    return standard.buildTransitions(
        route, context, animation, secondaryAnimation, child);
  }
}
