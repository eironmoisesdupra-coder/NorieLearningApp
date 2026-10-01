import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_foundation_curriculum.dart';
import '../domain/norie_content_models.dart';
import 'norie_lesson_screen.dart';

class NorieGradeLessonsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('$subject · ${grade.label}'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
              children: [
                Text(
                  '${grade.label} $subject',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Five guided lessons with readable tutorials, visual models, worked examples, practice, and mastery checks. Complete them in order for the recommended path, or open any lesson to review.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                for (final topic in topics) ...[
                  _LessonTile(
                    topic: topic,
                    accent: accent,
                    completed:
                        NorieProgression.instance.isTopicCompleted(topic.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => NorieLessonScreen(topic: topic),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  final VoidCallback onTap;

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
                  child: Text(
                    '${topic.order}',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
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
                    ],
                  ),
                ),
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  color: completed ? NorieColors.green : accent,
                ),
              ],
            ),
          ),
        ),
      );
}
