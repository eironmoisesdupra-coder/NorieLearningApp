import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/data/norie_study_service.dart';
import 'package:norie_learning/features/study/data/quiz_generation/native_quiz_repository.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'hybrid_quiz_generation_test.dart' show request;
import 'norie_study_cache_test.dart' show fixture;
import 'norie_study_sync_test.dart' show clientFor;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  NativeQuizRepository repo(String owner, {bool Function()? current}) =>
      NativeQuizRepository(
          store: NorieStudyOfflineStore(owner),
          stillCurrent: current ?? () => true);
  test(
      'native deck survives repository restart, carries provenance and reuses reward identity',
      () async {
    final set =
        await repo('alice').create(request(count: 5), title: 'Practice');
    expect(set.isNative, isTrue);
    expect(set.ownerId, 'alice');
    expect(set.generationMetadata['validation'], 'computationallyChecked');
    final restored = (await NorieStudyOfflineStore('alice').getSet(set.id))!;
    expect(restored.toMap(), set.toMap());
    expect(await NorieStudyOfflineStore('bob').listSets(), isEmpty);
    final again =
        await repo('alice').create(request(count: 5), title: 'Other title');
    expect(again.id, set.id);
    final answers = set.questions
        .map((q) => NorieStudyAnswer(
            question: q, response: q.correctValues.single, correct: true))
        .toList();
    final first = await NorieStudyOfflineStore('alice')
        .recordAttempt(studySet: set, answers: answers);
    expect(first.xpAwarded, 45);
    expect(
        (await NorieStudyOfflineStore('alice')
                .recordAttempt(studySet: again, answers: answers))
            .xpAwarded,
        0);
  });
  test('account change prevents native save and corrupted cache is preserved',
      () async {
    await expectLater(repo('alice', current: () => false).create(request()),
        throwsStateError);
    expect(await NorieStudyOfflineStore('alice').listSets(), isEmpty);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('norie.study.alice.offline.v1', '{broken');
    await expectLater(repo('alice').create(request()), throwsStateError);
    expect(prefs.getString('norie.study.alice.offline.v1'), '{broken');
  });
  test(
      'empty successful cloud refresh retains native deck and never uploads its edits or attempts',
      () async {
    var mutations = 0;
    final client = await clientFor(MockClient((req) async {
      if (req.method != 'GET') {
        mutations++;
        return http.Response('', 201, request: req);
      }
      return http.Response('[]', 200,
          request: req, headers: {'content-type': 'application/json'});
    }));
    final set = await repo('alice').create(request(count: 5));
    final store = NorieStudyOfflineStore('alice');
    await store.recordAttempt(studySet: set, answers: const []);
    final service = NorieStudyService.forTesting(client);
    final list = await service.listStudySets(refresh: true);
    await service.syncPendingAttempts();
    expect(list.map((s) => s.id), contains(set.id));
    expect(mutations, 0);
    expect(await store.getSet(set.id), isNotNull);
    await service.deleteStudySet(set);
    expect(await store.getSet(set.id), isNull);
    expect(mutations, 0);
  });
  test(
      'opening a cached native deck never asks the cloud to delete its absent row',
      () async {
    var reads = 0;
    final client = await clientFor(MockClient((req) async {
      reads++;
      return http.Response('[]', 200,
          request: req, headers: {'content-type': 'application/json'});
    }));
    final set = await repo('alice').create(request(count: 5));
    await NorieStudyService.forTesting(client).getStudySet(set.id);
    for (var i = 0; i < 10; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(await NorieStudyOfflineStore('alice').getSet(set.id), isNotNull);
    expect(reads, 0);
  });
  test('native answer proofs cannot be retained after an arbitrary card edit',
      () async {
    final set = await repo('alice').create(request(count: 5));
    final changed = NorieStudyQuestion.fromMap({
      ...set.questions.first.toMap(),
      'correct_values': ['99999']
    });
    await expectLater(NorieStudyOfflineStore('alice').editCard(set, changed),
        throwsStateError);
    expect(
        (await NorieStudyOfflineStore('alice').getSet(set.id))!
            .questions
            .first
            .correctValues,
        set.questions.first.correctValues);
  });
  test(
      'account switch during the final native read cannot return another owner deck',
      () async {
    var current = true;
    final store = SwitchOnFinalReadStore(() => current = false);
    await expectLater(
        NativeQuizRepository(store: store, stillCurrent: () => current)
            .create(request(count: 5)),
        throwsStateError);
    expect(await NorieStudyOfflineStore('bob').listSets(), isEmpty);
  });
  test(
      'completed native identities are retained for explicit no-repeat practice',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = await repo('alice').create(request(count: 5));
    expect(await store.completedNativeIdentities(), isEmpty);
    await store.recordAttempt(
        studySet: set,
        answers: set.questions
            .map((q) => NorieStudyAnswer(
                question: q, response: q.correctValues.single, correct: true))
            .toList());
    final completed = await store.completedNativeIdentities();
    expect(completed, hasLength(5));
    expect(
        completed,
        containsAll((set.generationMetadata['questions'] as List)
            .map((q) => q['identity'])));
    expect(await NorieStudyOfflineStore('bob').completedNativeIdentities(),
        isEmpty);
  });
  test('historical study JSON remains readable without generation metadata',
      () {
    final old = fixture();
    final copy = NorieStudySet.fromMap(jsonDecode(jsonEncode(old.toMap())),
        questions: old.questions);
    expect(copy.isNative, isFalse);
    expect(copy.generationMetadata, isEmpty);
    expect(copy.id, old.id);
  });
  test(
      'session keeps ordered questions and responses, rejects edited or corrupted content',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = await repo('alice').create(request(count: 5));
    final snapshot = {
      'schema': 1,
      'questions': set.questions.map((q) => q.toMap()).toList(),
      'responses': [set.questions.first.correctValues.single],
      'index': 0,
      'answer_xp': 5
    };
    await store.saveQuizSession(set, snapshot);
    expect(
        await NorieStudyOfflineStore('alice').loadQuizSession(set), snapshot);
    expect(await NorieStudyOfflineStore('bob').loadQuizSession(set), isNull);
    final edited = NorieStudySet.fromMap(set.toMap(), questions: [
      NorieStudyQuestion.fromMap(
          {...set.questions.first.toMap(), 'prompt': 'Edited'}),
      ...set.questions.skip(1)
    ]);
    await expectLater(store.loadQuizSession(edited), throwsFormatException);
    await store.clearQuizSession(set.id);
    expect(await store.loadQuizSession(set), isNull);
  });
}

class SwitchOnFinalReadStore extends NorieStudyOfflineStore {
  SwitchOnFinalReadStore(this.switchAccount) : super('alice');
  final void Function() switchAccount;
  int reads = 0;
  @override
  Future<NorieStudySet?> getSet(String id) async {
    final result = await super.getSet(id);
    if (++reads == 2) switchAccount();
    return result;
  }
}
