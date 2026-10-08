import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/science/science_curriculum.dart';
import 'package:norie_learning/features/content/data/science/science_expansion.dart';
import 'package:norie_learning/features/content/data/authored/advanced_mathematics.dart';
import 'package:norie_learning/features/content/data/authored/advanced_english.dart';
import 'package:norie_learning/features/content/data/authored/primary_english.dart';
import 'package:norie_learning/features/content/data/authored/secondary_english.dart';

void main() {
  final topics = [
    ...ScienceCurriculum.grades.values.expand((topics) => topics),
    ...ScienceExpansion.lessons.values,
    ...advancedMathematics.values,
    ...advancedEnglish.values,
    ...primaryEnglish.values,
    ...secondaryEnglish.values,
  ];
  String prompt(String topicId, int number) {
    final topic = topics.singleWhere((topic) => topic.id == topicId);
    final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
    return questions[number - 1].prompt.toLowerCase();
  }

  // These items can be issued individually in random order. Check the givens
  // in the prompt itself, without access to lesson prose or another question.
  final cases = <(String, int, List<String>)>[
    (
      'english.g3.word-meanings-from-context',
      2,
      ['the glass was fragile', 'carried it gently']
    ),
    (
      'english.g4.main-ideas-and-supporting-details',
      5,
      ['earlier opening', 'signs', 'reading corner']
    ),
    (
      'english.g5.writing-compare-and-contrast-paragraphs',
      7,
      ['print', 'audio', 'same story']
    ),
    (
      'english.g6.inference-supported-by-text',
      3,
      ['clock three times', 'tapped his foot', 'looked toward the door']
    ),
    (
      'english.g6.inference-supported-by-text',
      5,
      ['scarf', 'her hands', 'warm stage']
    ),
    (
      'english.g6.inference-supported-by-text',
      7,
      ['behind a book', 'avoided', 'gaze']
    ),
    (
      'english.g6.inference-supported-by-text',
      10,
      ['note', 'packing', 'forced']
    ),
    for (final number in [1, 2, 3, 7])
      (
        'english.g7.character-motivation-and-choices',
        number,
        ['omar', 'feared mistakes', 'practice with him alone']
      ),
    (
      'english.g8.claims-and-fair-counterclaims',
      1,
      ['one evening each week', 'before closing']
    ),
    (
      'english.g8.claims-and-fair-counterclaims',
      3,
      ['one evening each week', 'before closing']
    ),
    (
      'english.g8.claims-and-fair-counterclaims',
      4,
      ['library', 'staffing', 'cost']
    ),
    ('english.g8.claims-and-fair-counterclaims', 7, ['no root', 'site']),
    for (final number in [1, 3])
      (
        'english.g9.integrating-quotations-into-analysis',
        number,
        ['at the doorway, i paused', 'held the invitation tightly']
      ),
    for (final number in [6, 9])
      (
        'english.g9.integrating-quotations-into-analysis',
        number,
        ['narrow bridge manageable', 'testing the first board']
      ),
    ('science.g5.food-webs', 8, ['grass → rabbit', 'frog → hawk']),
    ('science.g5.food-webs', 9, ['grass → rabbit', 'grass → grasshopper']),
    ('science.g5.food-webs', 10, ['rabbit → hawk', 'frog → hawk']),
    (
      'science.g6.organisms-classification',
      11,
      ['1:', '3:', 'backbone', 'legs']
    ),
    (
      'science.g6.organisms-classification',
      15,
      ['pigeon', 'frog', 'ant', 'earthworm']
    ),
    ('science.g6.mixtures-solutions', 13, ['16 g to 100 ml']),
    (
      'science.g7.scientific-investigation',
      1,
      ['changes the surface', 'measures travel time']
    ),
    ('science.g7.scientific-investigation', 14, ['1.8', '2.2', '2.8', '3.2']),
    ('science.g7.matter-particles', 16, ['water', 'evaporates', 'no other']),
    ('science.g8.work-energy', 10, ['1 kg', '2 m/s', '4 m/s']),
    for (final number in [4, 10, 11, 12, 13, 14, 15, 16, 17])
      (
        'science.g8.genetics-basics',
        number,
        ['a is dominant', 'purple', 'aa is white']
      ),
    ('science.g10.electricity-magnetism', 18, ['12 v', '6 Ω', '12 Ω']),
    (
      'science.college.general-chemistry',
      10,
      ['delta h', '30 kj/mol', 'delta s', '0.100 kj/(mol k)']
    ),
    (
      'science.g11.heat-transfer-and-calorimetry',
      6,
      ['equal masses', 'water', '50°c', '10°c']
    ),
    (
      'mathematics.g12.optimizing-a-rectangle-with-derivatives',
      2,
      ['perimeter forty', 'length x']
    ),
    for (final number in [1, 2, 3, 4, 9])
      (
        'english.g12.synthesizing-sources-that-differ',
        number,
        ['20 volunteer', '200 randomly', 'timetable']
      ),
  ];
  for (final (topic, number, givens) in cases) {
    test('$topic item $number supplies independently required givens', () {
      final text = prompt(topic, number);
      for (final given in givens) {
        expect(text, contains(given.toLowerCase()),
            reason: 'Missing given: $given');
      }
    });
  }
}
