import 'dart:math';

import '../domain/norie_content_models.dart';

enum NorieActivityMode {
  mixed,
  multipleChoice,
  identification,
  matching,
  dragAndDrop,
  trueFalse,
  ordering,
  flashcards,
  fillInBlank,
}

extension NorieActivityModeLabel on NorieActivityMode {
  String get label => switch (this) {
        NorieActivityMode.mixed => 'Random Mix',
        NorieActivityMode.multipleChoice => 'Multiple Choice',
        NorieActivityMode.identification => 'Identification',
        NorieActivityMode.matching => 'Matching',
        NorieActivityMode.dragAndDrop => 'Drag & Drop',
        NorieActivityMode.trueFalse => 'True / False',
        NorieActivityMode.ordering => 'Ordering',
        NorieActivityMode.flashcards => 'Flashcards',
        NorieActivityMode.fillInBlank => 'Fill in the Blank',
      };
}

class NorieRandomizedQuestion {
  const NorieRandomizedQuestion({
    required this.source,
    required this.options,
    required this.correctIndex,
  });

  final NorieQuestionContent source;
  final List<String> options;
  final int correctIndex;
}

/// Creates a fresh assessment session.
///
/// Both the question order and each multiple-choice option order are shuffled.
/// Correct-answer identity is carried by value before the option shuffle so the
/// answer key remains valid.
abstract final class NorieItemRandomizer {
  static List<NorieRandomizedQuestion> randomize(
    List<NorieQuestionContent> questions, {
    Random? random,
    bool byDifficulty = false,
  }) {
    final rng = random ?? Random.secure();
    final items = questions.map((question) {
      if (!question.hasValidAnswer) {
        return NorieRandomizedQuestion(
          source: question,
          options: List<String>.from(question.options),
          correctIndex: question.correctIndex,
        );
      }

      final correctValue = question.options[question.correctIndex];
      final options = List<String>.from(question.options)..shuffle(rng);
      return NorieRandomizedQuestion(
        source: question,
        options: options,
        correctIndex: options.indexOf(correctValue),
      );
    }).toList()
      ..shuffle(rng);

    if (byDifficulty) {
      // Shuffle inside each tier while keeping the learning progression.
      const tiers = ['foundation', 'intermediate', 'advanced'];
      return [
        for (final tier in tiers)
          ...items.where((item) => item.source.difficulty == tier),
        ...items.where((item) => !tiers.contains(item.source.difficulty)),
      ];
    }
    return items;
  }

  static NorieActivityMode randomMode({
    required NorieQuestionContent question,
    Random? random,
  }) {
    final rng = random ?? Random.secure();
    final candidates = <NorieActivityMode>[
      NorieActivityMode.multipleChoice,
      NorieActivityMode.identification,
      NorieActivityMode.trueFalse,
      NorieActivityMode.flashcards,
      NorieActivityMode.fillInBlank,
    ];
    return candidates[rng.nextInt(candidates.length)];
  }
}

/// Science content never turns a phrase or a numerical result into a
/// one-word identification exercise. Other subject policies remain unchanged.
abstract final class NorieSciencePracticePolicy {
  static bool usesTiers(NorieTopicContent topic) =>
      (topic.subject.toLowerCase() == 'science' && topic.gradeLevel != 'g1') ||
      topic.quiz.questions.map((q) => q.difficulty).toSet().length > 1;

  static bool canIdentify(NorieQuestionContent question) {
    final answers = question.resolvedAcceptedAnswers;
    return answers.isNotEmpty &&
        answers.every((answer) =>
            answer == answer.trim() && RegExp(r'^[A-Za-z]+$').hasMatch(answer));
  }

  static NorieActivityMode resolve(
          NorieActivityMode requested, NorieQuestionContent question) =>
      requested == NorieActivityMode.identification && !canIdentify(question)
          ? NorieActivityMode.multipleChoice
          : requested;
}

String norieNormalizeAnswer(String value) {
  final normalized = value
      .trim()
      .toLowerCase()
      .replaceAll('−', '-')
      .replaceAll('×', '*')
      .replaceAll('÷', '/');
  // A decimal point, negative sign or fraction bar changes the answer.
  // Word recall retains its existing case/punctuation tolerance.
  final numeric = RegExp(r'[0-9⁰¹²³⁴⁵⁶⁷⁸⁹]').hasMatch(normalized);
  return normalized
      .replaceAll(
          numeric
              ? RegExp(
                  r'[^a-z0-9+*/=().\-\u00b2\u00b3\u2070-\u2079\u03b1-\u03c9]+')
              : RegExp(r'[^a-z0-9]+'),
          ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

bool norieAnswerMatches(String input, String expected) =>
    norieNormalizeAnswer(input) == norieNormalizeAnswer(expected);
