import 'package:flutter/material.dart';

import '../../../core/assets/norie_assets.dart';
import 'package:uuid/uuid.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_reward_feedback.dart';
import 'challenge_quiz_screen.dart';

class ChallengeResultsScreen extends StatefulWidget {
  const ChallengeResultsScreen({
    required this.mode,
    required this.correct,
    required this.total,
    this.secondsRemaining,
    this.attemptId,
    this.historyKey,
    this.answers = const [],
    super.key,
  });

  final NorieChallengeMode mode;
  final int correct;
  final int total;
  final int? secondsRemaining;
  final String? attemptId;
  final String? historyKey;
  final List<QuizAnswerRecord> answers;

  @override
  State<ChallengeResultsScreen> createState() => _ChallengeResultsScreenState();
}

class _ChallengeResultsScreenState extends State<ChallengeResultsScreen> {
  static final _receipts = <String, _ChallengeRewardReceipt>{};
  late final _attemptId = widget.attemptId ?? const Uuid().v4();
  late final NorieChallengeCompletion _completion;
  late final List<NorieAchievement> _newAchievements;

  bool get _isSpeed => widget.mode == NorieChallengeMode.speed;

  @override
  void initState() {
    super.initState();

    final receipt = _receipts.putIfAbsent(_attemptId, () {
      final progression = NorieProgression.instance;
      final unlockedBefore = progression.achievements
          .where((a) => a.unlocked)
          .map((a) => a.id)
          .toSet();
      final completion = progression.recordChallengeCompletion(
          mode: widget.mode, correct: widget.correct, total: widget.total);
      return _ChallengeRewardReceipt(
          completion,
          progression.achievements
              .where((a) => a.unlocked && !unlockedBefore.contains(a.id))
              .toList());
    });
    _completion = receipt.completion;
    _newAchievements = receipt.achievements;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showOutro();
    });
  }

  Future<void> _showOutro() async {
    final action = await NorieQuizOutro.show(context,
        canViewDetails: true,
        summary: QuizResultSummary(
            attemptId: _attemptId,
            historyKey: widget.historyKey ??
                quizHistoryKey('challenge:${widget.mode.name}',
                    widget.answers.map((a) => a.questionId)),
            title: _isSpeed ? 'Speed Challenge' : 'Daily Challenge',
            correctCount: widget.correct,
            totalCount: widget.total,
            xpEarned: _completion.totalXpAwarded,
            answers: widget.answers));
    if (!mounted || action == QuizOutroAction.viewDetails) return;
    if (action == QuizOutroAction.retry) {
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
          builder: (_) => ChallengeQuizScreen(mode: widget.mode)));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent =
        widget.total == 0 ? 0 : ((widget.correct / widget.total) * 100).round();
    final noXp = _completion.totalXpAwarded == 0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
              children: [
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: Image.asset(
                      NorieAssets.mascotCelebrating,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isSpeed
                      ? 'Speed run complete!'
                      : 'Daily challenge complete!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${widget.correct} / ${widget.total} correct · $percent%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                if (_isSpeed && widget.secondsRemaining != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    '${widget.secondsRemaining}s remaining',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: NorieColors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                NorieRewardBanner(
                  credits: _completion.creditsAwarded,
                  xp: _completion.totalXpAwarded,
                  title: _completion.weeklyRewardAwarded
                      ? 'Weekly reward claimed'
                      : 'Challenge reward claimed',
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF25145B),
                        Color(0xFF172554),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.violet.withValues(alpha: .55),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        noXp ? 'PRACTICE REPLAY' : 'XP EARNED',
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          fontSize: 10,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        noXp
                            ? 'Rewards already claimed today'
                            : '+${_completion.totalXpAwarded} XP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: noXp
                              ? NorieColors.textSecondary
                              : NorieColors.orange,
                          fontSize: noXp ? 18 : 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _RewardRow(
                        label: 'Score XP',
                        value: '+${_completion.baseXp}',
                      ),
                      const SizedBox(height: 7),
                      _RewardRow(
                        label: 'Bonus XP',
                        value: '+${_completion.bonusXp}',
                      ),
                      if (_completion.dailyRewardAwarded) ...[
                        const SizedBox(height: 7),
                        const _RewardNote(
                          icon: Icons.calendar_today_rounded,
                          text: 'Daily completion bonus · +25 Credits.',
                          color: NorieColors.magenta,
                        ),
                      ],
                      if (_completion.weeklyRewardAwarded) ...[
                        const SizedBox(height: 7),
                        const _RewardNote(
                          icon: Icons.emoji_events_rounded,
                          text: 'Weekly goal · +250 XP · +100 Credits!',
                          color: NorieColors.orange,
                        ),
                      ],
                      if (_completion.bestScoreImproved) ...[
                        const SizedBox(height: 7),
                        const _RewardNote(
                          icon: Icons.bolt_rounded,
                          text: 'New Speed Quiz personal best.',
                          color: NorieColors.cyan,
                        ),
                      ],
                    ],
                  ),
                ),
                if (_completion.leveledUp || _completion.rankChanged) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: NorieColors.cyan.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: NorieColors.cyan.withValues(alpha: .45),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_up_rounded,
                          color: NorieColors.cyan,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _completion.rankChanged
                                ? 'New rank: ${_completion.after.title}'
                                : 'Level ${_completion.before.level} → ${_completion.after.level}',
                            style: const TextStyle(
                              color: NorieColors.cyan,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_newAchievements.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: NorieColors.green.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: NorieColors.green.withValues(alpha: .45),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: NorieColors.green,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _newAchievements.length == 1
                                ? 'Achievement unlocked: ${_newAchievements.first.title}'
                                : '${_newAchievements.length} achievements unlocked!',
                            style: const TextStyle(
                              color: NorieColors.green,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: NorieProgression.instance,
                  builder: (context, _) {
                    final progression = NorieProgression.instance;
                    final snapshot = progression.snapshot;

                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: NorieColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: NorieColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Level ${snapshot.level} · ${snapshot.title}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text(
                                '${snapshot.totalXp} XP',
                                style: const TextStyle(
                                  color: NorieColors.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: snapshot.progress,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(99),
                            color: NorieColors.cyan,
                            backgroundColor: NorieColors.surfaceElevated,
                          ),
                          const SizedBox(height: 13),
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                size: 17,
                                color: NorieColors.orange,
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  'Weekly goal: ${progression.weeklyChallengeDays} / ${NorieChallengeRules.weeklyGoalDays} days',
                                  style: const TextStyle(
                                    color: NorieColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to Challenge'),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => ChallengeQuizScreen(
                          mode: widget.mode,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    _isSpeed ? 'Try Speed Quiz again' : 'Practice again',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
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

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _RewardNote extends StatelessWidget {
  const _RewardNote({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChallengeRewardReceipt {
  const _ChallengeRewardReceipt(this.completion, this.achievements);
  final NorieChallengeCompletion completion;
  final List<NorieAchievement> achievements;
}
