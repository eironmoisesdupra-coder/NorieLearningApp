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
                final t = _controller.value * math.pi * 2;
                final pulse = (math.sin(t) + 1) / 2;
                final scale = 1 + (0.006 + tier * 0.002) * math.sin(t);
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    if (tier >= 2)
                      Transform.rotate(
                        angle: _controller.value *
                            math.pi *
                            2 *
                            (tier == 2 ? .12 : .22),
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
                    if (tier >= 3 && _controller.isAnimating)
                      Transform.rotate(
                        angle: t,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Icon(Icons.auto_awesome,
                              size: widget.size * .09,
                              color: tier == 4
                                  ? Colors.amberAccent
                                  : Colors.cyanAccent),
                        ),
                      ),
                    Transform.scale(
                      scale: _controller.isAnimating ? scale : 1,
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
                    if (_controller.isAnimating) ...[
                      Positioned(
                        top: widget.size * .19,
                        child: Container(
                          width: widget.size * (.07 + tier * .008),
                          height: widget.size * (.07 + tier * .008),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                                alpha: .13 + pulse * (.18 + tier * .10)),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withValues(
                                    alpha: pulse * (.10 + tier * .10)),
                                blurRadius: widget.size * (.07 + tier * .015),
                              )
                            ],
                          ),
                        ),
                      ),
                      for (var i = 0; i < tier; i++)
                        Positioned(
                          left: widget.size *
                              (.18 + .62 * ((i + 1) / (tier + 1))),
                          top: widget.size *
                              (.16 + .52 * ((i.isEven ? 1 : 2) / 3)),
                          child: Opacity(
                            opacity:
                                (.15 + .65 * ((math.sin(t + i * 1.6) + 1) / 2))
                                    .clamp(0.0, 1.0),
                            child: Icon(Icons.auto_awesome,
                                size: widget.size * (.055 + tier * .006),
                                color: tier >= 3
                                    ? Colors.amberAccent
                                    : Colors.cyanAccent),
                          ),
                        ),
                    ],
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
