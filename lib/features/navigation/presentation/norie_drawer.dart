import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_logo_mark.dart';
import '../../common/presentation/coming_soon_screen.dart';
import '../../learning/presentation/atomic_structure_lesson_screen.dart';
import '../../learning/presentation/chemistry_screen.dart';
import '../../learning/presentation/learn_screen.dart';
import '../../progress/presentation/progress_screen.dart';

class NorieDrawer extends StatelessWidget {
  const NorieDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final drawerWidth = width > 430 ? 360.0 : width * .86;

    return Drawer(
      width: drawerWidth,
      backgroundColor: const Color(0xFF081226),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: NorieProgression.instance,
          builder: (context, _) {
            final progression = NorieProgression.instance.snapshot;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _ProfileHeader(progression: progression),
                const SizedBox(height: 20),
                const _SectionLabel('MAIN'),
                _MenuItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  color: NorieColors.cyan,
                  selected: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                _MenuItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Learn',
                  color: NorieColors.primary,
                  onTap: () => _open(context, const LearnScreen()),
                ),
                _MenuItem(
                  icon: Icons.route_rounded,
                  label: 'My Learning Path',
                  color: NorieColors.green,
                  onTap: () => _open(context, const ChemistryScreen()),
                ),
                const SizedBox(height: 14),
                const _SectionLabel('AI TOOLS'),
                _MenuItem(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI-Based Q&A',
                  color: NorieColors.violet,
                  trailing: const _SampleBadge(),
                  onTap: () => _open(context, const LearnScreen()),
                ),
                const SizedBox(height: 14),
                const _SectionLabel('PROGRESS'),
                _MenuItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'XP & Levels',
                  color: NorieColors.violet,
                  onTap: () => _open(context, const ProgressScreen()),
                ),
                _MenuItem(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Achievements',
                  color: NorieColors.orange,
                  onTap: () => _open(context, const ProgressScreen()),
                ),
                _MenuItem(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Streaks',
                  color: NorieColors.orange,
                  trailing: const _CountBadge('12'),
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Streaks',
                    subtitle:
                        'Daily learning streak history and streak protection will appear here.',
                    icon: Icons.local_fire_department_rounded,
                  ),
                ),
                const SizedBox(height: 14),
                const _SectionLabel('CHALLENGES'),
                _MenuItem(
                  icon: Icons.track_changes_rounded,
                  label: 'Daily Challenge',
                  color: NorieColors.magenta,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Daily Challenge',
                    subtitle:
                        'Daily mixed-subject challenges with XP bonuses are coming next.',
                    icon: Icons.track_changes_rounded,
                  ),
                ),
                _MenuItem(
                  icon: Icons.emoji_events_rounded,
                  label: 'Weekly Goals',
                  color: NorieColors.cyan,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Weekly Goals',
                    subtitle:
                        'Weekly XP, lesson, and mastery goals will be tracked here.',
                    icon: Icons.emoji_events_rounded,
                  ),
                ),
                const SizedBox(height: 18),
                const _QuickActions(),
                const SizedBox(height: 18),
                const _SectionLabel('ACCOUNT'),
                _MenuItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  color: NorieColors.cyan,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Profile',
                    subtitle:
                        'Your learner profile, selected subjects, and personal learning preferences will live here.',
                    icon: Icons.person_rounded,
                  ),
                ),
                _MenuItem(
                  icon: Icons.tune_rounded,
                  label: 'Learning Preferences',
                  color: NorieColors.primary,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Learning Preferences',
                    subtitle:
                        'Adjust difficulty, recommendations, study pace, and learning interests here.',
                    icon: Icons.tune_rounded,
                  ),
                ),
                _MenuItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  color: NorieColors.textSecondary,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Settings',
                    subtitle:
                        'App settings, notifications, appearance, and account controls are coming soon.',
                    icon: Icons.settings_rounded,
                  ),
                ),
                const Divider(
                  height: 28,
                  color: NorieColors.border,
                ),
                _MenuItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  color: NorieColors.textSecondary,
                  compact: true,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'Help & Support',
                    subtitle:
                        'Guides, support resources, and feedback tools will appear here.',
                    icon: Icons.help_outline_rounded,
                  ),
                ),
                _MenuItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About Norie',
                  color: NorieColors.textSecondary,
                  compact: true,
                  onTap: () => _openUpcoming(
                    context,
                    title: 'About Norie',
                    subtitle:
                        'Norie Learning · Play · Learn · Grow Further.',
                    icon: Icons.info_outline_rounded,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static void _open(BuildContext context, Widget screen) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  static void _openUpcoming(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    _open(
      context,
      ComingSoonScreen(
        title: title,
        subtitle: subtitle,
        icon: icon,
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.progression});

  final NorieLevelSnapshot progression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111D3D),
            Color(0xFF1C2458),
            Color(0xFF28164D),
          ],
        ),
        border: Border.all(
          color: NorieColors.primary.withValues(alpha: .48),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              NorieLogoMark(size: 48, showGlow: false),
              SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Norie Learning',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Guest learner',
                      style: TextStyle(
                        fontSize: 11,
                        color: NorieColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.auto_awesome_rounded,
                color: NorieColors.cyan,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Level ${progression.level} · ${progression.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${progression.totalXp} XP',
                style: const TextStyle(
                  color: NorieColors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          LinearProgressIndicator(
            value: progression.progress,
            minHeight: 7,
            borderRadius: BorderRadius.circular(99),
            color: NorieColors.cyan,
            backgroundColor: const Color(0x33475569),
          ),
          const SizedBox(height: 7),
          Text(
            progression.isMaxLevel
                ? 'Master rank reached'
                : '${progression.xpIntoLevel} / ${progression.xpRequiredForNextLevel} XP to Level ${progression.level + 1}',
            style: const TextStyle(
              fontSize: 10,
              color: NorieColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: NorieColors.orange.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: NorieColors.orange.withValues(alpha: .35),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: NorieColors.orange,
                ),
                SizedBox(width: 5),
                Text(
                  '12 day streak',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 7),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1.4,
          color: NorieColors.textSecondary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.selected = false,
    this.trailing,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool selected;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 1 : 4),
      child: Material(
        color: selected ? color.withValues(alpha: .11) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: compact ? 10 : 12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: compact ? 20 : 22,
                  color: selected ? color : color.withValues(alpha: .9),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: compact ? 13 : 14,
                      fontWeight:
                          selected ? FontWeight.w900 : FontWeight.w700,
                      color: selected
                          ? NorieColors.textPrimary
                          : NorieColors.textSecondary,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
                if (selected)
                  Container(
                    width: 5,
                    height: 22,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(99),
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

class _CountBadge extends StatelessWidget {
  const _CountBadge(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NorieColors.orange.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 10,
          color: NorieColors.orange,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SampleBadge extends StatelessWidget {
  const _SampleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: NorieColors.violet.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'SAMPLE',
        style: TextStyle(
          fontSize: 8,
          color: NorieColors.violet,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NorieColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.3,
              color: NorieColors.textSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _QuickAction(
            icon: Icons.play_arrow_rounded,
            label: 'Continue Chemistry',
            color: NorieColors.cyan,
            onTap: () => NorieDrawer._open(
              context,
              const AtomicStructureLessonScreen(),
            ),
          ),
          _QuickAction(
            icon: Icons.auto_awesome_rounded,
            label: 'Generate Sample Q&A',
            color: NorieColors.violet,
            onTap: () => NorieDrawer._open(
              context,
              const LearnScreen(),
            ),
          ),
          _QuickAction(
            icon: Icons.psychology_alt_rounded,
            label: 'Review Weak Topics',
            color: NorieColors.orange,
            onTap: () => NorieDrawer._openUpcoming(
              context,
              title: 'Review Weak Topics',
              subtitle:
                  'Norie will eventually identify weak areas from quiz performance and build a review queue.',
              icon: Icons.psychology_alt_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: NorieColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
