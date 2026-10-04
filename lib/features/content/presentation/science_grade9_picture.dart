import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original local models. Text remains naturally sized outside painted geometry.
class Grade9SciencePicture extends StatelessWidget {
  const Grade9SciencePicture({required this.picture, super.key});
  final String picture;
  static const descriptions = <String, String>{
    'g9-biology':
        'Negative feedback: increased body temperature stimulates sweating; evaporation transfers heat away and temperature moves toward its regulated range, reducing the original stimulus. Arrows show causal links, not quantities.',
    'g9-atom':
        'Neutral carbon-12 has six protons, six neutrons and six electrons. Neutral carbon-14 has six protons, eight neutrons and six electrons. Both have two inner-shell and four outer-shell electrons. Cyan protons, amber neutrons and white electrons are counted separately; shells are schematic, not electron paths.',
    'g9-bonding':
        'A two-dimensional fragment of solid sodium chloride shows alternating sodium positive and chloride negative ions in a one-to-one ratio. A separate hydrogen molecule shows two nuclei sharing one electron pair. The lattice continues beyond the fragment; sodium chloride is not a collection of isolated NaCl molecules.',
    'g9-motion':
        'A two-kilogram cart has an eight-newton force right and a two-newton force left. The right arrow is four times the length of the left. The net force is six newtons right and acceleration is three meters per second squared right. Vertical forces balance and are omitted.',
    'g9-seafloor':
        'An ideal ridge at the center has youngest crust. Three matching magnetic bands on each side alternate cyan normal polarity and amber reversed polarity. Outward arrows show spreading; mirror symmetry is idealized and band widths do not give an actual reversal timetable.',
    'g9-subduction':
        'An oceanic plate enters from the left and descends beneath a plate on the right. Coral earthquake dots follow the dipping slab, becoming deeper to the right. Numbers identify shallow, intermediate and deeper positions, not measurements. The schematic has no distance or depth scale.',
    'g9-gps':
        'A hypothetical GPS station moves east relative to a stated reference. It is at zero centimeters in year zero, two centimeters in year one and four centimeters in year two. Equal horizontal intervals represent equal two-centimeter displacements. Average eastward velocity is two centimeters per year.',
  };
  static bool supports(String picture) => descriptions.containsKey(picture);
  Widget text(String value) =>
      Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(value));
  Widget panel(String model, {double height = 210}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _Model(model))));
  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 9 Science picture: $picture');
    }
    return Semantics(
        container: true,
        explicitChildNodes: true,
        label: descriptions[picture],
        child: Column(
            key: ValueKey('science-grade9-$picture'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (picture == 'g9-biology') ...[
                const _FeedbackLoop(),
                text(
                    'This is negative feedback: the response opposes the initial change. The arrows show causal direction, not a measured heat flow. Sweating cools through evaporation, not simply because skin becomes wet.'),
              ],
              if (picture == 'g9-atom') ...[
                text('Carbon-12 · 6 protons + 6 neutrons'),
                panel('c12'),
                text('Carbon-14 · 6 protons + 8 neutrons'),
                panel('c14'),
                text(
                    'Cyan nuclear dots: protons. Amber nuclear dots: neutrons. White dots: two electrons in the inner shell and four in the outer shell of each neutral atom.'),
                text(
                    'Both have atomic number 6. Mass numbers 12 and 14 count protons plus neutrons. Changing neutron count makes isotopes of the same element.'),
                text(
                    'Electron dots and circles are a counting model, not measured sizes or paths. Most of the real atomic volume lies outside the tiny nucleus.'),
              ],
              if (picture == 'g9-bonding') ...[
                text('Solid NaCl · a continuing ionic lattice'),
                panel('lattice'),
                text(
                    'Cyan circles with +: Na⁺. Amber circles with −: Cl⁻. This fragment has six of each: a 1:1 ratio.'),
                text(
                    'Oppositely charged ions attract throughout a three-dimensional lattice. This drawing is only a flat fragment.'),
                text('H₂ · one discrete covalent molecule'),
                panel('hydrogen', height: 140),
                text(
                    'The two small white dots between the cyan nuclei represent one shared electron pair. Each hydrogen contributes one electron.'),
                text(
                    'Ionic bonding is electrostatic attraction between ions. Covalent bonding involves shared electrons. Symbol sizes and separations are schematic.'),
              ],
              if (picture == 'g9-motion') ...[
                panel('cart', height: 240),
                text(
                    '1 · Leftward force: 2 N. 2 · Rightward force: 8 N. Arrows use the same force scale, so the right arrow is four times as long.'),
                text(
                    'Cart mass = 2 kg. Net horizontal force = 8 − 2 = 6 N right. Acceleration = 6 ÷ 2 = 3 m/s² right.'),
                text(
                    'Vertical forces balance and are omitted. Acceleration does not tell us the present direction of velocity; a cart moving left could be slowing down.'),
              ],
              if (picture == 'g9-seafloor') ...[
                panel('stripes'),
                text(
                    '1 · Ridge: new crust forms here. 2 · Matching bands lie on opposite sides. Arrows show crust moving away from the ridge.'),
                text(
                    'Cyan: normal polarity. Amber: reversed polarity. Cooling magnetic minerals preserve the field direction at formation; polarity is not the direction the plate travels.'),
                text(
                    'Youngest crust is at the ridge, with older crust farther away. Symmetric spreading is an ideal model; natural rates, stripe widths and preservation vary.'),
              ],
              if (picture == 'g9-subduction') ...[
                panel('slab', height: 260),
                text(
                    '1 · Shallow earthquake near the trench. 2 · An intermediate position on the slab. 3 · A deeper earthquake farther beneath the overriding plate.'),
                text(
                    'Coral dots identify earthquake sources, not volcanoes. Their dipping pattern supports a descending plate; depths cannot be read numerically from this unscaled sketch.'),
                text(
                    'The mantle around the slab is mostly solid but can deform slowly. Not every subduction earthquake lies directly on the shallow plate interface.'),
              ],
              if (picture == 'g9-gps') ...[
                panel('gps', height: 150),
                text(
                    '1 · Year 0: 0 cm. 2 · Year 1: 2 cm east. 3 · Year 2: 4 cm east.'),
                text(
                    'Positions use the same reference and equally spaced distance intervals. East is to the right; north–south motion is omitted.'),
                text(
                    'Average velocity = (4 − 0) cm ÷ 2 years = 2 cm/year east. These are invented teaching data, not measurements of a named plate.'),
                text(
                    'A short GPS record and a million-year rock record average motion over different intervals. Neither guarantees the same future rate.'),
              ],
            ]));
  }
}

