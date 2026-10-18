import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_revision.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_validation.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_registry.dart';

void main() {
  test(
      'snapshots preserve IDs and cannot be mutated through source or returned JSON',
      () {
    final source = NorieContentCatalog.atomicStructure.toJson();
    final revision = CurriculumRevision.existing(source);
    final fingerprint = revision.fingerprint;
    source['title'] = 'changed';
    revision.topicJson['title'] = 'changed again';
    expect(revision.topic.id, NorieContentCatalog.atomicStructure.id);
    expect(revision.topic.title, 'Atomic Structure');
    expect(revision.fingerprint, fingerprint);
    expect(revision.stage, CurriculumStage.existingBundled);
    expect(revision.metadata['reviewer'], isNull);
  });
  test('fingerprints canonicalize map keys and distinguish content', () {
    expect(curriculumFingerprint({'b': 2, 'a': 1}),
        curriculumFingerprint({'a': 1, 'b': 2}));
    expect(curriculumFingerprint({'a': 2}),
        isNot(curriculumFingerprint({'a': 1})));
    expect(curriculumFingerprint({}),
        '44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a');
  });
  test('strict editorial validator reports metadata, bad key and cycle', () {
    final doc = NorieContentCatalog.atomicStructure.toJson();
    doc['prerequisite_topic_id'] = doc['id'];
    ((doc['quiz'] as Map)['questions'] as List).first['correct_index'] = 999;
    final revision = CurriculumRevision.draft(doc);
    final issues = CurriculumValidator.validate([revision]);
    expect(issues.map((i) => i.code),
        containsAll(['prerequisite_cycle', 'answer_key', 'metadata']));
  });
  test(
      'offline asset manifests require accessibility, licenses and actual paths',
      () {
    final draft = CurriculumRevision.draft(
        NorieContentCatalog.atomicStructure.toJson(),
        metadata: {
          'assets': [
            {'path': '../escape.png', 'alt_text': '', 'license': ''},
            {
              'path': 'assets/missing.png',
              'alt_text': 'Atom',
              'license': 'CC BY 4.0'
            }
          ]
        });
    final issues = CurriculumValidator.validate([draft], availableAssets: {});
    expect(
        issues.map((i) => i.code),
        containsAll([
          'asset_path',
          'asset_accessibility',
          'asset_license',
          'missing_asset'
        ]));
  });
  test('untrusted JSON cannot designate a vetted learner revision', () {
    final revision = CurriculumRevision.existing(
        NorieContentCatalog.atomicStructure.toJson());
    final imported =
        CurriculumRevision.fromJson(jsonDecode(jsonEncode(revision.toJson())));
    expect(imported.stage, CurriculumStage.draft);
    expect(CurriculumRegistry.bundled().resolve(imported.reference), isNotNull);
    expect(imported.isVettedForPath, isFalse);
  });
}
