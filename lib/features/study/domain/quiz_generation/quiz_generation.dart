import 'dart:convert';
import '../../../curriculum/domain/curriculum_fingerprint.dart';
import '../norie_study_models.dart';
import 'math_question_evidence.dart';

export 'math_question_evidence.dart';

enum QuizGenerationMode { native, hybrid, aiOnly }

enum QuizValidationState {
  computationallyChecked,
  verified,
  needsReview,
  rejected,
  unsupported
}

enum QuizFailureCode {
  invalidRequest,
  unsupported,
  exhausted,
  unavailable,
  quotaExhausted,
  rateLimited,
  credentials,
  timeout,
  malformed,
  validation,
  cancelled
}

class QuizGenerationFailure implements Exception {
  const QuizGenerationFailure(this.code, {this.availableCount});
  final QuizFailureCode code;
  final int? availableCount;
  @override
  String toString() => switch (code) {
        QuizFailureCode.exhausted =>
          'Only ${availableCount ?? 0} eligible questions are available. Choose a smaller count or explicitly enable repeat practice.',
        QuizFailureCode.cancelled => 'Generation cancelled.',
        QuizFailureCode.timeout =>
          'Generation timed out. Your saved quizzes are unchanged.',
        QuizFailureCode.invalidRequest =>
          'Choose a supported count and valid quiz settings.',
        _ =>
          'No eligible generator is available for these settings. Your topic and source have been kept.',
      };
}

class QuizGenerationRequest {
  QuizGenerationRequest(
      {required this.subject,
      required this.grade,
      required this.topic,
      required this.questionCount,
      this.subtopic,
      this.difficulty = 'foundation',
      this.questionType = NorieStudyGenerationMode.multipleChoice,
      this.sourceDocumentReference,
      this.requiresSourceGrounding = false,
      this.mode = QuizGenerationMode.native,
      this.providerPreference,
      this.offlineOnly = true,
      this.seed = 0,
      this.language = 'en',
      this.allowExternalProvider = false,
      this.allowRepeatPractice = false,
      Set<String> excludedQuestionIds = const {},
      this.timeout = const Duration(seconds: 15)})
      : excludedQuestionIds = Set.unmodifiable(excludedQuestionIds);
  final String subject, grade, topic, difficulty, language;
  final String? subtopic, sourceDocumentReference, providerPreference;
  final int questionCount, seed;
  final NorieStudyGenerationMode questionType;
  final QuizGenerationMode mode;
  final bool requiresSourceGrounding,
      offlineOnly,
      allowExternalProvider,
      allowRepeatPractice;
  final Set<String> excludedQuestionIds;
  final Duration timeout;
  bool get hasSourceConstraint =>
      requiresSourceGrounding || sourceDocumentReference != null;
  void validate() {
    if (!const [5, 10, 20, 40].contains(questionCount) ||
        [subject, grade, topic, difficulty, language]
            .any((v) => v.trim().isEmpty || v.length > 200) ||
        timeout <= Duration.zero ||
        timeout > const Duration(minutes: 2) ||
        seed < 0 ||
        seed > 0x7fffffff ||
        excludedQuestionIds.length > 10000 ||
        (requiresSourceGrounding &&
            (sourceDocumentReference?.trim().isEmpty ?? true))) {
      throw const QuizGenerationFailure(QuizFailureCode.invalidRequest);
    }
  }

  Map<String, dynamic> toMap() => {
        'subject': subject,
        'grade': grade,
        'topic': topic,
        'subtopic': subtopic,
        'count': questionCount,
        'difficulty': difficulty,
        'format': questionType.wireValue,
        'source': sourceDocumentReference,
        'source_grounding': requiresSourceGrounding,
        'mode': mode.name,
        'provider_preference': providerPreference,
        'offline_only': offlineOnly,
        'seed': seed,
        'language': language,
        'external_authorized': allowExternalProvider,
        'repeat_practice': allowRepeatPractice
      };
}

class QuizCoverage {
  const QuizCoverage({required this.availableCount, this.reason});
  final int availableCount;
  final String? reason;
  bool get supported => reason == null;
}

