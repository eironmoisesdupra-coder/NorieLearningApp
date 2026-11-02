import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/standards/ched_general_education.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/authored_lesson_visual_view.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_lessons_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';

void main() {
  testWidgets('college references are readable offline on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      home: NorieGradeLessonsScreen(
        subject: 'Mathematics',
        grade: NorieFoundationCurriculum.gradeLevels.last,
        accent: Colors.cyan,
      ),
    ));
    final references = find.text('Curriculum references and scope');
    await tester.scrollUntilVisible(references, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(references);
    await tester.pumpAndSettle();
    expect(find.text(ChedGeneralEducation.sources.first), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('college lesson shows a useful model on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final topic = ChedGeneralEducation.topics['Mathematics']!.first;
    await tester.pumpWidget(MaterialApp(
      home: NorieLessonScreen(topic: topic),
    ));
    await tester.scrollUntilVisible(
      find.byType(AuthoredLessonVisualView),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Observed terms: 4, 7, 10, 13'), findsOneWidget);
    expect(find.text(topic.lesson.keyConceptBody), findsWidgets);
  });

  testWidgets(
      'unnumbered guided solutions can be revealed instead of disappearing',
      (tester) async {
    final topic = ChedGeneralEducation.topics['Mathematics']!.first;
    await tester.pumpWidget(MaterialApp(
      home: NorieLessonScreen(topic: topic),
    ));
    await tester.scrollUntilVisible(find.text('Reveal answer'), 250,
        scrollable: find.byType(Scrollable).first);
    final answer = topic.lesson.sections.firstWhere((s) => s.reveal).body!;
    expect(find.text(answer), findsNothing);
    await tester.tap(find.text('Reveal answer'));
    await tester.pumpAndSettle();
    expect(find.text(answer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
