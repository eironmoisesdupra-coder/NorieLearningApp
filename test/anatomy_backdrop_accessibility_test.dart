import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/accessibility/presentation/norie_accessibility_scope.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_animated_backdrop.dart';

void main() {
  testWidgets(
      'anatomy decoration stops for motion preferences and hides for reading focus',
      (tester) async {
    Future<void> show(
            {bool disable = false,
            bool navigation = false,
            bool focus = false}) =>
        tester.pumpWidget(MaterialApp(
            home: MediaQuery(
                data: MediaQueryData(
                    disableAnimations: disable,
                    accessibleNavigation: navigation),
                child: NorieAccessibilityScope(
                    readingFocus: focus,
                    child: const AnatomyAnimatedBackdrop()))));
    CustomPainter painter() => tester
        .widget<CustomPaint>(find.descendant(
            of: find.byType(AnatomyAnimatedBackdrop),
            matching: find.byType(CustomPaint)))
        .painter!;
    await show();
    await tester.pump(const Duration(milliseconds: 100));
    final animated = painter();
    await tester.pump(const Duration(seconds: 1));
    expect(identical(painter(), animated), isFalse);
    for (final navigation in [false, true]) {
      await show(disable: !navigation, navigation: navigation);
      final still = painter();
      await tester.pump(const Duration(seconds: 1));
      expect(identical(painter(), still), isTrue);
      expect(tester.binding.transientCallbackCount, 0);
    }
    await show(focus: true);
    expect(
        find.descendant(
            of: find.byType(AnatomyAnimatedBackdrop),
            matching: find.byType(CustomPaint)),
        findsNothing);
    expect(tester.binding.transientCallbackCount, 0);
    await show();
    await tester.pump(const Duration(milliseconds: 100));
    final resumed = painter();
    await tester.pump(const Duration(seconds: 1));
    expect(identical(painter(), resumed), isFalse);
  });
}
