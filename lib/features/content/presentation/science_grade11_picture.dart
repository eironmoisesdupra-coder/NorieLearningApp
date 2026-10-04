import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original offline vector models, with scalable labels outside the paintings.
class Grade11SciencePicture extends StatelessWidget {
  const Grade11SciencePicture({required this.picture, super.key});
  final String picture;
  static const descriptions = <String, String>{
    'g11-cell':
        'A membrane bilayer separates higher solute concentration above from lower concentration below. The left cyan arrow shows passive transport down the gradient through a channel. The right amber arrow shows an ATP-powered pump moving solute upward against the gradient. Heads face water; tails face inward. Schematic, not to scale.',
    'g11-stoichiometry':
        'Before reaction: two hydrogen molecules, each containing two hydrogen atoms, and one oxygen molecule containing two oxygen atoms. After reaction: two water molecules, each containing two hydrogen atoms and one oxygen atom. Four hydrogen atoms and two oxygen atoms are conserved. Cyan represents hydrogen; amber represents oxygen.',
    'g11-mechanics':
        'A three-kilogram object has a ten-newton force to the right and a four-newton force to the left. The right arrow is two and a half times as long as the left arrow. Net force is six newtons right, so acceleration is two meters per second squared right. Only horizontal forces are shown.',
    'g11-materials':
        'Three schematic rock textures: coarse interlocking crystals, cemented rounded sediment grains, and aligned elongated metamorphic minerals. Grain texture provides evidence about formation; it does not by itself identify every mineral or rock. Colors distinguish grains rather than chemical identities.',
    'g11-replicates':
        'Two dot plots share a zero-to-sixteen-second horizontal scale. Set A contains nine, ten and eleven seconds. Set B contains six, ten and fourteen seconds. Both means are ten seconds. Their ranges are two and eight seconds. Each cyan dot is one reading; the amber diamond below marks the mean.',
    'g11-slope':
        'Position versus time: times zero, one, two and three seconds correspond to positions two, four, six and eight meters. The vertical axis spans zero to ten meters. The line has intercept two meters and slope two meters per second. The dashed slope triangle runs three seconds horizontally and rises six meters vertically.',
    'g11-uncertainty':
        'Minimum-to-maximum bars share a zero-to-sixteen-second scale. Group P has mean ten seconds and range nine to eleven seconds. Group Q has mean eleven seconds and range ten to twelve seconds. Amber diamonds mark means. These observed-range bars overlap from ten to eleven seconds; they are not confidence intervals or a significance test.',
  };
  static bool supports(String picture) => descriptions.containsKey(picture);
  Widget _text(String text) =>
      Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(text));
  Widget _panel(String model, {double height = 180}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _Grade11Model(model))));
  Widget _scalePanel(String model) => Column(children: [
        _panel(model, height: 90),
        _ticks(const ['0', '4', '8', '12', '16']),
        const SizedBox(height: 12),
      ]);
  Widget _ticks(List<String> labels) => Row(children: [
        for (final label in labels)
          Expanded(child: Text(label, textAlign: TextAlign.center)),
      ]);
  Widget _slope() => Column(children: [
        _text('Position x (m)'),
        SizedBox(
            height: 220,
            child: Row(children: [
              SizedBox(
                  width: 44,
                  child: Stack(children: [
                    for (var i = 0; i <= 5; i++)
                      Positioned(
                          top: 10 + i * 40 - 9,
                          right: 4,
                          child: Text('${10 - i * 2}',
                              style: const TextStyle(fontSize: 12))),
                  ])),
              const Expanded(
                  child: SizedBox(
                      height: 220,
                      child: CustomPaint(painter: _Grade11Model('slope')))),
            ])),
        Padding(
            padding: const EdgeInsets.only(left: 44),
            child: _ticks(const ['0', '1', '2', '3'])),
        _text('Time t (s)'),
      ]);
  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 11 picture: $picture');
    }
    return Semantics(
        container: true,
        explicitChildNodes: true,
        label: descriptions[picture],
        child: Column(
            key: ValueKey('science-grade11-$picture'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (picture == 'g11-cell') ...[
                _text('Higher solute concentration · outside'),
                _panel('membrane', height: 220),
                _text('Lower solute concentration · inside'),
                _text(
                    'Left cyan arrow: passive transport through a channel, down the concentration gradient.'),
                _text(
                    'Right amber arrow: an ATP-powered pump transports solute against the gradient. ATP supplies energy.'),
                _text(
                    'Paired rows of heads face water; tails meet inside the bilayer. Purple shapes are membrane proteins; white dots represent one solute. This model omits other molecules and is not to scale.'),
              ],
              if (picture == 'g11-stoichiometry') ...[
                _text('Before · 2 H₂ + 1 O₂'),
                _panel('reactants', height: 160),
                _text('After · 2 H₂O'),
                _panel('products', height: 160),
                _text(
                    'Cyan = hydrogen atom; amber = oxygen atom. Touching circles form one molecule. Count four H and two O atoms before and after.'),
                _text(
                    'The coefficient ratio 2 : 1 : 2 also applies to moles. Molecule sizes and spacing are schematic; this picture does not depict a reaction mechanism.'),
              ],
              if (picture == 'g11-mechanics') ...[
                _text('Horizontal forces on a 3 kg object'),
                _panel('forces', height: 150),
                _text(
                    'Cyan rightward force: 10 N. Amber leftward force: 4 N. Arrow lengths use the same scale.'),
                _text(
                    'Resultant: 10 − 4 = 6 N right. Acceleration: a = Fnet/m = 6/3 = 2 m/s² right.'),
                _text(
                    'The arrows share an origin inside the object. Vertical forces are omitted; they balance in this model. Acceleration direction alone does not identify the current direction of motion.'),
              ],
              if (picture == 'g11-materials') ...[
                _text('Coarse interlocking crystals'),
                _panel('crystals', height: 150),
                _text(
                    'Crystals grow against neighbors. Coarse igneous texture commonly indicates slower cooling beneath the surface.'),
                _text('Cemented rounded grains'),
                _panel('grains', height: 150),
                _text(
                    'Rounded grains retain boundaries; material between grains binds them. This clastic sedimentary texture records deposited fragments.'),
                _text('Aligned metamorphic minerals'),
                _panel('aligned', height: 150),
                _text(
                    'Parallel elongated minerals model foliation that can develop during solid-state deformation and recrystallization. Not all metamorphic rocks are foliated.'),
                _text(
                    'Schematics, not measured micrographs. Colors separate grains, not mineral species. Confirm rock identity using composition and other evidence.'),
              ],
              if (picture == 'g11-replicates') ...[
                _text('Set A · 9, 10, 11 s'),
                _scalePanel('replicateA'),
                _text('Set B · 6, 10, 14 s'),
                _scalePanel('replicateB'),
                _text(
                    'Horizontal scale: time (s), 0–16 in both panels. Cyan dots are individual readings; amber diamonds below the axis locate each mean of 10 s.'),
                _text(
                    'Range A: 11 − 9 = 2 s. Range B: 14 − 6 = 8 s. Same center, different observed spread; accuracy still requires a reference.'),
              ],
              if (picture == 'g11-slope') ...[
                _slope(),
                _text(
                    'Cyan points: (0, 2), (1, 4), (2, 6), (3, 8). Line: x = 2 + 2t.'),
                _text(
                    'Amber dashed triangle: run Δt = 3 s; rise Δx = 6 m. Slope = 6/3 = 2 m/s.'),
                _text(
                    'The intercept is 2 m at t = 0. Position/time at the final point, 8/3, is not the slope because the object started at 2 m.'),
              ],
              if (picture == 'g11-uncertainty') ...[
                _text('Group P · mean 10 s'),
                _scalePanel('rangeP'),
                _text('Group Q · mean 11 s'),
                _scalePanel('rangeQ'),
                _text(
                    'Horizontal scale: time (s), 0–16 in both panels. Cyan caps mark the minimum and maximum; amber diamonds mark means.'),
                _text(
                    'P: 9–11 s; Q: 10–12 s. These observed-range bars overlap from 10 to 11 s.'),
                _text(
                    'Bars describe three observations per group, not confidence intervals. Overlap alone cannot establish or rule out a statistically significant population difference.'),
              ],
            ]));
  }
}