class QuizGenerationCancellation {
  bool _cancelled = false;
  void cancel() => _cancelled = true;
  void check() {
    if (_cancelled) {
      throw const QuizGenerationFailure(QuizFailureCode.cancelled);
    }
  }
}

abstract interface class QuizGenerationProvider {
  String get id;
  bool get isExternal;
  QuizCoverage coverage(QuizGenerationRequest request);
  Future<bool> isAvailable();
  Future<QuizGenerationResult> generate(QuizGenerationRequest request,
      {QuizGenerationCancellation? cancellation});
}

class QuizSourceReference {
  const QuizSourceReference({required this.url, required this.location});
  final String url, location;
  bool get valid {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        location.trim().isNotEmpty;
  }

  Map<String, dynamic> toMap() => {'url': url, 'location': location};
}

class GeneratedQuizQuestion {
  GeneratedQuizQuestion(
      {required NorieStudyQuestion question,
      required this.identity,
      required this.subject,
      required this.grade,
      required this.topic,
      required this.contentVersion,
      required List<QuizSourceReference> sources,
      this.evidence,
      this.approvalRevision})
      : sources = List.unmodifiable(sources),
        _questionJson = jsonEncode(question.toMap());
  final String _questionJson;
  Map<String, dynamic> get _question =>
      jsonDecode(_questionJson) as Map<String, dynamic>;
  NorieStudyQuestion get question => NorieStudyQuestion.fromMap(_question);
  final String identity, subject, grade, topic, contentVersion;
  final List<QuizSourceReference> sources;
  final MathQuestionEvidence? evidence;
  final String? approvalRevision;
  String get contentHash => curriculumFingerprint({
        'question': _question,
        'identity': identity,
        'subject': subject,
        'grade': grade,
        'topic': topic,
        'version': contentVersion,
        'sources': sources.map((s) => s.toMap()).toList()
      });
  GeneratedQuizQuestion withQuestion(NorieStudyQuestion q) =>
      GeneratedQuizQuestion(
          question: q,
          identity: identity,
          subject: subject,
          grade: grade,
          topic: topic,
          contentVersion: contentVersion,
          sources: sources,
          evidence: evidence,
          approvalRevision: approvalRevision);
  GeneratedQuizQuestion withSources(List<QuizSourceReference> refs) =>
      GeneratedQuizQuestion(
          question: question,
          identity: identity,
          subject: subject,
          grade: grade,
          topic: topic,
          contentVersion: contentVersion,
          sources: refs,
          evidence: evidence,
          approvalRevision: approvalRevision);
}

class QuizValidationResult {
  QuizValidationResult(Iterable<String> issues, this.state)
      : issues = List.unmodifiable(issues);
  final List<String> issues;
  final QuizValidationState state;
  bool get eligible =>
      issues.isEmpty &&
      (state == QuizValidationState.computationallyChecked ||
          state == QuizValidationState.verified);
}

class QuizGenerationResult {
  QuizGenerationResult(
      {required this.quizId,
      required this.persistenceId,
      required List<GeneratedQuizQuestion> questions,
      required this.provider,
      required this.request,
      required this.contentVersion,
      required this.validationState,
      required this.generatedAt,
      this.usedFallback = false,
      this.creditTransactionReference})
      : questions = List.unmodifiable(questions);
  final String quizId, persistenceId, provider, contentVersion;
  final List<GeneratedQuizQuestion> questions;
  final QuizGenerationRequest request;
  final QuizValidationState validationState;
  final DateTime generatedAt;
  final bool usedFallback;
  final String? creditTransactionReference;
  Map<String, dynamic> get provenance => {
        'schema': 1,
        'provider': provider,
        'content_version': contentVersion,
        'validation': validationState.name,
        'generated_at': generatedAt.toUtc().toIso8601String(),
        'request': request.toMap(),
        'fallback': usedFallback,
        'transaction': creditTransactionReference,
        'questions': [
          for (final q in questions)
            {
              'id': q.question.id,
              'identity': q.identity,
              'revision': q.contentHash,
              'sources': q.sources.map((s) => s.toMap()).toList()
            }
        ]
      };
}
