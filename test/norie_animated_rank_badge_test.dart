import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/assets/norie_assets.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/widgets/norie_animated_rank_badge.dart';
import 'package:norie_learning/core/widgets/norie_rank_illustration.dart';
import 'package:norie_learning/features/accessibility/data/norie_accessibility_settings.dart';
import 'package:norie_learning/features/accessibility/presentation/norie_accessibility_scope.dart';

void main() {
  testWidgets('each rank shows its educational silhouette at both boundaries',
      (tester) async {
    final rasters = <String>{};
    for (final entry in {
      1: NorieRankIllustration.pencil,
      4: NorieRankIllustration.pencil,
      5: NorieRankIllustration.compass,
      14: NorieRankIllustration.compass,
      15: NorieRankIllustration.book,
      29: NorieRankIllustration.book,
      30: NorieRankIllustration.science,
      49: NorieRankIllustration.science,
      50: NorieRankIllustration.graduation,
      55: NorieRankIllustration.graduation,
    }.entries) {
      await tester.pumpWidget(MaterialApp(
          home: NorieAnimatedRankBadge(level: entry.key, animate: false)));
      final painter = tester
          .widget<CustomPaint>(
              find.byKey(const ValueKey('rank-illustration-layer')))
          .painter! as NorieRankIllustrationPainter;
      expect(painter.illustration, entry.value);
      final recorder = ui.PictureRecorder();
      painter.paint(Canvas(recorder), const Size(48, 48));
      final picture = recorder.endRecording();
      await tester.runAsync(() async {
        final image = await picture.toImage(48, 48);
        final bytes =
            await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final rgba = bytes!.buffer.asUint8List();
        expect(rgba.any((value) => value > 0), isTrue);
        rasters.add(base64Encode(rgba));
        image.dispose();
      });
      picture.dispose();
    }
    expect(rasters.length, 5,
        reason: 'Each rank needs a distinct readable silhouette at 48px');
  });

  test('all level titles and assets use the canonical progression policy', () {
    for (var level = 1; level <= 55; level++) {
      expect(NorieAnimatedRankBadge.titleForLevel(level),
          NorieLevelSystem.titleForLevel(level));
      expect(NorieAnimatedRankBadge.assetForLevel(level),
          NorieAssets.rankForTitle(NorieLevelSystem.titleForLevel(level)));
    }
    expect(NorieAssets.rankForTitle('Explorer'),
        NorieAnimatedRankBadge.assetForLevel(5));
    expect(NorieAssets.rankExplorer, 'assets/ranking/norie_rookie.png');
    expect(NorieAssets.rankForTitle('Curious Mind'),
        NorieAnimatedRankBadge.assetForLevel(5));
    expect(NorieAssets.rankForTitle('Specialist'),
        NorieAnimatedRankBadge.assetForLevel(30));
    expect(
        NorieAssets.rankForTitle('Novice'), 'assets/ranking/norie_novice.png');
    expect(NorieAssets.rankForTitle('Veteran'),
        'assets/ranking/norie_veteran.png');
    expect(
        NorieAssets.rankForTitle('Master'), 'assets/ranking/norie_master.png');
    expect(NorieAssets.rankForTitle('Scholar'),
        'assets/ranking/norie_veteran.png');
    expect(NorieAnimatedRankBadge.assetForLevel(30),
        'assets/ranking/norie_scholar.png');
    expect(NorieAssets.rankForTitle('unrecognized'),
        NorieAnimatedRankBadge.assetForLevel(1));
  });

  testWidgets(
      'educational art and aura animate independently and freeze with reduced motion',
      (tester) async {
    Widget app(bool reduced) => MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: const NorieAnimatedRankBadge(level: 30)));
    await tester.pumpWidget(app(false));
    final layers = ['rank-illustration-layer', 'rank-aura-layer'];
    final before = <String, CustomPainter>{};
    for (final key in layers) {
      before[key] =
          tester.widget<CustomPaint>(find.byKey(ValueKey(key))).painter!;
    }
    await tester.pump(const Duration(milliseconds: 350));
    for (final key in layers) {
      final after =
          tester.widget<CustomPaint>(find.byKey(ValueKey(key))).painter!;
      expect(after.shouldRepaint(before[key]!), isTrue,
          reason: '$key must animate');
    }
    await tester.pumpWidget(app(true));
    final frozen = <String, CustomPainter>{
      for (final key in layers)
        key: tester.widget<CustomPaint>(find.byKey(ValueKey(key))).painter!,
    };
    await tester.pump(const Duration(milliseconds: 350));
    for (final key in layers) {
      expect(tester.widget<CustomPaint>(find.byKey(ValueKey(key))).painter,
          same(frozen[key]),
          reason: '$key must remain frozen');
    }
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('native animation moves, stops off-route, and restarts safely',
      (tester) async {
    Widget app(bool enabled, bool animate) => MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(
                disableAnimations: false, accessibleNavigation: false),
            child: TickerMode(
                enabled: enabled,
                child: NorieAnimatedRankBadge(level: 50, animate: animate))));
    await tester.pumpWidget(app(true, true));
    final transform = find.descendant(
        of: find.byType(NorieAnimatedRankBadge),
        matching: find.byType(Transform));
    final initial = tester.widget<Transform>(transform.first).transform.clone();
    await tester.pump(const Duration(milliseconds: 450));
    expect(tester.widget<Transform>(transform.first).transform, isNot(initial));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpWidget(app(false, true));
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(app(true, true));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpWidget(app(true, false));
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'app reduced motion updates a mounted badge without queued frames',
      (tester) async {
    final store = NorieAccessibilitySettings(
        read: () async => null, write: (_) async => true);
    await store.load();
    await tester.pumpWidget(MaterialApp(
        home: NorieAccessibilityHost(
            store: store, child: const NorieAnimatedRankBadge(level: 50))));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await store.save(const NorieAccessibilityProfile(reducedMotion: true));
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Professor rank'), findsOneWidget);
    semantics.dispose();
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });

  testWidgets('48px and 96px educational badges render with OS motion disabled',
      (tester) async {
    for (final size in [48.0, 96.0]) {
      for (final level in [1, 5, 15, 30, 50]) {
        await tester.pumpWidget(MaterialApp(
            home: MediaQuery(
                data: const MediaQueryData(disableAnimations: true),
                child: Center(
                    child: NorieAnimatedRankBadge(level: level, size: size)))));
        expect(find.byType(Image), findsNothing,
            reason: 'Main rank art must remain code-native and offline');
        expect(find.byKey(const ValueKey('rank-illustration-layer')),
            findsOneWidget);
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byType(NorieAnimatedRankBadge)),
            Size.square(size));
        expect(tester.binding.transientCallbackCount, 0);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
