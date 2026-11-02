import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/science/science_curriculum.dart';
import 'package:norie_learning/features/content/data/science/science_expansion.dart';

void main() {
  test('lens focal-point question states the principal-axis assumption', () {
    final lens = ScienceExpansion.lessons['g10']!;
    expect(lens.quiz.questions.first.prompt,
        contains('parallel to the principal axis'));
  });
  test(
      'historical Science extensions retain their teaching and assessment contracts',
      () {
    for (final grade in NorieFoundationCurriculum.gradeLevels) {
      final added = ScienceExpansion.lessons[grade.id]!;
      expect(added.order, 6);
      expect(
          NorieFoundationCurriculum.historicalTopicById(
                  added.prerequisiteTopicId!)!
              .order,
          5);
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
