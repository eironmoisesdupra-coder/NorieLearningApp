import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_lessons_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_select_screen.dart';
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

  testWidgets('Learn subjects go straight to the traditional grade path',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(theme: NorieTheme.dark, home: const LearnScreen()));
    await tap(tester, 'Science');
    expect(find.text('Choose a grade'), findsOneWidget);
    expect(find.text('Adventure Mode'), findsNothing);
    expect(find.text('Classic Lessons'), findsNothing);
    await tap(tester, 'Grade 1');
    final lessonScreen = tester
        .widget<NorieGradeLessonsScreen>(find.byType(NorieGradeLessonsScreen));
    expect(lessonScreen.subject, 'Science');
    expect(lessonScreen.grade.id, 'g1');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Activities keep learning tools without the pixel-art pilot',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(theme: NorieTheme.dark, home: const LearnScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Activities'));
    await tester.pumpAndSettle();
    expect(find.text('Discovery Adventure'), findsNothing);
    expect(find.text('Open investigation'), findsNothing);
    expect(find.text('3D Anatomy Lab'), findsOneWidget);
    expect(find.text('Seasonal Learning'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('legacy subjects hub links to the existing grade path',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(theme: NorieTheme.dark, home: const SubjectHubScreen()));
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.textContaining('Adventure Mode'), findsNothing);
    await tap(tester, 'Araling Panlipunan');
    expect(find.byType(NorieGradeSelectScreen), findsOneWidget);
    expect(find.text('Choose a grade'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('grade selection remains readable and usable on small phones',
      (tester) async {
    await mountSubject(tester, 'Science', small: true);
    expect(find.text('Choose a grade'), findsOneWidget);
    await tap(tester, 'Grade 1');
    expect(find.byType(NorieGradeLessonsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
