import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
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
    await tester.ensureVisible(find.text('Save appearance'));
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
    await tester.ensureVisible(find.text('Save appearance'));
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
}
