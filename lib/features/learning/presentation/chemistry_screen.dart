import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../content/data/norie_content_catalog.dart';
import '../../content/domain/norie_content_models.dart';
import '../../content/presentation/norie_content_theme.dart';
import '../../content/presentation/norie_topic_route.dart';

class ChemistryScreen extends StatelessWidget {
  const ChemistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = NorieContentCatalog.chemistryTopics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemistry'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF312E81),
                        Color(0xFF5B21B6),
                        Color(0xFF701A75),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.violet.withValues(alpha: .7),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHEMISTRY',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          color: Color(0xFFE9D5FF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Build understanding from atoms upward.',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Each topic now uses the same Norie lesson, quiz, challenge, XP, and mastery engine.',
                        style: TextStyle(
                          color: Color(0xFFE9D5FF),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Learning path',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                for (var index = 0; index < topics.length; index++) ...[
                  _TopicCard(
                    topic: topics[index],
                    onTap: () => NorieTopicRoute.open(
                      context,
                      topics[index].id,
                    ),
                  ),
                  if (index != topics.length - 1)
                    const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.onTap,
  });

  final NorieTopicContent topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = norieContentAccent(topic.accent);
    final locked = !topic.available;

    return Opacity(
      opacity: locked ? .58 : 1,
      child: Material(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: .4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    topic.order.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: NorieColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locked ? 'Locked' : 'Continue',
                        style: TextStyle(
                          fontSize: 11,
                          color: locked
                              ? NorieColors.textSecondary
                              : color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  locked
                      ? Icons.lock_rounded
                      : Icons.chevron_right_rounded,
                  color: NorieColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
