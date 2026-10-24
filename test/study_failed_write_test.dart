import 'dart:convert';
import 'dart:async';

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
  bool failReadAfterDeniedWrite = false;
  @override
  Future<Map<String, Object>> getAll() async {
    if (unreadable) throw StateError("Device storage unavailable");
    return super.getAll();
  }

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (full) {
      if (failReadAfterDeniedWrite) unreadable = true;
      return false;
    }
    return super.setValue(type, key, value);
  }
}

class _SwitchingDisk extends InMemorySharedPreferencesStore {
  _SwitchingDisk() : super.empty();
  final started = Completer<void>();
  final release = Completer<void>();
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (key == 'flutter.norie.study.alice.offline.v1') {
      started.complete();
      await release.future;
    }
    if (key == 'flutter.norie.study.bob.offline.v1') return false;
    return super.setValue(type, key, value);
  }
}

class _UnrelatedProgressDisk extends InMemorySharedPreferencesStore {
  _UnrelatedProgressDisk() : super.empty();
  bool failStudy = false;
  final started = Completer<void>();
  final release = Completer<void>();
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (failStudy && key.startsWith('flutter.norie.study.')) return false;
    if (key == 'flutter.norie.completedLessons') {
      started.complete();
      await release.future;
    }
    return super.setValue(type, key, value);
  }
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
  test('failed write and recovery read cannot expose an optimistic save',
      () async {
    final store = NorieStudyOfflineStore('local');
    final set = fixture();
    await SharedPreferences.getInstance();
    disk.full = true;
    disk.failReadAfterDeniedWrite = true;
    await expectLater(store.saveSet(set), throwsStateError);
    await expectLater(store.getSet(set.id), throwsStateError);
    await expectLater(store.listSets(), throwsStateError);
    disk.unreadable = false;
    disk.failReadAfterDeniedWrite = false;
    expect(await store.getSet(set.id), isNull);
    disk.full = false;
    await store.saveSet(set);
    expect((await store.getSet(set.id))!.title, set.title);
  });
  test('another learner failed save cannot hide an in-flight durable deck',
      () async {
    final disk = _SwitchingDisk();
    SharedPreferencesStorePlatform.instance = disk;
    final alice = NorieStudyOfflineStore('alice');
    final pending = alice.saveSet(fixture());
    await disk.started.future;
    await expectLater(
        NorieStudyOfflineStore('bob').saveSet(fixture()), throwsStateError);
    disk.release.complete();
    await pending;
    expect((await alice.getSet(fixture().id))?.title, fixture().title);
  });

  test('failed edit restores exactly the previous Study cache bytes', () async {
    final preferences = await SharedPreferences.getInstance();
    const original = '  {"sets":{}, "sourceReviews":{}}  ';
    await preferences.setString('norie.study.local.offline.v1', original);
    disk.full = true;
    await expectLater(
        NorieStudyOfflineStore('local').saveSet(fixture()), throwsStateError);
    expect(preferences.getString('norie.study.local.offline.v1'), original);
    expect((await disk.getAll())['flutter.norie.study.local.offline.v1'],
        original);
  });
  for (final failedWrite in [false, true]) {
    test(
        'Study operation preserves unrelated pending progress (failedWrite=$failedWrite)',
        () async {
      final disk = _UnrelatedProgressDisk();
      SharedPreferencesStorePlatform.instance = disk;
      final preferences = await SharedPreferences.getInstance();
      final pending = preferences.setInt('norie.completedLessons', 4);
      await disk.started.future;
      if (failedWrite) {
        disk.failStudy = true;
        await expectLater(NorieStudyOfflineStore('local').saveSet(fixture()),
            throwsStateError);
      } else {
        await NorieStudyOfflineStore('local').getSet('unrelated-read');
      }
      disk.release.complete();
      expect(await pending, isTrue);
      expect(preferences.getInt('norie.completedLessons'), 4);
      expect((await disk.getAll())['flutter.norie.completedLessons'], 4);
    });
  }
}
