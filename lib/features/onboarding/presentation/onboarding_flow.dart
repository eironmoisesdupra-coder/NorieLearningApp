import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/assets/norie_assets.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_logo_mark.dart';
import '../../account/presentation/account_screen.dart';
import '../../account/presentation/learning_entry.dart';
import '../../navigation/presentation/main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    Timer(const Duration(milliseconds: 1900), _openWelcome);
  }

  void _openWelcome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: const NorieLearningEntry(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(.15, -.2),
            radius: 1.15,
            colors: [
              Color(0xFF18295F),
              Color(0xFF09152F),
              NorieColors.background,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NorieLogoMark(size: 126),
                  SizedBox(height: 22),
                  Text(
                    'Norie Learning',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.7,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PLAY · LEARN · GROW FURTHER',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2.1,
                      color: NorieColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBrand(),
          const Spacer(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0x553B82F6),
                        Color(0x225B5CE2),
                        Color(0x00071126),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 210,
                  height: 210,
                  child: Image.asset(
                    NorieAssets.mascotBase,
                    fit: BoxFit.contain,
                  ),
                ),
                const Positioned(
                  left: 16,
                  top: 34,
                  child: _FloatingIcon(
                    icon: Icons.calculate_rounded,
                    color: NorieColors.primary,
                  ),
                ),
                const Positioned(
                  right: 10,
                  top: 54,
                  child: _FloatingIcon(
                    icon: Icons.science_rounded,
                    color: NorieColors.green,
                  ),
                ),
                const Positioned(
                  right: 24,
                  bottom: 36,
                  child: _FloatingIcon(
                    icon: Icons.menu_book_rounded,
                    color: NorieColors.orange,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            'Learning that\ngrows with you.',
            style: TextStyle(
              fontSize: 38,
              height: 1.02,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Study smarter through lessons, active recall, challenges, and progress you can actually see.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: NorieColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          _PrimaryButton(
            label: 'Get Started',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => _push(context, const LearnerTypeScreen()),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AccountScreen(),
                ),
              );
            },
            child: const Text('I already have an account'),
          ),
        ],
      ),
    );
  }
}

class LearnerTypeScreen extends StatefulWidget {
  const LearnerTypeScreen({super.key});

  @override
  State<LearnerTypeScreen> createState() => _LearnerTypeScreenState();
}

class _LearnerTypeScreenState extends State<LearnerTypeScreen> {
  String? _selected;

