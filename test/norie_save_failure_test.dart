import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';

class FailableStore extends InMemorySharedPreferencesStore {
  FailableStore() : super.empty();
  bool failWrites = false;
  @override
  Future<bool> setValue(String type, String key, Object value) =>
      failWrites ? Future.value(false) : super.setValue(type, key, value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
      'false preference writes do not claim success, and explicit retry persists the current award once',
      () async {
    SharedPreferences.setMockInitialValues({});
    final store = FailableStore();
    SharedPreferencesStorePlatform.instance = store;
    final progress = NorieProgression.instance;
    await progress.resetForNewAccount();
    store.failWrites = true;
    progress.addXp(50);
    await expectLater(progress.flushPendingSaves(), throwsStateError);
    expect(progress.totalXp, 50);
    expect((await store.getAll())['flutter.norie.totalXp'], 0);
    store.failWrites = false;
    await progress.flushPendingSaves(retry: true);
    await (await SharedPreferences.getInstance()).reload();
    await progress.load();
    expect(progress.totalXp, 50);
    expect((await store.getAll())['flutter.norie.totalXp'], 50);
  });
}
