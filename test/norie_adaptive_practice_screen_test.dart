import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_review_quest.dart';
import 'package:norie_learning/features/content/presentation/norie_review_quest_screen.dart';

void main() {
  testWidgets(
      'five correct adaptive answers change no progression or mastery receipts',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    NorieProgression.instance.resetAsyncQueuesForTesting();
    NorieAdventureProgress.instance.resetAsyncQueuesForTesting();
    await tester.runAsync(NorieProgression.instance.load);
    NorieAdventureProgress.instance
        .applyValidatedState(NorieAdventureProgress.emptyState, persist: false);
    final before = NorieAdventureProgress.instance.exportState();
    final beforeXp = NorieProgression.instance.totalXp;
    final beforeGame = NorieProgression.instance.exportCloudState();
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g8').first;
    final bank = [...topic.quiz.questions, ...topic.challenge.rounds];
    await tester.pumpWidget(MaterialApp(
        home: NorieReviewQuestScreen(
            topic: topic, kind: NorieReviewQuestKind.adaptivePractice)));
    await tester.pump();
    for (var i = 0; i < 5; i++) {
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(0);
      await tester.pump();
      final question =
          bank.firstWhere((q) => find.text(q.prompt).evaluate().isNotEmpty);
      final answer = find.widgetWithText(
          OutlinedButton, question.options[question.correctIndex]);
      await tester.scrollUntilVisible(answer, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(answer);
      await tester.pump();
      await tester.scrollUntilVisible(find.text('Check answer'), 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text('Check answer'));
      await tester.pump();
      final next = find.text(i == 4 ? 'Finish quest' : 'Next question');
      await tester.scrollUntilVisible(next, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.tap(next);
      await tester.pump();
    }
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Continue'), findsOneWidget);
    expect(NorieAdventureProgress.instance.exportState(), before);
    expect(NorieProgression.instance.totalXp, beforeXp);
    expect(NorieProgression.instance.exportCloudState(), beforeGame);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
