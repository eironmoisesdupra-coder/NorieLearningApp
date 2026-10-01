import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_real_3d_model.dart';

void main() {
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
