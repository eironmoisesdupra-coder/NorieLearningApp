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

String norieNormalizeAnswer(String value) => value
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

bool norieAnswerMatches(String input, String expected) =>
    norieNormalizeAnswer(input) == norieNormalizeAnswer(expected);
