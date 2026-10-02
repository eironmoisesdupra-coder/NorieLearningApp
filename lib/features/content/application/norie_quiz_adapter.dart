import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../domain/norie_content_models.dart';

int? norieQuizGrade(NorieTopicContent topic) =>
    int.tryParse((topic.gradeLevel ?? '').replaceFirst('g', ''));

Future<void> norieEmptyContentQuiz(
    BuildContext context, NorieTopicContent topic, String mode) async {
  await NorieQuizOutro.show(context,
      summary: QuizResultSummary(
          attemptId: const Uuid().v4(),
          historyKey: norieContentHistoryKey(topic, mode, const []),
          title: topic.title,
          correctCount: 0,
          totalCount: 0,
          xpEarned: 0,
          gradeLevel: norieQuizGrade(topic),
          answers: const []),
      canRetry: false);
  if (context.mounted) Navigator.of(context).maybePop();
}

QuizAnswerRecord norieContentAnswer(
  NorieQuestionContent question, {
  required String response,
  required bool correct,
  String? prompt,
  String? correctAnswer,
  bool selfRated = false,
}) =>
    QuizAnswerRecord(
      questionId: question.id,
      prompt: prompt ?? question.prompt,
      response: response,
      correctAnswer:
          correctAnswer ?? question.resolvedAcceptedAnswers.join(' / '),
      explanation: question.explanation,
      correct: correct,
      conceptId: question.conceptId,
      conceptLabel: question.conceptLabel,
      selfRated: selfRated,
    );

String norieContentHistoryKey(NorieTopicContent topic, String mode,
        Iterable<NorieQuestionContent> questions) =>
    quizHistoryKey(
      'curriculum:${topic.id}:$mode',
      questions.map((q) => norieQuestionSignature(q, mode)),
    );

/// Include scored content and activity mode so only equivalent attempts compare.
String norieQuestionSignature(NorieQuestionContent q, String mode) =>
    jsonEncode([
      q.id,
      mode,
      q.prompt,
      q.resolvedAcceptedAnswers,
      q.options.toList()..sort(),
      q.orderedItems,
    ]);
