import 'anatomy_models.dart';

abstract final class AnatomyRenderPolicy {
  static const organAtlasSystems = <AnatomySystemId>{
    AnatomySystemId.cardiovascular,
    AnatomySystemId.nervous,
    AnatomySystemId.respiratory,
    AnatomySystemId.digestive,
    AnatomySystemId.urinary,
    AnatomySystemId.reproductive,
    AnatomySystemId.endocrine,
  };

  static bool useRealSkeleton(Set<AnatomySystemId> selectedSystems) {
    return selectedSystems.length == 1 &&
        selectedSystems.contains(AnatomySystemId.skeletal);
  }

  static bool useRealOrgans(Set<AnatomySystemId> selectedSystems) {
    return selectedSystems.isNotEmpty &&
        selectedSystems.every(organAtlasSystems.contains);
  }

  static bool useAnyReal3D(Set<AnatomySystemId> selectedSystems) {
    return useRealSkeleton(selectedSystems) || useRealOrgans(selectedSystems);
  }
}
