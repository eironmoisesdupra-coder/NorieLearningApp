import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Original offline investigation, optical, particle and Earth-system models.
class Grade7SciencePicture extends StatelessWidget {
  const Grade7SciencePicture({required this.picture, super.key});

  final String picture;

  static const descriptions = <String, String>{
    'g7-investigation':
        'Two sequential trial models reuse the same cart on tracks with identical height, slope and marked timed route length, 0.60 m. Only the track surface changes between surface A and surface B. Mark 1 is the start and mark 2 is the finish of the timed route; mark 3 indicates the same ramp height. The investigation measures travel time between the same marks. The drawing gives no measured time or guaranteed result.',
    'g7-microscope':
        'An upright light-microscope side model separates optical and support parts. A lamp below the stage supplies light through the slide toward the objective and then the eyepiece above. Number 1 is the lamp, 2 the slide on the stage, 3 the objective, 4 the eyepiece, 5 the support arm, 6 the focus knob and 7 the base. Upward arrows indicate the illumination and viewing sequence without modeling detailed lens rays.',
    'g7-diffusion':
        'Two closed-container models each have six blue and six amber equal-size particles. In the first, a removable partition separates blue particles on the left from amber particles on the right. In a possible later arrangement after removal, both colors occur across the same container and the counts remain six of each. Example motion arrows point in different directions, not toward particles of the other color. Mixing does not transform one kind into the other.',
    'g7-motion':
        'A cumulative distance–time graph uses time in seconds on the horizontal axis and distance in meters on the vertical axis, with equal numeric intervals. Data points are 0 seconds 0 meters, 2 seconds 4 meters, 4 seconds 4 meters, and 6 seconds 8 meters. The first and last segments rise; the middle segment is horizontal because no distance is added. From 4 to 6 seconds the speed is 4 meters divided by 2 seconds, or 2 meters per second.',
    'g7-earth':
        'A connected Earth-system landscape includes atmosphere air and cloud, hydrosphere surface water, ice and underground pore water, biosphere plant, and geosphere rock and soil. Cyan arrows show evaporation upward, precipitation downward, runoff along the surface, infiltration into soil, soil water entering plant roots, and transpiration toward air. Condensation forms the cloud droplets. Separate amber arrows show sunlight entering and energy leaving toward space, without an energy-return cycle.',
  };

  static bool supports(String picture) => descriptions.containsKey(picture);

