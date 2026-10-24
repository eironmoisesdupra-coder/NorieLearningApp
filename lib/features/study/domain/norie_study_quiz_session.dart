import '../../curriculum/domain/curriculum_fingerprint.dart';
import 'norie_study_models.dart';

/// A device-local attempt snapshot pinned by the store to the exact deck revision.
/// Responses are regraded on restore; saved correctness flags are never trusted.
class NorieStudyQuizSession {
  NorieStudyQuizSession._(
      this.questions, this.responses, this.index, this.answerXp);
  final List<NorieStudyQuestion> questions;
  final List<String> responses;
  final int index, answerXp;
  static String _identity(NorieStudyQuestion q) {
    final options = [...q.options]..sort();
    return curriculumFingerprint({...q.toMap(), 'options': options});
  }

  factory NorieStudyQuizSession.restore(
      Map<String, dynamic> raw, NorieStudySet set) {
    try {
      if (raw['schema'] != 1 ||
          raw['questions'] is! List ||
          raw['responses'] is! List ||
          raw['index'] is! int ||
          raw['answer_xp'] is! int) {
        throw const FormatException();
      }
      final questions = (raw['questions'] as List)
          .map((q) =>
              NorieStudyQuestion.fromMap(Map<String, dynamic>.from(q as Map)))
          .toList();
      final responses = List<String>.from(raw['responses'] as List);
      final index = raw['index'] as int;
      final xp = raw['answer_xp'] as int;
      final originals = {for (final q in set.questions) q.id: _identity(q)};
      if (questions.length != set.itemCount ||
          questions.isEmpty ||
          originals.length != set.itemCount ||
          questions.map((q) => q.id).toSet().length != set.itemCount ||
          questions.any((q) => originals[q.id] != _identity(q)) ||
          index < 0 ||
          index >= questions.length ||
          responses.length < index ||
          responses.length > index + 1 ||
          responses.any((r) => r.trim().isEmpty || r.length > 4000) ||
          xp < 0 ||
          xp > 80) {
        throw const FormatException();
      }
      return NorieStudyQuizSession._(List.unmodifiable(questions),
          List.unmodifiable(responses), index, xp);
    } catch (_) {
      throw const FormatException(
          'Saved quiz is unreadable. Restart this quiz explicitly.');
    }
  }
}
