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
