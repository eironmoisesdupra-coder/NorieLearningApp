import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../navigation/presentation/norie_drawer.dart';

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
      body: SafeArea(
        child: Center(
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
                        style: IconButton.styleFrom(
                          backgroundColor: NorieColors.surface,
                          side: const BorderSide(color: NorieColors.border),
                        ),
                        icon: const Icon(Icons.menu_rounded),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Challenge',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Train what you know.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Daily and weekly challenge modes will turn your learning progress into focused practice.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                const _ChallengeCard(
                  icon: Icons.track_changes_rounded,
                  title: 'Daily Challenge',
                  subtitle: '5 mixed questions · +100 XP bonus',
                  color: NorieColors.magenta,
                ),
                const SizedBox(height: 12),
                const _ChallengeCard(
                  icon: Icons.emoji_events_rounded,
                  title: 'Weekly Goal',
                  subtitle: 'Build a consistent week of study sessions.',
                  color: NorieColors.orange,
                ),
                const SizedBox(height: 12),
                const _ChallengeCard(
                  icon: Icons.bolt_rounded,
                  title: 'Speed Quiz',
                  subtitle: 'Coming next · answer accurately under time pressure.',
                  color: NorieColors.cyan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: color.withValues(alpha: .4)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: NorieColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
