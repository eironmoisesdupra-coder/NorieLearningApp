import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Original offline schematics. Teaching labels are scalable Flutter text.
class Grade6SciencePicture extends StatelessWidget {
  const Grade6SciencePicture({required this.picture, super.key});

  final String picture;

  static const descriptions = <String, String>{
    'g6-key':
        'A branching identification key only for pigeon, frog, ant and earthworm. Step 1 asks Backbone? Its yes branch leads to step 2, Feathers?: yes identifies pigeon and no identifies frog. Step 1 no leads separately to step 3, Six jointed legs?: yes identifies ant and no identifies earthworm. Steps 2 and 3 are alternatives, never a linear sequence.',
    'g6-circuit':
        'Two versions of one cell, switch and lamp loop. Wires connect the cell long and short terminal bars through a switch and a lamp, with no wire bypassing the lamp. In the closed version the switch joins its contacts and the lamp is lit. In the open version a raised switch leaves a visible gap, the lamp is unlit and sustained current stops throughout this simple loop.',
    'g6-branches':
        'Three circuit schematics. The series circuit has two lamps in one complete path. Two parallel schematics each have separate lamp A and lamp B branches between the same left and right junctions. In the first parallel case, a gap in branch A leaves lamp A off while lamp B has a complete source loop and stays lit. In the second, a gap in the common return wire breaks both source loops and both lamps are off. No branch bypasses a lamp.',
    'g6-plates':
        'Three distinct plate models. A divergent ocean-ridge cross-section has rigid plates moving apart over mostly solid slowly deforming mantle, with a small localized melt region rising between them. A convergent oceanic–continental cross-section has arrows toward the boundary; the oceanic lithosphere bends down at a trench and descends beneath the continental plate. The crust and rigid uppermost mantle together form each lithospheric plate. A transform plan view shows two plates moving in opposite directions parallel to their shared edge. The first two are side views, the third is a top view; thicknesses and distances are not to scale.',
    'g6-solar':
        'Eight nested numbered model orbits surround a central Sun marker. From the smallest to largest orbit the numbers identify Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus and Neptune. The main asteroid belt region is between Mars and Jupiter. All orbit gaps and body sizes are illustrative, not a distance or size scale. Planet-marker positions are chosen for readability and do not show a current configuration.',
  };

  static bool supports(String picture) => descriptions.containsKey(picture);

  static const _planetNames = [
    'Mercury',
    'Venus',
    'Earth',
    'Mars',
    'Jupiter',
    'Saturn',
    'Uranus',
    'Neptune',
  ];

