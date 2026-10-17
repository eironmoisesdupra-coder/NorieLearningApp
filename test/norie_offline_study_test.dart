import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';
import 'package:norie_learning/features/study/data/norie_study_service.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

const question = NorieStudyQuestion(
  id: 'q1',
  position: 0,
  kind: NorieStudyQuestionKind.singleSelect,
  prompt: 'What is 2 + 3?',
  options: ['4', '5'],
  correctValues: ['5'],
  explanation: 'Two and three make five.',
  sourceExcerpt: '2 + 3 = 5',
  difficulty: 'foundation',
);

NorieStudySet savedSet() => NorieStudySet(
      id: 'saved-set',
      title: 'Addition',
      sourceType: 'notes',
      sourceName: null,
      mode: NorieStudyGenerationMode.multipleChoice,
      requestedCount: 1,
      status: 'ready',
      createdAt: DateTime.utc(2026, 10, 1),
      questions: [question],
    );

void main() {
  test(
      'restart between eligibility commit and award recovers both rewards once',
      () async {
    final store = NorieStudyOfflineStore('local');
    const answer =
        NorieStudyAnswer(question: question, response: '5', correct: true);
    await store.claimAnswerReward(savedSet().id, answer);
    await store.recordAttempt(studySet: savedSet(), answers: [answer]);
    // A new service pass sees durable eligibility already consumed.
    expect(
        await NorieStudyOfflineStore('local')
            .claimAnswerReward(savedSet().id, answer),
        0);
    await NorieStudyService.instance.drainPendingRewards();
    expect(NorieProgression.instance.totalXp, 25);
    expect(NorieProgression.instance.credits, 1);
    await NorieStudyService.instance.drainPendingRewards();
    expect(NorieProgression.instance.totalXp, 25);
    final saved = jsonDecode((await SharedPreferences.getInstance())
        .getString('norie.study.local.offline.v1')!) as Map;
    expect(saved['rewardOutbox'], isEmpty);
  });

  test('failed economy save retains outbox and retry never duplicates award',
      () async {
    final store = NorieStudyOfflineStore('local');
    const answer =
        NorieStudyAnswer(question: question, response: '5', correct: true);
    await store.claimAnswerReward(savedSet().id, answer);
    var fail = false;
    final economy =
        NorieEconomyStore(read: () async => null, write: (_) async => !fail);
    await economy.load({});
    await economy.flush();
    fail = true;
    Future<Map<String, int>> drain() => store.drainRewardOutbox(
        stillCurrent: () => true,
        award: (claim, xp, credits) =>
            economy.reward(claim, xp: xp, credits: credits),
        flushEconomy: () => economy.flush(retry: true));
    await expectLater(drain(), throwsStateError);
    var saved = jsonDecode((await SharedPreferences.getInstance())
        .getString('norie.study.local.offline.v1')!) as Map;
    expect((saved['rewardOutbox'] as Map).length, 1);
    fail = false;
    await drain();
    expect(economy.totalXp, 5);
    expect(economy.credits, 1);
    saved = jsonDecode((await SharedPreferences.getInstance())
        .getString('norie.study.local.offline.v1')!) as Map;
    expect(saved['rewardOutbox'], isEmpty);
  });

  test('crash after economy save before outbox acknowledgement deduplicates',
      () async {
    final store = NorieStudyOfflineStore('local');
    const answer =
        NorieStudyAnswer(question: question, response: '5', correct: true);
    await store.claimAnswerReward(savedSet().id, answer);
    NorieProgression.instance.reward('card:saved-set:q1', xp: 5, credits: 1);
    await NorieProgression.instance.flushPendingSaves();
    await NorieProgression.instance.load();
    await NorieStudyService.instance.drainPendingRewards();
    expect(NorieProgression.instance.totalXp, 5);
    expect(NorieProgression.instance.credits, 1);
    final saved = jsonDecode((await SharedPreferences.getInstance())
        .getString('norie.study.local.offline.v1')!) as Map;
    expect(saved['rewardOutbox'], isEmpty);
  });

  test('legacy eligibility without outbox cannot invent new awards', () async {
    SharedPreferences.setMockInitialValues({
      'norie.study.local.offline.v1': jsonEncode({
        'rewarded': ['saved-set'],
        'answerRewards': {
          'saved-set': ['q1']
        }
      })
    });
    await NorieStudyService.instance.drainPendingRewards();
    expect(NorieProgression.instance.totalXp, 0);
    expect(NorieProgression.instance.credits, 0);
  });

  test('owner change during economy save retains reward for its original owner',
      () async {
    final store = NorieStudyOfflineStore('local');
    const answer =
        NorieStudyAnswer(question: question, response: '5', correct: true);
    await store.claimAnswerReward(savedSet().id, answer);
    var current = true;
    await store.drainRewardOutbox(
        stillCurrent: () => current,
        award: (claim, xp, credits) => true,
        flushEconomy: () async {
          current = false;
        });
    final saved = jsonDecode((await SharedPreferences.getInstance())
        .getString('norie.study.local.offline.v1')!) as Map;
    expect((saved['rewardOutbox'] as Map).length, 1);
  });

  test('card eligibility and recoverable reward are saved in one document',
      () async {
    final store = NorieStudyOfflineStore('local');
    const answer =
        NorieStudyAnswer(question: question, response: '5', correct: true);
    await store.claimAnswerReward(savedSet().id, answer);
    final prefs = await SharedPreferences.getInstance();
    final saved =
        jsonDecode(prefs.getString('norie.study.local.offline.v1')!) as Map;
    expect(saved['rewardOutbox'], {
      'card:saved-set:q1': {
        'claim_key': 'card:saved-set:q1',
        'xp': 5,
        'credits': 1
      }
    });
  });

  test('completion eligibility and recoverable reward are saved together',
      () async {
    final store = NorieStudyOfflineStore('local');
    await store.recordAttempt(studySet: savedSet(), answers: const [
      NorieStudyAnswer(question: question, response: '5', correct: true)
    ]);
    final prefs = await SharedPreferences.getInstance();
    final saved =
        jsonDecode(prefs.getString('norie.study.local.offline.v1')!) as Map;
    expect(saved['rewardOutbox'], {
      'study-set:saved-set:completion': {
        'claim_key': 'study-set:saved-set:completion',
        'xp': 25,
        'credits': 0
      }
    });
  });

  test('reviews persist per learner and are scheduled in UTC', () async {
    SharedPreferences.setMockInitialValues({});
    final due = await NorieStudyOfflineStore('alice')
        .reviewCard('deck', 'card', fsrs.Rating.good);
    final saved = await NorieStudyOfflineStore('alice').reviewCards('deck');
    expect(saved['card']!.due, due);
    expect(due.isUtc, isTrue);
    expect(due.isAfter(DateTime.now().toUtc()), isTrue);
    expect(await NorieStudyOfflineStore('bob').reviewCards('deck'), isEmpty);
  });

  test(
      'per-answer rewards are durable, deduplicated and deducted from completion XP',
      () async {
    SharedPreferences.setMockInitialValues({});
    final store = NorieStudyOfflineStore('alice');
    const answer =
        NorieStudyAnswer(question: question, response: '5', correct: true);
    expect(await store.claimAnswerReward(savedSet().id, answer), 5);
    expect(
        await NorieStudyOfflineStore('alice')
            .claimAnswerReward(savedSet().id, answer),
        0);
    final completion =
        await store.recordAttempt(studySet: savedSet(), answers: [answer]);
    expect(completion.xpAwarded, 20);
  });

  test('self-rated cards do not earn answer or completion XP', () async {
    SharedPreferences.setMockInitialValues({});
    final card =
        NorieStudyQuestion.fromMap({...question.toMap(), 'kind': 'flashcard'});
    final answer =
        NorieStudyAnswer(question: card, response: 'Knew it', correct: true);
    final store = NorieStudyOfflineStore('alice');
    expect(await store.claimAnswerReward('deck', answer), 0);
    final result =
        await store.recordAttempt(studySet: savedSet(), answers: [answer]);
    expect(result.xpAwarded, 0);
    expect(result.total, 0);
  });

  setUp(() async {
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
  });
  tearDown(() => NorieProgression.instance.flushPendingSaves());

  test('a saved quiz finishes offline and awards XP only once', () async {
    final before = NorieProgression.instance.snapshot.totalXp;
    final answers = [
      const NorieStudyAnswer(
        question: question,
        response: '5',
        correct: true,
      )
    ];
    final result = await NorieStudyService.instance.recordAttempt(
      studySet: savedSet(),
      answers: answers,
    );
    expect(result.correct, 1);
    expect(result.total, 1);
    expect(result.xpAwarded, 25);
    expect(NorieProgression.instance.snapshot.totalXp, before + 25);
    final replay = await NorieStudyService.instance.recordAttempt(
      studySet: savedSet(),
      answers: answers,
    );
    expect(replay.xpAwarded, 0);
    expect(NorieProgression.instance.snapshot.totalXp, before + 25);
  });

  test('AI generation cannot invent a quiz without an online account',
      () async {
    await expectLater(
      NorieStudyService.instance.generateFromSource(
        title: 'Addition',
        sourceType: 'notes',
        mode: NorieStudyGenerationMode.multipleChoice,
        questionCount: 5,
        sourceText: 'Two plus three equals five.',
      ),
      throwsStateError,
    );
  });

  test('signing out during a private quiz cannot queue it for another learner',
      () async {
    await NorieStudyOfflineStore('alice').saveSet(savedSet());
    final privateSet =
        await NorieStudyOfflineStore('alice').getSet('saved-set');
    expect(privateSet!.ownerId, 'alice');
    await expectLater(
      NorieStudyService.instance
          .recordAttempt(studySet: privateSet, answers: const []),
      throwsStateError,
    );
    expect(await NorieStudyOfflineStore('alice').pendingAttempts(), isEmpty);
    expect(await NorieStudyOfflineStore('local').pendingAttempts(), isEmpty);
  });
}
