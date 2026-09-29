import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/anatomy_models.dart';

class AnatomyBodyModel extends StatelessWidget {
  const AnatomyBodyModel({
    required this.selectedSystems,
    required this.opacity,
    super.key,
  });

  final Set<AnatomySystemId> selectedSystems;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AnatomyBodyPainter(
        selectedSystems: selectedSystems,
        opacity: opacity,
      ),
    );
  }
}

class AnatomyBodyPainter extends CustomPainter {
  const AnatomyBodyPainter({
    required this.selectedSystems,
    required this.opacity,
  });

  final Set<AnatomySystemId> selectedSystems;
  final double opacity;

  Paint _paint(Color color, {double width = 5, bool fill = false}) => Paint()
    ..color = color.withValues(alpha: opacity)
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 300;
    final sy = size.height / 620;
    canvas.save();
    canvas.scale(sx, sy);

    final ghost = Paint()
      ..color = const Color(0xFF9FB1C8).withValues(alpha: .11)
      ..style = PaintingStyle.fill;

    canvas.drawOval(const Rect.fromLTWH(122, 22, 56, 72), ghost);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(105, 92, 90, 190),
        const Radius.circular(42),
      ),
      ghost,
    );
    for (final rect in const [
      Rect.fromLTWH(75, 102, 28, 215),
      Rect.fromLTWH(197, 102, 28, 215),
      Rect.fromLTWH(108, 272, 36, 305),
      Rect.fromLTWH(156, 272, 36, 305),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(18)),
        ghost,
      );
    }

    if (selectedSystems.contains(AnatomySystemId.integumentary)) {
      _drawIntegumentary(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.skeletal)) {
      _drawSkeletal(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.articular)) {
      _drawJoints(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.muscular)) {
      _drawMuscular(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.cardiovascular)) {
      _drawHeart(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.arterial)) {
      _drawVessels(canvas, const Color(0xFFFF4C4C), arterial: true);
    }
    if (selectedSystems.contains(AnatomySystemId.venous)) {
      _drawVessels(canvas, const Color(0xFF6D7CFF), arterial: false);
    }
    if (selectedSystems.contains(AnatomySystemId.nervous)) {
      _drawNervous(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.lymphatic)) {
      _drawLymphatic(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.respiratory)) {
      _drawRespiratory(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.digestive)) {
      _drawDigestive(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.urinary)) {
      _drawUrinary(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.reproductive)) {
      _drawReproductive(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.endocrine)) {
      _drawEndocrine(canvas);
    }
    if (selectedSystems.contains(AnatomySystemId.sensory)) {
      _drawSensory(canvas);
    }

    canvas.restore();
  }

  void _drawSkeletal(Canvas c) {
    final p = _paint(const Color(0xFFE7EDF6), width: 5);
    c.drawOval(const Rect.fromLTWH(126, 28, 48, 62), p);
    c.drawLine(const Offset(150, 92), const Offset(150, 282), p);
    for (var i = 0; i < 8; i++) {
      final y = 116.0 + i * 13;
      final half = 42.0 - i * 2.4;
      c.drawArc(
        Rect.fromCenter(center: Offset(150, y), width: half * 2, height: 24),
        3.32,
        2.75,
        false,
        _paint(const Color(0xFFE7EDF6), width: 3),
      );
    }
    c.drawLine(const Offset(120, 105), const Offset(89, 178), p);
    c.drawLine(const Offset(89, 178), const Offset(84, 310), p);
    c.drawLine(const Offset(180, 105), const Offset(211, 178), p);
    c.drawLine(const Offset(211, 178), const Offset(216, 310), p);
    c.drawLine(const Offset(150, 270), const Offset(125, 386), p);
    c.drawLine(const Offset(125, 386), const Offset(123, 568), p);
    c.drawLine(const Offset(150, 270), const Offset(175, 386), p);
    c.drawLine(const Offset(175, 386), const Offset(177, 568), p);
    c.drawArc(const Rect.fromLTWH(115, 245, 70, 55), 0, math.pi, false, p);
  }

  void _drawJoints(Canvas c) {
    final p = _paint(const Color(0xFF8CF5FF), width: 4, fill: true);
    for (final point in const [
      Offset(102, 112), Offset(198, 112), Offset(88, 195), Offset(212, 195),
      Offset(127, 278), Offset(173, 278), Offset(124, 395), Offset(176, 395),
      Offset(123, 565), Offset(177, 565),
    ]) {
      c.drawCircle(point, 7, p);
    }
  }

  void _drawMuscular(Canvas c) {
    final p = _paint(const Color(0xFFFF6B7D), fill: true);
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(112, 105, 76, 150),
        const Radius.circular(35),
      ),
      p,
    );
    for (final rect in const [
      Rect.fromLTWH(78, 108, 22, 198),
      Rect.fromLTWH(200, 108, 22, 198),
      Rect.fromLTWH(111, 285, 31, 276),
      Rect.fromLTWH(158, 285, 31, 276),
    ]) {
      c.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(14)),
        p,
      );
    }
    c.drawLine(
      const Offset(150, 120),
      const Offset(150, 245),
      _paint(Colors.white.withValues(alpha: .55), width: 2),
    );
  }

  void _drawHeart(Canvas c) {
    final p = _paint(const Color(0xFFFF4E73), fill: true);
    final path = Path()
      ..moveTo(152, 177)
      ..cubicTo(132, 150, 111, 177, 152, 220)
      ..cubicTo(193, 177, 172, 150, 152, 177)
      ..close();
    c.drawPath(path, p);
  }

  void _drawVessels(Canvas c, Color color, {required bool arterial}) {
    final p = _paint(color, width: 3);
    final x = arterial ? 145.0 : 155.0;
    c.drawLine(Offset(x, 90), Offset(x, 560), p);
    c.drawLine(Offset(x, 145), const Offset(92, 190), p);
    c.drawLine(Offset(x, 145), const Offset(208, 190), p);
    c.drawLine(Offset(x, 290), const Offset(124, 430), p);
    c.drawLine(Offset(x, 290), const Offset(176, 430), p);
    c.drawLine(const Offset(124, 430), const Offset(123, 560), p);
    c.drawLine(const Offset(176, 430), const Offset(177, 560), p);
  }

  void _drawNervous(Canvas c) {
    final p = _paint(const Color(0xFFFFD84A), width: 3);
    c.drawOval(
      const Rect.fromLTWH(133, 44, 34, 28),
      _paint(const Color(0xFFFFD84A), fill: true),
    );
    c.drawLine(const Offset(150, 70), const Offset(150, 390), p);
    for (var i = 0; i < 10; i++) {
      final y = 112.0 + i * 30;
      c.drawLine(Offset(150, y), Offset(95, y + 28), p);
      c.drawLine(Offset(150, y), Offset(205, y + 28), p);
    }
    c.drawLine(const Offset(150, 335), const Offset(123, 560), p);
    c.drawLine(const Offset(150, 335), const Offset(177, 560), p);
  }

  void _drawLymphatic(Canvas c) {
    c.drawLine(
      const Offset(150, 95),
      const Offset(150, 535),
      _paint(const Color(0xFF7EEB8A), width: 2),
    );
    final node = _paint(const Color(0xFF7EEB8A), fill: true);
    for (final pt in const [
      Offset(140, 100), Offset(160, 100), Offset(105, 160), Offset(195, 160),
      Offset(130, 260), Offset(170, 260), Offset(125, 350), Offset(175, 350),
      Offset(123, 470), Offset(177, 470),
    ]) {
      c.drawCircle(pt, 5, node);
    }
  }

  void _drawRespiratory(Canvas c) {
    final p = _paint(const Color(0xFF7FD4FF), fill: true);
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(119, 130, 30, 100),
        const Radius.circular(18),
      ),
      p,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(151, 130, 30, 100),
        const Radius.circular(18),
      ),
      p,
    );
    c.drawLine(
      const Offset(150, 90),
      const Offset(150, 140),
      _paint(const Color(0xFF7FD4FF), width: 7),
    );
  }

  void _drawDigestive(Canvas c) {
    c.drawOval(
      const Rect.fromLTWH(152, 236, 44, 34),
      _paint(const Color(0xFFFF9C55), fill: true),
    );
    c.drawOval(
      const Rect.fromLTWH(105, 225, 58, 32),
      _paint(const Color(0xFFB86F3D), fill: true),
    );
    final path = Path()
      ..moveTo(132, 282)
      ..cubicTo(110, 305, 180, 312, 145, 338)
      ..cubicTo(112, 365, 185, 370, 148, 395);
    c.drawPath(path, _paint(const Color(0xFFFFB979), width: 7));
  }

  void _drawUrinary(Canvas c) {
    final p = _paint(const Color(0xFFB58CFF), fill: true);
    c.drawOval(const Rect.fromLTWH(117, 265, 25, 42), p);
    c.drawOval(const Rect.fromLTWH(158, 265, 25, 42), p);
    c.drawLine(
      const Offset(130, 300),
      const Offset(145, 370),
      _paint(const Color(0xFFB58CFF), width: 3),
    );
    c.drawLine(
      const Offset(170, 300),
      const Offset(155, 370),
      _paint(const Color(0xFFB58CFF), width: 3),
    );
    c.drawOval(const Rect.fromLTWH(136, 365, 28, 26), p);
  }

  void _drawReproductive(Canvas c) {
    final p = _paint(const Color(0xFFFF78C8), fill: true);
    c.drawOval(const Rect.fromLTWH(133, 365, 34, 28), p);
    c.drawCircle(const Offset(126, 370), 8, p);
    c.drawCircle(const Offset(174, 370), 8, p);
  }

  void _drawEndocrine(Canvas c) {
    final p = _paint(const Color(0xFF54E0C2), fill: true);
    for (final item in const [
      (Offset(150, 59), 5.0),
      (Offset(150, 112), 8.0),
      (Offset(128, 260), 6.0),
      (Offset(172, 260), 6.0),
      (Offset(157, 278), 7.0),
    ]) {
      c.drawCircle(item.$1, item.$2, p);
    }
  }

  void _drawSensory(Canvas c) {
    final p = _paint(const Color(0xFF65E6FF), fill: true);
    c.drawCircle(const Offset(140, 57), 5, p);
    c.drawCircle(const Offset(160, 57), 5, p);
    c.drawCircle(const Offset(124, 62), 4, p);
    c.drawCircle(const Offset(176, 62), 4, p);
    c.drawOval(const Rect.fromLTWH(143, 72, 14, 6), p);
  }

  void _drawIntegumentary(Canvas c) {
    final p = _paint(const Color(0xFFE0A985), width: 7);
    c.drawOval(const Rect.fromLTWH(122, 22, 56, 72), p);
    c.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(105, 92, 90, 190),
        const Radius.circular(42),
      ),
      p,
    );
    for (final rect in const [
      Rect.fromLTWH(75, 102, 28, 215),
      Rect.fromLTWH(197, 102, 28, 215),
      Rect.fromLTWH(108, 272, 36, 305),
      Rect.fromLTWH(156, 272, 36, 305),
    ]) {
      c.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(18)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AnatomyBodyPainter oldDelegate) =>
      oldDelegate.selectedSystems != selectedSystems ||
      oldDelegate.opacity != opacity;
}
