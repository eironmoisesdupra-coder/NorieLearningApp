import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_screen.dart';

void main() {
  testWidgets('quality preference reaches renderer and survives model reload',
      (tester) async {
    await tester.runAsync(AnatomyAtlasCatalog.load);
    await tester.pumpWidget(const MaterialApp(
        home: AnatomyAtlasScreen(initialSystems: {AnatomySystemId.skeletal})));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    final model = find.byType(AnatomyAtlasModelView);
    final controller = tester.widget<AnatomyAtlasModelView>(model).controller;
    final state = tester.state(model);
    await tester.tap(find.byTooltip('Explorer options'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Balanced'));
    await tester.pump();
    await tester.tap(find.text('Balanced'));
    await tester.pump();
    expect(controller.lastCommand?['type'], 'quality');
    expect(controller.lastCommand?['payload'], {'profile': 'balanced'});
    expect(tester.state(model), same(state));
    await tester.ensureVisible(find.text('Close options'));
    await tester.pump();
    await tester.tap(find.text('Close options'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    tester.widget<AnatomyAtlasModelView>(model).onLoaded!(true);
    await tester.pump();
    expect(controller.lastCommand?['type'], 'quality');
    expect(controller.lastCommand?['payload'], {'profile': 'balanced'});
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
