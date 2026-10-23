import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../assets/norie_assets.dart';
import '../progression/norie_progression.dart';
import 'norie_rank_illustration.dart';

/// Animates a native Flutter academic badge. No GIF files or network needed.
/// Animation is disabled for accessibility, TickerMode, or [animate] = false.
class NorieAnimatedRankBadge extends StatefulWidget {
  const NorieAnimatedRankBadge({
    super.key,
    required this.level,
    this.size = 96,
    this.animate = true,
    this.semanticLabel,
  });

  final int level;
  final double size;
  final bool animate;
  final String? semanticLabel;

  static String titleForLevel(int level) =>
      NorieLevelSystem.titleForLevel(level);

  static String assetForLevel(int level) => NorieAssets.rankForLevel(level);

  static int tierForLevel(int level) {
    if (level >= 50) return 4;
    if (level >= 30) return 3;
    if (level >= 15) return 2;
    if (level >= 5) return 1;
    return 0;
  }

  @override
  State<NorieAnimatedRankBadge> createState() => _NorieAnimatedRankBadgeState();
}

class _NorieAnimatedRankBadgeState extends State<NorieAnimatedRankBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant NorieAnimatedRankBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMotion();
  }

  void _syncMotion() {
    final media = MediaQuery.maybeOf(context);
    final reduced = (media?.disableAnimations ?? false) ||
        (media?.accessibleNavigation ?? false);
    final enabled =
        widget.animate && !reduced && TickerMode.valuesOf(context).enabled;
    if (enabled) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tier = NorieAnimatedRankBadge.tierForLevel(widget.level);
    final label = widget.semanticLabel ??
        '${NorieAnimatedRankBadge.titleForLevel(widget.level)} rank';
    return Semantics(
      label: label,
      image: true,
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: SizedBox.square(
            dimension: widget.size,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final phase = _controller.value * math.pi * 2;
                final moving = _controller.isAnimating;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (tier >= 2)
                      CustomPaint(
                        key: const ValueKey('rank-aura-layer'),
                        size: Size.square(widget.size),
                        painter: _RankAuraPainter(
                          tier: tier,
                          phase: moving ? phase * .85 : 0,
                          moving: moving,
                        ),
                      ),
                    Transform.scale(
                      scale: moving ? 1 + .008 * math.sin(phase) : 1,
                      child: CustomPaint(
                        key: const ValueKey('rank-illustration-layer'),
                        size: Size.square(widget.size),
                        painter: NorieRankIllustrationPainter(
                          illustration: rankIllustrationForLevel(widget.level),
                          phase: moving ? phase : 0,
                          moving: moving,
                        ),
                      ),
                    ),
                    if (moving && tier >= 1)
                      Positioned(
                        right: widget.size * .14,
                        top: widget.size * .17,
                        child: Opacity(
                          opacity: .25 + .3 * ((math.sin(phase + 1) + 1) / 2),
                          child: Icon(
                            Icons.auto_awesome,
                            size: widget.size * .09,
                            color: tier >= 3
                                ? Colors.amberAccent
                                : Colors.cyanAccent,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _RankAuraPainter extends CustomPainter {
  const _RankAuraPainter({
    required this.tier,
    required this.phase,
    required this.moving,
  });
  final int tier;
  final double phase;
  final bool moving;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * (tier == 4 ? .44 : .40);
    final gold = tier == 4 ? Colors.amberAccent : Colors.cyanAccent;
    final breathe = moving ? math.sin(phase) : 0.0;
    canvas.drawCircle(
      center,
      radius * (1.05 + .035 * breathe),
      Paint()
        ..color = gold.withValues(alpha: tier == 4 ? .16 : .095)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * .11),
    );
    for (var ring = 0; ring < (tier == 4 ? 3 : 2); ring++) {
      final r = radius * (.87 + ring * .13 + .015 * breathe);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        phase * (ring.isEven ? 1 : -.7) + ring,
        tier == 4 ? math.pi * 1.28 : math.pi * .96,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * (ring == 0 ? .016 : .009)
          ..strokeCap = StrokeCap.round
          ..color = gold.withValues(alpha: .36 - ring * .075),
      );
    }
    final count = tier == 4 ? 10 : 6;
    for (var i = 0; i < count; i++) {
      final theta = phase * (i.isEven ? .68 : -.55) + i * (2 * math.pi / count);
      final distance = radius * (1.08 + .10 * math.sin(phase + i));
      final p = center + Offset(math.cos(theta), math.sin(theta)) * distance;
      canvas.drawCircle(
        p,
        size.width * (i.isEven ? .014 : .009),
        Paint()
          ..color = gold.withValues(
              alpha: moving
                  ? .42 + .42 * ((math.sin(phase * 2 + i) + 1) / 2)
                  : .32),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RankAuraPainter oldDelegate) =>
      tier != oldDelegate.tier ||
      phase != oldDelegate.phase ||
      moving != oldDelegate.moving;
}
