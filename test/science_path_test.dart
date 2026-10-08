import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/science/science_curriculum.dart';
import 'package:norie_learning/features/content/presentation/science_figure_view.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
      'Science preserves 60 authored G2–College originals in an expanded 78-topic path',
      () {
    final authoredGrades = [
      for (var grade = 2; grade <= 12; grade++) 'g$grade',
      'college'
    ];
    expect(ScienceCurriculum.grades.keys, unorderedEquals(authoredGrades));
    expect(
        ScienceCurriculum.grades.values.expand((pack) => pack), hasLength(60));
    for (final grade in authoredGrades) {
      expect(NorieFoundationCurriculum.topicsFor('Science', grade).take(5),
          orderedEquals(ScienceCurriculum.grades[grade]!),
          reason:
              '$grade must resolve to its authored pack, not starter content');
    }
    final path = NorieFoundationCurriculum.gradeLevels
        .expand(
            (grade) => NorieFoundationCurriculum.topicsFor('Science', grade.id))
        .toList();
    expect(path, hasLength(78));
    expect(path.map((topic) => topic.id).toSet(), hasLength(78));
    expect(path.where((topic) => topic.gradeLevel == 'g1'), hasLength(6));
    final college =
        path.where((topic) => topic.gradeLevel == 'college').toList();
    expect(college, hasLength(6));
    expect(ScienceCurriculum.grades.containsKey('college'), isTrue);
  });
  test('authored grades do not repeat question stems or substantial prose', () {
    final stems = <String, String>{};
    final paragraphs = <String, String>{};
    for (final topic
        in ScienceCurriculum.grades.values.expand((pack) => pack)) {
      for (final q in [...topic.quiz.questions, ...topic.challenge.rounds]) {
        final key = q.prompt.trim().toLowerCase();
        expect(stems[key], isNull, reason: '${q.id} repeats ${stems[key]}');
        stems[key] = q.id;
      }
      for (final section in topic.lesson.sections
          .where((s) => (s.body?.length ?? 0) > 140 && !s.reveal)) {
        final key = section.body!.trim().toLowerCase();
        expect(paragraphs[key], isNull,
            reason: '${topic.id} repeats ${paragraphs[key]}');
        paragraphs[key] = topic.id;
      }
    }
  });
  testWidgets(
      'authored diagram captions and standalone reveal answers are accessible',
      (tester) async {
    final source = ScienceCurriculum.grades.values.first.first;
    final visual =
        source.lesson.sections.firstWhere((s) => s.visualType != null);
    final topic = NorieTopicContent(
        id: source.id,
        subject: source.subject,
        category: source.category,
        title: 'Test',
        subtitle: source.subtitle,
        order: 1,
        accent: 'green',
        quiz: source.quiz,
        challenge: source.challenge,
        lesson: NorieLessonContent(
            heading: 'Test',
            introduction: '',
            keyConceptTitle: '',
            keyConceptBody: '',
            sections: [
              const NorieLessonSection(
                  title: 'Try it',
                  symbol: '',
                  points: [],
                  body: 'A seedling is the young plant.',
                  reveal: true),
              visual
            ]));
    await tester.pumpWidget(MaterialApp(home: NorieLessonScreen(topic: topic)));
    expect(find.text('A seedling is the young plant.'), findsNothing);
    await tester.tap(find.text('Reveal answer'));
    await tester.pumpAndSettle();
    expect(find.text('A seedling is the young plant.'), findsOneWidget);
    await tester.scrollUntilVisible(find.text(visual.visualCaption!), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text(visual.visualCaption!), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final grade in ScienceCurriculum.grades.entries) {
    test(
        '${grade.key} authored pack preserves progression and assessment integrity',
        () {
      expect(grade.value, hasLength(5));
      final titles =
          NorieFoundationCurriculum.lessonTitles('Science', grade.key);
      final stems = <String>{};
      final paragraphs = <String>{};
      for (var i = 0; i < grade.value.length; i++) {
        final topic = grade.value[i];
        expect(topic.title, titles[i]);
        expect(topic.id,
            'science.${grade.key}.${titles[i].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}');
        expect(
            topic.prerequisiteTopicId, i == 0 ? null : grade.value[i - 1].id);
        expect(topic.subtitle.trim(), isNotEmpty);
        expect(topic.lesson.introduction, contains('minutes'));
        expect(
            topic.lesson.sections.first.points.length, inInclusiveRange(3, 5));
        expect(topic.lesson.sections.length, greaterThanOrEqualTo(10));
        expect(topic.lesson.keyConceptBody.length, greaterThan(40));
        final prose = topic.lesson.sections
            .where((s) => s.body != null)
            .map((s) => s.body!)
            .join(' ');
        expect(prose.split(RegExp(r'\s+')).length, greaterThanOrEqualTo(400),
            reason: topic.id);
        expect(prose, isNot(contains('Build a clear Grade')));
        for (final section in topic.lesson.sections
            .where((s) => (s.body?.length ?? 0) > 140 && !s.reveal)) {
          expect(paragraphs.add(section.body!.trim().toLowerCase()), isTrue,
              reason:
                  'Repeated substantial section ${topic.id}: ${section.title}');
        }
        final visuals =
            topic.lesson.sections.where((s) => s.visualType != null).toList();
        expect(visuals.length, greaterThanOrEqualTo(2));
        for (final section in visuals) {
          expect(
              ScienceCurriculum.figures.containsKey(section.visualType), isTrue,
              reason: section.visualType);
          expect(section.visualCaption, isNotEmpty);
        }
        expect(topic.quiz.questions, hasLength(20));
        expect(topic.challenge.rounds, hasLength(3));
        final all = [...topic.quiz.questions, ...topic.challenge.rounds];
        expect(all.map((q) => q.id).toSet(), hasLength(23));
        for (var n = 0; n < all.length; n++) {
          final q = all[n];
          expect(stems.add(q.prompt.trim().toLowerCase()), isTrue,
              reason: '${topic.id}: ${q.prompt}');
          expect(q.options.map((s) => s.trim().toLowerCase()).toSet(),
              hasLength(4));
          expect(q.hasValidAnswer, isTrue);
          expect(q.explanation.length, greaterThan(20),
              reason: '${q.id}: feedback should explain the answer');
          expect(q.conceptLabel, isNotEmpty);
          expect(
              q.difficulty,
              n < 7
                  ? 'foundation'
                  : n < 14
                      ? 'intermediate'
                      : 'advanced');
          expect(q.prompt.toLowerCase(), isNot(contains('study strategy')));
        }
      }
    });
  }

  testWidgets(
      'every authored figure fits a narrow lesson card with enlarged text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final entry in ScienceCurriculum.figures.entries) {
      await tester.pumpWidget(MaterialApp(
          home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: Scaffold(
            body: SingleChildScrollView(
                child: Center(
                    child: SizedBox(
          width: 244,
          child: ScienceFigureView(figure: entry.value),
        )))),
      )));
      expect(tester.takeException(), isNull, reason: entry.key);
      expect(find.text(entry.value.title), findsWidgets);
      for (final label in entry.value.labels) {
        expect(find.text(label), findsWidgets, reason: entry.key);
      }
    }
  });
}