  static const _types = [
    (
      'Junior / Senior High',
      'Build strong foundations and prepare for school exams.',
      Icons.backpack_rounded,
      NorieColors.cyan,
    ),
    (
      'College',
      'Master deeper concepts and strengthen your courses.',
      Icons.school_rounded,
      NorieColors.primary,
    ),
    (
      'Professional',
      'Refresh, specialize, and continue learning for your career.',
      Icons.work_rounded,
      NorieColors.violet,
    ),
    (
      'Self-Learner',
      'Explore subjects independently at your own pace.',
      Icons.auto_awesome_rounded,
      NorieColors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Progress(step: 1, total: 4),
          const SizedBox(height: 28),
          const Text(
            'Who are you\nlearning as?',
            style: _headingStyle,
          ),
          const SizedBox(height: 10),
          const Text(
            'This helps Norie shape recommendations and difficulty around you.',
            style: _supportStyle,
          ),
          const SizedBox(height: 24),
          ..._types.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SelectionCard(
                title: item.$1,
                subtitle: item.$2,
                icon: item.$3,
                color: item.$4,
                selected: _selected == item.$1,
                onTap: () => setState(() => _selected = item.$1),
              ),
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            enabled: _selected != null,
            onPressed: () => _push(context, const SubjectInterestScreen()),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => _push(context, const SubjectInterestScreen()),
              child: const Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectInterestScreen extends StatefulWidget {
  const SubjectInterestScreen({super.key});

  @override
  State<SubjectInterestScreen> createState() => _SubjectInterestScreenState();
}

class _SubjectInterestScreenState extends State<SubjectInterestScreen> {
  final Set<String> _selected = {'Science'};
  bool _showScience = true;

  void _toggle(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else {
        _selected.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Progress(step: 2, total: 4),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'What do you\nwant to learn?',
                  style: _headingStyle,
                ),
              ),
              SizedBox(
                width: 92,
                height: 92,
                child: Image.asset(
                  NorieAssets.mascotStudying,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Choose as many as you want. You can change this later.',
            style: _supportStyle,
          ),
          const SizedBox(height: 24),
          _SubjectChoice(
            label: 'Mathematics',
            icon: Icons.calculate_rounded,
            color: NorieColors.primary,
            selected: _selected.contains('Mathematics'),
            onTap: () => _toggle('Mathematics'),
          ),
          const SizedBox(height: 12),
          _SubjectChoice(
            label: 'Science',
            icon: Icons.science_rounded,
            color: NorieColors.green,
            selected: _selected.contains('Science'),
            onTap: () {
              _toggle('Science');
              setState(() => _showScience = true);
            },
            trailing: IconButton(
              onPressed: () => setState(() => _showScience = !_showScience),
              icon: Icon(
                _showScience
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _showScience
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final field in const [
                    'Chemistry',
                    'Biology',
                    'Physics',
                    'Earth Science',
                  ])
                    FilterChip(
                      label: Text(field),
                      selected: _selected.contains(field),
                      onSelected: (_) => _toggle(field),
                    ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          _SubjectChoice(
            label: 'English',
            icon: Icons.menu_book_rounded,
            color: NorieColors.orange,
            selected: _selected.contains('English'),
            onTap: () => _toggle('English'),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            enabled: _selected.isNotEmpty,
            onPressed: () => _push(context, const LearningGoalScreen()),
          ),
        ],
      ),
    );
  }
}

class LearningGoalScreen extends StatefulWidget {
  const LearningGoalScreen({super.key});

  @override
  State<LearningGoalScreen> createState() => _LearningGoalScreenState();
}

class _LearningGoalScreenState extends State<LearningGoalScreen> {
  String? _selected;

  static const _goals = [
    ('Improve my grades', Icons.trending_up_rounded, NorieColors.green),
    ('Prepare for an exam', Icons.edit_note_rounded, NorieColors.orange),
    ('Understand difficult topics', Icons.psychology_rounded, NorieColors.cyan),
    ('Master my subjects', Icons.workspace_premium_rounded, NorieColors.violet),
  ];

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Progress(step: 3, total: 4),
          const SizedBox(height: 28),
          const Text(
            'What are you\nworking toward?',
            style: _headingStyle,
          ),
          const SizedBox(height: 10),
          const Text(
            'Norie will use this to shape your challenges and recommended path.',
            style: _supportStyle,
          ),
          const SizedBox(height: 24),
          ..._goals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GoalCard(
                label: goal.$1,
                icon: goal.$2,
                color: goal.$3,
                selected: _selected == goal.$1,
                onTap: () => setState(() => _selected = goal.$1),
              ),
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'Build my learning path',
            icon: Icons.auto_awesome_rounded,
            enabled: _selected != null,
            onPressed: () => _push(context, const ReadyScreen()),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => _push(context, const ReadyScreen()),
              child: const Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }
}

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _progress = Tween<double>(begin: 0, end: .16).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      showBack: true,
      child: Column(
        children: [
          const _Progress(step: 4, total: 4),
          const Spacer(),
          SizedBox(
            width: 170,
            height: 170,
            child: Image.asset(
              NorieAssets.mascotCelebrating,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Your Norie path\nis ready.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              height: 1.03,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Start with Atomic Structure and build mastery through lessons, active recall, and challenges.',
            textAlign: TextAlign.center,
            style: _supportStyle,
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NorieColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: NorieColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.science_rounded, color: NorieColors.green),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Science · Chemistry',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      'LEVEL 1',
                      style: TextStyle(
                        color: NorieColors.cyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Atomic Structure',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your first recommended learning path',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _progress,
                  builder: (context, _) => LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(99),
                    color: NorieColors.cyan,
                    backgroundColor: NorieColors.surfaceElevated,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  '+50 XP · Profile created',
                  style: TextStyle(
                    color: NorieColors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'Start Learning',
            icon: Icons.play_arrow_rounded,
            onPressed: () {
              final progression = NorieProgression.instance;
              if (!progression.onboardingComplete) {
                progression.addXp(50);
                progression.markOnboardingComplete();
              }
              _replaceAll(context, const MainShell());
            },
          ),
        ],
      ),
    );
  }
}

const _headingStyle = TextStyle(
  fontSize: 34,
  height: 1.05,
  fontWeight: FontWeight.w900,
  letterSpacing: -.8,
);

const _supportStyle = TextStyle(
  color: NorieColors.textSecondary,
  height: 1.45,
  fontSize: 14,
);

class _OnboardingScaffold extends StatelessWidget {
  const _OnboardingScaffold({
    required this.child,
    this.showBack = false,
  });

  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1734),
              NorieColors.background,
              Color(0xFF060D1D),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
                child: Column(
                  children: [
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(child: child),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBrand extends StatelessWidget {
  const _TopBrand();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        NorieLogoMark(size: 46, showGlow: false),
        SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Norie Learning',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'PLAY · LEARN · GROW FURTHER',
              style: TextStyle(
                fontSize: 7,
                letterSpacing: 1.2,
                color: NorieColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'STEP $step OF $total',
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.3,
            color: NorieColors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: LinearProgressIndicator(
            value: step / total,
            minHeight: 5,
            borderRadius: BorderRadius.circular(99),
            color: NorieColors.cyan,
            backgroundColor: NorieColors.surfaceElevated,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: NorieColors.cyan,
          foregroundColor: NorieColors.background,
          disabledBackgroundColor: NorieColors.surfaceElevated,
          padding: const EdgeInsets.symmetric(vertical: 17),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Color.alphaBlend(color.withValues(alpha: .12), NorieColors.surface)
          : NorieColors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: selected ? color : NorieColors.border,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color),
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
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: NorieColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? color : NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectChoice extends StatelessWidget {
  const _SubjectChoice({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Color.alphaBlend(color.withValues(alpha: .12), NorieColors.surface)
          : NorieColors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: selected ? color : NorieColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 27),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline_rounded,
                  color: selected ? color : NorieColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Color.alphaBlend(color.withValues(alpha: .12), NorieColors.surface)
          : NorieColors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: selected ? color : NorieColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 29),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.chevron_right_rounded,
                color: selected ? color : NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: .6)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .22),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(icon, color: color),
    );
  }
}

void _push(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, animation, secondaryAnimation) {
        final offset = Tween<Offset>(
          begin: const Offset(.08, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offset, child: screen),
        );
      },
    ),
  );
}

void _replaceAll(BuildContext context, Widget screen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => screen),
    (_) => false,
  );
}
