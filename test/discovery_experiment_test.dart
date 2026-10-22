import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/discovery/presentation/discovery_experiment.dart';

void main() {
  Future<void> pumpExperiment(
    WidgetTester tester, {
    bool warmTrial = false,
    bool coolTrial = false,
    bool enabled = true,
    bool reducedMotion = false,
    double textScale = 1,
    ValueChanged<bool>? onRunTrial,
  }) async {
    await tester.pumpWidget(MaterialApp(
      theme: NorieTheme.dark,
      home: MediaQuery(
        data: MediaQueryData(
          size: tester.view.physicalSize / tester.view.devicePixelRatio,
          textScaler: TextScaler.linear(textScale),
          disableAnimations: reducedMotion,
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: DiscoveryExperiment(
              warmTrial: warmTrial,
              coolTrial: coolTrial,
              enabled: enabled,
              onRunTrial: onRunTrial ?? (_) {},
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  double waterHeight(WidgetTester tester, bool warm) => tester
      .getSize(find.byKey(ValueKey(warm ? 'warm-water' : 'cool-water')))
      .height;

  testWidgets('unrun dishes show equal starting water and no result',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpExperiment(tester);

      expect(waterHeight(tester, true), waterHeight(tester, false));
      expect(find.text('Same starting water level'), findsNWidgets(2));
      expect(find.text('More water evaporated'), findsNothing);
      expect(find.text('Less water evaporated'), findsNothing);
      expect(
        tester.getSemantics(find.byKey(const ValueKey('warm-dish'))).label,
        contains('Trial not run'),
      );
      expect(
          find.widgetWithText(FilledButton, 'Run warm trial'), findsOneWidget);
      expect(
          find.widgetWithText(FilledButton, 'Run cool trial'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('comparison identifies the changed and controlled variables',
      (tester) async {
    await pumpExperiment(tester);

    expect(find.textContaining('Only temperature changes'), findsOneWidget);
    for (final variable in [
      'starting water',
      'exposure to air',
      'exposed surface area',
      'duration',
      'airflow',
      'humidity',
    ]) {
      expect(find.textContaining(variable), findsWidgets);
    }
    expect(find.textContaining('Conceptual illustration'), findsOneWidget);
    expect(find.textContaining('not calibrated'), findsOneWidget);
    expect(find.textContaining('lab measurement'), findsOneWidget);
  });

  testWidgets('a trial requests parent state without revealing its own result',
      (tester) async {
    final trials = <bool>[];
    await pumpExperiment(tester, onRunTrial: trials.add);
    final initialHeight = waterHeight(tester, true);

    await tester.ensureVisible(find.text('Run warm trial'));
    await tester.tap(find.text('Run warm trial'));
    await tester.pumpAndSettle();

    expect(trials, [true]);
    expect(waterHeight(tester, true), initialHeight);
    expect(find.text('More water evaporated'), findsNothing);

    await pumpExperiment(tester, warmTrial: true, onRunTrial: trials.add);
    expect(waterHeight(tester, true), lessThan(initialHeight));
    expect(waterHeight(tester, false), initialHeight);
    expect(find.text('More water evaporated'), findsOneWidget);
    expect(find.text('Less water evaporated'), findsNothing);
  });

  testWidgets('cool trial alone changes only the cool observation',
      (tester) async {
    await pumpExperiment(tester);
    final startingHeight = waterHeight(tester, false);
    await pumpExperiment(tester, coolTrial: true);

    expect(waterHeight(tester, true), startingHeight);
    expect(waterHeight(tester, false), lessThan(startingHeight));
    expect(find.text('More water evaporated'), findsNothing);
    expect(find.text('Less water evaporated'), findsOneWidget);
  });

  testWidgets(
      'both results explain qualitative evaporation without destruction',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpExperiment(tester, warmTrial: true, coolTrial: true);

      expect(waterHeight(tester, true), lessThan(waterHeight(tester, false)));
      expect(find.textContaining('typical otherwise equal conditions'),
          findsOneWidget);
      expect(find.textContaining('invisible water vapor'), findsOneWidget);
      expect(find.textContaining('not destroyed'), findsOneWidget);
      expect(
        tester.getSemantics(find.byKey(const ValueKey('warm-dish'))).label,
        contains('More water evaporated'),
      );
      expect(
        tester.getSemantics(find.byKey(const ValueKey('cool-dish'))).label,
        contains('Less water evaporated'),
      );
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('disabled experiment prevents trial callbacks', (tester) async {
    final trials = <bool>[];
    await pumpExperiment(tester, enabled: false, onRunTrial: trials.add);

    for (final label in ['Run warm trial', 'Run cool trial']) {
      final button = find.widgetWithText(FilledButton, label);
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
    }
    expect(trials, isEmpty);
  });

  testWidgets('keyboard can run warm and cool trials with correct arguments',
      (tester) async {
    final trials = <bool>[];
    await pumpExperiment(tester, onRunTrial: trials.add);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(trials, [true, false]);
  });

  testWidgets('320px and 160 percent text keeps both controls reachable',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final trials = <bool>[];
    await pumpExperiment(tester, textScale: 1.6, onRunTrial: trials.add);

    for (final label in ['Run warm trial', 'Run cool trial']) {
      final button = find.widgetWithText(FilledButton, label);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      expect(tester.getRect(button).left, greaterThanOrEqualTo(0));
      expect(tester.getRect(button).right, lessThanOrEqualTo(320));
      await tester.tap(button);
      await tester.pumpAndSettle();
    }
    expect(trials, [true, false]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop comparison stays within a readable content width',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await pumpExperiment(tester);

    final content = tester
        .getRect(find.byKey(const ValueKey('discovery-experiment-content')));
    expect(content.width, lessThanOrEqualTo(760));
    expect(content.center.dx, closeTo(720, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion preserves trials with no idle animation loop',
      (tester) async {
    final trials = <bool>[];
    await pumpExperiment(tester, reducedMotion: true, onRunTrial: trials.add);

    for (final label in ['Run warm trial', 'Run cool trial']) {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    expect(trials, [true, false]);
    await tester.pump(const Duration(seconds: 10));
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
  });
}
