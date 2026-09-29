import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
  });

  test('lesson and perfect rewards are only granted once per topic', () {
    final progression = NorieProgression.instance;

    final first = progression.recordLessonCompletion(
      quizScore: 5,
      challengeScore: 3,
      topicId: 'science.chemistry.atomic-structure',
      quizAttempts: 5,
      challengeAttempts: 3,
    );

    expect(first.lessonRewardAwarded, isTrue);
    expect(first.perfectRewardAwarded, isTrue);
    expect(
      first.creditsAwarded,
      NorieEconomyRules.lessonCompletionCredits +
          NorieEconomyRules.perfectLessonCredits,
    );
    expect(progression.credits, first.creditsAwarded);

    final replay = progression.recordLessonCompletion(
      quizScore: 5,
      challengeScore: 3,
      topicId: 'science.chemistry.atomic-structure',
      quizAttempts: 5,
      challengeAttempts: 3,
    );

    expect(replay.creditsAwarded, 0);
    expect(replay.lessonRewardAwarded, isFalse);
    expect(replay.perfectRewardAwarded, isFalse);
    expect(progression.credits, first.creditsAwarded);
  });

  test('perfect bonus can be earned later without repeating completion reward', () {
    final progression = NorieProgression.instance;

    final first = progression.recordLessonCompletion(
      quizScore: 4,
      challengeScore: 2,
      topicId: 'science.chemistry.periodic-table',
      quizAttempts: 5,
      challengeAttempts: 3,
    );

    expect(first.creditsAwarded, NorieEconomyRules.lessonCompletionCredits);

    final perfect = progression.recordLessonCompletion(
      quizScore: 5,
      challengeScore: 3,
      topicId: 'science.chemistry.periodic-table',
      quizAttempts: 5,
      challengeAttempts: 3,
    );

    expect(perfect.lessonRewardAwarded, isFalse);
    expect(perfect.perfectRewardAwarded, isTrue);
    expect(perfect.creditsAwarded, NorieEconomyRules.perfectLessonCredits);
  });

  test('daily challenge credits cannot be farmed on the same day', () {
    final progression = NorieProgression.instance;
    final day = DateTime(2026, 9, 29, 12);

    final first = progression.recordChallengeCompletion(
      mode: NorieChallengeMode.daily,
      correct: 5,
      total: 5,
      completedAt: day,
    );
    final replay = progression.recordChallengeCompletion(
      mode: NorieChallengeMode.daily,
      correct: 5,
      total: 5,
      completedAt: day,
    );

    expect(first.creditsAwarded, NorieEconomyRules.dailyChallengeCredits);
    expect(replay.creditsAwarded, 0);
  });

  test('weekly goal adds its one-time credit bonus', () {
    final progression = NorieProgression.instance;
    NorieChallengeCompletion? finalDay;

    for (var index = 0; index < NorieChallengeRules.weeklyGoalDays; index++) {
      finalDay = progression.recordChallengeCompletion(
        mode: NorieChallengeMode.daily,
        correct: 4,
        total: 5,
        completedAt: DateTime(2026, 9, 28 + index, 12),
      );
    }

    expect(finalDay, isNotNull);
    expect(finalDay!.weeklyRewardAwarded, isTrue);
    expect(
      finalDay.creditsAwarded,
      NorieEconomyRules.dailyChallengeCredits +
          NorieEconomyRules.weeklyGoalCredits,
    );
  });
}
