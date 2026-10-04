import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:norie_learning/features/study/data/norie_local_job_client.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/data/norie_study_service.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

NorieStudySet fixture() => NorieStudySet(
      id: 'private-set',
      title: 'Anatomy notes',
      sourceType: 'notes',
      sourceName: 'notes.txt',
      mode: NorieStudyGenerationMode.mixed,
      requestedCount: 1,
      status: 'ready',
      createdAt: DateTime.utc(2026, 10, 1),
      topicTag: 'Skeleton',
      aiModel: 'server-model',
      questions: const [
        NorieStudyQuestion(
          id: 'bone-q1',
          position: 1,
          kind: NorieStudyQuestionKind.ordering,
          prompt: 'Order the labels',
          options: ['Skull', 'Femur'],
          correctValues: ['Skull, Femur'],
          orderedItems: ['Skull', 'Femur'],
          explanation: 'The skull is above the femur.',
          sourceExcerpt: 'Head to leg',
          difficulty: 'intermediate',
          topicTag: 'Skeleton',
        ),
      ],
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('local jobs poll independently and preserve their private request keys',
      () async {
    final keys = <String, String>{};
    final statuses = <String>[];
    final client = NorieLocalJobClient(
      base: Uri.parse('http://127.0.0.1:8752'),
      pollInterval: Duration.zero,
      client: MockClient((request) async {
        final key = request.headers['X-Norie-Job-Key'];
        if (request.method == 'POST') {
          final title = jsonDecode(request.body)['input']['title'] as String;
          keys[title] = key!;
          return http.Response(
              jsonEncode(
                  {'id': title, 'status': 'queued', 'queue_position': 1}),
              202);
        }
        final id = request.url.pathSegments.last;
        expect(key, keys[id]);
        expect(request.url.query, isEmpty);
        return http.Response(
            jsonEncode({
              'id': id,
              'status': 'succeeded',
              'result': {'title': id}
            }),
            200);
      }),
    );
    addTearDown(client.close);
    final results = await Future.wait([
      client.run('generate', {'title': 'anatomy'},
          onProgress: (job) => statuses.add(job['status'] as String)),
      client.run('generate', {'title': 'taxonomy'}),
    ]);
    expect(results.map((result) => result['title']), ['anatomy', 'taxonomy']);
    expect(keys.values.toSet().length, 2);
    expect(statuses, ['queued', 'succeeded']);
    expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);
  });

  test('local job retry reuses the key after a lost acknowledgement', () async {
    String? originalKey;
    var calls = 0;
    final client = NorieLocalJobClient(
      base: Uri.parse('http://127.0.0.1:8752'),
      client: MockClient((request) async {
        calls++;
        if (calls == 1) {
          originalKey = request.headers['X-Norie-Job-Key'];
          throw http.ClientException('Simulated disconnect');
        }
        expect(request.headers['X-Norie-Job-Key'], originalKey);
        return http.Response(
            jsonEncode({
              'id': 'retained',
              'status': 'succeeded',
              'result': {'title': 'saved'}
            }),
            202);
      }),
    );
    addTearDown(client.close);
    await expectLater(
        client.run('generate', {'title': 'saved'}), throwsStateError);
    expect(
        (await client.run('generate', {'title': 'saved'}))['title'], 'saved');
    expect(calls, 2);
  });

  test('local job client refuses remote servers', () {
    final client = NorieLocalJobClient(base: Uri.parse('https://example.com'));
    addTearDown(client.close);
    expect(() => client.run('generate', {}), throwsStateError);
  });

  test('local generation exposes only source-card supported modes', () {
    expect(
        NorieStudyService.supportsLocalMode(NorieStudyGenerationMode.trueFalse),
        isFalse);
    for (final mode in [
      NorieStudyGenerationMode.multipleChoice,
      NorieStudyGenerationMode.identification,
      NorieStudyGenerationMode.flashcards,
      NorieStudyGenerationMode.mixed,
    ]) {
      expect(NorieStudyService.supportsLocalMode(mode), isTrue);
    }
  });

  test('source-card answer and evidence survive offline saving', () async {
    const statement = 'Family is immediately above genus.';
    final original = fixture();
    final card = NorieStudyQuestion.fromMap({
      ...original.questions.single.toMap(),
      'kind': 'identification',
      'prompt': '_____ is immediately above genus.',
      'options': <String>[],
      'correct_values': ['Family'],
      'ordered_items': <String>[],
      'explanation': statement,
      'source_excerpt': statement,
    });
    await NorieStudyOfflineStore('alice')
        .saveSet(NorieStudySet.fromMap(original.toMap(), questions: [card]));
    final saved = (await NorieStudyOfflineStore('alice').getSet(original.id))!
        .questions
        .single;
    expect(saved.correctValues, ['Family']);
    expect(saved.prompt.replaceFirst('_____', saved.correctValues.single),
        saved.sourceExcerpt);
    expect(saved.explanation, statement);
    expect(await NorieStudyOfflineStore('bob').getSet(original.id), isNull);
  });

  test('pending card edits survive remote refresh and older acknowledgements',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = fixture();
    final edited = NorieStudyQuestion.fromMap(
        {...set.questions.single.toMap(), 'prompt': 'Edited question'});
    await store.editCard(set, edited);
    final old = (await store.pendingCardChanges()).single;
    await store.saveSet(set);
    expect((await store.getSet(set.id))!.questions.single.prompt,
        'Edited question');
    await store.editCard(
        set,
        NorieStudyQuestion.fromMap(
            {...edited.toMap(), 'prompt': 'Newer edit'}));
    await store.acknowledgeCardChange(edited.id, old['revision'] as String);
    expect(await store.pendingCardChanges(), hasLength(1));
    expect(await NorieStudyOfflineStore('bob').pendingCardChanges(), isEmpty);
  });

  test('uploaded edit survives a stale fetch until the cloud confirms it',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = fixture();
    final edited = NorieStudyQuestion.fromMap(
        {...set.questions.single.toMap(), 'prompt': 'Uploaded edit'});
    await store.editCard(set, edited);
    final change = (await store.pendingCardChanges()).single;
    await store.acknowledgeCardChange(edited.id, change['revision'] as String);
    expect(await store.pendingCardChanges(), isEmpty);
    await store.saveSet(set);
    expect(
        (await store.getSet(set.id))!.questions.single.prompt, 'Uploaded edit');
    await store
        .saveSet(NorieStudySet.fromMap(set.toMap(), questions: [edited]));
    final later = NorieStudyQuestion.fromMap(
        {...edited.toMap(), 'prompt': 'Later cloud edit'});
    await store.saveSet(NorieStudySet.fromMap(set.toMap(), questions: [later]));
    expect((await store.getSet(set.id))!.questions.single.prompt,
        'Later cloud edit');
  });

  test('saved questions and explanations survive reopening the offline store',
      () async {
    await NorieStudyOfflineStore('alice').saveSet(fixture());
    final reopened = NorieStudyOfflineStore('alice');
    final set = await reopened.getSet('private-set');
    expect(set!.title, 'Anatomy notes');
    expect(set.questions.single.kind, NorieStudyQuestionKind.ordering);
    expect(set.questions.single.correctValues, ['Skull, Femur']);
    expect(set.questions.single.orderedItems, ['Skull', 'Femur']);
    expect(set.questions.single.explanation, 'The skull is above the femur.');
    expect((await reopened.listSets()).single.itemCount, 1);
  });

  test('another learner cannot read cached private study sets', () async {
    await NorieStudyOfflineStore('alice').saveSet(fixture());
    expect(await NorieStudyOfflineStore('bob').listSets(), isEmpty);
    expect(await NorieStudyOfflineStore('bob').getSet('private-set'), isNull);
    expect(await NorieStudyOfflineStore('local').listSets(), isEmpty);
  });

  test(
      'queued attempts keep their ID until a successful sync acknowledges them',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final answers = [
      NorieStudyAnswer(
        question: fixture().questions.single,
        response: 'Skull, Femur',
        correct: true,
      )
    ];
    await store.recordAttempt(studySet: fixture(), answers: answers);
    final attempts = await NorieStudyOfflineStore('alice').pendingAttempts();
    expect(attempts, hasLength(1));
    expect(attempts.single['correct_count'], 1);
    expect(attempts.single['xp_awarded'], 25);
    expect(attempts.single['user_id'], 'alice');
    final id = attempts.single['id'] as String;
    await store.acknowledgeAttempt(id);
    expect(await store.pendingAttempts(), isEmpty);
  });

  test('concurrent completions cannot award the same set twice', () async {
    final answers = [
      NorieStudyAnswer(
        question: fixture().questions.single,
        response: 'Skull, Femur',
        correct: true,
      )
    ];
    final results = await Future.wait([
      NorieStudyOfflineStore('alice')
          .recordAttempt(studySet: fixture(), answers: answers),
      NorieStudyOfflineStore('alice')
          .recordAttempt(studySet: fixture(), answers: answers),
    ]);
    expect(results.map((result) => result.xpAwarded).toList(), [25, 0]);
    expect(
        await NorieStudyOfflineStore('alice').pendingAttempts(), hasLength(2));
  });

  test('deleting a saved set removes its pending attempts', () async {
    final store = NorieStudyOfflineStore('alice');
    await store.saveSet(fixture());
    await store.recordAttempt(studySet: fixture(), answers: const []);
    expect(await store.pendingAttempts(), hasLength(1));
    await store.removeSet(fixture().id);
    expect(await store.getSet(fixture().id), isNull);
    expect(await store.pendingAttempts(), isEmpty);
  });

  test('a prior cloud reward prevents another offline XP award', () async {
    final store = NorieStudyOfflineStore('alice');
    await store.markRewarded(fixture().id);
    final result = await store.recordAttempt(
      studySet: fixture(),
      answers: [
        NorieStudyAnswer(
          question: fixture().questions.single,
          response: 'Skull, Femur',
          correct: true,
        )
      ],
    );
    expect(result.xpAwarded, 0);
    expect(result.firstRewardedCompletion, isFalse);
    expect(await store.pendingAttempts(), hasLength(1));
  });
}
