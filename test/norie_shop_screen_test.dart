import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/commerce/presentation/norie_shop_placeholder_screen.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
  });

  Future<void> open(WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: NorieShopPlaceholderScreen()));
    await tester.pump();
  }

  // Persistence callbacks must originate in the real async zone, matching the
  // app. A widget-test fake zone cannot drain platform preference futures while
  // runAsync is waiting on their write queue.
  Future<void> tapPersisting(WidgetTester tester, Finder target) async {
    await tester.runAsync(() async {
      await tester.tap(target);
    });
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.runAsync(() => NorieProgression.instance
        .flushPendingSaves()
        .timeout(const Duration(seconds: 5)));
  }

  testWidgets('category browse hides unrelated products', (tester) async {
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    expect(find.text('Cyan Orbit Frame'), findsOneWidget);
    expect(find.text('Streak Shield'), findsNothing);
    await finish(tester);
  });

  testWidgets(
      'purchase requires confirmation with exact balance and can cancel',
      (tester) async {
    await tester.runAsync(() async {
      NorieProgression.instance.addCredits(200);
      await NorieProgression.instance.flushPendingSaves();
    });
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('buy-frame-cyan-orbit')), 250);
    await tapPersisting(
        tester, find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    await tester.pump();
    expect(find.text('Balance before: 200 Credits'), findsOneWidget);
    expect(find.text('Balance after: 0 Credits'), findsOneWidget);
    expect(NorieProgression.instance.credits, 200);
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(NorieProgression.instance.credits, 200);
    await finish(tester);
  });

  testWidgets(
      'wallet change while confirming requires fresh review without spending',
      (tester) async {
    final progression = NorieProgression.instance;
    await tester.runAsync(() async {
      progression.addCredits(200);
      await progression.flushPendingSaves();
    });
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('buy-frame-cyan-orbit')), 250);
    await tapPersisting(
        tester, find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    await tester.pump();
    await tester.runAsync(() async {
      progression.addCredits(10);
      await progression.flushPendingSaves();
    });
    await tapPersisting(tester, find.text('Confirm purchase'));
    await tester.pump();
    expect(progression.credits, 210);
    expect(progression.ownsShopItem('frame-cyan-orbit'), isFalse);
    await finish(tester);
  });

  testWidgets(
      'insufficient balance opens useful purchase review without changing wallet',
      (tester) async {
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('buy-frame-cyan-orbit')), 250);
    final button = tester.widget<FilledButton>(
        find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    expect(button.onPressed, isNotNull);
    await tester.tap(find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    await tester.pumpAndSettle();
    expect(find.text('You need 200 more Credits'), findsOneWidget);
    expect(find.text('Explore lessons'), findsOneWidget);
    expect(find.text('Confirm purchase'), findsNothing);
    await tester.tap(find.text('Explore lessons'));
    await tester.pumpAndSettle();
    expect(find.text('Subject World Map'), findsOneWidget);
    expect(NorieProgression.instance.credits, 0);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(NorieProgression.instance.credits, 0);
    await finish(tester);
  });

  testWidgets('preview is temporary and preserves current avatar draft',
      (tester) async {
    final store = NorieProfileAppearanceStore.instance;
    final before = store.exportState();
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('preview-frame-cyan-orbit')), 250);
    await tester.tap(find.byKey(const ValueKey('preview-frame-cyan-orbit')));
    await tester.pump();
    expect(
        find.text('Preview: Cyan Orbit Frame').hitTestable(), findsOneWidget);
    expect(find.text('Preview: Cyan Orbit Frame'), findsOneWidget);
    expect(store.exportState(), before);
    expect(NorieProgression.instance.equippedFrameId, isNull);
    await tester.pumpWidget(const SizedBox());
    await finish(tester);
  });

  testWidgets(
      'exact balance confirmation buys once and owned inventory can unequip',
      (tester) async {
    final progression = NorieProgression.instance;
    await tester.runAsync(() async {
      progression.addCredits(200);
      await progression.flushPendingSaves();
    });
    await open(tester);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('buy-frame-cyan-orbit')), 250);
    await tapPersisting(
        tester, find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    await tester.pump();
    await tapPersisting(tester, find.text('Confirm purchase'));
    await tester.pump();
    expect(progression.credits, 0);
    expect(progression.ownsShopItem('frame-cyan-orbit'), isTrue);
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Owned'), -250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Owned'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('equip-frame-cyan-orbit')), 250);
    await tapPersisting(
        tester, find.byKey(const ValueKey('equip-frame-cyan-orbit')));
    await tester.pump();
    expect(progression.equippedFrameId, 'frame-cyan-orbit');
    await tapPersisting(
        tester, find.byKey(const ValueKey('unequip-frame-cyan-orbit')));
    await tester.pump();
    expect(progression.equippedFrameId, isNull);
    expect(progression.credits, 0);
    await finish(tester);
  });

  testWidgets('320px at 160 percent text keeps shop controls usable',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const NorieShopPlaceholderScreen()));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Frames'), 250);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Frames'));
    await tester.pump();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('preview-frame-cyan-orbit')), 250);
    expect(tester.takeException(), isNull);
    await tester
        .ensureVisible(find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('buy-frame-cyan-orbit')));
    await tester.pumpAndSettle();
    expect(find.text('You need 200 more Credits'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Keep browsing'));
    await tester.pumpAndSettle();
    await finish(tester);
  });
}
