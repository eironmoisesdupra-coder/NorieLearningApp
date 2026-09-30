import 'anatomy_models.dart';

enum AnatomyHotspotSide { midline, right, left, bilateral }

enum AnatomyHotspotMode { explore, identification, clean, quiz }

class AnatomyHotspot {
  const AnatomyHotspot({
    required this.id,
    required this.structureId,
    required this.label,
    required this.system,
    required this.x,
    required this.y,
    required this.z,
    this.side = AnatomyHotspotSide.midline,
    this.priority = 1,
    this.enabled = true,
  });

  final String id;
  final String structureId;
  final String label;
  final AnatomySystemId system;

  /// Normalized local-model coordinates relative to the loaded GLB bounds.
  /// Each component is converted to model space at runtime using
  /// model-viewer's getBoundingBoxCenter() and getDimensions().
  final double x;
  final double y;
  final double z;

  final AnatomyHotspotSide side;
  final int priority;
  final bool enabled;
}

class AnatomyModelCalibration {
  const AnatomyModelCalibration({
    required this.id,
    required this.modelAsset,
    required this.sourceCommit,
    required this.sha256,
    required this.schemaVersion,
    required this.frontDirection,
    required this.dimensionsX,
    required this.dimensionsY,
    required this.dimensionsZ,
  });

  final String id;
  final String modelAsset;
  final String sourceCommit;
  final String sha256;
  final int schemaVersion;
  final String frontDirection;
  final double dimensionsX;
  final double dimensionsY;
  final double dimensionsZ;
}

abstract final class AnatomyHotspotCatalog {
  static const calibration = AnatomyModelCalibration(
    id: 'open3dmodel-skeleton-v1',
    modelAsset: 'assets/anatomy/overview-skeleton.glb',
    sourceCommit: 'e4d76fbb424d15e1364963528a082a78fa359161',
    sha256: '253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce',
    schemaVersion: 1,
    frontDirection: '+z',
    dimensionsX: .409679,
    dimensionsY: 1.69587,
    dimensionsZ: .254124,
  );

  static const skeletal = <AnatomyHotspot>[
    AnatomyHotspot(
      id: 'skeletal-skull',
      structureId: 'skull',
      label: 'Skull',
      system: AnatomySystemId.skeletal,
      x: 0,
      y: .43,
      z: .12,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-mandible',
      structureId: 'mandible',
      label: 'Mandible',
      system: AnatomySystemId.skeletal,
      x: 0,
      y: .355,
      z: .18,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-clavicle',
      structureId: 'clavicle',
      label: 'Clavicle',
      system: AnatomySystemId.skeletal,
      x: .13,
      y: .27,
      z: .16,
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-scapula',
      structureId: 'scapula',
      label: 'Scapula',
      system: AnatomySystemId.skeletal,
      x: .19,
      y: .235,
      z: -.08,
      side: AnatomyHotspotSide.right,
    ),
    AnatomyHotspot(
      id: 'skeletal-sternum',
      structureId: 'sternum',
      label: 'Sternum',
      system: AnatomySystemId.skeletal,
      x: 0,
      y: .205,
      z: .19,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-rib-cage',
      structureId: 'rib-cage',
      label: 'Rib Cage',
      system: AnatomySystemId.skeletal,
      x: .10,
      y: .16,
      z: .14,
      side: AnatomyHotspotSide.right,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-vertebral-column',
      structureId: 'vertebral-column',
      label: 'Vertebral Column',
      system: AnatomySystemId.skeletal,
      x: 0,
      y: .115,
      z: -.07,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-pelvis',
      structureId: 'pelvis',
      label: 'Pelvis',
      system: AnatomySystemId.skeletal,
      x: .08,
      y: -.07,
      z: .08,
      side: AnatomyHotspotSide.right,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-humerus',
      structureId: 'humerus',
      label: 'Humerus',
      system: AnatomySystemId.skeletal,
      x: .25,
      y: .105,
      z: .05,
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-radius',
      structureId: 'radius',
      label: 'Radius',
      system: AnatomySystemId.skeletal,
      x: .30,
      y: -.035,
      z: .08,
      side: AnatomyHotspotSide.right,
    ),
    AnatomyHotspot(
      id: 'skeletal-ulna',
      structureId: 'ulna',
      label: 'Ulna',
      system: AnatomySystemId.skeletal,
      x: .25,
      y: -.045,
      z: .02,
      side: AnatomyHotspotSide.right,
    ),
    AnatomyHotspot(
      id: 'skeletal-femur',
      structureId: 'femur',
      label: 'Femur',
      system: AnatomySystemId.skeletal,
      x: .115,
      y: -.235,
      z: .04,
      side: AnatomyHotspotSide.right,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-patella',
      structureId: 'patella',
      label: 'Patella',
      system: AnatomySystemId.skeletal,
      x: .12,
      y: -.345,
      z: .16,
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-tibia',
      structureId: 'tibia',
      label: 'Tibia',
      system: AnatomySystemId.skeletal,
      x: .105,
      y: -.425,
      z: .08,
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-fibula',
      structureId: 'fibula',
      label: 'Fibula',
      system: AnatomySystemId.skeletal,
      x: .16,
      y: -.425,
      z: .03,
      side: AnatomyHotspotSide.right,
    ),
  ];

  static List<AnatomyHotspot> hotspotsFor(Set<AnatomySystemId> systems) {
    if (!systems.contains(AnatomySystemId.skeletal)) return const [];
    return skeletal.where((item) => item.enabled).toList(growable: false);
  }

  static List<AnatomyHotspot> renderable(
    Iterable<AnatomyHotspot> hotspots, {
    required AnatomyHotspotMode mode,
  }) {
    if (mode == AnatomyHotspotMode.clean) return const [];
    return hotspots.where((item) => item.enabled).toList(growable: false);
  }

  static AnatomyStructure? resolveStructure(String structureId) =>
      AnatomyCatalog.structureById(structureId);

  static AnatomyHotspot? hotspotForStructureId(String structureId) {
    for (final hotspot in skeletal) {
      if (hotspot.enabled && hotspot.structureId == structureId) {
        return hotspot;
      }
    }
    return null;
  }
}
