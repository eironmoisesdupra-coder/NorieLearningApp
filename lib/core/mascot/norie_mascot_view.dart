import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../assets/norie_assets.dart';
import 'norie_mascot_controller.dart';
import 'norie_mascot_expression_painter.dart';
import 'norie_mascot_motion.dart';
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
                  child: child,
                ),
              ),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Image.asset(
                _assetForState(state),
                key: ValueKey(_assetForState(state)),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  if (_assetForState(state) == NorieAssets.mascotBase) {
                    return const SizedBox.shrink();
                  }
                  return Image.asset(
                    NorieAssets.mascotBase,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  );
                },
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                key: ValueKey('norie-expression-${_expressionKey(state)}'),
                painter: NorieMascotExpressionPainter(
                  state: state,
                  progress: _motion.value,
                ),
              ),
            ),
          ],
        ),
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
      _ => 'neutral',
    };
  }
}
