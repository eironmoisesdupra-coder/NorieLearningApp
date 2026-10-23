import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hint_library.dart';
import 'anatomy_hint_library_test.dart' as fixtures;

void main() {
  late Directory folder;
  late File catalog;
  setUp(() {
    folder = Directory.systemTemp.createTempSync('norie-hint-authoring-');
    catalog = File('${folder.path}/catalog.json')
      ..writeAsStringSync(jsonEncode(fixtures.hintCatalogFixture()));
  });
  tearDown(() => folder.deleteSync(recursive: true));

  Future<ProcessResult> run(List<String> args) => Process.run(
      '${File(Platform.resolvedExecutable).parent.parent.parent.parent.path}/dart-sdk/bin/dart${Platform.isWindows ? '.exe' : ''}',
      ['run', 'tool/anatomy/hints.dart', ...args, '--catalog', catalog.path]);

  test(
      'templates import exact parts without inventing hints, sources or review',
      () async {
    final output = File('${folder.path}/drafts.json');
    final result = await run(['templates', '--output', output.path]);
    expect(result.exitCode, 0, reason: result.stderr.toString());
    final records = (jsonDecode(output.readAsStringSync())['records'] as List)
        .map((j) => AnatomyHintRecord.fromJson(j as Map<String, dynamic>))
        .toList();
    expect(records.map((r) => r.identity.structureId), ['left', 'right']);
    for (final record in records) {
      expect(record.status, AnatomyHintStatus.draft);
      expect(record.laterality, AnatomyHintLaterality.unknown);
      expect(record.contentHash, record.computedHash);
      expect(record.structuralHint, isEmpty);
      expect(record.sourceUrl, isEmpty);
      expect(record.reviewerId, isNull);
      expect(record.approvedAt, isNull);
    }
  });

  test('review report rejects self-approval and reports missing coverage',
      () async {
    final input = File('${folder.path}/records.json')
      ..writeAsStringSync(jsonEncode({
        'schemaVersion': 1,
        'records': [fixtures.hintRecordFixture()]
      }));
    final output = File('${folder.path}/report.json');
    final result =
        await run(['report', '--records', input.path, '--output', output.path]);
    expect(result.exitCode, 0, reason: result.stderr.toString());
    final report = jsonDecode(output.readAsStringSync());
    expect(report['eligibleRecords'], 0);
    expect(report['systems']['skeletal']['totalParts'], 2);
    expect(report['systems']['skeletal']['missing'], 1);
    expect(report['systems']['skeletal']['eligible'], 0);
    expect(report['awaitingReview'], hasLength(2));
    expect(report['records'][0]['issues'], contains('untrustedApproval'));
    final strict = await run([
      'validate',
      '--records',
      input.path,
      '--output',
      '${folder.path}/validation.json'
    ]);
    expect(strict.exitCode, 1);
  });

  test(
      'duplicate drafts and unresolved laterality remain explicit review blockers',
      () async {
    final json = fixtures.hintRecordFixture()..['status'] = 'draft';
    json['laterality'] = 'unknown';
    final input = File('${folder.path}/records.json')
      ..writeAsStringSync(jsonEncode({
        'schemaVersion': 1,
        'records': [json, json]
      }));
    final output = File('${folder.path}/report.json');
    final result =
        await run(['report', '--records', input.path, '--output', output.path]);
    expect(result.exitCode, 0);
    final report = jsonDecode(output.readAsStringSync());
    expect(report['duplicateStructureIds'], ['left']);
    expect(report['records'][0]['issues'],
        containsAll(['duplicateMapping', 'unresolvedLaterality']));
  });

  test(
      'unknown requested part and malformed inventory fail without partial export',
      () async {
    final output = File('${folder.path}/drafts.json');
    final missing = await run(
        ['templates', '--structures', 'unknown', '--output', output.path]);
    expect(missing.exitCode, 2);
    expect(output.existsSync(), isFalse);
    final badCatalog = fixtures.hintCatalogFixture();
    (badCatalog['structures'] as List)[0].remove('meshes');
    catalog.writeAsStringSync(jsonEncode(badCatalog));
    final invalid = await run(['templates', '--output', output.path]);
    expect(invalid.exitCode, 2);
    expect(output.existsSync(), isFalse);
  });

  test('existing outputs and unsupported approval options are rejected',
      () async {
    final output = File('${folder.path}/existing.json')
      ..writeAsStringSync('preserve this work');
    final existing = await run(['templates', '--output', output.path]);
    expect(existing.exitCode, 2);
    expect(output.readAsStringSync(), 'preserve this work');
    final approval = await run([
      'templates',
      '--approve',
      'true',
      '--output',
      '${folder.path}/new.json'
    ]);
    expect(approval.exitCode, 2);
    expect(File('${folder.path}/new.json').existsSync(), isFalse);
    final duplicate = await run([
      'templates',
      '--structures',
      'left,left',
      '--output',
      '${folder.path}/new.json'
    ]);
    expect(duplicate.exitCode, 2);
    final input = File('${folder.path}/broken.json')
      ..writeAsStringSync('{"schemaVersion":1,"records":[{}]}');
    final malformed = await run([
      'report',
      '--records',
      input.path,
      '--output',
      '${folder.path}/new.json'
    ]);
    expect(malformed.exitCode, 2);
    expect(File('${folder.path}/new.json').existsSync(), isFalse);
  });

  test('checked-in 30-part pilot is entirely draft with exact catalog mappings',
      () {
    final geometry = AnatomyHintGeometryIndex.fromCatalogJson(
        jsonDecode(File('assets/anatomy/atlas-catalog.json').readAsStringSync())
            as Map<String, dynamic>);
    final input =
        jsonDecode(File('tool/anatomy/pilot-drafts.json').readAsStringSync());
    final records = (input['records'] as List)
        .map((j) => AnatomyHintRecord.fromJson(j as Map<String, dynamic>))
        .toList();
    expect(records, hasLength(30));
    expect(records.map((r) => r.identity.structureId).toSet(), hasLength(30));
    for (final r in records) {
      expect(
          r.identity.matches(geometry.parts[r.identity.structureId]!.identity),
          isTrue);
      expect(r.system, 'skeletal');
      expect(r.status, AnatomyHintStatus.draft);
      expect(r.generalHint, isEmpty);
      expect(r.structuralHint, isEmpty);
      expect(r.detailedHint, isEmpty);
      expect(r.sourceUrl, isEmpty);
      expect(r.reviewerId, isNull);
      expect(r.approvalHash, isNull);
    }
  });
}
