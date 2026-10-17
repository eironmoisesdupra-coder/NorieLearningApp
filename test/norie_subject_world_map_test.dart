import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_subject_world.dart';
import 'package:norie_learning/features/content/presentation/norie_subject_world_map.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_lessons_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    NorieLessonJourney.instance.resetAsyncQueuesForTesting();
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.load();
  });

  test('pilot islands include only real authored Grade 1 lessons', () {
    final worlds = NorieSubjectWorld.build(isCompleted: (_) => false);
    expect(worlds.map((world) => world.subject), [
      'Mathematics',
      'Science',
      'English',
      'Filipino',
      'Araling Panlipunan'
    ]);
    for (final subject in ['Mathematics', 'Science', 'English']) {
      expect(
          worlds.firstWhere((world) => world.subject == subject).grades.length,
          13);
    }
    final filipino = worlds.firstWhere((world) => world.subject == 'Filipino');
    final ap =
        worlds.firstWhere((world) => world.subject == 'Araling Panlipunan');
    expect(filipino.grades.map((grade) => grade.grade.id), ['g1']);
    expect(ap.grades.map((grade) => grade.grade.id), ['g1']);
    expect(filipino.total, 8);
    expect(ap.total, 7);
    final topic = NorieFoundationCurriculum.topicsFor('Filipino', 'g1').first;
    final completed = NorieSubjectWorld.build(
        isCompleted: (id) => id == topic.id || id == 'obsolete.lesson');
    expect(
        completed.firstWhere((world) => world.subject == 'Filipino').completed,
        1);
    expect(
        completed.firstWhere((world) => world.subject == 'English').completed,
        0);
  });

  testWidgets('list alternative navigates directly to a supported grade',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark, home: const NorieSubjectWorldMap()));
    await tester.tap(find.text('List'));
    await tester.pump();
    final grade = find.byKey(const ValueKey('world-grade-Filipino-g1'));
    await tester.scrollUntilVisible(grade, 400,
        scrollable: find.byType(Scrollable).first);
    expect(find.byKey(const ValueKey('world-grade-Filipino-g2')), findsNothing);
    await tester.tap(grade);
    await tester.pumpAndSettle();
    final screen = tester
        .widget<NorieGradeLessonsScreen>(find.byType(NorieGradeLessonsScreen));
    expect(screen.subject, 'Filipino');
    expect(screen.grade.id, 'g1');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('320px map supports large text, reduced motion and last island',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: NorieTheme.dark,
      home: const MediaQuery(
        data: MediaQueryData(
            size: Size(320, 700),
            textScaler: TextScaler.linear(1.6),
            disableAnimations: true),
        child: NorieSubjectWorldMap(),
      ),
    ));
    final grade =
        find.byKey(const ValueKey('world-grade-Araling Panlipunan-g1'));
    await tester.scrollUntilVisible(grade, 350,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('0/7 authored lessons completed'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('visible world counts refresh on progress load and account reset',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark, home: const NorieSubjectWorldMap()));
    final island = find.byKey(const ValueKey('world-island-Filipino'));
    await tester.scrollUntilVisible(island, 350,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('0/8 authored lessons completed'), findsOneWidget);
    final topic = NorieFoundationCurriculum.topicsFor('Filipino', 'g1').first;
    SharedPreferences.setMockInitialValues({
      'norie.completedTopicIds': [topic.id],
    });
    await tester.runAsync(NorieProgression.instance.load);
    await tester.pump();
    expect(find.text('1/8 authored lessons completed'), findsOneWidget);
    await tester.runAsync(NorieProgression.instance.resetForNewAccount);
    await tester.pump();
    expect(find.text('0/8 authored lessons completed'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
