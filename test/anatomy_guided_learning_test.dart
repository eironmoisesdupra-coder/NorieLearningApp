import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/data/anatomy_study_store.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_guided_learning.dart';

AnatomyAtlasCatalog guidedCatalog() => AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'Adult male', 'description': 'Reference'}
      ],
      'structures': [
        for (final row in [
          ['bp-FJ3365', 'Right femur', 'skeletal'],
          ['bp-FJ2541', 'Trachea', 'respiratory'],
          ['bp-FJ2422', 'Cavity of left ventricle', 'cardiovascular'],
        ])
          {
            'id': row[0],
            'name': row[1],
            'systems': [row[2]],
            'reference': 'male',
            'asset': 'male-${row[2]}',
            'source': 'bodyparts3d',
            'ontology': '',
          }
      ],
    });

void main() {
  test('skipping leaves unfinished evidence after review and reload', () async {
    final memory = <String, String>{};
    final store = AnatomyStudyStore(
      catalog: guidedCatalog(),
      ownerId: () => 'a',
      read: (key) async => memory[key],
      write: (key, value) async {
        memory[key] = value;
      },
    );
    await store.initialize();
    store.select('bp-FJ3365');
    store.completeStep();
    store.skipStep();
    for (var i = 0; i < 5; i++) {
      store.completeStep();
    }
    await store.flush();
    expect(store.current!.completed, isFalse);
    expect(store.current!.skippedSteps, contains(AnatomyStudyStep.locate));
    final restored = AnatomyStudyStore(
      catalog: guidedCatalog(),
      ownerId: () => 'a',
      read: (key) async => memory[key],
      write: (key, value) async {
        memory[key] = value;
      },
    );
    await restored.initialize();
    expect(restored.current!.step, AnatomyStudyStep.review);
    expect(restored.current!.completed, isFalse);
    restored.goToStep(AnatomyStudyStep.locate);
    restored.completeStep();
    expect(restored.current!.completed, isTrue);
    store.dispose();
    restored.dispose();
  });

  test('assisted checks and metadata study never become independent evidence',
      () async {
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => null,
        read: (_) async => null,
        write: (_, __) async {});
    await store.initialize();
    store.select('bp-FJ2541');
    store.recordIdentification();
    store.recordStudy();
    store.recordCheck(correct: true, assisted: true);
    expect(store.current!.identified, isTrue);
    expect(store.current!.studied, isTrue);
    expect(store.current!.independentAttempts, 0);
    expect(store.current!.independentCorrect, 0);
    store.recordCheck(correct: false, assisted: false);
    store.recordCheck(correct: true, assisted: false);
    expect(store.current!.independentAttempts, 0);
    expect(store.current!.independentCorrect, 0);
    expect(store.current!.assistedAttempts, 3);
    store.dispose();
  });

  test('A to B to A invalidates a pending restore and queued owner writes',
      () async {
    final owner = ValueNotifier<String?>('a');
    final firstRead = Completer<String?>();
    final readStarted = Completer<void>();
    var reads = 0;
    final memory = <String, String>{};
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => owner.value,
        ownerChanges: owner,
        read: (key) async {
          if (++reads == 1) {
            readStarted.complete();
            return firstRead.future;
          }
          return memory[key];
        },
        write: (key, value) async {
          memory[key] = value;
        });
    final stale = store.initialize();
    await readStarted.future;
    final oldOwnerGuard = store.captureOwnerGuard();
    owner.value = 'b';
    owner.value = 'a';
    await store.initialize();
    expect(oldOwnerGuard(), isFalse);
    store.select('bp-FJ2422');
    firstRead.complete(jsonEncode({
      'version': 1,
      'contentVersion': 1,
      'selected': 'bp-FJ3365',
      'entries': [
        {
          'id': 'bp-FJ3365',
          'step': 0,
          'done': [],
          'skipped': [],
          'identified': false,
          'studied': false,
          'assisted': 0,
          'attempts': 0,
          'correct': 0,
        }
      ]
    }));
    await stale;
    await store.flush();
    expect(store.current!.structureId, 'bp-FJ2422');
    owner.value = 'b';
    await store.initialize();
    expect(store.current, isNull);
    store.select('bp-FJ2541');
    await store.flush();
    owner.value = 'a';
    await store.initialize();
    expect(store.current!.structureId, 'bp-FJ2422');
    expect(memory.keys.length, 2);
    store.dispose();
    owner.dispose();
  });

  test('restore rejects malformed version, unknown IDs and excessive payloads',
      () async {
    for (final raw in [
      '{broken',
      jsonEncode({'version': 99}),
      jsonEncode({
        'version': 1,
        'contentVersion': 1,
        'selected': 'missing',
        'entries': [
          {'id': 'missing', 'step': 400, 'correct': -1},
          {
            'id': 'bp-FJ2422',
            'step': 999,
            'completed': [0, 1, 2, 3, 4, 5, 6]
          },
        ]
      }),
      jsonEncode({
        'version': 1,
        'contentVersion': 1,
        'selected': 'bp-FJ2422',
        'entries': List.filled(129, {
          'id': 'bp-FJ2422',
          'step': 0,
          'done': [],
          'skipped': [],
          'identified': false,
          'studied': false,
          'assisted': 0,
          'attempts': 0,
          'correct': 0,
        })
      }),
      ' ' * 262145
    ]) {
      final store = AnatomyStudyStore(
          catalog: guidedCatalog(),
          ownerId: () => 'a',
          read: (_) async => raw,
          write: (_, __) async {});
      await store.initialize();
      expect(store.current, isNull);
      expect(store.entries, isEmpty);
      store.dispose();
    }
  });

  test('an in-flight old-owner write cannot overwrite a resumed owner session',
      () async {
    final owner = ValueNotifier<String?>('a');
    final memory = <String, String>{};
    final release = Completer<void>();
    final started = Completer<void>();
    var block = true;
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => owner.value,
        ownerChanges: owner,
        read: (key) async => memory[key],
        write: (key, value) async {
          if (block) {
            block = false;
            started.complete();
            await release.future;
          }
          memory[key] = value;
        });
    await store.initialize();
    store.select('bp-FJ3365');
    await started.future;
    store.goToStep(AnatomyStudyStep.explore);
    owner.value = 'b';
    owner.value = 'a';
    release.complete();
    await store.initialize();
    // The queued Explore mutation belonged to the previous owner generation.
    expect(store.current!.step, AnatomyStudyStep.discover);
    store.select('bp-FJ2422');
    await store.flush();
    owner.value = 'b';
    await store.initialize();
    owner.value = 'a';
    await store.initialize();
    expect(store.current!.structureId, 'bp-FJ2422');
    store.dispose();
    owner.dispose();
  });

  test('reset clears only active owner and resumes another owner independently',
      () async {
    final owner = ValueNotifier<String?>('a');
    final memory = <String, String>{};
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => owner.value,
        ownerChanges: owner,
        read: (key) async => memory[key],
        write: (key, value) async {
          memory[key] = value;
        });
    await store.initialize();
    store.select('bp-FJ2422');
    await store.flush();
    owner.value = 'b';
    await store.initialize();
    store.select('bp-FJ2541');
    await store.flush();
    await store.reset();
    expect(store.current, isNull);
    owner.value = 'a';
    await store.initialize();
    expect(store.current!.structureId, 'bp-FJ2422');
    store.dispose();
    owner.dispose();
  });

  test('reset begun during A restore cannot clear B after an owner switch',
      () async {
    final owner = ValueNotifier<String?>('a');
    final aRead = Completer<String?>();
    final started = Completer<void>();
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => owner.value,
        ownerChanges: owner,
        read: (_) async {
          if (owner.value == 'a') {
            started.complete();
            return aRead.future;
          }
          return null;
        },
        write: (_, __) async {});
    final loadingA = store.initialize();
    await started.future;
    final resettingA = store.reset();
    owner.value = 'b';
    await store.initialize();
    store.select('bp-FJ2541');
    store.goToStep(AnatomyStudyStep.explore);
    aRead.complete(null);
    await loadingA;
    await resettingA;
    expect(store.current?.structureId, 'bp-FJ2541');
    expect(store.current?.step, AnatomyStudyStep.explore);
    store.dispose();
    owner.dispose();
  });

  test(
      'assistance provenance survives reload and cannot be relabelled independent',
      () async {
    final memory = <String, String>{};
    AnatomyStudyStore makeStore() => AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => 'a',
        read: (key) async => memory[key],
        write: (key, value) async {
          memory[key] = value;
        });
    final first = makeStore();
    await first.initialize();
    first.select('bp-FJ3365');
    first.recordCheck(correct: true, assisted: true);
    await first.flush();
    first.dispose();
    final restored = makeStore();
    await restored.initialize();
    restored.goToStep(AnatomyStudyStep.apply);
    restored.recordCheck(correct: true, assisted: false);
    expect(restored.current!.independentAttempts, 0);
    expect(restored.current!.assistedAttempts, 2);
    restored.dispose();
  });

  test(
      'a repeat of an answered item is practice rather than fresh independent evidence',
      () async {
    final store = AnatomyStudyStore(
        catalog: guidedCatalog(),
        ownerId: () => 'a',
        read: (_) async => null,
        write: (_, __) async {});
    await store.initialize();
    store.select('bp-FJ3365');
    store.recordCheck(correct: true, assisted: false);
    expect(store.current!.independentAttempts, 1);
    expect(store.current!.independentCorrect, 1);
    store.goToStep(AnatomyStudyStep.explore);
    store.goToStep(AnatomyStudyStep.practice);
    store.recordCheck(correct: true, assisted: false);
    expect(store.current!.independentAttempts, 1);
    expect(store.current!.assistedAttempts, 1);
    store.dispose();
  });

  test(
      'guided cards map model reference and expose no unapproved medical teaching',
      () {
    final modules = AnatomyGuidedModule.representativePaths(guidedCatalog());
    expect(modules.map((m) => m.structure.id),
        ['bp-FJ3365', 'bp-FJ2541', 'bp-FJ2422']);
    for (final module in modules) {
      expect(module.structure.reference, 'male');
      expect(module.source, 'bodyparts3d');
      expect(module.approvedExplanation, isNull);
      expect(
          module.editorialStatus, AnatomyEditorialStatus.catalogMetadataOnly);
    }
  });
}
