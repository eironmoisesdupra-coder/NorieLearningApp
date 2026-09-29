import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../core/theme/norie_theme.dart';

abstract final class Anatomy3DAssets {
  static const model = 'assets/anatomy/overview-skeleton.glb';
}

class AnatomyReal3DModel extends StatelessWidget {
  const AnatomyReal3DModel({
    required this.cameraOrbit,
    required this.cameraTarget,
    required this.autoRotate,
    required this.enableTouch,
    super.key,
  });

  final String cameraOrbit;
  final String cameraTarget;
  final bool autoRotate;
  final bool enableTouch;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ModelViewer(
            backgroundColor: Colors.transparent,
            src: Anatomy3DAssets.model,
            alt: 'Interactive 3D human skeletal system',
            cameraControls: enableTouch,
            disablePan: true,
            disableZoom: false,
            autoRotate: autoRotate,
            autoRotateDelay: 0,
            rotationPerSecond: '12deg',
            cameraOrbit: cameraOrbit,
            cameraTarget: cameraTarget,
            minCameraOrbit: 'auto auto 1.5m',
            maxCameraOrbit: 'auto auto 8m',
            minFieldOfView: '15deg',
            maxFieldOfView: '55deg',
            exposure: 1.05,
            shadowIntensity: .72,
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
            child: const Text(
              'REAL 3D · SKELETAL',
              style: TextStyle(
                color: NorieColors.cyan,
                fontSize: 8,
                letterSpacing: .8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const Positioned(
          right: 12,
          bottom: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xB3071227),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Text(
                'Open3Dmodel · CC BY-SA 4.0',
                style: TextStyle(
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
