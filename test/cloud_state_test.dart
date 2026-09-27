import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
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
}
