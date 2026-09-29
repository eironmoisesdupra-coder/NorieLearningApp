import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

class NorieLessonVisual extends StatelessWidget {
  const NorieLessonVisual({
    required this.type,
    required this.title,
    required this.accent,
    super.key,
  });

  final String type;
  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Educational illustration for $title',
      image: true,
      child: Container(
        height: 190,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: NorieColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withValues(alpha: .35)),
        ),
        child: CustomPaint(
          painter: _LessonVisualPainter(type: type, accent: accent),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(13),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: NorieColors.background.withValues(alpha: .82),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonVisualPainter extends CustomPainter {
  const _LessonVisualPainter({required this.type, required this.accent});
  final String type;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final faint = Paint()
      ..color = accent.withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final strong = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final fill = Paint()..color = accent.withValues(alpha: .16);
    final center = Offset(size.width * .58, size.height * .46);

    if (type == 'atom') {
      canvas.drawCircle(center, 18, Paint()..color = accent);
      for (final tilt in [-.7, 0.0, .7]) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(tilt);
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: 150, height: 58),
          faint,
        );
        canvas.restore();
      }
      canvas.drawCircle(Offset(center.dx + 72, center.dy), 7, Paint()..color = Colors.white);
      return;
    }

    if (type == 'math') {
      final origin = Offset(size.width * .18, size.height * .72);
      canvas.drawLine(origin, Offset(size.width * .88, origin.dy), faint);
      canvas.drawLine(origin, Offset(origin.dx, size.height * .18), faint);
      final path = Path()
        ..moveTo(origin.dx, origin.dy - 10)
        ..quadraticBezierTo(
          size.width * .48,
          size.height * .20,
          size.width * .82,
          size.height * .38,
        );
      canvas.drawPath(path, strong);
      for (var i = 0; i < 5; i++) {
        canvas.drawCircle(
          Offset(origin.dx + i * 60, origin.dy - 25 - i * 15),
          6,
          Paint()..color = accent,
        );
      }
      return;
    }

    if (type == 'language') {
      final left = Rect.fromLTWH(size.width * .18, 38, size.width * .28, 105);
      final right = Rect.fromLTWH(size.width * .48, 38, size.width * .28, 105);
      canvas.drawRRect(RRect.fromRectAndRadius(left, const Radius.circular(8)), fill);
      canvas.drawRRect(RRect.fromRectAndRadius(right, const Radius.circular(8)), fill);
      canvas.drawLine(Offset(size.width * .47, 45), Offset(size.width * .47, 142), strong);
      for (var i = 0; i < 4; i++) {
        canvas.drawLine(
          Offset(left.left + 15, left.top + 22 + i * 19),
          Offset(left.right - 15, left.top + 22 + i * 19),
          faint,
        );
        canvas.drawLine(
          Offset(right.left + 15, right.top + 22 + i * 19),
          Offset(right.right - 15, right.top + 22 + i * 19),
          faint,
        );
      }
      return;
    }

    canvas.drawCircle(center, 56, faint);
    canvas.drawCircle(center, 32, strong);
    for (var i = 0; i < 6; i++) {
      final p = Offset(
        center.dx + 72 * (i.isEven ? 1 : -1) * .7,
        center.dy + (i - 2.5) * 18,
      );
      canvas.drawCircle(p, 8, Paint()..color = accent.withValues(alpha: .7));
      canvas.drawLine(center, p, faint);
    }
  }

  @override
  bool shouldRepaint(covariant _LessonVisualPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.accent != accent;
}
