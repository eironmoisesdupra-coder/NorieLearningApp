import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Original offline models; all names and explanations use scalable text.
class Grade5SciencePicture extends StatelessWidget {
  const Grade5SciencePicture({required this.picture, super.key});

  final String picture;

  static const descriptions = <String, String>{
    'g5-cells':
        'Two enlarged cell models. Both contain a membrane, cytoplasm, nucleus and mitochondria. The animal-cell membrane surrounds an oval cell. The photosynthetic plant cell also has a firm outer wall, separate inner membrane, green chloroplasts and large central vacuole. Many nonphotosynthetic plant cells lack chloroplasts. Model colors and proportions are explanatory, not actual scale.',
    'g5-food-web':
        'A branched meadow food web. Grass feeds rabbit and grasshopper. Grasshopper feeds frog. Rabbit and frog feed hawk. Each arrow points from food toward the eater receiving its energy. Thus two chains share grass and hawk, with no energy arrow returning to grass. Other possible foods and decomposer links are not shown.',
    'g5-lever':
        'A horizontal lever has a load on its left end, a fulcrum near the load and a downward effort on its right end. The short load arm is left of the pivot and the longer effort arm is right of it. Downward effort on the long arm lifts the load on the short arm. The effort end travels farther; this lever does not create energy.',
    'g5-water-paths':
        'A landscape model has a water store at the left, a cloud above, rain over land at the right and a plant above underground soil. An upward arrow leads from surface water toward air. Rain falls onto land, then branches toward surface runoff into the water store and infiltration into soil. Water can also enter the plant from soil and leave toward air by transpiration. Clouds form by condensation. The routes are possibilities without a fixed schedule.',
  };

  static bool supports(String picture) => descriptions.containsKey(picture);

  static const _legends = <String, List<String>>{
    'g5-cells': [
      '1 · Membrane: controls entry and exit',
      '2 · Nucleus: holds most genetic instructions',
      '3 · Cytoplasm: interior material outside the nucleus',
      '4 · Cell wall: plant support outside its membrane',
      '5 · Mitochondria: help release usable food energy',
      '6 · Chloroplasts: capture light for photosynthesis',
      '7 · Central vacuole: stores fluid and supports firmness',
    ],
    'g5-lever': [
      '1 · Load: object lifted at the left',
      '2 · Fulcrum: pivot nearer the load',
      '3 · Effort: downward push at the right',
      '4 · Short load arm: smaller load travel',
      '5 · Long effort arm: farther effort travel',
    ],
    'g5-water-paths': [
      '1 · Evaporation: liquid water → vapor',
      '2 · Condensation: vapor → cloud droplets',
      '3 · Precipitation: water falls to the land',
      '4 · Runoff: water moves along the surface',
      '5 · Infiltration: water enters ground spaces',
      '6 · Root uptake: soil water enters the plant',
      '7 · Transpiration: plant water leaves as vapor',
    ],
  };

  static const _markers = <String, Map<int, Offset>>{
    'animal': {
      1: Offset(.89, .5),
      2: Offset(.38, .39),
      3: Offset(.54, .66),
      5: Offset(.68, .38),
    },
    'plant': {
      1: Offset(.90, .5),
      2: Offset(.25, .36),
      3: Offset(.31, .54),
      4: Offset(.078, .23),
      5: Offset(.23, .72),
      6: Offset(.77, .19),
      7: Offset(.63, .57),
    },
    'g5-lever': {
      1: Offset(.20, .40),
      2: Offset(.33, .70),
      3: Offset(.86, .25),
      4: Offset(.23, .60),
      5: Offset(.60, .60),
    },
    'g5-water-paths': {
      1: Offset(.12, .36),
      2: Offset(.40, .18),
      3: Offset(.79, .42),
      4: Offset(.39, .63),
      5: Offset(.872, .86),
      6: Offset(.59, .82),
      7: Offset(.57, .38),
    },
  };

  Widget _model(String model) => AspectRatio(
        aspectRatio: 320 / (model == 'g5-water-paths' ? 250 : 220),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(children: [
            Positioned.fill(child: CustomPaint(painter: _Grade5Painter(model))),
            for (final entry in _markers[model]!.entries)
              Positioned(
                left: constraints.maxWidth * entry.value.dx - 10,
                top: constraints.maxHeight * entry.value.dy - 10,
                child: ExcludeSemantics(
                    child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff173b48),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text('${entry.key}',
                      textScaler: TextScaler.noScaling,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                )),
              ),
          ]);
        }),
      );

  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 5 Science picture: $picture');
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: descriptions[picture],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (picture == 'g5-cells') ...[
            const Text('Animal-cell model',
                style: TextStyle(fontWeight: FontWeight.w700)),
            _model('animal'),
            const SizedBox(height: 8),
            const Text('Photosynthetic plant-cell model',
                style: TextStyle(fontWeight: FontWeight.w700)),
            _model('plant'),
          ] else if (picture == 'g5-food-web') ...[
            const _FoodWeb(),
            const Text('Each arrow means food energy passes to the eater.'),
            const SizedBox(height: 8),
            const Text('Route 1: grass → rabbit → hawk'),
            const Text('Route 2: grass → grasshopper → frog → hawk'),
          ] else
            _model(picture),
          for (final label in _legends[picture] ?? const <String>[])
            Padding(
                padding: const EdgeInsets.only(bottom: 7), child: Text(label)),
          if (picture == 'g5-cells')
            const Text(
                'Both models contain mitochondria. Many root cells have no chloroplasts. Colors and sizes are simplified.'),
          if (picture == 'g5-lever')
            const Text(
                'Downward effort lifts the load. Less force comes with farther effort travel in this arrangement.'),
          if (picture == 'g5-water-paths')
            const Text(
                'Surface runoff, infiltration and the plant route branch. Stores and travel times vary; this is not a fixed timetable.'),
        ],
      ),
    );
  }
}

