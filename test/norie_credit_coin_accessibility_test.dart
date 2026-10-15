import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/widgets/norie_credit_coin.dart';
import 'package:norie_learning/core/widgets/norie_logo_mark.dart';

void main() {
  testWidgets(
      'coin stops rotation and bob for either motion preference and resumes',
      (tester) async {
    Future<void> show({bool disable = false, bool navigation = false}) =>
        tester.pumpWidget(MaterialApp(
            home: MediaQuery(
                data: MediaQueryData(
                    disableAnimations: disable,
                    accessibleNavigation: navigation),
                child: const Center(child: NorieCreditCoin(size: 60)))));
    List<List<double>> transforms() => tester
        .widgetList<Transform>(find.descendant(
            of: find.byType(NorieCreditCoin), matching: find.byType(Transform)))
        .map((widget) => widget.transform.storage.toList())
        .toList();

    await show();
    await tester.pump(const Duration(milliseconds: 100));
    final animated = transforms();
    await tester.pump(const Duration(seconds: 1));
    expect(transforms(), isNot(animated));
    for (final useNavigation in [false, true]) {
      await show(disable: !useNavigation, navigation: useNavigation);
      final still = transforms();
      await tester.pump(const Duration(milliseconds: 100));
      expect(transforms(), still);
      await tester.pump(const Duration(seconds: 1));
      expect(transforms(), still);
      expect(find.byType(NorieLogoMark), findsOneWidget);
      expect(tester.binding.transientCallbackCount, 0);
    }
    await show();
    await tester.pump(const Duration(milliseconds: 100));
    final resumed = transforms();
    await tester.pump(const Duration(seconds: 1));
    expect(transforms(), isNot(resumed));
  });
}
