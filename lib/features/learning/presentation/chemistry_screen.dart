import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../content/data/norie_content_repository.dart';
import '../../content/domain/norie_content_access.dart';
import '../../content/domain/norie_content_models.dart';
import '../../content/presentation/norie_content_theme.dart';
import '../../content/presentation/norie_topic_route.dart';

class ChemistryScreen extends StatefulWidget {
  const ChemistryScreen({super.key});

  @override
  State<ChemistryScreen> createState() => _ChemistryScreenState();
}

class _ChemistryScreenState extends State<ChemistryScreen> {
  late Future<List<NorieTopicContent>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
    NorieProgression.instance.addListener(_progressChanged);
  }

  @override
  void dispose() {
    NorieProgression.instance.removeListener(_progressChanged);
    super.dispose();
  }

  void _progressChanged() {
    if (mounted) setState(() {});
  }

  void _reload() {
    _topicsFuture = NorieContentRepositoryService.instance
        .getTopicsForCategory('chemistry');
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _topicsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final completed = NorieProgression.instance.completedTopicIds;

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
            child: FutureBuilder<List<NorieTopicContent>>(
              future: _topicsFuture,
              builder: (context, snapshot) {
                final topics =
                    snapshot.data ?? const <NorieTopicContent>[];

                if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                    topics.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (topics.isEmpty) {
                  return _EmptyCurriculum(onRetry: _refresh);
                }

                final completedInPath = topics
                    .where((topic) => completed.contains(topic.id))
                    .length;
                final pathProgress = completedInPath / topics.length;

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
                            color: NorieColors.violet
                                .withValues(alpha: .7),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CHEMISTRY',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.5,
                                color: Color(0xFFE9D5FF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Build understanding from atoms upward.',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 14),
                            LinearProgressIndicator(
                              value: pathProgress,
                              minHeight: 7,
                              borderRadius: BorderRadius.circular(99),
                              color: NorieColors.cyan,
                              backgroundColor:
                                  const Color(0x445B5CE2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$completedInPath / ${topics.length} topics completed',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFE9D5FF),
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Published curriculum · cloud-first with offline fallback',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFC4B5FD),
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
                      const SizedBox(height: 6),
                      const Text(
                        'Complete each topic to unlock the next lesson.',
                        style: TextStyle(
                          fontSize: 12,
                          color: NorieColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (var index = 0;
                          index < topics.length;
                          index++) ...[
                        _TopicCard(
                          topic: topics[index],
                          unlocked: NorieContentAccess.isUnlocked(
                            topics[index],
                            completed,
                          ),
                          completed:
                              completed.contains(topics[index].id),
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
                );
              },
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
    required this.unlocked,
    required this.completed,
    required this.onTap,
  });

  final NorieTopicContent topic;
  final bool unlocked;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = norieContentAccent(topic.accent);

    return Opacity(
      opacity: unlocked ? 1 : .55,
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
              border: Border.all(
                color: color.withValues(alpha: .4),
              ),
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
                  child: completed
                      ? Icon(
                          Icons.check_rounded,
                          color: color,
                          size: 25,
                        )
                      : Text(
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
                        completed
                            ? 'Completed · Review anytime'
                            : unlocked
                                ? 'Unlocked'
                                : 'Complete previous topic to unlock',
                        style: TextStyle(
                          fontSize: 11,
                          color: completed || unlocked
                              ? color
                              : NorieColors.textSecondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  completed
                      ? Icons.replay_rounded
                      : unlocked
                          ? Icons.chevron_right_rounded
                          : Icons.lock_rounded,
                  color: completed || unlocked
                      ? color
                      : NorieColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCurriculum extends StatelessWidget {
  const _EmptyCurriculum({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 46,
              color: NorieColors.textSecondary,
            ),
            const SizedBox(height: 14),
            const Text(
              'Chemistry curriculum could not be loaded.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
