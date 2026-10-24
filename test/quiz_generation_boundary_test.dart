import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/study/data/quiz_generation/native_quiz_provider.dart';
import 'package:norie_learning/features/study/data/quiz_generation/question_bank_repository.dart';
import 'package:norie_learning/features/study/data/quiz_generation/quiz_validation_pipeline.dart';
import 'package:norie_learning/features/study/domain/quiz_generation/quiz_generation.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/curriculum/domain/curriculum_fingerprint.dart';
import 'hybrid_quiz_generation_test.dart' show request;

Map<String, dynamic> draftContent() => {
      'subject': 'Mathematics',
      'grade': 'g1',
      'topic': 'addition',
      'content_version': 'fixture-v1',
      'objectives': ['Add two numbers'],
      'hint': 'Count the combined units.',
      'source': {
        'url': 'https://example.org/review-fixture',
        'location': 'Synthetic test fixture'
      },
      'question': {
        'id': 'fixture-q',
        'position': 0,
        'kind': 'single_select',
        'prompt': 'What is 2 + 3?',
        'options': ['4', '5', '6', '7'],
        'correct_values': ['5'],
        'explanation': '2 + 3 = 5.',
        'source_excerpt': 'Synthetic fixture, not shipped teaching content',
        'difficulty': 'foundation',
        'topic_tag': 'addition'
      }
    };
void main() {
  test(
      'generated content cannot be changed through an input list after validation',
      () async {
    final source = (await NativeQuizProvider().generate(request(count: 5)))
        .questions
        .first;
    final options = [...source.question.options];
    final q = NorieStudyQuestion.fromMap(
        {...source.question.toMap(), 'options': options});
    final pinned = source.withQuestion(q);
    final before = pinned.contentHash;
    options.clear();
    expect(pinned.contentHash, before);
    expect(pinned.question.options, hasLength(4));
  });
  test('a mathematical proof cannot certify an unrelated source or language',
      () async {
    final items =
        (await NativeQuizProvider().generate(request(count: 5))).questions;
    expect(
        QuizValidationPipeline()
            .validate(items, request(source: 'private-document'))
            .eligible,
        isFalse);
    expect(
        QuizValidationPipeline()
            .validate(items, request(language: 'fil'))
            .eligible,
        isFalse);
  });
  test(
      'every bounded mathematical candidate passes proof checks and scalar copies share identity',
      () {
    final provider = NativeQuizProvider();
    for (final req in [
      request(),
      request(topic: 'addition', grade: 'g1'),
      request(topic: 'multiplication', grade: 'g3')
    ]) {
      final candidates = provider.candidates(req);
      expect(
          QuizValidationPipeline().validate(candidates, req).eligible, isTrue);
    }
    expect(const LinearEquationEvidence(2, 4, 10).identity,
        const LinearEquationEvidence(1, 2, 5).identity);
    expect(const LinearEquationEvidence(0, 0, 0).valid, isFalse);
    expect(const ArithmeticEvidence('addition', 20, 20).valid, isFalse);
  });
  test(
      'review is bound to exact content, reviewer and timestamp; malformed approved banks fail closed',
      () {
    final content = draftContent();
    final hash = curriculumFingerprint(content);
    final approval = QuestionBankApproval(
        contentHash: hash,
        reviewer: 'synthetic-reviewer',
        approvedAt: DateTime.utc(2026));
    Map<String, dynamic> envelope(Map<String, dynamic> c) => {
          'id': 'fixture-q',
          'status': 'approved',
          'reviewer': 'synthetic-reviewer',
          'approved_at': '2026-01-01T00:00:00.000Z',
          'approval_revision': hash,
          'content': c
        };
    final repository =
        QuestionBankRepository(trustedApprovals: {hash: approval});
    expect(repository.importCandidates([envelope(content)]).eligible, isTrue);
    for (final e in [
      {...envelope(content), 'status': 'retired'},
      {...envelope(content), 'status': 'draft'},
      {...envelope(content), 'reviewer': 'someone-else'},
      {...envelope(content), 'approved_at': '2026-02-01'},
      envelope({...content, 'hint': 'Changed content'}),
      {...envelope(content), 'content': {}},
    ]) {
      expect(repository.importCandidates([e]).eligible, isFalse);
      expect(repository.approvedQuestions, hasLength(1));
    }
    expect(
        repository
            .importCandidates([envelope(content), envelope(content)]).eligible,
        isFalse);
  });
}
