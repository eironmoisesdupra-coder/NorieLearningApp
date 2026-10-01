import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_models.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';
import 'package:norie_learning/features/learning/domain/anatomy_render_policy.dart';

void main() {
  test('Anatomy Lab covers all core body systems', () {
    final ids = AnatomyCatalog.systems.map((system) => system.id).toSet();

    expect(ids, contains(AnatomySystemId.skeletal));
    expect(ids, contains(AnatomySystemId.articular));
    expect(ids, contains(AnatomySystemId.muscular));
    expect(ids, contains(AnatomySystemId.cardiovascular));
    expect(ids, contains(AnatomySystemId.arterial));
    expect(ids, contains(AnatomySystemId.venous));
    expect(ids, contains(AnatomySystemId.nervous));
    expect(ids, contains(AnatomySystemId.lymphatic));
    expect(ids, contains(AnatomySystemId.respiratory));
    expect(ids, contains(AnatomySystemId.digestive));
    expect(ids, contains(AnatomySystemId.urinary));
    expect(ids, contains(AnatomySystemId.reproductive));
    expect(ids, contains(AnatomySystemId.endocrine));
    expect(ids, contains(AnatomySystemId.integumentary));
    expect(ids, contains(AnatomySystemId.sensory));
  });

  test('each anatomy system has enough structures for quiz distractors', () {
    for (final system in AnatomyCatalog.systems) {
      expect(
        system.structures.length,
        greaterThanOrEqualTo(4),
        reason: system.label,
      );
    }
  });

  test('anatomy structure ids are unique and marker positions are normalized', () {
    final ids = <String>{};

    for (final system in AnatomyCatalog.systems) {
      for (final structure in system.structures) {
        expect(ids.add(structure.id), isTrue, reason: structure.id);
        expect(structure.x, inInclusiveRange(0.0, 1.0));
        expect(structure.y, inInclusiveRange(0.0, 1.0));
        expect(structure.name, isNotEmpty);
        expect(structure.function, isNotEmpty);
        expect(structure.description, isNotEmpty);
      }
    }
  });

  test('multi-layer structure lookup combines selected systems', () {
    final selected = AnatomyCatalog.structuresFor({
      AnatomySystemId.skeletal,
      AnatomySystemId.muscular,
      AnatomySystemId.endocrine,
    });

    expect(selected, hasLength(23));
    expect(
      selected.map((item) => item.system).toSet(),
      {
        AnatomySystemId.skeletal,
        AnatomySystemId.muscular,
        AnatomySystemId.endocrine,
      },
    );
  });
  test('real 3D renderer is used only for the standalone skeletal layer', () {
    expect(
      AnatomyRenderPolicy.useRealSkeleton({AnatomySystemId.skeletal}),
      isTrue,
    );
    expect(
      AnatomyRenderPolicy.useRealSkeleton({
        AnatomySystemId.skeletal,
        AnatomySystemId.muscular,
      }),
      isFalse,
    );
    expect(
      AnatomyRenderPolicy.useRealSkeleton({AnatomySystemId.muscular}),
      isFalse,
    );
  });

  test('real 3D organ atlas is used for organ-only layer selections', () {
    for (final system in AnatomyRenderPolicy.organAtlasSystems) {
      expect(
        AnatomyRenderPolicy.useRealOrgans({system}),
        isTrue,
        reason: system.name,
      );
    }

    expect(
      AnatomyRenderPolicy.useRealOrgans({
        AnatomySystemId.respiratory,
        AnatomySystemId.digestive,
        AnatomySystemId.endocrine,
      }),
      isTrue,
    );
    expect(
      AnatomyRenderPolicy.useRealOrgans({
        AnatomySystemId.skeletal,
        AnatomySystemId.respiratory,
      }),
      isFalse,
    );
    expect(
      AnatomyRenderPolicy.useRealOrgans({AnatomySystemId.muscular}),
      isFalse,
    );
  });

  test('3D skeletal hotspots have unique ids and resolve to structures', () {
    final ids = <String>{};

    for (final hotspot
        in AnatomyHotspotCatalog.skeletal.where((item) => item.enabled)) {
      expect(ids.add(hotspot.id), isTrue, reason: hotspot.id);
      final structure =
          AnatomyHotspotCatalog.resolveStructure(hotspot.structureId);
      expect(structure, isNotNull, reason: hotspot.structureId);
      expect(structure!.system, AnatomySystemId.skeletal);
      expect(hotspot.x, inInclusiveRange(-0.5, 0.5));
      expect(hotspot.y, inInclusiveRange(-0.5, 0.5));
      expect(hotspot.z, inInclusiveRange(-0.5, 0.5));
      expect(hotspot.sourceNode, isNotEmpty, reason: hotspot.id);
    }
  });

  test('3D skeletal hotspot catalog covers minimum v1 bones', () {
    final ids = AnatomyHotspotCatalog.skeletal
        .where((item) => item.enabled)
        .map((item) => item.structureId)
        .toSet();

    expect(
      ids,
      containsAll(const {
        'skull',
        'mandible',
        'clavicle',
        'scapula',
        'sternum',
        'rib-cage',
        'vertebral-column',
        'pelvis',
        'humerus',
        'radius',
        'ulna',
        'femur',
        'patella',
        'tibia',
        'fibula',
      }),
    );
  });

  test('3D skeleton calibration is versioned and source-pinned', () {
    expect(AnatomyHotspotCatalog.calibration.id, isNotEmpty);
    expect(AnatomyHotspotCatalog.calibration.schemaVersion, greaterThan(0));
    expect(
      AnatomyHotspotCatalog.calibration.sourceCommit,
      'e4d76fbb424d15e1364963528a082a78fa359161',
    );
  });

  test('skeleton calibration pins checksum and measured bounds', () {
    expect(
      AnatomyHotspotCatalog.calibration.sha256,
      '253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce',
    );
    expect(
      AnatomyHotspotCatalog.calibration.centerX,
      closeTo(-.130685, 1e-6),
    );
    expect(
      AnatomyHotspotCatalog.calibration.centerY,
      closeTo(.857076, 1e-6),
    );
    expect(
      AnatomyHotspotCatalog.calibration.centerZ,
      closeTo(.009998, 1e-6),
    );
    expect(
      AnatomyHotspotCatalog.calibration.dimensionsX,
      closeTo(.409679, 1e-6),
    );
    expect(
      AnatomyHotspotCatalog.calibration.dimensionsY,
      closeTo(1.69587, 1e-6),
    );
    expect(
      AnatomyHotspotCatalog.calibration.dimensionsZ,
      closeTo(.254124, 1e-6),
    );
  });

  test('skeleton fetch script pins the calibrated skeleton source', () {
    final script = File('scripts/fetch_anatomy_assets.sh').readAsStringSync();

    expect(
      script,
      contains(AnatomyHotspotCatalog.calibration.sourceCommit),
    );
    expect(
      script,
      contains(AnatomyHotspotCatalog.calibration.sha256),
    );
    expect(
      script,
      contains('SKELETON_SOURCE='),
    );
    expect(
      script,
      contains('scripts/build_full_skeleton.py'),
    );
  });

  test('clean hotspot mode exposes no renderable hotspots', () {
    expect(
      AnatomyHotspotCatalog.renderable(
        AnatomyHotspotCatalog.skeletal,
        mode: AnatomyHotspotMode.clean,
      ),
      isEmpty,
    );
  });

}
