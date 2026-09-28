import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/challenge/domain/challenge_question.dart';

void main() {
  group('Norie Challenge Mode', () {
    test('daily and speed question counts match the game rules', () {
      expect(
        NorieChallengeBank.dailyQuestions().length,
        NorieChallengeRules.dailyQuestionCount,
      );
      expect(
        NorieChallengeBank.speedQuestions().length,
        NorieChallengeRules.speedQuestionCount,
      );
    });

    test('every challenge question has a valid correct answer', () {
      for (final question in NorieChallengeBank.questions) {
        expect(question.options, isNotEmpty);
        expect(question.correctIndex, greaterThanOrEqualTo(0));
        expect(question.correctIndex, lessThan(question.options.length));
        expect(question.topic, isNotEmpty);
        expect(question.category, isNotEmpty);
      }
    });

    test('challenge base XP follows mode-specific rules', () {
      expect(
        NorieChallengeRules.baseXp(
          mode: NorieChallengeMode.daily,
          correct: 3,
        ),
        36,
      );
      expect(
        NorieChallengeRules.baseXp(
          mode: NorieChallengeMode.speed,
          correct: 7,
        ),
        70,
      );
    });

    test('challenge constants use the approved sprint values', () {
      expect(NorieChallengeRules.dailyCompletionBonus, 100);
      expect(NorieChallengeRules.weeklyGoalDays, 5);
      expect(NorieChallengeRules.weeklyGoalBonus, 250);
      expect(NorieChallengeRules.speedDurationSeconds, 60);
    });
  });
}