  Widget _text(String text) =>
      Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text));

  Widget _panel(String title, String model,
          {double height = 240, Map<int, Offset> markers = const {}}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _Drawing(model: model, height: height, markers: markers),
          const SizedBox(height: 10),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 7 Science picture: $picture');
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: descriptions[picture],
      child: Column(
        key: ValueKey('science-grade7-$picture'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (picture == 'g7-investigation') ...[
            _panel('Trial A · surface A', 'ramp-a',
                height: 220,
                markers: const {
                  1: Offset(.266, .43),
                  2: Offset(.766, .71),
                  3: Offset(.0625, .56)
                }),
            _panel('Trial B · surface B', 'ramp-b',
                height: 220,
                markers: const {
                  1: Offset(.266, .43),
                  2: Offset(.766, .71),
                  3: Offset(.0625, .56)
                }),
            _text(
                '1 · Start mark. 2 · Finish mark. The same 0.60 m route is timed in each trial.'),
            _text(
                '3 · Same height. Both ramps have the same slope, and the same cart is reused rather than comparing different carts.'),
            _text(
                'Changed variable: track surface. Measured variable: travel time from start to finish. Keep release method and timing method alike.'),
            _text(
                'The textures distinguish surfaces in this model. Geometry is not to scale; no actual travel times or guaranteed surface effect are shown.'),
          ],
          if (picture == 'g7-microscope') ...[
            _panel('Light microscope · side model', 'microscope',
                height: 300,
                markers: const {
                  1: Offset(.39, .77),
                  2: Offset(.39, .54),
                  3: Offset(.39, .43),
                  4: Offset(.39, .13),
                  5: Offset(.73, .57),
                  6: Offset(.66, .40),
                  7: Offset(.69, .86)
                }),
            _text('1 · Lamp supplies illumination from below.'),
            _text('2 · Slide holds the specimen on the stage.'),
            _text(
                '3 · Objective lens is near the specimen; 4 · Eyepiece is where the viewer looks.'),
            _text(
                'Light passes from below the slide toward the objective and eyepiece. Arrows describe the sequence, not a complete ray diagram.'),
            _text(
                '5 · Arm supports upper parts. 6 · Focus knob adjusts the relative position of stage or optical parts. 7 · Base supports the instrument.'),
            _text(
                'Optical parts help form and view an image; the arm and base support the instrument. Shapes and proportions are simplified.'),
          ],
          if (picture == 'g7-diffusion') ...[
            _panel(
                'Initially · partition separates the kinds', 'particles-before',
                height: 230),
            _text(
                'Six blue particles and six amber particles occupy the same closed container. The internal partition is removable.'),
            _panel('Later · one possible mixed arrangement', 'particles-after',
                height: 230),
            _text(
                'After the partition is removed, both kinds can spread across the container through random motion. Counts remain six blue and six amber.'),
            _text(
                'Example arrows show differing directions of motion, not attraction toward the other color. Individual particles do not need to follow a straight route from one side to the other.'),
            _text(
                'Colors distinguish particle kinds; radius, box size and time are model choices. Neither kind changes into the other. An instant need not have exactly equal counts on both sides.'),
          ],
          if (picture == 'g7-motion') ...[
            const _DistanceTimeGraph(),
            const SizedBox(height: 12),
            _text(
                'Plotted records: 0 s → 0 m; 2 s → 4 m; 4 s → 4 m; 6 s → 8 m.'),
            _text(
                'From 2 to 4 seconds, distance stays at 4 m: the object is at rest. A horizontal distance–time segment does not show constant nonzero speed.'),
            _text(
                'From 4 to 6 seconds, it adds 4 m in 2 s: speed = 4 ÷ 2 = 2 m/s. A rising straight segment shows a constant speed over that interval.'),
            _text(
                'Distance is cumulative and nonnegative. These supplied example records are not a position graph or a speed–time graph.'),
          ],
          if (picture == 'g7-earth') ...[
            _panel('Connected spheres · water routes and energy', 'earth',
                height: 300,
                markers: const {
                  1: Offset(.62, .20),
                  2: Offset(.20, .72),
                  3: Offset(.56, .50),
                  4: Offset(.88, .48),
                  5: Offset(.79, .91),
                  6: Offset(.90, .37),
                  7: Offset(.10, .10)
                }),
            _text(
                '1 · Atmosphere: air and cloud. Condensation forms cloud droplets; precipitation returns water toward the surface.'),
            _text(
                '2 · Hydrosphere: surface water, plus 5 · Groundwater in spaces and 6 · Ice. Water is not limited to visible lakes.'),
            _text(
                '3 · Biosphere: the plant takes in soil water and releases vapor through transpiration. 4 · Geosphere: rock and soil provide storage and pathways.'),
            _text(
                'Cyan water arrows: evaporation up from water; precipitation down; runoff along land; infiltration down; root uptake into the plant; transpiration toward air.'),
            _text(
                '7 · Sun supplies energy. Amber arrows show incoming sunlight and outgoing energy toward space. Energy transfers through the system rather than cycling back in a closed loop.'),
            _text(
                'Routes branch, stores overlap and processes happen together. This simplified landscape has no fixed schedule and is not a scale model.'),
          ],
        ],
      ),
    );
  }
}

class _Drawing extends StatelessWidget {
  const _Drawing(
      {required this.model, required this.height, this.markers = const {}});
  final String model;
  final double height;
  final Map<int, Offset> markers;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 320 / height,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: const Color(0xff101b36),
              borderRadius: BorderRadius.circular(10)),
          child: LayoutBuilder(
              builder: (context, constraints) => Stack(children: [
                    Positioned.fill(
                        child: CustomPaint(
                            painter: _Grade7Painter(model, height))),
                    for (final marker in markers.entries)
                      Positioned(
                        left: constraints.maxWidth * marker.value.dx - 10,
                        top: constraints.maxHeight * marker.value.dy - 10,
                        child: ExcludeSemantics(
                            child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xff163344),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: Text('${marker.key}',
                              textScaler: TextScaler.noScaling,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        )),
                      ),
                  ])),
        ),
      );
}

class _DistanceTimeGraph extends StatelessWidget {
  const _DistanceTimeGraph();

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey('science-g7-distance-time-graph'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Distance (m)',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
              height: 240,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                      width: 30,
                      child: Column(children: [
                        Expanded(child: Center(child: Text('8'))),
                        Expanded(child: Center(child: Text('6'))),
                        Expanded(child: Center(child: Text('4'))),
                        Expanded(child: Center(child: Text('2'))),
                        Expanded(child: Center(child: Text('0'))),
                      ])),
                  Expanded(
                      child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color(0xff101b36),
                        borderRadius: BorderRadius.circular(8)),
                    child: const CustomPaint(painter: _DistanceTimePainter()),
                  )),
                ],
              )),
          const Row(children: [
            SizedBox(width: 30),
            Expanded(child: Center(child: Text('0'))),
            Expanded(child: Center(child: Text('2'))),
            Expanded(child: Center(child: Text('4'))),
            Expanded(child: Center(child: Text('6'))),
          ]),
          const Text('Time (s)',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      );
}

