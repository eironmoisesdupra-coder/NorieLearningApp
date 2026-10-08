import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final journey = NorieLessonJourney.instance;
  final topic = NorieFoundationCurriculum.topicsFor('Science', 'g2').first;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await journey.reset();
  });
  test('last lesson and reading offset survive reload and export', () async {
    journey.openTopic(topic.id);
    journey.recordOffset(topic.id, 456);
    await journey.flush();
    final state = journey.exportState();
    await journey.load();
    expect(journey.lastTopic?.id, topic.id);
    expect(journey.offsetFor(topic.id), 456);
    expect(journey.exportState(), state);
  });
  test('missing curriculum IDs remain portable but have no resume target',
      () async {
    await journey.replaceState({
      'last_topic_id': 'removed.lesson',
      'reading_offsets': {'removed.lesson': 72},
    });
    expect(journey.lastTopic, isNull);
    expect(journey.exportState()['last_topic_id'], 'removed.lesson');
  });
  test('invalid replacement leaves existing state intact', () async {
    journey.openTopic(topic.id);
    final before = journey.exportState();
    await expectLater(
        journey.replaceState({
          'last_topic_id': topic.id,
          'reading_offsets': {topic.id: -1},
        }),
        throwsFormatException);
    expect(journey.exportState(), before);
    await journey.flush();
  });
  test('non-finite offsets and malformed IDs are rejected', () {
    for (final offset in [double.nan, double.infinity, '300', null]) {
      expect(
          () => NorieLessonJourney.validateState({
                'last_topic_id': topic.id,
                'reading_offsets': {topic.id: offset},
              }),
          throwsFormatException);
    }
    expect(
        () => NorieLessonJourney.validateState({
              'last_topic_id': 12,
              'reading_offsets': {},
            }),
        throwsFormatException);
  });
  test('reset clears saved offsets and pending writes', () async {
    journey.openTopic(topic.id);
    journey.recordOffset(topic.id, 800);
    await journey.reset();
    await journey.load();
    expect(journey.lastTopic, isNull);
    expect(journey.offsetFor(topic.id), 0);
  });
  test('guarded replacement does not apply after account ownership changes',
      () async {
    var current = false;
    journey.openTopic(topic.id);
    await journey.flush();
    final before = journey.exportState();
    await journey.replaceState(
      {
        'last_topic_id': 'science.g2.other',
        'reading_offsets': {'science.g2.other': 12.0},
      },
      stillCurrent: () => current,
    );
    expect(journey.exportState(), before);
  });

  test(
      'grade map offsets roundtrip, legacy import clears them, and reset isolates learners',
      () async {
    await journey.saveMapOffset('science.g6', 321);
    await journey.saveMapOffset('science.g7', 654);
    await journey.load();
    expect(journey.mapOffsetFor('science.g6'), 321);
    final state = journey.exportState();
    await journey.reset();
    expect(journey.mapOffsetFor('science.g6'), isNull);
    await journey.replaceState(state);
    expect(journey.mapOffsetFor('science.g7'), 654);
    await journey.replaceState({'last_topic_id': null, 'reading_offsets': {}});
    expect(journey.mapOffsetFor('science.g7'), isNull);
  });

  test('concurrent saves and reset cannot resurrect old bookmarks', () async {
    final save = journey.saveMapOffset('science.g6', 321);
    final reset = journey.reset();
    await Future.wait([save, reset]);
    await journey.load();
    expect(journey.mapOffsetFor('science.g6'), isNull);
  });

  test('guard cancellation during preparation cannot partially apply state',
      () async {
    journey.openTopic(topic.id);
    var current = true;
    var committed = false;
    final operation = journey.replaceState(NorieLessonJourney.emptyState,
        stillCurrent: () => current, onApply: () => committed = true);
    current = false;
    expect(await operation, isFalse);
    expect(committed, isFalse);
    expect(journey.lastTopicId, topic.id);
  });

  test('malformed map offsets and unknown journey fields are rejected', () {
    for (final offset in [-1, double.infinity, '20']) {
      expect(
          () => NorieLessonJourney.validateState({
                ...NorieLessonJourney.emptyState,
                'map_offsets': {'science.g6': offset},
              }),
          throwsFormatException);
    }
    expect(
        () => NorieLessonJourney.validateState({
              ...NorieLessonJourney.emptyState,
              'access_token': 'secret',
            }),
        throwsFormatException);
  });
}
