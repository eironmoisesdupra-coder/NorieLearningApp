import '../../curriculum/domain/curriculum_fingerprint.dart';

enum AnatomyHintStatus { draft, pendingReview, approved, rejected, retired }

enum AnatomyHintLaterality {
  unknown,
  left,
  right,
  midline,
  bilateral,
  notApplicable
}

/// Selectable atlas part identity, including every mesh in the isolated group.
/// The renderer selects structureId; meshIds are exact GLB node names, not labels.
class AnatomyHintIdentity {
  AnatomyHintIdentity({
    required this.structureId,
    required this.reference,
    required this.assetId,
    required this.assetSha256,
    required Iterable<String> meshIds,
  }) : meshIds = List.unmodifiable(meshIds.toList()..sort());

  final String structureId, reference, assetId, assetSha256;
  final List<String> meshIds;
  String get mappingKey => '$reference/$assetId/$structureId';

  factory AnatomyHintIdentity.fromJson(Map<String, dynamic> json) =>
      AnatomyHintIdentity(
        structureId: json['structureId'] as String,
        reference: json['reference'] as String,
        assetId: json['assetId'] as String,
        assetSha256: json['assetSha256'] as String,
        meshIds: List<String>.from(json['meshIds'] as List),
      );

  Map<String, Object?> toJson() => {
        'structureId': structureId,
        'reference': reference,
        'assetId': assetId,
        'assetSha256': assetSha256,
        'meshIds': meshIds,
      };

  bool matches(AnatomyHintIdentity other) =>
      structureId == other.structureId &&
      reference == other.reference &&
      assetId == other.assetId &&
      assetSha256 == other.assetSha256 &&
      meshIds.length == other.meshIds.length &&
      Iterable<int>.generate(meshIds.length)
          .every((i) => meshIds[i] == other.meshIds[i]);
}

/// Immutable authored content. Review fields are declarations until independently
/// matched against the trusted approval registry. No JSON can approve itself.
class AnatomyHintRecord {
  AnatomyHintRecord._({
    required this.revision,
    required this.identity,
    required this.canonicalName,
    required List<String> synonyms,
    required this.system,
    required this.laterality,
    required this.generalHint,
    required this.structuralHint,
    required this.detailedHint,
    required this.sourceUrl,
    required this.sourceLocation,
    required this.contentHash,
    required this.status,
    required this.reviewerId,
    required this.approvedAt,
    required this.approvalHash,
  }) : synonyms = List.unmodifiable(synonyms);

  final int revision;
  final AnatomyHintIdentity identity;
  final String canonicalName, system, generalHint, structuralHint, detailedHint;
  final String sourceUrl, sourceLocation, contentHash;
  final List<String> synonyms;
  final AnatomyHintLaterality laterality;
  final AnatomyHintStatus status;
  final String? reviewerId, approvalHash;
  final DateTime? approvedAt;

  factory AnatomyHintRecord.fromJson(Map<String, dynamic> json) {
    try {
      if (json['schemaVersion'] != 1) {
        throw const FormatException('Unsupported hint schema');
      }
      final source = json['source'] as Map<String, dynamic>;
      return AnatomyHintRecord._(
        revision: json['revision'] as int,
        identity: AnatomyHintIdentity.fromJson(
            json['identity'] as Map<String, dynamic>),
        canonicalName: json['canonicalName'] as String,
        synonyms: List<String>.from(json['synonyms'] as List),
        system: json['system'] as String,
        laterality:
            AnatomyHintLaterality.values.byName(json['laterality'] as String),
        generalHint: json['generalHint'] as String,
        structuralHint: json['structuralHint'] as String,
        detailedHint: json['detailedHint'] as String,
        sourceUrl: source['url'] as String,
        sourceLocation: source['location'] as String,
        contentHash: json['contentHash'] as String,
        status: AnatomyHintStatus.values.byName(json['status'] as String),
        reviewerId: json['reviewerId'] as String?,
        approvedAt: json['approvedAt'] == null
            ? null
            : DateTime.parse(json['approvedAt'] as String),
        approvalHash: json['approvalHash'] as String?,
      );
    } on Object catch (error) {
      throw FormatException('Invalid anatomy hint record: $error');
    }
  }

  Map<String, Object?> get content => {
        'schemaVersion': 1,
        'revision': revision,
        'identity': identity.toJson(),
        'canonicalName': canonicalName,
        'synonyms': synonyms,
        'system': system,
        'laterality': laterality.name,
        'generalHint': generalHint,
        'structuralHint': structuralHint,
        'detailedHint': detailedHint,
        'source': {'url': sourceUrl, 'location': sourceLocation},
      };

  /// Reuses the existing canonical JSON SHA-256 implementation. This is an
  /// integrity fingerprint, never a publisher signature or scientific evidence.
  String get computedHash => curriculumFingerprint(content);

  Map<String, Object?> toJson() => {
        ...content,
        'contentHash': contentHash,
        'status': status.name,
        'reviewerId': reviewerId,
        'approvedAt': approvedAt?.toUtc().toIso8601String(),
        'approvalHash': approvalHash,
      };
}
