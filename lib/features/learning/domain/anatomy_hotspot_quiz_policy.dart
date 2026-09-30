import 'anatomy_hotspot_models.dart';

abstract final class AnatomyHotspotQuizPolicy {
  static AnatomyHotspot? hotspotForStructureId(String structureId) =>
      AnatomyHotspotCatalog.hotspotForStructureId(structureId);

  static List<AnatomyHotspot> quizHotspotsFor(AnatomyHotspot hotspot) =>
      <AnatomyHotspot>[hotspot];
}
