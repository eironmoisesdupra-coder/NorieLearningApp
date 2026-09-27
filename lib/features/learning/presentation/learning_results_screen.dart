import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';

class LearningResultsScreen extends StatefulWidget {
  const LearningResultsScreen({
    required this.quizScore,
    required this.challengeScore,
    super.key,
  });

  final int quizScore;
  final int challengeScore;

  @override
  State<LearningResultsScreen> createState() => _LearningResultsScreenState();
}

class _LearningResultsScreenState extends State<LearningResultsScreen> {
  late final int _quizXp;
  late final int _challengeXp;
  late final int _completionXp;
  late final int _totalXp;
  late final NorieXpAward _award;

  @override
  void initState() {
    super.initState();
    _quizXp = widget.quizScore * 20;
    _challengeXp = widget.challengeScore * 25;
    _completionXp = 50;
    _totalXp = _quizXp + _challengeXp + _completionXp;
    _award = NorieProgression.instance.addXp(_totalXp);
  }

  @override
  Widget build(BuildContext context) {
    final percent = widget.quizScore / 5;
    final after = _award.after;

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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          NorieColors.cyan,
                          NorieColors.primary,
                          NorieColors.magenta,
                        ],
                      ),
                      boxShadow: [
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
                Text(
                  _award.leveledUp ? 'Level up!' : 'Lesson complete!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _award.leveledUp
                      ? 'Level ${_award.before.level} → Level ${after.level} · ${after.title}'
                      : 'Atomic Structure · Chemistry',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                if (_award.rankChanged) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: NorieColors.violet.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: NorieColors.violet.withValues(alpha: .65),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: NorieColors.violet,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'New rank unlocked: ${after.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: NorieColors.violet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                        value: '${widget.quizScore} / 5 correct',
                        icon: Icons.quiz_rounded,
                        color: NorieColors.cyan,
                      ),
                      const Divider(height: 28),
                      _ResultRow(
                        label: 'Atom challenge',
                        value: '${widget.challengeScore} / 3 correct',
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
                        '+$_totalXp XP',
                        style: const TextStyle(
                          fontSize: 34,
                          color: NorieColors.orange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Quiz +$_quizXp  ·  Challenge +$_challengeXp  ·  Completion +$_completionXp',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Level ${after.level} · ${after.title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            after.isMaxLevel
                                ? 'MAX LEVEL'
                                : '${after.xpIntoLevel} / ${after.xpRequiredForNextLevel} XP',
                            style: const TextStyle(
                              color: NorieColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      LinearProgressIndicator(
                        value: after.progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(99),
                        color: NorieColors.cyan,
                        backgroundColor: NorieColors.surfaceElevated,
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
