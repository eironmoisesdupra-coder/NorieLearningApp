import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Original offline diagrams. All labels remain scalable Flutter text.
class Grade4SciencePicture extends StatelessWidget {
  const Grade4SciencePicture({required this.picture, super.key});

  final String picture;

  static const descriptions = <String, String>{
    'g4-body':
        'Simplified front-facing human body. Brain inside the head; paired lungs in the chest; heart between the lungs and slightly on the person’s left, the viewer’s right; stomach and coiled intestines below the chest. Nerves coordinate responses, lungs exchange gases, the heart pumps blood and digestive organs prepare and absorb nutrients. Organs overlap in real bodies.',
    'g4-rock':
        'An enlarged granite model contains adjoining mineral grains. White grains represent quartz, tan grains represent feldspar, and dark grains represent mica. The whole joined piece is a rock, while its grains are mineral components. Patterns and colors distinguish components in this model; actual specimens vary.',
    'g4-moon':
        'Two viewpoints of Moon phases. In the space view sunlight comes from the left and illuminates the left half of each Moon sphere. Earth is central, with new Moon toward the Sun, a quarter Moon to the side, and full Moon away from the Sun. Separate Earth-view disks show new Moon dark, quarter Moon half lit, and full Moon fully lit. Moon sizes, distances and orbit shape are not to scale. The real orbit is tilted, so these positions do not imply monthly eclipses.',
  };

  static bool supports(String picture) => descriptions.containsKey(picture);

  static const _legends = <String, List<String>>{
    'g4-body': [
      '1 · Brain and nerves: coordinate responses',
      '2 · Lungs: exchange oxygen and carbon dioxide',
      '3 · Heart and vessels: pump and carry blood',
      '4 · Stomach and intestines: digest and absorb',
    ],
    'g4-rock': [
      '1 · White grains: quartz mineral',
      '2 · Tan grains: feldspar mineral',
      '3 · Dark grains: mica mineral',
      '4 · Joined grains: one granite rock',
    ],
  };

  static const _markers = <String, List<Offset>>{
    'g4-body': [
      Offset(.69, .12),
      Offset(.25, .34),
      Offset(.78, .42),
      Offset(.73, .67)
    ],
    'g4-rock': [
      Offset(.22, .28),
      Offset(.44, .30),
      Offset(.69, .64),
      Offset(.16, .82)
    ],
  };

  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 4 Science picture: $picture');
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: descriptions[picture],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (picture == 'g4-moon') ...[
            const Text('Space view · sunlight from the left',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const AspectRatio(
              aspectRatio: 320 / 180,
              child: CustomPaint(painter: _Grade4Painter('g4-moon')),
            ),
            const Text(
                'Earth is the central blue globe. The yellow circle is the Sun.'),
            const SizedBox(height: 12),
            const Text('Views from Earth',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (var phase = 0; phase < 3; phase++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 48,
                          height: 48,
                          child: CustomPaint(painter: _MoonDiskPainter(phase))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(const [
                        '1 · New Moon: little or none of the lit half visible',
                        '2 · Quarter Moon: half the visible disk lit',
                        '3 · Full Moon: the visible disk fully lit',
                      ][phase])),
                    ]),
              ),
            const Text(
                'Top: new Moon is left of Earth; quarter Moon above; full Moon right. The lit half always faces the Sun. This flat model does not show the orbit’s tilt.'),
          ] else ...[
            AspectRatio(
              aspectRatio: picture == 'g4-body' ? 320 / 330 : 320 / 220,
              child: LayoutBuilder(
                  builder: (context, constraints) => Stack(children: [
                        Positioned.fill(
                            child:
                                CustomPaint(painter: _Grade4Painter(picture))),
                        for (var i = 0; i < _markers[picture]!.length; i++)
                          Positioned(
                            left: constraints.maxWidth *
                                    _markers[picture]![i].dx -
                                12,
                            top: constraints.maxHeight *
                                    _markers[picture]![i].dy -
                                12,
                            child: ExcludeSemantics(
                                child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color(0xfff8fafc),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xff25344f))),
                              child: Text('${i + 1}',
                                  textScaler: TextScaler.noScaling,
                                  style: const TextStyle(
                                      color: Color(0xff25344f),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            )),
                          ),
                      ])),
            ),
            const SizedBox(height: 8),
            for (final label in _legends[picture]!)
              Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(label)),
          ],
        ],
      ),
    );
  }
}

