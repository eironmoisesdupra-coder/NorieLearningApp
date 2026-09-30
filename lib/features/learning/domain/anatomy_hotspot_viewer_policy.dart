import 'anatomy_hotspot_models.dart';
import 'anatomy_models.dart';

abstract final class AnatomyHotspotViewerPolicy {
  static AnatomyStructure? structureForHotspotId(String hotspotId) {
    for (final hotspot in AnatomyHotspotCatalog.skeletal) {
      if (!hotspot.enabled || hotspot.id != hotspotId) continue;
      return AnatomyHotspotCatalog.resolveStructure(hotspot.structureId);
    }
    return null;
  }

  static bool shouldRenderHotspots(AnatomyHotspotMode mode) =>
      mode != AnatomyHotspotMode.clean;

  static List<AnatomyStructure> fallbackStructures({
    required Set<AnatomySystemId> selectedSystems,
    required bool realSkeleton,
  }) {
    if (!realSkeleton) {
      return AnatomyCatalog.structuresFor(selectedSystems);
    }

    final seen = <String>{};
    final structures = <AnatomyStructure>[];
    for (final hotspot in AnatomyHotspotCatalog.skeletal) {
      if (!hotspot.enabled || !seen.add(hotspot.structureId)) continue;
      final structure =
          AnatomyHotspotCatalog.resolveStructure(hotspot.structureId);
      if (structure != null) structures.add(structure);
    }
    return structures;
  }
}
