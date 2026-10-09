import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/domain/norie_curriculum_depth.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  test('published paths accept precisely six through twenty lessons', () {
    for (var count = -1; count <= 21; count++) {
      expect(
          NorieCurriculumDepth.isSupported(count), count >= 6 && count <= 20);
      void validate() => NorieCurriculumDepth.validate(
          subject: 'Science', gradeId: 'g6', count: count);
      expect(validate,
          count >= 6 && count <= 20 ? returnsNormally : throwsStateError);
    }
  });
  test('planning targets are separate from published coverage', () {
    expect(NorieCurriculumDepth.targetFor('Science', 'college'), 18);
    expect(NorieCurriculumDepth.targetFor('Mathematics', 'college'), 16);
    expect(NorieCurriculumDepth.targetFor('English', 'college'), 12);
    for (final subject in ['Science', 'Mathematics', 'English']) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        expect(NorieCurriculumDepth.targetFor(subject, grade.id),
            inInclusiveRange(6, 20));
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(topics, hasLength(6));
        expect(topics.every(NorieFoundationCurriculum.isAuthored), isTrue);
        expect(NorieFoundationCurriculum.coverageLabel(subject, grade.id),
            '6 authored lessons');
      }
    }
  });
  test('unknown subjects and grades expose no fabricated curriculum', () {
    expect(
        NorieFoundationCurriculum.topicsFor('Missing subject', 'g1'), isEmpty);
    expect(NorieFoundationCurriculum.lessonTitles('Missing subject', 'g1'),
        isEmpty);
    expect(NorieFoundationCurriculum.topicsFor('Science', 'g99'), isEmpty);
  });
}
