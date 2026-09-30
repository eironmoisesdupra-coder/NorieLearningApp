import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_hotspot_models.dart';
import '../domain/anatomy_hotspot_quiz_policy.dart';
import '../domain/anatomy_models.dart';
import 'anatomy_animated_backdrop.dart';
import 'anatomy_body_model.dart';
import 'anatomy_real_3d_model.dart';

class AnatomyQuizScreen extends StatefulWidget {
  const AnatomyQuizScreen({
    required this.selectedSystems,
    super.key,
  });

  final Set<AnatomySystemId> selectedSystems;

  @override
  State<AnatomyQuizScreen> createState() => _AnatomyQuizScreenState();
}

class _AnatomyQuizScreenState extends State<AnatomyQuizScreen> {
  final _random = Random.secure();

  late final List<_AnatomyQuestion> _questions;
  int _index = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _checked = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  List<_AnatomyQuestion> _buildQuestions() {
    final selectedStructures =
        AnatomyCatalog.structuresFor(widget.selectedSystems);
    final source = selectedStructures.isEmpty
        ? AnatomyCatalog.structuresFor(
            AnatomyCatalog.systems.map((item) => item.id).toSet(),
          )
        : selectedStructures;

    final shuffled = List<AnatomyStructure>.from(source)..shuffle(_random);
    final targets = shuffled.take(min(12, shuffled.length)).toList();

    return [
      for (var i = 0; i < targets.length; i++)
        _makeQuestion(targets[i], i),
    ];
  }

  _AnatomyQuestion _makeQuestion(AnatomyStructure target, int index) {
    final system = AnatomyCatalog.byId(target.system);
    final pool = <AnatomyStructure>[
      for (final structure in system.structures)
        if (structure.id != target.id) structure,
      for (final otherSystem in AnatomyCatalog.systems)
        if (otherSystem.id != target.system) ...otherSystem.structures,
    ]..shuffle(_random);

    final distractors = pool
        .where((item) => item.name != target.name)
        .take(3)
        .map((item) => item.name)
        .toList();
    final names = <String>[target.name, ...distractors]..shuffle(_random);

    final mode = index % 3;
    return _AnatomyQuestion(
      target: target,
      system: system,
      prompt: switch (mode) {
        0 => 'Identify the numbered structure.',
        1 => 'Which structure matches this function?\n${target.function}',
        _ => 'Which structure belongs to the ${system.label} system and is described as: ${target.description}',
      },
      options: names,
      correctIndex: names.indexOf(target.name),
      showVisual: mode == 0,
    );
  }

  void _check() {
    if (_checked || _selectedIndex == null) return;
    final correct = _selectedIndex == _questions[_index].correctIndex;
    if (correct) _score++;

    NorieProgression.instance.recordTopicAnswer(
      category: 'Anatomy',
      topic: _questions[_index].system.label,
      correct: correct,
    );

    setState(() => _checked = true);
  }

