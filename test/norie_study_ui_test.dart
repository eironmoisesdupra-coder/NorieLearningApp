import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_mascot_view.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/widgets/norie_reward_feedback.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/presentation/study_quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'norie_offline_study_test.dart' show question, savedSet;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.load();
  });

  testWidgets('typing enables checking and a double submit grants one reward',
      (tester) async {
    final typed = NorieStudyQuestion.fromMap(
        {...question.toMap(), 'kind': 'identification', 'options': <String>[]});
    final set = NorieStudySet.fromMap(savedSet().toMap(), questions: [typed]);
    final before = NorieProgression.instance.snapshot.totalXp;
    await tester.pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: set)));
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Check Answer'))
            .onPressed,
        isNull);
    await tester.enterText(find.byType(TextField), '5');
    await tester.pump();
    final button = find.widgetWithText(FilledButton, 'Check Answer');
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Correct!'), findsWidgets);
    expect(find.byType(NorieMascotView), findsOneWidget);
    expect(find.text('+5 XP'), findsOneWidget);
    expect(NorieProgression.instance.snapshot.totalXp, before + 5);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
      'repeat correct popup shows no invented rewards with reduced motion',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Builder(
          builder: (context) => Scaffold(
                  body: TextButton(
                onPressed: () => NorieRewardPopup.show(context,
                    credits: 0, xp: 0, title: 'Correct!', correctAnswer: true),
                child: const Text('Show'),
              ))),
    )));
    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Added to your rewards.'), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Correct!'), findsNothing);
    expect(find.text('Show'), findsOneWidget);
  });
}
