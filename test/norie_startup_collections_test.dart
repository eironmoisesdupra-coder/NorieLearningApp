import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_startup_collections.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

class _FullDeviceStore extends InMemorySharedPreferencesStore {
  _FullDeviceStore() : super.empty();
  bool full = false;
  @override
  Future<bool> setValue(String type, String key, Object value) =>
      full ? Future.value(false) : super.setValue(type, key, value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('full storage cannot block offline startup or lose migrated collections',
      () async {
    SharedPreferences.setMockInitialValues({});
    final storage = _FullDeviceStore();
    SharedPreferencesStorePlatform.instance = storage;
    final progression = NorieProgression.instance;
    await progression.resetForNewAccount();
    final topics = NorieFoundationCurriculum.topicsFor('Science', 'g1');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'norie.totalXp', NorieLevelSystem.totalXpRequiredForLevel(5));
    await prefs.setStringList(
        'norie.completedTopicIds', topics.take(5).map((t) => t.id).toList());
    await progression.load();
    storage.full = true;

    expect(await prepareNorieStartupCollections(), false);
    expect(progression.snapshot.level, 5);
    expect(NorieProfileAppearanceStore.instance.rankLevel, 5);
    expect(NorieAdventureProgress.instance.trophyIds,
        contains('grade:science.g1'));
    expect(topics.first.lesson.sections, isNotEmpty);
    expect(topics.first.available, true);

    storage.full = false;
    await progression.flushPendingSaves(retry: true);
    await prefs.reload();
    await NorieProfileAppearanceStore.instance.load(force: true);
    await NorieAdventureProgress.instance.load();
    expect(NorieProfileAppearanceStore.instance.rankLevel, 5);
    expect(NorieAdventureProgress.instance.trophyIds,
        contains('grade:science.g1'));
  });
}
