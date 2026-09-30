import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../core/theme/norie_theme.dart';

enum Anatomy3DAssetKind { skeleton, organs }

abstract final class Anatomy3DAssets {
  static const skeleton = 'assets/anatomy/overview-skeleton.glb';
  static const organs = 'assets/anatomy/anatomy-organs.glb';
}

class AnatomyReal3DModel extends StatelessWidget {
  const AnatomyReal3DModel({
    required this.kind,
    required this.cameraOrbit,
    required this.fieldOfView,
    required this.autoRotate,
    required this.enableTouch,
    required this.enablePan,
    super.key,
  });

  final Anatomy3DAssetKind kind;
  final String cameraOrbit;
  final String fieldOfView;
  final bool autoRotate;
  final bool enableTouch;
  final bool enablePan;

  bool get _isOrgans => kind == Anatomy3DAssetKind.organs;

  @override
  Widget build(BuildContext context) {
    final src =
        _isOrgans ? Anatomy3DAssets.organs : Anatomy3DAssets.skeleton;
    final badge = _isOrgans ? 'REAL 3D · ORGAN ATLAS' : 'REAL 3D · SKELETAL';
    final alt = _isOrgans
        ? 'Interactive 3D human internal organ atlas'
        : 'Interactive 3D human skeletal system';
    final attribution = _isOrgans
        ? 'BodyParts3D · CC BY-SA 2.1 JP'
        : 'Open3Dmodel · CC BY-SA 4.0';

    return Stack(
      children: [
        Positioned.fill(
          child: ModelViewer(
            key: ValueKey(kind),
            backgroundColor: Colors.transparent,
            src: src,
            alt: alt,
            cameraControls: enableTouch,
            disablePan: !enablePan,
            disableZoom: false,
            autoRotate: autoRotate,
            autoRotateDelay: 0,
            rotationPerSecond: '12deg',
            cameraOrbit: cameraOrbit,
            cameraTarget: 'auto auto auto',
            fieldOfView: fieldOfView,
            minCameraOrbit: 'auto auto 0.05m',
            maxCameraOrbit: 'auto auto 100m',
            minFieldOfView: '15deg',
            maxFieldOfView: '55deg',
            exposure: _isOrgans ? 1.1 : 1.05,
            shadowIntensity: _isOrgans ? .78 : .72,
            shadowSoftness: .85,
            debugLogging: false,
          ),
        ),
        Positioned(
          left: 12,
          top: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xD90A1630),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: NorieColors.cyan.withValues(alpha: .42),
              ),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: NorieColors.cyan,
                fontSize: 8,
                letterSpacing: .8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xB3071227),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Text(
                attribution,
                style: const TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
