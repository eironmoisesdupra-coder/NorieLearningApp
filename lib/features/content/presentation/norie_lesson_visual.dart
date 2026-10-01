import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

class NorieLessonVisual extends StatelessWidget {
  const NorieLessonVisual({
    required this.type,
    required this.title,
    required this.accent,
    this.compact = false,
    super.key,
  });

  final String type;
  final String title;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Educational illustration for $title',
      image: true,
      child: Container(
        height: compact ? 155 : 210,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: NorieColors.surface,
          borderRadius: BorderRadius.circular(compact ? 16 : 22),
          border: Border.all(color: accent.withValues(alpha: .35)),
        ),
        child: CustomPaint(
          painter: _LessonVisualPainter(type: type, accent: accent),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(11),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: NorieColors.background.withValues(alpha: .86),
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
    if (type.startsWith('g1-counting')) {
      _paintCounting(canvas, size);
      return;
    }
    if (type.startsWith('g1-place-value')) {
      _paintPlaceValue(canvas, size);
      return;
    }
    if (type.startsWith('g1-addition')) {
      _paintAddition(canvas, size);
      return;
    }
    if (type.startsWith('g1-subtraction')) {
      _paintSubtraction(canvas, size);
      return;
    }
    if (type.startsWith('g1-shapes')) {
      _paintShapesAndPatterns(canvas, size);
      return;
    }

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
      canvas.drawCircle(
        Offset(center.dx + 72, center.dy),
        7,
        Paint()..color = Colors.white,
      );
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
      canvas.drawRRect(
        RRect.fromRectAndRadius(left, const Radius.circular(8)),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(right, const Radius.circular(8)),
        fill,
      );
      canvas.drawLine(
        Offset(size.width * .47, 45),
        Offset(size.width * .47, 142),
        strong,
      );
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

  void _paintCounting(Canvas canvas, Size size) {
    final lineY = size.height * .57;
    final left = size.width * .10;
    final right = size.width * .90;
    final line = Paint()
      ..color = accent.withValues(alpha: .65)
      ..strokeWidth = 3;

    canvas.drawLine(Offset(left, lineY), Offset(right, lineY), line);

    for (var i = 0; i <= 10; i++) {
      final x = left + ((right - left) * i / 10);
      canvas.drawLine(
        Offset(x, lineY - 8),
        Offset(x, lineY + 8),
        line,
      );
      _text(
        canvas,
        '$i',
        Offset(x, lineY + 18),
        size: 10,
        center: true,
      );
    }

    for (var i = 0; i < 8; i++) {
      final row = i ~/ 4;
      final col = i % 4;
      canvas.drawCircle(
        Offset(
          size.width * .37 + col * 28,
          size.height * .20 + row * 27,
        ),
        8,
        Paint()..color = accent.withValues(alpha: .82),
      );
    }
    _text(canvas, '8 counters', Offset(size.width * .62, size.height * .26));
  }

  void _paintPlaceValue(Canvas canvas, Size size) {
    final baseY = size.height * .74;
    final startX = size.width * .18;
    final unit = math.min(10.0, size.height * .055);
    final fill = Paint()..color = accent.withValues(alpha: .72);
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: .75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var ten = 0; ten < 3; ten++) {
      final x = startX + ten * 18;
      final rect = Rect.fromLTWH(x, baseY - unit * 10, 12, unit * 10);
      canvas.drawRect(rect, fill);
      canvas.drawRect(rect, stroke);
      for (var j = 1; j < 10; j++) {
        canvas.drawLine(
          Offset(x, baseY - unit * j),
          Offset(x + 12, baseY - unit * j),
          stroke,
        );
      }
    }

    for (var one = 0; one < 4; one++) {
      final x = size.width * .62 + (one % 2) * 20;
      final y = baseY - 25 - (one ~/ 2) * 20;
      final rect = Rect.fromLTWH(x, y, 13, 13);
      canvas.drawRect(rect, fill);
      canvas.drawRect(rect, stroke);
    }
    _text(canvas, '3 tens', Offset(size.width * .18, baseY + 8));
    _text(canvas, '4 ones', Offset(size.width * .59, baseY + 8));
    _text(
      canvas,
      '34',
      Offset(size.width * .47, size.height * .16),
      size: 25,
      weight: FontWeight.w900,
    );
  }

