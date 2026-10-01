import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
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
