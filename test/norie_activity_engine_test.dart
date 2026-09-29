import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/application/norie_activity_engine.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

void main() {
  NorieQuestionContent question(
    String id,
    String correct,
    List<String> distractors,
  ) {
    final options = <String>[correct, ...distractors];
    return NorieQuestionContent(
      id: id,
      prompt: 'Prompt $id',
      options: options,
      correctIndex: 0,
      explanation: 'Explanation',
    );
  }

  test('randomizer preserves the correct answer after option shuffle', () {
    final source = [
      question('q1', 'Alpha', ['Beta', 'Gamma', 'Delta']),
      question('q2', 'One', ['Two', 'Three', 'Four']),
      question('q3', 'Red', ['Blue', 'Green', 'Yellow']),
    ];

    final randomized = NorieItemRandomizer.randomize(
      source,
      random: Random(42),
    );

    expect(randomized, hasLength(3));
    for (final item in randomized) {
      final originalCorrect =
          item.source.options[item.source.correctIndex];
      expect(item.options[item.correctIndex], originalCorrect);
    }
  });

  test('randomizer changes both question and option order for seeded session', () {
    final source = [
      question('q1', 'A', ['B', 'C', 'D']),
      question('q2', 'E', ['F', 'G', 'H']),
      question('q3', 'I', ['J', 'K', 'L']),
      question('q4', 'M', ['N', 'O', 'P']),
      question('q5', 'Q', ['R', 'S', 'T']),
    ];

    final randomized = NorieItemRandomizer.randomize(
      source,
      random: Random(91),
    );

    expect(
      randomized.map((item) => item.source.id).toList(),
      isNot(source.map((item) => item.id).toList()),
    );
    expect(
      randomized.any(
        (item) =>
            item.options.join('|') != item.source.options.join('|'),
      ),
      isTrue,
    );
  });

  test('answer matching ignores case and punctuation differences', () {
    expect(norieAnswerMatches('  Sodium-Chloride ', 'sodium chloride'), isTrue);
    expect(norieAnswerMatches('NaCl', 'NaCl'), isTrue);
    expect(norieAnswerMatches('NaCl', 'H2O'), isFalse);
  });

  test('question model round-trips recall and ordering metadata', () {
    const source = NorieQuestionContent(
      id: 'sequence',
      prompt: 'Order these',
      options: ['A', 'B'],
      correctIndex: 0,
      explanation: 'Because.',
      acceptedAnswers: ['Alpha', 'A'],
      orderedItems: ['First', 'Second', 'Third'],
    );

    final restored = NorieQuestionContent.fromJson(source.toJson());

    expect(restored.acceptedAnswers, ['Alpha', 'A']);
    expect(restored.orderedItems, ['First', 'Second', 'Third']);
  });
}
