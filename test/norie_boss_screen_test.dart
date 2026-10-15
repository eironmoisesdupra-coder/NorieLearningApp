import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/domain/norie_boss_mission.dart';
import 'package:norie_learning/features/content/presentation/norie_boss_missions_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_review_quest_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    NorieProgression.instance.resetAsyncQueuesForTesting();
    NorieAdventureProgress.instance.resetAsyncQueuesForTesting();
    await NorieProgression.instance.load();
    NorieAdventureProgress.instance
        .applyValidatedState(NorieAdventureProgress.emptyState, persist: false);
  });
  testWidgets('unprepared boss offers real lessons and cannot be started',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(
                textScaler: TextScaler.linear(1.6), disableAnimations: true),
            child:
                NorieBossMissionsScreen(subject: 'Science', gradeId: 'g1'))));
    await tester.pump();
    expect(find.text('Boss Missions'), findsOneWidget);
    final first = NorieBossMission.forPath('Science', 'g1').first;
    final start = find.byKey(ValueKey('start-${first.id}'));
    await tester.scrollUntilVisible(start, 250);
    expect(tester.widget<FilledButton>(start).onPressed, isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
        MaterialApp(home: NorieReviewQuestScreen.boss(mission: first)));
    expect(find.text('Prepare your chapter first'), findsOneWidget);
    expect(find.text('Check answer'), findsNothing);
    expect(NorieAdventureProgress.instance.trophyIds, isEmpty);
  });
  testWidgets(
      'passing boss saves a card but no lesson XP and stale learner cannot submit',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boss = NorieBossMission.forPath('Science', 'g1').last;
    SharedPreferences.setMockInitialValues(
        {'norie.completedTopicIds': boss.topics.map((t) => t.id).toList()});
    await NorieProgression.instance.load();
    final beforeXp = NorieProgression.instance.totalXp;
    final beforeGame = NorieProgression.instance.completedTopicIds;
    await tester.pumpWidget(
        MaterialApp(home: NorieReviewQuestScreen.boss(mission: boss)));
    final bank = [
      for (final t in boss.topics) ...[
        ...t.quiz.questions,
        ...t.challenge.rounds
      ]
    ];
    final count = boss.questions().length;
    for (var i = 0; i < count; i++) {
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(0);
      await tester.pump();
      final q =
          bank.firstWhere((q) => find.text(q.prompt).evaluate().isNotEmpty);
      final answer =
          find.widgetWithText(OutlinedButton, q.options[q.correctIndex]);
      await tester.scrollUntilVisible(answer, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(answer);
      await tester.pump();
      await tester.scrollUntilVisible(find.text('Check answer'), 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text('Check answer'));
      await tester.pump();
      final next = find.text(i == count - 1 ? 'Finish quest' : 'Next question');
      await tester.scrollUntilVisible(next, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.tap(next);
      await tester.pump();
    }
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(seconds: 1));
    expect(NorieAdventureProgress.instance.trophyIds, contains(boss.id));
    expect(NorieProgression.instance.totalXp, beforeXp);
    expect(NorieProgression.instance.completedTopicIds, beforeGame);
    for (final t in boss.topics) {
      expect(NorieAdventureProgress.instance.evidenceFor(t.id), isNull);
    }
    expect(find.textContaining('Knowledge card earned'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
        MaterialApp(home: NorieReviewQuestScreen.boss(mission: boss)));
    NorieAdventureProgress.instance
        .applyValidatedState(NorieAdventureProgress.emptyState, persist: false);
    await tester.pump();
    expect(find.text('The active learner changed'), findsOneWidget);
    expect(find.text('Check answer'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
      'failed replay preserves the card without announcing a new reward',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boss = NorieBossMission.forPath('Science', 'g1').last;
    SharedPreferences.setMockInitialValues(
        {'norie.completedTopicIds': boss.topics.map((t) => t.id).toList()});
    await NorieProgression.instance.load();
    NorieAdventureProgress.instance.applyValidatedState({
      ...NorieAdventureProgress.emptyState,
      'trophies': {boss.id: '2026-10-15T00:00:00.000Z'}
    }, persist: false);
    await tester.pumpWidget(
        MaterialApp(home: NorieReviewQuestScreen.boss(mission: boss)));
    final bank = [
      for (final t in boss.topics) ...[
        ...t.quiz.questions,
        ...t.challenge.rounds
      ]
    ];
    final count = boss.questions().length;
    for (var i = 0; i < count; i++) {
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(0);
      await tester.pump();
      final q =
          bank.firstWhere((q) => find.text(q.prompt).evaluate().isNotEmpty);
      final answer = find.widgetWithText(
          OutlinedButton, q.options[(q.correctIndex + 1) % q.options.length]);
      await tester.scrollUntilVisible(answer, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(answer);
      await tester.pump();
      await tester.scrollUntilVisible(find.text('Check answer'), 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text('Check answer'));
      await tester.pump();
      final next = find.text(i == count - 1 ? 'Finish quest' : 'Next question');
      await tester.scrollUntilVisible(next, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.tap(next);
      await tester.pump();
    }
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(seconds: 1));
    expect(NorieAdventureProgress.instance.trophyIds, {boss.id});
    expect(find.textContaining('Knowledge card earned'), findsNothing);
    expect(find.textContaining('Added to your collection'), findsNothing);
    expect(find.text('Continue'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
