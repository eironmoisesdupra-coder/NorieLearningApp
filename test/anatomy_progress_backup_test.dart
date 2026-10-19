import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/anatomy_progress_backup.dart';
import 'package:norie_learning/core/progression/norie_progress_backup.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/learning/domain/anatomy_guided_learning.dart';

import 'anatomy_guided_learning_test.dart' show guidedCatalog;

void main() {
  final catalog = guidedCatalog();
  test('legacy backup cannot silently discard an anatomy extension', () {
    final legacy = jsonDecode(NorieProgressBackup.encode(
        NorieProgression.instance.exportCloudState(),
        owner: 'a')) as Map;
    legacy['extensions'] = {
      'anatomy': {'version': 999}
    };
    expect(
        () => NorieProgressBackup.decode(jsonEncode(legacy), currentOwner: 'a'),
        throwsFormatException);
  });
  Map<String, dynamic> snapshot({String? owner = 'a'}) => {
        'version': 1,
        'catalog': 'assets/anatomy/atlas-catalog.json',
        'catalogVersion': 1,
        'contentVersion': 1,
        'owner': owner,
        'provenance': 'local-learner-activity-unverified',
        'exportedAt': '2026-10-19T00:00:00Z',
        'selected': 'bp-FJ3365',
        'study': [
          {
            ...AnatomyStudyProgress(structureId: 'bp-FJ3365').toJson(),
            'reference': 'male',
          },
        ],
        'bookmarks': [
          {'structureId': 'bp-FJ3365', 'reference': 'male', 'view': 'front'},
        ],
      };

  test('owner-bound anatomy extension roundtrips without reward fields', () {
    final state = snapshot();
    final decoded = AnatomyProgressBackup.decode(jsonEncode(state),
        catalog: catalog, currentOwner: 'a');
    expect(decoded, state);
    expect(decoded.keys, isNot(contains('total_xp')));
    expect(decoded.keys, isNot(contains('credit_transactions')));
  });

  test(
      'local persisted parts roundtrip while legacy missing reveal flags stay conservative',
      () {
    final row = AnatomyStudyProgress(
            structureId: 'bp-FJ3365',
            independentAttempts: 1,
            independentCorrect: 1)
        .toJson()
      ..remove('answersRevealed');
    final state = AnatomyProgressBackup.fromLocalParts({
      'study': jsonEncode({
        'version': 1,
        'contentVersion': 1,
        'selected': 'bp-FJ3365',
        'entries': [row]
      }),
      'bookmarks': null,
    }, catalog: catalog, currentOwner: 'a');
    expect((state['study'] as List).single['answersRevealed'], isTrue);
    final parts = AnatomyProgressBackup.toLocalParts(state,
        catalog: catalog, currentOwner: 'a');
    expect(jsonDecode(parts['study']!)['entries'], hasLength(1));
    expect(jsonDecode(parts['bookmarks']!)['owner'], 'account.a');
  });

  test('local invalid evidence cannot export as an empty safe snapshot', () {
    for (final raw in [
      '{damaged',
      jsonEncode({
        'version': 99,
        'contentVersion': 1,
        'selected': null,
        'entries': []
      }),
      jsonEncode({
        'version': 1,
        'contentVersion': 1,
        'unexpected': null,
        'entries': []
      }),
      jsonEncode({
        'version': 1,
        'contentVersion': 1,
        'selected': null,
        'entries': [
          {'id': 'missing'},
        ]
      }),
    ]) {
      expect(
          () => AnatomyProgressBackup.fromLocalParts(
              {'study': raw, 'bookmarks': null},
              catalog: catalog, currentOwner: 'a'),
          throwsFormatException);
    }
  });

  test('account and guest boundaries are exact in both directions', () {
    for (final pair in <(String?, String?)>[
      ('a', 'b'),
      ('a', null),
      (null, 'a'),
    ]) {
      expect(
          () => AnatomyProgressBackup.decode(
              jsonEncode(snapshot(owner: pair.$1)),
              catalog: catalog,
              currentOwner: pair.$2),
          throwsFormatException);
    }
    expect(
        AnatomyProgressBackup.decode(jsonEncode(snapshot(owner: null)),
            catalog: catalog),
        snapshot(owner: null));
  });

  test('damaged, oversized, nested and incompatible extensions fail closed',
      () {
    for (final text in ['', '{', '[]', ' ' * (5 * 1024 * 1024 + 1)]) {
      expect(
          () => AnatomyProgressBackup.decode(text,
              catalog: catalog, currentOwner: 'a'),
          throwsFormatException);
    }
    for (final change in <Map<String, dynamic>>[
      {'version': 2},
      {'version': 1.0},
      {'catalogVersion': 2},
      {'catalogVersion': 1.0},
      {'contentVersion': 2},
      {'contentVersion': 1.0},
      {'catalog': '../private.json'},
      {'provenance': 'verified-mastery'},
      {'exportedAt': 'yesterday'},
      {'selected': 'missing'},
      {
        'extra': {
          'nested': ['secret']
        }
      },
    ]) {
      expect(
          () => AnatomyProgressBackup.decode(
              jsonEncode({...snapshot(), ...change}),
              catalog: catalog,
              currentOwner: 'a'),
          throwsFormatException);
    }
  });

  test('every study row, reference, duplicate and step is validated', () {
    final original =
        (snapshot()['study'] as List).single as Map<String, dynamic>;
    for (final change in <Map<String, dynamic>>[
      {'id': 'missing'},
      {'reference': 'female'},
      {'step': 7},
      {
        'done': [0, 0]
      },
      {
        'done': [1],
        'skipped': [1]
      },
      {'correct': 1, 'attempts': 0},
      {'answersRevealed': 'false'},
      {'access_token': 'never'},
    ]) {
      expect(
          () => AnatomyProgressBackup.decode(
              jsonEncode({
                ...snapshot(),
                'study': [
                  {...original, ...change}
                ]
              }),
              catalog: catalog,
              currentOwner: 'a'),
          throwsFormatException);
    }
    expect(
        () => AnatomyProgressBackup.decode(
            jsonEncode({
              ...snapshot(),
              'study': [original, original]
            }),
            catalog: catalog,
            currentOwner: 'a'),
        throwsFormatException);
  });

  test('bookmarks reject duplicate IDs, wrong references and arbitrary views',
      () {
    final original = (snapshot()['bookmarks'] as List).single as Map;
    for (final rows in [
      [original, original],
      [
        {...original, 'view': 'orbit(123)'}
      ],
      [
        {...original, 'reference': 'female'}
      ],
      [
        {...original, 'structureId': 'missing'}
      ],
      [
        {
          ...original,
          'camera': [1, 2, 3]
        }
      ],
    ]) {
      expect(
          () => AnatomyProgressBackup.decode(
              jsonEncode({...snapshot(), 'bookmarks': rows}),
              catalog: catalog,
              currentOwner: 'a'),
          throwsFormatException);
    }
  });

  test(
      'merge is idempotent and keeps independent and assisted evidence separate',
      () {
    final local = snapshot();
    final remote = snapshot();
    final localRow = (local['study'] as List).single as Map<String, dynamic>;
    localRow.addAll({
      'attempts': 4,
      'correct': 1,
      'assisted': 2,
      'done': [0]
    });
    final remoteRow = (remote['study'] as List).single as Map<String, dynamic>;
    remoteRow.addAll({
      'attempts': 2,
      'correct': 2,
      'assisted': 9,
      'done': [1],
      'skipped': [0],
      'answersRevealed': true
    });
    final merged = AnatomyProgressBackup.merge(local, remote,
        catalog: catalog, currentOwner: 'a');
    final row = (merged['study'] as List).single as Map;
    expect(row['attempts'], 4);
    expect(row['correct'], 2);
    expect(row['assisted'], 9);
    expect(row['done'], [0, 1]);
    expect(row['skipped'], isEmpty);
    expect(row['answersRevealed'], isTrue);
    expect(merged['bookmarks'], hasLength(1));
    expect(
        AnatomyProgressBackup.merge(merged, remote,
            catalog: catalog, currentOwner: 'a'),
        merged);
  });
}
