import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/curriculum/domain/guided_assessment.dart';

void main() {
  test(
      'authored formats parse strictly without guessing from multiple-choice prose',
      () {
    final numeric = GuidedAssessmentItem.fromJson({
      'id': 'distance',
      'format': 'numeric',
      'prompt': 'A learner walks 1 m twice. What total distance is walked?',
      'answer': 2,
      'unit': 'm',
      'tolerance': 0
    });
    expect(numeric.checkNumeric('2', 'm'), isTrue);
    expect(
        () => GuidedAssessmentItem.fromJson({
              'id': 'bad',
              'format': 'numeric',
              'prompt': 'Distance',
              'answer': 'two',
              'unit': 'm'
            }),
        throwsFormatException);
    expect(
        () => GuidedAssessmentItem.fromJson({
              'id': 'bad',
              'format': 'multiSelect',
              'prompt': 'Select',
              'options': ['a', 'b'],
              'answers': [9]
            }),
        throwsFormatException);
  });
  test('help is sticky and never becomes independent evidence', () {
    final session = GuidedPracticeSession();
    session.revealHelp('q1');
    session.record('q1', correct: true);
    session.record('q1', correct: true);
    expect(
        session.attempts.every((a) => a.kind == PracticeEvidenceKind.assisted),
        isTrue);
    expect(session.independentCorrect, 0);
  });
  test('numeric assessment requires compatible units and finite numbers', () {
    const item = GuidedAssessmentItem.numeric(
        id: 'n', prompt: 'Distance', answer: 2, unit: 'm', tolerance: 0.01);
    expect(item.checkNumeric('2.005', 'm'), isTrue);
    expect(item.checkNumeric('2', 'cm'), isFalse);
    expect(item.checkNumeric('NaN', 'm'), isFalse);
  });
  test('multiselect and ordering compare complete answers', () {
    final item = GuidedAssessmentItem.selection(
        id: 's', prompt: 'Select', options: ['a', 'b', 'c'], answers: {0, 2});
    expect(item.checkSelection({2, 0}), isTrue);
    expect(item.checkSelection({0}), isFalse);
    final order = GuidedAssessmentItem.ordering(
        id: 'o', prompt: 'Order', items: ['first', 'next']);
    expect(order.checkOrder(['next', 'first']), isFalse);
    expect(order.checkOrder(['first', 'next']), isTrue);
  });
}
