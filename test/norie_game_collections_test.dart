import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/quiz/quiz_result_summary.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:norie_learning/features/profile/domain/norie_profile_appearance.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_review_quest.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
  });
  test(
      'same learner merges permanent trophies and rank ownership without overwriting chosen appearance',
      () async {
    final progression = NorieProgression.instance;
    final before = progression.exportCloudState();
    final other = {
      ...before,
      'total_xp': 1000,
      'completed_topic_ids': ['old-topic'],
      'profile_appearance': {
        'version': 1,
        'rankLevel': 30,
        'appearance': const NorieProfileAppearance().toJson(),
        'presets': []
      },
      'adventure_progress': {
        'version': 1,
        'evidence': {},
        'trophies': {'grade:science.g1': DateTime.utc(2026).toIso8601String()},
        'receipts': []
      }
    };
    final merged = NorieProgression.mergePermanentCollections(before, other);
    expect(merged['total_xp'], 1000);
    expect(merged['completed_topic_ids'], contains('old-topic'));
    expect((merged['profile_appearance'] as Map)['rankLevel'], 30);
    expect(((merged['adventure_progress'] as Map)['trophies'] as Map).keys,
        contains('grade:science.g1'));
    expect(merged['profile_appearance']['appearance'],
        before['profile_appearance']['appearance']);
    await progression.importCloudState(merged);
    expect(NorieAdventureProgress.instance.trophyIds,
        contains('grade:science.g1'));
    await progression.resetForNewAccount();
    expect(NorieAdventureProgress.instance.trophyIds, isEmpty);
    expect(NorieProfileAppearanceStore.instance.rankLevel, 1);
  });
  test(
      'assessment reward receipts survive restore and reject duplicate route awards',
      () async {
    final progression = NorieProgression.instance;
    expect(progression.claimAssessmentAttempt('topic:attempt'), true);
    progression.addXp(50);
    final state = progression.exportCloudState();
    await progression.resetForNewAccount();
    await progression.importCloudState(state);
    expect(progression.claimAssessmentAttempt('topic:attempt'), false);
    expect(progression.claimAssessmentAttempt('topic:next-attempt'), true);
  });
  test(
      'drills use actual missed concepts and varied equivalent authored questions',
      () async {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g3').first;
    final q = topic.quiz.questions.first;
    await NorieAdventureProgress.instance
        .recordAttempt(topicId: topic.id, attemptId: 'missed', answers: [
      QuizAnswerRecord(
          questionId: q.id,
          prompt: q.prompt,
          response: 'wrong',
          correctAnswer: q.options[q.correctIndex],
          explanation: q.explanation,
          correct: false,
          conceptId: q.conceptId,
          conceptLabel: q.conceptLabel)
    ]);
    final drill =
        NorieReviewQuestPolicy.select(topic, NorieReviewQuestKind.mistakeDrill);
    expect(drill, isNotEmpty);
    expect(drill.length, lessThanOrEqualTo(5));
    expect(drill.map((q) => q.id).toSet().length, drill.length);
    expect(
        drill.every(
            (item) => item.conceptLabel == q.conceptLabel || item.id == q.id),
        true);
    final chapter = NorieReviewQuestPolicy.chapterQuestions([topic]);
    expect(chapter.length, 5);
    expect(
        chapter.any((item) =>
            topic.challenge.rounds.any((mastery) => mastery.id == item.id)),
        true);
  });
}
