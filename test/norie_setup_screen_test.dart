import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/release/norie_setup_screen.dart';

void main() {
  testWidgets(
      'preview setup stays honest and readable at 320px with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const NorieSetupScreen()));
    expect(find.text('Preview configuration'), findsOneWidget);
    for (final title in [
      'Offline Classroom',
      'Cloud Classroom',
      'Paid memberships',
      'Store release'
    ]) {
      await tester.scrollUntilVisible(find.text(title), 180,
          scrollable: find.byType(Scrollable).first);
      expect(tester.takeException(), isNull);
    }
    expect(find.textContaining('Not certified'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Activate payments'), findsNothing);
  });
}
