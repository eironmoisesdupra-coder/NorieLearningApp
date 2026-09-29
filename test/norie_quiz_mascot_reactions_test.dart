import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_quiz_reaction_policy.dart';
import 'package:norie_learning/core/mascot/norie_mascot_state.dart';

void main() {
  group('NorieQuizReactionPolicy', () {
    test('maps low score to encouraging celebration', () {
      expect(
        NorieQuizReactionPolicy.celebrationFor(correct: 2, total: 5),
        NorieCelebrationLevel.encouraging,
      );
    });

    test('maps non-perfect passing score to standard celebration', () {
      expect(
        NorieQuizReactionPolicy.celebrationFor(correct: 4, total: 5),
        NorieCelebrationLevel.standard,
      );
    });

    test('maps perfect score to perfect celebration', () {
      expect(
        NorieQuizReactionPolicy.celebrationFor(correct: 5, total: 5),
        NorieCelebrationLevel.perfect,
      );
    });

    test('zero-length quiz remains encouraging', () {
      expect(
        NorieQuizReactionPolicy.celebrationFor(correct: 0, total: 0),
        NorieCelebrationLevel.encouraging,
      );
    });

    test('difficulty reaction appears only when tier increases', () {
      expect(
        NorieQuizReactionPolicy.shouldShowDifficultyReaction(
          previousTier: 1,
          nextTier: 2,
        ),
        isTrue,
      );
      expect(
        NorieQuizReactionPolicy.shouldShowDifficultyReaction(
          previousTier: 2,
          nextTier: 2,
        ),
        isFalse,
      );
      expect(
        NorieQuizReactionPolicy.shouldShowDifficultyReaction(
          previousTier: 3,
          nextTier: 1,
        ),
        isFalse,
      );
    });

    test('difficulty labels map to stable tiers', () {
      expect(NorieQuizReactionPolicy.difficultyTier('foundation'), 1);
      expect(NorieQuizReactionPolicy.difficultyTier('standard'), 2);
      expect(NorieQuizReactionPolicy.difficultyTier('advanced'), 3);
      expect(NorieQuizReactionPolicy.difficultyTier('challenge'), 3);
      expect(NorieQuizReactionPolicy.difficultyTier('unknown'), 1);
    });
  });
}
