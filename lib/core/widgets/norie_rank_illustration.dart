import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original, offline academic illustrations. Coordinates use a 100-unit canvas
/// so the same clear silhouettes work on a small rank row and a profile card.
enum NorieRankIllustration { pencil, compass, book, science, graduation }

NorieRankIllustration rankIllustrationForLevel(int level) {
  if (level >= 50) return NorieRankIllustration.graduation;
  if (level >= 30) return NorieRankIllustration.science;
  if (level >= 15) return NorieRankIllustration.book;
  if (level >= 5) return NorieRankIllustration.compass;
  return NorieRankIllustration.pencil;
}

class NorieRankIllustrationPainter extends CustomPainter {
  const NorieRankIllustrationPainter({
    required this.illustration,
    this.phase = 0,
    this.moving = false,
  });
  final NorieRankIllustration illustration;
  final double phase;
  final bool moving;

  static const _ink = Color(0xFF18364D);
  static const _paper = Color(0xFFFFF7DB);
  static const _teal = Color(0xFF65DBCF);
  static const _gold = Color(0xFFFFCD68);
  static const _coral = Color(0xFFFF9CA9);
  static const _violet = Color(0xFFB7A1F2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    final accent = switch (illustration) {
      NorieRankIllustration.pencil => _gold,
      NorieRankIllustration.compass => _teal,
      NorieRankIllustration.book => _violet,
      NorieRankIllustration.science => _teal,
      NorieRankIllustration.graduation => _gold,
    };
    canvas.drawCircle(const Offset(50, 51), 37,
        Paint()..color = accent.withValues(alpha: .13));
    canvas.drawOval(const Rect.fromLTWH(28, 77, 44, 6),
        Paint()..color = _ink.withValues(alpha: .16));
    canvas.save();
    if (moving) canvas.translate(0, math.sin(phase) * 1.2);
    switch (illustration) {
      case NorieRankIllustration.pencil:
        _pencil(canvas);
      case NorieRankIllustration.compass:
        _compass(canvas);
      case NorieRankIllustration.book:
        _book(canvas);
      case NorieRankIllustration.science:
        _science(canvas);
      case NorieRankIllustration.graduation:
        _graduation(canvas);
    }
    canvas.restore();
    canvas.restore();
  }

  void _path(Canvas c, Path path, Color fill) {
    c.drawPath(path, Paint()..color = fill);
    c.drawPath(path, _stroke());
  }

  Paint _stroke([Color color = _ink, double width = 2.5]) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;

  void _round(Canvas c, Rect rect, Color fill, [double radius = 3]) {
    final shape = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    c.drawRRect(shape, Paint()..color = fill);
    c.drawRRect(shape, _stroke());
  }

  void _face(Canvas c, Offset center) {
    for (final x in [-4.0, 4.0]) {
      c.drawCircle(center + Offset(x, -2), 1.4, Paint()..color = _ink);
    }
    c.drawArc(
        Rect.fromCenter(
            center: center + const Offset(0, 1), width: 5, height: 4),
        0,
        math.pi,
        false,
        _stroke(_ink, 1.6));
  }

  void _pencil(Canvas c) {
    c.save();
    c.translate(50, 50);
    c.rotate(.52);
    c.translate(-50, -50);
    _round(c, const Rect.fromLTWH(40, 21, 20, 13), _coral, 5);
    _round(c, const Rect.fromLTWH(40, 32, 20, 36), _gold, 1);
    c.drawLine(const Offset(46, 37), const Offset(46, 58), _stroke(_paper, 3));
    _path(
        c,
        Path()
          ..moveTo(40, 68)
          ..lineTo(60, 68)
          ..lineTo(50, 82)
          ..close(),
        _paper);
    _path(
        c,
        Path()
          ..moveTo(46, 76)
          ..lineTo(54, 76)
          ..lineTo(50, 82)
          ..close(),
        _ink);
    _face(c, const Offset(51, 47));
    c.restore();
  }

