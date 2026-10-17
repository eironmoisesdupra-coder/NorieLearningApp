import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/learning/presentation/learn_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_select_screen.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';

void main() {
  for (final subject in ['Science', 'Filipino', 'Araling Panlipunan']) {
    testWidgets(
        'Continue opens $subject saved lesson and rejects stale learner actions',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final journey = NorieLessonJourney.instance;
      final topic = NorieFoundationCurriculum.topicsFor(subject, 'g1').first;
      await tester.runAsync(() {
        journey.resetAsyncQueuesForTesting();
        return journey.replaceState({
          ...NorieLessonJourney.emptyState,
          'last_topic_id': topic.id,
        });
      });
      await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Continue Learning'));
      await tester.pumpAndSettle();
      final action = find.widgetWithText(FilledButton, 'Resume Lesson');
      expect(action, findsOneWidget);
      await tester.ensureVisible(action);
      final stale = tester.widget<FilledButton>(action).onPressed!;
      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<NorieLessonScreen>(find.byType(NorieLessonScreen))
              .topic
              .id,
          topic.id);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.runAsync(journey.reset);
      stale();
      await tester.pumpAndSettle();
      expect(find.byType(NorieLessonScreen), findsNothing);
      expect(find.text('Your first lesson awaits'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(journey.flush);
    });
  }
  testWidgets('Learn sections retain subject routes without invented progress',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.runAsync(() {
      NorieLessonJourney.instance.resetAsyncQueuesForTesting();
      NorieProgression.instance.resetAsyncQueuesForTesting();
      return NorieLessonJourney.instance.reset();
    });
    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(ChoiceChip), findsNWidgets(5));
    expect(find.byType(LinearProgressIndicator), findsNothing);
    for (final subject in [
      'Mathematics',
      'Science',
      'English',
      'Filipino',
      'Araling Panlipunan'
    ]) {
      await tester.scrollUntilVisible(find.text(subject), 200,
          scrollable: find.byType(Scrollable).first);
      await Scrollable.ensureVisible(tester.element(find.text(subject)),
          alignment: .25);
      await tester.pumpAndSettle();
      await tester.tap(find.text(subject));
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<NorieGradeSelectScreen>(
                  find.byType(NorieGradeSelectScreen))
              .subject,
          subject);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    for (final entry in <String, String>{
      'Continue Learning': 'Your first lesson awaits',
      'Activities': '3D Anatomy Lab',
      'Study Tools': 'AI Study Material Generator',
      'Classroom': 'Build, share and complete assignments offline',
    }.entries) {
      final chip = find.widgetWithText(ChoiceChip, entry.key);
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('every Learn group fits a 320px phone at 160 percent text',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.6)),
        child: child!,
      ),
      home: const LearnScreen(),
    ));
    for (final label in [
      'Subjects',
      'Continue Learning',
      'Activities',
      'Study Tools',
      'Classroom'
    ]) {
      final chip = find.widgetWithText(ChoiceChip, label);
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      await tester.pumpAndSettle();
      if (label == 'Subjects') {
        await Scrollable.ensureVisible(tester.element(find.text('Mathematics')),
            alignment: .25);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mathematics'));
        await tester.pumpAndSettle();
        expect(find.byType(NorieGradeSelectScreen), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
      }
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: label);
    }
  });
}