class _DistanceTimePainter extends CustomPainter {
  const _DistanceTimePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset point(double time, double distance) => Offset(
        size.width * (.125 + time / 6 * .75),
        size.height * (.9 - distance / 8 * .8));
    final grid = Paint()
      ..color = const Color(0xff39546c)
      ..strokeWidth = 1;
    for (var distance = 0; distance <= 8; distance += 2) {
      canvas.drawLine(
          point(0, distance.toDouble()), point(6, distance.toDouble()), grid);
    }
    for (var time = 0; time <= 6; time += 2) {
      canvas.drawLine(
          point(time.toDouble(), 0), point(time.toDouble(), 8), grid);
    }
    final axes = Paint()
      ..color = const Color(0xff65e2f1)
      ..strokeWidth = 2;
    canvas.drawLine(
        point(0, 0), Offset(size.width * .96, size.height * .9), axes);
    canvas.drawLine(
        point(0, 0), Offset(size.width * .125, size.height * .04), axes);
    final path = Path()..moveTo(point(0, 0).dx, point(0, 0).dy);
    for (final pair in [
      const Offset(2, 4),
      const Offset(4, 4),
      const Offset(6, 8)
    ]) {
      final next = point(pair.dx, pair.dy);
      path.lineTo(next.dx, next.dy);
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xffffc35b)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    for (final pair in [
      Offset.zero,
      const Offset(2, 4),
      const Offset(4, 4),
      const Offset(6, 8)
    ]) {
      canvas.drawCircle(
          point(pair.dx, pair.dy), 4, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _DistanceTimePainter oldDelegate) => false;
}

class _Grade7Painter extends CustomPainter {
  const _Grade7Painter(this.model, this.designHeight);
  final String model;
  final double designHeight;
  static const _cyan = Color(0xff65e2f1);
  static const _amber = Color(0xffffc35b);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / designHeight);
    switch (model) {
      case 'ramp-a':
        _ramp(canvas, textured: false);
        break;
      case 'ramp-b':
        _ramp(canvas, textured: true);
        break;
      case 'microscope':
        _microscope(canvas);
        break;
      case 'particles-before':
        _particles(canvas, mixed: false);
        break;
      case 'particles-after':
        _particles(canvas, mixed: true);
        break;
      case 'earth':
        _earth(canvas);
        break;
    }
    canvas.restore();
  }

  void _line(Canvas canvas, Offset a, Offset b,
          {Color color = _cyan, double width = 3}) =>
      canvas.drawLine(
          a,
          b,
          Paint()
            ..color = color
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round);

  void _arrow(Canvas canvas, Offset a, Offset b,
      {Color color = _cyan, double head = 9}) {
    final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
    for (final outline in [true, false]) {
      final ink = outline ? const Color(0xff101b36) : color;
      final width = outline ? 6.0 : 3.0;
      _line(canvas, a, b, color: ink, width: width);
      for (final delta in [-.55, .55]) {
        _line(canvas, b,
            b - Offset(math.cos(angle + delta), math.sin(angle + delta)) * head,
            color: ink, width: width);
      }
    }
  }

  void _ramp(Canvas canvas, {required bool textured}) {
    _line(canvas, const Offset(10, 170), const Offset(307, 170),
        color: const Color(0xff879db0));
    _line(canvas, const Offset(35, 75), const Offset(35, 170),
        color: const Color(0xff879db0));
    _line(canvas, const Offset(35, 75), const Offset(280, 170), width: 8);
    if (textured) {
      for (var i = 0; i < 18; i++) {
        final x = 45.0 + i * 13;
        final y = 75 + (x - 35) * 95 / 245;
        _line(canvas, Offset(x - 2, y + 3), Offset(x + 2, y - 3),
            color: _amber, width: 2);
      }
    }
    for (final x in [85.0, 245.0]) {
      final y = 75 + (x - 35) * 95 / 245;
      _line(canvas, Offset(x - 4, y + 11), Offset(x + 4, y - 11),
          color: Colors.white, width: 3);
    }
    _arrow(canvas, const Offset(145, 100), const Offset(232, 134));
    _line(canvas, const Offset(20, 77), const Offset(20, 167),
        color: _amber, width: 2);
    _line(canvas, const Offset(14, 77), const Offset(26, 77),
        color: _amber, width: 2);
    _line(canvas, const Offset(14, 167), const Offset(26, 167),
        color: _amber, width: 2);
    canvas.save();
    canvas.translate(100, 75 + (100 - 35) * 95 / 245);
    canvas.rotate(math.atan2(95, 245));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-20, -27, 40, 18), const Radius.circular(4)),
        Paint()..color = const Color(0xffd9a98a));
    for (final x in [-12.0, 12.0]) {
      canvas.drawCircle(
          Offset(x, -7), 7, Paint()..color = const Color(0xffdce7ed));
      canvas.drawCircle(
          Offset(x, -7), 3, Paint()..color = const Color(0xff183848));
    }
    canvas.restore();
  }

  void _microscope(Canvas canvas) {
    final arm = Path()
      ..moveTo(143, 78)
      ..lineTo(204, 78)
      ..quadraticBezierTo(242, 83, 242, 117)
      ..lineTo(242, 251)
      ..lineTo(219, 251)
      ..lineTo(219, 119)
      ..quadraticBezierTo(219, 104, 200, 103)
      ..lineTo(143, 103)
      ..close();
    canvas.drawPath(arm, Paint()..color = const Color(0xff839bb2));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(75, 246, 205, 29), const Radius.circular(11)),
        Paint()..color = const Color(0xff839bb2));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(110, 41, 30, 70), const Radius.circular(6)),
        Paint()..color = const Color(0xff9dc7d6));
    canvas.drawRect(const Rect.fromLTWH(106, 27, 38, 21),
        Paint()..color = const Color(0xffdce7ed));
    canvas.drawRect(const Rect.fromLTWH(114, 110, 22, 33),
        Paint()..color = const Color(0xffdce7ed));
    _line(canvas, const Offset(114, 143), const Offset(136, 143),
        color: _cyan, width: 4);
    _line(canvas, const Offset(80, 171), const Offset(118, 171),
        color: const Color(0xffdce7ed), width: 8);
    _line(canvas, const Offset(132, 171), const Offset(226, 171),
        color: const Color(0xffdce7ed), width: 8);
    canvas.drawRect(
        const Rect.fromLTWH(97, 158, 62, 8), Paint()..color = _cyan);
    canvas.drawCircle(const Offset(125, 162), 4, Paint()..color = _amber);
    canvas.drawCircle(const Offset(125, 230), 15, Paint()..color = _amber);
    canvas.drawCircle(
        const Offset(212, 122), 17, Paint()..color = const Color(0xffdce7ed));
    canvas.drawCircle(
        const Offset(212, 122), 7, Paint()..color = const Color(0xff597085));
    final beam = Path()
      ..moveTo(125, 213)
      ..lineTo(112, 178)
      ..lineTo(138, 178)
      ..close();
    canvas.drawPath(beam, Paint()..color = const Color(0x55ffc35b));
    _arrow(canvas, const Offset(148, 217), const Offset(148, 185),
        color: _amber);
    _arrow(canvas, const Offset(153, 151), const Offset(153, 119),
        color: _amber);
    _arrow(canvas, const Offset(153, 94), const Offset(153, 56), color: _amber);
  }

  void _particles(Canvas canvas, {required bool mixed}) {
    canvas.drawRect(const Rect.fromLTWH(20, 30, 280, 170),
        Paint()..color = const Color(0xff18324b));
    canvas.drawRect(
        const Rect.fromLTWH(20, 30, 280, 170),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    final blue = mixed
        ? const [
            Offset(55, 60),
            Offset(140, 75),
            Offset(245, 55),
            Offset(90, 140),
            Offset(185, 125),
            Offset(260, 165)
          ]
        : const [
            Offset(55, 75),
            Offset(90, 75),
            Offset(125, 75),
            Offset(55, 130),
            Offset(90, 130),
            Offset(125, 130)
          ];
    final amber = mixed
        ? const [
            Offset(90, 80),
            Offset(205, 75),
            Offset(55, 170),
            Offset(140, 160),
            Offset(250, 115),
            Offset(180, 180)
          ]
        : const [
            Offset(195, 75),
            Offset(230, 75),
            Offset(265, 75),
            Offset(195, 130),
            Offset(230, 130),
            Offset(265, 130)
          ];
    if (!mixed) {
      _line(canvas, const Offset(160, 30), const Offset(160, 200),
          color: const Color(0xffdce7ed), width: 5);
    }
    for (final center in blue) {
      canvas.drawCircle(center, 7, Paint()..color = _cyan);
    }
    for (final center in amber) {
      canvas.drawCircle(center, 7, Paint()..color = _amber);
    }
    if (mixed) {
      _arrow(canvas, const Offset(60, 48), const Offset(83, 44), head: 6);
      _arrow(canvas, const Offset(140, 89), const Offset(122, 106), head: 6);
      _arrow(canvas, const Offset(247, 68), const Offset(266, 84), head: 6);
      _arrow(canvas, const Offset(44, 171), const Offset(32, 158), head: 6);
      _arrow(canvas, const Offset(129, 160), const Offset(108, 173), head: 6);
      _arrow(canvas, const Offset(250, 101), const Offset(233, 84), head: 6);
    } else {
      _arrow(canvas, const Offset(45, 76), const Offset(34, 95), head: 6);
      _arrow(canvas, const Offset(125, 116), const Offset(111, 99), head: 6);
      _arrow(canvas, const Offset(195, 141), const Offset(210, 160), head: 6);
      _arrow(canvas, const Offset(265, 63), const Offset(277, 47), head: 6);
    }
  }

  void _earth(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(0, 0, 320, 300),
        Paint()..color = const Color(0xffc9e4ee));
    final land = Path()
      ..moveTo(0, 215)
      ..lineTo(125, 215)
      ..lineTo(170, 185)
      ..lineTo(230, 165)
      ..lineTo(270, 160)
      ..lineTo(320, 170)
      ..lineTo(320, 300)
      ..lineTo(0, 300)
      ..close();
    canvas.drawPath(land, Paint()..color = const Color(0xffb7a082));
    final mountain = Path()
      ..moveTo(250, 165)
      ..lineTo(286, 105)
      ..lineTo(318, 165)
      ..close();
    canvas.drawPath(mountain, Paint()..color = const Color(0xff8c949d));
    final snow = Path()
      ..moveTo(267, 137)
      ..lineTo(286, 105)
      ..lineTo(304, 139)
      ..lineTo(294, 132)
      ..lineTo(282, 140)
      ..lineTo(273, 134)
      ..close();
    canvas.drawPath(snow, Paint()..color = Colors.white);
    canvas.drawOval(const Rect.fromLTWH(15, 199, 105, 27),
        Paint()..color = const Color(0xff559ac7));
    for (final center in [
      const Offset(164, 57),
      const Offset(191, 48),
      const Offset(221, 58)
    ]) {
      canvas.drawOval(Rect.fromCenter(center: center, width: 66, height: 32),
          Paint()..color = const Color(0xffa4b7c6));
    }
    canvas.drawCircle(const Offset(32, 30), 19, Paint()..color = _amber);
    _arrow(canvas, const Offset(53, 49), const Offset(118, 157), color: _amber);
    _arrow(canvas, const Offset(302, 161), const Offset(302, 45),
        color: _amber);
    _arrow(canvas, const Offset(60, 202), const Offset(60, 85));
    _arrow(canvas, const Offset(252, 81), const Offset(252, 156));
    _line(canvas, const Offset(254, 166), const Offset(170, 183));
    _arrow(canvas, const Offset(170, 183), const Offset(108, 214));
    _arrow(canvas, const Offset(245, 164), const Offset(245, 267));
    _line(canvas, const Offset(180, 195), const Offset(180, 129),
        color: const Color(0xff3c784b), width: 6);
    for (final center in [const Offset(165, 142), const Offset(195, 128)]) {
      canvas.drawOval(Rect.fromCenter(center: center, width: 39, height: 21),
          Paint()..color = const Color(0xff528d4e));
    }
    _line(canvas, const Offset(180, 195), const Offset(169, 244),
        color: const Color(0xff74583f));
    _line(canvas, const Offset(174, 222), const Offset(196, 254),
        color: const Color(0xff74583f), width: 2);
    _line(canvas, const Offset(176, 211), const Offset(150, 250),
        color: const Color(0xff74583f), width: 2);
    _arrow(canvas, const Offset(202, 271), const Offset(176, 211));
    _arrow(canvas, const Offset(194, 114), const Offset(194, 84));
    for (final center in [
      const Offset(230, 276),
      const Offset(253, 273),
      const Offset(270, 288),
      const Offset(221, 295)
    ]) {
      canvas.drawCircle(center, 5, Paint()..color = const Color(0xff559ac7));
    }
  }

  @override
  bool shouldRepaint(covariant _Grade7Painter oldDelegate) =>
      model != oldDelegate.model || designHeight != oldDelegate.designHeight;
}