  void _compass(Canvas c) {
    _round(c, const Rect.fromLTWH(44, 17, 12, 12), _gold, 4);
    c.drawCircle(const Offset(50, 53), 27, Paint()..color = _gold);
    c.drawCircle(const Offset(50, 53), 27, _stroke());
    c.drawCircle(const Offset(50, 53), 22, Paint()..color = _paper);
    c.drawCircle(const Offset(50, 53), 22, _stroke(_ink, 1.7));
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final d = Offset(math.sin(angle), math.cos(angle));
      c.drawLine(const Offset(50, 53) + d * 17, const Offset(50, 53) + d * 19,
          _stroke());
    }
    final turn = moving ? math.sin(phase) * .04 : 0.0;
    c.save();
    c.translate(50, 53);
    c.rotate(.45 + turn);
    _path(
        c,
        Path()
          ..moveTo(0, -17)
          ..lineTo(7, 0)
          ..lineTo(0, 4)
          ..lineTo(-7, 0)
          ..close(),
        _coral);
    _path(
        c,
        Path()
          ..moveTo(0, 17)
          ..lineTo(7, 0)
          ..lineTo(0, -4)
          ..lineTo(-7, 0)
          ..close(),
        _teal);
    c.drawCircle(Offset.zero, 3, Paint()..color = _ink);
    c.restore();
  }

  void _book(Canvas c) {
    _round(c, const Rect.fromLTWH(20, 30, 60, 46), _violet, 5);
    _path(
        c,
        Path()
          ..moveTo(50, 34)
          ..quadraticBezierTo(37, 24, 24, 29)
          ..lineTo(24, 68)
          ..quadraticBezierTo(38, 65, 50, 73)
          ..quadraticBezierTo(63, 65, 76, 68)
          ..lineTo(76, 29)
          ..quadraticBezierTo(62, 24, 50, 34)
          ..close(),
        _paper);
    c.drawLine(const Offset(50, 35), const Offset(50, 70), _stroke());
    _path(
        c,
        Path()
          ..moveTo(62, 28)
          ..lineTo(69, 28)
          ..lineTo(69, 47)
          ..lineTo(65.5, 43)
          ..lineTo(62, 47)
          ..close(),
        _coral);
    for (var i = 0; i < 3; i++) {
      c.drawLine(
          Offset(30, 40 + i * 7), Offset(43, 43 + i * 7), _stroke(_violet, 2));
    }
    _face(c, const Offset(63, 57));
  }

  void _science(Canvas c) {
    final flask = Path()
      ..moveTo(41, 29)
      ..lineTo(59, 29)
      ..lineTo(59, 44)
      ..lineTo(74, 68)
      ..quadraticBezierTo(79, 78, 67, 79)
      ..lineTo(33, 79)
      ..quadraticBezierTo(21, 78, 26, 68)
      ..lineTo(41, 44)
      ..close();
    _path(c, flask, _paper);
    c.save();
    c.clipPath(flask);
    c.drawPath(
        Path()
          ..moveTo(22, 59)
          ..quadraticBezierTo(36, 52, 50, 59)
          ..quadraticBezierTo(65, 66, 79, 57)
          ..lineTo(79, 84)
          ..lineTo(22, 84)
          ..close(),
        Paint()..color = _teal);
    c.restore();
    c.drawPath(flask, _stroke());
    _round(c, const Rect.fromLTWH(38, 26, 24, 6), _violet, 2);
    for (var i = 0; i < 3; i++) {
      final y = 20.0 - i * 6 + (moving ? math.sin(phase + i) : 0);
      c.drawCircle(Offset(i.isEven ? 48 : 57, y), i == 1 ? 3 : 2,
          Paint()..color = i == 1 ? _violet : _teal);
    }
    _face(c, const Offset(50, 67));
    c.drawLine(const Offset(34, 67), const Offset(37, 61), _stroke(_paper, 3));
  }

  void _graduation(Canvas c) {
    _path(
        c,
        Path()
          ..moveTo(29, 46)
          ..lineTo(29, 65)
          ..quadraticBezierTo(50, 79, 71, 65)
          ..lineTo(71, 46)
          ..close(),
        _violet);
    _path(
        c,
        Path()
          ..moveTo(15, 40)
          ..lineTo(50, 24)
          ..lineTo(85, 40)
          ..lineTo(50, 56)
          ..close(),
        _ink);
    c.drawLine(const Offset(50, 40), const Offset(79, 48), _stroke(_gold, 3));
    c.drawLine(const Offset(79, 48), const Offset(79, 66), _stroke(_gold, 3));
    _round(c, const Rect.fromLTWH(75, 64, 8, 11), _gold, 3);
    c.drawCircle(const Offset(50, 40), 3, Paint()..color = _gold);
    _face(c, const Offset(50, 64));
  }

  @override
  bool shouldRepaint(covariant NorieRankIllustrationPainter oldDelegate) =>
      illustration != oldDelegate.illustration ||
      phase != oldDelegate.phase ||
      moving != oldDelegate.moving;
}
