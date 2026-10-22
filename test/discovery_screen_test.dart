import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/discovery/data/discovery_store.dart';
import 'package:norie_learning/features/discovery/domain/discovery_mission.dart';
import 'package:norie_learning/features/discovery/presentation/discovery_screen.dart';
import 'package:norie_learning/features/learning/presentation/learn_screen.dart';

void main() {
  Future<void> tap(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<DiscoveryStore> mount(WidgetTester tester,
      {double width = 390,
      double scale = 1,
      ValueNotifier<String?>? owner,
      Map<String, String>? storage}) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final values = storage ?? <String, String>{};
    final store = DiscoveryStore(
        ownerId: () => owner?.value,
        ownerChanges: owner,
        read: (k) async => values[k],
        write: (k, v) async {
          values[k] = v;
        });
    addTearDown(store.dispose);
    await store.initialize();
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: MediaQuery(
            data: MediaQueryData(
                size: Size(width, 844),
                textScaler: TextScaler.linear(scale),
                disableAnimations: true),
            child: DiscoveryScreen(store: store))));
    await tester.pumpAndSettle();
    return store;
  }

  Future<void> prepareExplanation(
      WidgetTester tester, DiscoveryStore store) async {
    for (final c in DiscoveryClue.values) {
      await store.inspect(c);
    }
    await store.continueMission();
    await store.runTrial(warm: true);
    await store.runTrial(warm: false);
    await store.continueMission();
    await tester.pumpAndSettle();
  }

  testWidgets('restart clears all selected explanation and application answers',
      (tester) async {
    final store = await mount(tester);
    await prepareExplanation(tester, store);
    await tap(tester, 'Water evaporated into the air');
    await tap(tester, 'The otherwise equal warm dish lost more water');
    await tap(tester, 'Check explanation');
    await tap(tester, 'Water slowly evaporates into surrounding air');
    await tap(tester, 'Check application');
    await tap(tester, 'Restart investigation');
    await tap(tester, 'Restart case');
    await prepareExplanation(tester, store);
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Check explanation'))
            .onPressed,
        isNull);
    await tap(tester, 'Water evaporated into the air');
    await tap(tester, 'The otherwise equal warm dish lost more water');
    await tap(tester, 'Check explanation');
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Check application'))
            .onPressed,
        isNull);
  });

  testWidgets('hint redisplays after another interaction and saved reload',
      (tester) async {
    final values = <String, String>{};
    await mount(tester, storage: values);
    await tap(tester, 'Ask Norie for a hint');
    await tap(tester, 'Use prop list');
    await tap(tester, 'Inspect warm window');
    await tap(tester, 'Ask Norie for a hint');
    expect(
        find.textContaining('Collect the three observations.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await mount(tester, storage: values);
    await tap(tester, 'Ask Norie for a hint');
    expect(
        find.textContaining('Collect the three observations.'), findsOneWidget);
  });

  testWidgets('stale prop controls cannot act for a new learner',
      (tester) async {
    final owner = ValueNotifier<String?>('A');
    addTearDown(owner.dispose);
    final store = await mount(tester, owner: owner);
    await tap(tester, 'Use prop list');
    final control =
        find.widgetWithText(OutlinedButton, 'Inspect water container');
    final stale = tester.widget<OutlinedButton>(control).onPressed!;
    owner.value = 'B';
    await store.initialize();
    await tester.pumpAndSettle();
    stale();
    await tester.pumpAndSettle();
    expect(store.state.clues, isEmpty);
  });

  testWidgets(
      'list alternative completes the whole evidence-based case and journal',
      (tester) async {
    final store = await mount(tester);
    await tap(tester, 'Use prop list');
    for (final prop in [
      'Inspect water container',
      'Inspect dry tabletop',
      'Inspect warm window'
    ]) {
      await tap(tester, prop);
    }
    expect(store.state.inspectedAll, true);
    await tap(tester, 'Continue to comparison');
    await tap(tester, 'Run warm trial');
    await tap(tester, 'Run cool trial');
    await tap(tester, 'Explain what happened');
    await tap(tester, 'Water evaporated into the air');
    await tap(tester, 'The otherwise equal warm dish lost more water');
    await tap(tester, 'Check explanation');
    expect(store.state.stage, DiscoveryStage.apply);
    expect(find.text('Ask Norie for a hint'), findsNothing);
    await tap(tester, 'Water slowly evaporates into surrounding air');
    await tap(tester, 'Check application');
    expect(store.state.complete, true);
    expect(store.journalEntry, isNotNull);
    expect(
        find.text('Case recorded in your Discovery Journal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      '320px enlarged text keeps gates, notebook and optional dialogue usable',
      (tester) async {
    final store = await mount(tester, width: 320, scale: 1.6);
    await tap(tester, 'Skip dialogue');
    await tap(tester, 'Use prop list');
    final continueButton =
        find.widgetWithText(FilledButton, 'Continue to comparison');
    await tester.ensureVisible(continueButton);
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);
    await tap(tester, 'Inspect evidence notebook');
    expect(store.state.stage, DiscoveryStage.inspect);
    expect(find.text('Evidence notebook'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wrong explanation does not unlock independent application',
      (tester) async {
    final store = await mount(tester);
    for (final c in DiscoveryClue.values) {
      await store.inspect(c);
    }
    await store.continueMission();
    await store.runTrial(warm: true);
    await store.runTrial(warm: false);
    await store.continueMission();
    await tester.pumpAndSettle();
    await tap(tester, 'Water evaporated into the air');
    await tap(tester, 'The dry tabletop alone proves there was no spill');
    await tap(tester, 'Check explanation');
    expect(store.state.stage, DiscoveryStage.conclude);
    expect(store.journalEntry, isNull);
    final feedback = find.textContaining('does not explain all the evidence');
    expect(feedback, findsWidgets);
    final visible = feedback.evaluate().any((e) {
      final box = e.renderObject! as RenderBox;
      final top = box.localToGlobal(Offset.zero).dy;
      return top >= 0 && top + box.size.height <= 844;
    });
    expect(visible, true,
        reason: 'Answer feedback must be visible near the check control');
  });

  testWidgets(
      'Learn Activities opens experimental Discovery without replacing existing activities',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
        MaterialApp(theme: NorieTheme.dark, home: const LearnScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Activities'));
    await tester.pumpAndSettle();
    expect(find.text('3D Anatomy Lab'), findsOneWidget);
    expect(find.text('Seasonal Learning'), findsOneWidget);
    await tap(tester, 'Discovery Adventure');
    expect(find.byType(DiscoveryScreen), findsOneWidget);
    expect(find.textContaining('Experimental'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