class _Model extends CustomPainter {
  const _Model(this.model);
  final String model;
  static const cyan = Color(0xff63e6eb),
      amber = Color(0xffffcf65),
      coral = Color(0xffff9187);
  @override
  void paint(Canvas canvas, Size size) {
    Offset p(double x, double y) => Offset(x * size.width, y * size.height);
    final paint = Paint();
    canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(10)),
        paint..color = const Color(0xff101b36));
    void line(Offset a, Offset b, Color color, [double width = 3]) =>
        canvas.drawLine(
            a,
            b,
            paint
              ..color = color
              ..strokeWidth = width
              ..style = PaintingStyle.stroke);
    void dot(Offset at, double radius, Color color) => canvas.drawCircle(
        at,
        radius,
        paint
          ..color = color
          ..style = PaintingStyle.fill);
    void arrow(Offset a, Offset b, Color color) {
      line(a, b, color);
      final direction = (a - b) / (a - b).distance;
      final perpendicular = Offset(-direction.dy, direction.dx);
      final path = Path()
        ..moveTo(b.dx, b.dy)
        ..lineTo((b + direction * 9 + perpendicular * 4).dx,
            (b + direction * 9 + perpendicular * 4).dy)
        ..lineTo((b + direction * 9 - perpendicular * 4).dx,
            (b + direction * 9 - perpendicular * 4).dy)
        ..close();
      canvas.drawPath(
          path,
          paint
            ..style = PaintingStyle.fill
            ..color = color);
    }

    void marker(String label, Offset at, Offset feature) {
      line(at, feature, Colors.white70, 1);
      dot(at, 10, const Color(0xff294463));
      final t = TextPainter(
          text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          textDirection: TextDirection.ltr)
        ..layout();
      t.paint(canvas, at - Offset(t.width / 2, t.height / 2));
    }

    if (model == 'connector') {
      arrow(p(.5, .12), p(.5, .88), cyan);
    }
    if (model == 'c12' || model == 'c14') {
      final center = p(.5, .5);
      canvas.drawCircle(
          center,
          size.width * .35,
          paint
            ..color = Colors.white38
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
      canvas.drawCircle(
          center,
          size.width * .21,
          paint
            ..color = Colors.white38
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
      for (var i = 0; i < 2; i++) {
        final a = math.pi / 2 + i * math.pi;
        dot(center + Offset(math.cos(a), math.sin(a)) * size.width * .21, 4,
            Colors.white);
      }
      for (var i = 0; i < 4; i++) {
        final a = math.pi / 4 + i * math.pi / 2;
        dot(center + Offset(math.cos(a), math.sin(a)) * size.width * .35, 4,
            Colors.white);
      }
      final count = model == 'c12' ? 12 : 14;
      for (var i = 0; i < count; i++) {
        dot(center + Offset((i % 4 - 1.5) * 13, (i ~/ 4 - 1.5) * 13), 5,
            i < 6 ? cyan : amber);
      }
    }
    if (model == 'lattice') {
      for (var y = 0; y < 3; y++) {
        for (var x = 0; x < 4; x++) {
          final at = p(.2 + x * .2, .23 + y * .27);
          final positive = (x + y) % 2 == 0;
          dot(at, 17, positive ? cyan : amber);
          line(at - const Offset(5, 0), at + const Offset(5, 0),
              const Color(0xff101b36), 2);
          if (positive) {
            line(at - const Offset(0, 5), at + const Offset(0, 5),
                const Color(0xff101b36), 2);
          }
        }
      }
    }
    if (model == 'hydrogen') {
      dot(p(.32, .5), 18, cyan);
      dot(p(.68, .5), 18, cyan);
      dot(p(.48, .5), 3, Colors.white);
      dot(p(.52, .5), 3, Colors.white);
    }
    if (model == 'cart') {
      canvas.drawRect(
          Rect.fromPoints(p(.28, .43), p(.53, .65)),
          paint
            ..style = PaintingStyle.fill
            ..color = amber);
      dot(p(.33, .69), 9, Colors.white70);
      dot(p(.48, .69), 9, Colors.white70);
      arrow(p(.4, .35), p(.28, .35), cyan);
      arrow(p(.4, .25), p(.88, .25), cyan);
      marker('1', p(.16, .46), p(.30, .35));
      marker('2', p(.78, .10), p(.76, .25));
    }
    if (model == 'stripes') {
      for (var i = 0; i < 6; i++) {
        final j = i < 3 ? 2 - i : i - 3;
        canvas.drawRect(
            Rect.fromLTWH(size.width * (.08 + i * .14), size.height * .36,
                size.width * .14, size.height * .42),
            paint
              ..style = PaintingStyle.fill
              ..color = j % 2 == 0 ? cyan : amber);
      }
      line(p(.5, .31), p(.5, .82), Colors.white, 3);
      arrow(p(.43, .22), p(.13, .22), cyan);
      arrow(p(.57, .22), p(.87, .22), cyan);
      marker('1', p(.5, .12), p(.5, .36));
      marker('2', p(.77, .9), p(.79, .74));
    }
    if (model == 'slab') {
      final slab = Path()
        ..moveTo(p(.08, .32).dx, p(.08, .32).dy)
        ..lineTo(p(.38, .32).dx, p(.38, .32).dy)
        ..lineTo(p(.86, .82).dx, p(.86, .82).dy);
      canvas.drawPath(
          slab,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 17
            ..color = cyan);
      line(p(.49, .31), p(.93, .31), amber, 17);
      arrow(p(.12, .18), p(.36, .18), cyan);
      arrow(p(.88, .18), p(.63, .18), amber);
      for (var i = 0; i < 3; i++) {
        final at = p(.42 + i * .18, .36 + i * .19);
        dot(at, 5, coral);
        marker('${i + 1}', at + const Offset(-28, 25), at);
      }
    }
    if (model == 'gps') {
      arrow(p(.10, .61), p(.92, .61), cyan);
      for (var i = 0; i < 3; i++) {
        final at = p(.15 + i * .32, .61);
        dot(at, 5, amber);
        marker('${i + 1}', at + const Offset(0, -35), at);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _Model oldDelegate) =>
      model != oldDelegate.model;
}

class _FeedbackLoop extends StatelessWidget {
  const _FeedbackLoop();
  @override
  Widget build(BuildContext context) {
    Widget stage(String label) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xff19364c),
              border: Border.all(color: const Color(0xff63e6eb)),
              borderRadius: BorderRadius.circular(8)),
          child: Text(label),
        );
    const connector = SizedBox(
        height: 36,
        width: double.infinity,
        child: CustomPaint(painter: _Model('connector')));
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Stack(children: [
            const Positioned.fill(
                child: CustomPaint(painter: _FeedbackReturn())),
            Padding(
                padding: const EdgeInsets.only(right: 28),
                child: Column(children: [
                  stage(
                      '1 ? Stimulus: body temperature rises above its regulated range.'),
                  connector,
                  stage(
                      '2 ? Response: sweating increases; evaporation transfers heat away.'),
                  connector,
                  stage(
                      '3 ? Effect: temperature moves back toward its regulated range.'),
                ])),
          ]),
          const SizedBox(height: 10),
          const Text(
              'Amber return arrow: the effect reduces the initial stimulus, so the cooling response decreases. This closes the negative-feedback loop.'),
        ]));
  }
}

class _FeedbackReturn extends CustomPainter {
  const _FeedbackReturn();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xffffcf65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final x = size.width - 12;
    final path = Path()
      ..moveTo(size.width - 28, size.height - 24)
      ..lineTo(x, size.height - 24)
      ..lineTo(x, 24)
      ..lineTo(size.width - 28, 24);
    canvas.drawPath(path, p);
    canvas.drawLine(
        Offset(size.width - 28, 24), Offset(size.width - 21, 19), p);
    canvas.drawLine(
        Offset(size.width - 28, 24), Offset(size.width - 21, 29), p);
  }

  @override
  bool shouldRepaint(covariant _FeedbackReturn oldDelegate) => false;
}
