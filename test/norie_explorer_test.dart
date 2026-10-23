import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:norie_learning/features/profile/presentation/norie_explorer_avatar.dart';
import 'package:norie_learning/features/profile/domain/norie_explorer_appearance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/profile/domain/norie_profile_appearance.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:norie_learning/features/profile/presentation/norie_appearance_studio.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Explorer choices survive saves, presets and legacy cosmetic imports',
      () async {
    SharedPreferences.setMockInitialValues({});
    final store = NorieProfileAppearanceStore();
    await store.load();
    final legacy = const NorieProfileAppearance(
            avatarId: 'comet', frameId: 'curious', paletteId: 'curious')
        .toJson();
    legacy.remove('explorer');
    final restored = NorieProfileAppearance.fromJson(legacy);
    final customized = NorieProfileAppearance.fromJson({
      ...restored.toJson(),
      'explorer': {
        'skin': 'deep',
        'hair': 'curls',
        'outfit': 'sky',
        'accessory': 'glasses'
      }
    });
    expect(
        await store.save(customized,
            expectedRevision: store.revision, level: 5, presets: [customized]),
        true);
    final reloaded = NorieProfileAppearanceStore();
    await reloaded.load();
    expect(
        reloaded.value.toJson()['explorer'], customized.toJson()['explorer']);
    expect(reloaded.presets.single.toJson()['explorer'],
        customized.toJson()['explorer']);
    expect(reloaded.value.avatarId, 'comet');
    expect(reloaded.value.frameId, 'curious');
    expect(
        NorieProfileAppearanceStore.validateState(
            customized.toJson())['appearance'],
        customized.toJson());
    store.dispose();
    reloaded.dispose();
  });
  testWidgets('reduced motion tap holds one complete pose', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
                body: NorieAppearancePreview(
                    value: NorieProfileAppearance(),
                    displayName: 'Learner',
                    subtitle: 'Profile')))));
    await tester.tap(find.bySemanticsLabel('Your Explorer. Wave hello'));
    await tester.pump();
    expect(
        find.byKey(const ValueKey('explorer-frame-waveOut')), findsOneWidget);
    await tester.pump(const Duration(seconds: 8));
    expect(
        find.byKey(const ValueKey('explorer-frame-waveOut')), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.text('Hello, Explorer!'), findsOneWidget);
  });
  testWidgets('idle blink is brief and wave plays a complete authored sequence',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: NorieExplorerAvatar(appearance: NorieExplorerAppearance()))));
    expect(find.byKey(const ValueKey('explorer-frame-idle')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('explorer-frame-blink')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const ValueKey('explorer-frame-idle')), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Your Explorer. Wave hello'));
    await tester.pump();
    expect(find.byKey(const ValueKey('explorer-frame-ready')), findsOneWidget);
    for (final pose in [
      'rise',
      'waveOut',
      'waveMid',
      'waveIn',
      'waveMid',
      'waveOut',
      'waveMid',
      'waveIn',
      'settle',
      'idle'
    ]) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(ValueKey('explorer-frame-$pose')), findsOneWidget);
    }
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('enabling reduced motion during a wave returns to static idle',
      (tester) async {
    var reduced = false;
    late StateSetter change;
    await tester.pumpWidget(
        MaterialApp(home: StatefulBuilder(builder: (context, setState) {
      change = setState;
      return MediaQuery(
          data: MediaQueryData(disableAnimations: reduced),
          child: const Scaffold(
              body:
                  NorieExplorerAvatar(appearance: NorieExplorerAppearance())));
    })));
    await tester.tap(find.bySemanticsLabel('Your Explorer. Wave hello'));
    await tester.pump(const Duration(milliseconds: 100));
    change(() => reduced = true);
    await tester.pump();
    expect(find.byKey(const ValueKey('explorer-frame-idle')), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(find.byKey(const ValueKey('explorer-frame-idle')), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
  });
  testWidgets(
      'Explorer keyboard activation works before any pointer interaction',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
                body: NorieExplorerAvatar(
                    appearance: NorieExplorerAppearance())))));
    expect(find.text('Hello, Explorer!'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.text('Hello, Explorer!'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('explorer-frame-waveOut')), findsOneWidget);
  });
  testWidgets(
      'offscreen ticker mode and inactive lifecycle suspend frame playback',
      (tester) async {
    Widget avatar(bool enabled) => MaterialApp(
        home: Scaffold(
            body: TickerMode(
                enabled: enabled,
                child: const NorieExplorerAvatar(
                    appearance: NorieExplorerAppearance()))));
    await tester.pumpWidget(avatar(false));
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('explorer-frame-idle')), findsOneWidget);
    await tester.pumpWidget(avatar(true));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('explorer-frame-idle')), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('explorer-frame-blink')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  test('malformed Explorer imports fail before replacing a saved profile',
      () async {
    SharedPreferences.setMockInitialValues({});
    final store = NorieProfileAppearanceStore();
    await store.load();
    final before = store.exportState();
    for (final explorer in [
      <String, dynamic>{'skin': 'unknown'},
      <String, dynamic>{'hair': 7},
      <String, dynamic>{'credential': 'unrecognized'}
    ]) {
      expect(
          () => store
              .replaceState({...store.value.toJson(), 'explorer': explorer}),
          throwsFormatException);
      expect(store.exportState(), before);
    }
    store.dispose();
  });
  testWidgets(
      'Explorer controls keep a draft and save alongside equipped cosmetics',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = NorieProfileAppearanceStore();
    await store.load();
    await tester.runAsync(() => store.save(
        store.value.copyWith(avatarId: 'comet', frameId: 'curious'),
        expectedRevision: store.revision,
        level: 5));
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!),
        home: Builder(
            builder: (context) => Scaffold(
                body: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => NorieAppearanceStudio(
                                store: store, level: 5, trophyIds: const {}))),
                    child: const Text('Edit'))))));
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    for (final key in [
      'explorer-skin tone-deep',
      'explorer-hair-curls',
      'explorer-outfit-sky',
      'explorer-accessory-glasses'
    ]) {
      final chip = find.byKey(ValueKey(key));
      await tester.scrollUntilVisible(chip, 200);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pump();
    }
    expect(store.value.explorer.skin, 'warm');
    await tester.scrollUntilVisible(
        find.text('Keep this look as a preset'), 450);
    await tester.ensureVisible(find.text('Keep this look as a preset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep this look as a preset'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Save appearance'), 450);
    await Scrollable.ensureVisible(
        tester.element(find.widgetWithText(FilledButton, 'Save appearance')),
        alignment: .5);
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.text('Save appearance'));
      await store.flush();
    });
    await tester.pumpAndSettle();
    expect(store.value.explorer.toJson(), {
      'skin': 'deep',
      'hair': 'curls',
      'outfit': 'sky',
      'accessory': 'glasses'
    });
    expect(
        store.presets.single.explorer.toJson(), store.value.explorer.toJson());
    expect(store.value.avatarId, 'comet');
    expect(store.value.frameId, 'curious');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });
  testWidgets(
      'complete frame drawings have different pixels and waving silhouettes',
      (tester) async {
    final rasters = <List<int>>[];
    for (final pose in NorieExplorerPose.values) {
      final key = GlobalKey();
      await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
              child: RepaintBoundary(
                  key: key,
                  child: SizedBox(
                      width: 180,
                      height: 240,
                      child: NorieExplorerIllustration(
                          appearance: const NorieExplorerAppearance(),
                          pose: pose))))));
      final image = (await tester.runAsync(() =>
          (key.currentContext!.findRenderObject()! as RenderRepaintBoundary)
              .toImage()))!;
      final bytes = (await tester.runAsync(
          () => image.toByteData(format: ui.ImageByteFormat.rawRgba)))!;
      rasters.add(bytes.buffer.asUint8List().toList());
      image.dispose();
    }
    for (var i = 0; i < rasters.length; i++) {
      for (var j = i + 1; j < rasters.length; j++) {
        expect(rasters[i], isNot(orderedEquals(rasters[j])),
            reason: 'Every full pose has its own inked artwork');
      }
    }
    // This area is empty in idle and occupied by the raised hand in wave-out.
    int inkInHandRegion(List<int> pixels) {
      var count = 0;
      for (var y = 45; y < 75; y++) {
        for (var x = 140; x < 165; x++) {
          if (pixels[(y * 180 + x) * 4 + 3] > 0) count++;
        }
      }
      return count;
    }

    expect(inkInHandRegion(rasters[0]), 0);
    expect(inkInHandRegion(rasters[3]), greaterThan(200));
  });
  testWidgets('shared profile and studio preview includes separate Explorer',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
                body: NorieAppearancePreview(
                    value: NorieProfileAppearance(),
                    displayName: 'Learner',
                    subtitle: 'Profile')))));
    expect(find.text('Your Explorer'), findsOneWidget);
    expect(find.bySemanticsLabel('Your Explorer. Wave hello'), findsOneWidget);
  });
}
