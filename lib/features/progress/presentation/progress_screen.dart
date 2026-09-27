import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: NorieProgression.instance,
          builder: (context, _) {
            final snapshot = NorieProgression.instance.snapshot;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF172554),
                            Color(0xFF312E81),
                            Color(0xFF4C1D95),
                          ],
                        ),
                        border: Border.all(
                          color: NorieColors.violet.withValues(alpha: .65),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT LEVEL',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.4,
                              color: NorieColors.textSecondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Level ${snapshot.level} · ${snapshot.title}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.totalXp} total XP',
                            style: const TextStyle(
                              color: NorieColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          LinearProgressIndicator(
                            value: snapshot.progress,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(99),
                            color: NorieColors.cyan,
                            backgroundColor: const Color(0x33475569),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            snapshot.isMaxLevel
                                ? 'Master rank reached'
                                : '${snapshot.xpIntoLevel} / ${snapshot.xpRequiredForNextLevel} XP toward Level ${snapshot.level + 1}',
                            style: const TextStyle(
                              color: NorieColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Rank journey',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _RankRow(
                      level: 1,
                      title: 'Explorer',
                      icon: Icons.explore_rounded,
                    ),
                    const _RankRow(
                      level: 5,
                      title: 'Curious Mind',
                      icon: Icons.psychology_rounded,
                    ),
                    const _RankRow(
                      level: 15,
                      title: 'Scholar',
                      icon: Icons.school_rounded,
                    ),
                    const _RankRow(
                      level: 30,
                      title: 'Specialist',
                      icon: Icons.workspace_premium_rounded,
                    ),
                    const _RankRow(
                      level: 50,
                      title: 'Master',
                      icon: Icons.diamond_rounded,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.level,
    required this.title,
    required this.icon,
  });

  final int level;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final currentLevel = NorieProgression.instance.snapshot.level;
    final unlocked = currentLevel >= level;
    final current = NorieLevelSystem.titleForLevel(currentLevel) == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: current
              ? NorieColors.violet.withValues(alpha: .12)
              : NorieColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: current
                ? NorieColors.violet
                : unlocked
                    ? NorieColors.cyan.withValues(alpha: .45)
                    : NorieColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              unlocked ? icon : Icons.lock_rounded,
              color: unlocked
                  ? (current ? NorieColors.violet : NorieColors.cyan)
                  : NorieColors.textSecondary,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Unlocks at Level $level',
                    style: const TextStyle(
                      fontSize: 11,
                      color: NorieColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (current)
              const Text(
                'CURRENT',
                style: TextStyle(
                  fontSize: 10,
                  color: NorieColors.violet,
                  fontWeight: FontWeight.w900,
                ),
              )
            else if (unlocked)
              const Icon(
                Icons.check_circle_rounded,
                color: NorieColors.green,
              ),
          ],
        ),
      ),
    );
  }
}
