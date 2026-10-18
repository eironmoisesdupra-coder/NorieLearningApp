import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/commerce/domain/norie_membership.dart';

void main() {
  final now = DateTime.utc(2026, 10, 18);
  Map<String, Object?> response() => {
        'ownerId': 'learner-a',
        'plan': 'plus',
        'status': 'active',
        'source': 'serverReceipt',
        'revision': 3,
        'issuedAt': '2026-10-17T00:00:00Z',
        'expiresAt': '2026-11-17T00:00:00Z',
      };
  MembershipSnapshot? parse(Map<String, Object?> value) =>
      MembershipSnapshot.validateServerMetadata(
        value,
        ownerId: 'learner-a',
        minimumRevision: 3,
        now: now,
      );

  test('proposed PHP catalog preserves core free learning and family limit',
      () {
    expect(NorieMembershipCatalog.plans.map((p) => p.monthlyPhp),
        [0, 79, 149, 249]);
    expect(NorieMembershipCatalog.plans.last.maxProfiles, 4);
    expect(NorieMembershipCatalog.checkoutEnabled, isFalse);
  });

  test('server metadata retains owner, status, source, revision and expiry',
      () {
    final snapshot = parse(response())!;
    expect(snapshot.ownerId, 'learner-a');
    expect(snapshot.plan, MembershipPlanId.plus);
    expect(snapshot.status, MembershipStatus.active);
    expect(snapshot.source, MembershipSource.serverReceipt);
    expect(snapshot.revision, 3);
    expect(snapshot.expiresAt, DateTime.utc(2026, 11, 17));
  });

  test('malformed, cross-owner, stale and expired active metadata fail closed',
      () {
    for (final mutation in <Map<String, Object?>>[
      {'ownerId': 'learner-b'},
      {'ownerId': ''},
      {'revision': 2},
      {'revision': 3.0},
      {'revision': -1},
      {'plan': 'unknown'},
      {'status': 'purchased'},
      {'source': 'local'},
      {'source': null},
      {'expiresAt': null},
      {'expiresAt': 'invalid'},
      {'expiresAt': '2026-11-31T00:00:00Z'},
      {'expiresAt': '2026-11-17T00:00:00+08:00'},
      {'issuedAt': null},
      {'issuedAt': '2026-11-17T00:00:00Z'},
      {'expiresAt': '2026-10-18T00:00:00Z'},
      {'expiresAt': '2026-11-17T00:00:00'},
      {'issuedAt': '2026-10-19T00:00:00Z'},
      {'plan': 'free'},
    ]) {
      expect(parse({...response(), ...mutation}), isNull, reason: '$mutation');
    }
  });

  test('all server lifecycle statuses are represented without inferring access',
      () {
    for (final status in ['active', 'grace', 'canceled', 'pendingVerify']) {
      expect(parse({...response(), 'status': status})?.status.name, status);
    }
    expect(parse({...response(), 'status': 'expired'}), isNull);
    expect(
        parse({
          ...response(),
          'status': 'expired',
          'expiresAt': '2026-10-17T12:00:00Z'
        })?.status,
        MembershipStatus.expired);
    expect(
        parse({
          ...response(),
          'plan': 'free',
          'status': 'free',
          'expiresAt': null
        })?.status,
        MembershipStatus.free);
  });

  test('unavailable authority cannot restore or grant a paid membership',
      () async {
    // Even a server-shaped imported assertion is metadata, never a grant.
    expect(parse(response()), isNotNull);
    const authority = UnavailableMembershipAuthority();
    final result = await authority.refreshForOwner('learner-a');
    expect(result.billingAvailable, isFalse);
    expect(result.snapshot, isNull);
    expect(result.paidAccessEnabled, isFalse);
    expect(result.coreLearningAvailable, isTrue);
  });
}