  void _paintAddition(Canvas canvas, Size size) {
    final y = size.height * .44;
    _counterGroup(canvas, Offset(size.width * .24, y), 3);
    _text(
      canvas,
      '+',
      Offset(size.width * .43, y - 15),
      size: 26,
      weight: FontWeight.w900,
    );
    _counterGroup(canvas, Offset(size.width * .54, y), 2);
    _text(
      canvas,
      '=',
      Offset(size.width * .69, y - 15),
      size: 26,
      weight: FontWeight.w900,
    );
    _text(
      canvas,
      '5',
      Offset(size.width * .81, y - 17),
      size: 30,
      weight: FontWeight.w900,
    );
    _text(
      canvas,
      '3 objects joined with 2 objects makes 5.',
      Offset(size.width * .19, size.height * .72),
      size: 11,
    );
  }

  void _paintSubtraction(Canvas canvas, Size size) {
    final y = size.height * .42;
    final startX = size.width * .24;
    for (var i = 0; i < 7; i++) {
      final center = Offset(startX + (i % 4) * 34, y + (i ~/ 4) * 38);
      canvas.drawCircle(
        center,
        11,
        Paint()..color = accent.withValues(alpha: i >= 5 ? .25 : .82),
      );
      if (i >= 5) {
        final slash = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5;
        canvas.drawLine(center.translate(-10, -10), center.translate(10, 10), slash);
      }
    }
    _text(
      canvas,
      '7 − 2 = 5',
      Offset(size.width * .61, size.height * .37),
      size: 24,
      weight: FontWeight.w900,
    );
    _text(
      canvas,
      'Start with 7. Take away 2. Count the 5 left.',
      Offset(size.width * .20, size.height * .77),
      size: 11,
    );
  }

  void _paintShapesAndPatterns(Canvas canvas, Size size) {
    final y = size.height * .34;
    final centers = [
      Offset(size.width * .18, y),
      Offset(size.width * .35, y),
      Offset(size.width * .52, y),
      Offset(size.width * .69, y),
      Offset(size.width * .86, y),
    ];

    for (var i = 0; i < centers.length; i++) {
      if (i.isEven) {
        canvas.drawCircle(
          centers[i],
          16,
          Paint()..color = accent.withValues(alpha: .78),
        );
      } else {
        final rect = Rect.fromCenter(
          center: centers[i],
          width: 31,
          height: 31,
        );
        canvas.drawRect(
          rect,
          Paint()..color = Colors.white.withValues(alpha: .72),
        );
      }
    }

    _text(
      canvas,
      'circle, square, circle, square, ...',
      Offset(size.width * .20, size.height * .59),
      size: 11,
    );
    _text(
      canvas,
      'What comes next?',
      Offset(size.width * .34, size.height * .73),
      size: 15,
      weight: FontWeight.w900,
    );
  }

  void _counterGroup(Canvas canvas, Offset origin, int count) {
    for (var i = 0; i < count; i++) {
      canvas.drawCircle(
        origin.translate(i * 27.0, 0),
        10,
        Paint()..color = accent.withValues(alpha: .82),
      );
    }
  }

  void _text(
    Canvas canvas,
    String value,
    Offset offset, {
    double size = 12,
    FontWeight weight = FontWeight.w700,
    bool center = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: Colors.white.withValues(alpha: .92),
          fontSize: size,
          fontWeight: weight,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center ? offset.translate(-painter.width / 2, 0) : offset,
    );
  }

  @override
  bool shouldRepaint(covariant _LessonVisualPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.accent != accent;
}
