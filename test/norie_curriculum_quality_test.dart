import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/quality/curriculum_quality.dart';
import 'package:norie_learning/features/content/quality/published_curriculum_quality.dart';

NorieQuestionContent question(String id,
        {List<String>? options, int answer = 0}) =>
    NorieQuestionContent(
        id: id,
        prompt: 'What is two plus one?',
        options: options ?? ['3', '4'],
        correctIndex: answer,
        explanation: 'Two objects and one object make three.');

NorieTopicContent topic(String id,
        {String? prerequisite,
        List<NorieQuestionContent>? quiz,
        List<NorieQuestionContent>? challenge,
        String? visual}) =>
    NorieTopicContent(
      id: id,
      subject: 'Mathematics',
      category: 'Grade 1',
      gradeLevel: 'g1',
      title: 'Adding objects',
      subtitle: '',
      order: 1,
      accent: 'cyan',
      prerequisiteTopicId: prerequisite,
      visualType: visual,
      lesson: const NorieLessonContent(
          heading: 'Adding',
          introduction: 'Join groups.',
          sections: [
            NorieLessonSection(
                title: 'Example',
                symbol: '',
                points: ['Two and one make three.'])
          ],
          keyConceptTitle: 'Recap',
          keyConceptBody: 'Addition joins groups.'),
      quiz: NorieQuizContent(questions: quiz ?? [question('$id.q')]),
      challenge: NorieChallengeContent(
          title: 'Mastery',
          description: 'Try it.',
          rounds: challenge ?? [question('$id.c')]),
    );

CurriculumQualityReport scan(List<NorieTopicContent> topics,
        {Set<String>? authored,
        Map<String, List<String>> assets = const {},
        bool Function(String)? exists}) =>
    CurriculumQualityScanner().scan(
        topics: topics,
        authoredTopicIds: authored ?? topics.map((t) => t.id).toSet(),
        visualIds: {'math'},
        visualAssets: assets,
        assetExists: exists);

void main() {
  test('published registry is fully scanned including additional subjects', () {
    final report = scanPublishedCurriculum();
    expect(report.topicCount, 249);
    expect(report.errors, isEmpty, reason: report.toJson().toString());
  });
  test('short approved prose produces editorial warnings, no hard error', () {
    final report = scan([topic('a')]);
    expect(report.errors, isEmpty);
    expect(report.warnings.map((i) => i.code), contains('short_lesson'));
    expect(report.toJson()['topic_count'], 1);
  });
  test('rejects duplicate topic and question identities', () {
    final report = scan([
      topic('a'),
      topic('a'),
      topic('b', quiz: [question('a.q')])
    ]);
    expect(report.errors.map((i) => i.code),
        containsAll(['duplicate_topic_id', 'duplicate_question_id']));
  });
  test('only exact same-topic quiz/challenge reuse is permitted', () {
    expect(
        scan([
          topic('a',
              quiz: [question('shared')], challenge: [question('shared')])
        ]).errors,
        isEmpty);
    expect(
        scan([
          topic('a',
              quiz: [question('shared')],
              challenge: [question('shared', answer: 1)])
        ]).errors.map((i) => i.code),
        contains('duplicate_question_id'));
    expect(
        scan([
          topic('a', quiz: [question('shared'), question('shared')])
        ]).errors.map((i) => i.code),
        contains('duplicate_question_id'));
  });
  test('checks answer bounds and duplicate or blank options', () {
    final report = scan([
      topic('a', quiz: [
        question('bad', options: ['3', ' 3 ', ''], answer: -1)
      ])
    ]);
    expect(
        report.errors.map((i) => i.code),
        containsAll(
            ['invalid_answer_index', 'duplicate_option', 'empty_option']));
  });
  test('duplicate question text cannot hide behind different IDs', () {
    expect(
        scan([
          topic('a', quiz: [question('one'), question('two')])
        ]).errors.map((i) => i.code),
        contains('duplicate_question_content'));
  });
  test('reordering answer options cannot hide a repeated question', () {
    final report = scan([
      topic('a', quiz: [
        question('one'),
        question('two', options: ['4', '3'], answer: 1),
      ]),
    ]);
    expect(report.errors.map((i) => i.code),
        contains('duplicate_question_content'));
  });
  test('invalid publication subject and grade mappings are rejected', () {
    final report = CurriculumQualityScanner().scan(topics: [
      topic('a')
    ], authoredTopicIds: {
      'a'
    }, visualIds: {}, publications: const [
      CurriculumPublication('a', 'Science', 'g2'),
      CurriculumPublication('missing', 'Science', 'g2')
    ]);
    expect(report.errors.map((i) => i.code),
        containsAll(['publication_mismatch', 'publication_missing_topic']));
  });
  test('checks missing prerequisites and cycles without recursion overflow',
      () {
    final report = scan([
      topic('a', prerequisite: 'b'),
      topic('b', prerequisite: 'a'),
      topic('c', prerequisite: 'missing')
    ]);
    expect(report.errors.map((i) => i.code),
        containsAll(['prerequisite_cycle', 'missing_prerequisite']));
  });
  test('checks authored coverage, visuals and explicit local assets', () {
    expect(
        scan([topic('a', visual: 'unknown')], authored: {})
            .errors
            .map((i) => i.code),
        containsAll(['unauthored_topic', 'unknown_visual']));
    expect(
        scan([
          topic('a', visual: 'math')
        ], assets: {
          'math': ['assets/missing.svg']
        }, exists: (_) => false).errors.map((i) => i.code),
        contains('missing_asset'));
  });
}
