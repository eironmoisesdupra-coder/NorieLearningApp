import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/assets/norie_assets.dart';
import '../../../core/progression/norie_lesson_journey.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_foundation_curriculum.dart';
import '../domain/norie_content_models.dart';
import '../domain/norie_grade_map.dart';
import 'norie_lesson_screen.dart';

class NorieScienceAdventureMap extends StatefulWidget {
  const NorieScienceAdventureMap({
    required this.grade,
    required this.accent,
    super.key,
  });

  final NorieGradeLevel grade;
  final Color accent;

  @override
  State<NorieScienceAdventureMap> createState() =>
      _NorieScienceAdventureMapState();
}

class _NorieScienceAdventureMapState extends State<NorieScienceAdventureMap>
    with WidgetsBindingObserver {
  late final ScrollController _scrollController;
  Timer? _saveDebounce;
  bool _restored = false;
  late int _ownershipRevision;

  String get _positionKey => 'science.${widget.grade.id}';
  double? _pendingOffset;

  @override
  void initState() {
    super.initState();
    _ownershipRevision = NorieLessonJourney.instance.ownershipRevision;
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController()..addListener(_scheduleSave);
    WidgetsBinding.instance.addPostFrameCallback((_) => _restorePosition());
  }

  void _restorePosition() {
    if (!mounted || !_scrollController.hasClients) return;
    final journey = NorieLessonJourney.instance;
    final progress = NorieGradeMapProgress.derive(
      topics: NorieFoundationCurriculum.topicsFor('Science', widget.grade.id),
      completedTopicIds: NorieProgression.instance.completedTopicIds,
      lastTopicId: journey.lastTopicId,
    );
    final width = math.min(MediaQuery.sizeOf(context).width - 24, 736.0);
    final rowHeight = _rowHeight(context, width, progress.nodes);
    final saved = journey.mapOffsetFor(_positionKey);
    final target =
        (saved ?? math.max(0, progress.currentIndex * rowHeight - 50))
            .clamp(0.0, _scrollController.position.maxScrollExtent)
            .toDouble();
    _scrollController.jumpTo(target);
    _restored = true;
  }

  void _scheduleSave() {
    if (!_restored ||
        !_scrollController.hasClients ||
        _ownershipRevision != NorieLessonJourney.instance.ownershipRevision) {
      return;
    }
    _pendingOffset = _scrollController.offset;
    _saveDebounce?.cancel();
    // Capture values while this controller and grade still belong to the view.
    final key = _positionKey;
    final offset = _pendingOffset!;
    _saveDebounce = Timer(const Duration(milliseconds: 350), () {
      _pendingOffset = null;
      if (_ownershipRevision == NorieLessonJourney.instance.ownershipRevision) {
        unawaited(NorieLessonJourney.instance.saveMapOffset(key, offset));
      }
    });
  }

  void _flushPosition() {
    _saveDebounce?.cancel();
    final offset = _pendingOffset;
    _pendingOffset = null;
    if (offset != null &&
        _ownershipRevision == NorieLessonJourney.instance.ownershipRevision) {
      unawaited(
          NorieLessonJourney.instance.saveMapOffset(_positionKey, offset));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _flushPosition();
  }

  @override
  void didUpdateWidget(covariant NorieScienceAdventureMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grade.id == widget.grade.id) return;
    _saveDebounce?.cancel();
    final offset = _pendingOffset;
    if (offset != null &&
        _ownershipRevision == NorieLessonJourney.instance.ownershipRevision) {
      unawaited(NorieLessonJourney.instance
          .saveMapOffset('science.${oldWidget.grade.id}', offset));
    }
    _pendingOffset = null;
    _restored = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _restorePosition());
  }

  @override
  void dispose() {
    _flushPosition();
    WidgetsBinding.instance.removeObserver(this);
    _scrollController
      ..removeListener(_scheduleSave)
      ..dispose();
    super.dispose();
  }

  Future<void> _openDetails(
    NorieGradeMapNode node,
    NorieGradeMapProgress progress,
  ) async {
    final topic = node.topic;
    final journey = NorieLessonJourney.instance;
    final offset = journey.offsetFor(topic.id);
    NorieTopicContent? prerequisite;
    for (final candidate in progress.nodes) {
      if (candidate.topic.id == topic.prerequisiteTopicId) {
        prerequisite = candidate.topic;
      }
    }
    final action = node.completed
        ? 'Review'
        : journey.lastTopicId == topic.id && offset > 0
            ? 'Continue'
            : 'Start';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: NorieColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * .85),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _NodeBadge(
                      number: topic.order,
                      state: node.state,
                      accent: widget.accent,
                      compact: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mission ${topic.order} · ${widget.grade.label}',
                            style: const TextStyle(
                              color: NorieColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  topic.lesson.introduction,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoPill(
                      icon: node.completed
                          ? Icons.check_circle_rounded
                          : Icons.flag_rounded,
                      label: node.completed
                          ? 'Lesson completed'
                          : _AdventureTrail.stateLabel(node.state),
                    ),
                    _InfoPill(
                      icon: Icons.route_rounded,
                      label:
                          '${progress.completedCount}/${progress.nodes.length} missions complete',
                    ),
                    if (offset > 0 && !node.completed)
                      const _InfoPill(
                        icon: Icons.bookmark_rounded,
                        label: 'Reading position saved',
                      ),
                  ],
                ),
                if (!node.canOpen) ...[
                  const SizedBox(height: 12),
                  Text(prerequisite == null
                      ? 'This lesson is not available yet. Choose an available mission.'
                      : 'Prerequisite: ${prerequisite.title}. Complete that lesson first.'),
                  if (prerequisite?.available == true)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) =>
                                NorieLessonScreen(topic: prerequisite!)));
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Open prerequisite'),
                    ),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: node.canOpen
                        ? () {
                            Navigator.pop(sheetContext);
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => NorieLessonScreen(topic: topic),
                              ),
                            );
                          }
                        : null,
                    icon: Icon(
                      node.completed
                          ? Icons.replay_rounded
                          : action == 'Continue'
                              ? Icons.play_arrow_rounded
                              : Icons.rocket_launch_rounded,
                    ),
                    label: Text('$action mission'),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topics =
        NorieFoundationCurriculum.topicsFor('Science', widget.grade.id);
    return AnimatedBuilder(
      animation: Listenable.merge([
        NorieProgression.instance,
        NorieLessonJourney.instance,
      ]),
      builder: (context, _) {
        final progress = NorieGradeMapProgress.derive(
          topics: topics,
          completedTopicIds: NorieProgression.instance.completedTopicIds,
          lastTopicId: NorieLessonJourney.instance.lastTopicId,
        );
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = math.min(constraints.maxWidth - 24, 736.0);
            final rowHeight = _rowHeight(context, width, progress.nodes);
            final mapHeight = progress.nodes.length * rowHeight + 120;
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 36),
              child: Center(
                child: SizedBox(
                  width: width,
                  height: mapHeight,
                  child: _AdventureTrail(
                    nodes: progress.nodes,
                    rowHeight: rowHeight,
                    currentIndex: progress.currentIndex,
                    accent: widget.accent,
                    onNodeTap: (node) => _openDetails(node, progress),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

double _rowHeight(
    BuildContext context, double width, List<NorieGradeMapNode> nodes) {
  var height =
      math.max(200.0, 162 + MediaQuery.textScalerOf(context).scale(20));
  for (final node in nodes) {
    final painter = TextPainter(
      text: TextSpan(
          text:
              '${node.topic.title}\n${_AdventureTrail.stateLabel(node.state)}',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w800, height: 1.35)),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: math.max(80, width - 148));
    height = math.max(height, painter.height + 100);
    painter.dispose();
  }
  return height;
}

class _AdventureTrail extends StatelessWidget {
  const _AdventureTrail(
      {required this.nodes,
      required this.currentIndex,
      required this.accent,
      required this.onNodeTap,
      required this.rowHeight});
  final List<NorieGradeMapNode> nodes;
  final int currentIndex;
  final Color accent;
  final ValueChanged<NorieGradeMapNode> onNodeTap;
  final double rowHeight;

  static String stateLabel(NorieGradeMapNodeState state) => switch (state) {
        NorieGradeMapNodeState.completed => 'Lesson completed',
        NorieGradeMapNodeState.current => 'Current mission',
        NorieGradeMapNodeState.available => 'Available to explore',
        NorieGradeMapNodeState.locked => 'Not available yet',
      };

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final positions = [
          for (var i = 0; i < nodes.length; i++)
            Offset(
                i.isEven ? 56 : constraints.maxWidth - 56, 115 + i * rowHeight)
        ];
        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(children: [
            Positioned.fill(
                child: CustomPaint(
                    painter:
                        _TrailPainter(positions: positions, accent: accent))),
            const Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: _Landmark(
                    icon: Icons.wb_sunny_rounded, label: 'Science Basecamp')),
            Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: _Landmark(
                    icon: Icons.emoji_events_rounded,
                    label: 'Complete every lesson to earn your grade trophy',
                    accent: accent)),
            for (var i = 0; i < nodes.length; i++)
              Positioned(
                  top: 65 + i * rowHeight,
                  left: 12,
                  right: 12,
                  child: Semantics(
                    button: true,
                    label:
                        'Mission ${i + 1}, ${nodes[i].topic.title}, ${stateLabel(nodes[i].state)}',
                    child: InkWell(
                      key: ValueKey('map-node-${nodes[i].topic.id}'),
                      onTap: () => onNodeTap(nodes[i]),
                      borderRadius: BorderRadius.circular(20),
                      child: ExcludeSemantics(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection:
                            i.isEven ? TextDirection.ltr : TextDirection.rtl,
                        children: [
                          SizedBox(
                              width: 88,
                              child: Column(children: [
                                _NodeBadge(
                                    number: i + 1,
                                    state: nodes[i].state,
                                    accent: accent),
                                if (i == currentIndex) ...[
                                  Image.asset(NorieAssets.mascotBase,
                                      width: 58,
                                      height: 58,
                                      fit: BoxFit.contain),
                                  const Text('You are here',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ])),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: NorieColors.surface
                                          .withValues(alpha: .92),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color:
                                              accent.withValues(alpha: .28))),
                                  child: _NodeLabel(
                                      topic: nodes[i].topic,
                                      state: nodes[i].state,
                                      alignRight: i.isOdd))),
                        ],
                      )),
                    ),
                  )),
          ]),
        );
      });
}

