import 'package:norie_learning/core/widgets/norie_animated_rank_badge.dart';
import 'package:norie_learning/features/progress/presentation/progress_screen.dart';
import 'package:norie_learning/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/accessibility/data/norie_accessibility_settings.dart';
import 'package:norie_learning/features/accessibility/presentation/norie_accessibility_scope.dart';
import 'package:norie_learning/features/navigation/presentation/main_shell.dart';

void main() {
  for (final assisted in [false, true]) {
    testWidgets(
        'all main routes fit 320px at 160 percent, all assists $assisted',
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      NorieProgression.instance.resetAsyncQueuesForTesting();
      NorieAdventureProgress.instance.resetAsyncQueuesForTesting();
      await NorieProgression.instance.load();
      NorieAdventureProgress.instance.applyValidatedState(
          NorieAdventureProgress.emptyState,
          persist: false);
      final store = NorieAccessibilitySettings(
          read: () async => null, write: (_) async => true);
      await store.save(NorieAccessibilityProfile(
          textScale: 1.6,
          boldText: assisted,
          highContrast: assisted,
          reducedMotion: assisted,
          readingFocus: assisted));
      await tester.pumpWidget(MaterialApp(
          theme: NorieTheme.dark,
          builder: (context, child) =>
              NorieAccessibilityHost(store: store, child: child!),
          home: const MainShell()));
      await tester.pump();
      expect(tester.takeException(), isNull);
      for (final tab in ['Learn', 'Challenge', 'Progress', 'Profile', 'Home']) {
        await tester.tap(find.text(tab).last);
        await tester.pump(const Duration(seconds: 1));
        for (var step = 0; step < 3; step++) {
          final scroll = find.byWidgetPredicate((widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down);
          if (scroll.evaluate().isEmpty) break;
          await tester.drag(scroll.first, const Offset(0, -500));
          await tester.pump(const Duration(milliseconds: 200));
        }
        expect(tester.takeException(), isNull, reason: tab);
        for (final element in find
            .byType(NorieAnimatedRankBadge, skipOffstage: false)
            .evaluate()) {
          final badge = element.widget as NorieAnimatedRankBadge;
          if (!badge.animate) continue;
          final progress =
              element.findAncestorWidgetOfExactType<ProgressScreen>() != null;
          final profile =
              element.findAncestorWidgetOfExactType<ProfileScreen>() != null;
          expect(TickerMode.valuesOf(element).enabled,
              (progress && tab == 'Progress') || (profile && tab == 'Profile'),
              reason: 'Only the visible tab may animate its rank badge');
        }
      }
      expect(NorieProgression.instance.totalXp, 0);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
