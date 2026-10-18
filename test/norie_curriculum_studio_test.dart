import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_studio_store.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_revision.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_path.dart';
import 'package:norie_learning/features/curriculum/data/curriculum_registry.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('paths pin immutable fingerprints and reject missing prerequisites', () {
    final registry = CurriculumRegistry.bundled();
    final atom = registry.revisions
        .firstWhere((r) => r.id == NorieContentCatalog.atomicStructure.id);
    final path = CurriculumPath(id: 'atoms', title: 'Atoms', nodes: [
      CurriculumPathNode(
          id: 'intro',
          kind: CurriculumPathNodeKind.lesson,
          reference: atom.reference)
    ]);
    expect(path.validate(registry), isEmpty);
    final forged = CurriculumPath(id: 'bad', title: 'Bad', nodes: [
      CurriculumPathNode(
          id: 'x',
          kind: CurriculumPathNodeKind.lesson,
          reference: CurriculumReference(atom.id, atom.revision, 'wrong'))
    ]);
    expect(forged.validate(registry), isNotEmpty);
  });
  test('draft history survives restart and stays owner scoped', () async {
    final store = CurriculumStudioStore('alice');
    final draft =
        CurriculumRevision.draft(NorieContentCatalog.atomicStructure.toJson());
    await store.save(draft);
    final updated = draft.topicJson..['title'] = 'Revised atom';
    await store.save(CurriculumRevision.draft(updated));
    expect((await CurriculumStudioStore('alice').load()).single.topic.title,
        'Revised atom');
    expect(await CurriculumStudioStore('bob').load(), isEmpty);
    await store.rollback(draft.id);
    expect((await store.load()).single.fingerprint, draft.fingerprint);
    expect((await store.history(draft.id)).length, 3);
  });
  test('stale owner guard cancels a queued write before persistence', () async {
    var current = true;
    final store = CurriculumStudioStore('alice', stillCurrent: () => current);
    final pending = store.save(
        CurriculumRevision.draft(NorieContentCatalog.atomicStructure.toJson()));
    current = false;
    await expectLater(pending, throwsFormatException);
    expect(await CurriculumStudioStore('alice').load(), isEmpty);
  });
  test('empty owner is rejected and simultaneous saves keep both drafts',
      () async {
    expect(() => CurriculumStudioStore(''), throwsArgumentError);
    final store = CurriculumStudioStore('alice');
    final first = NorieContentCatalog.atomicStructure.toJson();
    final second = NorieContentCatalog.atomicStructure.toJson()
      ..['id'] = 'other.atoms';
    await Future.wait([
      store.save(CurriculumRevision.draft(first)),
      store.save(CurriculumRevision.draft(second))
    ]);
    expect((await store.load()).map((r) => r.id).toSet(),
        {first['id'], second['id']});
  });
  test('published status in draft payload is demoted', () async {
    final store = CurriculumStudioStore('alice');
    await store.save(CurriculumRevision.existing(
        NorieContentCatalog.atomicStructure.toJson()));
    expect((await store.load()).single.stage, CurriculumStage.draft);
  });
}
