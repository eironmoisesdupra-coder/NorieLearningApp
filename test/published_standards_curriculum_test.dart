import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/quality/published_curriculum_quality.dart';

void main() {
  final replacementTopics = [
    for (final subject in ['Mathematics', 'Science', 'English'])
      for (final grade in NorieFoundationCurriculum.gradeLevels)
        ...NorieFoundationCurriculum.topicsFor(subject, grade.id),
  ];
  final questionCount = replacementTopics.fold<int>(
      0,
      (count, topic) =>
          count + topic.quiz.questions.length + topic.challenge.rounds.length);
  test('publishes 332 replacement lessons with $questionCount assessment items',
      () {
    expect(replacementTopics, hasLength(332));
    expect(replacementTopics.map((topic) => topic.id).toSet(), hasLength(332));
    expect(questionCount, greaterThan(3000));
  });

  test('every published path passes assessment and visual registry checks', () {
    final report = scanPublishedCurriculum();
    expect(report.errors.map((error) => error.toJson()).toList(), isEmpty);
    expect(report.topicCount, greaterThan(200));
  });

  test('published titles come from actual lessons rather than stale plans', () {
    for (final subject in NorieFoundationCurriculum.supportedSubjects) {
      for (final grade
          in NorieFoundationCurriculum.availableGradeLevels(subject)) {
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(
          NorieFoundationCurriculum.lessonTitles(subject, grade.id),
          orderedEquals(topics.map((topic) => topic.title)),
          reason: '$subject/${grade.id}',
        );
        for (final topic in topics) {
          expect(
            [
              ...topic.quiz.questions,
              ...topic.challenge.rounds
            ].any((question) =>
                question.prompt.toLowerCase().contains('which study habit')),
            isFalse,
            reason: topic.id,
          );
        }
      }
    }
  });

  test('every replaced subject and grade exposes offline reference scope', () {
    for (final subject in ['Mathematics', 'Science', 'English']) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        expect(
          NorieFoundationCurriculum.sourcesFor(subject, grade.id),
          isNotEmpty,
          reason: '$subject/${grade.id}',
        );
      }
    }
  });
}
