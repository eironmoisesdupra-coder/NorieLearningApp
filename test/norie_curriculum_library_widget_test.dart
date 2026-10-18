import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/curriculum/presentation/norie_curriculum_library_screen.dart';

void main() {
  testWidgets('offline library filters and opens a local studio at phone width',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const NorieCurriculumLibraryScreen(ownerId: 'local-test')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('curriculum-search')), 'Atomic Structure');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byKey(const Key('curriculum-topic-science.chemistry.atomic-structure')), 180,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.byKey(const Key('curriculum-topic-science.chemistry.atomic-structure')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('curriculum-topic-science.chemistry.atomic-structure')).hitTestable(), findsOneWidget);
    await tester.tap(find.byTooltip('Local studio'));
    await tester.pumpAndSettle();
    expect(find.text('Curriculum Studio'), findsOneWidget);
    expect(find.textContaining('Local drafts'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
