import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

class AnatomyAnimatedBackdrop extends StatefulWidget {
  const AnatomyAnimatedBackdrop({
    super.key,
    this.particlesEnabled = true,
  });

  final bool particlesEnabled;

  @override
  State<AnatomyAnimatedBackdrop> createState() => _AnatomyAnimatedBackdropState();
}

class _AnatomyAnimatedBackdropState extends State<AnatomyAnimatedBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _AnatomyBackdropPainter(
            progress: _controller.value,
            particlesEnabled: widget.particlesEnabled,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _AnatomyBackdropPainter extends CustomPainter {
  const _AnatomyBackdropPainter({
    required this.progress,
    required this.particlesEnabled,
  });

  final double progress;
  final bool particlesEnabled;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF061126),
          Color(0xFF0A1730),
          Color(0xFF101548),
          Color(0xFF07152F),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final glowA = Paint()
      ..shader = RadialGradient(
        colors: [
          NorieColors.cyan.withValues(alpha: .13),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .77, size.height * .22),
          radius: size.shortestSide * .52,
        ),
      );
    canvas.drawRect(rect, glowA);

    final glowB = Paint()
      ..shader = RadialGradient(
        colors: [
          NorieColors.violet.withValues(alpha: .12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .18, size.height * .72),
          radius: size.shortestSide * .60,
        ),
      );
    canvas.drawRect(rect, glowB);

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .025)
      ..strokeWidth = 1;
    const step = 34.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    if (!particlesEnabled) return;

    final rng = math.Random(29);
    for (var i = 0; i < 42; i++) {
      final baseX = rng.nextDouble();
      final baseY = rng.nextDouble();
      final speed = .18 + rng.nextDouble() * .45;
      final drift = (progress * speed + baseY) % 1;
      final x = (baseX * size.width) +
          math.sin((progress * math.pi * 2) + i) * 8;
      final y = size.height * (1 - drift);
      final radius = 1.2 + rng.nextDouble() * 2.2;
      final color = i % 3 == 0
          ? NorieColors.magenta
          : i % 2 == 0
              ? NorieColors.violet
              : NorieColors.cyan;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = color.withValues(alpha: .20 + rng.nextDouble() * .25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnatomyBackdropPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.particlesEnabled != particlesEnabled;
}
