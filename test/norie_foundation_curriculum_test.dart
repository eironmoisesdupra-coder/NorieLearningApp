import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_curriculum_depth.dart';

void main() {
  const subjects = ['Mathematics', 'Science', 'English'];

  test('foundation curriculum exposes Grade 1 through College', () {
    expect(NorieFoundationCurriculum.gradeLevels, hasLength(13));
    expect(NorieFoundationCurriculum.gradeLevels.first.label, 'Grade 1');
    expect(NorieFoundationCurriculum.gradeLevels.last.label, 'College');
  });

  test('every subject and grade has an authored production lesson path', () {
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        final topics =
            NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(
          topics.length,
          inInclusiveRange(
            NorieCurriculumDepth.minimumLessons,
            NorieCurriculumDepth.maximumLessons,
          ),
          reason: '$subject ${grade.label}',
        );
        for (final topic in topics) {
          expect(NorieFoundationCurriculum.isAuthored(topic), isTrue,
              reason: topic.id);
          expect(topic.subject, subject, reason: topic.id);
          expect(topic.gradeLevel, grade.id, reason: topic.id);
          expect(topic.quiz.questions, isNotEmpty, reason: topic.id);
          expect(topic.challenge.rounds, isNotEmpty, reason: topic.id);
          expect(topic.lesson.sections, isNotEmpty, reason: topic.id);
        }
      }
    }
  });

  test('published subject and grade topic ids are globally unique', () {
    final ids = <String>{};
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        for (final topic
            in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
          expect(ids.add(topic.id), isTrue, reason: topic.id);
        }
      }
    }
    expect(ids, isNotEmpty);
  });
}
