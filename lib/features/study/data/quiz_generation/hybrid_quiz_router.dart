import 'dart:async';
import '../../domain/quiz_generation/quiz_generation.dart';
import 'quiz_validation_pipeline.dart';

/// Optional providers are a capability contract, not enabled integrations.
/// No production cloud/local-inference adapter is registered in this milestone.
class HybridQuizRouter {
  HybridQuizRouter({required this.native, this.optionalProvider});
  final QuizGenerationProvider native;
  final QuizGenerationProvider? optionalProvider;
  Future<QuizGenerationResult> generate(QuizGenerationRequest request,
      {QuizGenerationCancellation? cancellation}) async {
    request.validate();
    cancellation?.check();
    if (request.mode != QuizGenerationMode.aiOnly &&
        native.coverage(request).supported) {
      // Shortage is explicit; never top up with unexpectedly billable questions.
      return native.generate(request, cancellation: cancellation);
    }
    final optional = optionalProvider;
    if (request.mode == QuizGenerationMode.native ||
        request.offlineOnly ||
        !request.allowExternalProvider ||
        optional == null ||
        request.providerPreference != optional.id ||
        !optional.coverage(request).supported) {
      throw const QuizGenerationFailure(QuizFailureCode.unsupported);
    }
    try {
      if (!await optional.isAvailable().timeout(request.timeout)) {
        throw const QuizGenerationFailure(QuizFailureCode.unavailable);
      }
      cancellation?.check();
      final result = await optional
          .generate(request, cancellation: cancellation)
          .timeout(request.timeout);
      cancellation?.check();
      final check =
          QuizValidationPipeline().validate(result.questions, request);
      if (result.questions.length != request.questionCount || !check.eligible) {
        throw const QuizGenerationFailure(QuizFailureCode.validation);
      }
      return result;
    } on TimeoutException {
      cancellation?.cancel();
      throw const QuizGenerationFailure(QuizFailureCode.timeout);
    }
  }
}
