import 'package:flutter/material.dart';

import '../../../core/assets/norie_assets.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_logo_mark.dart';
import '../../common/presentation/coming_soon_screen.dart';
import '../../learning/presentation/atomic_structure_lesson_screen.dart';
import '../../learning/presentation/learn_screen.dart';
import '../../navigation/presentation/norie_drawer.dart';
import '../../progress/presentation/progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
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
        selectedSection: NorieDrawerSection.home,
        onTabSelected: onTabSelected,
      ),
      drawerEdgeDragWidth: 48,
      body: Stack(
        children: [
          const Positioned.fill(child: _HomeBackdrop()),
          SafeArea(
            child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                constraints.maxWidth > 760 ? 720.0 : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
                      sliver: SliverList.list(
                        children: [
                          Builder(
                            builder: (drawerContext) => _Header(
                              onMenuPressed: () =>
                                  Scaffold.of(drawerContext).openDrawer(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _HomeHero(
                            onLearnTap: () => onTabSelected?.call(1),
                          ),
                          const SizedBox(height: 18),
                          const _ContinueLearningCard(),
                          const SizedBox(height: 16),
                          _HomeActionGrid(
                            onChallengeTap: () => onTabSelected?.call(2),
                            onStudyTap: () => onTabSelected?.call(1),
                          ),
                          const SizedBox(height: 16),
                          const _LevelCard(),
                        ],
                      ),
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
      bottomNavigationBar:
          embedded ? null : _BottomNavigation(onTabSelected: onTabSelected),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: NorieProgression.instance,
      builder: (context, _) {
        final progression = NorieProgression.instance.snapshot;

        return Row(
          children: [
            IconButton(
              onPressed: onMenuPressed,
              tooltip: 'Open menu',
              style: IconButton.styleFrom(
                backgroundColor: NorieColors.surface,
                foregroundColor: NorieColors.textPrimary,
                side: const BorderSide(color: NorieColors.border),
                minimumSize: const Size(42, 42),
              ),
              icon: const Icon(Icons.menu_rounded),
            ),
            const SizedBox(width: 8),
            const NorieLogoMark(size: 42, showGlow: false),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Norie Learning',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'PLAY · LEARN · GROW FURTHER',
                    style: TextStyle(
                      fontSize: 8,
                      letterSpacing: 1.2,
                      color: NorieColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _StatusPill(
              icon: Icons.star_rounded,
              value: '${progression.totalXp} XP',
            ),
          ],
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NorieColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: NorieColors.orange),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _HomeBackdrop extends StatelessWidget {
  const _HomeBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: NorieColors.background,
        gradient: RadialGradient(
          center: Alignment(.65, -.82),
          radius: 1.15,
          colors: [
            Color(0x243D7CFF),
            Color(0x151A31A3),
            Color(0x00071126),
          ],
        ),
      ),
      child: Stack(
        children: const [
          Positioned(
            right: -70,
            top: 170,
            child: _BackdropOrb(
              size: 190,
              color: Color(0x1622D3EE),
            ),
          ),
          Positioned(
            left: -80,
            top: 470,
            child: _BackdropOrb(
              size: 220,
              color: Color(0x12EC4899),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  const _BackdropOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({this.onLearnTap});

  final VoidCallback? onLearnTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: NorieProgression.instance,
      builder: (context, _) {
        final progression = NorieProgression.instance;
        final snapshot = progression.snapshot;

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF102956),
                Color(0xFF1C285D),
                Color(0xFF3B1D63),
              ],
            ),
            border: Border.all(
              color: NorieColors.cyan.withValues(alpha: .28),
            ),
            boxShadow: [
              BoxShadow(
                color: NorieColors.primary.withValues(alpha: .14),
                blurRadius: 34,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -32,
                top: -42,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NorieColors.cyan.withValues(alpha: .07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 9, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WELCOME BACK',
                            style: TextStyle(
                              color: Color(0xFF9BF6FF),
                              fontSize: 9,
                              letterSpacing: 1.7,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            snapshot.isMaxLevel
                                ? 'You reached\nMaster rank.'
                                : 'Ready for your\nnext level?',
                            style: const TextStyle(
                              fontSize: 28,
                              height: .98,
                              letterSpacing: -.8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Level ${snapshot.level} · ${snapshot.title}',
                            style: const TextStyle(
                              color: Color(0xFFD1DCF2),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 13),
                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children: [
                              _HeroStat(
                                icon: Icons.local_fire_department_rounded,
                                value: '${progression.currentStreak} day',
                                label: 'streak',
                                color: NorieColors.orange,
                              ),
                              _HeroStat(
                                icon: Icons.star_rounded,
                                value: '${snapshot.totalXp}',
                                label: 'XP',
                                color: NorieColors.cyan,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          FilledButton.icon(
                            onPressed: onLearnTap,
                            icon: const Icon(
                              Icons.explore_rounded,
                              size: 17,
                            ),
                            label: const Text('Explore Learning'),
                            style: FilledButton.styleFrom(
                              backgroundColor: NorieColors.cyan,
                              foregroundColor: NorieColors.background,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 11,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 132,
                      height: 170,
                      child: Image.asset(
                        NorieAssets.mascotCelebrating,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: .08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: NorieColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeActionGrid extends StatelessWidget {
  const _HomeActionGrid({
    required this.onChallengeTap,
    required this.onStudyTap,
  });

  final VoidCallback onChallengeTap;
  final VoidCallback onStudyTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;

        final challenge = _DailyChallengeCard(onTap: onChallengeTap);
        final study = _StudyLabCard(onTap: onStudyTap);

        if (compact) {
          return Column(
            children: [
              challenge,
              const SizedBox(height: 12),
              study,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: challenge),
            const SizedBox(width: 12),
            Expanded(child: study),
          ],
        );
      },
    );
  }
}

class _StudyLabCard extends StatelessWidget {
  const _StudyLabCard({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: const _InfoCard(
        icon: Icons.auto_awesome_rounded,
        iconColor: NorieColors.cyan,
        title: 'Norie AI Study Lab',
        subtitle: 'Turn your notes and files into grounded practice sets.',
        trailing: 'CREATE',
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF103B88),
            Color(0xFF182C73),
            Color(0xFF351D6C),
          ],
        ),
        border: Border.all(color: const Color(0xFF3374D9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335B5CE2),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTINUE LEARNING',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.6,
              color: Color(0xFFAED8FF),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chemistry:\nAtomic Structure',
                      style: TextStyle(
                        fontSize: 25,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Build the building blocks of a brighter tomorrow.',
                      style: TextStyle(
                        color: Color(0xFFD8E6FF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF8CF7FF),
                      NorieColors.primary,
                      Color(0x003B82F6),
                    ],
                  ),
                  border: Border.all(color: NorieColors.cyan),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: .72,
                  minHeight: 7,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  color: NorieColors.cyan,
                  backgroundColor: Color(0x4422D3EE),
                ),
              ),
              SizedBox(width: 10),
              Text('72%', style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AtomicStructureLessonScreen(),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Resume Lesson'),
            style: FilledButton.styleFrom(
              backgroundColor: NorieColors.cyan,
              foregroundColor: NorieColors.background,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progression = NorieProgression.instance;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: _InfoCard(
        icon: Icons.track_changes_rounded,
        iconColor: NorieColors.magenta,
        title: 'Daily Challenge',
        subtitle: progression.dailyChallengeCompletedToday
            ? 'Completed today · replay available in Challenge.'
            : 'Solve 5 mixed questions and earn today’s bonus.',
        trailing: progression.dailyChallengeCompletedToday
            ? 'DONE'
            : '+100 XP',
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: NorieProgression.instance,
      builder: (context, _) {
        final progression = NorieProgression.instance.snapshot;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: NorieColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: NorieColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: NorieColors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Level ${progression.level} · ${progression.title}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    progression.isMaxLevel
                        ? 'MAX LEVEL'
                        : '${progression.xpIntoLevel} / ${progression.xpRequiredForNextLevel} XP',
                    style: const TextStyle(
                      fontSize: 11,
                      color: NorieColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progression.progress,
                minHeight: 8,
                borderRadius: const BorderRadius.all(Radius.circular(99)),
                color: NorieColors.violet,
                backgroundColor: NorieColors.surfaceElevated,
              ),
              if (!progression.isMaxLevel &&
                  progression.nextRankTitle != null &&
                  progression.nextRankLevel != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_open_rounded,
                      size: 15,
                      color: NorieColors.cyan,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Next rank: ${progression.nextRankTitle} at Level ${progression.nextRankLevel}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: NorieColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF18203D), Color(0xFF351660)],
        ),
        border: Border.all(color: const Color(0xFF6636AA)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              color: NorieColors.orange,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({this.onTabSelected});

  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (onTabSelected != null) {
          onTabSelected!(index);
          return;
        }
        if (index == 0) return;

        if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const LearnScreen(),
            ),
          );
          return;
        }

        if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ProgressScreen(),
            ),
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ComingSoonScreen(
              title: index == 2 ? 'Challenge' : 'Profile',
              subtitle: index == 2
                  ? 'Daily and weekly challenges are being built.'
                  : 'Your learner profile and preferences are being built.',
              icon: index == 2
                  ? Icons.emoji_events_rounded
                  : Icons.person_rounded,
            ),
          ),
        );
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_rounded),
          label: 'Learn',
        ),
        NavigationDestination(
          icon: Icon(Icons.emoji_events_rounded),
          label: 'Challenge',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Progress',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