  void _next() {
    if (!_checked) return;
    if (_index == _questions.length - 1) {
      NorieProgression.instance.addXp(_score * 10);
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _index++;
      _selectedIndex = null;
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AnatomyAnimatedBackdrop()),
          SafeArea(
            child: _finished ? _results() : _quiz(),
          ),
        ],
      ),
    );
  }

  Widget _quiz() {
    final question = _questions[_index];
    final progress = (_index + 1) / _questions.length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close_rounded),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Anatomy Identification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${_index + 1}/${_questions.length}',
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              borderRadius: BorderRadius.circular(99),
              color: question.system.color,
              backgroundColor: NorieColors.surfaceElevated,
            ),
            const SizedBox(height: 18),
            _SystemPill(system: question.system),
            const SizedBox(height: 10),
            Text(
              question.prompt,
              style: const TextStyle(
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (question.showVisual) ...[
              const SizedBox(height: 16),
              _QuestionVisual(question: question),
            ],
            const SizedBox(height: 18),
            for (var i = 0; i < question.options.length; i++) ...[
              _AnswerTile(
                label: question.options[i],
                selected: _selectedIndex == i,
                checked: _checked,
                correct: i == question.correctIndex,
                color: question.system.color,
                onTap: _checked
                    ? null
                    : () => setState(() => _selectedIndex = i),
              ),
              const SizedBox(height: 9),
            ],
            if (_checked) ...[
              const SizedBox(height: 6),
              _Feedback(
                correct: _selectedIndex == question.correctIndex,
                structure: question.target,
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _selectedIndex == null
                  ? null
                  : (_checked ? _next : _check),
              style: FilledButton.styleFrom(
                backgroundColor: question.system.color,
                foregroundColor: NorieColors.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _checked
                    ? (_index == _questions.length - 1
                        ? 'View results'
                        : 'Next anatomy item')
                    : 'Check answer',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _results() {
    final accuracy =
        _questions.isEmpty ? 0 : (_score / _questions.length * 100).round();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF10295A),
                  Color(0xFF281B60),
                  Color(0xFF351747),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: NorieColors.cyan.withValues(alpha: .45),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.biotech_rounded,
                  size: 58,
                  color: NorieColors.cyan,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Anatomy Round Complete',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_score / ${_questions.length} · $accuracy%',
                  style: const TextStyle(
                    color: NorieColors.cyan,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+${_score * 10} XP · mastery updated for the systems you practiced',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.view_in_ar_rounded),
                    label: const Text('Return to Anatomy Lab'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnatomyQuestion {
  const _AnatomyQuestion({
    required this.target,
    required this.system,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.showVisual,
  });

  final AnatomyStructure target;
  final AnatomySystem system;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final bool showVisual;
}

class _QuestionVisual extends StatelessWidget {
  const _QuestionVisual({required this.question});

  final _AnatomyQuestion question;

  @override
  Widget build(BuildContext context) {
    final realHotspot =
        AnatomyHotspotQuizPolicy.hotspotForStructureId(question.target.id);

    return Container(
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: NorieColors.surface.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: question.system.color.withValues(alpha: .35),
        ),
      ),
      child: realHotspot != null
          ? AnatomyReal3DModel(
              cameraOrbit: '0deg 75deg 4.5m',
              cameraTarget: '0m 0m 0m',
              autoRotate: false,
              enableTouch: true,
              hotspots:
                  AnatomyHotspotQuizPolicy.quizHotspotsFor(realHotspot),
              hotspotMode: AnatomyHotspotMode.quiz,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                const width = 180.0;
                const height = 280.0;
                final markerX = width * question.target.x;
                final markerY = height * question.target.y;

                return Center(
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        AnatomyBodyModel(
                          selectedSystems: {question.system.id},
                          opacity: .95,
                        ),
                        Positioned(
                          left: markerX - 16,
                          top: markerY - 16,
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: question.system.color,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: question.system.color
                                      .withValues(alpha: .55),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _SystemPill extends StatelessWidget {
  const _SystemPill({required this.system});
  final AnatomySystem system;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: system.color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: system.color.withValues(alpha: .4)),
        ),
        child: Text(
          system.label.toUpperCase(),
          style: TextStyle(
            color: system.color,
            fontSize: 9,
            letterSpacing: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.label,
    required this.selected,
    required this.checked,
    required this.correct,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool checked;
  final bool correct;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var border = selected ? color : NorieColors.border;
    var fill = NorieColors.surface.withValues(alpha: .78);

    if (checked && correct) {
      border = NorieColors.green;
      fill = NorieColors.green.withValues(alpha: .11);
    } else if (checked && selected && !correct) {
      border = NorieColors.magenta;
      fill = NorieColors.magenta.withValues(alpha: .11);
    }

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              if (checked && correct)
                const Icon(
                  Icons.check_circle_rounded,
                  color: NorieColors.green,
                )
              else if (checked && selected)
                const Icon(
                  Icons.cancel_rounded,
                  color: NorieColors.magenta,
                )
              else if (selected)
                Icon(Icons.radio_button_checked_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.correct,
    required this.structure,
  });

  final bool correct;
  final AnatomyStructure structure;

  @override
  Widget build(BuildContext context) {
    final color = correct ? NorieColors.green : NorieColors.magenta;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: .55)),
      ),
      child: Text(
        correct
            ? '${structure.name}: ${structure.function}'
            : 'Answer: ${structure.name}\n${structure.description}\nFunction: ${structure.function}',
        style: const TextStyle(
          color: NorieColors.textSecondary,
          height: 1.4,
          fontSize: 11,
        ),
      ),
    );
  }
}
