import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:norie_learning/features/content/data/standards/deped_english.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/quality/curriculum_quality.dart';

void main() {
  test('ten school grades have six to eight ordered lessons and four quarters',
      () {
    expect(depedEnglish.keys.toSet(),
        {for (var grade = 1; grade <= 10; grade++) 'g$grade'});
    final ids = <String>{};
    for (final entry in depedEnglish.entries) {
      expect(entry.value.length, inInclusiveRange(6, 8));
      final quarters = <String>{};
      for (var index = 0; index < entry.value.length; index++) {
        final topic = entry.value[index];
        expect(ids.add(topic.id), isTrue);
        expect(topic.subject, 'English');
        expect(topic.gradeLevel, entry.key);
        expect(topic.order, index + 1);
        expect(topic.prerequisiteTopicId,
            index == 0 ? null : entry.value[index - 1].id);
        quarters.add(topic.subtitle.substring(0, 2));
      }
      expect(quarters, {'Q1', 'Q2', 'Q3', 'Q4'});
    }
    expect(ids, hasLength(64));
  });

  test('every lesson has explicit teaching, guided solution and passage model',
      () {
    for (final topic in depedEnglish.values.expand((grade) => grade)) {
      final sections = {
        for (final section in topic.lesson.sections) section.title: section,
      };
      expect(sections['Learning objectives']!.points.length,
          inInclusiveRange(3, 5));
      for (final title in [
        'Read or listen',
        'Learn the language',
        'Worked reasoning',
        'Guided task — try first',
        'Guided solution',
        'Common mistakes',
        'Labeled passage model',
        'Recap',
      ]) {
        expect(sections[title]?.body?.trim(), isNotEmpty,
            reason: '${topic.id}: $title');
      }
      final visual = depedEnglishVisuals[topic.visualType]!;
      expect(visual.validate, returnsNormally);
      expect(visual.labels, hasLength(3));
      expect(sections['Labeled passage model']!.visualType, topic.visualType);
      for (final detail in visual.details) {
        expect(sections['Labeled passage model']!.body, contains(detail));
      }
    }
    expect(depedEnglishVisuals, hasLength(64));
  });

  test('704 independent checks carry their own passage and valid answers', () {
    final questionIds = <String>{};
    final prompts = <String>{};
    for (final topic in depedEnglish.values.expand((grade) => grade)) {
      expect(topic.quiz.questions, hasLength(8));
      expect(topic.challenge.rounds, hasLength(3));
      final passage = topic.lesson.sections
          .singleWhere((section) => section.title == 'Read or listen')
          .body!;
      for (final question in [
        ...topic.quiz.questions,
        ...topic.challenge.rounds,
      ]) {
        expect(questionIds.add(question.id), isTrue);
        expect(prompts.add(question.prompt), isTrue);
        expect(question.prompt, startsWith('Read or listen:\n$passage\n\n'));
        expect(question.options, hasLength(4));
        expect(question.options.map((s) => s.trim().toLowerCase()).toSet(),
            hasLength(4));
        expect(question.hasValidAnswer, isTrue);
        expect(question.explanation.trim(), isNotEmpty);
      }
      // Persistence uses the normal content model and does not lose passages.
      final restored = NorieTopicContent.fromJson(
          jsonDecode(jsonEncode(topic.toJson())) as Map<String, dynamic>);
      expect(restored.toJson(), topic.toJson());
    }
    expect(questionIds, hasLength(704));
  });

  test('quality scanner reports no errors or readability/depth warnings', () {
    final topics = depedEnglish.values.expand((grade) => grade).toList();
    final report = CurriculumQualityScanner().scan(
      topics: topics,
      authoredTopicIds: topics.map((topic) => topic.id).toSet(),
      visualIds: depedEnglishVisuals.keys.toSet(),
    );
    expect(report.errors.map((e) => e.toJson()).toList(), isEmpty);
    expect(report.warnings.map((e) => e.toJson()).toList(), isEmpty);
  });

  test('offline source notes distinguish MATATAG, legacy and language limits',
      () {
    expect(depedEnglishSources.keys.toSet(), depedEnglish.keys.toSet());
    expect(depedEnglishCoverageNotes.keys.toSet(), depedEnglish.keys.toSet());
    for (final entry in depedEnglishSources.entries) {
      expect(entry.value, isNotEmpty);
      for (final source in entry.value) {
        expect(source, contains('https://www.deped.gov.ph/'));
        expect(source, contains('Grade ${entry.key.substring(1)}'));
        expect(source, contains('Q'));
        expect(source, contains('PDF pp.'));
      }
    }
    for (final grade in ['g2', 'g3', 'g5', 'g6', 'g8', 'g9', 'g10']) {
      expect(depedEnglishSources[grade]!.every((s) => s.contains('LEGACY')),
          isTrue);
      expect(depedEnglishCoverageNotes[grade],
          anyOf(contains('unverified'), contains('not a verified current')),
          reason: '$grade must not imply a verified current table');
    }
    expect(depedEnglishCoverageNotes['g1'], contains('not a complete'));
    expect(
        depedEnglishSources['g1']!.join(), contains('NOT standalone English'));
    expect(depedEnglishSources['g7']!.join(), contains('MATATAG'));
  });
}
