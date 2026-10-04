import 'package:uuid/uuid.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../application/norie_quiz_adapter.dart';
import '../application/norie_activity_engine.dart';
import 'package:flutter/material.dart';

import '../../../core/mascot/norie_mascot_scope.dart';
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
  final _attemptId = const Uuid().v4();
  final List<QuizAnswerRecord> _answers = [];
  late final _questions = NorieItemRandomizer.randomize(
      widget.topic.quiz.questions,
      byDifficulty: NorieSciencePracticePolicy.usesTiers(widget.topic));
  late final _audioToken =
      NorieAudioManager.instance.enterContext(NorieAudioContext.quiz);
  bool _finishing = false;
  @override
  void initState() {
    super.initState();
    _audioToken;
    if (_questions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          norieEmptyContentQuiz(context, widget.topic, 'multipleChoice');
        }
      });
    }
  }

  @override
  void dispose() {
    NorieAudioManager.instance.leaveContext(_audioToken);
    super.dispose();
  }

  int _current = 0;
  int? _selectedIndex;
  int _score = 0;
  bool _checked = false;

  void _checkAnswer() {
    if (_selectedIndex == null || _checked) return;
    final question = _questions[_current];
    final isCorrect = _selectedIndex == question.correctIndex;

    _answers.add(norieContentAnswer(question.source,
        response: question.options[_selectedIndex!], correct: isCorrect));
    if (isCorrect) {
      NorieAudioManager.instance.playCorrect();
    } else {
      NorieAudioManager.instance.playWrong();
    }
    setState(() {
      _checked = true;
      if (isCorrect) {
        _score++;
      }
    });

    if (isCorrect) {
      NorieMascotScope.maybeOf(context)?.controller.correct();
    }
  }

  Future<void> _next() async {
    if (!_checked || _finishing) return;

    if (_current == _questions.length - 1) {
      setState(() => _finishing = true);
      final action = await NorieQuizOutro.show(context,
          summary: QuizResultSummary(
              attemptId: _attemptId,
              historyKey: norieContentHistoryKey(
                  widget.topic, 'multipleChoice', widget.topic.quiz.questions),
              title: widget.topic.title,
              correctCount: _score,
              totalCount: _questions.length,
              xpEarned: 0,
              gradeLevel: norieQuizGrade(widget.topic),
              answers: List.unmodifiable(_answers)),
          canReviewLesson: true);
      if (!mounted) return;
      if (action == QuizOutroAction.reviewLesson) {
        Navigator.of(context).pop();
        return;
      }
      if (action == QuizOutroAction.retry) {
        Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (_) => NorieQuizScreen(topic: widget.topic)));
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => NorieChallengeScreen(
            topic: widget.topic,
            quizScore: _score,
            quizAnswers: List.unmodifiable(_answers),
            attemptId: _attemptId,
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
    if (_questions.isEmpty) {
      return const Scaffold(
          body: Center(child: Text('No questions available.')));
    }
    final questions = _questions;
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
                  question.source.prompt,
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
                          : () {
                              NorieAudioManager.instance.playQuizSelect();
                              setState(() => _selectedIndex = index);
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
                      question.source.explanation,
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
