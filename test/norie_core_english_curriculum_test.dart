import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/authored/core_english_curriculum.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  test('all original 65 English lessons retain identity, order and rewards',
      () {
    expect(CoreEnglishCurriculum.grades.length, 13);
    expect(CoreEnglishCurriculum.grades.values.expand((v) => v).length, 65);
    for (final entry in CoreEnglishCurriculum.grades.entries) {
      final titles =
          NorieFoundationCurriculum.lessonTitles('English', entry.key)
              .take(5)
              .toList();
      expect(entry.value.map((t) => t.title), titles);
      for (var i = 0; i < 5; i++) {
        final topic = entry.value[i];
        final slug =
            titles[i].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
        expect(topic.id, 'english.${entry.key}.$slug');
        expect(topic.order, i + 1);
        expect(topic.lesson.completionXp, 50);
        expect(topic.quiz.questions.length, 8);
        expect(topic.challenge.rounds.length, 3);
      }
    }
  });
  test('every lesson teaches examples, hidden reasoning and meaningful visuals',
      () {
    for (final topic in CoreEnglishCurriculum.grades.values.expand((v) => v)) {
      final sections = topic.lesson.sections;
      expect(sections.first.points.length, 3, reason: topic.id);
      expect(sections.any((s) => s.reveal && (s.body?.length ?? 0) > 35), true,
          reason: topic.id);
      expect(
          sections
              .any((s) => s.title.contains('Worked') && s.body!.contains('1.')),
          true,
          reason: topic.id);
      final visual = sections.singleWhere(
          (s) => s.visualType?.startsWith('english-core-') == true);
      final figure = CoreEnglishCurriculum.figures[visual.visualType]!;
      figure.validate();
      expect(figure.labels.length, greaterThanOrEqualTo(3), reason: topic.id);
      final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
      expect(questions.map((q) => q.prompt).toSet().length, 11,
          reason: topic.id);
      for (final q in questions) {
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.options.toSet().length, 4);
        expect(q.explanation.length, greaterThan(20));
        expect(q.conceptLabel, isNotEmpty);
        expect(q.prompt.toLowerCase(), isNot(contains('study habit')));
      }
    }
  });
  test('phonics keys use explicit word examples; invented research is labeled',
      () {
    final letters = CoreEnglishCurriculum.grades['g1']!.first;
    final question = letters.quiz.questions.first;
    expect(question.options[question.correctIndex], 'm');
    expect(question.prompt, contains('map'));
    for (final grade in ['g9', 'g10', 'g11', 'g12', 'college']) {
      final text = CoreEnglishCurriculum.grades[grade]!
          .map((t) => t.lesson.sections.map((s) => s.body ?? '').join(' '))
          .join(' ')
          .toLowerCase();
      expect(text, contains('invented'), reason: grade);
    }
  });
  test('shuffled reading and source items carry the givens inside the prompt', () {
    final sequence = CoreEnglishCurriculum.grades['g2']![4].quiz.questions;
    expect(sequence.first.prompt, contains('Mina put soil in a pot'));
    expect(sequence[2].prompt, contains('Days later a shoot appeared'));
    final literature = CoreEnglishCurriculum.grades['g7']![3].quiz.questions;
    expect(literature.first.prompt, contains('village dock after sunset'));
    expect(literature[1].prompt, contains('Lila found an unclaimed bag'));
    final sources = CoreEnglishCurriculum.grades['g12']![2].quiz.questions;
    expect(sources.first.prompt, contains('12 of 20 volunteers'));
    expect(sources[1].prompt, contains('80 of 200'));
    final logic = CoreEnglishCurriculum.grades['g11']![3].challenge.rounds;
    expect(logic.first.prompt, contains('If a form is incomplete, it is rejected'));
  });
}
