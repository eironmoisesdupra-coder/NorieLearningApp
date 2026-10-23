import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_lessons_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_select_screen.dart';
import 'package:norie_learning/features/discovery/data/discovery_store.dart';
import 'package:norie_learning/features/discovery/domain/discovery_mission.dart';
import 'package:norie_learning/features/discovery/presentation/discovery_screen.dart';
import 'package:norie_learning/features/learning/presentation/learn_screen.dart';
import 'package:norie_learning/features/learning/presentation/subject_hub_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.load();
  });

  Future<void> tap(WidgetTester tester, String label) async {
    final target = find.text(label);
    if (target.evaluate().isEmpty) {
      await tester.scrollUntilVisible(target, 250,
          scrollable: find.byType(Scrollable).last);
    }
    await tester.ensureVisible(target.last);
    await tester.pumpAndSettle();
    await tester.tap(target.last);
    await tester.pumpAndSettle();
  }

  Future<void> mountSubject(WidgetTester tester, String subject,
      {bool small = false}) async {
    if (small) {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }
    await tester.pumpWidget(MaterialApp(
      theme: NorieTheme.dark,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(small ? 1.6 : 1),
          disableAnimations: true,
        ),
        child: child!,
      ),
      home: NorieGradeSelectScreen(
        subject: subject,
        icon: Icons.science_rounded,
        accent: NorieColors.green,
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'active Learn subject offers modes and retains one-tap grade entry',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(theme: NorieTheme.dark, home: const LearnScreen()));
    await tap(tester, 'Science');
    expect(find.text('Classic Lessons'), findsOneWidget);
    expect(find.text('Adventure Mode'), findsOneWidget);
    await tap(tester, 'Grade 1');
    final lessonScreen = tester
        .widget<NorieGradeLessonsScreen>(find.byType(NorieGradeLessonsScreen));
    expect(lessonScreen.subject, 'Science');
    expect(lessonScreen.grade.id, 'g1');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'Science pilot opens existing offline case without course rewards',
      (tester) async {
    final beforeXp = NorieProgression.instance.totalXp;
    final beforeCredits = NorieProgression.instance.credits;
    await mountSubject(tester, 'Science');
    await tap(tester, 'Adventure Mode');
    expect(find.text('The Case of the Vanishing Water'), findsOneWidget);
    expect(find.textContaining('Grades 4–6'), findsOneWidget);
    expect(find.textContaining('Experimental · ungraded'), findsOneWidget);
    expect(find.text('Not started'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(DiscoveryStore.storageKeyFor(null)), isNull);
    await tap(tester, 'Open investigation');
    expect(find.byType(DiscoveryScreen), findsOneWidget);
    expect(NorieProgression.instance.totalXp, beforeXp);
    expect(NorieProgression.instance.credits, beforeCredits);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('legacy subjects hub links all current authored subject paths',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(theme: NorieTheme.dark, home: const SubjectHubScreen()));
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await tap(tester, 'Araling Panlipunan');
    expect(find.byType(NorieGradeSelectScreen), findsOneWidget);
    expect(find.text('Classic Lessons'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Classic card reaches existing grades on a small phone',
      (tester) async {
    await mountSubject(tester, 'Science', small: true);
    await tap(tester, 'Classic Lessons');
    expect(find.text('Grade 1').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Science hub resumes actual saved case progress', (tester) async {
    final store = DiscoveryStore(ownerId: () => null);
    await store.initialize();
    for (final clue in DiscoveryClue.values) {
      await store.inspect(clue);
    }
    await store.continueMission();
    store.dispose();
    await mountSubject(tester, 'Science');
    await tap(tester, 'Adventure Mode');
    expect(find.text('In progress · 1/4 investigation steps complete'),
        findsOneWidget);
    await tap(tester, 'Open investigation');
    expect(find.textContaining('Compare warmer and cooler conditions'),
        findsOneWidget);
    await tap(tester, 'Run warm trial');
    await tap(tester, 'Run cool trial');
    await tap(tester, 'Explain what happened');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('In progress · 2/4 investigation steps complete'),
        findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('corrupt progress is unavailable rather than fabricated as zero',
      (tester) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(DiscoveryStore.storageKeyFor(null), 'broken');
    await mountSubject(tester, 'Science');
    await tap(tester, 'Adventure Mode');
    expect(find.text('Progress unavailable · open case for recovery'),
        findsOneWidget);
    expect(find.text('Not started'), findsNothing);
    expect(preferences.getString(DiscoveryStore.storageKeyFor(null)), 'broken');
    await tap(tester, 'Open investigation');
    expect(find.textContaining('Saved case could not be read'), findsOneWidget);
    await tap(tester, 'Play temporarily without replacing saved data');
    expect(find.textContaining('Temporary session: progress'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tap(tester, 'Open investigation');
    // A temporary case ends at the case route, just as Discovery promises.
    expect(find.textContaining('Temporary session: progress'), findsNothing);
    expect(find.text('Play temporarily without replacing saved data'),
        findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final preview in <String, String>{
    'Mathematics': 'Observatory Mystery',
    'English': 'The Lost Story',
    'Filipino': 'Misteryo sa Aklatan',
    'Araling Panlipunan': 'The Missing Map',
  }.entries) {
    testWidgets('${preview.key} preview cannot start unreleased content',
        (tester) async {
      await mountSubject(tester, preview.key, small: true);
      await tap(tester, 'Adventure Mode');
      expect(find.text(preview.value), findsOneWidget);
      expect(find.text('Planned preview · not playable'), findsOneWidget);
      expect(find.text('Open investigation'), findsNothing);
      expect(find.byType(DiscoveryScreen), findsNothing);
      expect(tester.takeException(), isNull);
      await tap(tester, 'Back to Classic Lessons');
      await tap(tester, 'Grade 1');
      expect(find.byType(NorieGradeLessonsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
