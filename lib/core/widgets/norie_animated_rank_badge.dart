import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../assets/norie_assets.dart';
import '../progression/norie_progression.dart';

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

  static String assetForLevel(int level) =>
      NorieAssets.rankForTitle(titleForLevel(level));

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
                final crystalPhase = phase * 1.75 + .7;
                final wingPhase = phase * 2.2 + .3;
                final bookPhase = phase * 1.35 + 1.1;
                final auraPhase = phase * .85;
                final pulse = moving ? (math.sin(phase) + 1) / 2 : .32;
                final scale = moving
                    ? 1 + (0.006 + tier * 0.002) * math.sin(phase)
                    : 1.0;
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Backmost atmosphere is separate from the static PNG crest.
                    if (tier >= 3)
                      CustomPaint(
                        key: const ValueKey('rank-aura-layer'),
                        size: Size.square(widget.size),
                        painter: _RankAuraPainter(
                          tier: tier,
                          phase: moving ? auraPhase : 0,
                          moving: moving,
                        ),
                      ),
                    if (tier >= 2)
                      Transform.rotate(
                        angle: moving
                            ? _controller.value *
                                math.pi *
                                2 *
                                (tier == 2 ? .12 : .22)
                            : 0,
                        child: Container(
                          width: widget.size * .84,
                          height: widget.size * .84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.cyanAccent.withValues(
                                alpha: .10 + tier * .055 + .05 * pulse,
                              ),
                              width: tier >= 4 ? 2 : 1,
                            ),
                          ),
                        ),
                      ),
                    if (tier >= 3)
                      CustomPaint(
                        key: const ValueKey('rank-wing-layer'),
                        size: Size.square(widget.size),
                        painter: _RankMotifMotionPainter(
                          tier: tier,
                          wingPhase: moving ? wingPhase : 0,
                          bookPhase: moving ? bookPhase : 0,
                          moving: moving,
                          drawWings: true,
                        ),
                      ),
                    Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        NorieAnimatedRankBadge.assetForLevel(widget.level),
                        fit: BoxFit.contain,
                        width: widget.size,
                        height: widget.size,
                        gaplessPlayback: true,
                        cacheWidth: (widget.size *
                                MediaQuery.devicePixelRatioOf(context))
                            .ceil(),
                      ),
                    ),
                    // Foreground book glint and page motion do not move the PNG.
                    if (tier >= 3)
                      CustomPaint(
                        key: const ValueKey('rank-book-layer'),
                        size: Size.square(widget.size),
                        painter: _RankMotifMotionPainter(
                          tier: tier,
                          wingPhase: 0,
                          bookPhase: moving ? bookPhase : 0,
                          moving: moving,
                          drawWings: false,
                        ),
                      ),
                    CustomPaint(
                      key: const ValueKey('rank-crystal-layer'),
                      size: Size.square(widget.size),
                      painter: _RankCrystalPainter(
                        tier: tier,
                        phase: moving ? crystalPhase : 0,
                        moving: moving,
                      ),
                    ),
                    if (moving)
                      for (var i = 0; i < tier; i++)
                        Positioned(
                          left: widget.size *
                              (.18 + .62 * ((i + 1) / (tier + 1))),
                          top: widget.size *
                              (.16 + .52 * ((i.isEven ? 1 : 2) / 3)),
                          child: Opacity(
                            opacity: (.15 +
                                    .65 *
                                        ((math.sin(phase + i * 1.6) + 1) / 2))
                                .clamp(0.0, 1.0),
                            child: Icon(
                              Icons.auto_awesome,
                              size: widget.size * (.055 + tier * .006),
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

 
// Every painter uses normalized badge coordinates. The actual rank PNG stays
// intact; these decorative layers never change progression or saved rank IDs.
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
      final theta = phase * (i.isEven ? .68 : -.55) +
          i * (2 * math.pi / count);
      final distance = radius * (1.08 + .10 * math.sin(phase + i));
      final p = center + Offset(math.cos(theta), math.sin(theta)) * distance;
      canvas.drawCircle(
        p,
        size.width * (i.isEven ? .014 : .009),
        Paint()
          ..color = gold.withValues(
              alpha: moving ? .42 + .42 * ((math.sin(phase * 2 + i) + 1) / 2) : .32),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RankAuraPainter oldDelegate) =>
      tier != oldDelegate.tier ||
      phase != oldDelegate.phase ||
      moving != oldDelegate.moving;
}

class _RankCrystalPainter extends CustomPainter {
  const _RankCrystalPainter({
    required this.tier,
    required this.phase,
    required this.moving,
  });
  final int tier;
  final double phase;
  final bool moving;

  @override
  void paint(Canvas canvas, Size size) {
    // Crystal highlight occupies the crown at the top of each academic crest.
    final c = Offset(size.width * .5,
        size.height * (.225 + (moving ? .011 * math.sin(phase * .75) : 0)));
    final radius = size.width * (.033 + tier * .0045);
    final shimmer = moving ? (math.sin(phase) + 1) / 2 : .4;
    final color = tier >= 4 ? Colors.amberAccent : Colors.cyanAccent;
    canvas.drawCircle(
      c,
      radius * (1.9 + .35 * shimmer),
      Paint()
        ..color = color.withValues(alpha: .09 + .22 * shimmer)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.6),
    );
    final star = Path()
      ..moveTo(c.dx, c.dy - radius * 1.25)
      ..quadraticBezierTo(c.dx + radius * .25, c.dy - radius * .16,
          c.dx + radius * (1.1 + shimmer * .55), c.dy)
      ..quadraticBezierTo(c.dx + radius * .23, c.dy + radius * .15,
          c.dx, c.dy + radius * 1.25)
      ..quadraticBezierTo(c.dx - radius * .18, c.dy + radius * .14,
          c.dx - radius * 1.1, c.dy)
      ..quadraticBezierTo(c.dx - radius * .22, c.dy - radius * .16,
          c.dx, c.dy - radius * 1.25)
      ..close();
    canvas.drawPath(
      star,
      Paint()..color = Colors.white.withValues(alpha: .30 + shimmer * .65),
    );
    // An independent streak of light traverses the crystal, not the crest.
    final sweep = moving ? math.sin(phase * .85) : 0.0;
    canvas.drawLine(
      c + Offset(radius * sweep - radius * .3, -radius * .5),
      c + Offset(radius * sweep + radius * .3, radius * .5),
      Paint()
        ..color = Colors.white.withValues(alpha: .18 + .58 * shimmer)
        ..strokeWidth = math.max(.8, size.width * .012)
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RankCrystalPainter oldDelegate) =>
      tier != oldDelegate.tier ||
      phase != oldDelegate.phase ||
      moving != oldDelegate.moving;
}

class _RankMotifMotionPainter extends CustomPainter {
  const _RankMotifMotionPainter({
    required this.tier,
    required this.wingPhase,
    required this.bookPhase,
    required this.moving,
    required this.drawWings,
  });
  final int tier;
  final double wingPhase;
  final double bookPhase;
  final bool moving;
  final bool drawWings;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    if (drawWings) {
      // Wing feather arcs sweep independently left/right behind the crest.
      final flutter = moving ? math.sin(wingPhase) : 0.0;
      final color = tier == 4 ? Colors.amberAccent : Colors.cyanAccent;
      for (final sign in [-1.0, 1.0]) {
        for (var i = 0; i < (tier == 4 ? 4 : 2); i++) {
          final root = Offset(w * (.5 + sign * .19), w * (.50 + i * .025));
          final tip = Offset(
            w * (.5 + sign * (.33 + i * .047)),
            w * (.29 + i * .047 - flutter * (.028 + i * .007)),
          );
          final path = Path()
            ..moveTo(root.dx, root.dy)
            ..quadraticBezierTo(
              w * (.5 + sign * (.27 + i * .025)),
              w * (.31 + i * .033 - flutter * .025),
              tip.dx,
              tip.dy,
            );
          canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeWidth = w * (i == 0 ? .022 : .013)
              ..color = color.withValues(alpha: .37 - i * .045),
          );
        }
      }
      return;
    }

    // Stylized open-book page edges are layered over the PNG independently.
    final lift = moving ? math.sin(bookPhase) : 0.0;
    final glint = moving ? (math.sin(bookPhase + 1) + 1) / 2 : .35;
    final center = Offset(w * .5, w * .69);
    final color = tier == 4 ? Colors.amberAccent : Colors.cyanAccent;
    for (final side in [-1.0, 1.0]) {
      final path = Path()
        ..moveTo(center.dx, center.dy + w * .035)
        ..quadraticBezierTo(
          center.dx + side * w * .085,
          center.dy - w * (.012 + .022 * lift),
          center.dx + side * w * .22,
          center.dy - w * (.065 + .035 * lift),
        );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * .012
          ..strokeCap = StrokeCap.round
          ..color = color.withValues(alpha: .26 + .25 * glint),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RankMotifMotionPainter oldDelegate) =>
      tier != oldDelegate.tier ||
      wingPhase != oldDelegate.wingPhase ||
      bookPhase != oldDelegate.bookPhase ||
      moving != oldDelegate.moving ||
      drawWings != oldDelegate.drawWings;
}
