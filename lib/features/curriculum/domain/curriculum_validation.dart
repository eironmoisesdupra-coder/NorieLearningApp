import 'curriculum_revision.dart';
import 'guided_assessment.dart';
import 'dart:convert';

class CurriculumIssue {
  const CurriculumIssue(this.code, this.location, this.message);
  final String code;
  final String location;
  final String message;
  @override
  String toString() => '$location: $message';
}

/// This gate verifies structure, never factual accuracy or human signoff.
abstract final class CurriculumValidator {
  static List<CurriculumIssue> validate(Iterable<CurriculumRevision> revisions,
      {Set<String> availableAssets = const {},
      Set<String> externalPrerequisites = const {}}) {
    final issues = <CurriculumIssue>[];
    void issue(String code, String location, String message) =>
        issues.add(CurriculumIssue(code, location, message));
    final byId = <String, CurriculumRevision>{};
    final questionOwners = <String, ({String owner, String content})>{};
    for (final revision in revisions) {
      if (byId.containsKey(revision.id)) {
        issue('duplicate_id', revision.id, 'Duplicate lesson ID.');
      }
      byId[revision.id] = revision;
      final topic = revision.topic;
      final metadata = revision.metadata;
      for (final key in [
        'objective',
        'reading_level',
        'author',
        'reviewer',
        'content_source',
        'content_license',
        'unit',
        'quiz_bank',
        'progress_compatibility',
        'locale',
        'editorial_review'
      ]) {
        if (metadata[key] is! String ||
            (metadata[key] as String).trim().isEmpty ||
            RegExp(r'^(todo|tbd|unknown|placeholder|n/a)$',
                    caseSensitive: false)
                .hasMatch((metadata[key] as String).trim())) {
          issue('metadata', '${revision.id}/$key',
              'Supply real $key metadata before review.');
        }
      }
      if (topic.gradeLevel == null ||
          topic.gradeLevel!.trim().isEmpty ||
          topic.subject.trim().isEmpty) {
        issue('grade_subject', revision.id, 'Subject and grade are required.');
      }
      final lesson = topic.lesson;
      if (topic.title.trim().isEmpty ||
          lesson.heading.trim().isEmpty ||
          lesson.introduction.trim().isEmpty ||
          lesson.keyConceptBody.trim().isEmpty ||
          lesson.sections.isEmpty) {
        issue('lesson_structure', revision.id,
            'Provide an introduction, explanation and recap.');
      }
      final flow = metadata['flow'];
      for (final stage in [
        'discover',
        'understand',
        'worked_example',
        'guided_try',
        'independent_try',
        'apply',
        'review'
      ]) {
        if (flow is! Map ||
            flow[stage] is! String ||
            (flow[stage] as String).trim().isEmpty) {
          issue('teaching_flow', '${revision.id}/$stage',
              'Author the $stage teaching stage.');
        }
      }
      for (var i = 0; i < lesson.sections.length; i++) {
        final section = lesson.sections[i];
        final prose = [section.body ?? '', ...section.points].join(' ').trim();
        if (prose.split(RegExp(r'\s+')).length < 8) {
          issue('thin_explanation', '${revision.id}/section/$i',
              'Explanation needs subject-specific teaching and examples.');
        }
        if (section.visualType != null &&
            (section.visualCaption ?? '').trim().isEmpty) {
          issue('visual_accessibility', '${revision.id}/section/$i',
              'Add an accessible visual caption.');
        }
      }
      final rawTopic = revision.topicJson;
      for (final bankName in ['quiz', 'challenge']) {
        final rawBank = rawTopic[bankName];
        final rawQuestions = rawBank is Map
            ? rawBank[bankName == 'quiz' ? 'questions' : 'rounds']
            : null;
        if (rawQuestions is List) {
          for (final rawQuestion in rawQuestions) {
            if (rawQuestion is! Map ||
                rawQuestion['correct_index'] is! int ||
                rawQuestion['id'] is! String ||
                rawQuestion['prompt'] is! String ||
                rawQuestion['options'] is! List ||
                rawQuestion['explanation'] is! String) {
              issue('answer_key', revision.id,
                  'Question keys and required fields must have explicit correct types.');
            }
          }
        }
      }
      for (final bank in {
        'quiz': topic.quiz.questions,
        'challenge': topic.challenge.rounds
      }.entries) {
        if (bank.value.isEmpty) {
          issue('empty_bank', '${revision.id}/${bank.key}',
              'Author lesson-specific practice and mastery items.');
        }
        final ids = <String>{};
        for (final question in bank.value) {
          final at = '${revision.id}/${bank.key}/${question.id}';
          final previous = questionOwners[question.id];
          final serialized = jsonEncode(question.toJson());
          if (previous != null &&
              (previous.owner != revision.id ||
                  previous.content != serialized)) {
            issue('duplicate_question', at,
                'Question ID refers to different content or another lesson.');
          }
          questionOwners[question.id] =
              (owner: revision.id, content: serialized);
          if (question.id.trim().isEmpty || !ids.add(question.id)) {
            issue('duplicate_question', at,
                'Question IDs must be unique within each bank.');
          }
          if (!question.hasValidAnswer || question.options.length < 2) {
            issue('answer_key', at,
                'Provide a valid answer index and alternatives.');
          }
          if (question.options.any((s) => s.trim().isEmpty) ||
              question.options.toSet().length != question.options.length) {
            issue('alternatives', at,
                'Alternatives must be distinct and nonempty.');
          }
          if (question.prompt.trim().isEmpty ||
              question.explanation.trim().split(RegExp(r'\s+')).length < 5) {
            issue('thin_explanation', at,
                'Provide a specific question and explanatory answer.');
          }
          if (question.acceptedAnswers.any((s) => s.trim().isEmpty) ||
              question.acceptedAnswers.toSet().length !=
                  question.acceptedAnswers.length) {
            issue('accepted_answers', at,
                'Accepted answers must be nonempty and distinct.');
          }
          if (question.orderedItems.isNotEmpty &&
              (question.orderedItems.length < 2 ||
                  question.orderedItems.toSet().length !=
                      question.orderedItems.length ||
                  question.orderedItems.any((s) => s.trim().isEmpty))) {
            issue('ordering', at,
                'Ordering needs at least two distinct nonempty authored steps.');
          }
        }
      }
      final assessments = metadata['assessments'];
      if (assessments is List) {
        for (final item in assessments) {
          if (item is! Map) {
            issue('assessment', revision.id, 'Invalid assessment metadata.');
            continue;
          }
          try {
            final authored =
                GuidedAssessmentItem.fromJson(Map<String, dynamic>.from(item));
            if (questionOwners.containsKey(authored.id)) {
              issue('duplicate_question', revision.id,
                  'Authored item IDs must be distinct from other banks.');
            }
            questionOwners[authored.id] =
                (owner: revision.id, content: jsonEncode(item));
          } catch (_) {
            issue('assessment', revision.id,
                'Invalid authored format or answer key.');
          }
          if (item['explanation'] is! String ||
              (item['explanation'] as String)
                      .trim()
                      .split(RegExp(r'\s+'))
                      .length <
                  5) {
            issue('thin_explanation', revision.id,
                'Authored assessment requires a specific explanation.');
          }
          if (item['format'] == 'numeric' &&
              (item['answer'] is! num ||
                  !(item['answer'] as num).isFinite ||
                  item['unit'] is! String ||
                  (item['unit'] as String).trim().isEmpty ||
                  item['tolerance'] is! num ||
                  !(item['tolerance'] as num).isFinite ||
                  (item['tolerance'] as num) < 0)) {
            issue('answer_unit', revision.id,
                'Numeric items need a finite answer, nonnegative tolerance and explicit unit.');
          }
        }
      }
      final assets = metadata['assets'];
      if (assets != null && assets is! List) {
        issue('asset_manifest', revision.id, 'Assets must be a list.');
      }
      if (assets is List) {
        for (final asset in assets) {
          if (asset is! Map) {
            issue('asset_manifest', revision.id, 'Invalid asset metadata.');
            continue;
          }
          final path = asset['path'];
          if (path is! String || !validAssetPath(path)) {
            issue('asset_path', revision.id,
                'Only relative packaged assets/ paths are allowed.');
          }
          if (asset['alt_text'] is! String ||
              (asset['alt_text'] as String).trim().isEmpty) {
            issue('asset_accessibility', revision.id,
                'An accessible asset description is required.');
          }
          if (asset['license'] is! String ||
              (asset['license'] as String).trim().isEmpty) {
            issue('asset_license', revision.id,
                'Supply the actual asset license.');
          }
          if (path is String && !availableAssets.contains(path)) {
            issue('missing_asset', revision.id,
                'Offline asset is unavailable: $path');
          }
        }
      }
    }
    final visiting = <String>{}, visited = <String>{};
    void visit(String id) {
      if (visited.contains(id)) return;
      if (!visiting.add(id)) {
        issue('prerequisite_cycle', id, 'Prerequisites contain a cycle.');
        return;
      }
      final prerequisite = byId[id]?.topic.prerequisiteTopicId;
      if (prerequisite != null) {
        if (byId.containsKey(prerequisite)) {
          visit(prerequisite);
        } else if (!externalPrerequisites.contains(prerequisite)) {
          issue('missing_prerequisite', id,
              'Prerequisite is unavailable: $prerequisite');
        }
      }
      visiting.remove(id);
      visited.add(id);
    }

    for (final id in byId.keys) {
      visit(id);
    }
    return List.unmodifiable(issues);
  }

  static bool validAssetPath(String path) =>
      path.startsWith('assets/') &&
      !path.contains('..') &&
      !path.contains('\\') &&
      !path.contains(':') &&
      !path.contains('%') &&
      !path.contains('//') &&
      path.trim() == path;
}
