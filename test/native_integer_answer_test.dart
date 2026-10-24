import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/study/domain/quiz_generation/native_integer_answer.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/presentation/study_quiz_screen.dart';

void main() {
  test(
      'native whole-number answers accept exact aliases without rounding wrong values',
      () {
    for (final row in <(String, String, bool)>[
      ('5', '5', true),
      ('+005.000', '5', true),
      ('−3.0', '-3', true),
      ('-0.00', '0', true),
      (' 5.0 ', '5', true),
      ('5.000000000000001', '5', false),
      ('-3', '3', false),
      ('1/2', '1', false),
      ('1 0', '10', false),
      ('NaN', '0', false),
      ('Infinity', '0', false),
      ('5e0', '5', false),
      ('9007199254740993', '9007199254740992', false),
      ('', '0', false),
    ]) {
      expect(nativeIntegerAnswerMatches(row.$1, row.$2), row.$3,
          reason: '${row.$1} versus ${row.$2}');
    }
  });
  testWidgets('native identification grades an equivalent integer correctly',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    NorieProgression.instance.resetAsyncQueuesForTesting();
    await NorieProgression.instance.load();
    final set = NorieStudySet(
        id: 'native-alias',
        title: 'Exact integer practice',
        sourceType: 'native',
        sourceName: 'Synthetic widget fixture',
        mode: NorieStudyGenerationMode.identification,
        requestedCount: 1,
        status: 'ready',
        createdAt: DateTime.utc(2026),
        ownerId: 'local',
        questions: const [
          NorieStudyQuestion(
              id: 'alias-q',
              position: 0,
              kind: NorieStudyQuestionKind.identification,
              prompt: 'Calculate: 2 + 3.',
              options: [],
              correctValues: ['5'],
              explanation: '2 + 3 = 5.',
              sourceExcerpt: 'Synthetic widget fixture',
              difficulty: 'foundation')
        ]);
    await tester.pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: set)));
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 5)));
    }
    await tester.enterText(find.byType(TextField), '+005.000');
    await tester.pump();
    tester.testTextInput.hide();
    await tester.scrollUntilVisible(find.text('Check Answer'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check Answer'));
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 5)));
      if (find.text('Correct!').evaluate().isNotEmpty) break;
    }
    expect(find.text('Correct!'), findsWidgets);
    expect(NorieProgression.instance.snapshot.totalXp, 5);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
