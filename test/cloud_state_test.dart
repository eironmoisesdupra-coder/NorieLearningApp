import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('cloud progression state exports and restores core progress', () async {
    SharedPreferences.setMockInitialValues({});

    final progression = NorieProgression.instance;
    await progression.load();
    progression.setTotalXpForTesting(2222);

    final exported = progression.exportCloudState();

    expect(exported['schema_version'], 1);
    expect(exported['total_xp'], 2222);
    expect(exported['topic_mastery'], isA<Map>());

    final remoteTime = DateTime.utc(2026, 9, 27, 10);
    final remote = Map<String, dynamic>.from(exported)
      ..['total_xp'] = 3333
      ..['modified_at'] = remoteTime.toIso8601String();

    await progression.importCloudState(
      remote,
      remoteModifiedAt: remoteTime,
    );

    expect(progression.totalXp, 3333);
    expect(progression.lastModifiedAt, remoteTime);
  });
  test(
      'malformed cloud state is rejected without partial XP or journey changes',
      () async {
    SharedPreferences.setMockInitialValues({});
    final progression = NorieProgression.instance;
    await progression.load();
    progression.setTotalXpForTesting(222);
    await NorieLessonJourney.instance.saveMapOffset('science.g6', 100);
    final before = progression.exportCloudState();
    await expectLater(
        progression.importCloudState({
          ...before,
          'total_xp': 999,
          'topic_mastery': {'broken': false},
        }),
        throwsFormatException);
    expect(progression.exportCloudState(), before);
  });

  test('account change before restore commit leaves all state intact',
      () async {
    SharedPreferences.setMockInitialValues({});
    final progression = NorieProgression.instance;
    await progression.load();
    progression.setTotalXpForTesting(123);
    await NorieLessonJourney.instance.saveMapOffset('science.g6', 321);
    final before = progression.exportCloudState();
    var current = true;
    final restore = progression.importCloudState({
      ...before,
      'total_xp': 999,
      'lesson_journey': NorieLessonJourney.emptyState,
    }, stillCurrent: () => current);
    current = false;
    expect(await restore, isFalse);
    expect(progression.exportCloudState(), before);
    final reset = progression.resetForNewAccount(stillCurrent: () => current);
    expect(await reset, isFalse);
    expect(progression.exportCloudState(), before);
  });
  test('concurrent account replacements persist the final complete snapshot',
      () async {
    SharedPreferences.setMockInitialValues({});
    final progression = NorieProgression.instance;
    await progression.load();
    final baseline = progression.exportCloudState();
    final first = progression.importCloudState({
      ...baseline,
      'total_xp': 111,
      'equipped_frame_id': 'test-frame',
      'owned_shop_items': ['test-frame'],
      'lesson_journey': {
        'last_topic_id': null,
        'reading_offsets': {},
        'map_offsets': {'science.g6': 123},
      },
    });
    final second = progression.importCloudState({
      ...baseline,
      'total_xp': 222,
      'equipped_frame_id': null,
      'owned_shop_items': [],
      'lesson_journey': NorieLessonJourney.emptyState,
    });
    expect(await first, isTrue);
    expect(await second, isTrue);
    await progression.load();
    await NorieLessonJourney.instance.load();
    final restored = progression.exportCloudState();
    expect(restored['total_xp'], 222);
    expect(restored['equipped_frame_id'], isNull);
    expect(restored['owned_shop_items'], isEmpty);
    expect(NorieLessonJourney.instance.mapOffsetFor('science.g6'), isNull);
  });
}
