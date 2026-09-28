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
          borderRadius: BorderRadius.circular(size * .22),
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
          painter: const _NorieLogoPainter(),
        ),
      ),
    );
  }
}

class _NorieLogoPainter extends CustomPainter {
  const _NorieLogoPainter();

  static const _cyan = Color(0xFF22D3EE);
  static const _blue = Color(0xFF2563EB);
  static const _violet = Color(0xFF7C3AED);
  static const _magenta = Color(0xFFE879F9);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 512;
    final sy = size.height / 512;

    canvas.save();
    canvas.scale(sx, sy);

    const designRect = Rect.fromLTWH(0, 0, 512, 512);
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF07152F),
          Color(0xFF0C1F4D),
          Color(0xFF15164D),
        ],
        stops: [0, .55, 1],
      ).createShader(designRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        designRect,
        const Radius.circular(112),
      ),
      background,
    );

    final brandShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [_cyan, _blue, _violet, _magenta],
      stops: [0, .38, .72, 1],
    ).createShader(designRect);

    final nPath = Path()
      ..moveTo(108, 352)
      ..lineTo(108, 132)
      ..cubicTo(108, 105, 121, 93, 146, 93)
      ..cubicTo(194, 93, 236, 163, 276, 212)
      ..lineTo(370, 327)
      ..lineTo(370, 132)
      ..cubicTo(370, 108, 382, 96, 409, 96)
      ..lineTo(409, 352)
      ..cubicTo(409, 383, 394, 395, 366, 395)
      ..cubicTo(315, 395, 275, 324, 234, 275)
      ..lineTo(148, 173)
      ..lineTo(148, 352)
      ..close();

    canvas.drawPath(
      nPath,
      Paint()
        ..shader = brandShader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawPath(
      nPath,
      Paint()..shader = brandShader,
    );

    final bookPath = Path()
      ..moveTo(106, 334)
      ..cubicTo(169, 314, 210, 335, 256, 399)
      ..cubicTo(301, 335, 345, 313, 408, 334)
      ..lineTo(408, 396)
      ..cubicTo(344, 383, 297, 400, 256, 450)
      ..cubicTo(213, 400, 168, 383, 106, 396)
      ..close();

    canvas.drawPath(
      bookPath,
      Paint()..shader = brandShader,
    );

    final pageLine = Path()
      ..moveTo(108, 341)
      ..cubicTo(170, 328, 213, 352, 256, 399)
      ..cubicTo(299, 352, 344, 328, 406, 341);

    canvas.drawPath(
      pageLine,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );

    final sparkleOuter = Path()
      ..moveTo(390, 58)
      ..lineTo(400, 85)
      ..lineTo(427, 95)
      ..lineTo(400, 105)
      ..lineTo(390, 132)
      ..lineTo(380, 105)
      ..lineTo(353, 95)
      ..lineTo(380, 85)
      ..close();

    canvas.drawPath(
      sparkleOuter,
      Paint()..color = _cyan,
    );

    final sparkleInner = Path()
      ..moveTo(390, 65)
      ..lineTo(397, 85)
      ..lineTo(417, 92)
      ..lineTo(397, 99)
      ..lineTo(390, 119)
      ..lineTo(383, 99)
      ..lineTo(363, 92)
      ..lineTo(383, 85)
      ..close();

    canvas.drawPath(
      sparkleInner,
      Paint()..color = _magenta.withValues(alpha: .75),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
