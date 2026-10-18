import 'dart:convert';
import '../domain/curriculum_revision.dart';
import '../domain/curriculum_validation.dart';

class StagedCurriculumPack {
  StagedCurriculumPack(
      {required this.title,
      required this.locale,
      required this.fingerprint,
      required List<CurriculumRevision> revisions,
      required List<CurriculumIssue> issues})
      : revisions = List.unmodifiable(revisions),
        issues = List.unmodifiable(issues);
  final String title;
  final String locale;
  final String fingerprint;
  final List<CurriculumRevision> revisions;
  final List<CurriculumIssue> issues;
  bool get isInstalled => false;
}

/// A checksum is integrity evidence only. This codec never installs curriculum.
abstract final class CurriculumPackCodec {
  static const maxBytes = 2 * 1024 * 1024;
  static const maxRevisions = 128;
  static const format = 'norie-curriculum-pack';
  static String encode(List<CurriculumRevision> revisions,
      {required String title, String locale = 'en'}) {
    if (revisions.isEmpty ||
        revisions.length > maxRevisions ||
        title.trim().isEmpty ||
        title.length > 200 ||
        !RegExp(r'^[a-z]{2,3}(-[A-Za-z0-9]{2,8})*$').hasMatch(locale)) {
      throw const FormatException(
          'A pack needs 1?128 revisions, a title and locale.');
    }
    final body = <String, dynamic>{
      'format': format,
      'version': 1,
      'title': title.trim(),
      'locale': locale,
      'revisions': revisions.map((r) => r.asDraft().toJson()).toList()
    };
    final result =
        jsonEncode({...body, 'fingerprint': curriculumFingerprint(body)});
    if (utf8.encode(result).length > maxBytes) {
      throw const FormatException(
          'Content pack exceeds the 2 MiB size budget.');
    }
    return result;
  }

  static StagedCurriculumPack decode(String source,
      {Set<String> availableAssets = const {},
      Set<String> externalPrerequisites = const {}}) {
    if (source.length > maxBytes || utf8.encode(source).length > maxBytes) {
      throw const FormatException(
          'Content pack exceeds the 2 MiB size budget.');
    }
    // Reject deeply nested input before invoking the JSON parser.
    var depth = 0;
    var quoted = false;
    var escaped = false;
    for (final rune in source.runes) {
      if (quoted) {
        if (escaped) {
          escaped = false;
        } else if (rune == 92) {
          escaped = true;
        } else if (rune == 34) {
          quoted = false;
        }
      } else if (rune == 34) {
        quoted = true;
      } else if (rune == 91 || rune == 123) {
        if (++depth > 32) {
          throw const FormatException('Content pack is nested too deeply.');
        }
      } else if (rune == 93 || rune == 125) {
        depth--;
      }
    }
    try {
      final doc = jsonDecode(source);
      if (doc is! Map<String, dynamic> ||
          doc['format'] != format ||
          doc['version'] != 1 ||
          doc['title'] is! String ||
          (doc['title'] as String).trim().isEmpty ||
          (doc['title'] as String).length > 200 ||
          doc['locale'] is! String ||
          !RegExp(r'^[a-z]{2,3}(-[A-Za-z0-9]{2,8})*$')
              .hasMatch(doc['locale'] as String)) {
        throw const FormatException('Unsupported content pack manifest.');
      }
      final body = Map<String, dynamic>.from(doc)..remove('fingerprint');
      if (doc['fingerprint'] != curriculumFingerprint(body)) {
        throw const FormatException(
            'Pack fingerprint mismatch. Content was changed.');
      }
      final raw = doc['revisions'];
      if (raw is! List || raw.isEmpty || raw.length > maxRevisions) {
        throw const FormatException('A pack must contain 1?128 revisions.');
      }
      final revisions = [
        for (final item in raw)
          CurriculumRevision.fromJson(Map<String, dynamic>.from(item as Map))
      ];
      final issues = CurriculumValidator.validate(revisions,
          availableAssets: availableAssets,
          externalPrerequisites: externalPrerequisites);
      const unsafe = {
        'duplicate_id',
        'duplicate_question',
        'prerequisite_cycle',
        'missing_prerequisite',
        'answer_key',
        'alternatives',
        'accepted_answers',
        'ordering',
        'answer_unit',
        'assessment',
        'asset_manifest',
        'asset_path',
        'missing_asset',
        'asset_accessibility',
        'asset_license'
      };
      final blocking = issues.where((i) => unsafe.contains(i.code)).toList();
      if (blocking.isNotEmpty) {
        throw FormatException(
            blocking.take(8).map((i) => i.toString()).join('\n'));
      }
      return StagedCurriculumPack(
          title: doc['title'] as String,
          locale: doc['locale'] as String,
          fingerprint: doc['fingerprint'] as String,
          revisions: revisions,
          issues: issues);
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException(
          'Malformed curriculum pack. No drafts were changed.');
    }
  }
}
