import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/norie_study_models.dart';
import 'study_qa_screen.dart';
import 'study_quiz_screen.dart';

class StudyResultsScreen extends StatefulWidget {
  const StudyResultsScreen({
    required this.studySet,
    required this.answers,
    required this.result,
    this.attemptId,
    super.key,
  });

  final NorieStudySet studySet;
  final List<NorieStudyAnswer> answers;
  final NorieStudyAttemptResult result;
  final String? attemptId;

  @override
  State<StudyResultsScreen> createState() => _StudyResultsScreenState();
}

class _StudyResultsScreenState extends State<StudyResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showOutro();
    });
  }

  Future<void> _showOutro() async {
    final action = await NorieQuizOutro.show(context,
        canViewDetails: true,
        summary: QuizResultSummary(
            attemptId: widget.attemptId ?? const Uuid().v4(),
            historyKey: quizHistoryKey(
                'study:${widget.studySet.ownerId ?? 'local'}:${widget.studySet.id}',
                widget.studySet.questions.map((q) => jsonEncode([
                      q.id,
                      q.kind.name,
                      q.prompt,
                      q.correctValues,
                      q.options.toList()..sort(),
                      q.orderedItems
                    ]))),
            title: widget.studySet.title,
            correctCount: widget.result.correct,
            totalCount: widget.result.total,
            xpEarned: widget.result.xpAwarded,
            answers: [
              for (final answer in widget.answers)
                QuizAnswerRecord(
                    questionId: answer.question.id,
                    prompt: answer.question.prompt,
                    response: answer.response,
                    correctAnswer: answer.question.correctValues.join(' / '),
                    explanation: answer.question.explanation,
                    correct: answer.correct,
                    conceptId: answer.question.topicTag,
                    conceptLabel: answer.question.topicTag,
                    selfRated: answer.question.kind ==
                        NorieStudyQuestionKind.flashcard)
            ]));
    if (!mounted || action == QuizOutroAction.viewDetails) return;
    if (action == QuizOutroAction.retry) {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
          builder: (_) => StudyQuizScreen(studySet: widget.studySet)));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final missed = widget.answers.where((answer) => !answer.correct).toList();
    final percent = (widget.result.accuracy * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Results'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              children: [
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          NorieColors.cyan,
                          NorieColors.violet,
                          NorieColors.magenta,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.psychology_alt_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Study session complete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.studySet.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _ScoreCard(
                        label: 'Score',
                        value:
                            '${widget.result.correct} / ${widget.result.total}',
                        color: NorieColors.cyan,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ScoreCard(
                        label: 'Accuracy',
                        value: '$percent%',
                        color: NorieColors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ScoreCard(
                        label: 'XP',
                        value: '+${widget.result.xpAwarded}',
                        color: NorieColors.orange,
                      ),
                    ),
                  ],
                ),
                if (!widget.result.firstRewardedCompletion) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: NorieColors.violet.withValues(alpha: .07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: NorieColors.violet.withValues(alpha: .25),
                      ),
                    ),
                    child: const Text(
                      'This set already earned its completion XP. Retries still improve your study history and mastery, but do not award repeat XP.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (missed.isNotEmpty) ...[
                  const Text(
                    'Review mistakes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final answer in missed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _MistakeCard(answer: answer),
                    ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      final retrySet = NorieStudySet(
                        id: widget.studySet.id,
                        ownerId: widget.studySet.ownerId,
                        title: '${widget.studySet.title} · Mistake Review',
                        sourceType: widget.studySet.sourceType,
                        sourceName: widget.studySet.sourceName,
                        mode: widget.studySet.mode,
                        requestedCount: missed.length,
                        status: widget.studySet.status,
                        createdAt: widget.studySet.createdAt,
                        questions: [
                          for (final answer in missed) answer.question,
                        ],
                        topicTag: widget.studySet.topicTag,
                        aiModel: widget.studySet.aiModel,
                      );

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => StudyQuizScreen(
                            studySet: retrySet,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Retry Missed Items'),
                  ),
                ] else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NorieColors.green.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: NorieColors.green.withValues(alpha: .4),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: NorieColors.green,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'No missed items in this session.',
                            style: TextStyle(
                              color: NorieColors.green,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            StudyQaScreen(studySet: widget.studySet),
                      ),
                    );
                  },
                  icon: const Icon(Icons.question_answer_rounded),
                  label: const Text('Ask Norie About This Source'),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Study Set'),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  const _MistakeCard({required this.answer});

  final NorieStudyAnswer answer;

  @override
  Widget build(BuildContext context) {
    final question = answer.question;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: NorieColors.magenta.withValues(alpha: .3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Your answer: ${answer.response}',
            style: const TextStyle(
              color: NorieColors.magenta,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Answer: ${question.correctValues.join(' / ')}',
            style: const TextStyle(
              color: NorieColors.green,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (question.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.explanation,
              style: const TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
          if (question.sourceExcerpt.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Source: “${question.sourceExcerpt}”',
              style: const TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
