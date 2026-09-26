import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../learning/presentation/atomic_structure_lesson_screen.dart';
import '../../learning/presentation/science_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        children: const [
                          _Header(),
                          SizedBox(height: 26),
                          _Greeting(),
                          SizedBox(height: 22),
                          _ContinueLearningCard(),
                          SizedBox(height: 26),
                          _SectionTitle(title: 'Explore Subjects'),
                          SizedBox(height: 14),
                          _SubjectGrid(),
                          SizedBox(height: 22),
                          _DailyChallengeCard(),
                          SizedBox(height: 16),
                          _LevelCard(),
                          SizedBox(height: 26),
                          _SectionTitle(title: 'Achievements'),
                          SizedBox(height: 14),
                          _AchievementsRow(),
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
      bottomNavigationBar: const _BottomNavigation(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [
                NorieColors.cyan,
                NorieColors.primary,
                NorieColors.magenta,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'N',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
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
        const _StatusPill(
          icon: Icons.local_fire_department,
          value: '12',
        ),
        const SizedBox(width: 8),
        const _StatusPill(
          icon: Icons.star_rounded,
          value: '1,250 XP',
        ),
      ],
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

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          style: TextStyle(color: NorieColors.textSecondary, fontSize: 15),
        ),
        SizedBox(height: 2),
        Text(
          'Keep going!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 4),
        Text(
          'Small steps make big progress.',
          style: TextStyle(color: NorieColors.textSecondary),
        ),
      ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        const Text(
          'See all',
          style: TextStyle(
            color: NorieColors.cyan,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SubjectGrid extends StatelessWidget {
  const _SubjectGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _SubjectCard(
            title: 'Mathematics',
            icon: Icons.calculate_rounded,
            color: NorieColors.primary,
            progress: .68,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ScienceScreen(),
                ),
              );
            },
            child: const _SubjectCard(
              title: 'Science',
              icon: Icons.science_rounded,
              color: NorieColors.green,
              progress: .72,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: _SubjectCard(
            title: 'English',
            icon: Icons.menu_book_rounded,
            color: NorieColors.orange,
            progress: .45,
          ),
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.progress,
  });

  final String title;
  final IconData icon;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          color.withValues(alpha: .18),
          NorieColors.surface,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            borderRadius: BorderRadius.circular(99),
            color: color,
            backgroundColor: color.withValues(alpha: .18),
          ),
          const SizedBox(height: 5),
          Text(
            '${(progress * 100).round()}% complete',
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

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.track_changes_rounded,
      iconColor: NorieColors.magenta,
      title: 'Daily Challenge',
      subtitle: 'Solve 5 questions correctly and earn rewards.',
      trailing: '+100 XP',
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NorieColors.border),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: NorieColors.orange,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Level 8 · Future Achiever',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '350 / 500 XP',
                style: TextStyle(
                  fontSize: 11,
                  color: NorieColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: .7,
            minHeight: 8,
            borderRadius: BorderRadius.all(Radius.circular(99)),
            color: NorieColors.violet,
            backgroundColor: NorieColors.surfaceElevated,
          ),
        ],
      ),
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

class _AchievementsRow extends StatelessWidget {
  const _AchievementsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Achievement(
          icon: Icons.local_fire_department,
          label: '7-Day\nStreak',
        ),
        _Achievement(
          icon: Icons.star_rounded,
          label: 'Lesson\nMaster',
        ),
        _Achievement(
          icon: Icons.school_rounded,
          label: 'Subject\nExplorer',
        ),
        _Achievement(
          icon: Icons.diamond_rounded,
          label: 'Consistent\nLearner',
        ),
      ],
    );
  }
}

class _Achievement extends StatelessWidget {
  const _Achievement({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: NorieColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: NorieColors.primary),
            ),
            child: Icon(icon, color: NorieColors.cyan),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
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

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
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
