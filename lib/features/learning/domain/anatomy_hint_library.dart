import 'anatomy_hint_geometry.dart';
import 'anatomy_hint_record.dart';
export 'anatomy_hint_geometry.dart';
export 'anatomy_hint_record.dart';

/// These attestations require an appointed qualified reviewer. Automatic
/// validation cannot prove any of them or grant a medically-verified label.
enum AnatomyHintHumanCheck {
  structureIdentity,
  sourceSupport,
  laterality,
  answerConsistency,
  noAnswerDisclosure,
}

class AnatomyHintApproval {
  AnatomyHintApproval(
      {required this.contentHash,
      required this.reviewerId,
      required this.approvedAt,
      required Set<AnatomyHintHumanCheck> checks})
      : checks = Set.unmodifiable(checks);
  final String contentHash, reviewerId;
  final DateTime approvedAt;
  final Set<AnatomyHintHumanCheck> checks;
}

class AnatomyHintRequest {
  const AnatomyHintRequest(
      {required this.displayed,
      required this.selectedPartId,
      required this.questionStructureId,
      required this.correctAnswer,
      required this.laterality});
  final AnatomyHintIdentity displayed;
  final String selectedPartId, questionStructureId, correctAnswer;
  final AnatomyHintLaterality laterality;
}

class AnatomyHintValidation {
  AnatomyHintValidation(
      Iterable<String> issues, Iterable<AnatomyHintHumanCheck> humanChecks)
      : issues = List.unmodifiable(issues.toSet()),
        humanReviewRequired = Set.unmodifiable(humanChecks);
  final List<String> issues;
  final Set<AnatomyHintHumanCheck> humanReviewRequired;
  bool get eligible => issues.isEmpty && humanReviewRequired.isEmpty;
}

enum AnatomyHintAvailability { available, unavailable }

class AnatomyHintResult {
  AnatomyHintResult._(this.record, Iterable<String> issues)
      : issues = List.unmodifiable(issues);
  final AnatomyHintRecord? record;
  final List<String> issues;
  AnatomyHintAvailability get status => record == null
      ? AnatomyHintAvailability.unavailable
      : AnatomyHintAvailability.available;
  String get generalGuidance => AnatomyHintLibrary.generalGuidance;
}

/// Production starts with no approved records and no trusted signoffs.
/// A future independently controlled review process must supply approvals through
/// trusted application configuration, never from downloaded authoring JSON.
/// This module cannot debit credits or unlock paid hints.
class AnatomyHintLibrary {
  AnatomyHintLibrary(
      {required this.geometry,
      required Iterable<AnatomyHintRecord> records,
      Iterable<AnatomyHintApproval> approvals = const []})
      : records = List.unmodifiable(records),
        _approvals = List.unmodifiable(approvals);
  final AnatomyHintGeometryIndex geometry;
  final List<AnatomyHintRecord> records;
  final List<AnatomyHintApproval> _approvals;

  static const generalGuidance = 'Examine the object’s overall proportions. '
      'Look for recognizable surfaces, then compare the visible structure '
      'with the regions listed in the options.';

