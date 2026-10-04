import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/quiz/norie_quiz_outro.dart';
import 'package:norie_learning/core/quiz/quiz_result_summary.dart';
import 'package:norie_learning/core/mascot/norie_mascot_view.dart';
import 'package:norie_learning/core/mascot/norie_mascot_state.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';

void main() {
  testWidgets('result and mistake text inherit bundled offline font fallbacks',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final summary = QuizResultSummary(
        attemptId: 'b',
        historyKey: 'offline-fonts',
        title: 'Science',
        correctCount: 9,
        totalCount: 10,
        xpEarned: 0,
        gradeLevel: 1,
        answers: const [
          QuizAnswerRecord(
              questionId: 'heat',
              prompt: 'Which surface absorbs heat?',
              response: 'White',
              correctAnswer: 'Black',
              explanation: 'Dark surfaces absorb more sunlight.',
              correct: false)
        ]);
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!),
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () =>
                        NorieQuizOutro.show(context, summary: summary),
                    child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(summary.message, 'Great job! \u{1F31F}');
    final resultStyle =
        DefaultTextStyle.of(tester.element(find.text(summary.message))).style;
    const fallbacks = ['NorieScienceText', 'NorieScienceSymbols', 'NorieEmoji'];
    expect(resultStyle.fontFamilyFallback, fallbacks);
    expect(resultStyle.color, Colors.white);
    expect(resultStyle.fontSize, 15);
    expect(resultStyle.height, isNull);
    expect(resultStyle.letterSpacing, isNull);

    await tester.scrollUntilVisible(find.text('Review Mistakes'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Review Mistakes'));
    await tester.pumpAndSettle();
    final reviewStyle = DefaultTextStyle.of(
            tester.element(find.text(summary.mistakes.single.prompt)))
        .style;
    expect(reviewStyle.fontFamilyFallback, fallbacks);
    expect(reviewStyle.color, Colors.white);
    expect(reviewStyle.fontSize, 16);
    expect(reviewStyle.height, 1.5);
    expect(reviewStyle.letterSpacing, isNull);
    Navigator.of(tester.element(find.text(summary.mistakes.single.prompt)))
        .pop();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('system back continues safely and rebuild does not replay result',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    QuizOutroAction? action;
    late StateSetter rebuild;
    final summary = QuizResultSummary(
        attemptId: 'back',
        historyKey: 'back',
        title: 'Recall',
        correctCount: 1,
        totalCount: 1,
        xpEarned: 0,
        answers: const []);
    await tester.pumpWidget(StatefulBuilder(builder: (context, setState) {
      rebuild = setState;
      return MaterialApp(
          home: Builder(
              builder: (context) => TextButton(
                  onPressed: () async {
                    action =
                        await NorieQuizOutro.show(context, summary: summary);
                  },
                  child: const Text('Open'))));
    }));
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final mascot =
        tester.widget<NorieMascotView>(find.byType(NorieMascotView)).controller;
    expect(mascot.state, NorieMascotState.celebrating);
    await tester.pump(const Duration(seconds: 2));
    expect(mascot.state, NorieMascotState.idle);
    rebuild(() {});
    await tester.pump();
    expect(mascot.state, NorieMascotState.idle);
    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(action, QuizOutroAction.continueLearning);
    expect(find.byKey(const ValueKey('quiz-outro')), findsNothing);
  });
  testWidgets(
      'small phone reduced motion has supportive mascot and usable actions',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    QuizOutroAction? action;
    await tester.pumpWidget(MaterialApp(
        home: Builder(
            builder: (context) => MediaQuery(
                data: const MediaQueryData(
                    size: Size(320, 568),
                    disableAnimations: true,
                    textScaler: TextScaler.linear(1.6)),
                child: Builder(
                    builder: (context) => Scaffold(
                        body: TextButton(
                            onPressed: () async {
                              action = await NorieQuizOutro.show(context,
                                  summary: QuizResultSummary(
                                      attemptId: 'a',
                                      historyKey: 'q',
                                      title: 'Numbers',
                                      correctCount: 0,
                                      totalCount: 1,
                                      xpEarned: 0,
                                      gradeLevel: 1,
                                      answers: const [
                                        QuizAnswerRecord(
                                            questionId: 'a',
                                            prompt: 'One plus one?',
                                            response: '3',
                                            correctAnswer: '2',
                                            explanation: 'Count one more.',
                                            correct: false)
                                      ]),
                                  canReviewLesson: true);
                            },
                            child: const Text('Open'))))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('quiz-outro')), findsOneWidget);
    final mascot = tester.widget<NorieMascotView>(find.byType(NorieMascotView));
    expect(mascot.reduceMotion, true);
    expect(mascot.controller.state, NorieMascotState.pointing);
    await tester.scrollUntilVisible(find.text('Review Mistakes'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Review Mistakes'));
    await tester.pumpAndSettle();
    expect(find.text('One plus one?'), findsOneWidget);
    expect(find.text('Your answer: 3'), findsOneWidget);
    Navigator.of(tester.element(find.text('One plus one?'))).pop();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Continue'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(action, QuizOutroAction.continueLearning);
    expect(tester.takeException(), isNull);
  });
}
