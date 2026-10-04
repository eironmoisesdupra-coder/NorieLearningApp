import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_quiz_policy.dart';

void main() {
  final catalog = AnatomyAtlasCatalog.fromJson({
    'schemaVersion': 1,
    'references': [
      for (final id in ['male', 'female'])
        {'id': id, 'label': id, 'description': ''}
    ],
    'structures': [
      for (var i = 0; i < 8; i++)
        {
          'id': 's$i',
          'name': 'Structure $i',
          'reference': i < 4 ? 'male' : 'female',
          'systems': ['skeletal'],
          'asset': 'bones',
          'source': 'test',
        }
    ],
  });
  test('questions and distractors stay inside the requested reference', () {
    final quiz = AtlasQuizSession.generate(catalog, 'female', {'skeletal'},
        random: Random(2));
    expect(quiz.questions.length, 4);
    for (final q in quiz.questions) {
      expect(q.target.reference, 'female');
      expect(q.options.toSet().length, q.options.length);
      expect(q.options, contains(q.target.name));
      expect(q.options.every((name) => int.parse(name.split(' ').last) >= 4),
          isTrue);
    }
  });
  test('each answer and final XP reward can be recorded only once', () {
    final quiz = AtlasQuizSession.generate(catalog, 'male', {'skeletal'},
        random: Random(1));
    expect(quiz.takeReward(), isNull);
    expect(quiz.next(), isFalse);
    while (!quiz.finished) {
      expect(quiz.answer(quiz.current.target.name), isTrue);
      expect(quiz.answer(quiz.current.target.name), isNull);
      expect(quiz.next(), isTrue);
    }
    expect(quiz.takeReward(), 40);
    expect(quiz.takeReward(), isNull);
    expect(quiz.answer(quiz.current.target.name), isNull);
  });
  test('every-part scope includes each reference and system hints', () {
    final quiz = AtlasQuizSession.generate(catalog, 'all', {'skeletal'},
        random: Random(3));
    expect(quiz.questions, hasLength(8));
    expect(quiz.questions.map((question) => question.target.reference).toSet(),
        {'male', 'female'});
    expect(quiz.current.hint, contains('Bones, support'));
    expect(quiz.current.hint, isNot(contains(quiz.current.target.name)));
  });
  test('a selected system supplies 20 distinct questions', () {
    final largeCatalog = AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'Male', 'description': ''}
      ],
      'structures': [
        for (var index = 0; index < 50; index++)
          {
            'id': 'part-$index',
            'name': 'Part $index',
            'reference': 'male',
            'systems': [index < 25 ? 'skeletal' : 'muscular'],
            'asset': 'parts',
            'source': 'test',
          }
      ],
    });
    final quiz = AtlasQuizSession.generate(largeCatalog, 'male', {'skeletal'},
        random: Random(2));
    expect(quiz.questions, hasLength(20));
    expect(quiz.questions.map((question) => question.target.id).toSet(),
        hasLength(20));
    expect(
        quiz.questions
            .every((question) => question.target.systems.contains('skeletal')),
        isTrue);
  });
}
