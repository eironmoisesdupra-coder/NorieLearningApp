import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'science_grade4_picture.dart';
import 'science_grade5_picture.dart';

/// Original offline vector models. Every label is a Flutter text widget.
class SciencePicture extends StatelessWidget {
  const SciencePicture({required this.picture, super.key});
  final String picture;

  static String descriptionFor(String picture) {
    if (Grade4SciencePicture.supports(picture)) {
      return Grade4SciencePicture.descriptions[picture]!;
    }
    if (Grade5SciencePicture.supports(picture)) {
      return Grade5SciencePicture.descriptions[picture]!;
    }
    return switch (picture) {
      'butterfly' =>
        'Butterfly life cycle: eggs on a leaf, a caterpillar, a hanging pupa, and a winged adult. Adults lay eggs for the next generation.',
      'bean' =>
        'Bean life cycle: a seed, a first root emerging from a seed, a seedling with leaves, and a mature plant bearing pods containing new seeds.',
      'habitat' =>
        'A bird habitat has berries for food, a pond for water, a nest for shelter, and open space for movement.',
      'shadow' =>
        'Light rays travel from a torch toward a wall. An opaque card blocks the middle rays, leaving a dark shadow on the wall.',
      'daynight' =>
        'The Sun lights the left side of Earth. The side facing the Sun has day; the side facing away has night. Earth rotates in place.',
      'plant-parts' =>
        'A flowering bean plant: branching roots below the soil, an upright stem, green leaves attached to the stem, a flower at the top, and a pod containing seeds. Roots anchor and absorb; the stem supports and transports; leaves make food; flowers and seed-filled fruits help reproduction.',
      'forces' =>
        'Two blocks with horizontal force arrows. Top: equal-length arrows point left and right, so the horizontal forces are balanced. Bottom: a longer right arrow and shorter left arrow show unbalanced forces toward the right. Arrow lengths compare force strength, not travel distance. Vertical forces are balanced and omitted.',
      _ => throw ArgumentError('Unknown Science picture: $picture'),
    };
  }

  static const _labels = {
    'butterfly': [
      '1 · Egg',
      '2 · Caterpillar',
      '3 · Pupa',
      '4 · Adult butterfly'
    ],
    'bean': [
      '1 · Seed',
      '2 · First root',
      '3 · Seedling',
      '4 · Plant with pods'
    ],
    'habitat': [
      '1 · Food: berries',
      '2 · Water: pond',
      '3 · Shelter: nest',
      '4 · Space: room to move'
    ],
    'shadow': [
      '1 · Torch gives light',
      '2 · Opaque card blocks light',
      '3 · Shadow on the wall'
    ],
    'daynight': [
      '1 · Sun gives light',
      '2 · Day: facing the Sun',
      '3 · Night: facing away',
      '4 · Earth rotates'
    ],
    'plant-parts': [
      '1 · Roots: anchor and absorb water',
      '2 · Stem: support and transport',
      '3 · Leaves: make food using light',
      '4 · Flower: helps produce seeds',
      '5 · Fruit: pod containing seeds'
    ],
    'forces': [
      '1 · Equal opposite forces: balanced',
      '2 · Stronger right force: unbalanced'
    ],
  };

  static const _markers = {
    'habitat': [
      Offset(.14, .50),
      Offset(.84, .91),
      Offset(.85, .15),
      Offset(.48, .10)
    ],
    'shadow': [Offset(.10, .81), Offset(.49, .15), Offset(.84, .85)],
    'daynight': [
      Offset(.10, .16),
      Offset(.56, .22),
      Offset(.85, .22),
      Offset(.66, .87)
    ],
    'plant-parts': [
      Offset(.16, .86),
      Offset(.17, .26),
      Offset(.86, .18),
      Offset(.38, .09),
      Offset(.88, .67)
    ],
    'forces': [Offset(.09, .29), Offset(.09, .72)],
  };

