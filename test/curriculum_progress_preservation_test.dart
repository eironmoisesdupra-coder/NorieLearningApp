import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saved historical lessons still open without republishing old paths',
      () {
    const retiredId = 'science.g1.living-nonliving-things';
    final current = NorieFoundationCurriculum.topicsFor('Science', 'g1');
    expect(current.map((topic) => topic.id), isNot(contains(retiredId)));
    final historical = NorieLessonJourney.resolveTopic(retiredId);
    expect(historical?.id, retiredId);
    for (final topic in current) {
      expect(NorieLessonJourney.resolveTopic(topic.id), same(topic));
    }
  });

  test('replacing a path retains earned XP and historical completions',
      () async {
    const retiredId = 'mathematics.college.differential-calculus';
    SharedPreferences.setMockInitialValues({
      'norie.totalXp': 1250,
      'norie.credits': 75,
      'norie.completedLessons': 1,
      'norie.completedTopicIds': <String>[retiredId],
      'norie.rewardedLessonTopics': <String>[retiredId],
    });
    final progression = NorieProgression.instance;
    await progression.load();
    final before = progression.exportCloudState();

    final topics =
        NorieFoundationCurriculum.topicsFor('Mathematics', 'college');
    expect(topics.any((topic) => topic.id == retiredId), isFalse);
    expect(
        topics.any((topic) => progression.isTopicCompleted(topic.id)), isFalse);
    expect(progression.isTopicCompleted(retiredId), isTrue);
    expect(progression.exportCloudState(), before);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('norie.totalXp'), 1250);
    expect(preferences.getStringList('norie.completedTopicIds'), [retiredId]);
  });
}
