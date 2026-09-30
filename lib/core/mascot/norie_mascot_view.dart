import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../assets/norie_assets.dart';
import 'norie_cartoon_frames.dart';
import 'norie_mascot_controller.dart';
import 'norie_mascot_expression_painter.dart';
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
  late final AnimationController _frames = AnimationController(vsync: this);
  NorieMascotState? _lastState;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSequence(force: true);
  }

  @override
  void didUpdateWidget(covariant NorieMascotView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleController);
      widget.controller.addListener(_handleController);
      _lastState = null;
    }
    _syncSequence(force: true);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleController);
    _frames.dispose();
    super.dispose();
  }

  void _handleController() {
    if (!mounted) return;
    setState(() {});
    _syncSequence();
  }

  bool get _reduceMotion {
    final override = widget.reduceMotion;
    if (override != null) return override;
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  void _syncSequence({bool force = false}) {
    if (!mounted) return;
    final state = widget.controller.state;
    if (!force && state == _lastState) return;
    _lastState = state;

    final sequence = NorieCartoonSequence.forState(
      state,
      reduceMotion: _reduceMotion,
    );

    final milliseconds =
        sequence.frameDuration.inMilliseconds * sequence.frames.length;

    _frames
      ..stop()
      ..duration = Duration(
        milliseconds: math.max(milliseconds, 1),
      );

    if (_reduceMotion || sequence.frames.length <= 1) {
      _frames.value = 0;
    } else if (sequence.loop) {
      _frames.repeat();
    } else {
      _frames.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    if (state == NorieMascotState.hidden) {
      return SizedBox.square(dimension: widget.size);
    }

    final sequence = NorieCartoonSequence.forState(
      state,
      reduceMotion: _reduceMotion,
    );

    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _frames,
        builder: (context, _) {
          final frameCount = sequence.frames.length;
          final rawIndex = (_frames.value * frameCount).floor();
          final frameIndex = rawIndex.clamp(0, frameCount - 1);
          final frame = sequence.frames[frameIndex];
          final opacity = state == NorieMascotState.exiting
              ? (1 - _frames.value).clamp(0.0, 1.0)
              : 1.0;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              key: ValueKey('norie-cartoon-frame-${state.name}-$frameIndex'),
              offset: Offset(frame.dx, frame.dy),
              child: Transform.rotate(
                angle: frame.rotationTurns * math.pi * 2,
                child: Transform.scale(
                  scale: frame.scale,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _FullBodyFrame(
                        asset: frame.asset,
                      ),
                      IgnorePointer(
                        child: CustomPaint(
                          key: ValueKey(
                            'norie-expression-${_expressionKey(state)}',
                          ),
                          painter: NorieMascotExpressionPainter(
                            state: state,
                            progress: _frames.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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

class _FullBodyFrame extends StatelessWidget {
  const _FullBodyFrame({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      key: ValueKey('norie-full-body-frame-$asset'),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        if (asset == NorieAssets.mascotBase) {
          return const SizedBox.shrink();
        }
        return Image.asset(
          NorieAssets.mascotBase,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        );
      },
    );
  }
}
