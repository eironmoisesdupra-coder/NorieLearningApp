import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/science/college_science.dart';
import 'package:norie_learning/features/content/data/science/science_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';

void main() {
  test(
      'College authored pack replaces starters without changing saved topic IDs',
      () {
    const slugs = [
      'general-biology',
      'general-chemistry',
      'university-physics',
      'earth-science',
      'scientific-research',
    ];
    expect(NorieFoundationCurriculum.topicsFor('Science', 'college').take(5),
        orderedEquals(collegeScienceTopics));
    expect(ScienceCurriculum.grades['college'], same(collegeScienceTopics));
    expect(collegeScienceTopics.map((topic) => topic.title),
        NorieFoundationCurriculum.lessonTitles('Science', 'college').take(5));
    expect(collegeScienceTopics, hasLength(5));
    for (var i = 0; i < slugs.length; i++) {
      final topic = collegeScienceTopics[i];
      expect(topic.id, 'science.college.${slugs[i]}');
      expect(topic.order, i + 1);
      expect(topic.gradeLevel, 'college');
      expect(topic.category, 'College');
      expect(topic.prerequisiteTopicId,
          i == 0 ? null : 'science.college.${slugs[i - 1]}');
      expect(topic.lesson.introduction, isNot(startsWith('Build a clear')));
    }
  });

  test(
      'College assessments cover taught subjects with complete reasoned feedback',
      () {
    final stems = <String>{};
    final ids = <String>{};
    for (final topic in collegeScienceTopics) {
      expect(topic.lesson.sections.first.points, hasLength(4));
      expect(
          topic.lesson.sections
              .any((s) => s.title.startsWith('Worked example')),
          isTrue);
      expect(topic.lesson.sections.any((s) => s.title.startsWith('Guided')),
          isTrue);
      expect(
          topic.lesson.sections.any((s) => s.title.contains('Common mistakes')),
          isTrue);
      expect(
          topic.lesson.sections
              .any((s) => s.reveal && s.title.contains('recap')),
          isTrue);
      expect(topic.quiz.questions, hasLength(20));
      expect(topic.challenge.rounds, hasLength(3));
      final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
      for (var index = 0; index < questions.length; index++) {
        final q = questions[index];
        expect(ids.add(q.id), isTrue, reason: q.id);
        expect(stems.add(q.prompt.trim().toLowerCase()), isTrue, reason: q.id);
        expect(q.hasValidAnswer, isTrue, reason: q.id);
        expect(q.options.toSet(), hasLength(4), reason: q.id);
        expect(q.explanation.length, greaterThan(45), reason: q.id);
        expect(
            q.difficulty,
            index < 7
                ? 'foundation'
                : index < 14
                    ? 'intermediate'
                    : 'advanced');
        expect(q.prompt.toLowerCase(), isNot(contains('study strategy')));
      }
    }
    expect(ids, hasLength(115));
  });

  test('College uses fifteen registered offline diagrams with valid quantities',
      () {
    final used = <String>{};
    for (final topic in collegeScienceTopics) {
      final visuals = topic.lesson.sections.where((s) => s.visualType != null);
      expect(visuals, hasLength(3));
      for (final section in visuals) {
        final id = section.visualType!;
        used.add(id);
        final figure = collegeScienceFigures[id]!;
        expect(ScienceCurriculum.figures[id], same(figure));
        expect(figure.validate, returnsNormally);
        expect(section.visualCaption, isNotEmpty);
        expect(figure.note, isNotEmpty);
      }
    }
    expect(used, collegeScienceFigures.keys.toSet());
    expect(used, hasLength(15));
    expect(collegeScienceFigures['college_biology_rates']!.values,
        [90 * 1 / (2 + 1), 90 * 2 / (2 + 2), 90 * 6 / (2 + 6)]);
    expect(
        collegeScienceFigures['college_physics_energy']!.values,
        [0, 200 * math.pow(0.05, 2) / 2, 200 * math.pow(0.10, 2) / 2]
            .map((number) => closeTo(number, 1e-10)));
    expect(
        collegeScienceFigures['college_earth_budget']!.values,
        [1360 / 4, 0.30 * 1360 / 4, (1 - 0.30) * 1360 / 4]
            .map((number) => closeTo(number, 1e-10)));
  });

  test('independently calculated numerical answers survive answer shuffling',
      () {
    final biology = collegeScienceTopics[0];
    expect(_answer(biology.quiz.questions[8]), '${90 * 6 / (2 + 6)}');
    expect(_answer(biology.challenge.rounds[0]),
        '90 then 60 in the supplied rate units');
    expect(120 * 9 / (3 + 9), 90);
    expect(120 * 9 / (9 + 9), 60);

    final chemistry = collegeScienceTopics[1];
    final gibbs = 8.314 * 300 * math.log(0.1) / 1000;
    expect(gibbs, closeTo(-5.74, 0.01));
    expect(_answer(chemistry.quiz.questions[14]), 'About -5.74 kJ/mol');
    expect(_answer(chemistry.challenge.rounds[0]),
        '${(-20 - 300 * -0.050).toInt()} kJ/mol');
    expect(_answer(chemistry.challenge.rounds[1]), '1/16');

    final physics = collegeScienceTopics[2];
    final omega = math.sqrt(200 / 0.50);
    expect(_answer(physics.quiz.questions[7]), '${omega.toInt()} rad/s');
    expect(2 * math.pi / omega, closeTo(0.314, 0.001));
    expect(_answer(physics.challenge.rounds[1]),
        '${math.sqrt(2 * 0.75 / 0.50).toStringAsFixed(2)} m/s');

    final earth = collegeScienceTopics[3];
    expect(_answer(earth.challenge.rounds[0]),
        '+${((1 - 0.20) * 1200 / 4 - 235).toInt()} W/m2');
    expect(_answer(earth.challenge.rounds[1]), '${(9 - 11) * 4} GtC');
    expect(
        _answer(earth.challenge.rounds[2]), '${(3 * 44 / 12).toInt()} GtCO2');

    final research = collegeScienceTopics[4];
    expect(1 - math.pow(0.95, 20), closeTo(0.64, 0.01));
    expect(_answer(research.quiz.questions[19]), '0.64');
    expect(_answer(research.challenge.rounds[1]),
        'About ${math.sqrt(16 / 16 + 16 / 16).toStringAsFixed(2)} mm');
  });

  test('answer keys preserve important limits of scientific inference', () {
    expect(_answer(collegeScienceTopics[0].quiz.questions[16]),
        'It combines binding and catalytic rate constants');
    expect(_answer(collegeScienceTopics[1].quiz.questions[16]),
        'Actual Delta G is positive and reverse change is favored');
    expect(_answer(collegeScienceTopics[2].quiz.questions[17]),
        'The oscillator can pass that position in opposite directions');
    expect(_answer(collegeScienceTopics[3].quiz.questions[18]),
        'Multiple exchanging reservoirs respond on different time scales');
    expect(_answer(collegeScienceTopics[4].quiz.questions[16]),
        'The evidence did not meet the rejection criterion');
  });
}

String _answer(NorieQuestionContent question) =>
    question.options[question.correctIndex];
