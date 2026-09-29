import 'norie_mascot_state.dart';

abstract final class NorieQuizReactionPolicy {
  static NorieCelebrationLevel celebrationFor({
    required int correct,
    required int total,
  }) {
    if (total <= 0) return NorieCelebrationLevel.encouraging;

    final accuracy = correct.clamp(0, total) / total;
    if (accuracy >= 1) return NorieCelebrationLevel.perfect;
    if (accuracy >= .60) return NorieCelebrationLevel.standard;
    return NorieCelebrationLevel.encouraging;
  }

  static bool shouldShowDifficultyReaction({
    required int previousTier,
    required int nextTier,
  }) {
    return nextTier > previousTier;
  }

  static int difficultyTier(String difficulty) {
    return switch (difficulty.trim().toLowerCase()) {
      'standard' || 'intermediate' || 'medium' => 2,
      'advanced' || 'challenge' || 'hard' || 'expert' => 3,
      _ => 1,
    };
  }
}
