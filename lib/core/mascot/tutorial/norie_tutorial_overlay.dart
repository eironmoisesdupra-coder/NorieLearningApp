import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/norie_theme.dart';
import '../norie_mascot_scope.dart';
import 'norie_tutorial_coordinator.dart';
import 'norie_tutorial_models.dart';

class NorieTutorialOverlay extends StatefulWidget {
  const NorieTutorialOverlay({
    required this.coordinator,
    super.key,
  });

  final NorieTutorialCoordinator coordinator;

  @override
  State<NorieTutorialOverlay> createState() => _NorieTutorialOverlayState();
}

class _NorieTutorialOverlayState extends State<NorieTutorialOverlay>
    with SingleTickerProviderStateMixin {
  late final Ticker _trackingTicker = createTicker(_trackTarget);
  Rect? _trackedTarget;

  @override
  void initState() {
    super.initState();
    widget.coordinator.addListener(_handleCoordinator);
    _handleCoordinator();
  }

  @override
  void didUpdateWidget(covariant NorieTutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.coordinator, widget.coordinator)) return;
    oldWidget.coordinator.removeListener(_handleCoordinator);
    widget.coordinator.addListener(_handleCoordinator);
    _trackedTarget = null;
    _handleCoordinator();
  }

  @override
  void dispose() {
    widget.coordinator.removeListener(_handleCoordinator);
    _trackingTicker.dispose();
    super.dispose();
  }

  void _handleCoordinator() {
    if (!mounted) return;

    if (widget.coordinator.isActive) {
      if (!_trackingTicker.isActive) _trackingTicker.start();
      _syncTarget();
    } else {
      _trackingTicker.stop();
      if (_trackedTarget != null) {
        setState(() => _trackedTarget = null);
      }
    }
  }

  void _trackTarget(Duration _) {
    if (!widget.coordinator.isActive) return;
    _syncTarget();
  }

  void _syncTarget() {
    final step = widget.coordinator.currentStep;
    final next = widget.coordinator.targetRect(step?.targetId);
    if (next == _trackedTarget) return;
    if (!mounted) return;
    setState(() => _trackedTarget = next);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.coordinator,
      builder: (context, _) {
        final step = widget.coordinator.currentStep;
        if (step == null) return const SizedBox.shrink();

        final target =
            _trackedTarget ?? widget.coordinator.targetRect(step.targetId);

        return Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  key: const ValueKey('norie-tutorial-live-spotlight'),
                  painter: _TutorialSpotlightPainter(
                    target: target?.inflate(7),
                  ),
                ),
              ),
            ),
            if (target != null)
              Positioned.fromRect(
                rect: target.inflate(6),
                child: IgnorePointer(
                  child: AnimatedContainer(
                    key: const ValueKey('norie-tutorial-target-highlight'),
                    duration: const Duration(milliseconds: 80),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: NorieColors.cyan.withValues(alpha: .07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: NorieColors.cyan,
                        width: 2.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: NorieColors.cyan.withValues(alpha: .30),
                          blurRadius: 24,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            _TutorialCard(
              step: step,
              current: widget.coordinator.currentIndex + 1,
              total: widget.coordinator.stepCount,
              isLast: widget.coordinator.isLastStep,
              onSkip: () => unawaited(widget.coordinator.skip()),
              onNext: () => unawaited(widget.coordinator.next()),
            ),
          ],
        );
      },
    );
  }
}

class _TutorialSpotlightPainter extends CustomPainter {
  const _TutorialSpotlightPainter({required this.target});

  final Rect? target;

  @override
  void paint(Canvas canvas, Size size) {
    final full = Offset.zero & size;
    final path = Path()..fillType = PathFillType.evenOdd;
    path.addRect(full);

    final hole = target;
    if (hole != null) {
      path.addRRect(
        RRect.fromRectAndRadius(
          hole,
          const Radius.circular(18),
        ),
      );
    }

    canvas.drawPath(
      path,
      Paint()..color = const Color(0x78020A18),
    );
  }