  @override
  Widget build(BuildContext context) {
    if (Grade4SciencePicture.supports(picture)) {
      return Grade4SciencePicture(picture: picture);
    }
    if (Grade5SciencePicture.supports(picture)) {
      return Grade5SciencePicture(picture: picture);
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: descriptionFor(picture),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (picture == 'butterfly' || picture == 'bean')
          _stages()
        else ...[
          AspectRatio(
              aspectRatio: 320 / 220,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(children: [
                  Positioned.fill(
                      child: CustomPaint(painter: _SciencePainter(picture))),
                  for (var index = 0;
                      index < _markers[picture]!.length;
                      index++)
                    Positioned(
                      left:
                          constraints.maxWidth * _markers[picture]![index].dx -
                              13,
                      top:
                          constraints.maxHeight * _markers[picture]![index].dy -
                              13,
                      child: ExcludeSemantics(
                          child: Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xfff8fafc),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xff23344f))),
                        child: Text('${index + 1}',
                            style: const TextStyle(
                                color: Color(0xff132238),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      )),
                    ),
                ]),
              )),
          const SizedBox(height: 10),
          for (final label in _labels[picture]!)
            Padding(
                padding: const EdgeInsets.only(bottom: 6), child: Text(label)),
        ],
        if (picture == 'butterfly')
          const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                  'Follow 1 → 2 → 3 → 4. Adults lay eggs to begin a new generation.')),
        if (picture == 'bean')
          const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                  'Follow 1 → 2 → 3 → 4. Seeds in the pods can grow into new plants.')),
        if (picture == 'shadow')
          const Text(
              'Yellow arrows show light travelling. The card stops the middle rays; rays above and below it reach the wall.'),
        if (picture == 'daynight')
          const Text(
              'Straight arrows show sunlight. The curved arrow shows Earth turning on its axis, not travelling around the Sun.'),
        if (picture == 'plant-parts')
          const Text(
              'Roots are shown through the soil so their branches can be seen. The pod is shown with visible seeds as a cutaway model.'),
        if (picture == 'forces')
          const Text(
              'Yellow arrows show forces on each block. Longer means stronger within this diagram. They do not show travel paths. Vertical forces are balanced and omitted.'),
      ]),
    );
  }

  Widget _stages() => LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth < 200 ? 1 : 2;
        final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
        return Wrap(spacing: 8, runSpacing: 10, children: [
          for (var index = 0; index < 4; index++)
            SizedBox(
                width: width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: 105,
                          child: CustomPaint(
                              painter: _SciencePainter(picture, stage: index))),
                      const SizedBox(height: 6),
                      Text(_labels[picture]![index],
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ])),
        ]);
      });
}

class _SciencePainter extends CustomPainter {
  const _SciencePainter(this.picture, {this.stage = 0});
  final String picture;
  final int stage;
  static const _green = Color(0xff5dbf76);
  static const _lightGreen = Color(0xffb1dc78);
  static const _brown = Color(0xffb68556);
  static const _yellow = Color(0xffffd76c);
  static const _blue = Color(0xff6cc5f2);
  static const _ink = Color(0xff1a293d);

