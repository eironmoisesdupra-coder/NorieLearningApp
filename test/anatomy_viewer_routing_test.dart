import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_viewer_screen.dart';

void main() {
  for (final system in AnatomyCatalog.systems) {
    testWidgets('${system.label} opens selectable atlas geometry',
        (tester) async {
      await tester.runAsync(AnatomyAtlasCatalog.load);
      await tester.pumpWidget(
          MaterialApp(home: AnatomyViewerScreen(initialSystems: {system.id})));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
      final model = find.byType(AnatomyAtlasModelView);
      expect(model, findsOneWidget);
      expect(tester.widget<AnatomyAtlasModelView>(model).systems,
          {system.id.name});
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
