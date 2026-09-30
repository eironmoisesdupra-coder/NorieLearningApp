import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../assets/norie_assets.dart';
import 'norie_mascot_controller.dart';
import 'norie_mascot_expression_painter.dart';
import 'norie_mascot_motion.dart';
import 'norie_mascot_pose.dart';
import 'norie_mascot_state.dart';

class NorieMascotView extends StatefulWidget {
  const NorieMascotView({
    required this.controller,
    this.size = 144,
    this.reduceMotion,
    super.key,
  });

  final NorieMascotController controller;
  final double size;
  final bool? reduceMotion;

  @override
  State<NorieMascotView> createState() => _NorieMascotViewState();
}

class _NorieMascotViewState extends State<NorieMascotView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(vsync: this);
  NorieMascotState? _lastState;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion(force: true);
  }

  @override
  void didUpdateWidget(covariant NorieMascotView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleController);
      widget.controller.addListener(_handleController);
      _lastState = null;
    }
    _syncMotion(force: true);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleController);
    _motion.dispose();
    super.dispose();
  }

  void _handleController() {
    if (!mounted) return;
    setState(() {});
    _syncMotion();
  }

  bool get _reduceMotion {
    final override = widget.reduceMotion;
    if (override != null) return override;
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  void _syncMotion({bool force = false}) {
    if (!mounted) return;
    final state = widget.controller.state;
    if (!force && state == _lastState) return;
    _lastState = state;

    final spec = NorieMascotMotionSpec.forState(
      state,
      reduceMotion: _reduceMotion,
    );

    _motion
      ..stop()
      ..duration = spec.duration;

    if (_reduceMotion || !spec.loops) {
      _motion.forward(from: 0);
    } else {
      _motion.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    if (state == NorieMascotState.hidden) {
      return SizedBox.square(dimension: widget.size);
    }

    final spec = NorieMascotMotionSpec.forState(
      state,
      reduceMotion: _reduceMotion,
    );
    final pose = NorieMascotPoseSpec.forState(
      state,
      reduceMotion: _reduceMotion,
    );

    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _motion,
        builder: (context, child) {
          final raw = _motion.value;
          final wave = spec.loops
              ? Curves.easeInOut.transform(raw)
              : Curves.easeOutBack.transform(raw.clamp(0.0, 1.0));
          final oscillation = spec.loops
              ? math.sin(raw * math.pi * 2)
              : math.sin(raw * math.pi);

          final translateX = spec.translationX * oscillation;
          final translateY = -spec.translationY * wave;
          final scale = 1 + (spec.scaleDelta * wave);
          final turns = spec.rotationTurns * oscillation;

          final art = NorieMascotPoseSpec.usesArticulatedBase(state)
              ? _ArticulatedMascotSprite(
                  key: const ValueKey('norie-articulated-rig'),
                  asset: NorieAssets.mascotBase,
                  pose: pose,
                  wave: wave,
                  oscillation: oscillation,
                )
              : _MascotImage(asset: _assetForState(state));

          final animatedContent = Stack(
            fit: StackFit.expand,
            children: [
              art,
              IgnorePointer(
                child: CustomPaint(
                  key: ValueKey('norie-expression-${_expressionKey(state)}'),
                  painter: NorieMascotExpressionPainter(
                    state: state,
                    progress: raw,
                  ),
                ),
              ),
            ],
          );

          return Transform.translate(
            offset: Offset(translateX, translateY),
            child: Transform.rotate(
              angle: turns * math.pi * 2,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: state == NorieMascotState.exiting
                      ? (1 - raw).clamp(0.0, 1.0)
                      : raw == 0 && state == NorieMascotState.entering
                          ? 0
                          : 1,
                  child: animatedContent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _assetForState(NorieMascotState state) {
    return switch (state) {
      NorieMascotState.thinking ||
      NorieMascotState.searching => NorieAssets.mascotStudying,
      NorieMascotState.correct ||
      NorieMascotState.idea ||
      NorieMascotState.celebrating => NorieAssets.mascotCelebrating,
      _ => NorieAssets.mascotBase,
    };
  }

  String _expressionKey(NorieMascotState state) {
    return switch (state) {
      NorieMascotState.challenge => 'challenge',
      NorieMascotState.scared => 'scared',
      NorieMascotState.nervous => 'nervous',
      NorieMascotState.correct => 'correct',
      NorieMascotState.idea => 'idea',
      NorieMascotState.celebrating => 'celebrating',
      NorieMascotState.thinking => 'thinking',
      NorieMascotState.searching => 'searching',
      NorieMascotState.pointing => 'pointing',
      NorieMascotState.guiding => 'guiding',
      NorieMascotState.speaking => 'speaking',
      _ => 'neutral',
    };
  }
}

class _ArticulatedMascotSprite extends StatelessWidget {
  const _ArticulatedMascotSprite({
    required this.asset,
    required this.pose,
    required this.wave,
    required this.oscillation,
    super.key,
  });

  final String asset;
  final NorieMascotPoseSpec pose;
  final double wave;
  final double oscillation;

  @override
  Widget build(BuildContext context) {
    final leftPhase = .72 + (.28 * oscillation);
    final rightPhase = .82 + (.18 * oscillation);
    final headPhase = .68 + (.32 * oscillation);

    final leftAngle = pose.leftArmTurns * math.pi * 2 * leftPhase;
    final rightAngle = pose.rightArmTurns * math.pi * 2 * rightPhase;
    final headAngle = pose.headTurns * math.pi * 2 * headPhase;

    return Stack(
      fit: StackFit.expand,
      children: [
        _MascotPiece(
          asset: asset,
          clipper: const _BodyClipper(),
        ),
        Transform.rotate(
          key: const ValueKey('norie-head'),
          angle: headAngle,
          alignment: const Alignment(0, -.35),
          child: _MascotPiece(
            asset: asset,
            clipper: const _HeadClipper(),
          ),
        ),
        Transform.translate(
          offset: Offset(
            -2 * oscillation,
            -pose.leftArmLift * (.60 + (.40 * wave)),
          ),
          child: Transform.rotate(
            key: const ValueKey('norie-left-arm'),
            angle: leftAngle,
            alignment: const Alignment(-.28, -.12),
            child: _MascotPiece(
              asset: asset,
              clipper: const _LeftArmClipper(),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(
            3 * oscillation,
            -pose.rightArmLift * (.65 + (.35 * wave)),
          ),
          child: Transform.rotate(
            key: const ValueKey('norie-right-arm'),
            angle: rightAngle,
            alignment: const Alignment(.28, -.12),
            child: _MascotPiece(
              asset: asset,
              clipper: const _RightArmClipper(),
            ),
          ),
        ),
      ],
    );
  }
}

class _MascotPiece extends StatelessWidget {
  const _MascotPiece({
    required this.asset,
    required this.clipper,
  });

  final String asset;
  final CustomClipper<Path> clipper;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: clipper,
      child: _MascotImage(asset: asset),
    );
  }
}

class _MascotImage extends StatelessWidget {
  const _MascotImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        if (asset == NorieAssets.mascotBase) {
          return const SizedBox.shrink();
        }
        return Image.asset(
          NorieAssets.mascotBase,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _BodyClipper extends CustomClipper<Path> {
  const _BodyClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * .22, size.height * .38)
      ..lineTo(size.width * .78, size.height * .38)
      ..lineTo(size.width * .73, size.height)
      ..lineTo(size.width * .27, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _BodyClipper oldClipper) => false;
}

class _HeadClipper extends CustomClipper<Path> {
  const _HeadClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(
        Rect.fromLTWH(
          size.width * .08,
          0,
          size.width * .84,
          size.height * .55,
        ),
      );
  }

  @override
  bool shouldReclip(covariant _HeadClipper oldClipper) => false;
}

class _LeftArmClipper extends CustomClipper<Path> {
  const _LeftArmClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * .02, size.height * .27)
      ..lineTo(size.width * .44, size.height * .27)
      ..lineTo(size.width * .45, size.height * .73)
      ..lineTo(size.width * .03, size.height * .86)
      ..close();
  }

  @override
  bool shouldReclip(covariant _LeftArmClipper oldClipper) => false;
}

class _RightArmClipper extends CustomClipper<Path> {
  const _RightArmClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width * .56, size.height * .27)
      ..lineTo(size.width * .98, size.height * .27)
      ..lineTo(size.width * .97, size.height * .86)
      ..lineTo(size.width * .55, size.height * .73)
      ..close();
  }

  @override
  bool shouldReclip(covariant _RightArmClipper oldClipper) => false;
}