  @override
  bool shouldRepaint(covariant _TutorialSpotlightPainter oldDelegate) {
    return oldDelegate.target != target;
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.step,
    required this.current,
    required this.total,
    required this.isLast,
    required this.onSkip,
    required this.onNext,
  });

  final NorieTutorialStep step;
  final int current;
  final int total;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final alignment = switch (step.preferredPosition) {
      NorieTutorialPosition.top => Alignment.topCenter,
      NorieTutorialPosition.left => Alignment.centerLeft,
      NorieTutorialPosition.right => Alignment.centerRight,
      NorieTutorialPosition.bottom || NorieTutorialPosition.auto =>
        Alignment.bottomCenter,
    };

    return SafeArea(
      minimum: const EdgeInsets.all(14),
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Material(
            key: const ValueKey('norie-tutorial-card'),
            color: const Color(0xF20C1730),
            elevation: 10,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: NorieColors.cyan.withValues(alpha: .34),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: NorieColors.cyan,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Norie Guide',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '$current / $total',
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    step.message,
                    style: const TextStyle(
                      color: NorieColors.textPrimary,
                      height: 1.4,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onSkip,
                        child: const Text('Skip'),
                      ),
                      const SizedBox(width: 6),
                      FilledButton(
                        onPressed: onNext,
                        style: FilledButton.styleFrom(
                          backgroundColor: NorieColors.cyan,
                          foregroundColor: NorieColors.background,
                        ),
                        child: Text(isLast ? 'Done' : 'Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NorieTutorialTarget extends StatefulWidget {
  const NorieTutorialTarget({
    required this.id,
    required this.child,
    super.key,
  });

  final String id;
  final Widget child;

  @override
  State<NorieTutorialTarget> createState() => _NorieTutorialTargetState();
}

class _NorieTutorialTargetState extends State<NorieTutorialTarget> {
  final GlobalKey _targetKey = GlobalKey();
  NorieTutorialCoordinator? _coordinator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = NorieMascotScope.maybeOf(context)?.tutorialCoordinator;
    if (identical(next, _coordinator)) return;
    _coordinator?.unregisterTarget(widget.id, _targetKey);
    _coordinator = next;
    _coordinator?.registerTarget(widget.id, _targetKey);
  }

  @override
  void didUpdateWidget(covariant NorieTutorialTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id == widget.id) return;
    _coordinator?.unregisterTarget(oldWidget.id, _targetKey);
    _coordinator?.registerTarget(widget.id, _targetKey);
  }

  @override
  void dispose() {
    _coordinator?.unregisterTarget(widget.id, _targetKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _targetKey,
      child: widget.child,
    );
  }
}

class NorieTutorialEntry extends StatefulWidget {
  const NorieTutorialEntry({
    required this.definition,
    required this.child,
    super.key,
  });

  final NorieTutorialDefinition definition;
  final Widget child;

  @override
  State<NorieTutorialEntry> createState() => _NorieTutorialEntryState();
}

class _NorieTutorialEntryState extends State<NorieTutorialEntry> {
  String? _scheduledId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduledId == widget.definition.id) return;
    _scheduledId = widget.definition.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final coordinator =
          NorieMascotScope.maybeOf(context)?.tutorialCoordinator;
      if (coordinator != null) {
        unawaited(coordinator.startIfNeeded(widget.definition));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final coordinator =
              NorieMascotScope.maybeOf(context)?.tutorialCoordinator;
          coordinator?.handleTutorialScrollEnd();
        }
        return false;
      },
      child: widget.child,
    );
  }
}

class NorieTutorialReplayButton extends StatelessWidget {
  const NorieTutorialReplayButton({
    required this.definition,
    super.key,
  });

  final NorieTutorialDefinition definition;

  @override
  Widget build(BuildContext context) {
    final coordinator =
        NorieMascotScope.maybeOf(context)?.tutorialCoordinator;

    return IconButton(
      onPressed: coordinator == null
          ? null
          : () => unawaited(coordinator.replay(definition)),
      tooltip: 'Replay Tutorial',
      icon: const Icon(Icons.help_outline_rounded),
    );
  }
}
