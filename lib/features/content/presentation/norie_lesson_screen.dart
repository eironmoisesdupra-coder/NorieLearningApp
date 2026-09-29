import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../domain/norie_content_models.dart';
import 'norie_content_theme.dart';
import 'norie_practice_mode_screen.dart';

class NorieLessonScreen extends StatelessWidget {
  const NorieLessonScreen({
    required this.topic,
    super.key,
  });

  final NorieTopicContent topic;

  @override
  Widget build(BuildContext context) {
    final accent = norieContentAccent(topic.accent);

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
              children: [
                Row(
                  children: [
                    _Badge(text: topic.category, color: NorieColors.violet),
                    const SizedBox(width: 8),
                    _Badge(
                      text: 'Lesson ${topic.order}',
                      color: accent,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  topic.lesson.heading,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.lesson.introduction,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.55,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                for (var index = 0;
                    index < topic.lesson.sections.length;
                    index++) ...[
                  _ConceptCard(section: topic.lesson.sections[index]),
                  if (index != topic.lesson.sections.length - 1)
                    const SizedBox(height: 12),
                ],
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131A35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accent.withValues(alpha: .7),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KEY CONCEPT',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.4,
                          color: accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        topic.lesson.keyConceptTitle,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.lesson.keyConceptBody,
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: topic.quiz.questions.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => NoriePracticeModeScreen(topic: topic),
                            ),
                          );
                        },
                  icon: const Icon(Icons.extension_rounded),
                  label: Text(
                    'Choose practice mode · ${topic.quiz.questions.length} items',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({required this.section});

  final NorieLessonSection section;

  @override
  Widget build(BuildContext context) {
    final color = norieContentAccent(section.accent);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Text(
              section.symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                ...section.points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '• $point',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
