import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

Color norieContentAccent(String name) {
  return switch (name.toLowerCase()) {
    'green' => NorieColors.green,
    'violet' => NorieColors.violet,
    'magenta' => NorieColors.magenta,
    'orange' => NorieColors.orange,
    'primary' => NorieColors.primary,
    _ => NorieColors.cyan,
  };
}
