import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';

NorieTopicContent pilot(String subject, String grade, String id) =>
    NorieFoundationCurriculum.topicsFor(subject, grade)
        .singleWhere((topic) => topic.id == id);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('enriched pilots retain canonical progression and reward contracts', () {
    for (final row in [
      ['Science', 'g1', 'science.g1.living-nonliving-things', null, 20],
      [
        'Mathematics',
        'g7',
        'mathematics.g7.proportions',
        'mathematics.g7.rational-numbers',
        8
      ],
      [
        'Science',
        'g11',
        'science.g11.mechanics',
        'science.g11.stoichiometry',
        20
      ],
    ]) {
      final topic =
          pilot(row[0]! as String, row[1]! as String, row[2]! as String);
      expect(topic.prerequisiteTopicId, row[3]);
      expect(topic.lesson.completionXp, 50);
      expect(topic.quiz.xpPerCorrect, 20);
      expect(topic.challenge.xpPerCorrect, 25);
      expect(topic.quiz.questions, hasLength(row[4]! as int));
      expect(topic.challenge.rounds, hasLength(3));
      expect(
          NorieTopicContent.fromJson(topic.toJson()).toJson(), topic.toJson());
    }
  });

  test('proportions mastery transfers the unit rate and rejects a fixed fee',
      () {
    final topic = pilot('Mathematics', 'g7', 'mathematics.g7.proportions');
    final questions = topic.challenge.rounds;
    // 80 / 5 = 16 credits per notebook; 8 * 16 = 128 credits.
    expect(questions[0].options[questions[0].correctIndex], '128');
    // A fixed 20-credit fee makes the total 20 + 16 * 8 = 148,
    // and total cost at zero notebooks is 20 rather than zero.
    final transfer = questions[2];
    expect(transfer.prompt, contains('20-credit'));
    expect(transfer.options[transfer.correctIndex],
        '148 credits; not directly proportional');
    expect(transfer.explanation, contains('20 + 16'));
    expect(transfer.explanation, contains('zero'));
    expect(transfer.id, 'mathematics.g7.proportions.mastery.3');
  });

  test('mechanics mastery checks force, motion, units and reasonableness', () {
    final topic = pilot('Science', 'g11', 'science.g11.mechanics');
    final dynamics = topic.challenge.rounds.first;
    // (+7 - 3) N / 2 kg = +2 m/s²; 0 + 2 * 4 = +8 m/s.
    expect(dynamics.options[dynamics.correctIndex], '+8 m/s');
    expect(dynamics.explanation, contains('N/kg'));
    expect(dynamics.explanation, contains('0 and +8'));
    final transfer = topic.lesson.sections.where(
        (section) => section.title == 'Independent transfer: loading the cart');
    expect(transfer, hasLength(1),
        reason: 'The lesson needs an unanswered transfer before its reveal.');
    expect(transfer.single.reveal, isFalse);
    expect(
        topic.lesson.sections.any((section) =>
            section.title == 'Reveal: loading and model limits' &&
            section.reveal),
        isTrue);
  });

  for (final (textScale, reducedMotion) in [(1.0, false), (1.6, true)]) {
    testWidgets(
        'G1 reasoning reveals on a phone at ${textScale}x text, reduced motion $reducedMotion',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final source =
          pilot('Science', 'g1', 'science.g1.living-nonliving-things');
      final sections = source.lesson.sections
          .where((section) =>
              section.title == 'Try it yourself: plant or toy?' ||
              section.title == 'Reveal: use two clues')
          .toList();
      expect(sections, hasLength(2),
          reason: 'Keep independent observation separate from the answer.');
      final json = source.toJson();
      (json['lesson'] as Map<String, dynamic>)['sections'] =
          sections.map((section) => section.toJson()).toList();
      await tester.pumpWidget(MaterialApp(
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(textScale),
                  disableAnimations: reducedMotion),
              child: child!),
          home: NorieLessonScreen(topic: NorieTopicContent.fromJson(json))));
      await tester.pumpAndSettle();
      final answer = find.text(sections.last.body!);
      expect(answer, findsNothing);
      final reveal = find.ancestor(
          of: find.text('Reveal answer'), matching: find.byType(ListTile));
      await tester.scrollUntilVisible(reveal, 160,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      // A lazy ListView may build the next card before its button is onscreen.
      // Scroll the actual interactive tile into view after layout has settled.
      await tester.ensureVisible(reveal);
      await tester.pumpAndSettle();
      expect(reveal.hitTestable(), findsOneWidget);
      await tester.tap(reveal.hitTestable());
      await tester.pumpAndSettle();
      expect(answer, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
