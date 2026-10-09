import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/presentation/norie_science_adventure_map.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_lessons_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // A completed singleton Future can retain the preceding test's frozen
    // FakeAsync zone. Recreate only its drained queues in this fixture's zone.
    NorieLessonJourney.instance.resetAsyncQueuesForTesting();
    NorieProgression.instance.resetAsyncQueuesForTesting();
    await NorieLessonJourney.instance.flush();
    SharedPreferences.setMockInitialValues({});
    await NorieLessonJourney.instance.load();
  });

  for (final length in [5, 6, 7, 8, 10, 19, 20]) {
    testWidgets(
        '$length real missions remain reachable at 320px with large text',
        (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final topics = NorieFoundationCurriculum.gradeLevels
          .expand((grade) =>
              NorieFoundationCurriculum.topicsFor('Science', grade.id))
          .take(length)
          .toList();
      await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(
              size: Size(320, 700), textScaler: TextScaler.linear(1.6)),
          child: Scaffold(
              body: NorieScienceAdventureMap(
            grade: NorieFoundationCurriculum.gradeLevels.first,
            accent: NorieColors.green,
            topics: topics,
          )),
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final last = find.byKey(ValueKey('map-node-${topics.last.id}'));
      await tester.scrollUntilVisible(last, 250,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(last);
      await tester.pumpAndSettle();
      expect(find.text('Chapter ${(length / 5).ceil()} checkpoint'),
          findsOneWidget);
      await tester.ensureVisible(find.text('Start mission'));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    });
  }

  for (final subject in ['Mathematics', 'English']) {
    testWidgets('$subject offers a map with fully authored coverage',
        (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(
              size: Size(320, 700), textScaler: TextScaler.linear(1.6)),
          child: NorieGradeLessonsScreen(
              subject: subject,
              grade: NorieFoundationCurriculum.gradeLevels[1],
              accent: NorieColors.cyan),
        ),
      ));
      await tester.pump();
      expect(find.text('$subject Basecamp'), findsOneWidget);
      expect(find.textContaining('6 authored lessons'), findsOneWidget);
      expect(find.text('List'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    });
  }

  testWidgets('Science map remains usable on a small phone with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final grade = NorieFoundationCurriculum.gradeLevels
        .firstWhere((item) => item.id == 'g6');
    await tester.pumpWidget(
      MaterialApp(
        theme: NorieTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 700),
            textScaler: TextScaler.linear(1.6),
          ),
          child: NorieGradeLessonsScreen(
            subject: 'Science',
            grade: grade,
            accent: NorieColors.green,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Map'), findsOneWidget);
    expect(find.text('List'), findsOneWidget);
    expect(find.text('Science Basecamp'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('List'));
    await tester.pump();
    final topics = NorieFoundationCurriculum.topicsFor('Science', grade.id);
    for (final topic in topics) {
      await tester.scrollUntilVisible(find.text(topic.title), 120,
          scrollable: find.byType(Scrollable).last);
      expect(find.text(topic.title), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    expect(tester.takeException(), isNull);
  });
  testWidgets('rapid exit flushes captured map position and restores it',
      (tester) async {
    final grade =
        NorieFoundationCurriculum.gradeLevels.firstWhere((g) => g.id == 'g6');
    Widget map() => MaterialApp(
        theme: NorieTheme.dark,
        home: Scaffold(
            body: NorieScienceAdventureMap(
                grade: grade, accent: NorieColors.green)));
    await tester.pumpWidget(map());
    await tester.pump();
    final scroll = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
    scroll.controller!.jumpTo(245);
    await tester.pump();
    // Exit before the 350 ms timer. This previously lost the bookmark.
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    await tester.pump();
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    expect(NorieLessonJourney.instance.mapOffsetFor('science.g6'), 245);
    await _drainPersistence(tester, NorieLessonJourney.instance.load());
    await tester.pumpWidget(map());
    await tester.pump();
    final restored = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
    expect(restored.controller!.offset, 245);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
  });

  testWidgets(
      'new map opens near current mission and available nodes open real lessons',
      (tester) async {
    final grade =
        NorieFoundationCurriculum.gradeLevels.firstWhere((g) => g.id == 'g6');
    final topics = NorieFoundationCurriculum.topicsFor('Science', grade.id);
    await tester.runAsync(() => NorieLessonJourney.instance.replaceState({
          'last_topic_id': topics[3].id,
          'reading_offsets': <String, double>{},
        }));
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: Scaffold(
            body: NorieScienceAdventureMap(
                grade: grade, accent: NorieColors.green))));
    await tester.pump();
    final scroll = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
    expect(scroll.controller!.offset, greaterThan(0));
    scroll.controller!.jumpTo(0);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('map-node-${topics[0].id}')));
    await tester.pumpAndSettle();
    expect(find.text(topics[0].lesson.introduction), findsOneWidget);
    await tester.ensureVisible(find.text('Start mission'));
    await tester.tap(find.text('Start mission'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.byType(NorieLessonScreen), findsOneWidget);
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
  });

  testWidgets('grade switch preserves each map bookmark and list alternative',
      (tester) async {
    final grades = NorieFoundationCurriculum.gradeLevels;
    final grade = grades.firstWhere((g) => g.id == 'g6');
    final next = grades.firstWhere((g) => g.id == 'g5');
    await _drainPersistence(
        tester, NorieLessonJourney.instance.saveMapOffset('science.g6', 180));
    await _drainPersistence(
        tester, NorieLessonJourney.instance.saveMapOffset('science.g5', 70));
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: NorieGradeLessonsScreen(
            subject: 'Science', grade: grade, accent: NorieColors.green)));
    await tester.pump();
    await tester.tap(find.byTooltip('Switch grade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(next.label).last);
    await tester.pumpAndSettle();
    expect(NorieLessonJourney.instance.mapOffsetFor('science.g6'), 180);
    final scroll = tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView));
    expect(scroll.controller!.offset, 70);
    await tester.tap(find.text('List'));
    await tester.pump();
    expect(
        find.text(NorieFoundationCurriculum.topicsFor('Science', next.id)
            .first
            .title),
        findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
  });

  testWidgets('learner replacement discards pending map position',
      (tester) async {
    final grade =
        NorieFoundationCurriculum.gradeLevels.firstWhere((g) => g.id == 'g6');
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: Scaffold(
            body: NorieScienceAdventureMap(
                grade: grade, accent: NorieColors.green))));
    await tester.pump();
    tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
        .controller!
        .jumpTo(220);
    await tester.pump();
    await _drainPersistence(tester, NorieLessonJourney.instance.reset());
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
    await tester.pump();
    expect(NorieLessonJourney.instance.mapOffsetFor('science.g6'), isNull);
    expect(tester.takeException(), isNull);
  });
}

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
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 1)));
  }
  expect(completed, isTrue,
      reason: 'Persistence must finish across clock zones');
  if (error != null) throw error!;
}
