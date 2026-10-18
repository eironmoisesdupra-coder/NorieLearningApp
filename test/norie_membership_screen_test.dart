import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/commerce/presentation/subscription_placeholder_screen.dart';

void main() {
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
    await tester.tap(find.text('Restore help'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No purchase was restored'), findsOneWidget);
    expect(find.text('Restore purchases'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
