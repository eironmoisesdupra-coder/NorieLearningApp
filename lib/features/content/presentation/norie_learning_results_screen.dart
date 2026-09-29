import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_reward_feedback.dart';
import '../domain/norie_content_models.dart';
import 'norie_content_theme.dart';

class NorieLearningResultsScreen extends StatefulWidget {
  const NorieLearningResultsScreen({
    required this.topic,
    required this.quizScore,
    required this.challengeScore,
    super.key,
  });

  final NorieTopicContent topic;
  final int quizScore;
  final int challengeScore;

  @override
  State<NorieLearningResultsScreen> createState() =>
      _NorieLearningResultsScreenState();
}

class _NorieLearningResultsScreenState
    extends State<NorieLearningResultsScreen> {
  late final int _quizXp;
  late final int _challengeXp;
  late final int _completionXp;
  late final int _totalXp;
  late final NorieXpAward _award;
  late final NorieLessonCompletion _lessonCompletion;
  late final List<NorieAchievement> _newAchievements;

  @override
  void initState() {
    super.initState();

    _quizXp = widget.quizScore * widget.topic.quiz.xpPerCorrect;
    _challengeXp =
        widget.challengeScore * widget.topic.challenge.xpPerCorrect;
    _completionXp = widget.topic.lesson.completionXp;
    _totalXp = _quizXp + _challengeXp + _completionXp;

    final progression = NorieProgression.instance;
    final unlockedBefore = progression.achievements
        .where((achievement) => achievement.unlocked)
        .map((achievement) => achievement.id)
        .toSet();

    _lessonCompletion = progression.recordLessonCompletion(
      quizScore: widget.quizScore,
      challengeScore: widget.challengeScore,
      category: widget.topic.category,
      topic: widget.topic.title,
      topicId: widget.topic.id,
      quizAttempts: widget.topic.quiz.questions.length,
      challengeAttempts: widget.topic.challenge.rounds.length,
    );
    _award = progression.addXp(_totalXp);

    _newAchievements = progression.achievements
        .where(
          (achievement) =>
              achievement.unlocked &&
              !unlockedBefore.contains(achievement.id),
        )
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NorieRewardPopup.show(
        context,
        credits: _lessonCompletion.creditsAwarded,
        xp: _totalXp,
        title: _lessonCompletion.creditsAwarded > 0
            ? 'Lesson rewards!'
            : 'XP earned!',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizTotal = widget.topic.quiz.questions.length;
    final challengeTotal = widget.topic.challenge.rounds.length;
    final totalAttempts = quizTotal + challengeTotal;
    final totalCorrect = widget.quizScore + widget.challengeScore;
    final percent = totalAttempts == 0 ? 0 : totalCorrect / totalAttempts;
    final after = _award.after;
    final accent = norieContentAccent(widget.topic.accent);

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
                      gradient: LinearGradient(
                        colors: [
                          accent,
                          NorieColors.primary,
                          NorieColors.magenta,
                        ],
                      ),
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
                      : '${widget.topic.title} · ${widget.topic.category}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                if (_newAchievements.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _Notice(
                    icon: Icons.emoji_events_rounded,
                    color: NorieColors.green,
                    text: _newAchievements.length == 1
                        ? 'Achievement unlocked: ${_newAchievements.first.title}'
                        : '${_newAchievements.length} achievements unlocked!',
                  ),
                ],
                if (_award.rankChanged) ...[
                  const SizedBox(height: 14),
                  _Notice(
                    icon: Icons.auto_awesome_rounded,
                    color: NorieColors.violet,
                    text: 'New rank unlocked: ${after.title}',
                  ),
                ],
                const SizedBox(height: 14),
                NorieRewardBanner(
                  credits: _lessonCompletion.creditsAwarded,
                  xp: _totalXp,
                  title: _lessonCompletion.perfectRewardAwarded
                      ? 'Perfect clear reward'
                      : 'Lesson reward claimed',
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
                        value: '${widget.quizScore} / $quizTotal correct',
                        icon: Icons.quiz_rounded,
                        color: accent,
                      ),
                      const Divider(height: 28),
                      _ResultRow(
                        label: 'Challenge',
                        value:
                            '${widget.challengeScore} / $challengeTotal correct',
                        icon: Icons.extension_rounded,
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
                      LinearProgressIndicator(
                        value: after.progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(99),
                        color: accent,
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
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${widget.topic.title} mastery has been updated from this lesson evidence.',
                          style: const TextStyle(
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
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Home'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
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

class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .55)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
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
