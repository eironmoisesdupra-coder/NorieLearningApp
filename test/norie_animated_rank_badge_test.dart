import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/assets/norie_assets.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/widgets/norie_animated_rank_badge.dart';
import 'package:norie_learning/features/accessibility/data/norie_accessibility_settings.dart';
import 'package:norie_learning/features/accessibility/presentation/norie_accessibility_scope.dart';

void main() {
  test('all level titles and assets use the canonical progression policy', () {
    for (var level = 1; level <= 55; level++) {
      expect(NorieAnimatedRankBadge.titleForLevel(level),
          NorieLevelSystem.titleForLevel(level));
      expect(NorieAnimatedRankBadge.assetForLevel(level),
          NorieAssets.rankForTitle(NorieLevelSystem.titleForLevel(level)));
    }
    expect(NorieAssets.rankForTitle('Explorer'),
        NorieAnimatedRankBadge.assetForLevel(1));
    expect(NorieAssets.rankForTitle('Curious Mind'),
        NorieAnimatedRankBadge.assetForLevel(5));
    expect(NorieAssets.rankForTitle('Specialist'),
        NorieAnimatedRankBadge.assetForLevel(30));
    expect(NorieAssets.rankForTitle('unrecognized'),
        NorieAnimatedRankBadge.assetForLevel(1));
  });

  testWidgets(
      'crystal and Scholar layers repaint independently and freeze with reduced motion',
      (tester) async {
    Widget app(bool reduced) => MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: const NorieAnimatedRankBadge(level: 30)));
    await tester.pumpWidget(app(false));
    final layers = ['rank-crystal-layer', 'rank-wing-layer', 'rank-book-layer'];
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
    expect(find.bySemanticsLabel('Master rank'), findsOneWidget);
    semantics.dispose();
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });

  testWidgets(
      '48px and 96px crests decode for every rank with OS motion disabled',
      (tester) async {
    for (final size in [48.0, 96.0]) {
      for (final level in [1, 5, 15, 30, 50]) {
        await tester.pumpWidget(MaterialApp(
            home: MediaQuery(
                data: const MediaQueryData(disableAnimations: true),
                child: Center(
                    child: NorieAnimatedRankBadge(level: level, size: size)))));
        final image = tester.widget<Image>(find.byType(Image));
        expect(
            ((image.image as ResizeImage).imageProvider as AssetImage)
                .assetName,
            NorieAnimatedRankBadge.assetForLevel(level));
        await tester.runAsync(() =>
            precacheImage(image.image, tester.element(find.byType(Image))));
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byType(NorieAnimatedRankBadge)),
            Size.square(size));
        expect(tester.binding.transientCallbackCount, 0);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
