import 'anatomy_models.dart';

abstract final class AnatomyRenderPolicy {
  static bool useRealSkeleton(Set<AnatomySystemId> selectedSystems) {
    return selectedSystems.length == 1 &&
        selectedSystems.contains(AnatomySystemId.skeletal);
  }
}
