import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
// Exercise the renderer's validation against the app's actual configuration.
// ignore: implementation_imports
import 'package:model_viewer_plus/src/html_builder.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_real_3d_model.dart';

void main() {
  for (final kind in Anatomy3DAssetKind.values) {
    testWidgets('${kind.name} settings are accepted by the 3D renderer',
        (tester) async {
      late ModelViewer viewer;
      await tester.pumpWidget(Builder(builder: (context) {
        final stack = AnatomyReal3DModel(
          kind: kind,
          cameraOrbit: '0deg 75deg auto',
          fieldOfView: '30deg',
          autoRotate: false,
          enableTouch: true,
          enablePan: false,
        ).build(context) as Stack;
        viewer = (stack.children.first as Positioned).child as ModelViewer;
        return const SizedBox();
      }));
      expect(
          () => HTMLBuilder.build(
                src: viewer.src,
                exposure: viewer.exposure,
                shadowIntensity: viewer.shadowIntensity,
                shadowSoftness: viewer.shadowSoftness,
                minHotspotOpacity: viewer.minHotspotOpacity,
                maxHotspotOpacity: viewer.maxHotspotOpacity,
              ),
          returnsNormally);
    });
  }
}
