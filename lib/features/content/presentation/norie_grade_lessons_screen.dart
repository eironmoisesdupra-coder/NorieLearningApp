import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_foundation_curriculum.dart';
import '../domain/norie_content_models.dart';
import 'norie_lesson_screen.dart';
import 'norie_science_adventure_map.dart';

class NorieGradeLessonsScreen extends StatefulWidget {
  const NorieGradeLessonsScreen({
    required this.subject,
    required this.grade,
    required this.accent,
    super.key,
  });

  final String subject;
  final NorieGradeLevel grade;
  final Color accent;

  @override
  State<NorieGradeLessonsScreen> createState() =>
      _NorieGradeLessonsScreenState();
}

class _NorieGradeLessonsScreenState extends State<NorieGradeLessonsScreen> {
  late bool _showMap;

  bool get _supportsMap => const ['science', 'mathematics', 'english']
      .contains(widget.subject.toLowerCase());

  @override
  void initState() {
    super.initState();
    _showMap = _supportsMap;
  }

  @override
  Widget build(BuildContext context) {
    final topics = NorieFoundationCurriculum.topicsFor(
      widget.subject,
      widget.grade.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} · ${widget.grade.label}'),
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton<NorieGradeLevel>(
            tooltip: 'Switch grade',
            icon: const Icon(Icons.swap_vert_rounded),
            onSelected: (grade) {
              if (grade.id == widget.grade.id) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => NorieGradeLessonsScreen(
                    subject: widget.subject,
                    grade: grade,
                    accent: widget.accent,
                  ),
                ),
              );
            },
            itemBuilder: (context) => [
              for (final grade in NorieFoundationCurriculum.gradeLevels)
                PopupMenuItem<NorieGradeLevel>(
                  value: grade,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 68,
                        child: Text(
                          grade.shortLabel,
                          style: TextStyle(
                            color: grade.id == widget.grade.id
                                ? widget.accent
                                : null,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Expanded(child: Text(grade.label)),
                      if (grade.id == widget.grade.id)
                        Icon(Icons.check_rounded, color: widget.accent),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.grade.label} ${widget.subject}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Explore ${NorieFoundationCurriculum.coverageLabel(widget.subject, widget.grade.id)}. '
                                  'This focused path is not a complete ${widget.grade.label} curriculum.',
                                  style: const TextStyle(
                                    color: NorieColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_supportsMap) ...[
                        const SizedBox(height: 8),
                        AnimatedBuilder(
                          animation: NorieProgression.instance,
                          builder: (context, _) {
                            final count = topics
                                .where((topic) => NorieProgression.instance
                                    .isTopicCompleted(topic.id))
                                .length;
                            return Text(
                              '$count/${topics.length} lessons completed',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w800),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          label: 'Choose ${widget.subject} journey view',
                          child: SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment<bool>(
                                value: true,
                                icon: Icon(Icons.route_rounded),
                                label: Text('Map'),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                icon: Icon(Icons.format_list_bulleted_rounded),
                                label: Text('List'),
                              ),
                            ],
                            selected: {_showMap},
                            onSelectionChanged: (selection) {
                              setState(() => _showMap = selection.first);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: _supportsMap && _showMap
                      ? NorieScienceAdventureMap(
                          subject: widget.subject,
                          grade: widget.grade,
                          accent: widget.accent,
                        )
                      : _LessonList(
                          topics: topics,
                          accent: widget.accent,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonList extends StatelessWidget {
  const _LessonList({required this.topics, required this.accent});

  final List<NorieTopicContent> topics;
  final Color accent;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: NorieProgression.instance,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 36),
          children: [
            for (final topic in topics) ...[
              _LessonTile(
                topic: topic,
                accent: accent,
                completed: NorieProgression.instance.isTopicCompleted(topic.id),
                onTap: topic.available
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => NorieLessonScreen(topic: topic),
                          ),
                        )
                    : null,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      );
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.topic,
    required this.accent,
    required this.completed,
    required this.onTap,
  });

  final NorieTopicContent topic;
  final Color accent;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(19),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: NorieColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: topic.available
                      ? Text(
                          '${topic.order}',
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : const Icon(Icons.lock_rounded, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        topic.subtitle,
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          NorieFoundationCurriculum.isAuthored(topic)
                              ? 'Authored lesson'
                              : 'Foundation starter',
                          style: TextStyle(
                              color: accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : topic.available
                          ? Icons.chevron_right_rounded
                          : Icons.lock_outline_rounded,
                  color: completed
                      ? NorieColors.green
                      : topic.available
                          ? accent
                          : NorieColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      );
}
