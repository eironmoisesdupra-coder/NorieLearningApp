enum MembershipPlanId { free, plus, pro, family }

enum MembershipStatus { free, active, grace, expired, canceled, pendingVerify }

enum MembershipSource { serverReceipt, serverAdministrative }

class NorieMembershipPlan {
  const NorieMembershipPlan({
    required this.id,
    required this.title,
    required this.monthlyPhp,
    required this.benefits,
    this.maxProfiles = 1,
  });

  final MembershipPlanId id;
  final String title;
  final int monthlyPhp;
  final List<String> benefits;
  final int maxProfiles;
}

abstract final class NorieMembershipCatalog {
  static const checkoutEnabled = false;
  static const plans = [
    NorieMembershipPlan(
      id: MembershipPlanId.free,
      title: 'Free',
      monthlyPhp: 0,
      benefits: [
        'Core offline lessons and quizzes',
        'XP, progression, achievements and mastery',
      ],
    ),
    NorieMembershipPlan(
      id: MembershipPlanId.plus,
      title: 'Norie Plus',
      monthlyPhp: 79,
      benefits: [
        'Proposed: more AI creation capacity',
        'Proposed: larger source uploads',
      ],
    ),
    NorieMembershipPlan(
      id: MembershipPlanId.pro,
      title: 'Norie Pro',
      monthlyPhp: 149,
      benefits: [
        'Proposed: expanded AI creation capacity',
        'Proposed: advanced study organization tools',
      ],
    ),
    NorieMembershipPlan(
      id: MembershipPlanId.family,
      title: 'Norie Family',
      monthlyPhp: 249,
      maxProfiles: 4,
      benefits: [
        'Proposed: up to four managed profiles',
        'Proposed: guardian management tools',
      ],
    ),
  ];
}

/// Descriptive metadata only. Neither construction nor parsing grants access.
///
/// A future adapter must obtain this from an authenticated server that verifies
/// receipts. A payload's source label is never evidence of authenticity.
class MembershipSnapshot {
  const MembershipSnapshot._({
    required this.ownerId,
    required this.plan,
    required this.status,
    required this.source,
    required this.revision,
    required this.issuedAt,
    required this.expiresAt,
  });

  final String ownerId;
  final MembershipPlanId plan;
  final MembershipStatus status;
  final MembershipSource source;
  final int revision;
  final DateTime issuedAt;
  final DateTime? expiresAt;

  /// Shape/lifecycle validation, not authentication or authorization.
  /// [minimumRevision] must be supplied by a trusted server checkpoint.
  static MembershipSnapshot? validateServerMetadata(
    Map<String, Object?> data, {
    required String ownerId,
    required int minimumRevision,
    required DateTime now,
  }) {
    if (ownerId.isEmpty ||
        ownerId.trim() != ownerId ||
        data['ownerId'] != ownerId ||
        minimumRevision < 0) {
      return null;
    }
    final revision = data['revision'];
    if (revision is! int || revision < 1 || revision < minimumRevision) {
      return null;
    }
    final plan = _named(MembershipPlanId.values, data['plan']);
    final status = _named(MembershipStatus.values, data['status']);
    final source = _named(MembershipSource.values, data['source']);
    final issuedAt = _utcTimestamp(data['issuedAt']);
    if (plan == null ||
        status == null ||
        source == null ||
        issuedAt == null ||
        issuedAt.isAfter(now)) {
      return null;
    }
    final expiresAt = _utcTimestamp(data['expiresAt']);
    if (status == MembershipStatus.free) {
      if (plan != MembershipPlanId.free || data['expiresAt'] != null) {
        return null;
      }
    } else {
      if (plan == MembershipPlanId.free ||
          expiresAt == null ||
          !expiresAt.isAfter(issuedAt)) {
        return null;
      }
      if (status == MembershipStatus.expired) {
        if (expiresAt.isAfter(now)) return null;
      } else if (!expiresAt.isAfter(now)) {
        return null;
      }
    }
    return MembershipSnapshot._(
      ownerId: ownerId,
      plan: plan,
      status: status,
      source: source,
      revision: revision,
      issuedAt: issuedAt,
      expiresAt: expiresAt,
    );
  }

  static T? _named<T extends Enum>(List<T> values, Object? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  static DateTime? _utcTimestamp(Object? value) {
    // Strict spelling rejects timezone ambiguity and DateTime's overflow dates.
    if (value is! String ||
        !RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$').hasMatch(value)) {
      return null;
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null ||
        parsed.toIso8601String().replaceFirst('.000Z', 'Z') != value) {
      return null;
    }
    return parsed;
  }
}

/// Future authenticated server boundary. Never use client backups as authority.
/// Discard results when the signed-in owner changes during a refresh.
abstract interface class MembershipAuthority {
  Future<MembershipAvailability> refreshForOwner(String ownerId);
}

/// Foundation result deliberately has no constructor capable of granting access.
class MembershipAvailability {
  const MembershipAvailability.unavailable();

  MembershipSnapshot? get snapshot => null;
  bool get billingAvailable => false;
  bool get paidAccessEnabled => false;
  bool get coreLearningAvailable => true;
}

class UnavailableMembershipAuthority implements MembershipAuthority {
  const UnavailableMembershipAuthority();

  @override
  Future<MembershipAvailability> refreshForOwner(String ownerId) async =>
      const MembershipAvailability.unavailable();
}
