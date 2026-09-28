import 'package:flutter/material.dart';

import '../theme/norie_theme.dart';

class NorieAmbientBackdrop extends StatelessWidget {
  const NorieAmbientBackdrop({
    super.key,
    this.primary = NorieColors.primary,
    this.secondary = NorieColors.violet,
  });

  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: NorieColors.background),
        child: Stack(
          children: [
            Positioned(
              right: -90,
              top: -80,
              child: _GlowOrb(
                size: 280,
                color: primary.withValues(alpha: .12),
              ),
            ),
            Positioned(
              left: -120,
              top: 360,
              child: _GlowOrb(
                size: 300,
                color: secondary.withValues(alpha: .08),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 80,
              child: _GlowOrb(
                size: 150,
                color: NorieColors.cyan.withValues(alpha: .045),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
