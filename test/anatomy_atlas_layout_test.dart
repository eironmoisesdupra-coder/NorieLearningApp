import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_screen.dart';

void main() {
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
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
