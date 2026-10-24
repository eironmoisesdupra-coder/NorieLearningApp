import '../../domain/norie_study_models.dart';
import '../../domain/quiz_generation/quiz_generation.dart';

class QuizValidationPipeline {
  QuizValidationPipeline({Set<String> trustedContentRevisions = const {}})
      : _trusted = Set.unmodifiable(trustedContentRevisions);
  final Set<String> _trusted;
  QuizValidationResult validate(
      List<GeneratedQuizQuestion> items, QuizGenerationRequest request) {
    final issues = <String>[];
    try {
      request.validate();
    } on QuizGenerationFailure {
      issues.add('request');
    }
    // This milestone has no local document processor or translated templates.
    // A valid arithmetic key cannot prove source grounding or a translation.
    if (request.hasSourceConstraint ||
        request.language != 'en' ||
        request.subtopic != null) {
      issues.add('unsupported_grounding_or_language');
    }
    final identities = <String>{};
    final ids = <String>{};
    final prompts = <String>{};
    for (final item in items) {
      final q = item.question;
      if (!identities.add(item.identity) ||
          !ids.add(q.id) ||
          !prompts.add(
              q.prompt.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim())) {
        issues.add('duplicate');
      }
      if (q.id.trim().isEmpty ||
          item.identity.isEmpty ||
          q.prompt.trim().isEmpty ||
          q.explanation.trim().isEmpty ||
          item.contentVersion.isEmpty ||
          q.correctValues.length != 1 ||
          q.correctValues.single.trim().isEmpty ||
          q.prompt.contains('\u0000') ||
          q.explanation.contains('\u0000')) {
        issues.add('schema');
      }
      if (item.subject != request.subject ||
          item.grade != request.grade ||
          item.topic != request.topic ||
          q.difficulty != request.difficulty ||
          q.topicTag != request.topic) {
        issues.add('request_mismatch');
      }
      if (item.sources.isEmpty || item.sources.any((s) => !s.valid)) {
        issues.add('source');
      }
      final kind = switch (request.questionType) {
        NorieStudyGenerationMode.multipleChoice =>
          NorieStudyQuestionKind.singleSelect,
        NorieStudyGenerationMode.identification =>
          NorieStudyQuestionKind.identification,
        _ => null,
      };
      if (kind == null || q.kind != kind) issues.add('format');
      final normalized = q.options.map((v) => v.trim().toLowerCase()).toSet();
      if (q.kind == NorieStudyQuestionKind.singleSelect &&
          (q.options.length != 4 ||
              normalized.length != 4 ||
              normalized.contains('') ||
              q.correctValues.length != 1 ||
              !q.options.contains(q.correctValues.single))) {
        issues.add('choices');
      }
      if (q.kind == NorieStudyQuestionKind.identification &&
          q.options.isNotEmpty) {
        issues.add('choices');
      }
      final proof = item.evidence;
      if (proof != null) {
        if (!proof.valid ||
            item.identity != proof.identity ||
            q.prompt != proof.prompt ||
            item.topic != proof.topic ||
            item.grade != proof.grade ||
            q.explanation != proof.explanation ||
            q.correctValues.length != 1 ||
            q.correctValues.single != proof.answer.toString() ||
            q.options.any((s) => int.tryParse(s) == null)) {
          issues.add('answer_proof');
        }
      } else if (item.approvalRevision != item.contentHash ||
          !_trusted.contains(item.contentHash)) {
        issues.add('qualified_review_required');
      }
    }
    if (items.isEmpty) issues.add('empty');
    return QuizValidationResult(
        issues,
        issues.isNotEmpty
            ? QuizValidationState.rejected
            : items.every((q) => q.evidence != null)
                ? QuizValidationState.computationallyChecked
                : QuizValidationState.verified);
  }
}
