import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../domain/norie_content_models.dart';
import 'norie_challenge_screen.dart';
import 'norie_content_theme.dart';

class NorieQuizScreen extends StatefulWidget {
  const NorieQuizScreen({
    required this.topic,
    super.key,
  });

  final NorieTopicContent topic;

  @override
  State<NorieQuizScreen> createState() => _NorieQuizScreenState();
}

class _NorieQuizScreenState extends State<NorieQuizScreen> {
  int _current = 0;
  int? _selectedIndex;
  int _score = 0;
  bool _checked = false;

  void _checkAnswer() {
    if (_selectedIndex == null || _checked) return;
    final question = widget.topic.quiz.questions[_current];

    setState(() {
      _checked = true;
      if (_selectedIndex == question.correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (!_checked) return;

    if (_current == widget.topic.quiz.questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => NorieChallengeScreen(
            topic: widget.topic,
            quizScore: _score,
          ),
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
    final questions = widget.topic.quiz.questions;
    final question = questions[_current];
    final progress = (_current + 1) / questions.length;
    final accent = norieContentAccent(widget.topic.accent);

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
                        color: accent,
                        backgroundColor: NorieColors.surfaceElevated,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_current + 1}/${questions.length}',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  widget.topic.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: accent,
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
                      accent: accent,
                      onTap: _checked
                          ? null
                          : () => setState(() => _selectedIndex = index),
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
                    backgroundColor: accent,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _checked
                        ? (_current == questions.length - 1
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
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool checked;
  final bool correct;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var borderColor = selected ? accent : NorieColors.border;
    var fillColor = NorieColors.surface;
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
                Icon(Icons.radio_button_checked, color: accent)
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
