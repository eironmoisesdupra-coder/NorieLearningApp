import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/application/norie_activity_engine.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/presentation/norie_practice_mode_screen.dart';

NorieQuestionContent item(String answer, String difficulty) =>
    NorieQuestionContent(
      id: '$answer-$difficulty',
      prompt: 'Name this concept',
      options: [answer, 'Other', 'Third', 'Fourth'],
      correctIndex: 0,
      explanation: 'Explanation',
      difficulty: difficulty,
    );

void main() {
  test('Science identification requires an actual single trimmed word', () {
    for (final answer in ['Photosynthesis', 'Nucleus', 'Evaporation']) {
      expect(NorieSciencePracticePolicy.canIdentify(item(answer, 'foundation')),
          isTrue);
    }
    for (final answer in [
      '',
      'solar system',
      'cell\tmembrane',
      ' water',
      '30',
      'Newtons law'
    ]) {
      expect(NorieSciencePracticePolicy.canIdentify(item(answer, 'foundation')),
          isFalse);
    }
    expect(
        NorieSciencePracticePolicy.resolve(NorieActivityMode.identification,
            item('Solar system', 'foundation')),
        NorieActivityMode.multipleChoice);
  });

  test(
      'tiered sessions preserve all items and answer keys while shuffling within tiers',
      () {
    final source = [
      for (final level in ['advanced', 'foundation', 'intermediate'])
        for (var i = 0; i < 7; i++) item('$level$i', level),
    ];
    final output = NorieItemRandomizer.randomize(source,
        random: Random(73), byDifficulty: true);
    expect(output.map((q) => q.source.id).toSet(),
        source.map((q) => q.id).toSet());
    expect(output.take(7).every((q) => q.source.difficulty == 'foundation'),
        isTrue);
    expect(
        output
            .skip(7)
            .take(7)
            .every((q) => q.source.difficulty == 'intermediate'),
        isTrue);
    expect(output.skip(14).every((q) => q.source.difficulty == 'advanced'),
        isTrue);
    for (final q in output) {
      expect(
          q.options[q.correctIndex], q.source.options[q.source.correctIndex]);
    }
    expect(
        output.take(7).map((q) => q.source.id).toList(),
        isNot(source
            .where((q) => q.difficulty == 'foundation')
            .map((q) => q.id)
            .toList()));
  });

  testWidgets('Grade 2 picker exposes multiple choice only', (tester) async {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g2').first;
    await tester
        .pumpWidget(MaterialApp(home: NoriePracticeModeScreen(topic: topic)));
    expect(find.text('Multiple Choice'), findsOneWidget);
    expect(find.text('Identification'), findsNothing);
    expect(find.text('Random Mix'), findsNothing);
  });
}
