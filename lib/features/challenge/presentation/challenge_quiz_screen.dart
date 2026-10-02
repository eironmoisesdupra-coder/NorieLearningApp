import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/mascot/norie_mascot_scope.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/challenge_question.dart';
import 'challenge_results_screen.dart';

class ChallengeQuizScreen extends StatefulWidget {
  const ChallengeQuizScreen({
    required this.mode,
    super.key,
  });

  final NorieChallengeMode mode;

  @override
  State<ChallengeQuizScreen> createState() => _ChallengeQuizScreenState();
}

class _ChallengeQuizScreenState extends State<ChallengeQuizScreen> {
  final _attemptId = const Uuid().v4();
  final List<QuizAnswerRecord> _answers = [];
  late final Object _audioToken;
  late final List<ChallengeQuestion> _questions;
  Timer? _timer;

  int _current = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _checked = false;
  bool _finished = false;
  int _remainingSeconds = NorieChallengeRules.speedDurationSeconds;

  bool get _isSpeed => widget.mode == NorieChallengeMode.speed;

  @override
  void initState() {
    super.initState();
    _audioToken =
        NorieAudioManager.instance.enterContext(NorieAudioContext.quiz);
    NorieAudioManager.instance.playChallengeStart();
    _questions = _isSpeed
        ? NorieChallengeBank.speedQuestions()
        : NorieChallengeBank.dailyQuestions();

    if (_isSpeed) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || _finished) return;

        if (_remainingSeconds <= 1) {
          setState(() => _remainingSeconds = 0);
          timer.cancel();
          _finish();
          return;
        }

        setState(() => _remainingSeconds--);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    NorieAudioManager.instance.leaveContext(_audioToken);
    super.dispose();
  }

  void _select(int index) {
    if (_checked || _finished) return;
    NorieAudioManager.instance.playQuizSelect();
    setState(() => _selectedIndex = index);
  }

  void _checkAnswer() {
    if (_selectedIndex == null || _checked || _finished) return;

    final question = _questions[_current];
    final isCorrect = _selectedIndex == question.correctIndex;
    _answers.add(QuizAnswerRecord(
        questionId: question.id,
        prompt: question.prompt,
        response: question.options[_selectedIndex!],
        correctAnswer: question.options[question.correctIndex],
        explanation: question.explanation,
        correct: isCorrect,
        conceptId: '${question.category}:${question.topic}',
        conceptLabel: question.topic));
    if (isCorrect) {
      NorieAudioManager.instance.playCorrect();
    } else {
      NorieAudioManager.instance.playWrong();
    }

    NorieProgression.instance.recordTopicAnswer(
      category: question.category,
      topic: question.topic,
      correct: isCorrect,
    );

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

  void _next() {
    if (!_checked || _finished) return;

    if (_current == _questions.length - 1) {
      _finish();
      return;
    }

    setState(() {
      _current++;
      _selectedIndex = null;
      _checked = false;
    });
  }

  void _finish() {
    if (_finished || !mounted) return;
    _finished = true;
    _timer?.cancel();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeResultsScreen(
          mode: widget.mode,
          attemptId: _attemptId,
          answers: List.unmodifiable([
            ..._answers,
            for (final question in _questions
                .where((q) => !_answers.any((a) => a.questionId == q.id)))
              QuizAnswerRecord(
                  questionId: question.id,
                  prompt: question.prompt,
                  response: 'Not answered before time ended',
                  correctAnswer: question.options[question.correctIndex],
                  explanation: question.explanation,
                  correct: false,
                  unanswered: true,
                  conceptId: '${question.category}:${question.topic}',
                  conceptLabel: question.topic),
          ]),
          historyKey: quizHistoryKey(
              'challenge:${widget.mode.name}',
              _questions.map((q) => jsonEncode([
                    q.id,
                    q.prompt,
                    q.options[q.correctIndex],
                    q.options.toList()..sort()
                  ]))),
          correct: _score,
          total: _questions.length,
          secondsRemaining: _isSpeed ? _remainingSeconds : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_current];
    final progress = (_current + 1) / _questions.length;
    final correct = _selectedIndex == question.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSpeed ? 'Speed Quiz' : 'Daily Challenge'),
        backgroundColor: Colors.transparent,
        actions: [
          if (_isSpeed)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: _TimerPill(seconds: _remainingSeconds),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(99),
                        color:
                            _isSpeed ? NorieColors.orange : NorieColors.magenta,
                        backgroundColor: NorieColors.surfaceElevated,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_current + 1}/${_questions.length}',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _TopicPill(
                      text: question.category,
                      color: NorieColors.cyan,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: _TopicPill(
                        text: question.topic,
                        color: NorieColors.violet,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(height: 22),
                for (var index = 0; index < question.options.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: _ChallengeAnswer(
                      label: question.options[index],
                      selected: _selectedIndex == index,
                      checked: _checked,
                      correct: index == question.correctIndex,
                      onTap: () => _select(index),
                    ),
                  ),
                if (_checked) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: correct
                          ? NorieColors.green.withValues(alpha: .10)
                          : NorieColors.magenta.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color:
                            correct ? NorieColors.green : NorieColors.magenta,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          correct
                              ? Icons.check_circle_rounded
                              : Icons.lightbulb_rounded,
                          color:
                              correct ? NorieColors.green : NorieColors.orange,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            question.explanation,
                            style: const TextStyle(
                              color: NorieColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _selectedIndex == null
                      ? null
                      : (_checked ? _next : _checkAnswer),
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        _isSpeed ? NorieColors.orange : NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _checked
                        ? (_current == _questions.length - 1
                            ? 'Finish challenge'
                            : 'Next question')
                        : 'Check answer',
                  ),
                ),
                if (_isSpeed) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'The timer keeps running while you review explanations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: NorieColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final urgent = seconds <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: (urgent ? NorieColors.magenta : NorieColors.orange)
            .withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: urgent ? NorieColors.magenta : NorieColors.orange,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 16,
            color: urgent ? NorieColors.magenta : NorieColors.orange,
          ),
          const SizedBox(width: 5),
          Text(
            '${seconds}s',
            style: TextStyle(
              color: urgent ? NorieColors.magenta : NorieColors.orange,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicPill extends StatelessWidget {
  const _TopicPill({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .4)),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ChallengeAnswer extends StatelessWidget {
  const _ChallengeAnswer({
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var border = selected ? NorieColors.cyan : NorieColors.border;
    var fill = NorieColors.surface;
    IconData? status;
    Color? statusColor;

    if (checked && correct) {
      border = NorieColors.green;
      fill = NorieColors.green.withValues(alpha: .09);
      status = Icons.check_circle_rounded;
      statusColor = NorieColors.green;
    } else if (checked && selected && !correct) {
      border = NorieColors.magenta;
      fill = NorieColors.magenta.withValues(alpha: .09);
      status = Icons.cancel_rounded;
      statusColor = NorieColors.magenta;
    }

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: checked ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (status != null)
                Icon(status, color: statusColor)
              else
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color:
                      selected ? NorieColors.cyan : NorieColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
