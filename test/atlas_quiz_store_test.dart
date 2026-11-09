import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/learning/data/anatomy_atlas_quiz_store.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_quiz_snapshot.dart';
import 'anatomy_atlas_flexible_quiz_test.dart' as fixtures;

class FailedRoundDisk extends InMemorySharedPreferencesStore {
  FailedRoundDisk() : super.empty();
  bool fail = false;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (fail && key.contains('norie.atlasQuiz.round.')) {
      fail = false;
      return false;
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  final catalog = fixtures.fixture();
  final request = AtlasQuizRequest(
      reference: 'male', systems: const {'skeletal'}, requestedCount: 5);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('stored round retains exact questions, checked answer and score',
      () async {
    final store = AtlasQuizStore(owner: null);
    var round = await store.start(catalog, request);
    final quiz = round.session(catalog);
    quiz.answer(quiz.current.answer);
    round = await store.save(catalog, round.replace(catalog, quiz));
    final restored = (await AtlasQuizStore(owner: null).read(catalog))!;
    expect(restored.attemptId, round.attemptId);
    expect(restored.session(catalog).questions.map((q) => q.target.id),
        quiz.questions.map((q) => q.target.id));
    expect(restored.session(catalog).score, 1);
    expect(restored.session(catalog).checked, isTrue);
    expect(
        await AtlasQuizStore(owner: 'different-owner').read(catalog), isNull);
  });

  test('failed setter and stale writer preserve the acknowledged round',
      () async {
    final disk = FailedRoundDisk();
    SharedPreferencesStorePlatform.instance = disk;
    final store = AtlasQuizStore(owner: null);
    final round = await store.start(catalog, request);
    final quiz = round.session(catalog)
      ..answer(round.session(catalog).current.answer);
    disk.fail = true;
    await expectLater(
        store.save(catalog, round.replace(catalog, quiz)), throwsStateError);
    expect((await store.read(catalog))!.session(catalog).score, 0);
    await store.save(catalog, round.replace(catalog, quiz));
    await expectLater(store.save(catalog, round), throwsStateError);
    expect((await store.read(catalog))!.session(catalog).score, 1);
  });

  test(
      'corrupt and invalidated rounds retain original bytes until explicit restart',
      () async {
    final store = AtlasQuizStore(owner: null);
    await store.start(catalog, request);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(store.storageKey, '{damaged');
    await expectLater(store.read(catalog), throwsFormatException);
    expect(
        (await SharedPreferencesStorePlatform.instance
            .getAll())['flutter.${store.storageKey}'],
        '{damaged');
    await store.start(catalog, request, discard: true);
    final before = (await store.read(catalog))!;
    await AtlasQuizStore.invalidateOwner(null, stillCurrent: () => true);
    await expectLater(store.save(catalog, before), throwsStateError);
    expect(
        jsonDecode((await SharedPreferencesStorePlatform.instance
                .getAll())['flutter.${store.storageKey}'] as String)['round']
            ['attemptId'],
        before.attemptId);
  });

  test('unknown answers or changed catalog bindings cannot restore grading',
      () {
    final round = AtlasSavedRound.create(catalog, request, 'initial');
    final raw = jsonDecode(jsonEncode(round.toJson())) as Map<String, dynamic>;
    raw['responses'][0] = 'not a valid option';
    expect(() => AtlasSavedRound.restore(catalog, raw), throwsFormatException);
    final other = fixtures.fixture(count: 1);
    expect(() => AtlasSavedRound.restore(other, round.toJson()),
        throwsFormatException);
  });

  test(
      'unauthored distractors and a truncated saved question list cannot be graded',
      () {
    final round = AtlasSavedRound.create(catalog, request, 'initial');
    var raw = round.toJson();
    final options = raw['questions'][0]['options'] as List;
    final answer = round.session(catalog).current.answer;
    options[options.indexWhere((o) => o != answer)] =
        'fabricated unrelated option';
    expect(() => AtlasSavedRound.restore(catalog, raw), throwsFormatException);
    raw = round.toJson();
    (raw['questions'] as List).removeLast();
    (raw['responses'] as List).removeLast();
    expect(() => AtlasSavedRound.restore(catalog, raw), throwsFormatException);
  });

  test('pending completion cannot be replaced by a fresh reward identity',
      () async {
    final store = AtlasQuizStore(owner: null);
    final round = await store.start(catalog, request);
    final quiz = round.session(catalog);
    while (!quiz.finished) {
      quiz.answer(quiz.current.answer);
      quiz.next();
    }
    await store.save(catalog, round.replace(catalog, quiz));
    await expectLater(
        store.start(catalog, request, discard: true), throwsStateError);
    expect((await store.read(catalog))!.attemptId, round.attemptId);
  });

  test(
      'backup retirement cannot interleave an accepted effect or replay it afterwards',
      () async {
    final store = AtlasQuizStore(owner: null);
    final round = await store.start(catalog, request);
    final started = Completer<void>(), release = Completer<void>();
    var effects = 0;
    final effect = store.reconcileEffect(catalog, round, () async {
      started.complete();
      await release.future;
      effects++;
    });
    await started.future;
    final retire =
        AtlasQuizStore.invalidateOwner(null, stillCurrent: () => true);
    expect(
        (await SharedPreferencesStorePlatform.instance.getAll())
            .keys
            .any((k) => k.contains('atlasQuiz.epoch')),
        isFalse);
    release.complete();
    await effect;
    await retire;
    await expectLater(
        store.reconcileEffect(catalog, round, () async {
          effects++;
        }),
        throwsStateError);
    expect(effects, 1);
  });
}
