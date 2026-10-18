import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/commerce/presentation/subscription_placeholder_screen.dart';

void main() {
  testWidgets('paid plan opens review without granting membership',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: SubscriptionPlaceholderScreen()));
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('plan-plus')), 250);
    await tester.ensureVisible(find.byKey(const ValueKey('plan-plus')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('plan-plus')));
    await tester.pumpAndSettle();
    expect(find.text('Review Norie Plus'), findsOneWidget);
    expect(find.text('Checkout not connected'), findsOneWidget);
    expect(
        find.text('No charge. No subscription has started.'), findsOneWidget);
    await tester.tap(find.text('Keep exploring'));
    await tester.pumpAndSettle();
    expect(find.text('Review Norie Plus'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('membership comparison and help fit a small phone at 160 percent',
      (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.6)),
        child: child!,
      ),
      home: const SubscriptionPlaceholderScreen(),
    ));
    expect(find.text('Billing unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
    for (final label in [
      'Free',
      'Norie Plus',
      'Norie Pro',
      'Norie Family',
      'Monthly renewal',
      'Cancellation help',
      'Refund help',
      'Restore help'
    ]) {
      await tester.scrollUntilVisible(find.text(label), 220,
          scrollable: find.byType(Scrollable).first);
      expect(find.text(label), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.ensureVisible(find.byKey(const ValueKey('plan-family')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('plan-family')));
    await tester.pumpAndSettle();
    expect(find.text('Review Norie Family'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Keep exploring'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Restore help'));
    await tester.tap(find.text('Restore help'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No purchase was restored'), findsOneWidget);
    expect(find.text('Restore purchases'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