  Widget _caption(String text) =>
      Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text));

  Widget _panel(String title, String model,
          {double height = 240, Map<int, Offset> markers = const {}}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _Model(model: model, designHeight: height, markers: markers),
          const SizedBox(height: 10),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 6 Science picture: $picture');
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: descriptions[picture],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (picture == 'g6-key') ...[
            const _IdentificationKey(),
            _caption(
                'Use only for pigeon, frog, ant and earthworm. Start at step 1; follow one branch, not both.'),
            _caption(
                'Backbone yes: use feathers to choose pigeon or frog. Backbone no: use six jointed legs to choose ant or earthworm.'),
          ],
          if (picture == 'g6-circuit') ...[
            _panel('Closed switch · complete loop', 'closed'),
            _caption(
                'The joined switch contacts complete a route through both cell terminals and the lamp. The lamp is on.'),
            _panel('Open switch · broken loop', 'open'),
            _caption(
                'The raised switch leaves a visible gap. The lamp is off; sustained current stops throughout this simple loop.'),
            _caption(
                'Two unequal bars at the bottom: cell terminals. Circle with a cross at the right: lamp. Contacts and lever at the top: switch.'),
            _caption(
                'A schematic explains connections; it is not an instruction to wire a cell directly across its terminals.'),
          ],
          if (picture == 'g6-branches') ...[
            _panel('Series · two lamps on one path', 'series'),
            _caption(
                'Trace one route through both lamps and the source. Opening any connection in this route would stop both lamps.'),
            _panel('Parallel · only branch A is open', 'parallel-branch',
                markers: const {1: Offset(.29, .13)}),
            _caption(
                '1 · Branch A has a gap. Lamp A is off; branch B still forms a complete loop through the source, so lamp B remains on.'),
            _panel('Parallel · common return wire is open', 'parallel-common',
                markers: const {2: Offset(.078, .67)}),
            _caption(
                '2 · The gap lies in the common wire below both branches. Neither branch completes a source loop, so both lamps are off.'),
            _caption(
                'Each parallel lamp lies between the same left and right junctions, shown by filled dots. There is no plain wire crossing between junctions to bypass the lamps.'),
            _caption(
                'Lamp color shows the predicted on/off state for a working source and suitable lamps. Brightness is not a measured comparison.'),
          ],
          if (picture == 'g6-plates') ...[
            _panel('Divergent · ocean-ridge cross-section', 'divergent',
                height: 220,
                markers: const {
                  1: Offset(.10, .35),
                  2: Offset(.11, .50),
                  3: Offset(.89, .84),
                  4: Offset(.50, .70)
                }),
            _caption(
                '1 · Thin upper crust. 2 · Rigid uppermost mantle below the crust. Together they form the lithospheric plate.'),
            _caption(
                '3 · Mostly solid mantle that deforms slowly. 4 · A small local melt region rises at the spreading center. Outward arrows show the plates separating.'),
            _panel(
                'Convergent · oceanic–continental cross-section', 'subduction',
                height: 240,
                markers: const {
                  1: Offset(.50, .40),
                  2: Offset(.68, .70),
                  3: Offset(.88, .31),
                  4: Offset(.87, .47),
                  5: Offset(.25, .84)
                }),
            _caption(
                '1 · Trench at the downward bend. 2 · Descending oceanic lithosphere. 3 · Continental crust. 4 · Rigid uppermost mantle of the overriding plate. 5 · Mostly solid deforming mantle beneath.'),
            _caption(
                'Arrows point toward the boundary; the lower arrow follows the descending slab. This is an oceanic–continental example, not a model of every convergent boundary.'),
            _panel('Transform · view from above', 'transform', height: 210),
            _caption(
                'The arrows run parallel to the shared edge, in opposite directions. The two plates slide past; the picture shows neither spreading nor a descending slab.'),
            _caption(
                'Layer thicknesses and landforms are exaggerated. Solid rock can deform over geological time; the mantle is not a global liquid-magma ocean.'),
          ],
          if (picture == 'g6-solar') ...[
            _panel('Numbered model orbits', 'solar', height: 320, markers: {
              for (var i = 0; i < 8; i++) i + 1: _solarPoint(i) / 320
            }),
            _caption(
                'Central yellow disk: the Sun. Numbers identify the eight planet orbits from inner to outer.'),
            for (var i = 0; i < _planetNames.length; i++)
              _caption('${i + 1} · ${_planetNames[i]}'),
            _caption(
                'The dotted band between orbit 4 (Mars) and orbit 5 (Jupiter) represents the main asteroid belt region. Asteroids also occur elsewhere.'),
            _caption(
                'Orbit order only: distances, planet sizes and orbit shapes are simplified. These chosen positions are not the planets’ current configuration.'),
          ],
        ],
      ),
    );
  }
}

