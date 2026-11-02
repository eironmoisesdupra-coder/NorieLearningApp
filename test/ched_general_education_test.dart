import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/standards/ched_general_education.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/quality/curriculum_quality.dart';

void main() {
  test(
      'college paths teach GE subjects, not major-specific calculus or physics',
      () {
    expect(ChedGeneralEducation.courses, {
      'Mathematics': 'Mathematics in the Modern World',
      'Science': 'Science, Technology and Society',
      'English': 'Purposive Communication',
    });
    for (final entry in ChedGeneralEducation.topics.entries) {
      expect(entry.value, hasLength(6));
      for (var i = 0; i < entry.value.length; i++) {
        final topic = entry.value[i];
        expect(topic.subject, entry.key);
        expect(topic.gradeLevel, 'college');
        expect(topic.subtitle, ChedGeneralEducation.courses[entry.key]);
        expect(topic.lesson.completionXp, 50);
        expect(
            topic.prerequisiteTopicId, i == 0 ? null : entry.value[i - 1].id);
        expect(topic.quiz.questions, hasLength(8));
        expect(topic.challenge.rounds, hasLength(3));
        expect(
            topic.lesson.sections.map((s) => s.title),
            containsAll([
              'Learning objectives',
              'Model and evidence',
              'Worked example: follow the reasoning',
              'Guided practice: try first',
              'Guided solution',
              'Common mistake',
              'Recap',
            ]));
      }
    }
  });

  test('all GE lessons have valid unique assessments and registered models',
      () {
    final topics =
        ChedGeneralEducation.topics.values.expand((items) => items).toList();
    final report = CurriculumQualityScanner().scan(
      topics: topics,
      authoredTopicIds: topics.map((topic) => topic.id).toSet(),
      visualIds: {'authored-path', ...ChedGeneralEducation.visuals.keys},
    );
    expect(report.errors.map((error) => error.toJson()), isEmpty);
    for (final visual in ChedGeneralEducation.visuals.values) {
      expect(visual.validate, returnsNormally);
    }
  });

  test('the published college paths use the replacement GE lessons', () {
    for (final entry in ChedGeneralEducation.topics.entries) {
      expect(NorieFoundationCurriculum.topicsFor(entry.key, 'college'),
          orderedEquals(entry.value));
      expect(
        NorieFoundationCurriculum.lessonTitles(entry.key, 'college'),
        entry.value.map((topic) => topic.title),
      );
    }
  });
}
