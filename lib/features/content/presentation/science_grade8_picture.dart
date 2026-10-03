import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Original offline probability, particle, mechanics, wave and radiation models.
class Grade8SciencePicture extends StatelessWidget {
  const Grade8SciencePicture({required this.picture, super.key});

  final String picture;

  static const descriptions = <String, String>{
    'g8-inheritance':
        'A Punnett grid for two Aa flower parents in a simplified single-gene complete-dominance model. Column gametes are A and a, and row gametes are A and a. The four equally likely combinations are AA, Aa, Aa and aa. AA and Aa have purple flowers; aa has white flowers. Genotype probabilities are one quarter AA, one half Aa, and one quarter aa. Each offspring is an independent outcome, not a guarantee of one white flower among four offspring.',
    'g8-reaction':
        'A particle model of 2H₂ plus O₂ producing 2H₂O. Before reaction there are two hydrogen pairs and one oxygen pair; afterward there are two water molecules, each with one oxygen bonded to two hydrogen atoms. Four hydrogen atoms and two oxygen atoms remain present. Small cyan circles represent hydrogen and larger amber circles oxygen, with each element retaining its color and radius in both panels. This is a schematic rather than an experiment or molecular scale drawing.',
    'g8-work':
        'One 1-kilogram load is lifted steadily upward through 1 meter. The outlined lower box marks its earlier position and the filled upper box its later position. Equal-length opposite cyan arrows on the load show an upward applied force of 10 newtons and downward weight of 10 newtons. The separate amber upward distance marker measures the vertical 1-meter rise. With the supplied gravity model 10 newtons per kilogram, lifting work is 10 joules and gravitational potential energy increases by 10 joules. Constant velocity means no kinetic-energy increase.',
    'g8-wave':
        'A spatial transverse-wave snapshot plots displacement from equilibrium in meters vertically against position along the medium in meters horizontally. Two crests occur at 0.5 and 2.5 meters and troughs at 1.5 and 3.5 meters. Amplitude is 0.5 meter from equilibrium to a crest; the crest-to-trough distance is 1 meter. Crest-to-crest wavelength is 2 meters. Frequency 3 hertz is supplied separately, not determined from this snapshot, giving wave speed 6 meters per second.',
    'g8-greenhouse':
        'A qualitative greenhouse-radiation diagram uses amber arrows for incoming shortwave sunlight and surface reflection, and coral arrows for thermal infrared radiation. Some sunlight is absorbed by the surface. The surface emits infrared radiation upward; a symbolic greenhouse-gas group absorbs some of it and emits infrared radiation upward and downward. A separate infrared arrow passes directly from surface toward space. The gas symbol is not a solid lid or mirror; infrared absorption and emission do not trap energy forever.',
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
      throw ArgumentError('Unknown Grade 8 Science picture: $picture');
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: descriptions[picture],
      child: Column(
        key: ValueKey('science-grade8-$picture'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (picture == 'g8-inheritance') ...[
            const _PunnettGrid(),
            const SizedBox(height: 12),
            _text(
                'Model: Aa × Aa. A gives purple flowers under complete dominance; aa gives white. This example concerns one simplified gene.'),
            _text(
                'Combine the column gamete with the row gamete in each cell. Both parents can supply A or a with equal probability.'),
            _text(
                'Genotype probabilities: AA = 1/4; Aa = 1/2; aa = 1/4. Purple probability = 3/4; white = 1/4.'),
            _text(
                'The four boxes are possible outcomes, not four actual offspring. Independent outcomes do not guarantee exactly one white flower in a set of four.'),
          ],
          if (picture == 'g8-reaction') ...[
            const Text('2H₂ + O₂ → 2H₂O',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _panel('Before · two H₂ molecules and one O₂', 'reactants',
                height: 180),
            _panel('After · two H₂O molecules', 'products', height: 180),
            _text(
                'Small cyan circles: hydrogen atoms. Larger amber circles: oxygen atoms. Lines show bonds in this model.'),
            _text(
                'Count on each side: 4 H atoms and 2 O atoms. Bonds change while the numbers of each kind of atom are conserved.'),
            _text(
                'Each water molecule has one O bonded to two H atoms. The coefficient 2 means two complete molecules; it does not change the formula H₂O.'),
            _text(
                'Same element, same model color and circle size in both panels. Sizes and bond angles are illustrative. This is not a real experiment or an instruction to combine gases.'),
          ],
          if (picture == 'g8-work') ...[
            _panel('Steady vertical lift · same 1 kg load', 'work',
                height: 320,
                markers: const {
                  1: Offset(.375, .24),
                  2: Offset(.375, .61),
                  3: Offset(.78, .62)
                }),
            _text(
                '1 · Upward applied force: 10 N. 2 · Downward weight: 10 N. Equal cyan arrow lengths show equal force magnitudes.'),
            _text(
                '3 · Vertical rise: 1 m. The amber marker measures upward travel. The lower outline is the same load at its earlier position.'),
            _text(
                'Supplied gravity model: g = 10 N/kg. Weight = 1 kg × 10 N/kg = 10 N.'),
            _text(
                'Work by the lifting force = 10 N × 1 m = 10 J. Gravitational potential energy increases by 10 J.'),
            _text(
                'The lift is steady: opposing forces balance, velocity stays constant and kinetic energy does not increase. Positive lifting work is not a claim of positive net work on the load.'),
          ],
          if (picture == 'g8-wave') ...[
            const _SpatialWave(),
            const SizedBox(height: 12),
            _text(
                'Cyan measurement arrows: 0.5 m amplitude from equilibrium to a crest, and 2 m wavelength between neighboring crests.'),
            _text(
                'Crest to trough spans 1 m, twice the amplitude. The dashed middle line is equilibrium, not the path followed by a traveling particle.'),
            _text(
                'Frequency is supplied separately: 3 Hz, or three cycles per second. A spatial snapshot does not by itself measure that frequency.'),
            _text(
                'Wave speed = frequency × wavelength = 3 Hz × 2 m = 6 m/s. Displacement, wavelength, frequency and speed are different quantities.'),
          ],
          if (picture == 'g8-greenhouse') ...[
            _panel('Radiation transfers · qualitative model', 'greenhouse',
                height: 300,
                markers: const {
                  1: Offset(.11, .10),
                  2: Offset(.36, .82),
                  3: Offset(.414, .367),
                  4: Offset(.59, .65),
                  5: Offset(.45, .48),
                  6: Offset(.70, .66),
                  7: Offset(.875, .27),
                  8: Offset(.68, .30)
                }),
            _text(
                'Amber shortwave arrows: 1 · Sunlight arrives; 2 · some is absorbed by the surface; 3 · some is reflected toward space.'),
            _text(
                'Coral infrared arrows: 4 · the surface emits IR; 5 · greenhouse gases absorb some IR and emit IR in different directions.'),
            _text(
                '6 · Downward atmospheric IR reaches the surface. 8 · Upward atmospheric IR goes toward space. 7 · Some surface IR escapes directly.'),
            _text(
                'The gas symbol marks an absorption/emission location, not a solid atmospheric lid. Absorption followed by emission differs from mirror reflection.'),
            _text(
                'Arrows show processes, not measured energy fractions. Energy can leave; it is not trapped forever. This mechanism is not caused by the ozone hole.'),
          ],
        ],
      ),
    );
  }
}

