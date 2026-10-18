import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_revision.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_pack_codec.dart';

void main() {
  final revision =
      CurriculumRevision.draft(NorieContentCatalog.atomicStructure.toJson());
  test('roundtrip is staged and cannot promote client publication', () {
    final encoded =
        CurriculumPackCodec.encode([revision], title: 'Local atoms');
    final pack = CurriculumPackCodec.decode(encoded);
    expect(pack.revisions.single.fingerprint, revision.fingerprint);
    expect(pack.revisions.single.stage, CurriculumStage.draft);
    expect(pack.isInstalled, isFalse);
    final forged = jsonDecode(encoded) as Map<String, dynamic>;
    (forged['revisions'] as List).first['stage'] = 'published';
    expect(() => CurriculumPackCodec.decode(jsonEncode(forged)),
        throwsFormatException);
  });
  test('per-lesson limits reject dense collections before model construction',
      () {
    final topic = NorieContentCatalog.atomicStructure.toJson();
    (topic['lesson'] as Map)['sections'] = List.generate(
        1000,
        (_) => {
              'title': 'x',
              'symbol': '',
              'points': ['x']
            });
    expect(() => CurriculumRevision.draft(topic), throwsFormatException);
  });
  test('tampered content and oversized inputs fail closed', () {
    final doc =
        jsonDecode(CurriculumPackCodec.encode([revision], title: 'Atoms'))
            as Map<String, dynamic>;
    ((doc['revisions'] as List).first['topic'] as Map)['title'] = 'tampered';
    expect(() => CurriculumPackCodec.decode(jsonEncode(doc)),
        throwsFormatException);
    expect(
        () => CurriculumPackCodec.decode(
            ' ' * (CurriculumPackCodec.maxBytes + 1)),
        throwsFormatException);
  });
}
