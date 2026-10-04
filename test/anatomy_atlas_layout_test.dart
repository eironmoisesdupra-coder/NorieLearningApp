import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_mascot_host.dart';
import 'package:norie_learning/core/mascot/norie_mascot_scope.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_models.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_screen.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_lab_placeholder_screen.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_setup_screen.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_screen.dart';

void main() {
  testWidgets('lab quiz shortcut opens the category selector', (tester) async {
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester
        .pumpWidget(const MaterialApp(home: AnatomyLabPlaceholderScreen()));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    await tester.tap(find.text('Quiz Selected'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(AnatomyAtlasQuizSetupScreen), findsOneWidget);
    expect(find.byType(AnatomyAtlasQuizScreen), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('atlas guide focuses its camera and highlights system categories',
      (tester) async {
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(MaterialApp(
        builder: (_, child) => NorieMascotHost(child: child!),
        home: const AnatomyAtlasScreen(
            initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    final coordinator = NorieMascotScope.maybeOf(
            tester.element(find.byType(AnatomyAtlasScreen)))!
        .tutorialCoordinator;
    coordinator.browse(section: NorieTutorialCatalog.anatomy);
    coordinator.goTo(NorieTutorialCatalog.complete.steps
        .indexWhere((step) => step.id == 'anatomy-camera'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(viewer.controller.lastCommand?['type'], 'focus');
    final catalog = await tester.runAsync(AnatomyAtlasCatalog.load);
    final payload = viewer.controller.lastCommand?['payload'] as Map;
    expect(
        catalog!.structures
            .firstWhere((part) => part.id == payload['id'])
            .name
            .toLowerCase(),
        contains('femur'));
    coordinator.goTo(NorieTutorialCatalog.complete.steps
        .indexWhere((step) => step.id == 'anatomy-systems'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final rect = coordinator.targetRect('anatomy.systems');
    expect(rect?.height, 49);
    expect(find.byKey(const ValueKey('tutorial-location')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('quiz setup selects every part and starts 20 items on a phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final catalog = await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(MaterialApp(
        home: AnatomyAtlasQuizSetupScreen(
            catalog: catalog!,
            reference: 'glands',
            systems: const {'endocrine'})));
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    await tester.tap(find.text('Every part'));
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull);
    await tester.tap(find.text('Start 20-question quiz'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(AnatomyAtlasQuizScreen), findsOneWidget);
    expect(find.text('Identify · 1/20'), findsOneWidget);
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    final target = catalog.structures
        .firstWhere((structure) => structure.id == viewer.target);
    expect(viewer.reference, target.reference);
    await tester.tap(find.byTooltip('Show hint'));
    await tester.pump();
    expect(find.byKey(const ValueKey('atlas-quiz-hint')), findsOneWidget);
    expect(tester.getSize(find.byType(AnatomyAtlasModelView)).height,
        greaterThan(120));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('detail shortcuts preserve model space on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Asset IO must finish in real time before testing frame-only layout.
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(const MaterialApp(
        home: AnatomyAtlasScreen(initialSystems: {
      AnatomySystemId.articular,
      AnatomySystemId.endocrine,
      AnatomySystemId.lymphatic,
      AnatomySystemId.sensory,
    })));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    // Native WebView startup stays pending in widget tests; only lay out Flutter.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final viewer = find.byType(AnatomyAtlasModelView);
    expect(viewer, findsOneWidget);
    tester.widget<AnatomyAtlasModelView>(viewer).onSelected!('bp-FJ1796');
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Pituitary gland'), findsOneWidget);
    expect(tester.getSize(viewer).height, greaterThan(150));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Adult male · BodyParts3D'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final glandChoice =
        find.widgetWithText(ListTile, 'Endocrine glands · detail');
    expect(glandChoice, findsOneWidget);
    await tester.ensureVisible(glandChoice);
    await tester.pump();
    await tester.tap(glandChoice);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.widget<AnatomyAtlasModelView>(viewer).reference, 'glands');
    expect(find.text('Search 11 parts'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
