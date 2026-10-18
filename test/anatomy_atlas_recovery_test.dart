import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_screen.dart';

void main() {
  testWidgets(
      'context recovery retains isolation and fresh renderer replays controls',
      (tester) async {
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(const MaterialApp(
        home: AnatomyAtlasScreen(initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    final model = find.byType(AnatomyAtlasModelView);
    var view = tester.widget<AnatomyAtlasModelView>(model);
    view.onLoaded!(true);
    await tester.pump();
    view.onSelected!('bp-FJ3365');
    await tester.pump();
    await tester.ensureVisible(find.text('Isolate'));
    await tester.pump();
    await tester.tap(find.text('Isolate'));
    await tester.pump();
    final commands = <Map<String, dynamic>>[];
    final controller = tester.widget<AnatomyAtlasModelView>(model).controller;
    void capture() => commands.add(Map.of(controller.lastCommand!));
    controller.addListener(capture);
    view = tester.widget<AnatomyAtlasModelView>(model);
    view.onLoaded!(false);
    view.onLoaded!(true);
    await tester.pump();
    expect(commands.map((c) => c['type']), ['quality']);
    commands.clear();
    view.onRendererReady!();
    view.onLoaded!(true);
    await tester.pump();
    final types = commands.map((c) => c['type']).toList();
    expect(types, contains('isolate'));
    expect(types.lastIndexOf('select'), lessThan(types.indexOf('isolate')));
    expect(commands.firstWhere((c) => c['type'] == 'isolate')['payload'],
        {'id': 'bp-FJ3365'});
    expect(find.text('Right femur'), findsOneWidget);
    expect(tester.takeException(), isNull);
    controller.removeListener(capture);
    await tester.pumpWidget(const SizedBox());
  });
}
