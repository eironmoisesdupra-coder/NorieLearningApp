import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/norie_grade_select_screen.dart';
import 'package:norie_learning/features/content/data/additional_subjects/norie_additional_subject_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_curriculum_depth.dart';

void main() {
  test('pilot answer keys teach subject answers without a first-slot pattern',
      () {
    for (final topic in NorieAdditionalSubjectCurriculum.allTopics) {
      expect(
          topic.quiz.questions
              .map((question) => question.correctIndex)
              .toSet()
              .length,
          greaterThanOrEqualTo(3),
          reason: topic.id);
    }
    final filipino =
        NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1');
    String answer(int lesson, int item) {
      final question = filipino[lesson].quiz.questions[item];
      return question.options[question.correctIndex];
    }

    expect(answer(0, 0), 'B');
    expect(answer(1, 3), 'bus');
    expect(answer(2, 4), 'mesa at libro');
    expect(answer(6, 0), 'Liza');
    expect(answer(6, 1), 'bakuran');
  });

  test('only published pilot grades are offered and unknown paths stay empty',
      () {
    for (final subject in ['Filipino', 'Araling Panlipunan']) {
      expect(
          NorieFoundationCurriculum.availableGradeLevels(subject)
              .map((grade) => grade.id),
          ['g1']);
      expect(NorieFoundationCurriculum.lessonTitles(subject, 'g2'), isEmpty);
      expect(NorieFoundationCurriculum.supportsAdventureMap(subject), isTrue);
    }
    expect(NorieFoundationCurriculum.availableGradeLevels('unknown'), isEmpty);
    expect(NorieFoundationCurriculum.topicsFor('Science', 'unknown'), isEmpty);
    expect(
        NorieFoundationCurriculum.lessonTitles('Science', 'unknown'), isEmpty);
  });
  testWidgets('small phone pilot grade selection offers Grade 1 only',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final subject in ['Filipino', 'Araling Panlipunan']) {
      await tester.pumpWidget(MaterialApp(
          home: NorieGradeSelectScreen(
              subject: subject, icon: Icons.translate, accent: Colors.purple)));
      await tester.pump();
      expect(find.text('Grade 1'), findsOneWidget);
      expect(find.text('Grade 2'), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  test('pilot lessons explain the subject through worked and guided examples',
      () {
    for (final topic in NorieAdditionalSubjectCurriculum.allTopics) {
      final sections = topic.lesson.sections;
      expect(
          sections.map((section) => section.title),
          containsAll([
            'Layunin',
            'Halimbawang may paliwanag',
            'Subukan natin',
            'Karaniwang pagkakamali',
            'Larawang gabay'
          ]));
      expect(
          sections
              .firstWhere(
                  (section) => section.title == 'Halimbawang may paliwanag')
              .points
              .length,
          greaterThanOrEqualTo(3),
          reason: topic.id);
      expect(
          sections
              .firstWhere((section) => section.title == 'Larawang gabay')
              .body,
          isNotEmpty,
          reason: topic.id);
      expect(
          sections
              .firstWhere(
                  (section) => section.title == 'Karaniwang pagkakamali')
              .points
              .join(),
          isNot(contains('pinakamahabang sagot')),
          reason: topic.id);
    }
  });

  test('Filipino Grade 1 launches with eight authored missions', () {
    final topics = NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1');
    expect(topics, hasLength(8));
    NorieCurriculumDepth.validate(
        subject: 'Filipino', gradeId: 'g1', count: topics.length);
    expect(topics.first.prerequisiteTopicId, isNull);
    for (var i = 1; i < topics.length; i++) {
      expect(topics[i].prerequisiteTopicId, topics[i - 1].id);
    }
  });

  test('Araling Panlipunan Grade 1 launches with seven authored missions', () {
    final topics =
        NorieAdditionalSubjectCurriculum.topicsFor('Araling Panlipunan', 'g1');
    expect(topics, hasLength(7));
    NorieCurriculumDepth.validate(
        subject: 'Araling Panlipunan', gradeId: 'g1', count: topics.length);
  });

  test('additional subject questions are valid and concept-tagged', () {
    for (final topic in NorieAdditionalSubjectCurriculum.allTopics) {
      expect(topic.quiz.questions, hasLength(5), reason: topic.id);
      expect(topic.challenge.rounds, hasLength(3), reason: topic.id);
      expect(topic.lesson.sections, hasLength(7), reason: topic.id);
      for (final question in [
        ...topic.quiz.questions,
        ...topic.challenge.rounds
      ]) {
        expect(question.hasValidAnswer, isTrue, reason: question.id);
        expect(question.conceptId, isNotEmpty, reason: question.id);
        expect(question.conceptLabel, isNotEmpty, reason: question.id);
        expect(question.explanation.length, greaterThan(20),
            reason: question.id);
      }
    }
  });

  test('unpublished grades stay unavailable rather than receiving placeholders',
      () {
    expect(
        NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g2'), isEmpty);
    expect(
        NorieAdditionalSubjectCurriculum.topicsFor('Araling Panlipunan', 'g12'),
        isEmpty);
  });
}
