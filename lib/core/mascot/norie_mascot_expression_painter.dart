import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'norie_mascot_state.dart';

class NorieMascotExpressionPainter extends CustomPainter {
  const NorieMascotExpressionPainter({
    required this.state,
    required this.progress,
  });

  final NorieMascotState state;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.clamp(0.0, 1.0);
    final center = Offset(size.width / 2, size.height / 2);

    switch (state) {
      case NorieMascotState.correct:
      case NorieMascotState.idea:
        _paintSparkles(canvas, size, t);
      case NorieMascotState.celebrating:
        _paintCelebration(canvas, size, t);
      case NorieMascotState.thinking:
      case NorieMascotState.searching:
        _paintThinking(canvas, size, t);
      case NorieMascotState.nervous:
      case NorieMascotState.scared:
        _paintNervous(canvas, size, t);
      case NorieMascotState.challenge:
        _paintChallenge(canvas, size, center, t);
      case NorieMascotState.pointing:
        _paintGesturePulse(canvas, size, t, rightSide: true);
      case NorieMascotState.guiding:
        _paintGesturePulse(canvas, size, t, rightSide: false);
      case NorieMascotState.speaking:
        _paintSpeaking(canvas, size, t);
      case NorieMascotState.hidden:
      case NorieMascotState.entering:
      case NorieMascotState.idle:
      case NorieMascotState.exiting:
        break;
    }
  }

  void _paintSparkles(Canvas canvas, Size size, double t) {
    final paint = Paint()
      ..color = const Color(0xFF77F3FF).withValues(alpha: .55 + (.35 * t))
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (final point in [
      Offset(size.width * .18, size.height * .22),
      Offset(size.width * .82, size.height * .28),
      Offset(size.width * .76, size.height * .72),
    ]) {
      final radius = 4 + (3 * t);
      canvas.drawLine(
        point.translate(-radius, 0),
        point.translate(radius, 0),
        paint,
      );
      canvas.drawLine(
        point.translate(0, -radius),
        point.translate(0, radius),
        paint,
      );
    }
  }

  void _paintCelebration(Canvas canvas, Size size, double t) {
    final colors = [
      const Color(0xFF22D3EE),
      const Color(0xFFA78BFA),
      const Color(0xFFF59E0B),
    ];

    for (var i = 0; i < 9; i++) {
      final angle = (math.pi * 2 * i / 9) + (t * .35);
      final radius = size.shortestSide * (.38 + (.05 * t));
      final point = Offset(
        size.width / 2 + math.cos(angle) * radius,
        size.height / 2 + math.sin(angle) * radius,
      );
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: .78);
      canvas.drawCircle(point, 2.5 + (1.5 * t), paint);
    }
  }

  void _paintThinking(Canvas canvas, Size size, double t) {
    final paint = Paint()
      ..color = const Color(0xFFB7F5FF).withValues(alpha: .72);
    final origin = Offset(size.width * .76, size.height * .18);

    for (var i = 0; i < 3; i++) {
      final phase = (t + (i * .22)) % 1;
      canvas.drawCircle(
        origin.translate(i * 10, -i * 5),
        2.5 + (phase * 2),
        paint,
      );
    }
  }

  void _paintNervous(Canvas canvas, Size size, double t) {
    final paint = Paint()
      ..color = const Color(0xFF7DD3FC).withValues(alpha: .75)
      ..style = PaintingStyle.fill;

    final drop = Path()
      ..moveTo(size.width * .79, size.height * .15)
      ..quadraticBezierTo(
        size.width * .84,
        size.height * (.20 + (.02 * t)),
        size.width * .79,
        size.height * .25,
      )
      ..quadraticBezierTo(
        size.width * .74,
        size.height * (.20 + (.02 * t)),
        size.width * .79,
        size.height * .15,
      )
      ..close();
    canvas.drawPath(drop, paint);
  }

  void _paintChallenge(
    Canvas canvas,
    Size size,
    Offset center,
    double t,
  ) {
    final paint = Paint()
      ..color = const Color(0xFFA78BFA).withValues(alpha: .28 + (.18 * t))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final radius = size.shortestSide * (.43 + (.015 * t));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.08,
      math.pi * .84,
      false,
      paint,
    );
  }

  void _paintGesturePulse(
    Canvas canvas,
    Size size,
    double t, {
    required bool rightSide,
  }) {
    final phase = .5 + (.5 * math.sin(t * math.pi * 2));
    final x = size.width * (rightSide ? .85 : .15);
    final y = size.height * .48;
    final paint = Paint()
      ..color = const Color(0xFF77F3FF).withValues(alpha: .28 + (.48 * phase))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1;

    for (var i = 0; i < 2; i++) {
      final radius = 6 + (i * 6) + (phase * 3);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x, y), radius: radius),
        rightSide ? -.9 : math.pi - .9,
        1.8,
        false,
        paint,
      );
    }
  }

  void _paintSpeaking(Canvas canvas, Size size, double t) {
    final pulse = .5 + (.5 * math.sin(t * math.pi * 4));
    final paint = Paint()
      ..color = const Color(0xFFB7F5FF).withValues(alpha: .35 + (.45 * pulse));

    final origin = Offset(size.width * .73, size.height * .32);
    for (var i = 0; i < 3; i++) {
      final radius = 2.5 + (i * 1.6) + (pulse * 1.5);
      canvas.drawCircle(
        origin.translate(i * 8.0, -i * 3.0),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NorieMascotExpressionPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.progress != progress;
  }
}
