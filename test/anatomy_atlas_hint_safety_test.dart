import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_screen.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_quiz_policy.dart';
import 'anatomy_atlas_flexible_quiz_test.dart' as fixtures;

void main() {
  for (final balance in [0, 4, 5, 10]) {
    testWidgets(
        'unapproved hints never debit $balance credits or alter quiz readiness',
        (tester) async {
      SharedPreferences.setMockInitialValues({'norie.credits': balance});
      await tester.runAsync(NorieProgression.instance.load);
      final progress = NorieProgression.instance;
      final before = progress.exportCloudState();
      for (final difficulty in AtlasQuizDifficulty.values) {
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(MaterialApp(
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.6),
                    disableAnimations: true),
                child: child!),
            home: AnatomyAtlasQuizScreen(
                key: UniqueKey(),
                catalog: fixtures.fixture(),
                reference: 'male',
                systems: const {'skeletal'},
                difficulty: difficulty)));
        await tester.pump();
        final viewer = tester
            .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
        expect(viewer.reference, 'male');
        final target = fixtures
            .fixture()
            .structures
            .singleWhere((s) => s.id == viewer.target);
        expect(viewer.systems, target.systems);
        expect(find.text(target.name), findsOneWidget);
        for (var tap = 0; tap < 2; tap++) {
          await tester.tap(
              find.byTooltip('Specific hint unavailable; costs 0 credits'));
          await tester.pump();
        }
        expect(find.byKey(const ValueKey('atlas-quiz-hint')), findsNothing);
        expect(progress.credits, before['credits']);
        expect(progress.totalXp, before['total_xp']);
        expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
            isNull);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('previous question readiness cannot enable the next modeled part',
      (tester) async {
    final catalog = fixtures.fixture();
    await tester.pumpWidget(MaterialApp(
        home: AnatomyAtlasQuizScreen(
            catalog: catalog,
            reference: 'male',
            systems: const {'skeletal'},
            requestedCount: 5)));
    final oldViewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    oldViewer.onLoaded!(true);
    await tester.pump();
    final answer =
        catalog.structures.singleWhere((s) => s.id == oldViewer.target).name;
    await tester.ensureVisible(find.text(answer));
    await tester.tap(find.text(answer));
    await tester.pump();
    await tester.ensureVisible(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await tester.pump();
    await tester.ensureVisible(find.text('Next structure'));
    await tester.tap(find.text('Next structure'));
    await tester.pump();
    final nextViewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    expect(nextViewer.target, isNot(oldViewer.target));
    oldViewer.onLoaded!(true);
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    final option =
        tester.widget<OutlinedButton>(find.byType(OutlinedButton).first);
    expect(option.onPressed, isNull);
    nextViewer.onLoaded!(true);
    await tester.pump();
    expect(
        tester
            .widget<OutlinedButton>(find.byType(OutlinedButton).first)
            .onPressed,
        isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
