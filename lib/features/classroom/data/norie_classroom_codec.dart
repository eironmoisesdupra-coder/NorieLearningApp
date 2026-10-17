import '../domain/norie_classroom_fingerprint.dart';
import 'dart:convert';
import '../domain/norie_classroom_models.dart';
import '../domain/norie_classroom_resolver.dart';

abstract final class NorieClassroomCodec {
  static const version = 1, maxBytes = 2 * 1024 * 1024;
  static String encodeAssignment(NorieClassroomAssignment a) =>
      _encode('norie-classroom-assignment', {
        'assignment': NorieClassroomResolver.withSignature(a).toJson(),
        'catalog_signature': catalogSignature(a)
      });
  static String encodeSubmission(NorieClassroomSubmission s) =>
      _encode('norie-classroom-submission', s.toJson());
  static NorieClassroomAssignment decodeAssignment(String text) {
    final payload = _decode(text, 'norie-classroom-assignment');
    final a = NorieClassroomAssignment.fromJson(payload['assignment']);
    if (payload['catalog_signature'] != catalogSignature(a)) {
      throw const FormatException(
          'Classroom content version differs. Update both apps and export a fresh assignment.');
    }
    return a;
  }

  static NorieClassroomSubmission decodeSubmission(String text) =>
      NorieClassroomSubmission.fromJson(
          _decode(text, 'norie-classroom-submission'));
  static String catalogSignature(NorieClassroomAssignment a) =>
      NorieClassroomResolver.signature(a);
  static String _encode(String format, Map<String, dynamic> payload) {
    final out = jsonEncode({
      'format': format,
      'version': version,
      'integrity': checksum(canonical(payload)),
      'payload': payload
    });
    if (utf8.encode(out).length > maxBytes) {
      throw const FormatException('Package too large.');
    }
    return out;
  }

  static Map<String, dynamic> _decode(String text, String format) {
    checkBoundedJson(text);
    final d = classroomMap(jsonDecode(text));
    if (d['format'] != format ||
        d['version'] != version ||
        d['integrity'] is! String) {
      throw const FormatException('Unsupported classroom package.');
    }
    final p = classroomMap(d['payload']);
    if (checksum(canonical(p)) != d['integrity']) {
      throw const FormatException('Package integrity check failed.');
    }
    return p;
  }

  /// Preflight before jsonDecode/canonical recursion, including hostile nesting.
  static void checkBoundedJson(String text, {int byteLimit = maxBytes}) {
    if (text.length > byteLimit || utf8.encode(text).length > byteLimit) {
      throw const FormatException('Package too large.');
    }
    var depth = 0;
    var quoted = false;
    var escaped = false;
    var stringStart = 0;
    final objects = <Set<String>?>[];
    for (var index = 0; index < text.length; index++) {
      final unit = text.codeUnitAt(index);
      if (quoted) {
        if (escaped) {
          escaped = false;
        } else if (unit == 92) {
          escaped = true;
        } else if (unit == 34) {
          quoted = false;
          var next = index + 1;
          while (next < text.length && text.codeUnitAt(next) <= 32) {
            next++;
          }
          if (next < text.length &&
              text.codeUnitAt(next) == 58 &&
              objects.isNotEmpty &&
              objects.last != null) {
            final key =
                jsonDecode(text.substring(stringStart, index + 1)) as String;
            if (!objects.last!.add(key)) {
              throw const FormatException('Duplicate classroom JSON field.');
            }
          }
        }
      } else if (unit == 34) {
        quoted = true;
        stringStart = index;
      } else if (unit == 123 || unit == 91) {
        objects.add(unit == 123 ? <String>{} : null);
        if (++depth > 20) {
          throw const FormatException(
              'Classroom package is too deeply nested.');
        }
      } else if (unit == 125 || unit == 93) {
        depth--;
        if (depth < 0) {
          throw const FormatException('Malformed classroom package.');
        }
        objects.removeLast();
      }
    }
  }

  static String canonical(Object? v) => classroomCanonical(v);
  static String checksum(String text) => classroomChecksum(text);
  static String csvReport(NorieClassroomAssignment a,
      Iterable<NorieClassroomSubmission> submissions) {
    String cell(Object value) {
      var s = value.toString();
      if (RegExp(r'^[=+\-@\t\r]').hasMatch(s)) s = "'$s";
      return '"${s.replaceAll('"', '""')}"';
    }

    final rows = <List<Object>>[
      [
        'Assignment',
        'Learner alias',
        'Attempt',
        'Correct (recomputed)',
        'Total',
        'Completed UTC',
        'Submission ID'
      ],
      for (final raw in submissions.where((s) => s.assignmentId == a.id))
        ...(() {
          final s = NorieClassroomResolver.score(a, raw);
          return [
            [
              a.title,
              s.learnerAlias,
              s.attemptNumber,
              s.correct,
              s.total,
              s.completedAt.toUtc().toIso8601String(),
              s.id
            ]
          ];
        })()
    ];
    return rows.map((row) => row.map(cell).join(',')).join('\r\n');
  }
}
