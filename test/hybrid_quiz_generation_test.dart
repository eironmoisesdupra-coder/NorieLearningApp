import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/domain/quiz_generation/quiz_generation.dart';
import 'package:norie_learning/features/study/data/quiz_generation/native_quiz_provider.dart';
import 'package:norie_learning/features/study/data/quiz_generation/hybrid_quiz_router.dart';
import 'package:norie_learning/features/study/data/quiz_generation/quiz_validation_pipeline.dart';
import 'package:norie_learning/features/study/data/quiz_generation/question_bank_repository.dart';

QuizGenerationRequest request(
        {int count = 20,
        int seed = 17,
        String subject = 'Mathematics',
        String grade = 'g8',
        String topic = 'linear-equations',
        String difficulty = 'foundation',
        String language = 'en',
        String? source,
        QuizGenerationMode mode = QuizGenerationMode.native,
        bool offline = true,
        Set<String> excluded = const {},
        bool repeat = false,
        NorieStudyGenerationMode format =
            NorieStudyGenerationMode.multipleChoice}) =>
    QuizGenerationRequest(
        subject: subject,
        grade: grade,
        topic: topic,
        questionCount: count,
        seed: seed,
        difficulty: difficulty,
        language: language,
        sourceDocumentReference: source,
        requiresSourceGrounding: source != null,
        mode: mode,
        offlineOnly: offline,
        excludedQuestionIds: excluded,
        allowRepeatPractice: repeat,
        questionType: format);

