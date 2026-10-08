import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  const subjects = ['Mathematics', 'Science', 'English'];

  test('foundation curriculum exposes Grade 1 through College', () {
    expect(NorieFoundationCurriculum.gradeLevels, hasLength(13));
    expect(NorieFoundationCurriculum.gradeLevels.first.label, 'Grade 1');
    expect(NorieFoundationCurriculum.gradeLevels.last.label, 'College');
  });

  test('all subjects provide six authored units per grade/course', () {
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(
          topics,
          hasLength(6),
          reason: '$subject ${grade.label}',
        );
      }
    }
  });

  test(
      'foundation paths contain the original 195 lessons and 39 authored additions',
      () {
    var total = 0;
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        total += NorieFoundationCurriculum.topicsFor(subject, grade.id).length;
      }
    }
    expect(total, 234);
  });

  test('every foundation lesson has practice, independent mastery and a visual',
      () {
    for (final subject in subjects) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        for (final topic
            in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
          final legacyBank = topic.order < 6 &&
              (subject == 'Science' ||
                  (subject == 'Mathematics' && grade.id == 'g1'));
          expect(topic.quiz.questions, hasLength(legacyBank ? 20 : 8),
              reason: topic.id);
          expect(NorieFoundationCurriculum.isAuthored(topic), isTrue,
              reason: topic.id);
          expect(topic.challenge.rounds, hasLength(3), reason: topic.id);
          expect(topic.visualType, isNotNull, reason: topic.id);
          expect(topic.lesson.sections, isNotEmpty, reason: topic.id);
        }
      }
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
    expect(ids, hasLength(234));
  });
}
