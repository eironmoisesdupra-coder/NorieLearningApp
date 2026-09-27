import 'dart:math' as math;

import 'package:flutter/material.dart';

class NorieLogoMark extends StatelessWidget {
  const NorieLogoMark({
    super.key,
    this.size = 96,
    this.showGlow = true,
  });

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * .24),
          boxShadow: showGlow
              ? [
                  BoxShadow(
                    color: const Color(0xFF5B5CE2).withValues(alpha: .35),
                    blurRadius: size * .28,
                    spreadRadius: size * .02,
                  ),
                ]
              : null,
        ),
        child: CustomPaint(
          painter: _NorieLogoPainter(),
        ),
      ),
    );
  }
}

class _NorieLogoPainter extends CustomPainter {
  static const _cyan = Color(0xFF22D3EE);
  static const _blue = Color(0xFF2563EB);
  static const _violet = Color(0xFF7C3AED);
  static const _magenta = Color(0xFFE879F9);
  static const _navy = Color(0xFF0B1E58);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = Radius.circular(size.width * .22);

    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF07152F),
          Color(0xFF0C1F4D),
          Color(0xFF15164D),
        ],
      ).createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), bg);

    final nPath = Path()
      ..moveTo(size.width * .21, size.height * .69)
      ..lineTo(size.width * .21, size.height * .25)
      ..quadraticBezierTo(
        size.width * .21,
        size.height * .18,
        size.width * .29,
        size.height * .18,
      )
      ..cubicTo(
        size.width * .40,
        size.height * .18,
        size.width * .47,
        size.height * .38,
        size.width * .58,
        size.height * .50,
      )
      ..lineTo(size.width * .72, size.height * .66)
      ..lineTo(size.width * .72, size.height * .25)
      ..quadraticBezierTo(
        size.width * .72,
        size.height * .19,
        size.width * .80,
        size.height * .19,
      )
      ..lineTo(size.width * .80, size.height * .70)
      ..quadraticBezierTo(
        size.width * .80,
        size.height * .79,
        size.width * .70,
        size.height * .79,
      )
      ..cubicTo(
        size.width * .58,
        size.height * .78,
        size.width * .49,
        size.height * .57,
        size.width * .38,
        size.height * .45,
      )
      ..lineTo(size.width * .29, size.height * .35)
      ..lineTo(size.width * .29, size.height * .69)
      ..close();

    final nPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_cyan, _blue, _violet, _magenta],
        stops: [0, .38, .72, 1],
      ).createShader(rect);
    canvas.drawPath(nPath, nPaint);

    final shadowPath = Path()
      ..moveTo(size.width * .29, size.height * .35)
      ..lineTo(size.width * .38, size.height * .45)
      ..cubicTo(
        size.width * .49,
        size.height * .57,
        size.width * .58,
        size.height * .78,
        size.width * .70,
        size.height * .79,
      )
      ..lineTo(size.width * .62, size.height * .80)
      ..cubicTo(
        size.width * .53,
        size.height * .71,
        size.width * .44,
        size.height * .55,
        size.width * .34,
        size.height * .45,
      )
      ..close();
    canvas.drawPath(
      shadowPath,
      Paint()..color = _navy.withValues(alpha: .68),
    );

    final leftPage = Path()
      ..moveTo(size.width * .20, size.height * .66)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .61,
        size.width * .50,
        size.height * .82,
      )
      ..quadraticBezierTo(
        size.width * .36,
        size.height * .74,
        size.width * .20,
        size.height * .77,
      )
      ..close();
    final rightPage = Path()
      ..moveTo(size.width * .50, size.height * .82)
      ..quadraticBezierTo(
        size.width * .65,
        size.height * .61,
        size.width * .82,
        size.height * .66,
      )
      ..lineTo(size.width * .82, size.height * .77)
      ..quadraticBezierTo(
        size.width * .65,
        size.height * .74,
        size.width * .50,
        size.height * .82,
      )
      ..close();

    final pagePaint = Paint()
      ..shader = const LinearGradient(
        colors: [_cyan, _blue, _violet],
      ).createShader(rect);
    canvas.drawPath(leftPage, pagePaint);
    canvas.drawPath(rightPage, pagePaint);

    final whiteLine = Paint()
      ..color = Colors.white.withValues(alpha: .95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .024
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .21, size.height * .67)
        ..quadraticBezierTo(
          size.width * .36,
          size.height * .64,
          size.width * .50,
          size.height * .82,
        )
        ..quadraticBezierTo(
          size.width * .65,
          size.height * .64,
          size.width * .81,
          size.height * .67,
        ),
      whiteLine,
    );

    final sparkleCenter = Offset(size.width * .77, size.height * .14);
    final sparkle = Path();
    for (var i = 0; i < 8; i++) {
      final angle = -math.pi / 2 + (math.pi / 4 * i);
      final r = i.isEven ? size.width * .075 : size.width * .028;
      final p = sparkleCenter + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (i == 0) {
        sparkle.moveTo(p.dx, p.dy);
      } else {
        sparkle.lineTo(p.dx, p.dy);
      }
    }
    sparkle.close();
    canvas.drawPath(
      sparkle,
      Paint()
        ..shader = const LinearGradient(
          colors: [_cyan, _violet, _magenta],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