  AnatomyHintValidation validate(AnatomyHintRecord record,
      {AnatomyHintRequest? request}) {
    final issues = <String>[];
    final expected = geometry.parts[record.identity.structureId];
    if (expected == null ||
        !expected.identity.matches(record.identity) ||
        expected.canonicalName != record.canonicalName) {
      issues.add('invalidMapping');
    }
    if (!anatomyHintSystems.contains(record.system) ||
        expected?.systems.contains(record.system) != true) {
      issues.add('invalidSystem');
    }
    if (record.laterality == AnatomyHintLaterality.unknown) {
      issues.add('unresolvedLaterality');
    }
    final nameWords = _words(record.canonicalName);
    if ((nameWords.contains('left') &&
            record.laterality != AnatomyHintLaterality.left) ||
        (nameWords.contains('right') &&
            record.laterality != AnatomyHintLaterality.right)) {
      issues.add('nameLateralityMismatch');
    }
    if (record.revision < 1) issues.add('invalidRevision');
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(record.contentHash) ||
        record.contentHash != record.computedHash) {
      issues.add('contentHashMismatch');
    }
    final source = Uri.tryParse(record.sourceUrl);
    if (source == null ||
        source.scheme != 'https' ||
        source.host.isEmpty ||
        source.userInfo.isNotEmpty ||
        record.sourceLocation.trim().isEmpty) {
      issues.add('invalidSource');
    }
    final hints = [
      record.generalHint,
      record.structuralHint,
      record.detailedHint
    ];
    if (hints.any((hint) => hint.trim().isEmpty)) issues.add('emptyHint');
    final answers = [
      record.canonicalName,
      ...record.synonyms,
      if (request != null) request.correctAnswer
    ];
    // Also reject the unsided base answer, e.g. "femur" in "left femur".
    final forbidden = answers
        .expand((answer) => [
              _words(answer).join(' '),
              _words(answer)
                  .where((w) => w != 'left' && w != 'right')
                  .join(' '),
            ])
        .where((answer) => answer.isNotEmpty);
    if (hints.any((hint) => forbidden.any(
        (answer) => ' ${_words(hint).join(' ')} '.contains(' $answer ')))) {
      issues.add('answerLeakage');
    }
    final opposite = switch (record.laterality) {
      AnatomyHintLaterality.left => 'right',
      AnatomyHintLaterality.right => 'left',
      _ => null,
    };
    if (opposite != null &&
        hints.any((hint) => _words(hint).contains(opposite))) {
      issues.add('oppositeLaterality');
    }
    if (record.synonyms.any((s) => s.trim().isEmpty) ||
        record.synonyms.toSet().length != record.synonyms.length) {
      issues.add('invalidSynonyms');
    }
    if (record.status != AnatomyHintStatus.approved) issues.add('notApproved');
    if (record.approvalHash != record.contentHash) {
      issues.add('approvalRevisionMismatch');
    }
    final approval = _approvals
        .where((a) =>
            a.contentHash == record.contentHash &&
            a.reviewerId.trim().isNotEmpty &&
            a.reviewerId == record.reviewerId &&
            record.approvedAt != null &&
            a.approvedAt.isUtc &&
            record.approvedAt!.isUtc &&
            a.approvedAt.isAtSameMomentAs(record.approvedAt!))
        .toList();
    if (approval.length != 1) issues.add('untrustedApproval');
    final humanChecks = AnatomyHintHumanCheck.values.toSet();
    if (approval.length == 1) humanChecks.removeAll(approval.single.checks);
    if (humanChecks.isNotEmpty) issues.add('humanReviewRequired');
    if (_activeMatches(record.identity.structureId).length > 1) {
      issues.add('duplicateMapping');
    }
    if (request != null &&
        (!record.identity.matches(request.displayed) ||
            request.selectedPartId != record.identity.structureId ||
            request.questionStructureId != record.identity.structureId ||
            request.correctAnswer != record.canonicalName ||
            request.laterality != record.laterality)) {
      issues.add('questionMappingMismatch');
    }
    return AnatomyHintValidation(issues, humanChecks);
  }

  List<AnatomyHintRecord> _activeMatches(String id) => records
      .where((r) =>
          r.identity.structureId == id &&
          r.status != AnatomyHintStatus.retired &&
          r.status != AnatomyHintStatus.rejected)
      .toList();

  AnatomyHintResult lookup(AnatomyHintRequest request) {
    final matches = _activeMatches(request.questionStructureId);
    if (matches.isEmpty) return AnatomyHintResult._(null, ['missingRecord']);
    if (matches.length != 1) {
      return AnatomyHintResult._(null, ['duplicateMapping']);
    }
    final report = validate(matches.single, request: request);
    return AnatomyHintResult._(
        report.eligible ? matches.single : null, report.issues);
  }

  static List<String> _words(String text) => text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\u00c0-\u024f]+'), ' ')
      .trim()
      .split(RegExp(r'\s+'));
}
