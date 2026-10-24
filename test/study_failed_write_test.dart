import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'norie_study_cache_test.dart' show fixture;

class _FullStudyDisk extends InMemorySharedPreferencesStore {
  _FullStudyDisk() : super.empty();
  bool full = false;
  bool unreadable = false;
  @override
  Future<Map<String, Object>> getAll() async {
    if (unreadable) throw StateError("Device storage unavailable");
    return super.getAll();
  }

  @override
  Future<bool> setValue(String type, String key, Object value) async =>
      full ? false : super.setValue(type, key, value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _FullStudyDisk disk;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    disk = _FullStudyDisk();
    SharedPreferencesStorePlatform.instance = disk;
  });
  test('failed study creation must not reopen an optimistic unsaved deck',
      () async {
    final store = NorieStudyOfflineStore('local');
    final set = fixture();
    disk.full = true;
    await expectLater(store.saveSet(set), throwsStateError);
    expect(
        (await disk.getAll())['flutter.norie.study.local.offline.v1'], isNull);
    expect(await NorieStudyOfflineStore('local').getSet(set.id), isNull);
    disk.full = false;
    await store.saveSet(set);
    final raw = jsonDecode((await disk
        .getAll())['flutter.norie.study.local.offline.v1']! as String);
    expect(raw['sets'][set.id]['title'], 'Anatomy notes');
    await (await SharedPreferences.getInstance()).reload();
    expect((await NorieStudyOfflineStore('local').getSet(set.id))!.title,
        'Anatomy notes');
  });
  test(
      'failed edit preserves the last durable question set until explicit retry',
      () async {
    final store = NorieStudyOfflineStore('local');
    final set = fixture();
    await store.saveSet(set);
    final changed = NorieStudySet.fromMap(
        {...set.toMap(), 'title': 'Pending edit'},
        questions: set.questions);
    disk.full = true;
    await expectLater(store.saveSet(changed), throwsStateError);
    expect((await NorieStudyOfflineStore('local').getSet(set.id))!.title,
        'Anatomy notes');
    disk.full = false;
    await store.saveSet(changed);
    await (await SharedPreferences.getInstance()).reload();
    expect((await NorieStudyOfflineStore('local').getSet(set.id))!.title,
        'Pending edit');
  });
  test('failed write and failed reload cannot expose an optimistic save',
      () async {
    final store = NorieStudyOfflineStore('local');
    final set = fixture();
    await SharedPreferences.getInstance();
    disk.full = true;
    disk.unreadable = true;
    await expectLater(store.saveSet(set), throwsStateError);
    await expectLater(store.getSet(set.id), throwsStateError);
    await expectLater(store.listSets(), throwsStateError);
    disk.unreadable = false;
    expect(await store.getSet(set.id), isNull);
    disk.full = false;
    await store.saveSet(set);
    expect((await store.getSet(set.id))!.title, set.title);
  });
}
