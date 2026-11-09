import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_progress_backup.dart';

const receipt =
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const topic = 'Skeletal System';
bool current() => true;

class FailedMasteryDisk extends InMemorySharedPreferencesStore {
  FailedMasteryDisk() : super.empty();
  bool fail = false;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (fail && key == 'flutter.norie.topicMastery') {
      fail = false;
      return false;
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  final progress = NorieProgression.instance;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    progress.resetAsyncQueuesForTesting();
    await progress.load();
  });
  tearDown(() async => progress.flushPendingSaves(retry: true));

  test('Atlas answer replay after cold load increments mastery once', () async {
    final lineage =
        await progress.prepareAtlasMastery(topic, stillCurrent: current);
    Future<void> apply() => progress.recordAtlasMastery(
        topic: topic,
        lineage: lineage,
        receipt: receipt,
        correct: true,
        stillCurrent: current);
    await apply();
    await apply();
    await progress.load();
    await apply();
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.attempts, 1);
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.correct, 1);
    progress.recordTopicAnswer(
        category: 'Anatomy', topic: topic, correct: false);
    await progress.flushPendingSaves();
    await progress.load();
    await apply();
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.attempts, 2);
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.correct, 1);
    final state = progress.exportCloudState();
    NorieProgressBackup.validateState(state);
    expect((state['topic_mastery'] as Map).values.single.keys.toSet(),
        {'category', 'topic', 'correct', 'attempts'});
  });

  test('failed mastery write retries the same receipt without counting twice',
      () async {
    final disk = FailedMasteryDisk();
    SharedPreferencesStorePlatform.instance = disk;
    await progress.load();
    final lineage =
        await progress.prepareAtlasMastery(topic, stillCurrent: current);
    disk.fail = true;
    Future<void> apply() => progress.recordAtlasMastery(
        topic: topic,
        lineage: lineage,
        receipt: receipt,
        correct: true,
        stillCurrent: current);
    await expectLater(apply(), throwsStateError);
    final raw = jsonDecode(
        (await disk.getAll())['flutter.norie.topicMastery'] as String) as Map;
    expect(raw.values.single['attempts'], 0);
    await progress.load();
    await apply();
    await progress.load();
    await apply();
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.attempts, 1);
  });

  test('conflicting receipt and replaced lineage cannot apply another answer',
      () async {
    final lineage =
        await progress.prepareAtlasMastery(topic, stillCurrent: current);
    await progress.recordAtlasMastery(
        topic: topic,
        lineage: lineage,
        receipt: receipt,
        correct: true,
        stillCurrent: current);
    await expectLater(
        progress.recordAtlasMastery(
            topic: topic,
            lineage: lineage,
            receipt: receipt,
            correct: false,
            stillCurrent: current),
        throwsStateError);
    final state = progress.exportCloudState();
    await progress.importCloudState(state);
    await expectLater(
        progress.recordAtlasMastery(
            topic: topic,
            lineage: lineage,
            receipt: receipt,
            correct: true,
            stillCurrent: current),
        throwsStateError);
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.attempts, 1);
  });

  test(
      'damaged local receipts preserve original mastery bytes through other saves',
      () async {
    final validState = progress.exportCloudState();
    final raw = jsonEncode({
      'anatomy::skeletal system': {
        'category': 'Anatomy',
        'topic': topic,
        'correct': 2,
        'attempts': 3,
        '_atlas': {'version': 1, 'lineage': 'damaged', 'receipts': []}
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('norie.topicMastery', raw);
    await progress.load();
    await expectLater(
        progress.prepareAtlasMastery(topic, stillCurrent: current),
        throwsStateError);
    await expectLater(
        progress.prepareAtlasMastery(topic,
            ownerId: 'account-B', stillCurrent: current),
        throwsStateError);
    progress.addXp(1, claimKey: 'unrelated-fixture');
    await progress.flushPendingSaves(retry: true);
    expect(
        (await SharedPreferencesStorePlatform.instance
            .getAll())['flutter.norie.topicMastery'],
        raw);
    expect(() => progress.exportCloudState(), throwsStateError);
    await progress.importCloudState(validState);
    final copies = (await SharedPreferencesStorePlatform.instance.getAll())
        .entries
        .where((e) => e.key.contains('mastery.quarantineRecovery'))
        .toList();
    expect(copies, hasLength(1));
    expect(jsonDecode(copies.single.value as String)['raw'], raw);
    NorieProgressBackup.validateState(progress.exportCloudState());
  });

  test('a new learner cannot mutate progression still owned by another account',
      () async {
    await (await SharedPreferences.getInstance())
        .setString('norie.cloudOwnerUserId', 'account-A');
    await expectLater(
        progress.prepareAtlasMastery(topic, stillCurrent: current),
        throwsStateError);
    await expectLater(
        progress.prepareAtlasMastery(topic,
            ownerId: 'account-B', stillCurrent: current),
        throwsStateError);
    expect(progress.masteryFor(category: 'Anatomy', topic: topic), isNull);
  });

  test('damaged aggregate counters cannot retain acknowledged Atlas receipts',
      () async {
    final lineage =
        await progress.prepareAtlasMastery(topic, stillCurrent: current);
    await progress.recordAtlasMastery(
        topic: topic,
        lineage: lineage,
        receipt: receipt,
        correct: true,
        stillCurrent: current);
    final valid = jsonDecode((await SharedPreferencesStorePlatform.instance
        .getAll())['flutter.norie.topicMastery'] as String) as Map;
    final row = Map<String, dynamic>.from(valid.values.single as Map);
    final damaged = <Map<String, dynamic>>[
      for (final field in ['category', 'topic', 'correct', 'attempts'])
        {...row}..remove(field),
      {...row, 'correct': 0, 'attempts': 0},
      {...row, 'correct': 0, 'attempts': 1},
      {
        ...row,
        '_atlas': {
          ...Map<String, dynamic>.from(row['_atlas'] as Map),
          'receipts': {receipt: false}
        }
      },
    ];
    final prefs = await SharedPreferences.getInstance();
    for (final value in damaged) {
      final raw = jsonEncode({valid.keys.single: value});
      await prefs.setString('norie.topicMastery', raw);
      await progress.load();
      expect(() => progress.exportCloudState(), throwsStateError);
      await expectLater(
          progress.prepareAtlasMastery(topic, stillCurrent: current),
          throwsStateError);
      progress.addXp(1, claimKey: 'corrupt-counter:${damaged.indexOf(value)}');
      await progress.flushPendingSaves();
      expect(
          (await SharedPreferencesStorePlatform.instance
              .getAll())['flutter.norie.topicMastery'],
          raw);
    }
  });

  test('concurrent duplicate Atlas answers retain one counter and receipt',
      () async {
    final lineage =
        await progress.prepareAtlasMastery(topic, stillCurrent: current);
    await Future.wait([
      for (var i = 0; i < 2; i++)
        progress.recordAtlasMastery(
            topic: topic,
            lineage: lineage,
            receipt: receipt,
            correct: true,
            stillCurrent: current)
    ]);
    await progress.load();
    expect(progress.masteryFor(category: 'Anatomy', topic: topic)!.attempts, 1);
  });
}
