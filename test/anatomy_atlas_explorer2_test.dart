import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_screen.dart';

void main() {
  testWidgets(
      'Explorer panels preserve selected model and fit 320px at 160 percent',
      (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const AnatomyAtlasScreen(
            initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    final model = find.byType(AnatomyAtlasModelView);
    final controller = tester.widget<AnatomyAtlasModelView>(model).controller;
    tester.widget<AnatomyAtlasModelView>(model).onSelected!('bp-FJ3365');
    await tester.pump();
    await tester.tap(find.byTooltip('Hide systems'));
    await tester.pump();
    expect(tester.widget<AnatomyAtlasModelView>(model).controller,
        same(controller));
    expect(find.text('Right femur'), findsOneWidget);
    expect(tester.getSize(model).height, greaterThan(180));
    await tester.tap(find.byTooltip('Selected details'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('description unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Close details'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Close details'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('landscape enlarged text keeps selected model usable',
      (tester) async {
    tester.view.physicalSize = const Size(568, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const AnatomyAtlasScreen(
            initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    final model = find.byType(AnatomyAtlasModelView);
    tester.widget<AnatomyAtlasModelView>(model).onSelected!('bp-FJ3365');
    await tester.pump();
    expect(tester.getSize(model).height, greaterThan(120));
    await tester.ensureVisible(find.byTooltip('View controls'));
    await tester.pump();
    await tester.tap(find.byTooltip('View controls'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Opacity'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('search keyboard leaves a scrolling results surface',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(const MaterialApp(
        home: AnatomyAtlasScreen(initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    await tester.tap(find.text('Search 234 parts'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    await tester.enterText(
        find.byKey(const ValueKey('atlas-search-field')), 'bp-FJ3365');
    await tester.pump();
    expect(find.text('1 structures in selected systems'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  Future<void> openLandscape(WidgetTester tester) async {
    tester.view.physicalSize = const Size(568, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(const MaterialApp(
        home: AnatomyAtlasScreen(initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  }

  Future<void> controls(WidgetTester tester) async {
    await tester.ensureVisible(find.byTooltip('View controls'));
    await tester.pump();
    await tester.tap(find.byTooltip('View controls'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('compact Hide always leaves Restore available', (tester) async {
    await openLandscape(tester);
    final model = find.byType(AnatomyAtlasModelView);
    tester.widget<AnatomyAtlasModelView>(model).onSelected!('bp-FJ3365');
    await tester.pump();
    await controls(tester);
    await tester.ensureVisible(find.text('Hide'));
    await tester.pump();
    await tester.tap(find.text('Hide'));
    await tester.pump();
    expect(find.text('Restore'), findsOneWidget);
    await tester.ensureVisible(find.text('Restore'));
    await tester.pump();
    await tester.tap(find.text('Restore'));
    expect(
        tester
            .widget<AnatomyAtlasModelView>(model)
            .controller
            .lastCommand?['type'],
        'restore');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('compact opacity can rotate into portrait safely',
      (tester) async {
    await openLandscape(tester);
    await controls(tester);
    await tester.ensureVisible(find.byType(Slider));
    await tester.pump();
    await tester.drag(find.byType(Slider), const Offset(-60, 0));
    await tester.pump();
    await tester.ensureVisible(find.text('Close controls'));
    await tester.pump();
    await tester.tap(find.text('Close controls'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    tester.view.physicalSize = const Size(320, 740);
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('rotation preserves actual model State with selection',
      (tester) async {
    await openLandscape(tester);
    final model = find.byType(AnatomyAtlasModelView);
    final state = tester.state(model);
    tester.widget<AnatomyAtlasModelView>(model).onSelected!('bp-FJ3365');
    await tester.pump();
    tester.view.physicalSize = const Size(320, 740);
    await tester.pump();
    expect(tester.state(model), same(state));
    expect(find.text('Right femur'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
