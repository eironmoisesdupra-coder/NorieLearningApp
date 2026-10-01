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
    required this.sourceNode,
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

  /// Exact GLB mesh node used to derive this anchor.
  final String sourceNode;

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
    required this.centerX,
    required this.centerY,
    required this.centerZ,
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
  final double centerX;
  final double centerY;
  final double centerZ;
  final double dimensionsX;
  final double dimensionsY;
  final double dimensionsZ;
}

abstract final class AnatomyHotspotCatalog {
  static const calibration = AnatomyModelCalibration(
    id: 'open3dmodel-skeleton-v2-full-body',
    modelAsset: 'assets/anatomy/overview-skeleton.glb',
    sourceCommit: 'e4d76fbb424d15e1364963528a082a78fa359161',
    sha256: '253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce',
    schemaVersion: 2,
    frontDirection: '+z',
    centerX: -.130685,
    centerY: .857076,
    centerZ: .009998,
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
      x: .319021,
      y: .466782,
      z: .172349,
      sourceNode: 'Frontal bone',
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-mandible',
      structureId: 'mandible',
      label: 'Mandible',
      system: AnatomySystemId.skeletal,
      x: .318994,
      y: .403463,
      z: .133289,
      sourceNode: 'Mandible bone',
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-clavicle',
      structureId: 'clavicle',
      label: 'Clavicle',
      system: AnatomySystemId.skeletal,
      x: .123514,
      y: .324052,
      z: -.052042,
      sourceNode: 'Clavicle.r',
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-scapula',
      structureId: 'scapula',
      label: 'Scapula',
      system: AnatomySystemId.skeletal,
      x: .033902,
      y: .282737,
      z: -.275574,
      sourceNode: 'Scapula.r.',
      side: AnatomyHotspotSide.right,
    ),
    AnatomyHotspot(
      id: 'skeletal-sternum',
      structureId: 'sternum',
      label: 'Sternum',
      system: AnatomySystemId.skeletal,
      x: .318991,
      y: .260453,
      z: .317959,
      sourceNode: 'Body of sternum',
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-rib-cage',
      structureId: 'rib-cage',
      label: 'Rib Cage',
      system: AnatomySystemId.skeletal,
      x: .139968,
      y: .264126,
      z: -.010357,
      sourceNode: 'Rib (5th).r',
      side: AnatomyHotspotSide.right,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-vertebral-column',
      structureId: 'vertebral-column',
      label: 'Vertebral Column',
      system: AnatomySystemId.skeletal,
      x: .318994,
      y: .253272,
      z: -.294502,
      sourceNode: 'Thoracic vertebrae (T7)',
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-pelvis',
      structureId: 'pelvis',
      label: 'Pelvis',
      system: AnatomySystemId.skeletal,
      x: .150752,
      y: .028054,
      z: -.098468,
      sourceNode: 'Hip bone.r',
      side: AnatomyHotspotSide.right,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-humerus',
      structureId: 'humerus',
      label: 'Humerus',
      system: AnatomySystemId.skeletal,
      x: -.160828,
      y: .229599,
      z: -.163345,
      sourceNode: 'Humerus.r',
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-radius',
      structureId: 'radius',
      label: 'Radius',
      system: AnatomySystemId.skeletal,
      x: -.310314,
      y: .070931,
      z: -.088473,
      sourceNode: 'Radius.r',
      side: AnatomyHotspotSide.right,
    ),
    AnatomyHotspot(
      id: 'skeletal-ulna',
      structureId: 'ulna',
      label: 'Ulna',
      system: AnatomySystemId.skeletal,
      x: -.240474,
      y: .077223,
      z: -.130365,
      sourceNode: 'Ulna.r',
      side: AnatomyHotspotSide.right,
    ),
    AnatomyHotspot(
      id: 'skeletal-femur',
      structureId: 'femur',
      label: 'Femur',
      system: AnatomySystemId.skeletal,
      x: .098372,
      y: -.117108,
      z: -.118163,
      sourceNode: 'Femur.r',
      side: AnatomyHotspotSide.right,
      priority: 3,
    ),
    AnatomyHotspot(
      id: 'skeletal-patella',
      structureId: 'patella',
      label: 'Patella',
      system: AnatomySystemId.skeletal,
      x: .113289,
      y: -.243279,
      z: -.020356,
      sourceNode: 'Patella.r',
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-tibia',
      structureId: 'tibia',
      label: 'Tibia',
      system: AnatomySystemId.skeletal,
      x: .132902,
      y: -.355028,
      z: -.151922,
      sourceNode: 'Tibia.r',
      side: AnatomyHotspotSide.right,
      priority: 2,
    ),
    AnatomyHotspot(
      id: 'skeletal-fibula',
      structureId: 'fibula',
      label: 'Fibula',
      system: AnatomySystemId.skeletal,
      x: .058043,
      y: -.365608,
      z: -.209850,
      sourceNode: 'Fibula.r',
      side: AnatomyHotspotSide.right,
    ),
  ];

  static double modelX(AnatomyHotspot hotspot) =>
      calibration.centerX + (hotspot.x * calibration.dimensionsX);

  static double modelY(AnatomyHotspot hotspot) =>
      calibration.centerY + (hotspot.y * calibration.dimensionsY);

  static double modelZ(AnatomyHotspot hotspot) =>
      calibration.centerZ + (hotspot.z * calibration.dimensionsZ);

  static String displaySourceNode(String sourceNode) {
    final trimmed = sourceNode.trim();
    return trimmed
        .replaceFirst(
          RegExp(r'\.r\.?$', caseSensitive: false),
          ' — right',
        )
        .replaceFirst(
          RegExp(r'\.l$', caseSensitive: false),
          ' — left',
        );
  }

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
