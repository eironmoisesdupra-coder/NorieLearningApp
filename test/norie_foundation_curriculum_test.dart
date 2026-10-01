import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  const subjects = ['Mathematics', 'Science', 'English'];

  test('foundation curriculum exposes Grade 1 through College', () {
    expect(NorieFoundationCurriculum.gradeLevels, hasLength(13));
    expect(NorieFoundationCurriculum.gradeLevels.first.label, 'Grade 1');
    expect(NorieFoundationCurriculum.gradeLevels.last.label, 'College');
  });

  test('every subject and grade has exactly five starter lessons', () {
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        final topics =
            NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(
          topics,
          hasLength(5),
          reason: '$subject ${grade.label}',
        );
      }
    }
  });

  test('foundation sprint contains 195 pre-generated lessons', () {
    var total = 0;
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        total +=
            NorieFoundationCurriculum.topicsFor(subject, grade.id).length;
      }
    }
    expect(total, 195);
  });

  test('every foundation lesson includes 20 practice items and a visual', () {
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        for (final topic
            in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
          expect(topic.quiz.questions, hasLength(20), reason: topic.id);
          expect(topic.challenge.rounds, hasLength(3), reason: topic.id);
          expect(topic.visualType, isNotNull, reason: topic.id);
          expect(topic.lesson.sections, isNotEmpty, reason: topic.id);
        }
      }
    }
  });

  test('Grade 1 Mathematics ships five proper guided lessons', () {
    final topics =
        NorieFoundationCurriculum.topicsFor('Mathematics', 'g1');

    expect(
      topics.map((topic) => topic.title).toList(),
      const [
        'Counting to 100',
        'Place Value',
        'Addition Basics',
        'Subtraction Basics',
        'Shapes & Patterns',
      ],
    );

    for (final topic in topics) {
      expect(topic.lesson.objectives.length, greaterThanOrEqualTo(3),
          reason: topic.id);
      expect(topic.lesson.estimatedMinutes, isNotNull, reason: topic.id);
      expect(topic.lesson.sections.length, greaterThanOrEqualTo(5),
          reason: topic.id);
      expect(
        topic.lesson.sections.where((section) => section.visualType != null),
        isNotEmpty,
        reason: '${topic.id} should include inline visual models',
      );
      expect(topic.quiz.questions, hasLength(20), reason: topic.id);
      expect(topic.challenge.rounds, hasLength(3), reason: topic.id);
      expect(topic.visualType, startsWith('g1-'), reason: topic.id);

      for (final question in topic.quiz.questions) {
        expect(question.hasValidAnswer, isTrue, reason: question.id);
        expect(question.explanation, isNotEmpty, reason: question.id);
      }
    }
  });

  test('Grade 1 Math lessons no longer use generic study-habit questions', () {
    final topics =
        NorieFoundationCurriculum.topicsFor('Mathematics', 'g1');

    for (final topic in topics) {
      final prompts =
          topic.quiz.questions.map((question) => question.prompt).join(' ');
      expect(prompts, isNot(contains('study habit')), reason: topic.id);
      expect(prompts, isNot(contains('learning approach')), reason: topic.id);
    }
  });

  test('foundation topic ids are globally unique', () {
    final ids = <String>{};
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        for (final topic
            in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
          expect(ids.add(topic.id), isTrue, reason: topic.id);
        }
      }
    }
    expect(ids, hasLength(195));
  });
}
