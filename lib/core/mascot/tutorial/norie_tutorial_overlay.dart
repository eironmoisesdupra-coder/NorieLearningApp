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
            const Positioned.fill(
                child: ModalBarrier(
                    dismissible: false, color: Colors.transparent)),
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
            if (widget.coordinator.showingContents)
              _TutorialContents(coordinator: widget.coordinator)
            else
              _TutorialCard(
                step: step,
                current: widget.coordinator.currentIndex + 1,
                total: widget.coordinator.stepCount,
                isLast: widget.coordinator.isLastStep,
                onSkip: () => unawaited(widget.coordinator.skip()),
                onNext: () => unawaited(widget.coordinator.next()),
                onBack: widget.coordinator.currentIndex == 0
                    ? null
                    : widget.coordinator.previous,
                onContents: widget.coordinator.showContents,
                target: target,
                onFocus: () =>
                    unawaited(widget.coordinator.focusCurrentTarget()),
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
    required this.onBack,
    required this.onContents,
    required this.target,
    required this.onFocus,
  });

  final NorieTutorialStep step;
  final int current;
  final int total;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback onContents;
  final Rect? target;
  final VoidCallback onFocus;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final focusAbove = target != null && target!.center.dy > size.height * .55;
    final alignment = target == null
        ? Alignment.center
        : focusAbove
            ? (size.width >= 960 ? Alignment.topRight : Alignment.topCenter)
            : (size.width >= 960
                ? Alignment.bottomRight
                : Alignment.bottomCenter);
    final freeHeight = target == null
        ? size.height * .82
        : focusAbove
            ? target!.top - 28
            : size.height - target!.bottom - 28;
    final maximumHeight = target == null
        ? size.height * .82
        : freeHeight >= 240
            ? freeHeight.clamp(0.0, size.height * .65)
            : size.height * .55;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        minimum: const EdgeInsets.all(14),
        child: Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: target == null ? 620 : 500, maxHeight: maximumHeight),
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
                          Icons.explore_rounded,
                          color: NorieColors.cyan,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step.section.isEmpty ? 'Norie Guide' : step.section,
                            style: const TextStyle(
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
                    LinearProgressIndicator(
                      value: current / total,
                      minHeight: 3,
                      color: NorieColors.cyan,
                      backgroundColor: NorieColors.cyan.withValues(alpha: .12),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: SingleChildScrollView(
                        key: ValueKey('tutorial-text-${step.id}'),
                        child: Semantics(
                            liveRegion: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (step.location.isNotEmpty) ...[
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            size: 16, color: NorieColors.cyan),
                                        const SizedBox(width: 6),
                                        Expanded(
                                            child: Text(step.location,
                                                key: const ValueKey(
                                                    'tutorial-location'),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: NorieColors.cyan))),
                                      ]),
                                  const SizedBox(height: 8),
                                ],
                                Text(step.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 12),
                                Text(step.message,
                                    style: const TextStyle(
                                        color: NorieColors.textPrimary,
                                        height: 1.5,
                                        fontSize: 15)),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (target != null)
                          IconButton(
                              onPressed: onFocus,
                              tooltip: 'Focus area',
                              icon: const Icon(Icons.center_focus_strong)),
                        TextButton.icon(
                            onPressed: onContents,
                            icon: const Icon(Icons.list_rounded),
                            label: const Text('Contents')),
                        TextButton(
                          onPressed: onSkip,
                          child: const Text('Close'),
                        ),
                        IconButton(
                            onPressed: onBack,
                            tooltip: 'Previous step',
                            icon: const Icon(Icons.arrow_back_rounded)),
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
      ),
    );
  }
}

class _TutorialContents extends StatefulWidget {
  const _TutorialContents({required this.coordinator});
  final NorieTutorialCoordinator coordinator;

  @override
  State<_TutorialContents> createState() => _TutorialContentsState();
}