class _NodeBadge extends StatelessWidget {
  const _NodeBadge({
    required this.number,
    required this.state,
    required this.accent,
    this.compact = false,
  });

  final int number;
  final NorieGradeMapNodeState state;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 46.0 : 84.0;
    final completed = state == NorieGradeMapNodeState.completed;
    final current = state == NorieGradeMapNodeState.current;
    final locked = state == NorieGradeMapNodeState.locked;
    final color = locked
        ? NorieColors.textSecondary
        : completed
            ? NorieColors.green
            : current
                ? accent
                : NorieColors.surfaceElevated;
    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: locked ? .18 : .95),
        border: Border.all(
          color: current ? Colors.white : color.withValues(alpha: .9),
          width: current ? 4 : 3,
        ),
        boxShadow: current
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: .35),
                  blurRadius: 24,
                  spreadRadius: 4,
                )
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: locked
          ? Icon(Icons.lock_rounded, size: compact ? 20 : 30)
          : completed
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.check_rounded, size: compact ? 22 : 34),
                  ],
                )
              : Text(
                  '$number',
                  style: TextStyle(
                    fontSize: compact ? 16 : 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
    );
  }
}

class _NodeLabel extends StatelessWidget {
  const _NodeLabel({
    required this.topic,
    required this.state,
    required this.alignRight,
  });

