import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/content/data/authored/authored_subject_curriculum.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/authored_lesson_visual_view.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets(
      'all authored Mathematics and English diagrams fit a narrow card at large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final entry in AuthoredSubjectCurriculum.visuals.entries) {
      await tester.pumpWidget(MaterialApp(
          home: MediaQuery(
        data: const MediaQueryData(
            size: Size(320, 700), textScaler: TextScaler.linear(1.6)),
        child: Scaffold(
            body: SingleChildScrollView(
                child: Center(
                    child: SizedBox(
          width: 244,
          child: AuthoredLessonVisualView(
              visual: entry.value, accent: NorieColors.cyan),
        )))),
      )));
      expect(tester.takeException(), isNull, reason: entry.key);
      expect(find.text(entry.value.title), findsOneWidget);
      for (final label in entry.value.labels) {
        expect(find.text(label), findsWidgets, reason: entry.key);
      }
    }
  });

  for (final subject in ['Mathematics', 'English']) {
    testWidgets('$subject authored lesson renders its actual diagram route',
        (tester) async {
      final topic = NorieFoundationCurriculum.topicsFor(subject, 'g1').last;
      await tester.pumpWidget(MaterialApp(
          theme: NorieTheme.dark, home: NorieLessonScreen(topic: topic)));
      await tester.scrollUntilVisible(
          find.byType(AuthoredLessonVisualView), 200,
          scrollable: find.byType(Scrollable).first);
      expect(find.byType(AuthoredLessonVisualView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
