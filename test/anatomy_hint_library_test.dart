import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_fingerprint.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hint_library.dart';

// Synthetic editorial fixtures only. These are not shipped anatomical claims.
Map<String, dynamic> hintCatalogFixture() => {
      'schemaVersion': 1,
      'references': [
        {'id': 'test-reference'}
      ],
      'assets': [
        {'id': 'bones', 'file': 'bones.glb', 'sha256': 'a' * 64}
      ],
      'structures': [
        for (final side in ['Left', 'Right'])
          {
            'id': side.toLowerCase(),
            'name': '$side test bone',
            'reference': 'test-reference',
            'asset': 'bones',
            'meshes': ['mesh-${side.toLowerCase()}'],
            'systems': ['skeletal'],
          }
      ],
    };

Map<String, dynamic> hintRecordFixture() {
  final content = <String, dynamic>{
    'schemaVersion': 1,
    'revision': 1,
    'identity': {
      'structureId': 'left',
      'reference': 'test-reference',
      'assetId': 'bones',
      'assetSha256': 'a' * 64,
      'meshIds': ['mesh-left'],
    },
    'canonicalName': 'Left test bone',
    'synonyms': ['Fixture alias'],
    'system': 'skeletal',
    'laterality': 'left',
    'generalHint': 'Examine the overall proportions.',
    'structuralHint': 'Compare the visible surfaces with the answer options.',
    'detailedHint': 'Rotate the model and compare its ends.',
    'source': {
      'url': 'https://example.org/test-fixture',
      'location': 'Synthetic test fixture, not an educational source',
    },
  };
  return {
    ...content,
    'contentHash': curriculumFingerprint(content),
    'status': 'approved',
    'reviewerId': 'test-only-reviewer',
    'approvedAt': '2026-10-01T00:00:00.000Z',
    'approvalHash': curriculumFingerprint(content),
  };
}

AnatomyHintRequest hintRequestFixture({
  String structureId = 'left',
  String selectedPartId = 'left',
  String questionStructureId = 'left',
  String meshId = 'mesh-left',
  String assetId = 'bones',
  String? checksum,
  String reference = 'test-reference',
  String answer = 'Left test bone',
  AnatomyHintLaterality laterality = AnatomyHintLaterality.left,
}) =>
    AnatomyHintRequest(
      displayed: AnatomyHintIdentity(
          structureId: structureId,
          reference: reference,
          assetId: assetId,
          assetSha256: checksum ?? 'a' * 64,
          meshIds: [meshId]),
      selectedPartId: selectedPartId,
      questionStructureId: questionStructureId,
      correctAnswer: answer,
      laterality: laterality,
    );

AnatomyHintApproval hintApprovalFixture(AnatomyHintRecord record,
        {Set<AnatomyHintHumanCheck>? checks}) =>
    AnatomyHintApproval(
      contentHash: record.contentHash,
      reviewerId: 'test-only-reviewer',
      approvedAt: DateTime.utc(2026, 10),
      checks: checks ?? AnatomyHintHumanCheck.values.toSet(),
    );

AnatomyHintLibrary hintLibraryFixture(
    {List<AnatomyHintRecord>? records,
    List<AnatomyHintApproval>? approvals,
    Map<String, dynamic>? catalog}) {
  final record = AnatomyHintRecord.fromJson(hintRecordFixture());
  return AnatomyHintLibrary(
      geometry: AnatomyHintGeometryIndex.fromCatalogJson(
          catalog ?? hintCatalogFixture()),
      records: records ?? [record],
      approvals: approvals ?? [hintApprovalFixture(record)]);
}