  Paint _fill(Color color) => Paint()..color = color;
  Paint _stroke(Color color, [double width = 3]) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  void _line(Canvas canvas, Offset a, Offset b, Color color,
          [double width = 3]) =>
      canvas.drawLine(a, b, _stroke(color, width));
  void _oval(
          Canvas canvas, double x, double y, double w, double h, Color color) =>
      canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: w, height: h),
          _fill(color));
  void _leaf(Canvas canvas, double x, double y, double dx, double dy) {
    final path = Path()
      ..moveTo(x, y)
      ..quadraticBezierTo(
          x + dx * .12 - dy * .4, y + dy * .12 + dx * .4, x + dx, y + dy)
      ..quadraticBezierTo(x + dx * .65 + dy * .4, y + dy * .65 - dx * .4, x, y);
    canvas.drawPath(path, _fill(_green));
    _line(canvas, Offset(x, y), Offset(x + dx * .88, y + dy * .88),
        const Color(0xff277b4b), 2);
  }

  void _arrow(Canvas canvas, Offset from, Offset to, Color color,
      [double width = 3]) {
    _line(canvas, from, to, color, width);
    final angle = math.atan2(to.dy - from.dy, to.dx - from.dx);
    for (final turn in [-.55, .55]) {
      _line(
          canvas,
          to,
          to - Offset(math.cos(angle + turn), math.sin(angle + turn)) * 9,
          color,
          width);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / 220);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(0, 0, 320, 220), const Radius.circular(14)),
        _fill(const Color(0xff162943)));
    switch (picture) {
      case 'butterfly':
        _butterfly(canvas);
      case 'bean':
        _bean(canvas);
      case 'habitat':
        _habitat(canvas);
      case 'shadow':
        _shadow(canvas);
      case 'daynight':
        _daynight(canvas);
      case 'plant-parts':
        _plantParts(canvas);
      case 'forces':
        _forces(canvas);
    }
    canvas.restore();
  }

  void _butterfly(Canvas canvas) {
    switch (stage) {
      case 0:
        _leaf(canvas, 60, 166, 200, -68);
        for (final offset in const [
          Offset(124, 109),
          Offset(153, 101),
          Offset(179, 119),
          Offset(143, 135)
        ]) {
          _oval(canvas, offset.dx, offset.dy, 21, 27, const Color(0xfffff6d3));
          canvas.drawOval(
              Rect.fromCenter(center: offset, width: 21, height: 27),
              _stroke(_brown, 2));
        }
      case 1:
        _leaf(canvas, 45, 183, 232, -20);
        for (var i = 0; i < 7; i++) {
          final x = 72 + i * 26.0;
          final y = 123 - math.sin(i * .5) * 9;
          _line(canvas, Offset(x, y + 15), Offset(x - 7, y + 36), _brown, 4);
          canvas.drawCircle(
              Offset(x, y), 23, _fill(i.isEven ? _green : _lightGreen));
        }
        _oval(canvas, 244, 119, 48, 52, _lightGreen);
        canvas.drawCircle(const Offset(254, 109), 5, _fill(_ink));
        _line(canvas, const Offset(247, 95), const Offset(252, 77), _ink);
        _line(canvas, const Offset(235, 95), const Offset(235, 77), _ink);
      case 2:
        _line(canvas, const Offset(62, 45), const Offset(269, 52), _brown, 11);
        _leaf(canvas, 226, 49, 48, -30);
        _line(canvas, const Offset(163, 49), const Offset(163, 78),
            const Color(0xffe1d6b4));
        final chrysalis = Path()
          ..moveTo(162, 73)
          ..cubicTo(129, 100, 130, 154, 164, 185)
          ..cubicTo(193, 148, 200, 105, 162, 73);
        canvas.drawPath(chrysalis, _fill(const Color(0xffa0b65c)));
        canvas.drawPath(chrysalis, _stroke(_brown, 4));
        for (var i = 0; i < 4; i++) {
          _line(canvas, Offset(144, 108 + i * 15.0),
              Offset(180, 111 + i * 15.0), const Color(0xff6a7a39), 2);
        }
      case 3:
        _oval(canvas, 118, 83, 83, 96, const Color(0xfff4b85e));
        _oval(canvas, 204, 83, 83, 96, const Color(0xfff4b85e));
        _oval(canvas, 123, 148, 65, 69, const Color(0xffe39769));
        _oval(canvas, 200, 148, 65, 69, const Color(0xffe39769));
        for (final x in [116.0, 205.0]) {
          _oval(canvas, x, 81, 25, 32, const Color(0xff46659a));
          _oval(canvas, x + 5, 145, 16, 18, const Color(0xfff6dc89));
        }
        _oval(canvas, 161, 116, 20, 96, _brown);
        canvas.drawCircle(const Offset(161, 62), 13, _fill(_brown));
        _line(canvas, const Offset(155, 54), const Offset(139, 35), _yellow);
        _line(canvas, const Offset(167, 54), const Offset(184, 35), _yellow);
    }
  }

  void _seed(Canvas canvas, double x, double y, [double scale = 1]) {
    canvas.save();
    canvas.translate(x, y);
    canvas.scale(scale);
    final bean = Path()
      ..moveTo(5, -36)
      ..cubicTo(-52, -53, -62, 42, -9, 42)
      ..cubicTo(37, 45, 48, 16, 20, 5)
      ..cubicTo(-1, -4, 37, -28, 5, -36);
    canvas.drawPath(bean, _fill(const Color(0xffd0a172)));
    canvas.drawPath(bean, _stroke(_brown, 3));
    _oval(canvas, 5, 6, 10, 20, const Color(0xffffe0ab));
    canvas.restore();
  }

  void _roots(Canvas canvas, double fromY) {
    final root = Path()
      ..moveTo(158, fromY)
      ..quadraticBezierTo(156, fromY + 23, 163, 192);
    canvas.drawPath(root, _stroke(const Color(0xffe6c494), 4));
    _line(canvas, Offset(159, fromY + 18), const Offset(139, 183),
        const Color(0xffe6c494));
    _line(canvas, Offset(161, fromY + 27), const Offset(185, 186),
        const Color(0xffe6c494));
  }

  void _bean(Canvas canvas) {
    if (stage == 0) {
      _seed(canvas, 160, 112, 1.45);
      return;
    }
    canvas.drawRect(
        const Rect.fromLTWH(24, 151, 272, 49), _fill(const Color(0xff694e38)));
    _line(canvas, const Offset(24, 151), const Offset(296, 151),
        const Color(0xffb18b5c), 3);
    _roots(canvas, stage == 1 ? 127 : 153);
    if (stage == 1) {
      _seed(canvas, 159, 125, .72);
      return;
    }
    final top = stage == 2 ? 85.0 : 42.0;
    _line(canvas, const Offset(158, 153), Offset(160, top), _green, 7);
    _leaf(canvas, 160, 115, -58, -26);
    _leaf(canvas, 160, 110, 57, -30);
    _leaf(canvas, 160, top + 10, -31, -25);
    _leaf(canvas, 160, top + 10, 34, -30);
    if (stage == 2) {
      _seed(canvas, 147, 153, .32);
      return;
    }
    _leaf(canvas, 158, 76, -67, -34);
    _leaf(canvas, 161, 83, 58, -19);
    for (final pod in const [
      Offset(110, 94),
      Offset(214, 106),
      Offset(191, 67)
    ]) {
      canvas.drawOval(Rect.fromCenter(center: pod, width: 17, height: 57),
          _fill(_lightGreen));
      canvas.drawOval(Rect.fromCenter(center: pod, width: 17, height: 57),
          _stroke(_green, 2));
      for (var seed = 0; seed < 3; seed++) {
        canvas.drawCircle(pod + Offset(0, -15 + seed * 15.0), 5,
            _fill(const Color(0xff3a8c4b)));
      }
    }
  }

  void _bird(Canvas canvas, double x, double y) {
    _oval(canvas, x, y, 38, 23, const Color(0xffedb26f));
    canvas.drawCircle(
        Offset(x + 18, y - 9), 11, _fill(const Color(0xffedb26f)));
    canvas.drawCircle(Offset(x + 21, y - 12), 2, _fill(_ink));
    canvas.drawPath(
        Path()
          ..moveTo(x + 26, y - 10)
          ..lineTo(x + 37, y - 6)
          ..lineTo(x + 26, y - 3)
          ..close(),
        _fill(_yellow));
    canvas.drawPath(
        Path()
          ..moveTo(x - 1, y)
          ..quadraticBezierTo(x - 23, y - 38, x - 33, y - 20)
          ..lineTo(x - 12, y + 4),
        _fill(_brown));
    _line(canvas, Offset(x - 14, y + 1), Offset(x - 28, y + 11), _brown, 6);
  }

  void _habitat(Canvas canvas) {
    canvas.drawRect(
        const Rect.fromLTWH(0, 168, 320, 52), _fill(const Color(0xff315f43)));
    _oval(canvas, 245, 179, 104, 36, _blue);
    _line(canvas, const Offset(249, 173), const Offset(273, 173),
        const Color(0xffc9f0ff), 2);
    _line(canvas, const Offset(218, 184), const Offset(243, 184),
        const Color(0xffc9f0ff), 2);
    canvas.drawRect(const Rect.fromLTWH(257, 88, 15, 89), _fill(_brown));
    _line(canvas, const Offset(265, 97), const Offset(221, 79), _brown, 9);
    for (final canopy in const [
      Offset(240, 63),
      Offset(279, 72),
      Offset(258, 40)
    ]) {
      canvas.drawCircle(canopy, 38, _fill(_green));
    }
    final nest = Path()
      ..moveTo(218, 85)
      ..quadraticBezierTo(240, 119, 261, 84)
      ..close();
    canvas.drawPath(nest, _fill(const Color(0xffd7ac75)));
    for (var i = 0; i < 4; i++) {
      _line(canvas, Offset(224, 90 + i * 4.0), Offset(255, 88 + i * 4.0),
          _brown, 2);
    }
    _oval(canvas, 237, 83, 9, 12, const Color(0xfffff1cd));
    _oval(canvas, 249, 81, 9, 12, const Color(0xfffff1cd));
    for (final shrub in const [
      Offset(59, 155),
      Offset(82, 141),
      Offset(98, 161)
    ]) {
      canvas.drawCircle(shrub, 22, _fill(_green));
      canvas.drawCircle(
          shrub + const Offset(5, -4), 5, _fill(const Color(0xfff5848f)));
      canvas.drawCircle(
          shrub + const Offset(-7, 7), 5, _fill(const Color(0xfff5848f)));
    }
    _bird(canvas, 156, 91);
    _arrow(canvas, const Offset(105, 61), const Offset(123, 48),
        const Color(0xffc6e4ee), 2);
    _arrow(canvas, const Offset(194, 113), const Offset(207, 128),
        const Color(0xffc6e4ee), 2);
    _line(canvas, const Offset(45, 110), const Offset(68, 138),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(269, 195), const Offset(250, 183),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(269, 39), const Offset(245, 84),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(154, 28), const Offset(156, 59),
        const Color(0xffe5eef9), 2);
  }

  void _shadow(Canvas canvas) {
    // The wall is seen from the side. Unblocked rays hit lit areas, while the
    // central card stops rays and leaves the wall segment behind it unlit.
    const source = Offset(78, 112);
    const card = Rect.fromLTWH(155, 84, 8, 59);
    const wallX = 292.0;
    double projectedY(double cardY) =>
        source.dy +
        (cardY - source.dy) * (wallX - source.dx) / (card.left - source.dx);
    final shadowTop = projectedY(card.top);
    final shadowBottom = projectedY(card.bottom);
    final cone = Path()
      ..moveTo(source.dx, source.dy)
      ..lineTo(wallX, 20)
      ..lineTo(wallX, 210)
      ..close();
    canvas.drawPath(cone, _fill(_yellow.withValues(alpha: .12)));
    final blocked = Path()
      ..moveTo(card.left, card.top)
      ..lineTo(wallX, shadowTop)
      ..lineTo(wallX, shadowBottom)
      ..lineTo(card.left, card.bottom)
      ..close();
    canvas.drawPath(blocked, _fill(const Color(0xff172337)));
    canvas.drawRect(const Rect.fromLTWH(wallX, 20, 13, 190),
        _fill(const Color(0xffe5d7af)));
    canvas.drawRect(Rect.fromLTRB(wallX, shadowTop, wallX + 13, shadowBottom),
        _fill(const Color(0xff29303a)));
    _arrow(canvas, source, const Offset(wallX, 24), _yellow, 3);
    _arrow(canvas, source, const Offset(wallX, 205), _yellow, 3);
    for (final y in [90.0, 112.0, 135.0]) {
      _arrow(canvas, source, Offset(card.left, y), _yellow, 3);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(18, 98, 49, 28), const Radius.circular(6)),
        _fill(_blue));
    canvas.drawPath(
        Path()
          ..moveTo(61, 98)
          ..lineTo(78, 88)
          ..lineTo(78, 136)
          ..lineTo(61, 126)
          ..close(),
        _fill(const Color(0xffc8d7e1)));
    canvas.drawRect(card, _fill(const Color(0xffc98764)));
    _line(canvas, const Offset(159, 143), const Offset(159, 184), _brown, 5);
    _line(canvas, const Offset(140, 184), const Offset(177, 184), _brown, 5);
    _line(canvas, const Offset(33, 169), const Offset(40, 124),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(157, 42), const Offset(159, 84),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(271, 180), const Offset(296, 131),
        const Color(0xffe5eef9), 2);
  }

  void _daynight(Canvas canvas) {
    canvas.drawCircle(const Offset(37, 110), 25, _fill(_yellow));
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      _line(
          canvas,
          const Offset(37, 110) + Offset(math.cos(angle), math.sin(angle)) * 30,
          const Offset(37, 110) + Offset(math.cos(angle), math.sin(angle)) * 37,
          _yellow,
          3);
    }
    for (final y in [77.0, 110.0, 143.0]) {
      _arrow(canvas, Offset(81, y), Offset(158, y), _yellow, 3);
    }
    const globe = Rect.fromLTWH(160, 58, 106, 106);
    canvas.drawOval(globe, _fill(_blue));
    canvas.save();
    canvas.clipPath(Path()..addOval(globe));
    final land = Path()
      ..moveTo(182, 65)
      ..lineTo(197, 79)
      ..lineTo(187, 92)
      ..lineTo(193, 113)
      ..lineTo(178, 118)
      ..lineTo(169, 97)
      ..close();
    canvas.drawPath(land, _fill(_green));
    canvas.drawPath(
        Path()
          ..moveTo(227, 79)
          ..lineTo(253, 91)
          ..lineTo(248, 115)
          ..lineTo(234, 125)
          ..lineTo(221, 106)
          ..close(),
        _fill(_green));
    canvas.drawRect(const Rect.fromLTWH(213, 54, 58, 117),
        _fill(const Color(0xff10182c).withValues(alpha: .88)));
    canvas.restore();
    canvas.drawOval(globe, _stroke(const Color(0xffb8d8eb), 2));
    // A curved arrow hugging the globe means rotation, never orbital motion.
    const rotation = Rect.fromLTWH(182, 132, 62, 49);
    canvas.drawArc(rotation, .10, math.pi * .88, false,
        _stroke(const Color(0xffc1e4dc), 3));
    _arrow(canvas, const Offset(185, 163), const Offset(182, 151),
        const Color(0xffc1e4dc), 3);
    _line(canvas, const Offset(34, 42), const Offset(37, 80),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(179, 54), const Offset(184, 84),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(272, 54), const Offset(241, 87),
        const Color(0xffe5eef9), 2);
    _line(canvas, const Offset(211, 180), const Offset(212, 175),
        const Color(0xffe5eef9), 2);
  }

  void _plantParts(Canvas canvas) {
    // A soil cutaway makes the roots visible without suggesting that roots
    // usually sit on top of soil. Each callout joins a marker to a real part.
    canvas.drawRect(
        const Rect.fromLTWH(18, 153, 284, 55), _fill(const Color(0xff694e38)));
    _line(canvas, const Offset(18, 153), const Offset(302, 153),
        const Color(0xffb18b5c), 3);
    final root = Path()
      ..moveTo(160, 153)
      ..quadraticBezierTo(155, 175, 160, 202);
    canvas.drawPath(root, _stroke(const Color(0xffe6c494), 4));
    for (final branch in const [
      [Offset(158, 162), Offset(131, 185), Offset(112, 190)],
      [Offset(158, 170), Offset(184, 186), Offset(201, 198)],
      [Offset(159, 184), Offset(139, 200), Offset(130, 202)]
    ]) {
      _line(canvas, branch[0], branch[1], const Color(0xffe6c494), 3);
      _line(canvas, branch[1], branch[2], const Color(0xffe6c494), 2);
    }
    _line(canvas, const Offset(160, 153), const Offset(160, 42), _green, 7);
    _leaf(canvas, 160, 120, -61, -25);
    _leaf(canvas, 160, 95, 67, -26);
    _leaf(canvas, 160, 72, -42, -22);
    _line(canvas, const Offset(160, 109), const Offset(224, 104), _green, 4);
    canvas.drawOval(const Rect.fromLTWH(214, 103, 20, 44), _fill(_lightGreen));
    canvas.drawOval(const Rect.fromLTWH(214, 103, 20, 44), _stroke(_green, 2));
    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
          Offset(224, 113 + index * 12.0), 4, _fill(const Color(0xff277b4b)));
    }
    for (var petal = 0; petal < 5; petal++) {
      final angle = petal * math.pi * 2 / 5;
      canvas.drawCircle(
          const Offset(160, 35) + Offset(math.cos(angle), math.sin(angle)) * 10,
          9,
          _fill(const Color(0xffdfb6f0)));
    }
    canvas.drawCircle(const Offset(160, 35), 6, _fill(_yellow));
    const calloutColor = Color(0xffe5eef9);
    _line(
        canvas, const Offset(65, 189), const Offset(127, 184), calloutColor, 2);
    _line(canvas, const Offset(67, 58), const Offset(157, 85), calloutColor, 2);
    _line(
        canvas, const Offset(261, 42), const Offset(216, 76), calloutColor, 2);
    _line(
        canvas, const Offset(131, 22), const Offset(151, 32), calloutColor, 2);
    _line(canvas, const Offset(267, 145), const Offset(232, 129), calloutColor,
        2);
  }

  void _forces(Canvas canvas) {
    // Both rows use the same scale for force arrows. Top: 70 = 70.
    // Bottom: 90 right > 32 left. No arrow measures distance travelled.
    for (final y in [45.0, 140.0]) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(140, y, 40, 38), const Radius.circular(5)),
          _fill(_blue));
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(140, y, 40, 38), const Radius.circular(5)),
          _stroke(const Color(0xffc8eafa), 2));
      _line(canvas, Offset(57, y + 41), Offset(289, y + 41),
          const Color(0xff788b9f), 2);
    }
    _arrow(canvas, const Offset(140, 64), const Offset(70, 64), _yellow, 4);
    _arrow(canvas, const Offset(180, 64), const Offset(250, 64), _yellow, 4);
    _arrow(canvas, const Offset(140, 159), const Offset(108, 159), _yellow, 4);
    _arrow(canvas, const Offset(180, 159), const Offset(270, 159), _yellow, 4);
  }

  @override
  bool shouldRepaint(covariant _SciencePainter oldDelegate) =>
      picture != oldDelegate.picture || stage != oldDelegate.stage;
}
