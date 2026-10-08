import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/account/norie_account_service.dart';
import 'package:norie_learning/core/quiz/norie_quiz_outro.dart';
import 'package:norie_learning/core/quiz/quiz_result_summary.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';

void main() {
  testWidgets(
      'changing learner closes both a private mistake review and its parent result',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    var current = true;
    final summary = QuizResultSummary(
        attemptId: 'identity',
        historyKey: 'identity',
        title: 'Private result',
        correctCount: 0,
        totalCount: 1,
        xpEarned: 0,
        answers: const [
          QuizAnswerRecord(
              questionId: 'one',
              prompt: 'A private mistake',
              response: 'wrong',
              correctAnswer: 'right',
              explanation: 'Feedback',
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
                    onPressed: () => NorieQuizOutro.show(context,
                        summary: summary, stillCurrent: () => current),
                    child: const Text('Open result'))))));
    await tester.tap(find.text('Open result'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Review Mistakes'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Review Mistakes'));
    await tester.pumpAndSettle();
    expect(find.text('A private mistake'), findsOneWidget);
    current = false;
    NorieAccountService.instance.clearMessage();
    await tester.pumpAndSettle();
    expect(find.text('A private mistake'), findsNothing);
    expect(find.byKey(const ValueKey('quiz-outro')), findsNothing);
    expect(find.text('Open result'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