class _FoodWeb extends StatelessWidget {
  const _FoodWeb();

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 320 / 440,
        child: LayoutBuilder(builder: (context, constraints) {
          const nodes = <String, Offset>{
            'Grass': Offset(.5, .09),
            'Rabbit': Offset(.23, .35),
            'Grasshopper': Offset(.76, .35),
            'Frog': Offset(.76, .61),
            'Hawk': Offset(.5, .88),
          };
          return Stack(children: [
            const Positioned.fill(
                child: CustomPaint(painter: _Grade5Painter('web'))),
            for (final node in nodes.entries)
              Positioned(
                left: constraints.maxWidth * (node.value.dx - .22),
                top: constraints.maxHeight * node.value.dy - 21,
                width: constraints.maxWidth * .44,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  decoration: BoxDecoration(
                    color: node.key == 'Grass'
                        ? const Color(0xffd9edd4)
                        : const Color(0xffe1eef5),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xff355669)),
                  ),
                  child: Text(node.key,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff173b48),
                          fontWeight: FontWeight.w700)),
                ),
              ),
          ]);
        }),
      );
}

class _Grade5Painter extends CustomPainter {
  const _Grade5Painter(this.model);
  final String model;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(
        size.width / 320,
        size.height /
            (model == 'web'
                ? 440
                : model == 'g5-water-paths'
                    ? 250
                    : 220));
    switch (model) {
      case 'animal':
        _cell(canvas, plant: false);
        break;
      case 'plant':
        _cell(canvas, plant: true);
        break;
      case 'web':
        _web(canvas);
        break;
      case 'g5-lever':
        _lever(canvas);
        break;
      case 'g5-water-paths':
        _water(canvas);
        break;
    }
    canvas.restore();
  }

  void _cell(Canvas canvas, {required bool plant}) {
    if (plant) {
      final wall = RRect.fromRectAndRadius(
          const Rect.fromLTWH(25, 20, 270, 180), const Radius.circular(20));
      canvas.drawRRect(wall, Paint()..color = const Color(0xffbcd98c));
      canvas.drawRRect(
          wall,
          Paint()
            ..color = const Color(0xff557133)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4);
      final membrane = RRect.fromRectAndRadius(
          const Rect.fromLTWH(33, 28, 254, 164), const Radius.circular(15));
      canvas.drawRRect(membrane, Paint()..color = const Color(0xfff4f1c9));
      canvas.drawRRect(
          membrane,
          Paint()
            ..color = const Color(0xff237d80)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
      canvas.drawRRect(
          RRect.fromRectAndRadius(const Rect.fromLTWH(130, 58, 135, 113),
              const Radius.circular(18)),
          Paint()..color = const Color(0xffaacde8));
      canvas.drawCircle(
          const Offset(80, 80), 26, Paint()..color = const Color(0xffad91c9));
      _mitochondrion(canvas, const Offset(73, 158));
      _mitochondrion(canvas, const Offset(108, 42));
      for (final center in [const Offset(246, 41), const Offset(66, 181)]) {
        canvas.drawOval(Rect.fromCenter(center: center, width: 36, height: 16),
            Paint()..color = const Color(0xff499b47));
        for (var i = -1; i <= 1; i++) {
          canvas.drawLine(
              center + Offset(i * 8, -5),
              center + Offset(i * 8, 5),
              Paint()
                ..color = const Color(0xffd6eb9c)
                ..strokeWidth = 2);
        }
      }
    } else {
      final outline = const Rect.fromLTWH(30, 25, 255, 170);
      canvas.drawOval(outline, Paint()..color = const Color(0xfff2ddce));
      canvas.drawOval(
          outline,
          Paint()
            ..color = const Color(0xff237d80)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
      canvas.drawCircle(
          const Offset(122, 86), 31, Paint()..color = const Color(0xffad91c9));
      _mitochondrion(canvas, const Offset(218, 83));
      _mitochondrion(canvas, const Offset(85, 146));
      _mitochondrion(canvas, const Offset(213, 154));
    }
  }

  void _mitochondrion(Canvas canvas, Offset center) {
    canvas.drawOval(Rect.fromCenter(center: center, width: 39, height: 19),
        Paint()..color = const Color(0xffd68856));
    final folds = Path()..moveTo(center.dx - 13, center.dy);
    for (var i = 0; i < 6; i++) {
      folds.lineTo(center.dx - 10 + i * 4, center.dy + (i.isEven ? -4 : 4));
    }
    canvas.drawPath(
        folds,
        Paint()
          ..color = const Color(0xff813b27)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  void _web(Canvas canvas) {
    _arrow(canvas, const Offset(145, 64), const Offset(79, 122));
    _arrow(canvas, const Offset(177, 64), const Offset(235, 122));
    _arrow(canvas, const Offset(243, 175), const Offset(243, 245));
    _arrow(canvas, const Offset(80, 175), const Offset(149, 360));
    _arrow(canvas, const Offset(240, 290), const Offset(176, 360));
  }

  void _lever(Canvas canvas) {
    canvas.drawLine(
        const Offset(28, 178),
        const Offset(303, 178),
        Paint()
          ..color = const Color(0xffa9b2bb)
          ..strokeWidth = 2);
    final pivot = Path()
      ..moveTo(105, 116)
      ..lineTo(82, 174)
      ..lineTo(128, 174)
      ..close();
    canvas.drawPath(pivot, Paint()..color = const Color(0xff9fa8b1));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(35, 106, 260, 12), const Radius.circular(4)),
        Paint()..color = const Color(0xffad7549));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(48, 65, 40, 40), const Radius.circular(5)),
        Paint()..color = const Color(0xff79ae83));
    _arrow(canvas, const Offset(275, 22), const Offset(275, 94));
    _arrow(canvas, const Offset(44, 170), const Offset(44, 127));
    canvas.drawLine(
        const Offset(65, 132),
        const Offset(101, 132),
        Paint()
          ..color = const Color(0xff617788)
          ..strokeWidth = 2);
    canvas.drawLine(
        const Offset(111, 132),
        const Offset(275, 132),
        Paint()
          ..color = const Color(0xff617788)
          ..strokeWidth = 2);
  }

  void _water(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(0, 0, 320, 178),
        Paint()..color = const Color(0xffe5f1f7));
    canvas.drawRect(const Rect.fromLTWH(0, 178, 320, 72),
        Paint()..color = const Color(0xffdfcba9));
    canvas.drawCircle(
        const Offset(27, 28), 17, Paint()..color = const Color(0xffe9b944));
    final ground = Path()
      ..moveTo(0, 178)
      ..lineTo(80, 178)
      ..lineTo(135, 155)
      ..lineTo(320, 133)
      ..lineTo(320, 178)
      ..close();
    canvas.drawPath(ground, Paint()..color = const Color(0xff88b481));
    canvas.drawOval(const Rect.fromLTWH(7, 163, 95, 26),
        Paint()..color = const Color(0xff6dadd3));
    for (final center in [
      const Offset(132, 45),
      const Offset(164, 38),
      const Offset(190, 47),
      const Offset(221, 47)
    ]) {
      canvas.drawOval(Rect.fromCenter(center: center, width: 62, height: 32),
          Paint()..color = const Color(0xffbdc9d2));
    }
    _arrow(canvas, const Offset(38, 157), const Offset(38, 65));
    _arrow(canvas, const Offset(252, 68), const Offset(252, 140));
    canvas.drawLine(
        const Offset(243, 139),
        const Offset(135, 151),
        Paint()
          ..color = const Color(0xff2b607b)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);
    _arrow(canvas, const Offset(135, 151), const Offset(88, 172));
    _arrow(canvas, const Offset(279, 151), const Offset(279, 230));
    canvas.drawLine(
        const Offset(181, 157),
        const Offset(181, 103),
        Paint()
          ..color = const Color(0xff427447)
          ..strokeWidth = 6);
    for (final leaf in [const Offset(164, 120), const Offset(199, 106)]) {
      canvas.drawOval(Rect.fromCenter(center: leaf, width: 35, height: 17),
          Paint()..color = const Color(0xff518e4d));
    }
    canvas.drawLine(
        const Offset(181, 157),
        const Offset(173, 205),
        Paint()
          ..color = const Color(0xff725e40)
          ..strokeWidth = 3);
    canvas.drawLine(
        const Offset(173, 191),
        const Offset(155, 212),
        Paint()
          ..color = const Color(0xff725e40)
          ..strokeWidth = 2);
    canvas.drawLine(
        const Offset(175, 182),
        const Offset(203, 211),
        Paint()
          ..color = const Color(0xff725e40)
          ..strokeWidth = 2);
    _arrow(canvas, const Offset(195, 229), const Offset(181, 157));
    _arrow(canvas, const Offset(184, 98), const Offset(184, 68));
    for (final center in [
      const Offset(240, 204),
      const Offset(305, 221),
      const Offset(224, 233)
    ]) {
      canvas.drawCircle(center, 4, Paint()..color = const Color(0xff6dadd3));
    }
  }

  void _arrow(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = model == 'web' || model == 'g5-lever'
          ? const Color(0xff77cde3)
          : const Color(0xff2b607b)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
    for (final offset in [-.55, .55]) {
      canvas.drawLine(
          end,
          end - Offset(math.cos(angle + offset), math.sin(angle + offset)) * 11,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Grade5Painter oldDelegate) =>
      model != oldDelegate.model;
}
