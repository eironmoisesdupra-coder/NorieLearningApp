import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/science/science_curriculum.dart';

void main() {
  test('lens focal-point question states the principal-axis assumption', () {
    final lens = NorieFoundationCurriculum.topicsFor('Science', 'g10').last;
    expect(lens.quiz.questions.first.prompt,
        contains('parallel to the principal axis'));
  });
  test(
      'each Science grade gains a real authored sixth lesson without replacing its cohort',
      () {
    for (final grade in NorieFoundationCurriculum.gradeLevels) {
      final topics = NorieFoundationCurriculum.topicsFor('Science', grade.id);
      expect(topics.length, greaterThanOrEqualTo(6), reason: grade.id);
      if (grade.id != 'g1') {
        expect(
            topics.take(5), orderedEquals(ScienceCurriculum.grades[grade.id]!));
      }
      final added = topics[5];
      expect(NorieFoundationCurriculum.lessonTitles('Science', grade.id).last,
          added.title);
      expect(added.order, 6);
      expect(added.prerequisiteTopicId, topics[4].id);
      expect(added.quiz.questions.length, greaterThanOrEqualTo(5));
      expect(added.challenge.rounds, hasLength(3));
      expect(added.challenge.rounds.every((q) => q.difficulty == 'advanced'),
          isTrue);
      expect(added.lesson.sections.first.points.length, inInclusiveRange(3, 5));
      for (final label in [
        'Worked example',
        'Guided',
        'Common mistakes',
        'recap'
      ]) {
        expect(
            added.lesson.sections.any((s) => s.title.contains(label)), isTrue,
            reason: '${added.id}: $label');
      }
      final visual =
          added.lesson.sections.firstWhere((s) => s.visualType != null);
      expect(ScienceCurriculum.figures[visual.visualType], isNotNull);
      ScienceCurriculum.figures[visual.visualType]!.validate();
      final questions = [...added.quiz.questions, ...added.challenge.rounds];
      expect(questions.map((q) => q.prompt.toLowerCase()).toSet().length,
          questions.length);
      for (final q in questions) {
        expect(q.hasValidAnswer, isTrue, reason: q.id);
        expect(q.explanation.length, greaterThan(30), reason: q.id);
        expect(q.conceptLabel, isNotEmpty);
      }
    }
  });
}