void main() {
  test('current generated catalog retains distinct exact selectable identities',
      () {
    final catalog =
        jsonDecode(File('assets/anatomy/atlas-catalog.json').readAsStringSync())
            as Map<String, dynamic>;
    final geometry = AnatomyHintGeometryIndex.fromCatalogJson(catalog);
    final left = geometry.parts['bp-FJ3259']!;
    final right = geometry.parts['bp-FJ3365']!;
    expect(left.identity.meshIds, ['FJ3259']);
    expect(right.identity.meshIds, ['FJ3365']);
    expect(left.identity.matches(right.identity), isFalse);
    expect(left.identity.assetId, 'male-skeletal');
    expect(left.canonicalName, 'Left femur');
    // This is metadata/geometry identity evidence, not an anatomical approval.
    expect(
        AnatomyHintLibrary(geometry: geometry, records: []).records, isEmpty);
  });

  test('exact reviewed mapping returns a usable free structural clue', () {
    final result = hintLibraryFixture().lookup(hintRequestFixture());
    expect(result.status, AnatomyHintAvailability.available);
    expect(result.record?.structuralHint,
        'Compare the visible surfaces with the answer options.');
    expect(result.issues, isEmpty);
  });

  test('self-declared approval never authorizes content', () {
    final library = hintLibraryFixture(approvals: []);
    final result = library.lookup(hintRequestFixture());
    expect(result.status, AnatomyHintAvailability.unavailable);
    expect(result.record, isNull);
    expect(result.issues, contains('untrustedApproval'));
    expect(library.validate(library.records.single).humanReviewRequired,
        contains(AnatomyHintHumanCheck.sourceSupport));
  });

  for (final entry in <String, AnatomyHintRequest>{
    'selected part': hintRequestFixture(selectedPartId: 'right'),
    'question target': hintRequestFixture(questionStructureId: 'right'),
    'displayed structure': hintRequestFixture(structureId: 'right'),
    'mesh': hintRequestFixture(meshId: 'mesh-right'),
    'model asset': hintRequestFixture(assetId: 'other'),
    'model revision': hintRequestFixture(checksum: 'b' * 64),
    'reference scene': hintRequestFixture(reference: 'other'),
    'correct answer': hintRequestFixture(answer: 'Right test bone'),
    'laterality': hintRequestFixture(laterality: AnatomyHintLaterality.right),
  }.entries) {
    test('${entry.key} mismatch makes the clue unavailable', () {
      final result = hintLibraryFixture().lookup(entry.value);
      expect(result.status, AnatomyHintAvailability.unavailable);
      expect(result.record, isNull);
    });
  }

  for (final status in ['draft', 'pendingReview', 'rejected', 'retired']) {
    test('$status cannot become active despite old approval', () {
      final record = AnatomyHintRecord.fromJson(
          {...hintRecordFixture(), 'status': status});
      expect(
          hintLibraryFixture(records: [record])
              .lookup(hintRequestFixture())
              .record,
          isNull);
    });
  }

  test('a missing record returns safe general guidance without content', () {
    final result = hintLibraryFixture(records: []).lookup(hintRequestFixture());
    expect(result.status, AnatomyHintAvailability.unavailable);
    expect(result.issues, contains('missingRecord'));
    expect(result.generalGuidance, contains('proportions'));
    expect(result.record, isNull);
  });

  for (final change in <String, Object?>{
    'canonicalName': 'Another structure',
    'synonyms': ['Changed alias'],
    'system': 'muscular',
    'laterality': 'right',
    'generalHint': 'Edited guidance.',
    'structuralHint': 'Edited clue.',
    'detailedHint': 'Edited detail.',
    'revision': 2,
    'source': {
      'url': 'https://example.org/edited',
      'location': 'Edited section'
    },
  }.entries) {
    test('editing ${change.key} invalidates exact revision approval', () {
      final record = AnatomyHintRecord.fromJson(
          {...hintRecordFixture(), change.key: change.value});
      final report = hintLibraryFixture().validate(record);
      expect(report.issues, contains('contentHashMismatch'));
      expect(report.eligible, isFalse);
    });
  }

  test('rehashed edits still require independent new approval', () {
    final json = hintRecordFixture()..['structuralHint'] = 'Edited clue.';
    final edited = AnatomyHintRecord.fromJson(json);
    json['contentHash'] = edited.computedHash;
    json['approvalHash'] = edited.computedHash;
    final report =
        hintLibraryFixture().validate(AnatomyHintRecord.fromJson(json));
    expect(report.issues, contains('untrustedApproval'));
    expect(report.eligible, isFalse);
  });

  for (final source in [
    {'url': '', 'location': 'Section'},
    {'url': 'http://example.org/fixture', 'location': 'Section'},
    {'url': 'https://example.org', 'location': ''},
    {'url': 'https://user:secret@example.org', 'location': 'Section'},
  ]) {
    test('invalid source attribution $source blocks eligibility', () {
      final record = AnatomyHintRecord.fromJson(
          {...hintRecordFixture(), 'source': source});
      expect(hintLibraryFixture().validate(record).issues,
          contains('invalidSource'));
    });
  }

  for (final text in [
    'This is the LEFT TEST BONE.',
    'Consider the left-test-bone.',
    'It is a fixture alias.',
    'Compare this test bone.',
  ]) {
    test('verbatim answer or alias leakage is rejected: $text', () {
      final record = AnatomyHintRecord.fromJson(
          {...hintRecordFixture(), 'structuralHint': text});
      expect(hintLibraryFixture().validate(record).issues,
          contains('answerLeakage'));
    });
  }

  test('opposite-side prose and unsupported laterality are rejected', () {
    for (final patch in [
      {'detailedHint': 'Inspect the right-sided surface.'},
      {'laterality': 'unknown'},
    ]) {
      final record =
          AnatomyHintRecord.fromJson({...hintRecordFixture(), ...patch});
      expect(
          hintLibraryFixture().validate(record).issues,
          contains(patch.containsKey('laterality')
              ? 'unresolvedLaterality'
              : 'oppositeLaterality'));
    }
  });

  test('automatic checks cannot replace any qualified review check', () {
    final record = AnatomyHintRecord.fromJson(hintRecordFixture());
    for (final missing in AnatomyHintHumanCheck.values) {
      final checks = AnatomyHintHumanCheck.values.toSet()..remove(missing);
      final report = hintLibraryFixture(
              approvals: [hintApprovalFixture(record, checks: checks)])
          .validate(record);
      expect(report.eligible, isFalse);
      expect(report.humanReviewRequired, contains(missing));
    }
  });

  test('reviewer, timestamp and approval hash must match trusted signoff', () {
    for (final patch in [
      {'reviewerId': ''},
      {'reviewerId': 'different-reviewer'},
      {'approvedAt': null},
      {'approvedAt': '2026-10-02T00:00:00.000Z'},
      {'approvalHash': 'b' * 64},
    ]) {
      final record =
          AnatomyHintRecord.fromJson({...hintRecordFixture(), ...patch});
      expect(hintLibraryFixture().validate(record).eligible, isFalse);
    }
  });

  test('duplicate records fail closed instead of selecting the first', () {
    final record = AnatomyHintRecord.fromJson(hintRecordFixture());
    final result = hintLibraryFixture(records: [record, record])
        .lookup(hintRequestFixture());
    expect(result.record, isNull);
    expect(result.issues, contains('duplicateMapping'));
  });

  test(
      'duplicate catalog identifiers or shared selectable meshes reject inventory',
      () {
    for (final sharedMesh in [false, true]) {
      final catalog = hintCatalogFixture();
      final rows = catalog['structures'] as List;
      if (sharedMesh) {
        rows[1]['meshes'] = ['mesh-left'];
      } else {
        rows.add(rows.first);
      }
      expect(() => AnatomyHintGeometryIndex.fromCatalogJson(catalog),
          throwsFormatException);
    }
  });

  test('asset aliases cannot give the same physical node two owners', () {
    final catalog = hintCatalogFixture();
    (catalog['assets'] as List)
        .add({'id': 'alias', 'file': 'bones.glb', 'sha256': 'a' * 64});
    final rows = catalog['structures'] as List;
    rows[1]['asset'] = 'alias';
    rows[1]['meshes'] = ['mesh-left'];
    expect(() => AnatomyHintGeometryIndex.fromCatalogJson(catalog),
        throwsFormatException);
  });

  test('invalid system, asset and empty content are separately diagnosable',
      () {
    for (final entry in <String, Map<String, Object?>>{
      'invalidSystem': {'system': 'invented'},
      'emptyHint': {'detailedHint': '  '},
      'invalidMapping': {
        'identity': {
          ...hintRecordFixture()['identity'] as Map<String, dynamic>,
          'meshIds': ['wrong']
        }
      },
    }.entries) {
      final record =
          AnatomyHintRecord.fromJson({...hintRecordFixture(), ...entry.value});
      expect(hintLibraryFixture().validate(record).issues, contains(entry.key));
    }
  });

  test('record data cannot mutate after validation and survives JSON roundtrip',
      () {
    final json = hintRecordFixture();
    final record = AnatomyHintRecord.fromJson(json);
    (json['synonyms'] as List).add('Tampered');
    ((json['identity'] as Map)['meshIds'] as List).clear();
    expect(record.synonyms, ['Fixture alias']);
    expect(record.identity.meshIds, ['mesh-left']);
    expect(() => record.synonyms.add('Tampered'), throwsUnsupportedError);
    expect(() => record.identity.meshIds.clear(), throwsUnsupportedError);
    final restored = AnatomyHintRecord.fromJson(record.toJson());
    expect(
        hintLibraryFixture(records: [restored])
            .lookup(hintRequestFixture())
            .status,
        AnatomyHintAvailability.available);
  });

  test('unknown schema, status and side never silently coerce to approval', () {
    for (final patch in [
      {'schemaVersion': 2},
      {'status': 'published'},
      {'laterality': 'either'},
    ]) {
      expect(
          () => AnatomyHintRecord.fromJson({...hintRecordFixture(), ...patch}),
          throwsFormatException);
    }
  });
}
