import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/norie_theme.dart';
import '../norie_mascot_scope.dart';
import 'norie_tutorial_coordinator.dart';
import 'norie_tutorial_models.dart';

class NorieTutorialOverlay extends StatelessWidget {
  const NorieTutorialOverlay({
    required this.coordinator,
    super.key,
  });

  final NorieTutorialCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: coordinator,
      builder: (context, _) {
        final step = coordinator.currentStep;
        if (step == null) return const SizedBox.shrink();

        final target = coordinator.targetRect(step.targetId);

        return Stack(
          children: [
            const Positioned.fill(
              child: AbsorbPointer(
                key: ValueKey('norie-tutorial-input-lock'),
                absorbing: true,
                child: ColoredBox(
                  color: Color(0x42000000),
                ),
              ),
            ),
            if (target != null)
              Positioned.fromRect(
                rect: target.inflate(6),
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: NorieColors.cyan,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: NorieColors.cyan.withValues(alpha: .22),
                          blurRadius: 22,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            _TutorialCard(
              step: step,
              current: coordinator.currentIndex + 1,
              total: coordinator.stepCount,
              isLast: coordinator.isLastStep,
              onSkip: () => unawaited(coordinator.skip()),
              onNext: () => unawaited(coordinator.next()),
            ),
          ],
        );
      },
    );
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
  Widget build(BuildContext context) => widget.child;
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
