import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/science/science_figure.dart';
import 'science_picture.dart';

/// Offline diagrams with readable, selectable labels and semantic models.
class ScienceFigureView extends StatelessWidget {
  const ScienceFigureView({required this.figure, super.key});

  final ScienceFigure figure;

  @override
  Widget build(BuildContext context) {
    figure.validate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(figure.title,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        ),
        const SizedBox(height: 12),
        if (figure.picture.isNotEmpty) ...[
          SciencePicture(picture: figure.picture),
          const SizedBox(height: 16),
        ],
        switch (figure.kind) {
          'process' || 'cycle' => _stages(),
          'bars' => _bars(),
          'particles' => _particles(),
          _ => _comparison(),
        },
        if (figure.note.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(figure.note, style: const TextStyle(fontSize: 13)),
        ],
      ],
    );
  }

  Widget _panel(int index, {Widget? model}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: NorieColors.green.withValues(alpha: 0.08),
          border: Border.all(color: NorieColors.green.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(figure.labels[index],
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (model != null) ...[const SizedBox(height: 8), model],
            const SizedBox(height: 6),
            Text(figure.details[index]),
          ],
        ),
      );

  Widget _stages() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < figure.labels.length; index++) ...[
            _panel(index),
            if (index < figure.labels.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Icon(Icons.arrow_downward,
                    color: NorieColors.green,
                    semanticLabel:
                        '${figure.labels[index]} leads to ${figure.labels[index + 1]}'),
              ),
          ],
          if (figure.kind == 'cycle')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.loop, color: NorieColors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Returns to ${figure.labels.first}')),
                ],
              ),
            ),
        ],
      );

  Widget _comparison() => LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 440 ? 2 : 1;
        final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
        return Wrap(spacing: 10, runSpacing: 10, children: [
          for (var index = 0; index < figure.labels.length; index++)
            SizedBox(width: width, child: _panel(index)),
        ]);
      });

  String _measure(double value) {
    final number = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
    return figure.unit.isEmpty ? number : '$number ${figure.unit}';
  }

  Widget _bars() {
    if (figure.values.any((value) => !value.isFinite || value < 0)) {
      throw ArgumentError('Science bars require finite nonnegative values.');
    }
    final maximum = figure.values.reduce(math.max);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Scale: 0–${_measure(maximum)}'),
      const SizedBox(height: 8),
      for (var index = 0; index < figure.labels.length; index++) ...[
        _panel(index,
            model: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_measure(figure.values[index])),
                  const SizedBox(height: 4),
                  LayoutBuilder(
                      builder: (context, constraints) => Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              key: ValueKey('science-bar-fill-$index'),
                              width: maximum == 0
                                  ? 0
                                  : constraints.maxWidth *
                                      figure.values[index] /
                                      maximum,
                              height: 18,
                              color: NorieColors.green,
                            ),
                          )),
                ])),
        if (index < figure.labels.length - 1) const SizedBox(height: 10),
      ],
    ]);
  }

  Widget _particles() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < 3; index++) ...[
            _panel(index,
                model: Semantics(
                  label: '${figure.labels[index]} particle model: ${const [
                    'closely packed in ordered rows.',
                    'close together with an irregular arrangement.',
                    'widely spaced throughout the container.'
                  ][index]}',
                  child: SizedBox(
                    height: 110,
                    child: CustomPaint(painter: _ParticlePainter(index)),
                  ),
                )),
            if (index < 2) const SizedBox(height: 10),
          ],
        ],
      );
}

/// Only particle shapes are painted; words remain in the widget tree.
class _ParticlePainter extends CustomPainter {
  const _ParticlePainter(this.state);
  final int state;

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = NorieColors.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
        border);
    final dots = Paint()..color = NorieColors.cyan;
    // Equal numbers and sizes avoid suggesting that states change particle size
    // or create particles. The solid lattice vibrates in place in reality.
    const liquid = [
      Offset(.36, .58),
      Offset(.46, .61),
      Offset(.57, .57),
      Offset(.66, .64),
      Offset(.33, .72),
      Offset(.43, .75),
      Offset(.54, .70),
      Offset(.64, .78),
      Offset(.37, .87),
      Offset(.48, .88),
      Offset(.59, .85),
      Offset(.69, .90),
    ];
    const gas = [
      Offset(.08, .13),
      Offset(.34, .20),
      Offset(.58, .10),
      Offset(.86, .18),
      Offset(.18, .43),
      Offset(.42, .51),
      Offset(.69, .41),
      Offset(.91, .49),
      Offset(.09, .83),
      Offset(.35, .78),
      Offset(.62, .90),
      Offset(.85, .79),
    ];
    for (var i = 0; i < 12; i++) {
      final position = switch (state) {
        0 => Offset(.35 + (i % 4) * .10, .60 + (i ~/ 4) * .14),
        1 => liquid[i],
        _ => gas[i],
      };
      canvas.drawCircle(
          Offset(position.dx * size.width, position.dy * size.height), 4, dots);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.state != state;
}