class _Grade11Model extends CustomPainter {
  const _Grade11Model(this.model);
  final String model;
  static const cyan = Color(0xff66e0df);
  static const amber = Color(0xffffc568);
  static const white = Color(0xffe3ecff);
  static const purple = Color(0xffab94ed);
  void _line(Canvas c, Offset a, Offset b, Color color, [double width = 2]) =>
      c.drawLine(
          a,
          b,
          Paint()
            ..color = color
            ..strokeWidth = width);
  void _arrow(Canvas c, Offset a, Offset b, Color color) {
    _line(c, a, b, color, 3);
    final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
    for (final turn in [-.55, .55]) {
      _line(
          c,
          b,
          b - Offset(math.cos(angle + turn), math.sin(angle + turn)) * 10,
          color,
          3);
    }
  }

  void _dot(Canvas c, Offset p, double radius, Color color) =>
      c.drawCircle(p, radius, Paint()..color = color);
  void _diamond(Canvas c, Offset p) => c.drawPath(
      Path()
        ..moveTo(p.dx, p.dy - 6)
        ..lineTo(p.dx + 6, p.dy)
        ..lineTo(p.dx, p.dy + 6)
        ..lineTo(p.dx - 6, p.dy)
        ..close(),
      Paint()..color = amber);
  void _dash(Canvas c, Offset a, Offset b) {
    final delta = b - a;
    final length = delta.distance;
    for (double d = 0; d < length; d += 10) {
      _line(c, a + delta * (d / length),
          a + delta * (math.min(d + 5, length) / length), amber);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (model == 'membrane') {
      for (var i = 0; i < 14; i++) {
        final x = 10 + (w - 20) * i / 13;
        if ((x - w * .3).abs() < 20 || (x - w * .73).abs() < 19) continue;
        for (final y in [87.0, 133.0]) {
          _dot(canvas, Offset(x, y), 5, cyan);
          final sign = y < 110 ? 1 : -1;
          _line(canvas, Offset(x - 2, y + sign * 4),
              Offset(x - 3, y + sign * 19), cyan, 1.5);
          _line(canvas, Offset(x + 2, y + sign * 4),
              Offset(x + 3, y + sign * 19), cyan, 1.5);
        }
      }
      for (final x in [w * .3, w * .73]) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(center: Offset(x, 110), width: 36, height: 64),
                const Radius.circular(10)),
            Paint()..color = purple.withValues(alpha: .4));
      }
      for (var i = 0; i < 7; i++) {
        _dot(
            canvas, Offset(18 + i * (w - 36) / 6, 24 + (i % 2) * 20), 4, white);
      }
      for (final x in [w * .25, w * .77]) {
        _dot(canvas, Offset(x, 195), 4, white);
      }
      _arrow(canvas, Offset(w * .3, 59), Offset(w * .3, 170), cyan);
      _arrow(canvas, Offset(w * .73, 170), Offset(w * .73, 59), amber);
    } else if (model == 'reactants' || model == 'products') {
      if (model == 'reactants') {
        for (final p in [Offset(w * .26, 43), Offset(w * .74, 43)]) {
          _dot(canvas, p - const Offset(8, 0), 9, cyan);
          _dot(canvas, p + const Offset(8, 0), 9, cyan);
        }
        _dot(canvas, Offset(w / 2 - 11, 113), 12, amber);
        _dot(canvas, Offset(w / 2 + 11, 113), 12, amber);
      } else {
        for (final p in [Offset(w * .26, 75), Offset(w * .74, 75)]) {
          _dot(canvas, p, 12, amber);
          _dot(canvas, p + const Offset(-14, 13), 9, cyan);
          _dot(canvas, p + const Offset(14, 13), 9, cyan);
        }
      }
    } else if (model == 'forces') {
      final unit = (w - 32) / 14;
      final center = Offset(16 + unit * 4, h / 2);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: center, width: 50, height: 54),
              const Radius.circular(6)),
          Paint()..color = purple.withValues(alpha: .35));
      _arrow(canvas, center, center + Offset(unit * 10, 0), cyan);
      _arrow(canvas, center, center - Offset(unit * 4, 0), amber);
      _dot(canvas, center, 3, white);
    } else if (model == 'crystals') {
      // Shared irregular vertices form a continuous interlocking mosaic.
      final vertices = <List<Offset>>[
        [
          const Offset(8, 8),
          Offset(w * .36, 8),
          Offset(w * .29, 69),
          const Offset(8, 91)
        ],
        [
          Offset(w * .36, 8),
          Offset(w * .68, 8),
          Offset(w * .73, 60),
          Offset(w * .51, 87),
          Offset(w * .29, 69)
        ],
        [
          Offset(w * .68, 8),
          Offset(w - 8, 8),
          Offset(w - 8, 92),
          Offset(w * .73, 60)
        ],
        [
          const Offset(8, 91),
          Offset(w * .29, 69),
          Offset(w * .51, 87),
          Offset(w * .4, h - 8),
          Offset(8, h - 8)
        ],
        [
          Offset(w * .51, 87),
          Offset(w * .73, 60),
          Offset(w - 8, 92),
          Offset(w - 8, h - 8),
          Offset(w * .4, h - 8)
        ],
      ];
      for (var i = 0; i < vertices.length; i++) {
        final path = Path()..addPolygon(vertices[i], true);
        canvas.drawPath(
            path,
            Paint()
              ..color = [cyan, purple, amber][i % 3].withValues(alpha: .65));
        canvas.drawPath(
            path,
            Paint()
              ..color = white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
      }
    } else if (model == 'grains') {
      canvas.drawRect(Rect.fromLTWH(8, 8, w - 16, h - 16),
          Paint()..color = purple.withValues(alpha: .22));
      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 5; col++) {
          final p =
              Offset(28 + col * (w - 58) / 4 + (row % 2) * 4, 31 + row * 43.0);
          canvas.drawOval(
              Rect.fromCenter(
                  center: p,
                  width: 26 + (col % 2) * 3,
                  height: 24 + (row % 2) * 5),
              Paint()
                ..color = [cyan, amber][(row + col) % 2].withValues(alpha: .8));
        }
      }
    } else if (model == 'aligned') {
      for (var row = 0; row < 4; row++) {
        for (var col = 0; col < 3; col++) {
          canvas.save();
          canvas.translate(39 + col * (w - 76) / 2, 22 + row * 34.0);
          canvas.rotate(-.18);
          canvas.drawOval(const Rect.fromLTWH(-28, -6, 56, 12),
              Paint()..color = [cyan, purple, amber][row % 3]);
          canvas.restore();
        }
      }
    } else if (model == 'slope') {
      final left = w / 8, right = w * 7 / 8, top = 10.0, bottom = h - 10;
      Offset point(double t, double x) => Offset(
          left + (right - left) * t / 3, bottom - (bottom - top) * x / 10);
      for (var y = 0; y <= 10; y += 2) {
        _line(canvas, point(0, y.toDouble()), point(3, y.toDouble()),
            white.withValues(alpha: .18), 1);
      }
      _line(canvas, Offset(left, top), Offset(left, bottom), white);
      _line(canvas, Offset(left, bottom), Offset(right, bottom), white);
      for (var t = 0; t <= 3; t++) {
        _line(canvas, point(t.toDouble(), 0),
            point(t.toDouble(), 0) + const Offset(0, 4), white);
      }
      _dash(canvas, point(0, 2), point(3, 2));
      _dash(canvas, point(3, 2), point(3, 8));
      _line(canvas, point(0, 2), point(3, 8), cyan);
      for (var t = 0; t <= 3; t++) {
        _dot(canvas, point(t.toDouble(), 2 + t * 2.0), 4, cyan);
      }
    } else {
      double x(double value) => w / 10 + w * .8 * value / 16;
      _line(canvas, Offset(x(0), 60), Offset(x(16), 60), white);
      for (var i = 0; i <= 16; i += 4) {
        _line(canvas, Offset(x(i.toDouble()), 57), Offset(x(i.toDouble()), 64),
            white);
      }
      if (model.startsWith('replicate')) {
        final values =
            model == 'replicateA' ? [9.0, 10.0, 11.0] : [6.0, 10.0, 14.0];
        for (final value in values) {
          _dot(canvas, Offset(x(value), 40), 5, cyan);
        }
        _diamond(canvas, Offset(x(10), 78));
      } else {
        final mean = model == 'rangeP' ? 10.0 : 11.0;
        _line(
            canvas, Offset(x(mean - 1), 32), Offset(x(mean + 1), 32), cyan, 3);
        for (final value in [mean - 1, mean + 1]) {
          _line(canvas, Offset(x(value), 22), Offset(x(value), 42), cyan, 3);
        }
        _diamond(canvas, Offset(x(mean), 32));
      }
    }
  }

  @override
  bool shouldRepaint(_Grade11Model oldDelegate) => oldDelegate.model != model;
}
