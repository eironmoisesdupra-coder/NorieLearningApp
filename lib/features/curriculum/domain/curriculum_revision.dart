import 'dart:convert';
import '../../content/domain/norie_content_models.dart';
import 'curriculum_fingerprint.dart';
export 'curriculum_fingerprint.dart' show curriculumFingerprint;

enum CurriculumStage {
  draft,
  review,
  approved,
  published,
  retired,
  existingBundled
}

class CurriculumReference {
  const CurriculumReference(this.id, this.revision, this.fingerprint);
  final String id;
  final int revision;
  final String fingerprint;
  Map<String, dynamic> toJson() =>
      {'id': id, 'revision': revision, 'fingerprint': fingerprint};
  factory CurriculumReference.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String ||
        json['revision'] is! int ||
        (json['revision'] as int) < 1 ||
        json['fingerprint'] is! String) {
      throw const FormatException('Invalid pinned curriculum reference.');
    }
    return CurriculumReference(json['id'] as String, json['revision'] as int,
        json['fingerprint'] as String);
  }
}

/// JSON is copied on both entry and exit. Consumers cannot mutate history.
class CurriculumRevision {
  CurriculumRevision._(Map<String, dynamic> topic,
      Map<String, dynamic> metadata, this.revision, this.stage)
      : _topic = jsonEncode(topic),
        _metadata = jsonEncode(metadata) {
    _checkRevisionBounds(topic, metadata);
    // Parse immediately so malformed imports fail before persistence.
    final parsed = this.topic;
    if (parsed.id.trim().isEmpty || revision < 1) {
      throw const FormatException(
          'A revision needs a topic ID and positive revision.');
    }
  }
  factory CurriculumRevision.existing(Map<String, dynamic> topic) =>
      CurriculumRevision._(topic, const {}, 1, CurriculumStage.existingBundled);
  factory CurriculumRevision.draft(Map<String, dynamic> topic,
          {Map<String, dynamic> metadata = const {}, int revision = 1}) =>
      CurriculumRevision._(topic, metadata, revision, CurriculumStage.draft);

  /// Import never grants trust, even if client JSON claims approval/publication.
  factory CurriculumRevision.fromJson(Map<String, dynamic> json) {
    if (json['revision'] is! int ||
        json['topic'] is! Map<String, dynamic> ||
        json['metadata'] is! Map<String, dynamic> ||
        json['fingerprint'] is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(json['fingerprint'] as String)) {
      throw const FormatException('Invalid curriculum revision.');
    }
    try {
      final revision = CurriculumRevision.draft(
          Map<String, dynamic>.from(json['topic'] as Map),
          metadata: Map<String, dynamic>.from(json['metadata'] as Map),
          revision: json['revision'] as int);
      if (json['fingerprint'] != revision.fingerprint) {
        throw const FormatException(
            'Revision fingerprint does not match its content.');
      }
      return revision;
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Malformed lesson content.');
    }
  }
  final String _topic;
  final String _metadata;
  final int revision;
  final CurriculumStage stage;
  Map<String, dynamic> get topicJson =>
      jsonDecode(_topic) as Map<String, dynamic>;
  Map<String, dynamic> get metadata =>
      jsonDecode(_metadata) as Map<String, dynamic>;
  NorieTopicContent get topic => NorieTopicContent.fromJson(topicJson);
  late final String id = topicJson['id'] as String;
  late final String fingerprint =
      curriculumFingerprint({'topic': topicJson, 'metadata': metadata});
  CurriculumReference get reference =>
      CurriculumReference(id, revision, fingerprint);
  bool get isVettedForPath => stage == CurriculumStage.existingBundled;
  CurriculumRevision asDraft({int? revision}) =>
      CurriculumRevision.draft(topicJson,
          metadata: metadata, revision: revision ?? this.revision);
  Map<String, dynamic> toJson() => {
        'revision': revision,
        'stage': stage.name,
        'topic': topicJson,
        'metadata': metadata,
        'fingerprint': fingerprint
      };
}

/// UI and parser budgets apply before constructing question/section objects.
/// These are limits for a single revision, independent of pack byte limits.
void _checkRevisionBounds(
    Map<String, dynamic> topic, Map<String, dynamic> metadata) {
  if (utf8.encode(jsonEncode({'topic': topic, 'metadata': metadata})).length >
      1024 * 1024) {
    throw const FormatException('A lesson revision must fit within 1 MiB.');
  }
  void visit(Object? value, int depth) {
    if (depth > 24) {
      throw const FormatException('Lesson content is nested too deeply.');
    }
    if (value is String && value.length > 32768) {
      throw const FormatException(
          'A lesson text field exceeds 32768 characters.');
    }
    if (value is Map) {
      if (value.length > 128) {
        throw const FormatException('A lesson object has too many fields.');
      }
      for (final entry in value.entries) {
        visit(entry.key, depth + 1);
        visit(entry.value, depth + 1);
      }
    }
    if (value is List) {
      if (value.length > 512) {
        throw const FormatException('A lesson collection exceeds 512 entries.');
      }
      for (final item in value) {
        visit(item, depth + 1);
      }
    }
  }

  visit(topic, 0);
  visit(metadata, 0);
  void limit(Object? list, int maximum, String name) {
    if (list is List && list.length > maximum) {
      throw FormatException('$name exceeds its $maximum item limit.');
    }
  }

  final lesson = topic['lesson'];
  if (lesson is Map) {
    limit(lesson['sections'], 64, 'Lesson sections');
    final sections = lesson['sections'];
    if (sections is List) {
      for (final section in sections) {
        if (section is Map) limit(section['points'], 32, 'Section points');
      }
    }
  }
  for (final name in ['quiz', 'challenge']) {
    final bank = topic[name];
    if (bank is Map) {
      final questions = bank[name == 'quiz' ? 'questions' : 'rounds'];
      limit(questions, 128, 'Assessment bank');
      if (questions is List) {
        for (final question in questions) {
          if (question is Map) {
            limit(question['options'], 16, 'Question alternatives');
            limit(question['accepted_answers'], 32, 'Accepted answers');
            limit(question['ordered_items'], 32, 'Ordered steps');
          }
        }
      }
    }
  }
  limit(metadata['assets'], 128, 'Offline assets');
  limit(metadata['assessments'], 64, 'Authored assessments');
  final assessments = metadata['assessments'];
  if (assessments is List) {
    for (final assessment in assessments) {
      if (assessment is Map) {
        limit(assessment['options'], 16, 'Selection alternatives');
        limit(assessment['answers'], 16, 'Selection keys');
        limit(assessment['items'], 32, 'Ordered steps');
        limit(assessment['accepted'], 32, 'Accepted answers');
      }
    }
  }
}
