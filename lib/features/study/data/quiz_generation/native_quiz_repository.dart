import '../../domain/norie_study_models.dart';
import '../../domain/quiz_generation/quiz_generation.dart';
import '../norie_study_offline_store.dart';
import 'native_quiz_provider.dart';

class NativeQuizRepository {
  NativeQuizRepository({required this.store, required this.stillCurrent});
  final NorieStudyOfflineStore store;
  final bool Function() stillCurrent;
  void _checkOwner() {
    if (!stillCurrent()) {
      throw StateError('Account changed. Reopen the generator to continue.');
    }
  }

  Future<NorieStudySet> create(QuizGenerationRequest request,
      {String title = '', QuizGenerationCancellation? cancellation}) async {
    _checkOwner();
    if (request.mode == QuizGenerationMode.aiOnly) {
      throw const QuizGenerationFailure(QuizFailureCode.unsupported);
    }
    final result = await NativeQuizProvider()
        .generate(request, cancellation: cancellation);
    _checkOwner();
    final existing = await store.getSet(result.persistenceId);
    _checkOwner();
    if (existing != null) return existing;
    final set = NorieStudySet(
        id: result.persistenceId,
        title: title.trim().isEmpty
            ? NativeQuizProvider.topics[request.topic]!.$2
            : title.trim(),
        sourceType: 'native',
        sourceName: 'Norie Native · ${result.contentVersion}',
        mode: request.questionType,
        requestedCount: request.questionCount,
        status: 'ready',
        createdAt: result.generatedAt,
        questions: result.questions.map((q) => q.question).toList(),
        topicTag: request.topic,
        ownerId: store.userId,
        generationMetadata: result.provenance);
    cancellation?.check();
    await store.saveSet(set);
    _checkOwner();
    final saved = await store.getSet(set.id);
    _checkOwner();
    if (saved == null) throw StateError('Could not reopen the saved quiz.');
    return saved;
  }
}
