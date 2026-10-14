import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../features/profile/domain/norie_profile_appearance.dart';

/// Static, code-native rank art: available offline and safe for reduced motion.
class NorieRankMotifPainter extends CustomPainter {
  const NorieRankMotifPainter({required this.bundle});
  final NorieRankBundle bundle;

  void paintMotif(Canvas canvas, Offset center, double radius, int index,
      {bool celebration = false}) {
    final color = bundle.colors[index % bundle.colors.length];
    final fill = Paint()..color = color;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, radius * .18);
    switch (bundle.id) {
      case 'curious':
        canvas.drawLine(
            center - Offset(radius * 1.7, radius * .8), center, stroke);
        canvas.drawLine(center - Offset(radius * 1.4, 0), center, stroke);
        canvas.drawCircle(center, radius * .55, fill);
      case 'scholar':
        if (celebration) {
          // Laurel leaves frame the reward, while maps use lantern markers.
          final leaf = Path()
            ..moveTo(center.dx, center.dy + radius)
            ..quadraticBezierTo(
                center.dx - radius, center.dy, center.dx, center.dy - radius)
            ..quadraticBezierTo(
                center.dx + radius, center.dy, center.dx, center.dy + radius)
            ..close();
          canvas.drawPath(leaf, fill);
          canvas.drawLine(
              center - Offset(0, radius * .65),
              center + Offset(0, radius * .65),
              Paint()
                ..color = Colors.white.withValues(alpha: .5)
                ..strokeWidth = 1);
          return;
        }
        // A glowing expedition lantern, with its hanging handle.
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: center, width: radius * 1.1, height: radius * 1.5),
                Radius.circular(radius * .2)),
            stroke);
        canvas.drawCircle(center, radius * .22, fill);
        canvas.drawArc(
            Rect.fromCenter(
                center: center - Offset(0, radius),
                width: radius * .7,
                height: radius * .7),
            math.pi,
            math.pi,
            false,
            stroke);
      case 'specialist':
        canvas.drawOval(
            Rect.fromCenter(center: center, width: radius * 2, height: radius),
            stroke);
        canvas.drawCircle(center, radius * .24, fill);
        canvas.drawCircle(center + Offset(radius * .85, 0), radius * .25, fill);
      case 'master':
        final diamond = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius * .7, center.dy)
          ..lineTo(center.dx, center.dy + radius)
          ..lineTo(center.dx - radius * .7, center.dy)
          ..close();
        canvas.drawPath(diamond, fill);
        canvas.drawLine(
            center - Offset(0, radius * .7),
            center + Offset(0, radius * .7),
            Paint()
              ..color = Colors.white.withValues(alpha: .7)
              ..strokeWidth = 1.5);
      default:
        final star = Path();
        for (var i = 0; i < 10; i++) {
          final angle = i * math.pi / 5 - math.pi / 2;
          final r = radius * (i.isEven ? 1 : .4);
          final point =
              center + Offset(math.cos(angle) * r, math.sin(angle) * r);
          if (i == 0) {
            star.moveTo(point.dx, point.dy);
          } else {
            star.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(star..close(), fill);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) * .42;
    if (bundle.id == 'specialist') {
      canvas.drawOval(
          Rect.fromCenter(
              center: center, width: radius * 2.2, height: radius * 1.5),
          Paint()
            ..color = bundle.colors.first.withValues(alpha: .35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      paintMotif(
          canvas,
          center + Offset(math.cos(angle) * radius, math.sin(angle) * radius),
          5.5,
          i,
          celebration: true);
    }
  }

  @override
  bool shouldRepaint(covariant NorieRankMotifPainter oldDelegate) =>
      oldDelegate.bundle.id != bundle.id;
}
