import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../domain/norie_content_models.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../data/norie_foundation_curriculum.dart';

Future<bool> norieRecordPracticeEvidence(
    BuildContext context,
    NorieTopicContent topic,
    String attemptId,
    List<QuizAnswerRecord> answers,
    int ownershipRevision,
    {bool Function()? stillCurrent}) async {
  if (stillCurrent?.call() == false) return false;
  // Starter completion stays valid, but generic preview items cannot certify
  // independent understanding of the real subject.
  if (!NorieFoundationCurriculum.isAuthored(topic)) return true;
  try {
    final recorded = await NorieAdventureProgress.instance.recordAttempt(
        topicId: topic.id,
        attemptId: attemptId,
        answers: answers,
        expectedRevision: ownershipRevision);
    if (!recorded && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'This attempt belongs to a previous learner. Return to the lesson to start again.')));
    }
    return recorded && stillCurrent?.call() != false;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Your evidence could not be saved. Please try again before leaving.')));
    }
    return false;
  }
}

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