class _Model extends StatelessWidget {
  const _Model(
      {required this.model,
      required this.designHeight,
      this.markers = const {}});
  final String model;
  final double designHeight;
  final Map<int, Offset> markers;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 320 / designHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: const Color(0xff101b36),
              borderRadius: BorderRadius.circular(10)),
          child: LayoutBuilder(
              builder: (context, constraints) => Stack(children: [
                    Positioned.fill(
                        child: CustomPaint(
                            painter: _Grade6Painter(model, designHeight))),
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
                    if (model.startsWith('parallel')) ...[
                      const Positioned(
                          left: 8,
                          top: 8,
                          child: Text('A',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                      Positioned(
                          left: 8,
                          top: constraints.maxHeight * .40,
                          child: const Text('B',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                    ],
                  ])),
        ),
      );
}

class _IdentificationKey extends StatelessWidget {
  const _IdentificationKey();

  Widget _card(String title, {String? result}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        decoration: BoxDecoration(
            color: const Color(0xffe1eef5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xff7ed8dd))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xff183848),
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          if (result != null)
            Text(result,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xff183848), fontSize: 12)),
        ]),
      );

  Widget _answer(String choice, String animal, {required bool last}) =>
      IntrinsicHeight(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              width: 20,
              child: CustomPaint(
                painter: _KeyConnectorPainter('leaf', last: last),
              )),
          Expanded(child: _card(choice, result: animal)),
        ],
      ));

  Widget _branch(String question, String yes, String no) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _card(question),
          const SizedBox(
              height: 20,
              child: CustomPaint(painter: _KeyConnectorPainter('stem'))),
          _answer('Yes', yes, last: false),
          const SizedBox(
              height: 12,
              child: CustomPaint(painter: _KeyConnectorPainter('spacer'))),
          _answer('No', no, last: true),
        ],
      );

  @override
  Widget build(BuildContext context) => Container(
        key: const ValueKey('science-g6-identification-key'),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xff101b36),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _card('1 · Backbone?'),
            const SizedBox(
                height: 56,
                child: CustomPaint(painter: _KeyConnectorPainter('split'))),
            const Row(children: [
              Expanded(
                  child: Text('Yes → 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12))),
              Expanded(
                  child: Text('No → 3',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ]),
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _branch('2 · Feathers?', 'Pigeon', 'Frog')),
              const SizedBox(width: 12),
              Expanded(
                  child: _branch('3 · Six jointed legs?', 'Ant', 'Earthworm')),
            ]),
          ],
        ),
      );
}

/// Connector dimensions follow the actual text-card heights rather than a
/// fixed drawing coordinate system, including when words wrap at large scale.
class _KeyConnectorPainter extends CustomPainter {
  const _KeyConnectorPainter(this.part, {this.last = false});
  final String part;
  final bool last;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff65e2f1)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    void line(Offset a, Offset b) => canvas.drawLine(a, b, paint);
    void arrow(Offset a, Offset b) {
      line(a, b);
      final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
      for (final delta in [-.55, .55]) {
        line(b,
            b - Offset(math.cos(angle + delta), math.sin(angle + delta)) * 7);
      }
    }

    switch (part) {
      case 'split':
        arrow(Offset(size.width * .5, 0),
            Offset(size.width * .25, size.height - 3));
        arrow(Offset(size.width * .5, 0),
            Offset(size.width * .75, size.height - 3));
        break;
      case 'stem':
        line(Offset(size.width * .5, 0), Offset(8, size.height));
        break;
      case 'spacer':
        line(const Offset(8, 0), Offset(8, size.height));
        break;
      case 'leaf':
        line(const Offset(8, 0),
            Offset(8, last ? size.height * .5 : size.height));
        arrow(Offset(8, size.height * .5),
            Offset(size.width - 2, size.height * .5));
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _KeyConnectorPainter oldDelegate) =>
      part != oldDelegate.part || last != oldDelegate.last;
}

Offset _solarPoint(int index) {
  const angles = [-50.0, 170.0, 90.0, 230.0, 10.0, 145.0, -95.0, 60.0];
  final radians = angles[index] * math.pi / 180;
  final radius = 30.0 + index * 17;
  return const Offset(160, 160) +
      Offset(math.cos(radians), math.sin(radians)) * radius;
}

