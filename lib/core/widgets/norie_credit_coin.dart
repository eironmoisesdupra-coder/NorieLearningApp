import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'norie_logo_mark.dart';

/// Norie Credits visual token.
///
/// The idle animation intentionally borrows the readable motion language of a
/// floating game pickup: a slow Y-axis spin, gentle vertical bob, and a soft
/// ground shadow that compresses as the token rises.
class NorieCreditCoin extends StatefulWidget {
  const NorieCreditCoin({
    super.key,
    this.size = 24,
    this.animate = true,
  });

  final double size;
  final bool animate;

  @override
  State<NorieCreditCoin> createState() => _NorieCreditCoinState();
}

class _NorieCreditCoinState extends State<NorieCreditCoin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NorieCreditCoin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate == widget.animate) return;

    if (widget.animate) {
      _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return _CoinFace(size: widget.size);
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final turn = _controller.value * math.pi * 2;
          final wave = math.sin(turn);
          final bob = wave * widget.size * .09;
          final shadowScale = 1 - ((wave + 1) / 2 * .18);

          return SizedBox(
            width: widget.size * 1.35,
            height: widget.size * 1.45,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: widget.size * .02,
                  child: Transform.scale(
                    scaleX: shadowScale,
                    child: Container(
                      width: widget.size * .68,
                      height: widget.size * .14,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .22),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -widget.size * .05 + bob),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .0018)
                      ..rotateY(turn),
                    child: child,
                  ),
                ),
              ],
            ),
          );
        },
        child: _CoinFace(size: widget.size),
      ),
    );
  }
}

class _CoinFace extends StatelessWidget {
  const _CoinFace({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .085),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8CF7FF),
            Color(0xFF22D3EE),
            Color(0xFF4F46E5),
            Color(0xFFE879F9),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: .72),
          width: math.max(1, size * .045),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22D3EE).withValues(alpha: .22),
            blurRadius: size * .22,
          ),
          BoxShadow(
            color: const Color(0xFFE879F9).withValues(alpha: .18),
            blurRadius: size * .30,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(size * .08),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF07152F),
          border: Border.all(
            color: Colors.white.withValues(alpha: .16),
            width: math.max(.8, size * .028),
          ),
        ),
        child: ClipOval(
          child: NorieLogoMark(
            size: size * .67,
            showGlow: false,
          ),
        ),
      ),
    );
  }
}
