import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/study/presentation/study_quiz_screen.dart';
import 'package:norie_learning/features/study/presentation/study_results_screen.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';

Future<void> settleAsync(WidgetTester tester) async {
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
  }
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.load();
  });
  testWidgets(
      'native quiz resumes ordered questions and checked progress after reopening',
      (tester) async {
    final set = NorieStudySet(
        id: 'native-resume-fixture',
        title: 'Native resume',
        sourceType: 'native',
        sourceName: 'Synthetic widget fixture',
        mode: NorieStudyGenerationMode.identification,
        requestedCount: 5,
        status: 'ready',
        createdAt: DateTime.utc(2026),
        ownerId: 'local',
        questions: [
          for (var i = 0; i < 5; i++)
            NorieStudyQuestion(
                id: 'resume-$i',
                position: i,
                kind: NorieStudyQuestionKind.identification,
                prompt: 'Calculate: $i + 1.',
                options: const [],
                correctValues: ['${i + 1}'],
                explanation: 'Add one to $i.',
                sourceExcerpt: 'Synthetic widget fixture',
                difficulty: 'foundation')
        ]);
    await tester.pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: set)));
    await settleAsync(tester);
    await tester.enterText(find.byType(TextField), '999999');
    await tester.pump();
    tester.testTextInput.hide();
    await tester.scrollUntilVisible(find.text('Check Answer'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Check Answer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check Answer'));
    await settleAsync(tester);
    await tester.scrollUntilVisible(find.text('Next'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await settleAsync(tester);
    expect(find.text('2/5'), findsOneWidget);
    final visible = set.questions
        .where((q) => find.text(q.prompt).evaluate().isNotEmpty)
        .single
        .prompt;
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: set)));
    await settleAsync(tester);
    expect(find.text('2/5'), findsOneWidget);
    expect(find.text(visible), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
  testWidgets(
      'a native deck opened under a different owner never displays private prompts',
      (tester) async {
    final foreign = NorieStudySet(
        id: 'foreign-native',
        title: 'Private title',
        sourceType: 'native',
        sourceName: 'fixture',
        mode: NorieStudyGenerationMode.identification,
        requestedCount: 1,
        status: 'ready',
        createdAt: DateTime.utc(2026),
        ownerId: 'another-account',
        questions: const [
          NorieStudyQuestion(
              id: 'private',
              position: 0,
              kind: NorieStudyQuestionKind.identification,
              prompt: 'Private prompt must be hidden',
              options: [],
              correctValues: ['5'],
              explanation: 'Private explanation',
              sourceExcerpt: 'Private source',
              difficulty: 'foundation')
        ]);
    await tester
        .pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: foreign)));
    await settleAsync(tester);
    expect(find.text('Private title'), findsNothing);
    expect(find.text('Learner changed'), findsOneWidget);
    await tester.pumpWidget(MaterialApp(
        home: StudyResultsScreen(
            studySet: foreign,
            answers: const [],
            result: const NorieStudyAttemptResult(
                correct: 0,
                total: 0,
                xpAwarded: 0,
                firstRewardedCompletion: false))));
    await settleAsync(tester);
    expect(find.text('Learner changed'), findsOneWidget);
    expect(find.text('Private title'), findsNothing);
  });
}