class _Grade6Painter extends CustomPainter {
  const _Grade6Painter(this.model, this.designHeight);
  final String model;
  final double designHeight;
  static const _wireColor = Color(0xff65e2f1);
  static const _amber = Color(0xffffc35b);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / designHeight);
    switch (model) {
      case 'closed':
        _circuit(canvas, closed: true);
        break;
      case 'open':
        _circuit(canvas, closed: false);
        break;
      case 'series':
        _series(canvas);
        break;
      case 'parallel-branch':
        _parallel(canvas, branchOpen: true);
        break;
      case 'parallel-common':
        _parallel(canvas, branchOpen: false);
        break;
      case 'divergent':
        _divergent(canvas);
        break;
      case 'subduction':
        _subduction(canvas);
        break;
      case 'transform':
        _transform(canvas);
        break;
      case 'solar':
        _solar(canvas);
        break;
    }
    canvas.restore();
  }

  void _line(Canvas canvas, Offset a, Offset b,
          {Color color = _wireColor, double width = 3}) =>
      canvas.drawLine(
          a,
          b,
          Paint()
            ..color = color
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round);

  void _arrow(Canvas canvas, Offset a, Offset b,
      {double head = 10, Color color = _wireColor}) {
    final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
    for (final outline in [true, false]) {
      final stroke = outline ? 6.0 : 3.0;
      final ink = outline ? const Color(0xff101b36) : color;
      _line(canvas, a, b, color: ink, width: stroke);
      for (final delta in [-.55, .55]) {
        _line(canvas, b,
            b - Offset(math.cos(angle + delta), math.sin(angle + delta)) * head,
            color: ink, width: stroke);
      }
    }
  }

  void _cell(Canvas canvas, double x, double y) {
    _line(canvas, Offset(x, y - 17), Offset(x, y + 17),
        color: _amber, width: 4);
    _line(canvas, Offset(x + 20, y - 10), Offset(x + 20, y + 10),
        color: _amber, width: 4);
  }

  void _lamp(Canvas canvas, Offset center, {required bool lit}) {
    if (lit) {
      canvas.drawCircle(center, 26, Paint()..color = const Color(0x33ffc35b));
    }
    canvas.drawCircle(
        center,
        20,
        Paint()
          ..color = lit ? const Color(0xfff7c55f) : const Color(0xff64748b));
    canvas.drawCircle(
        center,
        20,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    _line(
        canvas, center + const Offset(-10, -10), center + const Offset(10, 10),
        color: const Color(0xff183848), width: 2);
    _line(
        canvas, center + const Offset(-10, 10), center + const Offset(10, -10),
        color: const Color(0xff183848), width: 2);
  }

  void _circuit(Canvas canvas, {required bool closed}) {
    _line(canvas, const Offset(45, 50), const Offset(115, 50));
    _line(canvas, const Offset(185, 50), const Offset(275, 50));
    _line(canvas, const Offset(45, 50), const Offset(45, 185));
    _line(canvas, const Offset(45, 185), const Offset(130, 185));
    _cell(canvas, 130, 185);
    _line(canvas, const Offset(150, 185), const Offset(275, 185));
    _line(canvas, const Offset(275, 50), const Offset(275, 95));
    _line(canvas, const Offset(275, 135), const Offset(275, 185));
    _lamp(canvas, const Offset(275, 115), lit: closed);
    for (final center in [const Offset(115, 50), const Offset(185, 50)]) {
      canvas.drawCircle(center, 4, Paint()..color = Colors.white);
    }
    _line(canvas, const Offset(115, 50),
        closed ? const Offset(185, 50) : const Offset(167, 19),
        color: _amber);
  }

  void _series(Canvas canvas) {
    _line(canvas, const Offset(45, 60), const Offset(100, 60));
    _lamp(canvas, const Offset(120, 60), lit: true);
    _line(canvas, const Offset(140, 60), const Offset(200, 60));
    _lamp(canvas, const Offset(220, 60), lit: true);
    _line(canvas, const Offset(240, 60), const Offset(280, 60));
    _line(canvas, const Offset(45, 60), const Offset(45, 190));
    _line(canvas, const Offset(280, 60), const Offset(280, 190));
    _line(canvas, const Offset(45, 190), const Offset(140, 190));
    _cell(canvas, 140, 190);
    _line(canvas, const Offset(160, 190), const Offset(280, 190));
  }

  void _parallel(Canvas canvas, {required bool branchOpen}) {
    _line(canvas, const Offset(50, 60), const Offset(80, 60));
    if (!branchOpen) _line(canvas, const Offset(80, 60), const Offset(105, 60));
    _line(canvas, const Offset(105, 60), const Offset(125, 60));
    _lamp(canvas, const Offset(145, 60), lit: false);
    _line(canvas, const Offset(165, 60), const Offset(270, 60));
    _line(canvas, const Offset(50, 125), const Offset(125, 125));
    _lamp(canvas, const Offset(145, 125), lit: branchOpen);
    _line(canvas, const Offset(165, 125), const Offset(270, 125));
    _line(canvas, const Offset(50, 60), const Offset(50, 150));
    if (branchOpen) _line(canvas, const Offset(50, 150), const Offset(50, 172));
    _line(canvas, const Offset(50, 172), const Offset(50, 190));
    _line(canvas, const Offset(270, 60), const Offset(270, 190));
    _line(canvas, const Offset(50, 190), const Offset(140, 190));
    _cell(canvas, 140, 190);
    _line(canvas, const Offset(160, 190), const Offset(270, 190));
    for (final junction in [
      const Offset(50, 60),
      const Offset(50, 125),
      const Offset(270, 60),
      const Offset(270, 125)
    ]) {
      canvas.drawCircle(junction, 5, Paint()..color = _amber);
    }
  }

  void _polygon(Canvas canvas, List<Offset> points, Color color) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, Paint()..color = color);
  }

  void _mantle(Canvas canvas, double height) {
    canvas.drawRect(Rect.fromLTWH(0, 0, 320, height),
        Paint()..color = const Color(0xffb9a58b));
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 8; col++) {
        canvas.drawOval(
            Rect.fromLTWH(14.0 + col * 40.0, 134.0 + row * 25.0, 15, 6),
            Paint()..color = const Color(0xff94816c));
      }
    }
  }

  void _divergent(Canvas canvas) {
    _mantle(canvas, 220);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 320, 82),
        Paint()..color = const Color(0xffbce4ec));
    _polygon(
        canvas,
        [
          const Offset(0, 72),
          const Offset(115, 72),
          const Offset(150, 58),
          const Offset(150, 124),
          const Offset(0, 124)
        ],
        const Color(0xff43608a));
    _polygon(
        canvas,
        [
          const Offset(170, 58),
          const Offset(205, 72),
          const Offset(320, 72),
          const Offset(320, 124),
          const Offset(170, 124)
        ],
        const Color(0xff43608a));
    _polygon(
        canvas,
        [
          const Offset(0, 72),
          const Offset(115, 72),
          const Offset(150, 58),
          const Offset(150, 68),
          const Offset(115, 82),
          const Offset(0, 82)
        ],
        const Color(0xffe8ce8e));
    _polygon(
        canvas,
        [
          const Offset(170, 58),
          const Offset(205, 72),
          const Offset(320, 72),
          const Offset(320, 82),
          const Offset(205, 82),
          const Offset(170, 68)
        ],
        const Color(0xffe8ce8e));
    _polygon(
        canvas,
        [
          const Offset(158, 62),
          const Offset(150, 150),
          const Offset(160, 172),
          const Offset(170, 150),
          const Offset(162, 62)
        ],
        const Color(0xffe69353));
    _arrow(canvas, const Offset(116, 102), const Offset(45, 102));
    _arrow(canvas, const Offset(204, 102), const Offset(275, 102));
    _arrow(canvas, const Offset(160, 164), const Offset(160, 94),
        color: _amber);
  }

  void _subduction(Canvas canvas) {
    _mantle(canvas, 240);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 320, 63),
        Paint()..color = const Color(0xffd9ebf0));
    _polygon(
        canvas,
        [
          const Offset(0, 48),
          const Offset(145, 48),
          const Offset(166, 92),
          const Offset(150, 88),
          const Offset(130, 80),
          const Offset(0, 80)
        ],
        const Color(0xff89c8dc));
    _polygon(
        canvas,
        [
          const Offset(0, 80),
          const Offset(130, 80),
          const Offset(150, 88),
          const Offset(235, 173),
          const Offset(268, 208),
          const Offset(240, 223),
          const Offset(207, 185),
          const Offset(137, 115),
          const Offset(125, 113),
          const Offset(0, 113)
        ],
        const Color(0xff43608a));
    _polygon(
        canvas,
        [
          const Offset(0, 80),
          const Offset(130, 80),
          const Offset(150, 88),
          const Offset(235, 173),
          const Offset(268, 208),
          const Offset(260, 216),
          const Offset(227, 181),
          const Offset(145, 96),
          const Offset(125, 90),
          const Offset(0, 88)
        ],
        const Color(0xffe8ce8e));
    _polygon(
        canvas,
        [
          const Offset(165, 92),
          const Offset(181, 65),
          const Offset(215, 65),
          const Offset(250, 35),
          const Offset(270, 65),
          const Offset(320, 65),
          const Offset(320, 125),
          const Offset(200, 125),
          const Offset(175, 108)
        ],
        const Color(0xff697392));
    _polygon(
        canvas,
        [
          const Offset(165, 92),
          const Offset(181, 65),
          const Offset(215, 65),
          const Offset(250, 35),
          const Offset(270, 65),
          const Offset(320, 65),
          const Offset(320, 83),
          const Offset(270, 83),
          const Offset(250, 55),
          const Offset(215, 83),
          const Offset(190, 83),
          const Offset(174, 104)
        ],
        const Color(0xffe8ce8e));
    _arrow(canvas, const Offset(55, 100), const Offset(120, 100));
    _arrow(canvas, const Offset(285, 105), const Offset(222, 105));
    _arrow(canvas, const Offset(180, 137), const Offset(229, 184));
  }

  void _transform(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(8, 22, 146, 168),
        Paint()..color = const Color(0xff426f83));
    canvas.drawRect(const Rect.fromLTWH(166, 22, 146, 168),
        Paint()..color = const Color(0xff66658f));
    for (var y = 26; y < 190; y += 18) {
      _line(canvas, Offset(160, y.toDouble()), Offset(160, y + 8.0),
          color: Colors.white, width: 2);
    }
    _arrow(canvas, const Offset(112, 163), const Offset(112, 55));
    _arrow(canvas, const Offset(208, 55), const Offset(208, 163));
  }

  void _solar(Canvas canvas) {
    for (var i = 0; i < 8; i++) {
      canvas.drawCircle(
          const Offset(160, 160),
          30.0 + i * 17.0,
          Paint()
            ..color = const Color(0xff8dbacb)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2);
    }
    for (var i = 0; i < 48; i++) {
      final angle = i * math.pi / 24;
      canvas.drawCircle(
          const Offset(160, 160) +
              Offset(math.cos(angle), math.sin(angle)) * 89.5,
          1.8,
          Paint()..color = const Color(0xffb5a88d));
    }
    canvas.drawCircle(const Offset(160, 160), 17, Paint()..color = _amber);
    for (var i = 0; i < 8; i++) {
      canvas.drawCircle(
          _solarPoint(i),
          8,
          Paint()
            ..color =
                i < 4 ? const Color(0xffe8b78d) : const Color(0xff99d0ee));
    }
  }

  @override
  bool shouldRepaint(covariant _Grade6Painter oldDelegate) =>
      model != oldDelegate.model || designHeight != oldDelegate.designHeight;
}
