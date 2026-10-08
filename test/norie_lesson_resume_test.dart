import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';
import 'package:norie_learning/features/home/presentation/home_screen.dart';
import 'package:norie_learning/features/home/presentation/norie_welcome_card.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_overlay.dart';

void main() {
  final journey = NorieLessonJourney.instance;
  setUp(() async {
    // A completed singleton Future can retain the preceding test's frozen
    // FakeAsync zone. Recreate only its drained queues in this fixture's zone.
    NorieLessonJourney.instance.resetAsyncQueuesForTesting();
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await journey.reset();
  });
  testWidgets('new learner chooses learning without fictional progress',
      (tester) async {
    int? selected;
    await tester.pumpWidget(MaterialApp(
        home: HomeScreen(
      embedded: true,
      onTabSelected: (value) => selected = value,
    )));
    await tester.pump();
    expect(
        tester
            .widget<NorieTutorialEntry>(find.byType(NorieTutorialEntry))
            .autoStart,
        isFalse);
    await tester.scrollUntilVisible(find.text('Choose a lesson'), 250);
    expect(find.text('72%'), findsNothing);
    await tester.tap(find.text('Choose a lesson'));
    expect(selected, 1);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('welcome is actionable and dismissal survives reconstruction',
      (tester) async {
    var opened = false;
    Widget app() => MaterialApp(
        home:
            Scaffold(body: NorieWelcomeCard(onLearnTap: () => opened = true)));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Start in three steps'), findsOneWidget);
    await tester.tap(find.text('Explore subjects'));
    expect(opened, isTrue);
    await tester.tap(find.byTooltip('Dismiss welcome'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Start in three steps'), findsNothing);
  });
  testWidgets('home opens saved topic and restores reading position',
      (tester) async {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g2')[1];
    await tester.runAsync(() => journey.replaceState({
          'last_topic_id': topic.id,
          'reading_offsets': {topic.id: 450.0},
        }));
    await tester
        .pumpWidget(const MaterialApp(home: HomeScreen(embedded: true)));
    await tester.scrollUntilVisible(find.text('Resume Lesson'), 250);
    expect(find.text(topic.title), findsOneWidget);
    await tester.tap(find.text('Resume Lesson'));
    // The lesson screen includes continuously animated mascot/background UI,
    // so waiting for the entire tree to settle can time out even when
    // navigation and restoration are complete. Pump the route transition only.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(
        tester
            .widget<NorieLessonScreen>(find.byType(NorieLessonScreen))
            .topic
            .id,
        topic.id);
    final list = tester.widget<ListView>(find.descendant(
      of: find.byType(NorieLessonScreen),
      matching: find.byType(ListView),
    ));
    expect(list.controller!.offset, closeTo(450, 1));
    await tester.drag(find.byType(ListView).last, const Offset(0, -300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pageBack();
    // Home's animated mascot keeps scheduling frames after navigation ends.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(journey.offsetFor(topic.id), greaterThan(450));
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, journey.flush());
  });
}

// Persistence can enqueue callbacks in the widget fake clock. Keep pumping that
// clock until completion instead of waiting in runAsync, which suspends it.
Future<void> _drainPersistence(
    WidgetTester tester, Future<dynamic> operation) async {
  var completed = false;
  Object? error;
  operation.then((_) => completed = true, onError: (Object value) {
    error = value;
    completed = true;
  });
  for (var i = 0; i < 100 && !completed; i++) {
    await tester.pump(const Duration(milliseconds: 10));
    // Queues initialized by setUp may also own real-zone callbacks.
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 1)));
  }
  expect(completed, isTrue,
      reason: 'Persistence must finish while the fake clock runs');
  if (error != null) throw error!;
}