class _Grade4Painter extends CustomPainter {
  const _Grade4Painter(this.picture);
  final String picture;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(
        size.width / 320,
        size.height /
            (picture == 'g4-body'
                ? 330
                : picture == 'g4-moon'
                    ? 180
                    : 220));
    switch (picture) {
      case 'g4-body':
        _body(canvas);
      case 'g4-rock':
        _rock(canvas);
      case 'g4-moon':
        _moon(canvas);
    }
    canvas.restore();
  }

  void _line(Canvas c, List<Offset> points, Color color, {double width = 3}) {
    final p = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      p.lineTo(point.dx, point.dy);
    }
    c.drawPath(
        p,
        Paint()
          ..color = color
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);
  }

  void _body(Canvas c) {
    const skin = Color(0xffe9d8c8), outline = Color(0xff6c6c79);
    final body = Path()
      ..moveTo(139, 66)
      ..lineTo(139, 79)
      ..quadraticBezierTo(111, 81, 100, 99)
      ..lineTo(78, 203)
      ..lineTo(94, 208)
      ..lineTo(116, 136)
      ..lineTo(118, 224)
      ..lineTo(112, 313)
      ..lineTo(139, 313)
      ..lineTo(156, 238)
      ..lineTo(164, 238)
      ..lineTo(181, 313)
      ..lineTo(208, 313)
      ..lineTo(202, 224)
      ..lineTo(204, 136)
      ..lineTo(226, 208)
      ..lineTo(242, 203)
      ..lineTo(220, 99)
      ..quadraticBezierTo(209, 81, 181, 79)
      ..lineTo(181, 66)
      ..close();
    c.drawPath(body, Paint()..color = skin);
    c.drawPath(
        body,
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    c.drawOval(const Rect.fromLTWH(128, 7, 64, 69), Paint()..color = skin);
    c.drawOval(
        const Rect.fromLTWH(128, 7, 64, 69),
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    c.drawOval(const Rect.fromLTWH(138, 15, 44, 28),
        Paint()..color = const Color(0xffa894d0));
    _line(c, const [Offset(146, 21), Offset(153, 28), Offset(146, 34)],
        const Color(0xff705894),
        width: 2);
    _line(c, const [Offset(166, 20), Offset(159, 28), Offset(170, 35)],
        const Color(0xff705894),
        width: 2);
    _line(c, const [Offset(160, 45), Offset(160, 226)], const Color(0xffa894d0),
        width: 2);
    _line(c, const [Offset(160, 94), Offset(108, 119), Offset(88, 196)],
        const Color(0xffa894d0),
        width: 2);
    _line(c, const [Offset(160, 94), Offset(212, 119), Offset(232, 196)],
        const Color(0xffa894d0),
        width: 2);
    final leftLung = Path()
      ..moveTo(150, 93)
      ..quadraticBezierTo(125, 95, 120, 126)
      ..quadraticBezierTo(110, 157, 148, 155)
      ..close();
    final rightLung = Path()
      ..moveTo(170, 93)
      ..quadraticBezierTo(195, 95, 200, 126)
      ..quadraticBezierTo(210, 157, 172, 155)
      ..quadraticBezierTo(180, 141, 170, 126)
      ..close();
    c.drawPath(leftLung, Paint()..color = const Color(0xff74b6c8));
    c.drawPath(rightLung, Paint()..color = const Color(0xff74b6c8));
    _line(c, const [Offset(160, 66), Offset(160, 109), Offset(138, 125)],
        const Color(0xff4e8799),
        width: 5);
    _line(
        c, const [Offset(160, 109), Offset(183, 125)], const Color(0xff4e8799),
        width: 5);
    final heart = Path()
      ..moveTo(166, 127)
      ..cubicTo(148, 109, 141, 133, 166, 157)
      ..cubicTo(195, 136, 191, 111, 166, 127)
      ..close();
    c.drawPath(heart, Paint()..color = const Color(0xffcf526d));
    _line(c, const [Offset(167, 149), Offset(177, 163), Offset(185, 229)],
        const Color(0xffcf526d),
        width: 3);
    _line(c, const [Offset(155, 148), Offset(142, 164), Offset(133, 228)],
        const Color(0xff4e8799),
        width: 3);
    _line(c, const [Offset(153, 62), Offset(153, 158), Offset(165, 165)],
        const Color(0xffc78a48),
        width: 3);
    final stomach = Path()
      ..moveTo(164, 160)
      ..cubicTo(177, 152, 193, 163, 185, 180)
      ..cubicTo(178, 195, 152, 189, 151, 180)
      ..quadraticBezierTo(163, 186, 164, 160)
      ..close();
    c.drawPath(stomach, Paint()..color = const Color(0xffe2a456));
    c.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(130, 193, 60, 35), const Radius.circular(9)),
        Paint()..color = const Color(0xffdd9977));
    _line(
        c,
        const [
          Offset(140, 200),
          Offset(178, 200),
          Offset(178, 208),
          Offset(140, 208),
          Offset(140, 216),
          Offset(178, 216)
        ],
        const Color(0xff925b42),
        width: 4);
    c.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(123, 191, 74, 44), const Radius.circular(9)),
        Paint()
          ..color = const Color(0xffb56a47)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6);
    _line(
        c, const [Offset(160, 235), Offset(160, 246)], const Color(0xffb56a47),
        width: 5);
    // Thin leader lines link numbered Flutter markers with the organ groups.
    _line(c, const [Offset(182, 27), Offset(211, 38)], outline, width: 1);
    _line(c, const [Offset(90, 112), Offset(125, 122)], outline, width: 1);
    _line(c, const [Offset(180, 137), Offset(237, 139)], outline, width: 1);
    _line(c, const [Offset(198, 215), Offset(221, 221)], outline, width: 1);
  }

  void _rock(Canvas c) {
    final edge = Path()
      ..moveTo(58, 37)
      ..lineTo(128, 16)
      ..lineTo(244, 42)
      ..lineTo(286, 112)
      ..lineTo(252, 180)
      ..lineTo(147, 205)
      ..lineTo(57, 171)
      ..lineTo(32, 101)
      ..close();
    c.save();
    c.clipPath(edge);
    c.drawRect(const Rect.fromLTWH(25, 10, 265, 200),
        Paint()..color = const Color(0xffe5be8b));
    final quartz = [
      const [
        Offset(33, 66),
        Offset(78, 39),
        Offset(117, 66),
        Offset(91, 115),
        Offset(45, 114)
      ],
      const [
        Offset(164, 37),
        Offset(219, 38),
        Offset(225, 87),
        Offset(178, 108),
        Offset(145, 72)
      ],
      const [
        Offset(95, 150),
        Offset(147, 113),
        Offset(191, 154),
        Offset(177, 208),
        Offset(110, 196)
      ],
      const [
        Offset(247, 72),
        Offset(284, 103),
        Offset(277, 145),
        Offset(237, 130)
      ],
    ];
    for (final points in quartz) {
      final p = Path()..addPolygon(points, true);
      c.drawPath(p, Paint()..color = const Color(0xfff2f1ed));
      c.drawPath(
          p,
          Paint()
            ..color = const Color(0xff87939b)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
    }
    for (final rect in [
      const Rect.fromLTWH(118, 48, 15, 42),
      const Rect.fromLTWH(208, 118, 22, 43),
      const Rect.fromLTWH(68, 129, 12, 31),
      const Rect.fromLTWH(238, 163, 22, 15)
    ]) {
      c.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()..color = const Color(0xff485263));
      _line(
          c,
          [
            Offset(rect.left + 4, rect.top + 3),
            Offset(rect.left + 4, rect.bottom - 3)
          ],
          const Color(0xffa6aeba),
          width: 1);
    }
    _line(c, const [Offset(116, 89), Offset(145, 110), Offset(178, 108)],
        const Color(0xffa4794e),
        width: 2);
    _line(c, const [Offset(95, 150), Offset(83, 120), Offset(119, 92)],
        const Color(0xffa4794e),
        width: 2);
    c.restore();
    c.drawPath(
        edge,
        Paint()
          ..color = const Color(0xff596578)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    _line(c, const [Offset(63, 180), Offset(76, 178)], const Color(0xff596578),
        width: 1.5);
  }

  void _arrow(Canvas c, Offset start, Offset end) {
    const color = Color(0xffdba733);
    _line(c, [start, end], color, width: 2);
    _line(
        c,
        [Offset(end.dx - 7, end.dy - 4), end, Offset(end.dx - 7, end.dy + 4)],
        color,
        width: 2);
  }

  void _moon(Canvas c) {
    c.drawCircle(
        const Offset(26, 99), 23, Paint()..color = const Color(0xfff1c54f));
    for (final y in [24.0, 65.0, 150.0]) {
      _arrow(c, Offset(3, y), Offset(303, y));
    }
    c.drawOval(
        const Rect.fromLTWH(91, 20, 189, 142),
        Paint()
          ..color = const Color(0xffadb8cd)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    c.drawCircle(
        const Offset(185, 99), 25, Paint()..color = const Color(0xff589dc9));
    c.drawOval(const Rect.fromLTWH(170, 85, 16, 22),
        Paint()..color = const Color(0xff69b099));
    c.drawOval(const Rect.fromLTWH(187, 104, 13, 10),
        Paint()..color = const Color(0xff69b099));
    for (final center in [
      const Offset(92, 99),
      const Offset(185, 21),
      const Offset(278, 99)
    ]) {
      c.drawCircle(center, 14, Paint()..color = const Color(0xff404960));
      c.drawArc(Rect.fromCircle(center: center, radius: 14), math.pi / 2,
          math.pi, true, Paint()..color = const Color(0xffedece3));
      c.drawCircle(
          center,
          14,
          Paint()
            ..color = const Color(0xff6c768c)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(_Grade4Painter oldDelegate) =>
      oldDelegate.picture != picture;
}

class _MoonDiskPainter extends CustomPainter {
  const _MoonDiskPainter(this.phase);
  final int phase;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) * .43;
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawCircle(center, r, Paint()..color = const Color(0xff404960));
    if (phase == 1) {
      canvas.drawArc(rect, math.pi / 2, math.pi, true,
          Paint()..color = const Color(0xffedece3));
    } else if (phase == 2) {
      canvas.drawCircle(center, r, Paint()..color = const Color(0xffedece3));
    }
    canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = const Color(0xff6c768c)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(_MoonDiskPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
