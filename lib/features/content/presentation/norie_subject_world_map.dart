import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/norie_subject_world.dart';
import 'norie_grade_lessons_screen.dart';

/// All navigation and completion evidence comes from the local curriculum.
class NorieSubjectWorldMap extends StatefulWidget {
  const NorieSubjectWorldMap({super.key});

  @override
  State<NorieSubjectWorldMap> createState() => _NorieSubjectWorldMapState();
}

class _NorieSubjectWorldMapState extends State<NorieSubjectWorldMap> {
  bool _showMap = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Subject World Map')),
        body: SafeArea(
          top: false,
          child: AnimatedBuilder(
            // Account restores and resets notify this same source. No cached
            // learner snapshot or delayed write can leak across accounts.
            animation: NorieProgression.instance,
            builder: (context, _) {
              final worlds = NorieSubjectWorld.build(
                  isCompleted: NorieProgression.instance.isTopicCompleted);
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
                    children: [
                      const Text('Your learning archipelago',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose an island, then a grade. Every path works offline. '
                        'Counts show completed authored lessons in the available paths.',
                        style: TextStyle(
                            color: NorieColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                                value: true,
                                icon: Icon(Icons.map_rounded),
                                label: Text('Map')),
                            ButtonSegment(
                                value: false,
                                icon: Icon(Icons.list_rounded),
                                label: Text('List')),
                          ],
                          selected: {_showMap},
                          onSelectionChanged: (value) =>
                              setState(() => _showMap = value.first),
                        ),
                      ),
                      const SizedBox(height: 24),
                      for (var index = 0; index < worlds.length; index++) ...[
                        if (index > 0 && _showMap)
                          const ExcludeSemantics(
                            child: SizedBox(
                                height: 36,
                                child: CustomPaint(painter: _IslandTrail())),
                          ),
                        Padding(
                          padding: _showMap &&
                                  MediaQuery.sizeOf(context).width >= 600
                              ? EdgeInsets.only(
                                  left: index.isOdd ? 64 : 0,
                                  right: index.isEven ? 64 : 0)
                              : EdgeInsets.zero,
                          child: _SubjectIsland(
                              world: worlds[index], map: _showMap),
                        ),
                        if (!_showMap) const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class _SubjectIsland extends StatelessWidget {
  const _SubjectIsland({required this.world, required this.map});
  final NorieSubjectWorld world;
  final bool map;

  @override
  Widget build(BuildContext context) {
    final (icon, accent) = switch (world.subject) {
      'Mathematics' => (Icons.calculate_rounded, NorieColors.primary),
      'Science' => (Icons.science_rounded, NorieColors.green),
      'English' => (Icons.menu_book_rounded, NorieColors.orange),
      'Filipino' => (Icons.translate_rounded, NorieColors.violet),
      _ => (Icons.public_rounded, NorieColors.cyan),
    };
    final pilot =
        world.subject == 'Filipino' || world.subject == 'Araling Panlipunan';
    final summary =
        '${world.completed}/${world.total} authored lessons completed';
    return Container(
      key: ValueKey('world-island-${world.subject}'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        gradient: map
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent.withValues(alpha: .17), NorieColors.surface])
            : null,
        borderRadius: BorderRadius.circular(map ? 30 : 18),
        border: Border.all(color: accent.withValues(alpha: .45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ExcludeSemantics(
                child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: accent.withValues(alpha: .18)),
              child: Icon(icon, color: accent, size: 28),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Semantics(
                      header: true,
                      child: Text(world.subject,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w900))),
                  const SizedBox(height: 4),
                  Text(pilot ? 'Grade 1 pilot' : 'Grade 1–College',
                      style: const TextStyle(color: NorieColors.textSecondary)),
                ])),
          ]),
          const SizedBox(height: 16),
          Text(summary, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ExcludeSemantics(
              child: LinearProgressIndicator(
            value: world.total == 0 ? 0 : world.completed / world.total,
            color: accent,
            backgroundColor: NorieColors.border,
            borderRadius: BorderRadius.circular(8),
            minHeight: 6,
          )),
          const SizedBox(height: 14),
          const Text('Choose a grade',
              style: TextStyle(color: NorieColors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final entry in world.grades)
              Semantics(
                label: '${world.subject}, ${entry.grade.label}, '
                    '${entry.completed} of ${entry.total} authored lessons completed',
                button: true,
                child: Tooltip(
                  message:
                      '${entry.grade.label}: ${entry.completed}/${entry.total} completed',
                  child: OutlinedButton(
                    key: ValueKey(
                        'world-grade-${world.subject}-${entry.grade.id}'),
                    onPressed: entry.total == 0
                        ? null
                        : () {
                            NorieProgression.instance
                                .recordSubjectExplored(world.subject);
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => NorieGradeLessonsScreen(
                                subject: world.subject,
                                grade: entry.grade,
                                accent: accent,
                              ),
                            ));
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      foregroundColor: NorieColors.textPrimary,
                    ),
                    child: Text(
                        '${entry.grade.shortLabel} · ${entry.completed}/${entry.total}'),
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}

class _IslandTrail extends CustomPainter {
  const _IslandTrail();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;
    final path = Path()
      ..moveTo(center - 14, 0)
      ..cubicTo(center - 14, 12, center + 14, 24, center + 14, size.height);
    canvas.drawPath(
        path,
        Paint()
          ..color = NorieColors.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    canvas.drawCircle(Offset(center, size.height / 2), 4,
        Paint()..color = NorieColors.cyan.withValues(alpha: .6));
  }

  @override
  bool shouldRepaint(covariant _IslandTrail oldDelegate) => false;
}
