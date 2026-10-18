import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/curriculum/domain/guided_assessment.dart';
import 'package:norie_learning/features/curriculum/presentation/norie_authored_practice_screen.dart';

void main() {
  testWidgets(
      'numeric rehearsal requires answer and unit and marks help separately',
      (tester) async {
    final session = GuidedPracticeSession();
    await tester.pumpWidget(MaterialApp(
        home: NorieAuthoredPracticeScreen(items: const [
      GuidedAssessmentItem.numeric(
          id: 'distance',
          prompt: 'Walk 1 m twice. What distance?',
          answer: 2,
          unit: 'm')
    ], explanations: const {
      'distance': 'One metre plus one metre is two metres.'
    }, session: session)));
    await tester.enterText(find.byKey(const Key('numeric-answer')), '2');
    await tester.enterText(find.byKey(const Key('numeric-unit')), 'cm');
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    expect(find.text('Review the explanation.'), findsOneWidget);
    expect(session.attempts.single.correct, isFalse);
    expect(session.attempts.single.kind, PracticeEvidenceKind.independent);
    expect(session.usedHelp('distance'), isTrue);
  });
}
