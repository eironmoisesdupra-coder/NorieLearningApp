import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/profile/domain/norie_profile_appearance.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:norie_learning/features/profile/presentation/norie_appearance_studio.dart';

void main() {
  late NorieProfileAppearanceStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = NorieProfileAppearanceStore();
    await store.load();
  });
  tearDown(() => store.dispose());
  Future<void> open(WidgetTester tester, {int level = 5}) async {
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                disableAnimations: true,
                textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: Builder(
            builder: (context) => Scaffold(
                body: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => NorieAppearanceStudio(
                                store: store,
                                level: level,
                                trophyIds: const {'grade:science.g1'}))),
                    child: const Text('Open studio'))))));
    await tester.tap(find.text('Open studio'));
    await tester.pumpAndSettle();
  }

  testWidgets('320px large text preview and cancel keep persisted look',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Comet'), 220);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Comet'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Comet'));
    await tester.pumpAndSettle();
    expect(store.value.avatarId, 'norie');
    await tester.scrollUntilVisible(find.text('Cancel'), 450);
    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(store.value.avatarId, 'norie');
    expect(tester.takeException(), isNull);
  });
  testWidgets('save applies appearance; reset previews until explicitly saved',
      (tester) async {
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Comet'), 220);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Comet'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Comet'));
    await tester.scrollUntilVisible(find.text('Save appearance'), 500);
    await Scrollable.ensureVisible(
        tester.element(find.widgetWithText(FilledButton, 'Save appearance')),
        alignment: .5);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Save appearance').hitTestable(),
        findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Save appearance'));
      await store.flush();
    });
    await tester.pumpAndSettle();
    expect(store.value.avatarId, 'comet');
    await tester.tap(find.text('Open studio'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Reset preview'), 500);
    await tester.ensureVisible(find.text('Reset preview'));
    await tester.tap(find.text('Reset preview'));
    await tester.pumpAndSettle();
    expect(store.value.avatarId, 'comet');
    await Scrollable.ensureVisible(
        tester.element(find.widgetWithText(FilledButton, 'Save appearance')),
        alignment: .5);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Save appearance').hitTestable(),
        findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Save appearance'));
      await store.flush();
    });
    await tester.pumpAndSettle();
    expect(store.value.avatarId, 'norie');
    expect(tester.takeException(), isNull);
  });
  testWidgets('locked cosmetics explain their level and cannot be equipped',
      (tester) async {
    await open(tester, level: 1);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Comet · Level 5'), 220);
    final chip = tester
        .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Comet · Level 5'));
    expect(chip.onSelected, isNull);
    expect(store.value.avatarId, 'norie');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('new studio surfaces preview as a draft and save together',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await open(tester);
    for (final label in ['Glow', 'Star field', 'Explorer ribbon']) {
      final chip = find.widgetWithText(ChoiceChip, label);
      await tester.scrollUntilVisible(chip, 180);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pump();
    }
    await tester.scrollUntilVisible(find.byType(NorieAppearancePreview), -200);
    await tester.pumpAndSettle();
    final preview = tester
        .widget<NorieAppearancePreview>(find.byType(NorieAppearancePreview));
    expect(preview.value.backgroundId, 'stars');
    expect(preview.value.nameplateId, 'curious');
    expect(preview.value.frameEffectId, 'glow');
    expect(store.value.toJson(), const NorieProfileAppearance().toJson());
    await tester.scrollUntilVisible(find.text('Save appearance'), 450);
    await Scrollable.ensureVisible(
        tester.element(find.widgetWithText(FilledButton, 'Save appearance')),
        alignment: .5);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Save appearance').hitTestable(),
        findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Save appearance'));
      await store.flush();
    });
    await tester.pumpAndSettle();
    expect(store.value.toJson(), preview.value.toJson());
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'shared preview renders every surface at 320px with reduced motion',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final bundle in NorieAppearanceCatalog.bundles) {
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
              disableAnimations: true, textScaler: TextScaler.linear(1.6)),
          child: Scaffold(
              body: SingleChildScrollView(
                  child: NorieAppearancePreview(
            value: NorieProfileAppearance(
                nameplateId: bundle.id,
                backgroundId: bundle.level >= 30
                    ? 'constellation'
                    : bundle.level >= 15
                        ? 'aurora'
                        : bundle.level >= 5
                            ? 'stars'
                            : 'plain',
                frameEffectId: bundle.level >= 50
                    ? 'prism'
                    : bundle.level >= 30
                        ? 'orbit'
                        : bundle.level >= 5
                            ? 'glow'
                            : 'none'),
            displayName: 'A learner with a long readable name',
            subtitle: bundle.title,
          ))),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('A learner with a long readable name'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(tester.binding.transientCallbackCount, 0);
    }
  });
}
