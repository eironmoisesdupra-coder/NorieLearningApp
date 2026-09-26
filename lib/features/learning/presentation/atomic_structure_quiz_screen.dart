import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import 'atom_challenge_screen.dart';

class AtomicStructureQuizScreen extends StatefulWidget {
  const AtomicStructureQuizScreen({super.key});

  @override
  State<AtomicStructureQuizScreen> createState() =>
      _AtomicStructureQuizScreenState();
}

class _AtomicStructureQuizScreenState
    extends State<AtomicStructureQuizScreen> {
  static const _questions = <_QuizQuestion>[
    _QuizQuestion(
      prompt: 'Which particle determines an element\'s atomic number?',
      options: ['Electron', 'Proton', 'Neutron', 'Ion'],
      correctIndex: 1,
      explanation:
          'Atomic number is defined by the number of protons in the nucleus.',
    ),
    _QuizQuestion(
      prompt: 'Which subatomic particle has a negative charge?',
      options: ['Proton', 'Neutron', 'Electron', 'Nucleus'],
      correctIndex: 2,
      explanation:
          'Electrons carry negative charge and occupy regions around the nucleus.',
    ),
    _QuizQuestion(
      prompt: 'Where are protons and neutrons located?',
      options: [
        'Electron cloud',
        'Nucleus',
        'Outer shell only',
        'Between atoms',
      ],
      correctIndex: 1,
      explanation:
          'Protons and neutrons are concentrated in the atomic nucleus.',
    ),
    _QuizQuestion(
      prompt: 'A neutral atom has 8 protons. How many electrons does it have?',
      options: ['4', '8', '10', '16'],
      correctIndex: 1,
      explanation:
          'A neutral atom has equal numbers of positive protons and negative electrons.',
    ),
    _QuizQuestion(
      prompt:
          'Atoms of the same element with different neutron counts are called...',
      options: ['Ions', 'Compounds', 'Isotopes', 'Molecules'],
      correctIndex: 2,
      explanation:
          'Isotopes have the same proton count but different numbers of neutrons.',
    ),
  ];

  int _current = 0;
  int? _selectedIndex;
  int _score = 0;
  bool _checked = false;

  void _checkAnswer() {
    if (_selectedIndex == null || _checked) return;
    setState(() {
      _checked = true;
      if (_selectedIndex == _questions[_current].correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (!_checked) return;

    if (_current == _questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => AtomChallengeScreen(quizScore: _score),
        ),
      );
      return;
    }

    setState(() {
      _current++;
      _selectedIndex = null;
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_current];
    final progress = (_current + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Check'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(99),
                        color: NorieColors.cyan,
                        backgroundColor: NorieColors.surfaceElevated,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_current + 1}/${_questions.length}',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'ATOMIC STRUCTURE',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: NorieColors.violet,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 22),
                ...List.generate(
                  question.options.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: _AnswerOption(
                      label: question.options[index],
                      selected: _selectedIndex == index,
                      checked: _checked,
                      correct: index == question.correctIndex,
                      onTap: _checked
                          ? null
                          : () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                    ),
                  ),
                ),
                if (_checked) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedIndex == question.correctIndex
                          ? NorieColors.green.withValues(alpha: .12)
                          : NorieColors.magenta.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedIndex == question.correctIndex
                            ? NorieColors.green
                            : NorieColors.magenta,
                      ),
                    ),
                    child: Text(
                      question.explanation,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _selectedIndex == null
                      ? null
                      : (_checked ? _next : _checkAnswer),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _checked
                        ? (_current == _questions.length - 1
                            ? 'Continue to challenge'
                            : 'Next question')
                        : 'Check answer',
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

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.checked,
    required this.correct,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool checked;
  final bool correct;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = selected ? NorieColors.cyan : NorieColors.border;
    Color fillColor = NorieColors.surface;
    IconData? statusIcon;

    if (checked && correct) {
      borderColor = NorieColors.green;
      fillColor = NorieColors.green.withValues(alpha: .10);
      statusIcon = Icons.check_circle_rounded;
    } else if (checked && selected && !correct) {
      borderColor = NorieColors.magenta;
      fillColor = NorieColors.magenta.withValues(alpha: .10);
      statusIcon = Icons.cancel_rounded;
    }

    return Material(
      color: fillColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (statusIcon != null)
                Icon(statusIcon, color: borderColor)
              else if (selected)
                const Icon(
                  Icons.radio_button_checked,
                  color: NorieColors.cyan,
                )
              else
                const Icon(
                  Icons.radio_button_unchecked,
                  color: NorieColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
