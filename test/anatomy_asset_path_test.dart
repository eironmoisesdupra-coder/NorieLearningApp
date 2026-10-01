import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_real_3d_model.dart';

void main() {
  test('camera presets recreate the web model viewer', () {
    final front = AnatomyReal3DModel.viewerKey(
      kind: Anatomy3DAssetKind.skeleton,
      hotspotMode: AnatomyHotspotMode.explore,
      hotspotCount: 15,
      cameraOrbit: '0deg 75deg auto',
      fieldOfView: '35deg',
      enablePan: false,
      autoRotate: false,
    );
    final left = AnatomyReal3DModel.viewerKey(
      kind: Anatomy3DAssetKind.skeleton,
      hotspotMode: AnatomyHotspotMode.explore,
      hotspotCount: 15,
      cameraOrbit: '-90deg 75deg auto',
      fieldOfView: '35deg',
      enablePan: false,
      autoRotate: false,
    );
    final zoomed = AnatomyReal3DModel.viewerKey(
      kind: Anatomy3DAssetKind.skeleton,
      hotspotMode: AnatomyHotspotMode.explore,
      hotspotCount: 15,
      cameraOrbit: '0deg 75deg auto',
      fieldOfView: '28deg',
      enablePan: false,
      autoRotate: false,
    );

    expect(left, isNot(front));
    expect(zoomed, isNot(front));
  });

  test('web anatomy assets use Flutter web deployed asset paths', () {
    expect(
      Anatomy3DAssets.sourceFor(
        Anatomy3DAssetKind.skeleton,
        web: true,
      ),
      'assets/assets/anatomy/overview-skeleton.glb',
    );
    expect(
      Anatomy3DAssets.sourceFor(
        Anatomy3DAssetKind.organs,
        web: true,
      ),
      'assets/assets/anatomy/anatomy-organs.glb',
    );
  });

  test('native anatomy assets keep Flutter bundle asset paths', () {
    expect(
      Anatomy3DAssets.sourceFor(
        Anatomy3DAssetKind.skeleton,
        web: false,
      ),
      'assets/anatomy/overview-skeleton.glb',
    );
    expect(
      Anatomy3DAssets.sourceFor(
        Anatomy3DAssetKind.organs,
        web: false,
      ),
      'assets/anatomy/anatomy-organs.glb',
    );
  });
}
