import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/assets/norie_assets.dart';
import 'package:norie_learning/core/mascot/norie_mascot_controller.dart';
import 'package:norie_learning/core/mascot/norie_mascot_expression_painter.dart';
import 'package:norie_learning/core/mascot/norie_mascot_motion.dart';
import 'package:norie_learning/core/mascot/norie_mascot_state.dart';
import 'package:norie_learning/core/mascot/norie_mascot_view.dart';

void main() {
  test('reduced motion keeps mascot translation within four pixels', () {
    for (final state in NorieMascotState.values) {
      final spec = NorieMascotMotionSpec.forState(
        state,
        reduceMotion: true,
      );

      expect(
        spec.translationY.abs(),
        lessThanOrEqualTo(4),
        reason: state.name,
      );
      expect(
        spec.translationX.abs(),
        lessThanOrEqualTo(4),
        reason: state.name,
      );
    }
  });

  testWidgets('idle state renders the base Norie artwork', (tester) async {
    final controller = NorieMascotController();

    await tester.pumpWidget(
      _Host(
        child: NorieMascotView(
          controller: controller,
          reduceMotion: true,
        ),
      ),
    );

    expect(_assetNames(tester), contains(NorieAssets.mascotBase));

    controller.dispose();
  });

  testWidgets('thinking state uses Norie studying artwork', (tester) async {
    final controller = NorieMascotController()..think();

    await tester.pumpWidget(
      _Host(
        child: NorieMascotView(
          controller: controller,
          reduceMotion: true,
        ),
      ),
    );

    expect(_assetNames(tester), contains(NorieAssets.mascotStudying));

    controller.dispose();
  });

  testWidgets('celebrating state uses Norie celebration artwork',
      (tester) async {
    final controller = NorieMascotController()..celebrate();

    await tester.pumpWidget(
      _Host(
        child: NorieMascotView(
          controller: controller,
          reduceMotion: true,
        ),
      ),
    );

    expect(_assetNames(tester), contains(NorieAssets.mascotCelebrating));

    controller.dispose();
  });

  testWidgets('challenge reaction renders an expression overlay',
      (tester) async {
    final controller = NorieMascotController()..challengeMode();

    await tester.pumpWidget(
      _Host(
        child: NorieMascotView(
          controller: controller,
          reduceMotion: true,
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('norie-expression-challenge')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    controller.dispose();
  });


  testWidgets('expression overlay progress advances with mascot motion',
      (tester) async {
    final controller = NorieMascotController()..challengeMode();

    await tester.pumpWidget(
      _Host(
        child: NorieMascotView(
          controller: controller,
          reduceMotion: false,
        ),
      ),
    );

    final before = tester
        .widget<CustomPaint>(
          find.byKey(const ValueKey('norie-expression-challenge')),
        )
        .painter as NorieMascotExpressionPainter;

    await tester.pump(const Duration(milliseconds: 250));

    final after = tester
        .widget<CustomPaint>(
          find.byKey(const ValueKey('norie-expression-challenge')),
        )
        .painter as NorieMascotExpressionPainter;

    expect(after.progress, greaterThan(before.progress));

    controller.dispose();
  });

  testWidgets('state changes preserve a usable mascot widget tree',
      (tester) async {
    final controller = NorieMascotController();

    await tester.pumpWidget(
      _Host(
        child: NorieMascotView(
          controller: controller,
          reduceMotion: false,
        ),
      ),
    );

    controller
      ..correct()
      ..celebrate(level: NorieCelebrationLevel.perfect)
      ..think();

    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(NorieMascotView), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(ErrorWidget), findsNothing);
    expect(tester.takeException(), isNull);

    controller.dispose();
  });
}

List<String> _assetNames(WidgetTester tester) {
  return tester.widgetList<Image>(find.byType(Image)).map((image) {
    final provider = image.image;
    return provider is AssetImage ? provider.assetName : '';
  }).toList();
}

class _Host extends StatelessWidget {
  const _Host({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }
}
