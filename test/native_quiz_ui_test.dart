import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/study/presentation/study_generator_screen.dart';
import 'package:norie_learning/features/study/presentation/native_quiz_generator_screen.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';

Future<void> settleAsync(WidgetTester tester) async {
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
  }
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.load();
  });
  testWidgets(
      'existing source generator offers free offline entry without replacing notes',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: StudyGeneratorScreen()));
    expect(find.text('Source material'), findsOneWidget);
    await tester.tap(find.text('Native Engine · Free offline practice'));
    await tester.pumpAndSettle();
    expect(find.text('Available offline · No AI allowance or Credits required'),
        findsOneWidget);
    await tester.scrollUntilVisible(find.text('Generate Native Quiz'), 300);
    expect(find.text('Generate Native Quiz'), findsOneWidget);
  });
  testWidgets(
      'native generator creates 20 questions on a small large-text reduced-motion screen',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final before = NorieProgression.instance.credits;
    await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
            data: MediaQueryData(
                textScaler: TextScaler.linear(1.6), disableAnimations: true),
            child: NativeQuizGeneratorScreen())));
    final count = find.text('20', skipOffstage: false);
    await tester.scrollUntilVisible(count, 250);
    await tester.ensureVisible(count);
    await tester.pumpAndSettle();
    await tester.tap(count);
    final generate = find.text('Generate Native Quiz');
    await tester.scrollUntilVisible(generate, 250);
    await tester.tap(generate);
    await settleAsync(tester);
    expect(find.text('Study Set'), findsOneWidget);
    expect((await NorieStudyOfflineStore('local').listSets()).single.itemCount,
        20);
    expect(NorieProgression.instance.credits, before);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await settleAsync(tester);
  });
}