void main() {
  final provider = NativeQuizProvider();
  for (final count in [5, 10, 20, 40]) {
    test(
        '$count linear questions have independently correct answers and no duplicates',
        () async {
      final result = await provider.generate(request(count: count));
      expect(result.questions, hasLength(count));
      expect(result.questions.map((q) => q.identity).toSet(), hasLength(count));
      for (final item in result.questions) {
        final match = RegExp(r'^Solve for x: (\d+)x \+ (\d+) = (-?\d+)\.$')
            .firstMatch(item.question.prompt)!;
        final a = int.parse(match[1]!);
        final b = int.parse(match[2]!);
        final c = int.parse(match[3]!);
        final answer = int.parse(item.question.correctValues.single);
        expect(a * answer + b, c);
        expect(item.question.options.toSet(), hasLength(4));
        expect(item.question.options.where((v) => a * int.parse(v) + b == c),
            [answer.toString()]);
        expect(item.question.explanation, contains('Check:'));
      }
      expect(
          result.validationState, QuizValidationState.computationallyChecked);
      expect(result.creditTransactionReference, isNull);
    });
  }
  test(
      'seed preserves question order/choices and shuffled replay keeps persistence identity',
      () async {
    final a = await provider.generate(request());
    final b = await provider.generate(request());
    expect(a.questions.map((q) => q.question.toMap()),
        b.questions.map((q) => q.question.toMap()));
    expect(a.persistenceId, b.persistenceId);
    expect(
        (await provider.generate(request(seed: 19)))
            .questions
            .map((q) => q.identity),
        isNot(a.questions.map((q) => q.identity)));
  });
  test('constraints fail explicitly without substituting unrelated curriculum',
      () async {
    for (final req in [
      request(subject: 'Anatomy'),
      request(grade: 'g1'),
      request(topic: 'iupac'),
      request(difficulty: 'advanced'),
      request(language: 'fil'),
      request(source: 'private-notes'),
      request(format: NorieStudyGenerationMode.trueFalse)
    ]) {
      expect(provider.coverage(req).supported, isFalse);
      await expectLater(
          provider.generate(req), throwsA(isA<QuizGenerationFailure>()));
    }
    await expectLater(provider.generate(request(count: 100)),
        throwsA(isA<QuizGenerationFailure>()));
  });
  test('avoids completed identities and reports shortage without padding',
      () async {
    final first = await provider.generate(request(count: 40));
    final ids = first.questions.map((q) => q.identity).toSet();
    final next = await provider.generate(request(count: 40, excluded: ids));
    expect(next.questions.any((q) => ids.contains(q.identity)), isFalse);
    final all = provider.candidates(request()).map((q) => q.identity).toSet();
    await expectLater(
        provider.generate(request(excluded: all)),
        throwsA(isA<QuizGenerationFailure>()
            .having((e) => e.availableCount, 'count', 0)));
    expect(
        (await provider.generate(request(excluded: all, repeat: true)))
            .questions,
        hasLength(20));
  });
  test(
      'cancellation refuses work and router never invokes unauthorized inference',
      () async {
    final token = QuizGenerationCancellation()..cancel();
    await expectLater(
        provider.generate(request(), cancellation: token),
        throwsA(isA<QuizGenerationFailure>()
            .having((e) => e.code, 'code', QuizFailureCode.cancelled)));
    final external = CountingProvider();
    final router =
        HybridQuizRouter(native: provider, optionalProvider: external);
    await expectLater(
        router.generate(request(
            subject: 'Chemistry',
            mode: QuizGenerationMode.hybrid,
            offline: false)),
        throwsA(isA<QuizGenerationFailure>()));
    expect(external.calls, 0);
    final native =
        await router.generate(request(mode: QuizGenerationMode.hybrid));
    expect(native.provider, 'native');
    expect(external.calls, 0);
  });
  test(
      'validation rejects wrong keys, malformed choices, duplicate identities and missing source',
      () async {
    final sample = (await provider.generate(request(count: 5))).questions.first;
    final pipeline = QuizValidationPipeline();
    for (final map in [
      {
        ...sample.question.toMap(),
        'correct_values': ['99999']
      },
      {
        ...sample.question.toMap(),
        'options': ['1', '1', '2', '3']
      },
      {...sample.question.toMap(), 'explanation': ''},
      {...sample.question.toMap(), 'prompt': 'An unrelated question'},
    ]) {
      expect(
          pipeline.validate(
              [sample.withQuestion(NorieStudyQuestion.fromMap(map))],
              request(count: 5)).eligible,
          isFalse);
    }
    expect(pipeline.validate([sample, sample], request()).eligible, isFalse);
    expect(
        pipeline.validate([sample.withSources(const [])], request()).eligible,
        isFalse);
  });
  test(
      'bounded addition and multiplication canonicalize commutative duplicates',
      () async {
    for (final topic in ['addition', 'multiplication']) {
      final req = request(
          topic: topic, grade: topic == 'addition' ? 'g1' : 'g3', count: 40);
      final result = await provider.generate(req);
      expect(result.questions, hasLength(40));
      expect(result.questions.map((q) => q.identity).toSet(), hasLength(40));
      for (final item in result.questions) {
        final m = RegExp(r'^Calculate: (\d+) ([+×]) (\d+)\.$')
            .firstMatch(item.question.prompt)!;
        final a = int.parse(m[1]!);
        final b = int.parse(m[3]!);
        expect(int.parse(item.question.correctValues.single),
            m[2] == '+' ? a + b : a * b);
      }
    }
  });
  test('bank JSON claiming approval cannot authorize itself', () {
    final bank = QuestionBankRepository();
    final report = bank.importCandidates([
      {'id': 'fake', 'status': 'approved', 'reviewer': 'fake'}
    ]);
    expect(report.eligible, isFalse);
    expect(bank.approvedQuestions, isEmpty);
  });
}

class CountingProvider implements QuizGenerationProvider {
  int calls = 0;
  @override
  String get id => 'test-external';
  @override
  bool get isExternal => true;
  @override
  QuizCoverage coverage(QuizGenerationRequest request) =>
      const QuizCoverage(availableCount: 40);
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<QuizGenerationResult> generate(QuizGenerationRequest request,
      {QuizGenerationCancellation? cancellation}) async {
    calls++;
    throw const QuizGenerationFailure(QuizFailureCode.unavailable);
  }
}
