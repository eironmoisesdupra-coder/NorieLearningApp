import '../../curriculum/domain/curriculum_fingerprint.dart';
import 'norie_study_models.dart';

enum SourceReviewDecision { compared, flagged, unchecked }

enum SourceReviewStatus {
  unchecked,
  compared,
  flagged,
  missingSource,
  incomplete
}

/// Learner comparison only. This data cannot grant qualified content approval.
class SourceReviewRecord {
  const SourceReviewRecord(this.revision, this.decision, this.comparedAt);
  final String revision;
  final SourceReviewDecision decision;
  final DateTime comparedAt;

  Map<String, dynamic> toMap() => {
        'revision': revision,
        'decision': decision.name,
        'compared_at': comparedAt.toUtc().toIso8601String(),
      };
  factory SourceReviewRecord.fromMap(Map<String, dynamic> raw) {
    final revision = raw['revision'];
    final decision = raw['decision'];
    final at = raw['compared_at'];
    if (revision is! String ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(revision) ||
        decision is! String ||
        !SourceReviewDecision.values.any((d) => d.name == decision) ||
        at is! String ||
        DateTime.tryParse(at) == null) {
      throw const FormatException('Unreadable source comparison.');
    }
    return SourceReviewRecord(
        revision,
        SourceReviewDecision.values.byName(decision),
        DateTime.parse(at).toUtc());
  }
}

class StudySourceReview {
  StudySourceReview(
      {required this.ownerId,
      required this.setId,
      Map<String, SourceReviewRecord> records = const {}})
      : records = Map.unmodifiable(records);
  final String ownerId, setId;
  final Map<String, SourceReviewRecord> records;

  String revisionFor(NorieStudySet set, NorieStudyQuestion q) {
    final options = [...q.options]..sort();
    final data = {...q.toMap()}..remove('position');
    return curriculumFingerprint({
      'owner': ownerId,
      'set': set.id,
      'question': {...data, 'options': options},
      'source_type': set.sourceType,
      'source_name': set.sourceName,
      'ai_model': set.aiModel,
      'provenance': set.generationMetadata,
    });
  }

  static bool hasAnswerContent(NorieStudyQuestion q) =>
      q.id.trim().isNotEmpty &&
      q.prompt.trim().isNotEmpty &&
      q.explanation.trim().isNotEmpty &&
      (q.kind == NorieStudyQuestionKind.ordering
          ? q.orderedItems.isNotEmpty &&
              q.orderedItems.every((s) => s.trim().isNotEmpty)
          : q.correctValues.isNotEmpty &&
              q.correctValues.every((s) => s.trim().isNotEmpty));

  SourceReviewStatus statusFor(NorieStudySet set, NorieStudyQuestion q) {
    if (set.id != setId || (set.ownerId != null && set.ownerId != ownerId)) {
      return SourceReviewStatus.unchecked;
    }
    final record = records[q.id];
    final current = record != null && record.revision == revisionFor(set, q);
    if (current && record.decision == SourceReviewDecision.flagged) {
      return SourceReviewStatus.flagged;
    }
    if (q.sourceExcerpt.trim().isEmpty) return SourceReviewStatus.missingSource;
    if (!hasAnswerContent(q)) return SourceReviewStatus.incomplete;
    return current && record.decision == SourceReviewDecision.compared
        ? SourceReviewStatus.compared
        : SourceReviewStatus.unchecked;
  }

  bool completeFor(NorieStudySet set) =>
      set.questions.isNotEmpty &&
      set.questions.map((q) => q.id).toSet().length == set.questions.length &&
      set.questions
          .every((q) => statusFor(set, q) == SourceReviewStatus.compared);

  StudySourceReview decide(
      NorieStudySet set, String questionId, SourceReviewDecision decision,
      {DateTime? now}) {
    final matches = set.questions.where((q) => q.id == questionId).toList();
    if (set.id != setId ||
        questionId.trim().isEmpty ||
        (set.ownerId != null && set.ownerId != ownerId) ||
        matches.length != 1 ||
        (decision == SourceReviewDecision.compared &&
            (!hasAnswerContent(matches.single) ||
                matches.single.sourceExcerpt.trim().isEmpty))) {
      throw StateError(
          'This card cannot be compared with its retained source.');
    }
    return StudySourceReview(ownerId: ownerId, setId: setId, records: {
      ...records,
      questionId: SourceReviewRecord(revisionFor(set, matches.single), decision,
          (now ?? DateTime.now()).toUtc()),
    });
  }

  Map<String, dynamic> toMap() => {
        'schema': 1,
        'owner_id': ownerId,
        'set_id': setId,
        'records': records.map((id, record) => MapEntry(id, record.toMap())),
      };

  factory StudySourceReview.fromMap(Map<String, dynamic> raw,
      {required String ownerId, required String setId}) {
    if (raw['schema'] != 1 ||
        raw['owner_id'] != ownerId ||
        raw['set_id'] != setId ||
        raw['records'] is! Map) {
      throw const FormatException('Unreadable or foreign source comparison.');
    }
    final records = <String, SourceReviewRecord>{};
    for (final entry in (raw['records'] as Map).entries) {
      if (entry.key is! String ||
          (entry.key as String).trim().isEmpty ||
          entry.value is! Map) {
        throw const FormatException('Unreadable source comparison.');
      }
      records[entry.key as String] = SourceReviewRecord.fromMap(
          Map<String, dynamic>.from(entry.value as Map));
    }
    return StudySourceReview(ownerId: ownerId, setId: setId, records: records);
  }
}
