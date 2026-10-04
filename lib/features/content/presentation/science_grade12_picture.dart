import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original offline schematics; all explanatory labels remain scalable text.
class Grade12SciencePicture extends StatelessWidget {
  const Grade12SciencePicture({required this.picture, super.key});
  final String picture;
  static const descriptions = <String, String>{
    'g12-genetics':
        'Template DNA 3 prime TAC CTT 5 prime is transcribed to messenger RNA 5 prime AUG GAA 3 prime, translated as methionine then glutamate. Coding DNA is 5 prime ATG GAA 3 prime. Arrows show information flow, not conversion of DNA into protein.',
    'g12-equilibrium':
        'A reversible A to B system has equilibrium concentrations A 0.20 and B 0.80 moles per liter. Bars share a zero-to-one scale. Forward and reverse rate arrows are equal. Kc is B divided by A, equal to four.',
    'g12-fields':
        'Equal positive and negative source charges lie left and right of a midpoint. At the midpoint both component electric field arrows point right and have equal lengths. Their vector sum points right. A negative test charge experiences force left.',
    'g12-geology':
        'A closed radioactive clock begins with 100 percent parent and zero daughter. After one half-life, 50 percent parent remains; after two, 25 percent remains. Complementary daughter fractions are zero, 50 and 75 percent. Equal-width bars represent the original parent total.',
    'g12-sampling':
        'Four one-square-meter quadrats contain two, four, three and three plants, totaling twelve plants across four square meters. Mean density is three plants per square meter. A representative sample would estimate 300 plants in 100 square meters.',
    'g12-diversity':
        'Two communities each contain eight individuals of two species. Community A has four of each species; B has seven of the first and one of the second. Richness is two in both. Using one minus the sum of squared proportions, diversity is 0.50 for A and 0.21875 for B.',
    'g12-niche':
        'A hypothetical species persists without competitors across soil moisture values two to eight on a zero-to-ten illustrative scale. With a competitor, it persists from five to eight. The realized interval is narrower in this competition-only model; moisture is just one niche dimension.',
  };
  static bool supports(String picture) => descriptions.containsKey(picture);
  Widget _text(String text) =>
      Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(text));
  Widget _paint(String model, [double height = 120]) => SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _Model(model)));
  Widget _ticks(List<String> labels) => Row(children: [
        for (final label in labels)
          Expanded(child: Text(label, textAlign: TextAlign.center))
      ]);
  Widget _box(String text) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff66e0df)),
          borderRadius: BorderRadius.circular(8)),
      child: Text(text));
  @override
  Widget build(BuildContext context) {
    if (!supports(picture)) {
      throw ArgumentError('Unknown Grade 12 picture: $picture');
    }
    return Semantics(
        container: true,
        explicitChildNodes: true,
        label: descriptions[picture],
        child: Column(
            key: ValueKey('science-grade12-$picture'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (picture == 'g12-genetics') ...[
                _box("Coding DNA\n5′-ATG GAA-3′"),
                _box("Template DNA\n3′-TAC CTT-5′"),
                _paint('down', 34),
                _text('Transcription: RNA is made using the template.'),
                _box("mRNA\n5′-AUG GAA-3′"),
                _paint('down', 34),
                _text('Translation: read mRNA codons from 5′ to 3′.'),
                _box('Peptide begins\nMet–Glu'),
                _text(
                    'A short sequence model, not a complete gene. DNA remains DNA; arrows show information use. Coding DNA matches RNA except T replaces U.'),
              ],
              if (picture == 'g12-equilibrium') ...[
                _text('A ⇌ B · equilibrium concentrations'),
                _paint('equilibrium', 160),
                _ticks(const ['0', '0.25', '0.50', '0.75', '1.00']),
                _text(
                    'Concentration (mol/L). Upper cyan bar: A = 0.20. Lower amber bar: B = 0.80.'),
                _paint('rates', 80),
                _text(
                    'Equal-length arrows: equal forward and reverse rates. Arrow length here represents rate, not concentration.'),
                _text(
                    'Kc = [B]/[A] = 0.80/0.20 = 4. Constant concentrations can be unequal.'),
              ],
              if (picture == 'g12-fields') ...[
                _text('Equal source magnitudes: + on left, − on right'),
                _paint('charges', 120),
                _text(
                    'Small white dot: midpoint observation location. Charges and distances are schematic.'),
                _paint('fields', 100),
                _text(
                    'Component fields at that same midpoint, drawn on separate rows for visibility: cyan from + points away from +; amber from − points toward −. Both point right.'),
                _text(
                    'Equal distances and charge magnitudes give equal component magnitudes. The resultant field is twice either component, rightward. F = qE: a negative test charge feels force leftward.'),
              ],
              if (picture == 'g12-geology') ...[
                _text('0 half-lives · parent 100%, daughter 0%'),
                _paint('clock0', 50),
                _text('1 half-life · parent 50%, daughter 50%'),
                _paint('clock1', 50),
                _text('2 half-lives · parent 25%, daughter 75%'),
                _paint('clock2', 50),
                _text(
                    'Cyan = parent; amber = daughter produced. Each full bar represents the initial parent count. This ideal closed-system model assumes no initial daughter and no gain or loss other than decay.'),
              ],
              if (picture == 'g12-sampling') ...[
                _text('Four sampled quadrats · each 1 m²'),
                _paint('quadrats', 240),
                _text(
                    'Top left: 2 plants. Top right: 4. Bottom left: 3. Bottom right: 3. Circles represent counted plants, not their cover.'),
                _text(
                    'Density = 12 plants / 4 m² = 3 plants/m². Estimate for 100 m²: 3 × 100 = 300 plants, if these quadrats represent that area. Panels show counts, not field positions.'),
              ],
              if (picture == 'g12-diversity') ...[
                _text('Community A · 4 cyan + 4 amber'),
                _paint('diverseA', 100),
                _text('Community B · 7 cyan + 1 amber'),
                _paint('diverseB', 100),
                _text(
                    'One circle = one individual; color = species. Both have richness 2 and sample size 8.'),
                _text(
                    'Diversity convention: 1 − Σpᵢ². A: 1 − (0.5² + 0.5²) = 0.50. B: 1 − (0.875² + 0.125²) = 0.21875. More even abundances give A the larger value.'),
              ],
              if (picture == 'g12-niche') ...[
                _text(
                    'Upper cyan: without competitor. Lower amber: with competitor.'),
                _paint('niche', 130),
                _ticks(const ['0', '2', '4', '6', '8', '10']),
                _text('Soil moisture · illustrative relative units'),
                _text(
                    'Potential persistence: 2–8. Observed persistence with competition: 5–8. These invented intervals illustrate competitive restriction along one environmental dimension, not universal species limits.'),
                _text(
                    'A niche includes conditions and resources needed to persist. A species’ location alone does not reveal its full niche or prove competition.'),
              ],
            ]));
  }
}

