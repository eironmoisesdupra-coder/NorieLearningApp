import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_codec.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_models.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_resolver.dart';
import 'norie_classroom_store_test.dart' show assignment, submission;

void main() {
  test('portable FNV-1a known vectors', () {
    expect(NorieClassroomCodec.checksum(''), '811c9dc5');
    expect(NorieClassroomCodec.checksum('a'), 'e40c292c');
    expect(NorieClassroomCodec.checksum('foobar'), 'bf9cf968');
  });
  test('duplicate JSON fields including escaped equivalents are rejected', () {
    expect(
        () => NorieClassroomCodec.checkBoundedJson(
            r'{"responses":{"q":1,"\u0071":2}}'),
        throwsFormatException);
  });
  test('authored assignment and submission round trips with content signature',
      () {
    final a = assignment();
    final decoded = NorieClassroomCodec.decodeAssignment(
        NorieClassroomCodec.encodeAssignment(a));
    expect(decoded.id, a.id);
    expect(decoded.catalogSignature, NorieClassroomResolver.signature(a));
    expect(
        NorieClassroomCodec.decodeSubmission(
                NorieClassroomCodec.encodeSubmission(submission()))
            .responses,
        submission().responses);
  });
  test('edited package payload fails integrity', () {
    final text = NorieClassroomCodec.encodeAssignment(assignment())
        .replaceFirst('Living things', 'Changed');
    expect(() => NorieClassroomCodec.decodeAssignment(text),
        throwsFormatException);
  });
  test('malformed version oversized and excessive nesting rejected', () {
    for (final text in [
      'null',
      '[]',
      '{',
      '{"version":2}',
      ' ' * (NorieClassroomCodec.maxBytes + 1),
        '${'[' * 21}0${']' * 21}'
    ]) {
      expect(() => NorieClassroomCodec.decodeAssignment(text),
          throwsFormatException);
    }
  });
  test('well checksummed package still rejects changed curriculum fingerprint',
      () {
    final d = jsonDecode(NorieClassroomCodec.encodeAssignment(assignment()))
        as Map<String, dynamic>;
    final p = d['payload'] as Map<String, dynamic>;
    p['catalog_signature'] = 'outdated';
    d['integrity'] =
        NorieClassroomCodec.checksum(NorieClassroomCodec.canonical(p));
    expect(() => NorieClassroomCodec.decodeAssignment(jsonEncode(d)),
        throwsFormatException);
  });
  test(
      'strict fields reject duplicates long titles invalid response and invalid IDs',
      () {
    final a = assignment();
    for (final change in [
      {
        'question_ids': [...a.questionIds, ...a.questionIds]
      },
      {'topic_ids': List.filled(41, a.topicIds.first)},
      {'title': 'x' * 161},
      {'max_attempts': 0}
    ]) {
      expect(
          () => NorieClassroomAssignment.fromJson({...a.toJson(), ...change}),
          throwsFormatException);
    }
    expect(
        () => NorieClassroomResolver.questionsFor(
                NorieClassroomAssignment.fromJson({
              ...a.toJson(),
              'question_ids': ['missing']
            })),
        throwsFormatException);
    expect(
        () => NorieClassroomSubmission.fromJson({
              ...submission().toJson(),
              'responses': {'q': -1}
            }),
        throwsFormatException);
  });
  test('CSV quotes aliases and prevents spreadsheet formulas', () {
    final raw = submission();
    final s = NorieClassroomSubmission.fromJson(
        {...raw.toJson(), 'learner_alias': '=SUM(1,2)'});
    final csv = NorieClassroomCodec.csvReport(assignment(), [s]);
    expect(csv, contains('"\'=SUM(1,2)"'));
    expect(csv, contains('"1","1"'));
  });
}
