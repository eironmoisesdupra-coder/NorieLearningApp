import 'dart:convert';
import '../domain/norie_content_models.dart';

class CurriculumQualityIssue {
  const CurriculumQualityIssue(this.code, this.location, this.message);
  final String code;
  final String location;
  final String message;
  Map<String, Object> toJson() =>
      {'code': code, 'location': location, 'message': message};
}

class CurriculumQualityReport {
  CurriculumQualityReport(this.topicCount, this.errors, this.warnings);
  final int topicCount;
  final List<CurriculumQualityIssue> errors;
  final List<CurriculumQualityIssue> warnings;
  Map<String, Object> toJson() => {
        'schema_version': 1,
        'topic_count': topicCount,
        'error_count': errors.length,
        'warning_count': warnings.length,
        'errors': errors.map((e) => e.toJson()).toList(),
        'warnings': warnings.map((e) => e.toJson()).toList()
      };
}

class CurriculumPublication {
  const CurriculumPublication(this.topicId, this.subject, this.grade);
  final String topicId;
  final String subject;
  final String grade;
}

/// Deterministic structural checks with injectable publication/visual registries.
///
/// Length and sentence heuristics are editorial warnings, not claims about
/// subject correctness. This scanner deliberately does not infer arithmetic
/// from prose, so notation, quoted examples and distractors stay meaningful.
/// Option case is preserved: English letter lessons may distinguish A from a.
class CurriculumQualityScanner {
  CurriculumQualityReport scan(
      {required List<NorieTopicContent> topics,
      required Set<String> authoredTopicIds,
      required Set<String> visualIds,
      Map<String, List<String>> visualAssets = const {},
      List<CurriculumPublication> publications = const [],
      bool Function(String)? assetExists}) {
    final errors = <CurriculumQualityIssue>[];
    final warnings = <CurriculumQualityIssue>[];
    void error(String code, String at, String message) =>
        errors.add(CurriculumQualityIssue(code, at, message));
    void warning(String code, String at, String message) =>
        warnings.add(CurriculumQualityIssue(code, at, message));
    final byId = <String, NorieTopicContent>{};
    final questions = <String, ({int topicIndex, String bank, String data})>{};
    for (var ti = 0; ti < topics.length; ti++) {
      final topic = topics[ti];
      final at = 'topics[$ti]/${topic.id}';
      if (topic.id.trim().isEmpty) {
        error('empty_topic_id', at, 'Topic ID must not be empty.');
      }
      if (byId.containsKey(topic.id)) {
        error('duplicate_topic_id', at, 'Topic ID is already published.');
      }
      byId[topic.id] = topic;
      if (!authoredTopicIds.contains(topic.id)) {
        error('unauthored_topic', at,
            'Published topic is absent from authored registry.');
      }
      if (topic.title.trim().isEmpty ||
          topic.lesson.heading.trim().isEmpty ||
          topic.lesson.sections.isEmpty) {
        error('incomplete_lesson', at,
            'A lesson needs a title, heading and sections.');
      }
      final prose = [
        topic.lesson.introduction,
        topic.lesson.keyConceptBody,
        for (final s in topic.lesson.sections) ...[s.body ?? '', ...s.points]
      ].join(' ');
      final words = prose.trim().split(RegExp(r'\s+'));
      if (words.length < 80) {
        warning('short_lesson', at,
            'Fewer than 80 words: review teaching depth; this is an editorial signal.');
      }
      if (const {'g1', 'g2', 'g3'}.contains(topic.gradeLevel)) {
        final sentences = prose
            .split(RegExp(r'[.!?]+'))
            .where((s) => s.trim().isNotEmpty)
            .length;
        if (sentences > 0 && words.length / sentences > 22) {
          warning('primary_sentence_length', at,
              'Average sentence exceeds 22 words: review early-grade readability.');
        }
      }
      void checkVisual(String? id, String location) {
        if (id == null) return;
        if (!visualIds.contains(id)) {
          error('unknown_visual', location,
              'No registered renderer or figure for $id.');
        }
        for (final path in visualAssets[id] ?? const <String>[]) {
          if (assetExists == null) {
            error('asset_check_unavailable', location,
                'Cannot verify explicit asset $path.');
          } else if (!assetExists(path)) {
            error('missing_asset', location,
                'Explicit asset does not exist: $path.');
          }
        }
      }

      checkVisual(topic.visualType, '$at/visual');
      for (var i = 0; i < topic.lesson.sections.length; i++) {
        checkVisual(
            topic.lesson.sections[i].visualType, '$at/sections[$i]/visual');
      }
      for (final bank in {
        'quiz': topic.quiz.questions,
        'challenge': topic.challenge.rounds
      }.entries) {
        if (bank.value.isEmpty) {
          error('empty_assessment', '$at/${bank.key}',
              'Published assessment must contain questions.');
        }
        final content = <String>{};
        for (var qi = 0; qi < bank.value.length; qi++) {
          final q = bank.value[qi];
          final location = '$at/${bank.key}[$qi]/${q.id}';
          if (q.id.trim().isEmpty) {
            error('empty_question_id', location,
                'Question ID must not be empty.');
          }
          final data = jsonEncode(q.toJson());
          final previous = questions[q.id];
          // Grade 1 math intentionally reuses its final quiz questions in mastery.
          // Permit only one byte-identical same-topic quiz/challenge pair.
          final reuse = previous != null &&
              previous.topicIndex == ti &&
              previous.bank == 'quiz' &&
              bank.key == 'challenge' &&
              previous.data == data;
          if (previous != null && !reuse) {
            error('duplicate_question_id', location,
                'Question ID is already used outside an identical quiz/challenge pair.');
          }
          questions[q.id] = (topicIndex: ti, bank: bank.key, data: data);
          if (q.prompt.trim().isEmpty) {
            error(
                'empty_prompt', location, 'Question prompt must not be empty.');
          }
          if (q.explanation.trim().isEmpty) {
            error('empty_explanation', location,
                'Answer explanation must not be empty.');
          }
          if (!q.hasValidAnswer) {
            error('invalid_answer_index', location,
                'Correct index must select an existing option.');
          }
          if (q.options.length < 2) {
            error('insufficient_options', location,
                'Multiple choice needs at least two options.');
          }
          final options = q.options.map(_normalize).toList();
          if (options.any((o) => o.isEmpty)) {
            error('empty_option', location, 'Options must not be blank.');
          }
          if (options.toSet().length != options.length) {
            error('duplicate_option', location,
                'Options must be distinct after whitespace normalization.');
          }
          final fingerprint =
              jsonEncode([_normalize(q.prompt), options.toList()..sort()]);
          if (!content.add(fingerprint)) {
            error('duplicate_question_content', location,
                'Same prompt and options occur twice in this assessment.');
          }
        }
      }
    }
    for (final publication in publications) {
      final topic = byId[publication.topicId];
      if (topic == null) {
        error('publication_missing_topic', publication.topicId,
            'Publication references an absent topic.');
      } else if (topic.subject != publication.subject ||
          topic.gradeLevel != publication.grade) {
        error('publication_mismatch', publication.topicId,
            'Topic subject/grade differ from publication path ${publication.subject}/${publication.grade}.');
      }
    }
    final finished = <String>{};
    for (final topic in topics) {
      final prerequisite = topic.prerequisiteTopicId;
      if (prerequisite != null && !byId.containsKey(prerequisite)) {
        error('missing_prerequisite', topic.id,
            'Prerequisite $prerequisite is not published.');
      }
      final path = <String>{};
      String? current = topic.id;
      while (current != null &&
          byId.containsKey(current) &&
          !finished.contains(current)) {
        if (!path.add(current)) {
          error('prerequisite_cycle', current,
              'Prerequisite cycle: ${path.join(' -> ')} -> $current.');
          break;
        }
        current = byId[current]!.prerequisiteTopicId;
      }
      finished.addAll(path);
    }
    return CurriculumQualityReport(
        topics.length, List.unmodifiable(errors), List.unmodifiable(warnings));
  }
}

String _normalize(String value) => value.trim().replaceAll(RegExp(r'\s+'), ' ');