class _PunnettGrid extends StatelessWidget {
  const _PunnettGrid();

  Widget _cell(String allele, [String? phenotype]) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(allele,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white)),
          if (phenotype != null)
            Text(phenotype,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: phenotype == 'Purple'
                        ? const Color(0xffd2b4f4)
                        : Colors.white)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey('science-g8-punnett-grid'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Column gametes · first Aa parent',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const Text('Row gametes · second Aa parent'),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xff101b36)),
            child: Table(
              border:
                  TableBorder.all(color: const Color(0xff65e2f1), width: 1.5),
              columnWidths: const {0: FixedColumnWidth(42)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [_cell('×'), _cell('A'), _cell('a')]),
                TableRow(children: [
                  _cell('A'),
                  _cell('AA', 'Purple'),
                  _cell('Aa', 'Purple')
                ]),
                TableRow(children: [
                  _cell('a'),
                  _cell('Aa', 'Purple'),
                  _cell('aa', 'White')
                ]),
              ],
            ),
          ),
        ],
      );
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
                            painter: _Grade8Painter(model, height))),
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

class _SpatialWave extends StatelessWidget {
  const _SpatialWave();

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey('science-g8-spatial-wave'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Displacement from equilibrium (m)',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
              height: 240,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                      width: 64,
                      child: Column(children: [
                        Expanded(
                            child: Center(
                                child: Text('0.5',
                                    style: TextStyle(fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child:
                                    Text('0', style: TextStyle(fontSize: 12)))),
                        Expanded(
                            child: Center(
                                child: Text('−0.5',
                                    style: TextStyle(fontSize: 12)))),
                      ])),
                  Expanded(
                      child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color(0xff101b36),
                        borderRadius: BorderRadius.circular(8)),
                    child: const CustomPaint(painter: _WavePainter()),
                  )),
                ],
              )),
          const Row(children: [
            SizedBox(width: 64),
            Expanded(child: Center(child: Text('0'))),
            Expanded(child: Center(child: Text('1'))),
            Expanded(child: Center(child: Text('2'))),
            Expanded(child: Center(child: Text('3'))),
            Expanded(child: Center(child: Text('4'))),
          ]),
          const Text('Position along medium (m)',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      );
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset point(double position, double displacement) => Offset(
        size.width * (.1 + position / 4 * .8),
        size.height * (.5 - displacement / 1.5));
    final grid = Paint()
      ..color = const Color(0xff39546c)
      ..strokeWidth = 1;
    for (final displacement in [-.5, 0.0, .5]) {
      canvas.drawLine(point(0, displacement), point(4, displacement), grid);
    }
    for (var x = 0; x <= 4; x++) {
      canvas.drawLine(point(x.toDouble(), -.5), point(x.toDouble(), .5), grid);
    }
    final axis = Paint()
      ..color = const Color(0xff8dbacb)
      ..strokeWidth = 2;
    canvas.drawLine(point(0, -.5), point(0, .5), axis);
    for (var i = 0; i < 16; i++) {
      canvas.drawLine(point(i / 4, 0), point(i / 4 + .125, 0), axis);
    }
    final wave = Path();
    for (var i = 0; i <= 160; i++) {
      final x = i / 40;
      final p = point(x, .5 * math.sin(math.pi * x));
      if (i == 0) {
        wave.moveTo(p.dx, p.dy);
      } else {
        wave.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
        wave,
        Paint()
          ..color = const Color(0xffffc35b)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    void measure(Offset a, Offset b) {
      final paint = Paint()
        ..color = const Color(0xff65e2f1)
        ..strokeWidth = 2;
      canvas.drawLine(a, b, paint);
      final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
      for (final direction in [0.0, math.pi]) {
        final end = direction == 0 ? b : a;
        for (final delta in [-.55, .55]) {
          canvas.drawLine(
              end,
              end -
                  Offset(math.cos(angle + direction + delta),
                          math.sin(angle + direction + delta)) *
                      7,
              paint);
        }
      }
    }

    measure(point(.5, 0), point(.5, .5));
    final left = Offset(point(.5, .5).dx, size.height * .07);
    final right = Offset(point(2.5, .5).dx, size.height * .07);
    canvas.drawLine(left, point(.5, .5), axis);
    canvas.drawLine(right, point(2.5, .5), axis);
    measure(left, right);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => false;
}

class _Grade8Painter extends CustomPainter {
  const _Grade8Painter(this.model, this.designHeight);
  final String model;
  final double designHeight;
  static const _cyan = Color(0xff65e2f1);
  static const _amber = Color(0xffffc35b);
  static const _infrared = Color(0xffff9282);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 320, size.height / designHeight);
    switch (model) {
      case 'reactants':
        _reaction(canvas, products: false);
        break;
      case 'products':
        _reaction(canvas, products: true);
        break;
      case 'work':
        _work(canvas);
        break;
      case 'greenhouse':
        _greenhouse(canvas);
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
      {Color color = _cyan, double head = 10}) {
    final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
    _line(canvas, a, b, color: color);
    for (final delta in [-.55, .55]) {
      _line(canvas, b,
          b - Offset(math.cos(angle + delta), math.sin(angle + delta)) * head,
          color: color);
    }
  }

  void _reaction(Canvas canvas, {required bool products}) {
    const hydrogensBefore = [
      Offset(50, 70),
      Offset(80, 70),
      Offset(50, 130),
      Offset(80, 130)
    ];
    const oxygensBefore = [Offset(218, 100), Offset(253, 100)];
    const hydrogensAfter = [
      Offset(54, 78),
      Offset(110, 78),
      Offset(206, 78),
      Offset(262, 78)
    ];
    const oxygensAfter = [Offset(82, 105), Offset(234, 105)];
    if (products) {
      _line(canvas, oxygensAfter[0], hydrogensAfter[0],
          color: Colors.white, width: 2);
      _line(canvas, oxygensAfter[0], hydrogensAfter[1],
          color: Colors.white, width: 2);
      _line(canvas, oxygensAfter[1], hydrogensAfter[2],
          color: Colors.white, width: 2);
      _line(canvas, oxygensAfter[1], hydrogensAfter[3],
          color: Colors.white, width: 2);
    } else {
      _line(canvas, hydrogensBefore[0], hydrogensBefore[1],
          color: Colors.white, width: 2);
      _line(canvas, hydrogensBefore[2], hydrogensBefore[3],
          color: Colors.white, width: 2);
      _line(canvas, oxygensBefore[0], oxygensBefore[1],
          color: Colors.white, width: 2);
    }
    for (final atom in products ? hydrogensAfter : hydrogensBefore) {
      canvas.drawCircle(atom, 11, Paint()..color = _cyan);
    }
    for (final atom in products ? oxygensAfter : oxygensBefore) {
      canvas.drawCircle(atom, 16, Paint()..color = _amber);
    }
  }

  void _work(Canvas canvas) {
    final outline = Paint()
      ..color = const Color(0xff809bad)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(80, 235, 80, 55), const Radius.circular(5)),
        outline);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(80, 110, 80, 55), const Radius.circular(5)),
        Paint()..color = const Color(0xffc49b81));
    _arrow(canvas, const Offset(120, 137), const Offset(120, 62));
    _arrow(canvas, const Offset(120, 137), const Offset(120, 212));
    _line(canvas, const Offset(166, 137), const Offset(257, 137),
        color: const Color(0xff597085), width: 1);
    _line(canvas, const Offset(166, 262), const Offset(257, 262),
        color: const Color(0xff597085), width: 1);
    _arrow(canvas, const Offset(250, 262), const Offset(250, 137),
        color: _amber);
    _line(canvas, const Offset(242, 137), const Offset(258, 137),
        color: _amber, width: 2);
    _line(canvas, const Offset(242, 262), const Offset(258, 262),
        color: _amber, width: 2);
  }

  void _greenhouse(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(0, 222, 320, 78),
        Paint()..color = const Color(0xff446d56));
    _line(canvas, const Offset(0, 222), const Offset(320, 222),
        color: const Color(0xff91b794), width: 2);
    canvas.drawCircle(const Offset(35, 30), 20, Paint()..color = _amber);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      _line(
          canvas,
          const Offset(35, 30) + Offset(math.cos(angle), math.sin(angle)) * 24,
          const Offset(35, 30) + Offset(math.cos(angle), math.sin(angle)) * 30,
          color: _amber,
          width: 2);
    }
    _arrow(canvas, const Offset(55, 55), const Offset(115, 245), color: _amber);
    _arrow(canvas, const Offset(108, 222), const Offset(145, 45),
        color: _amber);
    _arrow(canvas, const Offset(190, 221), const Offset(190, 162),
        color: _infrared);
    _line(canvas, const Offset(144, 144), const Offset(173, 145),
        color: const Color(0xffd7e9f2), width: 1.5);
    canvas.drawCircle(
        const Offset(190, 145), 17, Paint()..color = const Color(0xffb8a9d3));
    for (final offset in [
      const Offset(-6, -3),
      const Offset(6, -3),
      const Offset(0, 6)
    ]) {
      canvas.drawCircle(const Offset(190, 145) + offset, 4,
          Paint()..color = const Color(0xff594c7a));
    }
    _arrow(canvas, const Offset(199, 127), const Offset(235, 48),
        color: _infrared);
    _arrow(canvas, const Offset(200, 164), const Offset(239, 221),
        color: _infrared);
    _arrow(canvas, const Offset(280, 221), const Offset(280, 40),
        color: _infrared);
    for (final point in [
      const Offset(66, 142),
      const Offset(91, 182),
      const Offset(260, 137),
      const Offset(171, 72)
    ]) {
      canvas.drawCircle(point, 3, Paint()..color = const Color(0xff8496b7));
    }
  }

  @override
  bool shouldRepaint(covariant _Grade8Painter oldDelegate) =>
      model != oldDelegate.model || designHeight != oldDelegate.designHeight;
}
