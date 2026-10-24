import 'dart:convert';
import '../../../curriculum/domain/curriculum_fingerprint.dart';
import '../../domain/norie_study_models.dart';
import '../../domain/quiz_generation/quiz_generation.dart';

class QuestionBankApproval {
  const QuestionBankApproval(
      {required this.contentHash,
      required this.reviewer,
      required this.approvedAt});
  final String contentHash, reviewer;
  final DateTime approvedAt;
}

/// Development staging boundary. Candidate JSON cannot authorize publication.
/// Trusted signoffs must come from independently reviewed application config.
/// There are NO production approved records or fabricated reviewer identities.
class QuestionBankRepository {
  QuestionBankRepository(
      {Map<String, QuestionBankApproval> trustedApprovals = const {}})
      : _trusted = Map.unmodifiable(trustedApprovals);
  final Map<String, QuestionBankApproval> _trusted;
  List<String> _approved = [];
  List<Map<String, dynamic>> get approvedQuestions => List.unmodifiable(
      _approved.map((q) => jsonDecode(q) as Map<String, dynamic>));
  QuizValidationResult importCandidates(List<Map<String, dynamic>> candidates) {
    final issues = <String>[];
    final ids = <String>{};
    if (candidates.isEmpty) issues.add('empty');
    for (final candidate in candidates) {
      final content = candidate['content'];
      final hash = content is Map ? curriculumFingerprint(content) : '';
      final signoff = _trusted[hash];
      final source = content is Map ? content['source'] : null;
      final approvedAt =
          DateTime.tryParse(candidate['approved_at']?.toString() ?? '');
      if (candidate['id'] is! String ||
          (candidate['id'] as String).trim().isEmpty ||
          !ids.add(candidate['id'] as String)) {
        issues.add('invalid_or_duplicate_id');
      }
      if (candidate['status'] != 'approved' ||
          hash.isEmpty ||
          signoff == null ||
          signoff.contentHash != hash ||
          candidate['approval_revision'] != hash ||
          candidate['reviewer'] != signoff.reviewer ||
          signoff.reviewer.trim().isEmpty ||
          approvedAt == null ||
          !approvedAt.isAtSameMomentAs(signoff.approvedAt)) {
        issues.add('qualified_review_required');
      }
      if (source is! Map ||
          !QuizSourceReference(
                  url: source['url']?.toString() ?? '',
                  location: source['location']?.toString() ?? '')
              .valid) {
        issues.add('source');
      }
      try {
        if (content is! Map || content['question'] is! Map) {
          throw const FormatException();
        }
        for (final field in [
          'subject',
          'grade',
          'topic',
          'content_version',
          'hint'
        ]) {
          if (content[field] is! String ||
              (content[field] as String).trim().isEmpty) {
            throw const FormatException();
          }
        }
        final objectives = content['objectives'];
        if (objectives is! List ||
            objectives.isEmpty ||
            objectives.any((o) => o is! String || o.trim().isEmpty)) {
          throw const FormatException();
        }
        final raw = Map<String, dynamic>.from(content['question'] as Map);
        if (!['single_select', 'identification'].contains(raw['kind'])) {
          throw const FormatException();
        }
        final q = NorieStudyQuestion.fromMap(raw);
        if (q.id != candidate['id'] ||
            q.prompt.trim().isEmpty ||
            q.explanation.trim().isEmpty ||
            q.correctValues.length != 1 ||
            q.correctValues.single.trim().isEmpty ||
            q.topicTag != content['topic'] ||
            !['foundation', 'intermediate', 'advanced']
                .contains(q.difficulty)) {
          throw const FormatException();
        }
        if (q.kind == NorieStudyQuestionKind.singleSelect &&
            (q.options.length != 4 ||
                q.options.map((o) => o.trim().toLowerCase()).toSet().length !=
                    4 ||
                q.options.any((o) => o.trim().isEmpty) ||
                !q.options.contains(q.correctValues.single))) {
          throw const FormatException();
        }
        if (q.kind == NorieStudyQuestionKind.identification &&
            q.options.isNotEmpty) {
          throw const FormatException();
        }
      } catch (_) {
        issues.add('schema');
      }
    }
    // Invalid imports preserve the last successful staging report; neither path
    // adds anything to a running native provider or grants runtime publication.
    if (issues.isEmpty) _approved = candidates.map(jsonEncode).toList();
    return QuizValidationResult(
        issues,
        issues.isEmpty
            ? QuizValidationState.verified
            : QuizValidationState.needsReview);
  }
}
