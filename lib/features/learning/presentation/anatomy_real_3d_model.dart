import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

import '../../../core/theme/norie_theme.dart';

abstract final class Anatomy3DAssets {
  static const model = 'assets/anatomy/overview-skeleton.glb';
}

class AnatomyReal3DModel extends StatefulWidget {
  const AnatomyReal3DModel({required this.controller, super.key});

  final Flutter3DController controller;

  @override
  State<AnatomyReal3DModel> createState() => _AnatomyReal3DModelState();
}

class _AnatomyReal3DModelState extends State<AnatomyReal3DModel> {
  double _progress = 0;
  bool _loaded = false;
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Flutter3DViewer(
            activeGestureInterceptor: true,
            progressBarColor: NorieColors.cyan,
            enableTouch: true,
            controller: widget.controller,
            src: Anatomy3DAssets.model,
            onProgress: (value) {
              if (mounted) setState(() => _progress = value.clamp(0.0, 1.0).toDouble());
            },
            onLoad: (_) {
              if (mounted) setState(() {
                _loaded = true;
                _failed = false;
                _progress = 1;
              });
            },
            onError: (_) {
              if (mounted) setState(() {
                _loaded = false;
                _failed = true;
              });
            },
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
              border: Border.all(color: NorieColors.cyan.withValues(alpha: .42)),
            ),
            child: Text(
              _loaded ? 'REAL 3D · SKELETAL' : 'LOADING 3D',
              style: const TextStyle(
                color: NorieColors.cyan,
                fontSize: 8,
                letterSpacing: .8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        if (!_loaded && !_failed)
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: LinearProgressIndicator(
              value: _progress <= 0 ? null : _progress,
              minHeight: 5,
              borderRadius: BorderRadius.circular(99),
              color: NorieColors.cyan,
              backgroundColor: NorieColors.surfaceElevated,
            ),
          ),
        if (_failed)
          const Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Text(
              'The high-detail 3D anatomy model could not load.',
              textAlign: TextAlign.center,
              style: TextStyle(color: NorieColors.textSecondary, fontSize: 10),
            ),
          ),
        const Positioned(
          right: 12,
          bottom: 12,
          child: Text(
            'Open3Dmodel · CC BY-SA 4.0',
            style: TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 7.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
