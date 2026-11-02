import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/standards/deped_mathematics.dart';
import 'package:norie_learning/features/content/quality/curriculum_quality.dart';

void main() {
  test('Mathematics paths cover G1–G10 only with complete authored units', () {
    expect(depedMathematics.keys.toSet(),
        {for (var grade = 1; grade <= 10; grade++) 'g$grade'});
    final topicIds = <String>{};
    final questionIds = <String>{};
    for (final entry in depedMathematics.entries) {
      expect(entry.value.length, inInclusiveRange(8, 16), reason: entry.key);
      for (var index = 0; index < entry.value.length; index++) {
        final topic = entry.value[index];
        expect(topicIds.add(topic.id), isTrue);
        expect(topic.gradeLevel, entry.key);
        expect(topic.subject, 'Mathematics');
        expect(topic.order, index + 1);
        expect(topic.prerequisiteTopicId,
            index == 0 ? null : entry.value[index - 1].id);
        expect(topic.quiz.questions, hasLength(8));
        expect(topic.challenge.rounds, hasLength(3));
        final sections = topic.lesson.sections;
        expect(sections.first.title, 'Learning objectives');
        expect(sections.first.points.length, inInclusiveRange(3, 5));
        expect(
            sections.map((s) => s.title),
            containsAll([
              'Explore the idea',
              'Diagram and model',
              'Worked example — four reasoning steps',
              'Guided example — try before revealing',
              'Guided solution',
              'Common mistakes',
              'Lesson recap',
            ]));
        expect(sections.singleWhere((s) => s.title == 'Guided solution').reveal,
            isTrue);
        for (final section in sections) {
          if (section.visualType != null) {
            final visual = depedMathematicsVisuals[section.visualType];
            expect(visual, isNotNull, reason: topic.id);
            expect(visual!.labels.length, greaterThanOrEqualTo(2));
            visual.validate();
          } else {
            expect(section.body?.trim(), isNotEmpty, reason: topic.id);
          }
        }
        final prompts = <String>{};
        for (final q in [
          ...topic.quiz.questions,
          ...topic.challenge.rounds,
        ]) {
          expect(questionIds.add(q.id), isTrue);
          expect(prompts.add(q.prompt.trim()), isTrue,
              reason: '${topic.id}: repeated practice/mastery prompt');
          expect(q.hasValidAnswer, isTrue);
          expect(q.options.toSet(), hasLength(4));
          expect(q.explanation.trim().length, greaterThan(15));
        }
      }
    }
  });

  test('Structural quality scanner accepts all topics and offline models', () {
    final topics = depedMathematics.values.expand((grade) => grade).toList();
    final report = CurriculumQualityScanner().scan(
      topics: topics,
      authoredTopicIds: topics.map((topic) => topic.id).toSet(),
      visualIds: {'authored-path', ...depedMathematicsVisuals.keys},
    );
    expect(report.errors.map((e) => e.toJson()).toList(), isEmpty);
    expect(report.warnings.map((e) => e.toJson()).toList(), isEmpty);
  });

  test('Every grade has official URLs and honest quarterly source labels', () {
    expect(depedMathematicsSources.keys.toSet(), depedMathematics.keys.toSet());
    for (final grade in depedMathematics.keys) {
      final sources = depedMathematicsSources[grade]!;
      for (var quarter = 1; quarter <= 4; quarter++) {
        final citation =
            sources.singleWhere((source) => source.contains('Q$quarter,'));
        expect(citation, contains('https://www.deped.gov.ph/'));
        expect(citation, contains('Grade ${grade.substring(1)}'));
        expect(citation, matches(RegExp(r'p{1,2}\.\d+')));
      }
      if (!{'g1', 'g4', 'g7'}.contains(grade)) {
        expect(sources.join(' '), contains('August 2016'));
        expect(sources.join(' '), contains('have not been verified'));
      }
      expect(depedMathematicsCoverageNotes[grade], isNotEmpty);
    }
  });

  test('Grade-specific main domains are concrete, not old irrelevant titles',
      () {
    final expected = <String, List<String>>{
      'g1': ['Shapes', 'Taking Away', 'Picture Data', 'Halves', 'Clock'],
      'g2': ['Sharing', 'Lines', 'Standard Measures', 'Picture Charts'],
      'g3': ['10000', 'Symmetry', 'Elapsed Time', 'Likelihood'],
      'g4': ['One Million', 'Boundary', 'Fraction Amounts', 'Line Graphs'],
      'g5': ['Divisibility', 'Ratios', 'Temperature', 'Experimental'],
      'g6': ['Decimal Problem', 'Surface Area', 'Meter Readings', 'Pie Graphs'],
      'g7': ['Polygon', 'Roots', 'Venn', 'Sampling', 'Scientific'],
      'g8': ['Factoring', 'Rational Algebraic', 'Congruence', 'Probability'],
      'g9': ['Quadratic', 'Variation', 'Parallelogram', 'Oblique'],
      'g10': ['Sequences', 'Polynomial', 'Secants', 'Measures of Position'],
    };
    for (final entry in expected.entries) {
      final titles =
          depedMathematics[entry.key]!.map((t) => t.title).join('\n');
      for (final keyword in entry.value) {
        expect(titles, contains(keyword), reason: entry.key);
      }
    }
    expect(depedMathematics['g5']!.any((t) => t.title == 'Coordinate Plane'),
        isFalse);
    expect(depedMathematics['g9']!.any((t) => t.title == 'Intro Statistics'),
        isFalse);
    expect(
        depedMathematics['g10']!.any((t) => t.title == 'Quadratic Equations'),
        isFalse);
  });

  test(
      'Representative original answer keys agree with independent calculations',
      () {
    void answer(String grade, String title, String prompt, String expected) {
      final topic =
          depedMathematics[grade]!.singleWhere((t) => t.title == title);
      final question = [...topic.quiz.questions, ...topic.challenge.rounds]
          .singleWhere((q) => q.prompt == prompt);
      expect(question.options[question.correctIndex], expected,
          reason: '$grade / $title / $prompt');
    }

    answer('g1', 'Putting Together to 20', 'What is 7 + 8?', '${7 + 8}');
    answer('g2', 'Sharing Equally and Unit Fractions', 'What is 12 ÷ 2?',
        '${12 ~/ 2}');
    answer('g3', 'Numbers Money and Operations to 10000',
        'What is 6,003 - 2,578?', '${6003 - 2578}');
    answer('g4', 'Whole Numbers to One Million', 'What is 498,765 + 123,456?',
        '${498765 + 123456}');
    answer(
        'g5',
        'Polygons Circles and Solid Models',
        'Using π = 22/7, circumference for radius 14 cm?',
        '${(2 * 22 / 7 * 14).round()} cm');
    answer(
        'g6',
        'Solids Nets and Surface Area',
        'Surface area of a closed 4 by 3 by 2 cm prism?',
        '${2 * (4 * 3 + 4 * 2 + 3 * 2)} cm²');
    answer('g7', 'Scientific Notation and Powers of Ten',
        'Multiply (6 × 10⁻³)(2 × 10²).', '1.2 × 10⁰');
    expect(6 * math.pow(10, -3) * 2 * math.pow(10, 2), closeTo(1.2, 1e-12));
    answer(
        'g8',
        'Triangle Inequalities and Parallel Lines',
        'Two sides are 4 and 9. Third side x must satisfy what?',
        '${9 - 4} < x < ${9 + 4}');
    answer(
        'g9',
        'Elevation Depression and Oblique Triangles',
        'Sides 3 and 4 include a 90° angle. Third side?',
        '${math.sqrt(3 * 3 + 4 * 4).round()}');
    answer('g10', 'Arithmetic Sequences and Finite Sums',
        'Fifteenth term of 4,9,14,...?', '${4 + (15 - 1) * 5}');
    answer('g10', 'Measures of Position in Ungrouped Data',
        'Model data Q1 under the stated convention?', '${(20 + 30) ~/ 2}');
    answer(
        'g10',
        'Grouped Positions and Statistical Investigation',
        'L = 19.5, target = 15, cf = 10, f = 10, w = 10. Percentile estimate?',
        '${19.5 + (15 - 10) / 10 * 10}');
  });
}
