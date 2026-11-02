import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('replacing a path retains earned XP and historical completions', () async {
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
    expect(topics.any((topic) => progression.isTopicCompleted(topic.id)), isFalse);
    expect(progression.isTopicCompleted(retiredId), isTrue);
    expect(progression.exportCloudState(), before);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('norie.totalXp'), 1250);
    expect(preferences.getStringList('norie.completedTopicIds'), [retiredId]);
  });
}