  final NorieTopicContent topic;
  final NorieGradeMapNodeState state;
  final bool alignRight;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            topic.title,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            switch (state) {
              NorieGradeMapNodeState.completed => 'Lesson completed',
              NorieGradeMapNodeState.current => 'Current mission',
              NorieGradeMapNodeState.available => 'Available to explore',
              NorieGradeMapNodeState.locked => 'Not available yet',
            },
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
}

class _TrailPainter extends CustomPainter {
  const _TrailPainter({required this.positions, required this.accent});

  final List<Offset> positions;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final backdrop = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF142B40), Color(0xFF123E37), Color(0xFF0B233A)],
      ).createShader(Offset.zero & size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(30)),
      backdrop,
    );

    // Original code-native night expedition: river, groves and field specimens.
    final river = Path()..moveTo(size.width * .48, 0);
    for (var y = 0.0; y < size.height; y += 120) {
      river.relativeCubicTo(-75, 35, 65, 85, 0, 120);
    }
    canvas.drawPath(
        river,
        Paint()
          ..color = const Color(0xFF235770)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 35);
    for (var i = 0; i < positions.length * 3; i++) {
      final x = (i.isEven ? .10 : .90) * size.width;
      final y = 185 + i * (size.height - 220) / (positions.length * 3);
      canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y + 12), width: 62, height: 22),
          Paint()..color = const Color(0xFF246149));
      canvas.drawLine(
          Offset(x, y),
          Offset(x, y - 25),
          Paint()
            ..color = const Color(0xFF8A7460)
            ..strokeWidth = 5);
      canvas.drawCircle(
          Offset(x, y - 30), 18, Paint()..color = const Color(0xFF347C58));
      canvas.drawCircle(
          Offset(x - 10, y - 20), 13, Paint()..color = const Color(0xFF409867));
      canvas.drawCircle(
          Offset(x + 10, y - 21), 14, Paint()..color = const Color(0xFF2E6C50));
      for (var j = 0; j < 3; j++) {
        canvas.drawCircle(Offset(x + j * 9 - 9, y + 14), 2,
            Paint()..color = accent.withValues(alpha: .6));
      }
    }

    if (positions.length < 2) return;
    final path = Path()..moveTo(positions.first.dx, positions.first.dy);
    for (var i = 1; i < positions.length; i++) {
      final previous = positions[i - 1];
      final next = positions[i];
      final middleY = (previous.dy + next.dy) / 2;
      path.cubicTo(
        previous.dx,
        middleY,
        next.dx,
        middleY,
        next.dx,
        next.dy,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFBCA77C)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 30,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFEEE0B7)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) =>
      oldDelegate.positions != positions || oldDelegate.accent != accent;
}

class _Landmark extends StatelessWidget {
  const _Landmark({
    required this.icon,
    required this.label,
    this.accent = NorieColors.cyan,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: NorieColors.surface.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: .32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: accent, size: 16),
            const SizedBox(width: 6),
            Flexible(
                child: Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
            )),
          ],
        ),
      );
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: NorieColors.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: NorieColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: NorieColors.cyan),
            const SizedBox(width: 6),
            Flexible(child: Text(label, style: const TextStyle(fontSize: 10))),
          ],
        ),
      );
}
