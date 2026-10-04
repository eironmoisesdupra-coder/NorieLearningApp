import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original offline scientific models; labels retain the user's text scale.
class Grade10SciencePicture extends StatelessWidget {
  const Grade10SciencePicture({required this.picture, super.key});
  final String picture;
  static const descriptions = <String, String>{
    'g10-selection':
        'Inherited resistance occurs in 10 of 100 organisms before selection and 40 of 100 in a later generation. Each grid has 100 individuals; cyan means resistant and amber means susceptible. These are different generations, not individuals changing their inherited traits.',
    'g10-periodic':
        'Neutral sodium has electron counts 2, 8, 1; magnesium 2, 8, 2; chlorine 2, 8, 7. All have three occupied shells. Outer-shell counts help explain their different chemical behavior. Rings are a counting model, not electron paths or measured sizes.',
    'g10-ph':
        'At the same temperature in this dilute aqueous model, pH 3 has 100 times the hydronium concentration of pH 5. One hundred cyan dots versus one represent relative concentrations in equal volumes, not actual particle counts or acid strength.',
    'g10-circuit':
        'A closed ideal circuit has a 12-volt source and a 6-ohm resistor. Conventional current is 2 amperes clockwise, leaving the long positive terminal. One amber dot marks the source; two amber dots mark the resistor. Wire resistance is neglected; the drawing is not to physical scale.',
    'g10-population':
        'Invented rabbit counts are 20, 40, 65, 80 and 80 in years zero through four. Bars share a zero baseline and a maximum of 100 rabbits. The slowing growth is consistent with resource limitation but does not establish a permanent carrying capacity.',
    'g10-energy':
        'Supplied annual production is 10000, 1500 and 150 kilojoules per square meter per year for producers, herbivores and secondary consumers. Bars share a zero baseline and are proportional. Transfers are 15 percent and 10 percent; neither is a universal rule.',
    'g10-cascade':
        'An idealized causal model: more predators can reduce herbivores, and fewer herbivores can reduce grazing and increase plant biomass. Arrows with numbered explanations show causal effects, not energy quantities. Drought and other interactions can alter the outcome.',
  };
  static bool supports(String picture) => descriptions.containsKey(picture);
  Widget _text(String value) =>
      Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(value));
  Widget _panel(String model, {double height = 180}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _ScienceModel(model))));
  Widget _bar(String label, double fraction) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _text(label),
        SizedBox(
            height: 22, child: CustomPaint(painter: _QuantityBar(fraction))),
        const SizedBox(height: 16)
      ]);
  Widget _node(String label) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff66e0df)),
          borderRadius: BorderRadius.circular(12)),
      child: Text(label));
  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 10 picture: $picture');
    }
    return Semantics(
        container: true,
        explicitChildNodes: true,
        label: descriptions[picture],
        child: Column(
            key: ValueKey('science-grade10-$picture'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (picture == 'g10-selection') ...[
                _text('Before selection: 10 resistant / 100 organisms'),
                _panel('before'),
                _text('Later generation: 40 resistant / 100 organisms'),
                _panel('after'),
                _text(
                    'Each dot = one individual. Cyan = inherited resistance; amber = susceptible. Each row contains ten individuals.'),
                _text(
                    'Resistance rises from 10% to 40% across generations. Survival and reproduction change proportions; exposure does not deliberately transform susceptible individuals into resistant ones.'),
              ],
              if (picture == 'g10-periodic') ...[
                _text('Na · atomic number 11 · shells 2, 8, 1'),
                _panel('Na'),
                _text('Mg · atomic number 12 · shells 2, 8, 2'),
                _panel('Mg'),
                _text('Cl · atomic number 17 · shells 2, 8, 7'),
                _panel('Cl'),
                _text(
                    'White dots count electrons. Cyan center locates the nucleus but does not count its particles. Three occupied shells place all three elements in period 3.'),
                _text(
                    'For these main-group atoms, outer counts 1, 2 and 7 help explain common ions Na⁺, Mg²⁺ and Cl⁻. Rings are simplified shell counts, not circular electron tracks or scale drawings.'),
              ],
              if (picture == 'g10-ph') ...[
                _text('pH 3 · relative hydronium concentration 100'),
                _panel('ph3'),
                _text('pH 5 · relative hydronium concentration 1'),
                _panel('ph5'),
                _text(
                    'Equal modeled volumes at the same temperature. Dots show a concentration ratio: 10 × 10 = 100. Actual samples contain enormously more ions.'),
                _text(
                    'Two pH units do not mean twice the concentration. These dots omit water and other ions; they do not determine whether the dissolved acid is strong or weak.'),
              ],
              if (picture == 'g10-circuit') ...[
                _panel('circuit', height: 230),
                _text(
                    'One amber dot · Source: 12 V. The long terminal is positive; the short terminal is negative.'),
                _text(
                    'Two amber dots · Resistor: 6 Ω. Conventional current leaves + and follows the arrow clockwise: I = V/R = 12/6 = 2 A.'),
                _text(
                    'One closed path, ideal source and negligible wire resistance. Current is the same before and after the resistor; energy is transferred there. Symbols are not drawn to physical scale.'),
              ],
              if (picture == 'g10-population') ...[
                _text('Invented rabbit survey · same area and method'),
                _bar('Year 0 · 20 rabbits', .2),
                _bar('Year 1 · 40 rabbits', .4),
                _bar('Year 2 · 65 rabbits', .65),
                _bar('Year 3 · 80 rabbits', .8),
                _bar('Year 4 · 80 rabbits', .8),
                _text(
                    'Common scale: left edge 0; full outlined bar 100 rabbits. Gains are +20, +25, +15, then 0 rabbits per year.'),
                _text(
                    'The plateau is consistent with limited resources. Counts alone do not prove the cause or a fixed carrying capacity; measure food, water, disease and movement too.'),
              ],
              if (picture == 'g10-energy') ...[
                _text('Supplied annual production · kJ/m²/year'),
                _bar('Producers · 10,000', 1),
                _bar('Herbivores · 1,500', .15),
                _bar('Secondary consumers · 150', .015),
                _text(
                    'Shared zero at left. Full width = 10,000 kJ/m²/year; the small final bar is intentional. All values cover the same area and year.'),
                _text(
                    'First transfer: 1,500/10,000 × 100 = 15%. Second: 150/1,500 × 100 = 10%. Across both: 150/10,000 × 100 = 1.5%.'),
                _text(
                    'These are energy production rates, not standing biomass in g/m². Respiration transfers energy as heat; uneaten and unassimilated material can enter detrital pathways.'),
              ],
              if (picture == 'g10-cascade') ...[
                _node('Predator abundance increases'),
                _panel('arrow', height: 45),
                _text('1 · More predation can reduce herbivores.'),
                _node('Herbivore abundance decreases'),
                _panel('arrow', height: 45),
                _text('2 · Less grazing can allow more plant growth.'),
                _node('Plant biomass increases'),
                _text(
                    'Arrows represent possible causal effects, not feeding direction or energy amounts. The predator has an indirect positive effect on plants in this model.'),
                _text(
                    'Test the prediction against data. Drought, alternative prey, migration and other interactions may alter or overwhelm this pathway.'),
              ],
            ]));
  }
}