class _TutorialContentsState extends State<_TutorialContents> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final coordinator = widget.coordinator;
    final steps = coordinator.activeDefinition!.steps;
    final entries = steps.indexed
        .where((entry) =>
            '${entry.$2.section} ${entry.$2.title} ${entry.$2.message}'
                .toLowerCase()
                .contains(_query.trim().toLowerCase()))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
          minimum: const EdgeInsets.all(14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Material(
                key: const ValueKey('norie-tutorial-contents'),
                color: NorieColors.surface,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(children: [
                          const Expanded(
                              child: Text('App guide',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900))),
                          IconButton(
                              tooltip: 'Close guide',
                              onPressed: () => unawaited(coordinator.skip()),
                              icon: const Icon(Icons.close_rounded)),
                        ]),
                        Text(
                            '${NorieTutorialCatalog.chapters.length} chapters · ${steps.length} steps',
                            style: const TextStyle(
                                color: NorieColors.textSecondary)),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: const InputDecoration(
                              labelText: 'Search guide',
                              prefixIcon: Icon(Icons.search_rounded)),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                        const SizedBox(height: 12),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          FilledButton.icon(
                              onPressed: () => coordinator.goTo(0),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Start tutorial')),
                          TextButton(
                              onPressed: () =>
                                  coordinator.goTo(coordinator.currentIndex),
                              child: const Text('Continue guide')),
                        ]),
                        const SizedBox(height: 8),
                        entries.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                    'No matching guide topics. Try another word.'))
                            : ListView(
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  for (final chapter
                                      in NorieTutorialCatalog.chapters)
                                    if (entries.any((entry) =>
                                        entry.$2.section == chapter.title))
                                      if (_query.trim().isEmpty)
                                        ExpansionTile(
                                          key: PageStorageKey(
                                              'guide-${chapter.id}'),
                                          title: Text(chapter.title),
                                          subtitle: Text(
                                              '${chapter.steps.length} steps'),
                                          children: [
                                            for (final entry in entries.where(
                                                (entry) =>
                                                    entry.$2.section ==
                                                    chapter.title))
                                              ListTile(
                                                  title: Text(entry.$2.title),
                                                  leading: const Icon(
                                                      Icons.article_outlined),
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    coordinator.goTo(entry.$1);
                                                  })
                                          ],
                                        )
                                      else ...[
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 16, 16, 4),
                                            child: Text(chapter.title,
                                                style: const TextStyle(
                                                    color: NorieColors.cyan,
                                                    fontWeight:
                                                        FontWeight.w800))),
                                        for (final entry in entries.where(
                                            (entry) =>
                                                entry.$2.section ==
                                                chapter.title))
                                          ListTile(
                                              title: Text(entry.$2.title),
                                              leading: const Icon(
                                                  Icons.article_outlined),
                                              onTap: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                coordinator.goTo(entry.$1);
                                              }),
                                      ],
                                ],
                              ),
                      ],
                    )),
              ),
            ),
          )),
    );
  }
}

class NorieTutorialTarget extends StatefulWidget {
  const NorieTutorialTarget({
    required this.id,
    required this.child,
    this.onFocus,
    super.key,
  });

  final String id;
  final Widget child;
  final VoidCallback? onFocus;

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
    _coordinator?.registerTarget(widget.id, _targetKey,
        onFocus: widget.onFocus);
  }

  @override
  void didUpdateWidget(covariant NorieTutorialTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id == widget.id && oldWidget.onFocus == widget.onFocus) {
      return;
    }
    _coordinator?.unregisterTarget(oldWidget.id, _targetKey);
    _coordinator?.registerTarget(widget.id, _targetKey,
        onFocus: widget.onFocus);
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
    this.autoStart = true,
    super.key,
  });

  final NorieTutorialDefinition definition;
  final Widget child;
  final bool autoStart;

  @override
  State<NorieTutorialEntry> createState() => _NorieTutorialEntryState();
}

class _NorieTutorialEntryState extends State<NorieTutorialEntry> {
  String? _scheduledId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.autoStart) return;
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
    final coordinator = NorieMascotScope.maybeOf(context)?.tutorialCoordinator;

    return IconButton(
      onPressed: coordinator == null
          ? null
          : () => coordinator.browse(section: definition),
      tooltip: 'Tutorial & help',
      icon: const Icon(Icons.help_outline_rounded),
    );
  }
}
