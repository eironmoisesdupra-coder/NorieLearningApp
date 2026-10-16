import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/widgets/norie_mentor_card.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';

void main() {
  testWidgets(
      'mentor opens actual priority lesson and resets without leaking learner advice',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    NorieProgression.instance.resetAsyncQueuesForTesting();
    NorieAdventureProgress.instance.resetAsyncQueuesForTesting();
    await NorieProgression.instance.load();
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').first;
    NorieAdventureProgress.instance.applyValidatedState({
      ...NorieAdventureProgress.emptyState,
      'evidence': {
        topic.id: NorieLessonEvidence(
            lastAttemptAt: DateTime.now().toUtc(),
            lastPercent: 40,
            priorityConcepts: ['Observing']).toJson()
      }
    }, persist: false);
    final before = NorieProgression.instance.exportCloudState();
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const Scaffold(
            body: SingleChildScrollView(child: NorieMentorCard()))));
    await tester.pump();
    expect(find.textContaining(topic.title), findsWidgets);
    final stale = tester
        .widget<FilledButton>(find.byKey(const ValueKey('mentor-primary')))
        .onPressed!;
    await tester.tap(find.text('Review this lesson'));
    await tester.pumpAndSettle();
    expect(find.byType(NorieLessonScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(NorieProgression.instance.exportCloudState()['total_xp'],
        before['total_xp']);
    NorieAdventureProgress.instance
        .applyValidatedState(NorieAdventureProgress.emptyState, persist: false);
    stale();
    await tester.pumpAndSettle();
    expect(find.byType(NorieLessonScreen), findsNothing);
    expect(find.text('Start a small discovery'), findsOneWidget);
    expect(find.textContaining(topic.title), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
