import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/mascot/norie_mentor_feedback.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final at = DateTime.utc(2026, 10, 15);
  late NorieAdventureProgress evidence;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    NorieProgression.instance.resetAsyncQueuesForTesting();
    await NorieProgression.instance.load();
    evidence = NorieAdventureProgress();
  });
  final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').first;
  void seed(
      {int percent = 100,
      bool retained = false,
      bool due = false,
      bool improved = false,
      List<String> concepts = const []}) {
    final first = at.subtract(const Duration(days: 3));
    evidence.applyValidatedState({
      ...NorieAdventureProgress.emptyState,
      'evidence': {
        topic.id: NorieLessonEvidence(
                firstPassedAt: retained || due ? first : null,
                retainedAt:
                    retained ? first.add(const Duration(days: 1)) : null,
                lastAttemptAt: at.subtract(const Duration(hours: 1)),
                lastPercent: percent,
                bestPercent: 100,
                priorityConcepts: concepts)
            .toJson()
      },
      'trophies': {
        if (improved) 'improvement:${topic.id}': at.toIso8601String()
      }
    }, persist: false);
  }

  test('new learner advice invents no progress or strengths', () {
    final message = NorieMentorFeedback.current(adventure: evidence, at: at);
    expect(message.kind, 'start');
    expect(message.topic, isNull);
    expect(message.body, contains('Complete a lesson'));
  });
  test('latest mistakes take priority over historical retained strength', () {
    seed(percent: 40, retained: true, concepts: ['Observation']);
    final message = NorieMentorFeedback.current(adventure: evidence, at: at);
    expect(message.kind, 'priority');
    expect(message.topic?.id, topic.id);
    expect(message.body, contains(topic.title));
    expect(message.body, contains('Observation'));
    expect(message.body, isNot(contains('angry')));
  });
  test('due independent evidence points directly to delayed review', () {
    seed(due: true);
    final message = NorieMentorFeedback.current(adventure: evidence, at: at);
    expect(message.kind, 'retention');
    expect(message.topic?.id, topic.id);
  });
  test('earned improvement is praised without inventing a percentage trend',
      () {
    seed(percent: 90, retained: true, improved: true);
    final message = NorieMentorFeedback.current(adventure: evidence, at: at);
    expect(message.kind, 'improvement');
    expect(message.body, contains('improvement badge'));
    expect(message.body, isNot(contains('100%')));
    expect(message.topic?.id, topic.id);
  });
  test(
      'retained evidence can be celebrated without promising permanent mastery',
      () {
    seed(retained: true);
    final message = NorieMentorFeedback.current(adventure: evidence, at: at);
    expect(message.kind, 'strength');
    expect(message.topic?.id, topic.id);
  });
}
