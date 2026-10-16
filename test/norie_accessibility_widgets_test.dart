import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/mascot/norie_mascot_host.dart';
import 'package:norie_learning/core/mascot/norie_mascot_scope.dart';
import 'package:norie_learning/core/mascot/norie_mascot_view.dart';
import 'package:norie_learning/core/mascot/help/norie_help_sheet.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/core/widgets/norie_ambient_backdrop.dart';
import 'package:norie_learning/features/accessibility/data/norie_accessibility_settings.dart';
import 'package:norie_learning/features/accessibility/presentation/norie_accessibility_scope.dart';
import 'package:norie_learning/features/accessibility/presentation/norie_accessibility_screen.dart';

class _NonlinearScaler extends TextScaler {
  const _NonlinearScaler();
  @override
  double scale(double size) => size + size * size / 100;
  @override
  double get textScaleFactor => 1.2;
}

void main() {
  testWidgets(
      'reading focus hides floating reactions but preserves explicit help',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = NorieAccessibilitySettings(
        read: () async => null, write: (_) async => true);
    await store.save(const NorieAccessibilityProfile(readingFocus: true));
    await tester.pumpWidget(MaterialApp(
        home: NorieAccessibilityHost(
            store: store,
            child:
                const NorieMascotHost(child: Scaffold(body: Text('Lesson'))))));
    final scope = NorieMascotScope.of(tester.element(find.text('Lesson')));
    scope.controller.think();
    await tester.pump();
    expect(find.byType(NorieMascotView), findsNothing);
    scope.showAssistant();
    await tester.pump();
    expect(find.byType(NorieMascotView), findsOneWidget);
    expect(find.byType(NorieHelpSheet), findsOneWidget);
    scope.hideAssistant();
    await tester.pump();
    expect(find.byType(NorieHelpSheet), findsNothing);
    await store.reset();
    await tester.pump();
    scope.controller.think();
    await tester.pump();
    expect(find.byType(NorieMascotView), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'OS bold text and high contrast apply with default device settings',
      (tester) async {
    final store = NorieAccessibilitySettings(
        read: () async => null, write: (_) async => true);
    late ThemeData theme;
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
      data: const MediaQueryData(boldText: true, highContrast: true),
      child: NorieAccessibilityHost(
          store: store,
          child: Builder(builder: (context) {
            theme = Theme.of(context);
            return const Text('Lesson example');
          })),
    )));
    final rich = tester.widget<RichText>(find.byType(RichText));
    expect((rich.text as TextSpan).style!.fontWeight, FontWeight.bold);
    expect(theme.colorScheme.outline, Colors.white);
  });
  testWidgets('preferences compose with OS nonlinear scale and accessibility',
      (tester) async {
    final store = NorieAccessibilitySettings(
        read: () async => null, write: (_) async => true);
    await store.save(const NorieAccessibilityProfile(textScale: 1.5));
    late MediaQueryData observed;
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
      data: const MediaQueryData(
          textScaler: _NonlinearScaler(),
          boldText: true,
          disableAnimations: true,
          accessibleNavigation: true,
          highContrast: true),
      child: NorieAccessibilityHost(
          store: store,
          child: Builder(builder: (context) {
            observed = MediaQuery.of(context);
            return const SizedBox();
          })),
    )));
    expect(observed.textScaler.scale(10), 16.5);
    expect(observed.textScaler.scale(20), 36);
    expect(observed.boldText, isTrue);
    expect(observed.disableAnimations, isTrue);
    expect(observed.accessibleNavigation, isTrue);
    expect(observed.highContrast, isTrue);
  });

  testWidgets(
      'user controls change media, visible theme and decorative effects',
      (tester) async {
    final store = NorieAccessibilitySettings(
        read: () async => null, write: (_) async => true);
    late MediaQueryData media;
    late ThemeData theme;
    late bool focus;
    await tester.pumpWidget(MaterialApp(
      theme: NorieTheme.dark,
      home: NorieAccessibilityHost(
          store: store,
          child: Builder(builder: (context) {
            media = MediaQuery.of(context);
            theme = Theme.of(context);
            focus = NorieAccessibilityScope.readingFocusOf(context);
            return const NorieAmbientBackdrop();
          })),
    ));
    final original = theme.colorScheme.primary;
    await store.save(const NorieAccessibilityProfile(
        boldText: true,
        reducedMotion: true,
        highContrast: true,
        readingFocus: true));
    await tester.pump();
    expect(media.boldText, isTrue);
    expect(media.disableAnimations, isTrue);
    expect(media.accessibleNavigation, isTrue);
    expect(focus, isTrue);
    expect(theme.colorScheme.primary, isNot(original));
    expect(theme.colorScheme.onPrimary, const Color(0xFF071126));
    expect(theme.colorScheme.outline, Colors.white);
    expect(find.byType(Stack), findsNothing);
    await store.reset();
    await tester.pump();
    expect(media.disableAnimations, isFalse);
    expect(focus, isFalse);
    expect(find.byType(Stack), findsOneWidget);
  });

  testWidgets('320px settings at 160% remain scrollable and show save failure',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = NorieAccessibilitySettings(
        read: () async => null, write: (_) async => false);
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
      child: NorieAccessibilityScreen(store: store),
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('shared on this device'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Bolder text'), 180,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bolder text'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bolder text'));
    await tester.scrollUntilVisible(
        find.text('Save accessibility settings'), 180,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save accessibility settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save accessibility settings'));
    await tester.pumpAndSettle();
    expect(find.text('Could not save accessibility settings. Try again.'),
        findsOneWidget);
    expect(store.value.boldText, isFalse);
    expect(find.byType(NorieAccessibilityScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
