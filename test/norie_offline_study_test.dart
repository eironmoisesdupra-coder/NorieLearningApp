import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/study/data/norie_study_service.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.load();
  });

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
