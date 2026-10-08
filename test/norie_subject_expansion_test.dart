import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/authored/authored_subject_curriculum.dart';

void main() {
  test('context substitution describes fragility rather than a completed break',
      () {
    final topic = NorieFoundationCurriculum.topicsFor('English', 'g3').last;
    final explanation = topic.lesson.sections
        .firstWhere((s) => s.title == 'Explore the idea')
        .body!;
    expect(explanation, contains('The glass was easy to break'));
    expect(explanation, isNot(contains('The glass was easily broken')));
  });
  test(
      'rhetorical library-hours example concerns access rather than book stock',
      () {
    final topic = NorieFoundationCurriculum.topicsFor('English', 'g11').last;
    final prose = topic.lesson.sections.map((s) => s.body ?? '').join(' ');
    expect(prose, contains('doors closed'));
    expect(prose, isNot(contains('empty shelves')));
  });
  for (final subject in ['Mathematics', 'English']) {
    test('$subject adds a focused authored lesson at every grade', () {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(topics, hasLength(6), reason: '$subject ${grade.id}');
        final lesson = topics.last;
        expect(lesson.id, startsWith('${subject.toLowerCase()}.${grade.id}.'));
        expect(lesson.order, 6);
        expect(NorieFoundationCurriculum.isAuthored(lesson), isTrue);
        expect(lesson.prerequisiteTopicId, topics[4].id);
        expect(lesson.quiz.questions, hasLength(8));
        expect(lesson.challenge.rounds, hasLength(3));
        expect(
            lesson.lesson.sections.first.points.length, inInclusiveRange(3, 5));
        for (final heading in [
          'Worked example',
          'Guided',
          'Common mistakes',
          'recap'
        ]) {
          expect(
              lesson.lesson.sections
                  .any((section) => section.title.contains(heading)),
              isTrue,
              reason: '${lesson.id}: $heading');
        }
        expect(
            lesson.lesson.sections.any((section) => section.visualType != null),
            isTrue);
        final visual = lesson.lesson.sections
            .firstWhere((section) => section.visualType != null);
        expect(AuthoredSubjectCurriculum.visuals[visual.visualType], isNotNull);
        AuthoredSubjectCurriculum.visuals[visual.visualType]!.validate();
        final questions = [
          ...lesson.quiz.questions,
          ...lesson.challenge.rounds
        ];
        expect(questions.map((q) => q.prompt).toSet(), hasLength(11));
        for (final q in questions) {
          expect(q.hasValidAnswer, isTrue, reason: q.id);
          expect(q.explanation.length, greaterThan(30), reason: q.id);
          expect(q.prompt, isNot(contains('study strategy')));
        }
      }
    });
  }

  test(
      'every original subject lesson is authored and coverage is labeled honestly',
      () {
    for (final subject in ['Mathematics', 'English']) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        expect(topics.take(5).map(NorieFoundationCurriculum.isAuthored),
            everyElement(true));
        expect(NorieFoundationCurriculum.coverageLabel(subject, grade.id),
            '6 authored lessons');
      }
    }
  });

  test(
      'restored Grade 1 Mathematics has stable IDs and independent mastery questions',
      () {
    const slugs = [
      'counting-to-100',
      'place-value',
      'addition-basics',
      'subtraction-basics',
      'shapes-patterns'
    ];
    final topics = NorieFoundationCurriculum.topicsFor('Mathematics', 'g1');
    expect(topics[3].quiz.questions.last.prompt, contains('taken out'));
    for (var i = 0; i < 5; i++) {
      final topic = topics[i];
      expect(topic.id, 'mathematics.g1.${slugs[i]}');
      expect(topic.lesson.completionXp, 50);
      expect(topic.quiz.questions, hasLength(20));
      expect(topic.challenge.rounds, hasLength(3));
      expect(
          topic.lesson.sections
              .any((s) => s.title.toLowerCase().contains('worked example')),
          isTrue);
      expect(
          topic.lesson.sections.any((s) => s.title.contains('Guided')), isTrue);
      expect(
          topic.lesson.sections
              .any((s) => s.title.toLowerCase().contains('mistakes')),
          isTrue);
      expect(
          topic.lesson.sections.any((s) => s.title.contains('recap')), isTrue);
      final practiceStems = topic.quiz.questions.map((q) => q.prompt).toSet();
      expect(
          topic.challenge.rounds
              .every((q) => !practiceStems.contains(q.prompt)),
          isTrue);
      for (final section
          in topic.lesson.sections.where((s) => s.visualType != null)) {
        expect(section.body, isNotEmpty,
            reason: 'old point-based prose must render beside its diagram');
        expect(
            AuthoredSubjectCurriculum.visuals[section.visualType], isNotNull);
      }
    }
    final placeValue = topics[1].quiz.questions.firstWhere(
        (q) => q.prompt == 'In 73, what is the value of the tens digit?',
        orElse: () => topics[1].challenge.rounds.firstWhere(
            (q) => q.prompt == 'In 73, what is the value of the tens digit?'));
    expect(placeValue.options[placeValue.correctIndex], '70');
  });
}
