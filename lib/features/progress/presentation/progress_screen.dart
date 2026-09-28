import 'package:flutter/material.dart';

import '../../../core/assets/norie_assets.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../navigation/presentation/norie_drawer.dart';
import 'weak_topics_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({
    super.key,
    this.embedded = false,
    this.onTabSelected,
  });

  final bool embedded;
  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NorieDrawer(
        selectedSection: NorieDrawerSection.progress,
        onTabSelected: onTabSelected,
      ),
      drawerEdgeDragWidth: 48,
      appBar: embedded
          ? null
          : AppBar(
              title: const Text('Progress'),
              backgroundColor: Colors.transparent,
              leading: Builder(
                builder: (drawerContext) => IconButton(
                  onPressed: () => Scaffold.of(drawerContext).openDrawer(),
                  tooltip: 'Open menu',
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
            ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: NorieAmbientBackdrop(
              primary: NorieColors.violet,
              secondary: NorieColors.cyan,
            ),
          ),
          SafeArea(
            top: false,
            child: AnimatedBuilder(
          animation: NorieProgression.instance,
          builder: (context, _) {
            final snapshot = NorieProgression.instance.snapshot;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  children: [
                    if (embedded)
                      Builder(
                        builder: (drawerContext) => Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  Scaffold.of(drawerContext).openDrawer(),
                              tooltip: 'Open menu',
                              style: IconButton.styleFrom(
                                backgroundColor: NorieColors.surface,
                                side: const BorderSide(
                                  color: NorieColors.border,
                                ),
                              ),
                              icon: const Icon(Icons.menu_rounded),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (embedded) const SizedBox(height: 22),
                    _CurrentRankCard(snapshot: snapshot),
                    const SizedBox(height: 14),
                    _ProgressPulse(
                      streak: NorieProgression.instance.currentStreak,
                      accuracy: NorieProgression.instance.questionsAnswered == 0
                          ? null
                          : (NorieProgression.instance.quizAccuracy * 100).round(),
                      mastered: NorieProgression.instance.masteredTopicCount,
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Rank journey',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Keep learning to unlock the next Norie rank.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _RankRow(
                      level: 1,
                      title: 'Explorer',
                      asset: NorieAssets.rankExplorer,
                    ),
                    const _RankRow(
                      level: 5,
                      title: 'Curious Mind',
                      asset: NorieAssets.rankCuriousMind,
                    ),
                    const _RankRow(
                      level: 15,
                      title: 'Scholar',
                      asset: NorieAssets.rankScholar,
                    ),
                    const _RankRow(
                      level: 30,
                      title: 'Specialist',
                      asset: NorieAssets.rankSpecialist,
                    ),
                    const _RankRow(
                      level: 50,
                      title: 'Master',
                      asset: NorieAssets.rankMaster,
                    ),
                    const SizedBox(height: 26),
                    _MasterySummaryCard(
                      progression: NorieProgression.instance,
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Achievements',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${NorieProgression.instance.unlockedAchievementCount} / 4 unlocked',
                          style: TextStyle(
                            color: NorieColors.cyan.withValues(alpha: .9),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your learning milestones now use the official Norie 3D badge set.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _AchievementsGrid(
                      achievements: NorieProgression.instance.achievements,
                    ),
                  ],
                ),
              ),
            );
          },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPulse extends StatelessWidget {
  const _ProgressPulse({
    required this.streak,
    required this.accuracy,
    required this.mastered,
  });

  final int streak;
  final int? accuracy;
  final int mastered;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final cards = [
          _PulseTile(
            icon: Icons.local_fire_department_rounded,
            value: '$streak',
            label: 'day streak',
            color: NorieColors.orange,
          ),
          _PulseTile(
            icon: Icons.analytics_rounded,
            value: accuracy == null ? '—' : '$accuracy%',
            label: 'accuracy',
            color: NorieColors.green,
          ),
          _PulseTile(
            icon: Icons.psychology_alt_rounded,
            value: '$mastered',
            label: 'mastered',
            color: NorieColors.cyan,
          ),
        ];

        if (compact) {
          return Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                Expanded(child: cards[i]),
                if (i != cards.length - 1) const SizedBox(width: 8),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
}

class _PulseTile extends StatelessWidget {
  const _PulseTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: .12),
            NorieColors.surface.withValues(alpha: .90),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentRankCard extends StatelessWidget {
  const _CurrentRankCard({required this.snapshot});

  final NorieLevelSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10204A),
            Color(0xFF2B236E),
            Color(0xFF4A1B68),
          ],
        ),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .65),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335B5CE2),
            blurRadius: 34,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 92,
                height: 92,
                child: Image.asset(
                  NorieAssets.rankForTitle(snapshot.title),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CURRENT RANK',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.3,
                        color: NorieColors.textSecondary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Level ${snapshot.level} · ${snapshot.title}',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${snapshot.totalXp} total XP',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: snapshot.progress,
            minHeight: 9,
            borderRadius: BorderRadius.circular(99),
            color: NorieColors.cyan,
            backgroundColor: const Color(0x33475569),
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              snapshot.isMaxLevel
                  ? 'Master rank reached'
                  : '${snapshot.xpIntoLevel} / ${snapshot.xpRequiredForNextLevel} XP toward Level ${snapshot.level + 1}',
              style: const TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!snapshot.isMaxLevel && snapshot.nextRankTitle != null) ...[
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Next rank: ${snapshot.nextRankTitle} at Level ${snapshot.nextRankLevel}',
                style: const TextStyle(
                  color: NorieColors.violet,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.level,
    required this.title,
    required this.asset,
  });

  final int level;
  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final currentLevel = NorieProgression.instance.snapshot.level;
    final unlocked = currentLevel >= level;
    final current = NorieLevelSystem.titleForLevel(currentLevel) == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: current
              ? NorieColors.violet.withValues(alpha: .11)
              : NorieColors.surface,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: current
                ? NorieColors.violet
                : unlocked
                    ? NorieColors.cyan.withValues(alpha: .4)
                    : NorieColors.border,
          ),
        ),
        child: Row(
          children: [
            Opacity(
              opacity: unlocked ? 1 : .28,
              child: SizedBox(
                width: 62,
                height: 62,
                child: Image.asset(asset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    unlocked
                        ? 'Unlocked at Level $level'
                        : 'Unlocks at Level $level',
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
                  fontSize: 9,
                  color: NorieColors.violet,
                  fontWeight: FontWeight.w900,
                ),
              )
            else if (unlocked)
              const Icon(
                Icons.check_circle_rounded,
                color: NorieColors.green,
              )
            else
              const Icon(
                Icons.lock_rounded,
                color: NorieColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  const _AchievementsGrid({required this.achievements});

  final List<NorieAchievement> achievements;

  static String _assetFor(NorieAchievementId id) {
    return switch (id) {
      NorieAchievementId.sevenDayStreak => NorieAssets.achievementStreak,
      NorieAchievementId.lessonMaster => NorieAssets.achievementLessonMaster,
      NorieAchievementId.subjectExplorer =>
        NorieAssets.achievementSubjectExplorer,
      NorieAchievementId.consistentLearner =>
        NorieAssets.achievementConsistentLearner,
    };
  }

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.sizeOf(context).width >= 650 ? 4 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .83,
      ),
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _AchievementCard(
          achievement: achievement,
          asset: _assetFor(achievement.id),
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.achievement,
    required this.asset,
  });

  final NorieAchievement achievement;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NorieColors.primary.withValues(alpha: .4),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x205B5CE2),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: achievement.unlocked ? 1 : .28,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                  ),
                ),
                if (!achievement.unlocked)
                  const Icon(
                    Icons.lock_rounded,
                    color: Colors.white70,
                    size: 28,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.unlocked
                ? 'Unlocked'
                : achievement.progressLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              height: 1.25,
              color: NorieColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


class _MasterySummaryCard extends StatelessWidget {
  const _MasterySummaryCard({required this.progression});

  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    final tracked = progression.topicMastery.length;
    final weak = progression.weakTopics.length;
    final mastered = progression.masteredTopicCount;

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .42),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                color: NorieColors.violet,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Knowledge Mastery',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Accuracy plus repeated evidence determines mastery. Weak topics are detected automatically.',
            style: TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 10,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MasteryMiniStat(
                  label: 'Tracked',
                  value: '$tracked',
                  color: NorieColors.cyan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MasteryMiniStat(
                  label: 'Mastered',
                  value: '$mastered',
                  color: NorieColors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MasteryMiniStat(
                  label: 'Weak',
                  value: '$weak',
                  color: NorieColors.magenta,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WeakTopicsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                weak > 0 ? 'Review Weak Topics' : 'View Mastery',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: NorieColors.violet,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MasteryMiniStat extends StatelessWidget {
  const _MasteryMiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
