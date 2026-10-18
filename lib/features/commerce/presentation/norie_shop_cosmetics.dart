import 'package:flutter/material.dart';
import '../../../core/theme/norie_theme.dart';

/// Offline code-native decorations for the existing catalog IDs. These values
/// do not grant ownership or modify the learner's saved appearance.
abstract final class NorieShopCosmetics {
  static Color? frameColor(String? id) => switch (id) {
        'frame-cyan-orbit' => NorieColors.cyan,
        'frame-violet-scholar' => NorieColors.violet,
        _ => null,
      };
  static Color? themeColor(String? id) => switch (id) {
        'theme-aurora' => NorieColors.cyan,
        'theme-ember' => NorieColors.orange,
        _ => null,
      };
  static Color? themeTail(String? id) => switch (id) {
        'theme-aurora' => const Color(0xFF282044),
        'theme-ember' => const Color(0xFF402038),
        _ => null,
      };
  static String? badgeLabel(String? id) => switch (id) {
        'badge-atom' => 'Atomic Mind Badge',
        'badge-streak' => 'Streak Keeper Badge',
        _ => null,
      };
  static IconData badgeIcon(String? id) => id == 'badge-atom'
      ? Icons.science_outlined
      : Icons.local_fire_department_outlined;
}
