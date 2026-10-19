import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/data/anatomy_backup_persistence.dart';
import 'package:norie_learning/features/learning/data/anatomy_study_store.dart';
import 'package:norie_learning/features/learning/data/anatomy_atlas_bookmark_store.dart';
import 'package:norie_learning/features/learning/domain/anatomy_guided_learning.dart';
import 'package:norie_learning/core/progression/anatomy_progress_backup.dart';

import 'anatomy_guided_learning_test.dart' show guidedCatalog;

void main() {
  late Map<String, String> disk;
  late AnatomyBackupPersistence storage;
  setUp(() {
    disk = {};
    storage = AnatomyBackupPersistence(
      read: (key) async => disk[key],
      write: (key, value) async {
        disk[key] = value;
        return true;
      },
    );
  });

  test(
      'a blocked owner cannot stall another owner while same-owner writes wait',
      () async {
    final entered = Completer<void>();
    final release = Completer<void>();
    var block = true, otherFinished = false, sameFinished = false;
    final guarded = AnatomyBackupPersistence(read: (key) async {
      if (block && key.contains('account.a')) {
        block = false;
        entered.complete();
        await release.future;
      }
      return disk[key];
    });
    final first = guarded.readPart('account.a', 'study');
    await entered.future;
    final same = guarded.readPart('account.a', 'bookmarks').then((_) {
      sameFinished = true;
    });
    final other = guarded.readPart('account.b', 'study').then((_) {
      otherFinished = true;
    });
    try {
      await Future<void>.delayed(Duration.zero);
      expect(otherFinished, isTrue,
          reason:
              'Independent learner storage must not share a blocked queue.');
      expect(sameFinished, isFalse,
          reason: 'Operations for one learner must still serialize.');
    } finally {
      release.complete();
      await first;
      await same;
      await other;
    }
  });

  test('migration preserves both legacy parts and leaves original keys intact',
      () async {
    disk['norie.anatomy.study.v1.account.a'] = 'old-study';
    disk['norie.anatomy.bookmarks.v1.account.a'] = 'old-views';
    await storage.writePart('account.a', 'study', 'new-study',
        stillCurrent: () => true);
    expect(await storage.capture('account.a'),
        {'study': 'new-study', 'bookmarks': 'old-views'});
    expect(disk['norie.anatomy.study.v1.account.a'], 'old-study');
    expect(disk['norie.anatomy.bookmarks.v1.account.a'], 'old-views');
  });

  test(
      'pair restore writes one envelope and never partially applies on write failure',
      () async {
    await storage.restore(
        'account.a', {'study': 'before', 'bookmarks': 'before'},
        stillCurrent: () => true);
    var writes = 0;
    final failing = AnatomyBackupPersistence(
      read: (key) async => disk[key],
      write: (key, value) async {
        writes++;
        return false;
      },
    );
    await expectLater(
        failing.restore('account.a', {'study': 'after', 'bookmarks': 'after'},
            stillCurrent: () => true),
        throwsStateError);
    expect(writes, 1);
    expect(await storage.capture('account.a'),
        {'study': 'before', 'bookmarks': 'before'});
  });

  test(
      'queued writes precede capture and stale pre-restore writes cannot overwrite it',
      () async {
    final revision = storage.revision('account.a');
    final first = storage.writePart('account.a', 'study', 'queued',
        stillCurrent: () => true, expectedRevision: revision);
    final captured = storage.capture('account.a');
    await first;
    expect((await captured)['study'], 'queued');
    await storage.restore(
        'account.a', {'study': 'restored', 'bookmarks': 'views'},
        stillCurrent: () => true);
    expect(
        await storage.writePart('account.a', 'study', 'obsolete',
            stillCurrent: () => true, expectedRevision: revision),
        isFalse);
    expect((await storage.capture('account.a'))['study'], 'restored');
  });

  test('A to B to A during platform write compensates before a newer capture',
      () async {
    await storage.restore(
        'account.a', {'study': 'before', 'bookmarks': 'before'},
        stillCurrent: () => true);
    final entered = Completer<void>();
    final release = Completer<void>();
    var generation = 0;
    var writes = 0;
    final racing = AnatomyBackupPersistence(
      read: (key) async => disk[key],
      write: (key, value) async {
        disk[key] = value;
        if (++writes == 1) {
          entered.complete();
          await release.future;
        }
        return true;
      },
    );
    final restoring = racing.restore(
        'account.a', {'study': 'after', 'bookmarks': 'after'},
        stillCurrent: () => generation == 0);
    await entered.future;
    generation = 2; // A -> B -> A still invalidates the captured generation.
    final later = racing.capture('account.a');
    release.complete();
    expect(await restoring, isFalse);
    expect(await later, {'study': 'before', 'bookmarks': 'before'});
  });

  test(
      'damaged envelope fails closed instead of falling back to empty legacy data',
      () async {
    await storage.restore('guest', {'study': 'evidence', 'bookmarks': 'views'},
        stillCurrent: () => true);
    final key = disk.keys.single;
    final envelope = jsonDecode(disk[key]!) as Map;
    envelope['owner'] = 'account.someone-else';
    disk[key] = jsonEncode(envelope);
    await expectLater(storage.capture('guest'), throwsFormatException);
  });

  test('interrupted staged restore recovers previous pair before any read',
      () async {
    await storage.restore(
        'account.a', {'study': 'before', 'bookmarks': 'before'},
        stillCurrent: () => true);
    String? interruptedKey, interruptedValue;
    var writes = 0;
    final interrupted = AnatomyBackupPersistence(
      read: (key) async => disk[key],
      write: (key, value) async {
        if (++writes == 1) {
          interruptedKey = key;
          interruptedValue = value;
        }
        if (writes > 1) throw StateError('platform unavailable');
        disk[key] = value;
        return true;
      },
    );
    await expectLater(
        interrupted.restore(
            'account.a', {'study': 'after', 'bookmarks': 'after'},
            stillCurrent: () => true),
        throwsStateError);
    // Reproduce the process dying immediately after durable staging, then reopen.
    disk[interruptedKey!] = interruptedValue!;
    expect(await storage.capture('account.a'),
        {'study': 'before', 'bookmarks': 'before'});
    expect(jsonDecode(disk[interruptedKey!]!)['pending'], isNull);
  });

  test('live study and bookmark instances flush and adopt the committed pair',
      () async {
    final catalog = guidedCatalog();
    final study = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final views =
        AnatomyAtlasBookmarkStore('account.a', catalog, persistence: storage);
    addTearDown(study.dispose);
    addTearDown(views.dispose);
    await study.initialize();
    await views.load();
    study.select('bp-FJ3365');
    study
        .recordStudy(); // Deliberately leave the instance's save queue pending.
    final captured = await storage.capture('account.a');
    expect(
        (jsonDecode(captured['study']!)['entries'] as List).single['studied'],
        true);
    final preRestoreCallback = study.captureOwnerGuard();
    final replacement = jsonEncode({
      'version': 1,
      'contentVersion': 1,
      'selected': 'bp-FJ2541',
      'entries': [
        AnatomyStudyProgress(structureId: 'bp-FJ2541', studied: true).toJson(),
      ]
    });
    final replacementViews = jsonEncode({
      'version': 1,
      'owner': 'account.a',
      'bookmarks': [
        {'reference': 'male', 'structureId': 'bp-FJ2541', 'view': 'back'}
      ]
    });
    await storage.restore(
        'account.a', {'study': replacement, 'bookmarks': replacementViews},
        stillCurrent: () => true);
    expect(study.current!.structureId, 'bp-FJ2541');
    expect(preRestoreCallback(), isFalse,
        reason:
            'A delayed activity callback must not mutate restored evidence.');
    expect(views.bookmarks.single.view, 'back');
    study.goToStep(AnatomyStudyStep.review);
    await study.flush();
    final after = await storage.capture('account.a');
    expect((jsonDecode(after['study']!)['entries'] as List).single['id'],
        'bp-FJ2541');
    expect(jsonDecode(after['bookmarks']!)['bookmarks'], hasLength(1));
  });

  test(
      'two live study instances retain disjoint queued evidence through empty import',
      () async {
    final catalog = guidedCatalog();
    final first = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final second = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await first.initialize();
    await second.initialize();
    first.select('bp-FJ3365');
    first.recordStudy();
    second.select('bp-FJ2541');
    second.recordStudy();
    final empty = AnatomyProgressBackup.fromLocalParts(
        {'study': null, 'bookmarks': null},
        catalog: catalog, currentOwner: 'a');
    await storage.restore(
        'account.a',
        AnatomyProgressBackup.toLocalParts(empty,
            catalog: catalog, currentOwner: 'a'),
        stillCurrent: () => true,
        mergeWithCurrent: (parts) => AnatomyProgressBackup.toLocalParts(
            AnatomyProgressBackup.merge(
                AnatomyProgressBackup.fromLocalParts(parts,
                    catalog: catalog, currentOwner: 'a'),
                empty,
                catalog: catalog,
                currentOwner: 'a'),
            catalog: catalog,
            currentOwner: 'a'));
    for (final store in [first, second]) {
      expect(store.entries.keys.toSet(), {'bp-FJ3365', 'bp-FJ2541'});
      expect(store.entries.values.every((entry) => entry.studied), isTrue);
    }
    final parts = await storage.capture('account.a');
    expect(jsonDecode(parts['study']!)['entries'], hasLength(2));
  });

  test(
      'conflicting same-entry saves keep independent and assisted evidence separate',
      () async {
    final catalog = guidedCatalog();
    final first = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final second = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await first.initialize();
    await second.initialize();
    first.select('bp-FJ3365');
    first.recordCheck(correct: true, assisted: false);
    second.select('bp-FJ3365');
    second.recordCheck(correct: true, assisted: true);
    final parts = await storage.capture('account.a');
    final row = (jsonDecode(parts['study']!)['entries'] as List).single as Map;
    expect(row['attempts'], 1);
    expect(row['correct'], 1);
    expect(row['assisted'], 1);
  });

  test(
      'explicit study reset clears every live instance and retains saved views',
      () async {
    final catalog = guidedCatalog();
    final first = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final second = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final views =
        AnatomyAtlasBookmarkStore('account.a', catalog, persistence: storage);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    addTearDown(views.dispose);
    await first.initialize();
    await second.initialize();
    await views.load();
    await views.save(
        reference: 'male', structureId: 'bp-FJ3365', view: 'front');
    first.select('bp-FJ3365');
    first.recordStudy();
    second.select('bp-FJ2541');
    second.recordStudy();
    await first.reset();
    await second.flush();
    expect(first.entries, isEmpty);
    expect(second.entries, isEmpty);
    final parts = await storage.capture('account.a');
    expect(jsonDecode(parts['study']!)['entries'], isEmpty);
    expect(jsonDecode(parts['bookmarks']!)['bookmarks'], hasLength(1));
  });

  test(
      'uncontended edits retain backward navigation and explicit skip semantics',
      () async {
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(), ownerId: () => 'a', persistence: storage);
    addTearDown(store.dispose);
    await store.initialize();
    store.select('bp-FJ3365');
    store.completeStep();
    store.goToStep(AnatomyStudyStep.discover);
    store.skipStep();
    await store.flush();
    final parts = await storage.capture('account.a');
    final row = (jsonDecode(parts['study']!)['entries'] as List).single as Map;
    expect(row['done'], isEmpty);
    expect(row['skipped'], [0]);
    expect(row['step'], AnatomyStudyStep.locate.index);
  });

  test(
      'another live study reveal makes stale checks assisted before feedback and empty import',
      () async {
    final catalog = guidedCatalog();
    final first = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final second = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await first.initialize();
    await second.initialize();
    first.select('bp-FJ3365');
    second.select('bp-FJ3365');
    await first.flush();
    await second.flush();
    first.recordAnswerReveal();
    await first.flush();
    expect(second.current!.answersRevealed, isTrue,
        reason:
            'Feedback must see shared provenance before accepting a check.');
    second.recordCheck(correct: true, assisted: false);
    expect(second.current!.independentAttempts, 0,
        reason:
            'Synchronous feedback must not claim a fresh independent check.');
    expect(second.current!.independentCorrect, 0);
    expect(second.current!.assistedAttempts, 1);
    await second.flush();
    final empty = AnatomyProgressBackup.fromLocalParts(
        {'study': null, 'bookmarks': null},
        catalog: catalog, currentOwner: 'a');
    await storage.restore(
        'account.a',
        AnatomyProgressBackup.toLocalParts(empty,
            catalog: catalog, currentOwner: 'a'),
        stillCurrent: () => true,
        mergeWithCurrent: (parts) => AnatomyProgressBackup.toLocalParts(
            AnatomyProgressBackup.merge(
                AnatomyProgressBackup.fromLocalParts(parts,
                    catalog: catalog, currentOwner: 'a'),
                empty,
                catalog: catalog,
                currentOwner: 'a'),
            catalog: catalog,
            currentOwner: 'a'));
    final parts = await storage.capture('account.a');
    final row = (jsonDecode(parts['study']!)['entries'] as List).single as Map;
    expect(row['attempts'], 0);
    expect(row['correct'], 0);
    expect(row['assisted'], 1);
    expect(first.current!.independentAttempts, 0);
    expect(second.current!.independentAttempts, 0);
  });

  test(
      'shared reveal protection preserves real history and resets only with explicit reset',
      () async {
    final catalog = guidedCatalog();
    final first = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    final second = AnatomyStudyStore(
        catalog: catalog, ownerId: () => 'a', persistence: storage);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await first.initialize();
    await second.initialize();
    first.select('bp-FJ3365');
    second.select('bp-FJ3365');
    first.recordCheck(correct: true, assisted: false);
    await first.flush();
    second.recordCheck(correct: true, assisted: false);
    await second.flush();
    final parts = await storage.capture('account.a');
    final row = (jsonDecode(parts['study']!)['entries'] as List).single as Map;
    expect(row['attempts'], 1);
    expect(row['correct'], 1);
    expect(row['assisted'], 1);
    await first.reset();
    second.select('bp-FJ3365');
    second.recordCheck(correct: true, assisted: false);
    expect(second.current!.independentAttempts, 1);
    expect(second.current!.assistedAttempts, 0);
    await second.flush();
  });

  for (final phase in [1, 2]) {
    test(
        'restore phase $phase visibly freezes live edits and resumes after commit',
        () async {
      final entered = Completer<void>();
      final release = Completer<void>();
      addTearDown(() {
        if (!release.isCompleted) release.complete();
      });
      var restoring = false, writes = 0;
      final guarded = AnatomyBackupPersistence(
          read: (key) async => disk[key],
          write: (key, value) async {
            if (restoring && ++writes == phase) {
              entered.complete();
              await release.future;
            }
            disk[key] = value;
            return true;
          });
      final catalog = guidedCatalog();
      final store = AnatomyStudyStore(
          catalog: catalog, ownerId: () => 'a', persistence: guarded);
      final views =
          AnatomyAtlasBookmarkStore('account.a', catalog, persistence: guarded);
      addTearDown(store.dispose);
      addTearDown(views.dispose);
      await store.initialize();
      await views.load();
      store.select('bp-FJ3365');
      store.recordStudy();
      final previous = await guarded.capture('account.a');
      restoring = true;
      final transaction =
          guarded.restore('account.a', previous, stillCurrent: () => true);
      await entered.future;
      expect(store.ready, isFalse,
          reason: 'Existing UI must show the busy state.');
      expect(store.select('bp-FJ2541'), isFalse);
      expect(store.recordCheck(correct: true, assisted: false), isFalse);
      expect(store.recordAnswerReveal(), isFalse);
      store.recordIdentification();
      expect(store.current!.identified, isFalse);
      final rejectedView = expectLater(
          views.save(reference: 'male', structureId: 'bp-FJ3365', view: 'back'),
          throwsStateError);
      release.complete();
      expect(await transaction, isTrue);
      await rejectedView;
      expect(store.ready, isTrue);
      expect(store.current!.identified, isFalse);
      store.recordIdentification();
      await store.flush();
      expect(store.current!.identified, isTrue);
    });
  }
}
