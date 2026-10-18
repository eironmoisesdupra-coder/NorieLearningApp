import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/learning/data/anatomy_atlas_bookmark_store.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_controller.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_tools_sheet.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_tools_state.dart';

AnatomyAtlasCatalog fixture() => AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'Male', 'description': 'Body'},
        {'id': 'female', 'label': 'Female', 'description': 'Body'},
      ],
      'structures': [
        for (final row in [
          [
            'bone',
            'Bone',
            'male',
            ['skeletal']
          ],
          [
            'joint',
            'Joint',
            'male',
            ['skeletal', 'articular']
          ],
          [
            'ligament',
            'Ligament',
            'male',
            ['articular']
          ],
          [
            'other',
            'Other reference',
            'female',
            ['skeletal']
          ],
        ])
          {
            'id': row[0],
            'name': row[1],
            'reference': row[2],
            'systems': row[3],
            'asset': 'model',
            'source': 'fixture',
          }
      ]
    });

void main() {
  test('named camera stays truthful when changing configured systems', () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller)
      ..configure('male', {'skeletal'})
      ..camera('back')
      ..configure('male', {'skeletal', 'articular'});
    expect(tools.cameraView, 'back');
    tools.select('bone', sendCommand: false);
    tools.clearSelection();
    tools.camera('left');
    expect(tools.selectedId, isNull);
  });
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
      'fresh renderer replay preserves layer, hide, selection and comparison snapshot',
      () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller)
      ..configure('male', {'skeletal', 'articular'})
      ..select('bone')
      ..setLayer('skeletal', opacity: .4)
      ..setLayer('articular', visible: false, opacity: .3)
      ..setGlobalOpacity(.6)
      ..hide('ligament')
      ..compare('bone', 'joint')
      ..camera('back');
    final commands = <Map<String, dynamic>>[];
    controller.addListener(() => commands.add({
          'type': controller.lastCommand!['type'],
          'payload': controller.lastCommand!['payload'],
        }));
    var changes = 0;
    tools.addListener(() => changes++);
    tools.replayToRenderer();
    expect(commands, [
      {
        'type': 'select',
        'payload': {'id': 'bone'}
      },
      {
        'type': 'systemLayer',
        'payload': {'system': 'skeletal', 'opacity': .4}
      },
      {
        'type': 'systemLayer',
        'payload': {'system': 'articular', 'visible': false, 'opacity': .3}
      },
      {
        'type': 'opacity',
        'payload': {'value': .6}
      },
      {
        'type': 'hide',
        'payload': {'id': 'ligament'}
      },
      {
        'type': 'compare',
        'payload': {
          'ids': ['bone', 'joint']
        }
      },
      {
        'type': 'camera',
        'payload': {'view': 'back'}
      },
    ]);
    expect(changes, 0);
    expect(tools.selectedId, 'bone');
    expect(tools.visibleIds, {'bone', 'joint'});
    expect(tools.compareIds, ['bone', 'joint']);
    expect(tools.globalOpacity, .6);
    expect(tools.layerVisible('articular'), isFalse);
    expect(tools.layerOpacity('skeletal'), .4);
  });

  test('fresh renderer replay keeps a hidden isolated part hidden', () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller)
      ..configure('male', {'skeletal'})
      ..isolate('bone')
      ..hide('bone');
    final commands = <Map<String, dynamic>>[];
    controller.addListener(() => commands.add({
          'type': controller.lastCommand!['type'],
          'payload': controller.lastCommand!['payload'],
        }));
    tools.replayToRenderer();
    expect(commands, [
      {
        'type': 'isolate',
        'payload': {'id': 'bone'}
      },
      {
        'type': 'opacity',
        'payload': {'value': 1.0}
      },
      {
        'type': 'hide',
        'payload': {'id': 'bone'}
      },
      {
        'type': 'compare',
        'payload': {'ids': <String>[]}
      },
      {
        'type': 'camera',
        'payload': {'view': 'reset'}
      },
    ]);
    expect(tools.visibleIds, isEmpty);
    expect(tools.selectedId, isNull);
    expect(tools.isolatedId, 'bone');
  });

  test(
      'reference reset prevents replay of prior-reference layer and part commands',
      () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller)
      ..configure('male', {'skeletal', 'articular'})
      ..setLayer('skeletal', visible: false)
      ..setGlobalOpacity(.35)
      ..hide('ligament')
      ..isolate('joint')
      ..camera('back')
      ..configure('female', {'skeletal'});
    final commands = <Map<String, dynamic>>[];
    controller.addListener(() => commands.add({
          'type': controller.lastCommand!['type'],
          'payload': controller.lastCommand!['payload'],
        }));
    tools.replayToRenderer();
    expect(commands, [
      {
        'type': 'opacity',
        'payload': {'value': 1.0}
      },
      {
        'type': 'compare',
        'payload': {'ids': <String>[]}
      },
      {
        'type': 'camera',
        'payload': {'view': 'back'}
      },
    ]);
    expect(tools.visibleIds, {'other'});
    expect(tools.selectedId, isNull);
    expect(tools.compareIds, isEmpty);
  });

  test(
      'replay applies isolation before a layer override that would reject isolate',
      () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller)
      ..configure('male', {'skeletal', 'articular'})
      ..isolate('bone')
      ..setLayer('skeletal', visible: false);
    final commands = <Map<String, dynamic>>[];
    controller.addListener(() => commands.add({
          'type': controller.lastCommand!['type'],
          'payload': controller.lastCommand!['payload'],
        }));
    tools.replayToRenderer();
    expect(commands, [
      {
        'type': 'isolate',
        'payload': {'id': 'bone'}
      },
      {
        'type': 'systemLayer',
        'payload': {'system': 'skeletal', 'visible': false}
      },
      {
        'type': 'opacity',
        'payload': {'value': 1.0}
      },
      {
        'type': 'compare',
        'payload': {'ids': <String>[]}
      },
      {
        'type': 'camera',
        'payload': {'view': 'reset'}
      },
    ]);
    expect(tools.visibleIds, isEmpty);
    expect(tools.isolatedId, 'bone');
    expect(tools.selectedId, isNull);
  });

  test('layer composition keeps shared anatomy visible and prunes comparison',
      () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller);
    tools.configure('male', {'skeletal', 'articular'});
    expect(tools.compare('bone', 'joint'), isTrue);
    tools.setLayer('skeletal', opacity: .4);
    tools.setGlobalOpacity(.5);
    expect(tools.effectiveOpacity('bone'), .2);
    expect(tools.effectiveOpacity('joint'), .5);
    tools.setLayer('skeletal', visible: false);
    expect(tools.visibleIds, {'joint', 'ligament'});
    expect(tools.compareIds, isEmpty);
    expect(tools.compare('joint', 'other'), isFalse);
    expect(tools.compare('joint', 'joint'), isFalse);
    tools.restore();
    expect(tools.globalOpacity, 1);
    expect(tools.layerOpacity('skeletal'), 1);
    expect(tools.layerVisible('skeletal'), isTrue);
    expect(controller.lastCommand?['type'], 'restore');
  });

  test('tools reject invalid layer values and follow hide, select and isolate',
      () {
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(fixture(), controller);
    tools.configure('male', {'skeletal', 'articular'});
    expect(tools.setLayer('missing', visible: false), isFalse);
    expect(tools.setLayer('skeletal', opacity: double.nan), isFalse);
    expect(tools.setLayer('skeletal', opacity: 1.1), isFalse);
    expect(tools.setGlobalOpacity(.1), isFalse);
    expect(tools.compare('bone', 'joint'), isTrue);
    tools.hide('joint');
    expect(tools.visibleIds, {'bone', 'ligament'});
    expect(tools.compareIds, isEmpty);
    tools.select('joint');
    expect(tools.visibleIds, {'bone', 'joint', 'ligament'});
    tools.isolate('bone');
    expect(tools.visibleIds, {'bone'});
    tools.configure('female', {'skeletal'});
    expect(tools.visibleIds, {'other'});
    expect(tools.camera('freeform'), isFalse);
    expect(tools.camera('back'), isTrue);
    expect(controller.lastCommand?['payload'], {'view': 'back'});
  });

  test(
      'bookmarks deduplicate by reference, structure and named view and isolate owners',
      () async {
    final catalog = fixture();
    final a = AnatomyAtlasBookmarkStore('learner-a', catalog);
    await a.load();
    expect(await a.save(reference: 'male', structureId: 'bone', view: 'front'),
        isTrue);
    expect(await a.save(reference: 'male', structureId: 'bone', view: 'front'),
        isTrue);
    expect(await a.save(reference: 'male', structureId: 'bone', view: 'back'),
        isTrue);
    expect(a.bookmarks.length, 2);
    final b = AnatomyAtlasBookmarkStore('learner-b', catalog);
    await b.load();
    expect(b.bookmarks, isEmpty);
    final fresh = AnatomyAtlasBookmarkStore('learner-a', catalog);
    await fresh.load();
    expect(fresh.bookmarks.map((b) => b.view), ['front', 'back']);
    expect(
        () =>
            fresh.save(reference: 'female', structureId: 'bone', view: 'front'),
        throwsFormatException);
    expect(
        () => fresh.save(
            reference: 'male', structureId: 'bone', view: 'arbitrary'),
        throwsFormatException);
    final exported = jsonDecode(fresh.exportJson()) as Map;
    expect(exported['owner'], 'learner-a');
    expect((exported['bookmarks'] as List).first, {
      'reference': 'male',
      'structureId': 'bone',
      'view': 'front',
    });
    expect(await fresh.delete(fresh.bookmarks.first), isTrue);
    expect(fresh.bookmarks.single.view, 'back');
    expect(await fresh.reset(), isTrue);
    final empty = AnatomyAtlasBookmarkStore('learner-a', catalog);
    await empty.load();
    expect(empty.bookmarks, isEmpty);
  });

  test('failed durable writes keep prior bookmarks and cannot claim success',
      () async {
    var fail = false;
    String? persisted;
    final store = AnatomyAtlasBookmarkStore('durability', fixture(),
        read: (_) async => persisted,
        write: (_, value) async {
          if (fail) return false;
          persisted = value;
          return true;
        });
    await store.load();
    await store.save(reference: 'male', structureId: 'bone', view: 'front');
    fail = true;
    await expectLater(store.reset(), throwsStateError);
    expect(store.bookmarks.single.structureId, 'bone');
    expect((jsonDecode(persisted!)['bookmarks'] as List).length, 1);
  });

  test('owner change during load prevents stale hydration', () async {
    var current = true;
    final gate = Completer<String?>();
    final store = AnatomyAtlasBookmarkStore('load-race', fixture(),
        stillCurrent: () => current, read: (_) => gate.future);
    final loading = store.load();
    current = false;
    gate.complete(jsonEncode({
      'version': 1,
      'owner': 'load-race',
      'bookmarks': [
        {'reference': 'male', 'structureId': 'bone', 'view': 'front'}
      ]
    }));
    await loading;
    expect(store.bookmarks, isEmpty);
    expect(store.loaded, isFalse);
  });

  test('owner change during save rolls back the stale write', () async {
    var current = true;
    String? persisted;
    final gate = Completer<bool>();
    var writes = 0;
    final store = AnatomyAtlasBookmarkStore('save-race', fixture(),
        stillCurrent: () => current,
        read: (_) async => persisted,
        write: (_, value) async {
          persisted = value;
          if (++writes == 1) return gate.future;
          return true;
        });
    await store.load();
    final saving =
        store.save(reference: 'male', structureId: 'bone', view: 'front');
    await Future<void>.delayed(Duration.zero);
    current = false;
    gate.complete(true);
    expect(await saving, isFalse);
    expect(store.bookmarks, isEmpty);
    expect((jsonDecode(persisted!)['bookmarks'] as List), isEmpty);
  });

  test('malformed persisted camera transforms are rejected without overwrite',
      () async {
    final raw = jsonEncode({
      'version': 1,
      'owner': 'invalid',
      'bookmarks': [
        {
          'reference': 'male',
          'structureId': 'bone',
          'view': {'x': 900}
        },
      ]
    });
    final store =
        AnatomyAtlasBookmarkStore('invalid', fixture(), read: (_) async => raw);
    await expectLater(store.load(), throwsFormatException);
    expect(store.loaded, isFalse);
  });

  test(
      'reference bookmark limit rejects additional views without evicting saved work',
      () async {
    final catalog = AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'Male', 'description': 'Body'}
      ],
      'structures': [
        for (var i = 0; i < 33; i++)
          {
            'id': 'part-$i',
            'name': 'Part $i',
            'reference': 'male',
            'systems': ['skeletal'],
            'asset': 'model',
            'source': 'fixture',
          }
      ],
    });
    final store = AnatomyAtlasBookmarkStore('bounds', catalog);
    await store.load();
    for (var i = 0; i < 32; i++) {
      await store.save(
          reference: 'male', structureId: 'part-$i', view: 'front');
    }
    await expectLater(
        store.save(reference: 'male', structureId: 'part-32', view: 'front'),
        throwsStateError);
    expect(store.bookmarks.length, 32);
    final fresh = AnatomyAtlasBookmarkStore('bounds', catalog);
    await fresh.load();
    expect(fresh.bookmarks.first.structureId, 'part-0');
    expect(fresh.bookmarks.last.structureId, 'part-31');
  });

  testWidgets('tools sheet remains scrollable on a small phone with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final catalog = fixture();
    final tools = AnatomyAtlasToolsState(catalog, AnatomyAtlasController())
      ..configure('male', {'skeletal', 'articular'});
    final store = AnatomyAtlasBookmarkStore('phone', catalog);
    await store.load();
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(
                size: Size(320, 568), textScaler: TextScaler.linear(1.6)),
            child: Scaffold(
                body: AnatomyAtlasToolsSheet(
              state: tools,
              bookmarks: store,
              selectedId: 'bone',
              onOpenBookmark: (_) async {},
              onExport: (_) async {},
            )))));
    expect(find.text('Explorer tools'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Save current view'), 180);
    await tester.pumpAndSettle();
    expect(find.text('Save current view').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Save current view'));
    await tester.pumpAndSettle();
    expect(store.bookmarks.single.structureId, 'bone');
    expect(tester.takeException(), isNull);
  });

  testWidgets('owner replacement cannot show stale export success',
      (tester) async {
    final catalog = fixture();
    final tools = AnatomyAtlasToolsState(catalog, AnatomyAtlasController())
      ..configure('male', {'skeletal'});
    var current = true;
    final first = AnatomyAtlasBookmarkStore('first-sheet-owner', catalog,
        stillCurrent: () => current);
    final second = AnatomyAtlasBookmarkStore('second-sheet-owner', catalog);
    await first.load();
    await second.load();
    final gate = Completer<void>();
    Widget app(AnatomyAtlasBookmarkStore store) => MaterialApp(
            home: Scaffold(
                body: AnatomyAtlasToolsSheet(
          state: tools,
          bookmarks: store,
          selectedId: 'bone',
          onOpenBookmark: (_) async {},
          onExport: (_) => gate.future,
        )));
    await tester.pumpWidget(app(first));
    final exportButton = find.ancestor(
        of: find.text('Export saved views JSON'),
        matching: find.byWidgetPredicate((widget) => widget is TextButton));
    await tester.scrollUntilVisible(exportButton, 180);
    await tester.pumpAndSettle();
    expect(exportButton.hitTestable(), findsOneWidget);
    await tester.tap(exportButton);
    await tester.pump();
    expect(tester.widget<TextButton>(exportButton).onPressed, isNull);
    current = false;
    await tester.pumpWidget(app(second));
    gate.complete();
    await tester.pumpAndSettle();
    final feedback = find.byKey(const ValueKey('atlas-bookmark-feedback'));
    await tester.scrollUntilVisible(feedback, -180);
    await tester.pumpAndSettle();
    expect(feedback.hitTestable(), findsOneWidget);
    expect(find.text('Saved views exported.'), findsNothing);
    expect(find.text('Learner changed. Close and reopen Explorer tools.'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('global opacity slider emits a supported Explorer preset',
      (tester) async {
    final catalog = fixture();
    final controller = AnatomyAtlasController();
    final tools = AnatomyAtlasToolsState(catalog, controller)
      ..configure('male', {'skeletal'});
    final store = AnatomyAtlasBookmarkStore('opacity-preset', catalog);
    await store.load();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: AnatomyAtlasToolsSheet(
      state: tools,
      bookmarks: store,
      selectedId: 'bone',
      onOpenBookmark: (_) async {},
      onExport: (_) async {},
    ))));
    final slider = find.byType(Slider);
    await tester.scrollUntilVisible(slider, 180);
    await tester.pumpAndSettle();
    final rect = tester.getRect(slider);
    await tester.tapAt(Offset(rect.left + rect.width * .6, rect.center.dy));
    await tester.pump();
    expect(tools.globalOpacity, .6);
    expect(controller.lastCommand?['type'], 'opacity');
    expect(controller.lastCommand?['payload'], {'value': .6});
    expect(tester.takeException(), isNull);
  });
}
