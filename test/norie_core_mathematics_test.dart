import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/authored/core_mathematics_curriculum.dart';

void main() {
  const originalTitles = <String, List<String>>{
    'g2': [
      'Place Value to 1000',
      'Addition Strategies',
      'Subtraction Strategies',
      'Equal Groups',
      'Length, Time & Money'
    ],
    'g3': [
      'Multiplication Facts',
      'Division Facts',
      'Fractions',
      'Area & Perimeter',
      'Data & Graphs'
    ],
    'g4': [
      'Multi-Digit Operations',
      'Factors & Multiples',
      'Equivalent Fractions',
      'Decimals',
      'Angles & Symmetry'
    ],
    'g5': [
      'Fraction Operations',
      'Decimal Operations',
      'Volume',
      'Coordinate Plane',
      'Numerical Expressions'
    ],
    'g6': [
      'Ratios & Rates',
      'Percent',
      'Integers',
      'Expressions & Variables',
      'Statistics'
    ],
    'g7': [
      'Rational Numbers',
      'Proportions',
      'Algebraic Expressions',
      'Equations & Inequalities',
      'Geometry & Probability'
    ],
    'g8': [
      'Linear Equations',
      'Functions',
      'Systems of Equations',
      'Exponents & Radicals',
      'Pythagorean Theorem'
    ],
    'g9': [
      'Polynomials',
      'Quadratic Foundations',
      'Coordinate Geometry',
      'Similarity & Congruence',
      'Intro Statistics'
    ],
    'g10': [
      'Quadratic Equations',
      'Functions & Graphs',
      'Trigonometry Basics',
      'Circles',
      'Probability & Combinatorics'
    ],
    'g11': [
      'Advanced Algebra',
      'Sequences & Series',
      'Trigonometric Functions',
      'Analytic Geometry',
      'Intro Calculus'
    ],
    'g12': [
      'Limits',
      'Derivatives',
      'Integrals',
      'Probability Distributions',
      'Applied Mathematics'
    ],
    'college': [
      'College Algebra',
      'Precalculus',
      'Differential Calculus',
      'Integral Calculus',
      'Linear Algebra'
    ],
  };
  test('original Mathematics G2–College lessons teach their actual subjects',
      () {
    var count = 0;
    for (final grade in NorieFoundationCurriculum.gradeLevels.skip(1)) {
      final titles = originalTitles[grade.id]!;
      final topics =
          NorieFoundationCurriculum.topicsFor('Mathematics', grade.id)
              .take(5)
              .toList();
      for (var index = 0; index < 5; index++) {
        final topic = topics[index];
        count++;
        expect(NorieFoundationCurriculum.isAuthored(topic), isTrue,
            reason: topic.id);
        expect(topic.id,
            'mathematics.${grade.id}.${titles[index].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}');
        expect(topic.order, index + 1);
        expect(topic.title, titles[index]);
        expect(topic.lesson.completionXp, 50);
        expect(
            topic.lesson.sections.first.points.length, inInclusiveRange(3, 5));
        for (final heading in [
          'Worked example',
          'Guided',
          'Common mistakes',
          'recap'
        ]) {
          expect(
              topic.lesson.sections
                  .any((section) => section.title.contains(heading)),
              isTrue,
              reason: '${topic.id}: $heading');
        }
        expect(topic.quiz.questions.length, greaterThanOrEqualTo(8));
        expect(topic.challenge.rounds, hasLength(3));
        expect(
            topic.lesson.sections.any((section) => section.visualType != null),
            isTrue);
        final visual = topic.lesson.sections
            .firstWhere((section) => section.visualType != null);
        expect(CoreMathematicsCurriculum.visuals[visual.visualType], isNotNull);
        CoreMathematicsCurriculum.visuals[visual.visualType]!.validate();
        expect(topic.prerequisiteTopicId,
            index == 0 ? null : topics[index - 1].id);
        final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
        expect(questions.map((q) => q.prompt).toSet().length, questions.length);
        for (final q in questions) {
          expect(q.hasValidAnswer, isTrue, reason: q.id);
          expect(q.prompt.toLowerCase(), isNot(contains('focus on first')));
          expect(q.prompt.toLowerCase(), isNot(contains('study strategy')));
        }
      }
    }
    expect(count, 60);
  });

  test('core Mathematics has sixty actual diagram models', () {
    expect(CoreMathematicsCurriculum.grades.values.expand((topics) => topics),
        hasLength(60));
    expect(CoreMathematicsCurriculum.visuals, hasLength(60));
    for (final visual in CoreMathematicsCurriculum.visuals.values) {
      visual.validate();
      expect(visual.labels.length, greaterThanOrEqualTo(2));
      expect(
          visual.details.every((detail) => detail.trim().isNotEmpty), isTrue);
    }
  });

  test(
      'numeric answer keys agree with independent arithmetic across every grade',
      () {
    final checks = <(String, int, String, num)>[
      ('g2', 2, '46 + 27', 46 + 27),
      ('g2', 3, '52 − 28', 52 - 28),
      ('g3', 1, '7 × 6', 7 * 6),
      ('g3', 2, '35 ÷ 5', 35 / 5),
      ('g4', 1, '256 + 187', 256 + 187),
      ('g4', 4, '0.27 + 0.50', .27 + .50),
      ('g5', 1, '3/4 + 1/6', 3 / 4 + 1 / 6),
      ('g5', 2, '1.2 × 0.3', 1.2 * .3),
      ('g6', 1, '180 km in four', 180 / 4),
      ('g6', 5, 'Mean of 2, 4, 4, 6, 9', (2 + 4 + 4 + 6 + 9) / 5),
      ('g7', 1, '−1/2 + 3/4', -1 / 2 + 3 / 4),
      ('g7', 4, '2x + 5 = 17', (17 - 5) / 2),
      ('g8', 1, '5x − 7 = 3x + 9', (9 + 7) / (5 - 3)),
      ('g8', 4, '2³ × 2²', 8 * 4),
      ('g9', 1, 'At x = 2, x² + 3x − 10', 2 * 2 + 3 * 2 - 10),
      ('g9', 3, 'Distance between (2, 3) and (8, 11)', 10),
      ('g10', 1, 'Discriminant of x² − 5x + 6', 25 - 4 * 6),
      ('g10', 5, 'Choose two people from six', 6 * 5 / 2),
      ('g11', 2, 'Sum of 2, 6, 18, 54', 2 + 6 + 18 + 54),
      ('g11', 5, 'Average rate of x² from two to four', (16 - 4) / (4 - 2)),
      ('g12', 2, 'Derivative rate of 3x³ − 2x + 5 at two', 9 * 2 * 2 - 2),
      ('g12', 3, 'Integral of 2x from one to three', 3 * 3 - 1),
      ('college', 1, '(x + 2)/(x − 1) = 3', 5 / 2),
      ('college', 4, 'Integral of 2x(x² + 1)³ from zero to one', (16 - 1) / 4),
    ];
    for (final (grade, order, prefix, expected) in checks) {
      final topic = CoreMathematicsCurriculum.grades[grade]![order - 1];
      final question = [...topic.quiz.questions, ...topic.challenge.rounds]
          .singleWhere((q) => q.prompt.startsWith(prefix));
      final answer =
          question.options[question.correctIndex].replaceAll('−', '-');
      final match =
          RegExp(r'^(-?\d+(?:\.\d+)?)(?:/(\d+))?').firstMatch(answer)!;
      final numerator = num.parse(match.group(1)!);
      final value = match.group(2) == null
          ? numerator
          : numerator / num.parse(match.group(2)!);
      expect(value, closeTo(expected, 1e-10), reason: question.id);
    }
  });
}
