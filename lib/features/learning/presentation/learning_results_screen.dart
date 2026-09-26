import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

class LearningResultsScreen extends StatelessWidget {
  const LearningResultsScreen({
    required this.quizScore,
    required this.challengeScore,
    super.key,
  });

  final int quizScore;
  final int challengeScore;

  @override
  Widget build(BuildContext context) {
    final quizXp = quizScore * 20;
    final challengeXp = challengeScore * 25;
    final completionXp = 50;
    final totalXp = quizXp + challengeXp + completionXp;
    final percent = quizScore / 5;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 36),
              children: [
                Center(
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          NorieColors.cyan,
                          NorieColors.primary,
                          NorieColors.magenta,
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x445B5CE2),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Lesson complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Atomic Structure · Chemistry',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: NorieColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: NorieColors.border),
                  ),
                  child: Column(
                    children: [
                      _ResultRow(
                        label: 'Quiz',
                        value: '$quizScore / 5 correct',
                        icon: Icons.quiz_rounded,
                        color: NorieColors.cyan,
                      ),
                      const Divider(height: 28),
                      _ResultRow(
                        label: 'Atom challenge',
                        value: '$challengeScore / 3 correct',
                        icon: Icons.hub_outlined,
                        color: NorieColors.violet,
                      ),
                      const Divider(height: 28),
                      _ResultRow(
                        label: 'Accuracy',
                        value: '${(percent * 100).round()}%',
                        icon: Icons.analytics_rounded,
                        color: NorieColors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2E1065),
                        Color(0xFF172554),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.violet.withValues(alpha: .65),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'XP EARNED',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          color: NorieColors.textSecondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '+$totalXp XP',
                        style: const TextStyle(
                          fontSize: 34,
                          color: NorieColors.orange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Quiz +$quizXp  ·  Challenge +$challengeXp  ·  Completion +$completionXp',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: NorieColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: NorieColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: NorieColors.cyan,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Atomic Structure mastery increased. The Periodic Table lesson is next in this learning path.',
                          style: TextStyle(
                            color: NorieColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Home'),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: NorieColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
