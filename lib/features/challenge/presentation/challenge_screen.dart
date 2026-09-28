import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../navigation/presentation/norie_drawer.dart';
import 'challenge_quiz_screen.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({
    super.key,
    this.onTabSelected,
  });

  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NorieDrawer(
        selectedSection: NorieDrawerSection.challenge,
        onTabSelected: onTabSelected,
      ),
      drawerEdgeDragWidth: 48,
      body: Stack(
        children: [
          const Positioned.fill(
            child: NorieAmbientBackdrop(
              primary: NorieColors.magenta,
              secondary: NorieColors.cyan,
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
          animation: NorieProgression.instance,
          builder: (context, _) {
            final progression = NorieProgression.instance;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                  children: [
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Challenge',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Train · score · earn XP',
                                  style: TextStyle(
                                    color: NorieColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _StatPill(
                            icon: Icons.local_fire_department_rounded,
                            value: '${progression.currentStreak}',
                            color: NorieColors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _ChallengeHero(progression: progression),
                    const SizedBox(height: 20),
                    _WeeklyGoalCard(progression: progression),
                    const SizedBox(height: 14),
                    _ModeCard(
                      icon: Icons.track_changes_rounded,
                      title: 'Daily Challenge',
                      subtitle: progression.dailyChallengeCompletedToday
                          ? 'Completed today · replay for practice'
                          : '5 mixed questions · score XP + 100 XP daily bonus',
                      color: NorieColors.magenta,
                      badge: progression.dailyChallengeCompletedToday
                          ? 'COMPLETED'
                          : '+100 XP',
                      badgeColor: progression.dailyChallengeCompletedToday
                          ? NorieColors.green
                          : NorieColors.orange,
                      trailingIcon: progression.dailyChallengeCompletedToday
                          ? Icons.replay_rounded
                          : Icons.play_arrow_rounded,
                      onTap: () => _start(
                        context,
                        NorieChallengeMode.daily,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ModeCard(
                      icon: Icons.bolt_rounded,
                      title: 'Speed Quiz',
                      subtitle:
                          '10 questions · 60 seconds · best ${progression.speedBestScore}/10',
                      color: NorieColors.cyan,
                      badge: progression.speedRewardEarnedToday
                          ? 'PRACTICE'
                          : 'DAILY XP',
                      badgeColor: progression.speedRewardEarnedToday
                          ? NorieColors.textSecondary
                          : NorieColors.cyan,
                      trailingIcon: Icons.timer_rounded,
                      onTap: () => _start(
                        context,
                        NorieChallengeMode.speed,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: NorieColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: NorieColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.analytics_rounded,
                            color: NorieColors.violet,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Challenge record',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${progression.challengeSessions} sessions completed',
                                  style: const TextStyle(
                                    color: NorieColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${progression.snapshot.totalXp} XP',
                            style: const TextStyle(
                              color: NorieColors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _RewardRulesCard(),
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

  static void _start(
    BuildContext context,
    NorieChallengeMode mode,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeQuizScreen(mode: mode),
      ),
    );
  }
}

class _WeeklyGoalCard extends StatelessWidget {
  const _WeeklyGoalCard({required this.progression});

  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    final completed = progression.weeklyGoalComplete;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3A1C69),
            Color(0xFF1D245A),
            Color(0xFF103C59),
          ],
        ),
        border: Border.all(
          color: (completed ? NorieColors.green : NorieColors.violet)
              .withValues(alpha: .58),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: NorieColors.orange.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: NorieColors.orange,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Complete Daily Challenge on 5 different days.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: (completed ? NorieColors.green : NorieColors.orange)
                      .withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  completed ? 'DONE' : '+250 XP',
                  style: TextStyle(
                    color:
                        completed ? NorieColors.green : NorieColors.orange,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          LinearProgressIndicator(
            value: progression.weeklyChallengeProgress,
            minHeight: 9,
            borderRadius: BorderRadius.circular(99),
            color: completed ? NorieColors.green : NorieColors.cyan,
            backgroundColor: const Color(0x33334155),
          ),
          const SizedBox(height: 8),
          Text(
            '${progression.weeklyChallengeDays} / ${NorieChallengeRules.weeklyGoalDays} challenge days this week',
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.badge,
    required this.badgeColor,
    required this.trailingIcon,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String badge;
  final Color badgeColor;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: color.withValues(alpha: .42)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: .11),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                trailingIcon,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardRulesCard extends StatelessWidget {
  const _RewardRulesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NorieColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: NorieColors.textSecondary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Daily Challenge and Speed Quiz give their main XP reward once per day. You can replay either mode for practice without farming unlimited XP.',
              style: TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _ChallengeHero extends StatelessWidget {
  const _ChallengeHero({required this.progression});
  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D174C), Color(0xFF20245E), Color(0xFF0B4052)],
        ),
        border: Border.all(color: NorieColors.magenta.withValues(alpha: .42)),
        boxShadow: [
          BoxShadow(
            color: NorieColors.magenta.withValues(alpha: .10),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CHALLENGE ARENA',
                  style: TextStyle(
                    color: NorieColors.cyan,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Train what you know.\nPush your score higher.',
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.02,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${progression.currentStreak} day streak · ${progression.challengeSessions} challenge sessions',
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0x55EC4899), Color(0x225B5CE2), Colors.transparent],
              ),
              border: Border.all(color: NorieColors.magenta.withValues(alpha: .35)),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 46,
              color: NorieColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
