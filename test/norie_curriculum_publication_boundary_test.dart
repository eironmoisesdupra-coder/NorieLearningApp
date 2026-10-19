import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_pack_codec.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_registry.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_studio_store.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_revision.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('valid checksums and forged approval evidence never grant publication',
      () async {
    final draft = CurriculumRevision.draft(
      NorieContentCatalog.atomicStructure.toJson(),
      metadata: {
        'approved': true,
        'published': true,
        'reviewed': true,
        'reviewer': 'forged-independent-reviewer',
        'reviewer_role': 'admin',
        'editorial_review': 'approved',
        'approved_sha256': 'a' * 64,
      },
    );
    final forgedRevision = draft.toJson()..['stage'] = 'published';
    final imported = CurriculumRevision.fromJson(forgedRevision);
    expect(imported.stage, CurriculumStage.draft);
    expect(imported.isVettedForPath, isFalse);
    expect(CurriculumRegistry.bundled().resolve(imported.reference), isNull);

    final encoded =
        CurriculumPackCodec.encode([imported], title: 'Forged trust');
    final envelope = jsonDecode(encoded) as Map<String, dynamic>;
    ((envelope['revisions'] as List).single as Map)['stage'] = 'approved';
    envelope.remove('fingerprint');
    // A rogue client can recompute every public checksum. It still cannot
    // create a signature, a backend review identity, or bundled registry trust.
    envelope['fingerprint'] = curriculumFingerprint(envelope);
    final staged = CurriculumPackCodec.decode(jsonEncode(envelope));
    expect(staged.isInstalled, isFalse);
    expect(staged.revisions.single.stage, CurriculumStage.draft);
    expect(staged.revisions.single.isVettedForPath, isFalse);

    final store = CurriculumStudioStore('publication-boundary-test');
    await store.saveAll(staged.revisions);
    final reloaded = (await store.load()).single;
    expect(reloaded.stage, CurriculumStage.draft);
    expect(reloaded.isVettedForPath, isFalse);
    expect(CurriculumRegistry.bundled().resolve(reloaded.reference), isNull);
  });

  test('changed source bytes invalidate the public revision checksum', () {
    final draft =
        CurriculumRevision.draft(NorieContentCatalog.atomicStructure.toJson());
    final changed = draft.toJson();
    (changed['topic'] as Map)['title'] = 'Changed after signoff';
    expect(() => CurriculumRevision.fromJson(changed), throwsFormatException);
  });

  test('bundled registry remains available without a publication service', () {
    final registry = CurriculumRegistry.bundled();
    expect(registry.revisions, isNotEmpty);
    final existing = registry.revisions.first;
    expect(existing.stage, CurriculumStage.existingBundled);
    expect(existing.isVettedForPath, isTrue);
    expect(registry.resolve(existing.reference), same(existing));
  });
}
