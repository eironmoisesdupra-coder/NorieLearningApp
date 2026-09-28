import 'package:flutter/material.dart';

import '../theme/norie_theme.dart';

class NorieGlassCard extends StatelessWidget {
  const NorieGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.accent = NorieColors.primary,
    this.radius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color accent;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: .12),
            NorieColors.surface.withValues(alpha: .94),
            NorieColors.surface.withValues(alpha: .82),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: .25)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: .06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
