import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/discovery/data/discovery_store.dart';
import 'package:norie_learning/features/discovery/domain/discovery_mission.dart';

class _DiskPreferences extends InMemorySharedPreferencesStore {
  _DiskPreferences() : super.empty();
  String? failure;

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (failure == 'throw') throw StateError('Storage unavailable');
    if (failure == 'false') return false;
    return super.setValue(type, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _DiskPreferences disk;
  final key = 'flutter.${DiscoveryStore.storageKeyFor(null)}';

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    disk = _DiskPreferences();
    SharedPreferencesStorePlatform.instance = disk;
  });

  Future<DiscoveryStore> open() async {
    // Exercise the real SharedPreferences adapter, including its optimistic
    // cache, rather than the injected read/write helpers used by store tests.
    final store = DiscoveryStore(ownerId: () => null);
    addTearDown(store.dispose);
    await store.initialize();
    return store;
  }

  for (final failure in ['false', 'throw']) {
    test('$failure preference write retry must reach durable storage',
        () async {
      final store = await open();
      disk.failure = failure;
      expect(await store.inspect(DiscoveryClue.openContainer), false);
      expect(store.error, isNotNull);
      expect((await disk.getAll())[key], isNull);

      disk.failure = null;
      expect(await store.retry(), true);
      expect(store.error, isNull);
      final encoded = (await disk.getAll())[key];
      expect(encoded, isNotNull,
          reason: 'Retry success must mean the platform persisted the case');
      final saved = jsonDecode(encoded! as String);
      expect(saved['state']['clues'], ['openContainer']);
      final resumed = await open();
      expect(resumed.state.clues, {DiscoveryClue.openContainer});
    });
  }

  test('reopening must not accept a failed cached completion or journal',
      () async {
    final store = await open();
    for (final clue in DiscoveryClue.values) {
      await store.inspect(clue);
    }
    await store.continueMission();
    await store.runTrial(warm: true);
    await store.runTrial(warm: false);
    await store.continueMission();
    await store.conclude(
        evaporation: true, evidence: DiscoveryEvidence.controlledComparison);
    disk.failure = 'throw';
    expect(await store.applyAnswer(correct: true), false);

    final reopened = await open();
    expect(reopened.state.stage, DiscoveryStage.apply);
    expect(reopened.journalEntry, isNull);
    expect(reopened.applicationAttempts, 0);

    disk.failure = null;
    expect(await store.retry(), true);
    final resumed = await open();
    expect(resumed.state.complete, true);
    expect(resumed.journalEntry, isNotNull);
    expect(resumed.applicationAttempts, 1);
    final saved = jsonDecode((await disk.getAll())[key]! as String);
    expect(saved['journal']['attempts'], 1);
  });

  test('reopening observes backend changes rather than an old cached case',
      () async {
    final store = await open();
    await store.inspect(DiscoveryClue.openContainer);
    await disk.remove(key);

    final reopened = await open();
    expect(reopened.state.stage, DiscoveryStage.inspect);
    expect(reopened.state.clues, isEmpty);
    expect(reopened.journalEntry, isNull);
  });
}