class _Model extends CustomPainter {
  const _Model(this.model);
  final String model;
  static const cyan = Color(0xff66e0df);
  static const amber = Color(0xffffc568);
  static const white = Color(0xffe3ecff);
  void line(Canvas c, Offset a, Offset b, Color color, [double width = 2]) {
    c.drawLine(
        a,
        b,
        Paint()
          ..color = color
          ..strokeWidth = width);
  }

  void arrow(Canvas c, Offset a, Offset b, Color color) {
    line(c, a, b, color, 3);
    final angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
    for (final turn in [-.6, .6]) {
      line(c, b, b - Offset(math.cos(angle + turn), math.sin(angle + turn)) * 9,
          color, 3);
    }
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width;
    if (model == 'down') {
      arrow(c, Offset(w / 2, 1), Offset(w / 2, 28), cyan);
    } else if (model == 'equilibrium') {
      final left = w / 10;
      final span = w * .8;
      for (var i = 0; i <= 4; i++) {
        final x = left + span * i / 4;
        line(c, Offset(x, 10), Offset(x, 152), white.withValues(alpha: .2));
      }
      c.drawRect(Rect.fromLTWH(left, 30, span * .2, 30), Paint()..color = cyan);
      c.drawRect(
          Rect.fromLTWH(left, 90, span * .8, 30), Paint()..color = amber);
      line(c, Offset(left, 150), Offset(left + span, 150), white);
    } else if (model == 'rates') {
      arrow(c, Offset(w * .2, 20), Offset(w * .8, 20), cyan);
      arrow(c, Offset(w * .8, 58), Offset(w * .2, 58), amber);
    } else if (model == 'charges') {
      for (final fraction in [.15, .85]) {
        final center = Offset(w * fraction, 60);
        c.drawCircle(center, 22, Paint()..color = fraction < .5 ? cyan : amber);
        line(c, center - const Offset(10, 0), center + const Offset(10, 0),
            const Color(0xff101b36), 3);
        if (fraction < .5) {
          line(c, center - const Offset(0, 10), center + const Offset(0, 10),
              const Color(0xff101b36), 3);
        }
      }
      c.drawCircle(Offset(w / 2, 60), 4, Paint()..color = white);
    } else if (model == 'fields') {
      arrow(c, Offset(w * .3, 25), Offset(w * .7, 25), cyan);
      arrow(c, Offset(w * .3, 70), Offset(w * .7, 70), amber);
    } else if (model.startsWith('clock')) {
      final fraction = model == 'clock0'
          ? 1.0
          : model == 'clock1'
              ? .5
              : .25;
      c.drawRect(Rect.fromLTWH(8, 2, w - 16, 30), Paint()..color = amber);
      c.drawRect(
          Rect.fromLTWH(8, 2, (w - 16) * fraction, 30), Paint()..color = cyan);
    } else if (model == 'quadrats') {
      const counts = [2, 4, 3, 3];
      for (var q = 0; q < 4; q++) {
        final rect = Rect.fromLTWH(
            8 + (q % 2) * w / 2, 8.0 + (q ~/ 2) * 116.0, w / 2 - 16, 100);
        c.drawRect(
            rect,
            Paint()
              ..color = white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
        for (var p = 0; p < counts[q]; p++) {
          c.drawCircle(
              Offset(rect.left + rect.width * (.3 + .4 * (p % 2)),
                  rect.top + 30 + 40 * (p ~/ 2)),
              7,
              Paint()..color = cyan);
        }
      }
    } else if (model.startsWith('diverse')) {
      for (var i = 0; i < 8; i++) {
        c.drawCircle(Offset((i % 4 + .5) * w / 4, 23.0 + 48.0 * (i ~/ 4)), 12,
            Paint()..color = i < (model == 'diverseA' ? 4 : 7) ? cyan : amber);
      }
    } else if (model == 'niche') {
      double x(double value) => w / 12 + value / 10 * w * 5 / 6;
      for (var i = 0; i <= 10; i += 2) {
        line(c, Offset(x(i.toDouble()), 10), Offset(x(i.toDouble()), 122),
            white.withValues(alpha: .25));
      }
      line(c, Offset(x(2), 40), Offset(x(8), 40), cyan, 14);
      line(c, Offset(x(5), 85), Offset(x(8), 85), amber, 14);
      line(c, Offset(x(0), 122), Offset(x(10), 122), white);
    }
  }

  @override
  bool shouldRepaint(covariant _Model oldDelegate) =>
      oldDelegate.model != model;
}
