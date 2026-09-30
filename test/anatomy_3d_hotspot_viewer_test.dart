import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_models.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_viewer_policy.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';

void main() {
  test('known hotspot id resolves the expected structure', () {
    final structure =
        AnatomyHotspotViewerPolicy.structureForHotspotId('skeletal-femur');

    expect(structure, isNotNull);
    expect(structure!.id, 'femur');
  });

  test('unknown hotspot id resolves safely to null', () {
    expect(
      AnatomyHotspotViewerPolicy.structureForHotspotId('missing-hotspot'),
      isNull,
    );
  });

  test('clean mode hides hotspots while study modes show them', () {
    expect(
      AnatomyHotspotViewerPolicy.shouldRenderHotspots(
        AnatomyHotspotMode.clean,
      ),
      isFalse,
    );
    expect(
      AnatomyHotspotViewerPolicy.shouldRenderHotspots(
        AnatomyHotspotMode.explore,
      ),
      isTrue,
    );
    expect(
      AnatomyHotspotViewerPolicy.shouldRenderHotspots(
        AnatomyHotspotMode.identification,
      ),
      isTrue,
    );
  });

  test('standalone skeletal fallback list uses calibrated hotspot structures',
      () {
    final items = AnatomyHotspotViewerPolicy.fallbackStructures(
      selectedSystems: const {AnatomySystemId.skeletal},
      realSkeleton: true,
    );

    expect(items, isNotEmpty);
    expect(items.map((item) => item.id), contains('skull'));
    expect(items.map((item) => item.id), contains('femur'));
    expect(items.every((item) => item.system == AnatomySystemId.skeletal), isTrue);
  });
}
