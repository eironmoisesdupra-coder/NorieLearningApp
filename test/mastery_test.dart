import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';

void main() {
  group('Norie topic mastery', () {
    test('one correct answer does not instantly master a topic', () {
      const mastery = NorieTopicMastery(
        category: 'Science',
        topic: 'Atomic Structure',
        correct: 1,
        attempts: 1,
      );

      expect(mastery.accuracy, 1);
      expect(mastery.score, closeTo(.2, .001));
      expect(mastery.level, NorieMasteryLevel.learning);
      expect(mastery.isWeak, isFalse);
    });

    test('repeated strong evidence can reach Mastered', () {
      const mastery = NorieTopicMastery(
        category: 'Mathematics',
        topic: 'Algebra',
        correct: 5,
        attempts: 5,
      );

      expect(mastery.score, 1);
      expect(mastery.level, NorieMasteryLevel.mastered);
      expect(mastery.isWeak, isFalse);
    });

    test('low accuracy after multiple attempts becomes a weak topic', () {
      const mastery = NorieTopicMastery(
        category: 'English',
        topic: 'Grammar',
        correct: 1,
        attempts: 3,
      );

      expect(mastery.accuracy, closeTo(1 / 3, .001));
      expect(mastery.isWeak, isTrue);
      expect(mastery.level, NorieMasteryLevel.learning);
    });

    test('topic evidence accumulates correctly', () {
      const initial = NorieTopicMastery(
        category: 'Science',
        topic: 'Cell Biology',
        correct: 1,
        attempts: 2,
      );

      final updated = initial.add(
        correctAnswers: 2,
        totalAttempts: 2,
      );

      expect(updated.correct, 3);
      expect(updated.attempts, 4);
      expect(updated.accuracy, .75);
      expect(updated.isWeak, isFalse);
    });
  });
}
