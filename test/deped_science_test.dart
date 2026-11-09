import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/standards/deped_science.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/quality/curriculum_quality.dart';

void main() {
  final topics = depedScience.values.expand((grade) => grade).toList();

  test('ten grade paths contain eight substantive units each', () {
    expect(depedScience.keys.toSet(), {
      for (var grade = 1; grade <= 10; grade++) 'g$grade',
    });
    expect(topics, hasLength(80));
    expect(topics.map((topic) => topic.id).toSet(), hasLength(80));
    for (final entry in depedScience.entries) {
      expect(entry.value, hasLength(8));
      for (var index = 0; index < entry.value.length; index++) {
        final topic = entry.value[index];
        expect(topic.gradeLevel, entry.key);
        expect(topic.subject, 'Science');
        expect(topic.order, index + 1);
        expect(topic.prerequisiteTopicId,
            index == 0 ? null : entry.value[index - 1].id);
        final objectives = topic.lesson.sections.first.points;
        expect(objectives.length, inInclusiveRange(3, 5));
        expect(objectives.every((objective) => objective.trim().isNotEmpty),
            isTrue);
        final titles = topic.lesson.sections.map((section) => section.title);
        expect(
            titles,
            containsAll([
              'Worked example: follow the reasoning',
              'Guided question',
              'Guided solution',
              'Common mistake and correction',
              'Recap',
              'Safe observation',
              'Labeled model',
            ]));
        expect(
            topic.lesson.sections
                .singleWhere((section) => section.title == 'Guided solution')
                .reveal,
            isTrue);
      }
    }
  });

  test('every standalone reference path covers all four source quarters', () {
    for (final entry in depedScience.entries) {
      if (entry.key == 'g1' || entry.key == 'g2') continue;
      for (var quarter = 1; quarter <= 4; quarter++) {
        expect(
          entry.value.where((topic) => topic.subtitle.contains('Q$quarter:')),
          hasLength(2),
          reason: '${entry.key} quarter $quarter',
        );
      }
    }
  });

  test('880 checks include eight practice and three independent mastery items',
      () {
    final questionIds = <String>{};
    var count = 0;
    for (final topic in topics) {
      expect(topic.quiz.questions, hasLength(8));
      expect(topic.challenge.rounds, hasLength(3));
      final prompts = <String>{};
      for (final question in [
        ...topic.quiz.questions,
        ...topic.challenge.rounds,
      ]) {
        count++;
        expect(questionIds.add(question.id), isTrue);
        expect(prompts.add(question.prompt.toLowerCase().trim()), isTrue,
            reason: '${topic.id}: repeated assessment prompt');
        expect(question.options, hasLength(4));
        expect(question.options.map((option) => option.toLowerCase()).toSet(),
            hasLength(4));
        expect(question.hasValidAnswer, isTrue);
        expect(question.explanation.length, greaterThan(60));
        expect(question.explanation, isNot(contains('The correct answer is')));
        expect(question.conceptId, startsWith(topic.id));
      }
    }
    expect(count, 880);
  });

  test('all diagrams are offline labeled scientific comparison models', () {
    expect(depedScienceVisuals, hasLength(80));
    for (final topic in topics) {
      final visual = depedScienceVisuals[topic.visualType];
      expect(visual, isNotNull, reason: topic.id);
      expect(visual!.validate, returnsNormally);
      expect(visual.labels, hasLength(4));
      expect(visual.details, hasLength(4));
      final modelSection = topic.lesson.sections
          .singleWhere((section) => section.title == 'Labeled model');
      expect(modelSection.visualType, topic.visualType);
      for (var index = 0; index < visual.labels.length; index++) {
        final explanation = topic.lesson.sections
            .singleWhere((section) => section.title == visual.labels[index]);
        expect(explanation.body, visual.details[index]);
      }
    }
  });

  test('sources distinguish integration, MATATAG, and legacy uncertainty', () {
    expect(depedScienceSources.keys.toSet(), depedScience.keys.toSet());
    for (final grade in ['g1', 'g2']) {
      final source = depedScienceSources[grade]!.join(' ');
      expect(source, contains('integrated'));
      expect(source, contains('NOT a standalone Science'));
      for (final topic in depedScience[grade]!) {
        expect(topic.subtitle, contains('Integrated exploratory'));
        expect(topic.subtitle, contains('not an official standalone'));
        expect(topic.subtitle, isNot(contains('Q1:')));
      }
    }
    for (final grade in ['g4', 'g7']) {
      expect(depedScienceSources[grade]!.join(' '), contains('MATATAG'));
      expect(depedScienceSources[grade]!.join(' '), contains('sci_cg.pdf'));
    }
    for (final grade in ['g3', 'g5', 'g6', 'g8', 'g9', 'g10']) {
      expect(depedScienceSources[grade]!.join(' '), contains('LEGACY 2016'));
      for (final topic in depedScience[grade]!) {
        expect(topic.subtitle, startsWith('Legacy 2016 reference'));
      }
    }
    for (final source in depedScienceSources.values.expand((urls) => urls)) {
      expect(source, startsWith('https://www.deped.gov.ph/'));
      expect(source, contains('|'));
      expect(source.toLowerCase(), contains('grade'));
    }
  });

  test(
      'structural publication scanner reports no errors or readability warnings',
      () {
    final report = CurriculumQualityScanner().scan(
      topics: topics,
      authoredTopicIds: topics.map((topic) => topic.id).toSet(),
      visualIds: depedScienceVisuals.keys.toSet(),
    );
    expect(report.errors.map((error) => error.toJson()).toList(), isEmpty);
    expect(
        report.warnings.map((warning) => warning.toJson()).toList(), isEmpty);
  });

  test('scientific misconception checks retain their intended answers', () {
    String answer(String grade, String promptFragment) {
      final matches = depedScience[grade]!
          .expand<NorieQuestionContent>(
              (topic) => [...topic.quiz.questions, ...topic.challenge.rounds])
          .where((question) => question.prompt.contains(promptFragment));
      expect(matches, hasLength(1), reason: promptFragment);
      final question = matches.single;
      return question.options[question.correctIndex];
    }

    expect(answer('g3', 'A sealed cold bottle'), 'Condensation');
    expect(answer('g5', 'half-lit Moon is followed days later by a fuller'),
        'First quarter');
    expect(answer('g5', 'half-lit Moon is followed days later by a thinner'),
        'Last quarter');
    expect(answer('g7', 'A cart moves straight at constant velocity'),
        'Balanced forces');
    expect(answer('g8', 'pairs of identical oxygen atoms'), 'Element');
    expect(answer('g8', 'from 11 to 10 electrons'), 'Electrons and ions');
    expect(answer('g9', 'same momentum change, but one takes twice as long'),
        'Impulse');
    expect(answer('g10', '4 liters to 2 liters'), 'Boyle relationship');
    expect(answer('g10', '300 K to 600 K'), 'Charles relationship');
    expect(
        answer('g10', 'changes H2O into H2O2'), 'Balanced chemical equation');
  });
}
