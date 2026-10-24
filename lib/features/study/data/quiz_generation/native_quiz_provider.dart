import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../../curriculum/domain/curriculum_fingerprint.dart';
import '../../domain/norie_study_models.dart';
import '../../domain/quiz_generation/quiz_generation.dart';
import 'quiz_validation_pipeline.dart';

class NativeQuizProvider implements QuizGenerationProvider {
  static const version = 'native-math-v1';
  @override
  String get id => 'native';
  @override
  bool get isExternal => false;
  @override
  Future<bool> isAvailable() async => true;
  static const topics = {
    'addition': ('g1', 'Addition within 20'),
    'multiplication': ('g3', 'Multiplication facts to 12'),
    'linear-equations': ('g8', 'Integer linear equations')
  };
  bool _supports(QuizGenerationRequest r) =>
      r.subject == 'Mathematics' &&
      topics[r.topic]?.$1 == r.grade &&
      r.subtopic == null &&
      r.difficulty == 'foundation' &&
      r.language == 'en' &&
      !r.hasSourceConstraint &&
      const [
        NorieStudyGenerationMode.multipleChoice,
        NorieStudyGenerationMode.identification
      ].contains(r.questionType);
  @override
  QuizCoverage coverage(QuizGenerationRequest request) {
    if (!_supports(request)) {
      return const QuizCoverage(
          availableCount: 0,
          reason:
              'No checked native generator for these settings. Source-specific requests need their original service.');
    }
    return QuizCoverage(
        availableCount: candidates(request)
            .where((q) =>
                request.allowRepeatPractice ||
                !request.excludedQuestionIds.contains(q.identity))
            .length);
  }

  List<GeneratedQuizQuestion> candidates(QuizGenerationRequest request) {
    if (!_supports(request)) return const [];
    final proofs = <MathQuestionEvidence>[];
    if (request.topic == 'linear-equations') {
      final seen = <String>{};
      for (var a = 1; a <= 9; a++) {
        for (var b = 0; b <= 9; b++) {
          for (var x = -10; x <= 10; x++) {
            final p = LinearEquationEvidence(a, b, a * x + b);
            if (seen.add(p.identity)) proofs.add(p);
          }
        }
      }
    } else {
      final max = request.topic == 'addition' ? 20 : 12;
      final min = request.topic == 'addition' ? 0 : 1;
      for (var a = min; a <= max; a++) {
        for (var b = a; b <= max; b++) {
          final p = ArithmeticEvidence(request.topic, a, b);
          if (p.valid) proofs.add(p);
        }
      }
    }
    return [
      for (var i = 0; i < proofs.length; i++) _item(proofs[i], request, i)
    ];
  }

  GeneratedQuizQuestion _item(
      MathQuestionEvidence p, QuizGenerationRequest r, int index) {
    final answers = [p.answer, p.answer + 1, p.answer + 2, p.answer + 3];
    final refs = p is LinearEquationEvidence
        ? const [
            QuizSourceReference(
                url:
                    'https://openstax.org/books/elementary-algebra-2e/pages/2-1-solve-equations-using-the-subtraction-and-addition-properties-of-equality',
                location: '§2.1: equality and substitution'),
            QuizSourceReference(
                url:
                    'https://openstax.org/books/elementary-algebra-2e/pages/2-2-solve-equations-using-the-division-and-multiplication-properties-of-equality',
                location: '§2.2: division by a nonzero coefficient')
          ]
        : [
            QuizSourceReference(
                url:
                    'https://openstax.org/books/prealgebra-2e/pages/${p.topic == 'addition' ? '1-2-add-whole-numbers' : '1-4-multiply-whole-numbers'}',
                location: p.topic == 'addition'
                    ? '§1.2: whole-number addition'
                    : '§1.4: whole-number multiplication')
          ];
    return GeneratedQuizQuestion(
        identity: p.identity,
        subject: r.subject,
        grade: r.grade,
        topic: r.topic,
        contentVersion: version,
        evidence: p,
        sources: refs,
        question: NorieStudyQuestion(
            id: const Uuid().v5(Namespace.url.value, '$version:${p.identity}'),
            position: index,
            kind: r.questionType == NorieStudyGenerationMode.multipleChoice
                ? NorieStudyQuestionKind.singleSelect
                : NorieStudyQuestionKind.identification,
            prompt: p.prompt,
            options: r.questionType == NorieStudyGenerationMode.multipleChoice
                ? answers.map((n) => n.toString()).toList()
                : const [],
            correctValues: [p.answer.toString()],
            explanation: p.explanation,
            sourceExcerpt:
                'Original Norie parameterized exercise. Method reference: ${refs.map((s) => '${s.url} (${s.location})').join('; ')}. Answer checked by exact integer arithmetic; no editorial certification.',
            difficulty: r.difficulty,
            topicTag: r.topic));
  }

  @override
  Future<QuizGenerationResult> generate(QuizGenerationRequest request,
      {QuizGenerationCancellation? cancellation}) async {
    request.validate();
    cancellation?.check();
    if (!_supports(request)) {
      throw const QuizGenerationFailure(QuizFailureCode.unsupported);
    }
    final watch = Stopwatch()..start();
    final rng = Random(request.seed);
    final pool = candidates(request)
        .where((q) =>
            request.allowRepeatPractice ||
            !request.excludedQuestionIds.contains(q.identity))
        .toList()
      ..shuffle(rng);
    if (pool.length < request.questionCount) {
      throw QuizGenerationFailure(QuizFailureCode.exhausted,
          availableCount: pool.length);
    }
    final items = <GeneratedQuizQuestion>[];
    for (final candidate in pool.take(request.questionCount)) {
      cancellation?.check();
      final options = [...candidate.question.options]..shuffle(rng);
      items.add(candidate.withQuestion(NorieStudyQuestion.fromMap({
        ...candidate.question.toMap(),
        'position': items.length,
        'options': options
      })));
      if (items.length % 5 == 0) await Future<void>.delayed(Duration.zero);
      if (watch.elapsed > request.timeout) {
        throw const QuizGenerationFailure(QuizFailureCode.timeout);
      }
    }
    cancellation?.check();
    final validation = QuizValidationPipeline().validate(items, request);
    if (!validation.eligible) {
      throw const QuizGenerationFailure(QuizFailureCode.validation);
    }
    final identities = items.map((q) => q.identity).toList()..sort();
    // Shuffling, title changes and reopening the same content never mint a new
    // deck reward identity. Content/version/format boundaries remain explicit.
    final hash = curriculumFingerprint({
      'version': version,
      'ids': identities,
      'subject': request.subject,
      'grade': request.grade,
      'topic': request.topic,
      'format': request.questionType.wireValue,
      'language': request.language
    });
    final stable = const Uuid().v5(Namespace.url.value, hash);
    return QuizGenerationResult(
        quizId: stable,
        persistenceId: stable,
        questions: items,
        provider: id,
        request: request,
        contentVersion: version,
        validationState: validation.state,
        generatedAt: DateTime.now().toUtc());
  }
}