class _QuantityBar extends CustomPainter {
  const _QuantityBar(this.fraction);
  final double fraction;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(1, 1, (size.width - 2) * fraction, size.height - 2),
        Paint()..color = const Color(0xff66e0df));
    canvas.drawRect(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        Paint()
          ..color = const Color(0xffe3ecff)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_QuantityBar oldDelegate) =>
      oldDelegate.fraction != fraction;
}

class _ScienceModel extends CustomPainter {
  const _ScienceModel(this.model);
  final String model;
  static const cyan = Color(0xff66e0df);
  static const amber = Color(0xffffd176);
  static const white = Color(0xffe3ecff);
  void _line(Canvas c, Offset a, Offset b,
          {Color color = white, double width = 2}) =>
      c.drawLine(
          a,
          b,
          Paint()
            ..color = color
            ..strokeWidth = width);
  void _arrow(Canvas c, Offset a, Offset b) {
    _line(c, a, b, color: cyan, width: 3);
    final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
    for (final delta in [-.6, .6]) {
      _line(
          c,
          b,
          b -
              Offset(
                  math.cos(angle + delta) * 12, math.sin(angle + delta) * 12),
          color: cyan,
          width: 3);
    }
  }

  @override
  void paint(Canvas c, Size s) {
    if (['before', 'after', 'ph3', 'ph5'].contains(model)) {
      final count = model == 'ph5' ? 1 : 100;
      final selected = model == 'before'
          ? 10
          : model == 'after'
              ? 40
              : 100;
      final dx = (s.width - 24) / 10;
      final dy = (s.height - 20) / 10;
      for (var i = 0; i < count; i++) {
        c.drawCircle(
            Offset(12 + dx * (i % 10 + .5), 10 + dy * (i ~/ 10 + .5)),
            math.min(dx, dy) * .31,
            Paint()..color = i < selected ? cyan : amber);
      }
      c.drawRect(
          Rect.fromLTWH(4, 4, s.width - 8, s.height - 8),
          Paint()
            ..color = white
            ..style = PaintingStyle.stroke);
    } else if (['Na', 'Mg', 'Cl'].contains(model)) {
      final center = Offset(s.width / 2, s.height / 2);
      final radius = math.min(s.width / 2 - 12, s.height / 2 - 8);
      c.drawCircle(center, 9, Paint()..color = cyan);
      final counts = [
        2,
        8,
        model == 'Na'
            ? 1
            : model == 'Mg'
                ? 2
                : 7
      ];
      for (var shell = 0; shell < 3; shell++) {
        final r = radius * (shell + 1) / 3;
        c.drawCircle(
            center,
            r,
            Paint()
              ..color = cyan
              ..style = PaintingStyle.stroke);
        for (var n = 0; n < counts[shell]; n++) {
          final a = -math.pi / 2 + 2 * math.pi * n / counts[shell];
          c.drawCircle(center + Offset(math.cos(a) * r, math.sin(a) * r), 4,
              Paint()..color = white);
        }
      }
    } else if (model == 'arrow') {
      _arrow(c, Offset(s.width / 2, 3), Offset(s.width / 2, s.height - 5));
    } else if (model == 'circuit') {
      final left = s.width * .2,
          right = s.width * .8,
          top = 35.0,
          bottom = s.height - 35;
      _line(c, Offset(left, top), Offset(right, top));
      _line(c, Offset(right, top), Offset(right, 90));
      _line(c, Offset(right, 140), Offset(right, bottom));
      _line(c, Offset(right, bottom), Offset(left, bottom));
      _line(c, Offset(left, bottom), Offset(left, 128));
      _line(c, Offset(left, 112), Offset(left, top));
      _line(c, Offset(left - 18, 112), Offset(left + 18, 112),
          color: amber, width: 4);
      _line(c, Offset(left - 9, 128), Offset(left + 9, 128),
          color: amber, width: 4);
      // One dot beside source, two beside resistor: accessible legend below.
      c.drawCircle(Offset(left - 29, 120), 4, Paint()..color = amber);
      _line(c, Offset(left - 25, 120), Offset(left - 13, 120), color: amber);
      c.drawRect(
          Rect.fromLTRB(right - 10, 90, right + 10, 140),
          Paint()
            ..color = amber
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
      for (final y in [111.0, 121.0]) {
        c.drawCircle(Offset(right + 28, y), 3, Paint()..color = amber);
      }
      _line(c, Offset(right + 24, 116), Offset(right + 12, 116), color: amber);
      _arrow(
          c, Offset(s.width * .43, top - 12), Offset(s.width * .65, top - 12));
    }
  }

  @override
  bool shouldRepaint(_ScienceModel oldDelegate) => oldDelegate.model != model;
}
