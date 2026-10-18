# Membership foundation

Packet 02 is a nontransactional comparison. Proposed Philippine monthly prices are Free PHP 0, Plus PHP 79, Pro PHP 149, and Family PHP 249 for up to four managed profiles. These are planning values, separate from earned Norie Credits. Paid benefits, capacities and managed profiles are proposals, not implemented services or account entitlements. No service quotas are promised. Core offline lessons, quizzes, XP, progression and mastery stay free.

The existing membership route presents all four plans using wrapping text and a vertically scrolling layout. Renewal, cancellation, refund and restoration help explain the unavailable state without issuing a purchase, cancellation, refund or restore request. No payment fields, external payment links, checkout SDKs or credentials are added. Billing stays unavailable.

## Entitlement boundary

`MembershipSnapshot.validateServerMetadata` checks metadata shape and lifecycle consistency only. It is **not** receipt verification or proof of authenticity. Its output must never be used by itself to unlock anything. A map, backup, local preference or imported account assertion cannot grant paid access. This foundation has no membership persistence or paid-access gate.

The snapshot contains owner, plan, lifecycle status (`free`, `active`, `grace`, `expired`, `canceled`, `pendingVerify`), server source, revision, issue time and optional expiry. Validation rejects owner mismatch, unsupported source/status/plan, stale or noninteger revisions, future issue times, ambiguous/non-UTC timestamps, inconsistent plan/status and invalid expiry windows. The revision floor must come from a trusted authority, never an imported client assertion. The caller must discard any asynchronous response after the current owner changes.

`MembershipAuthority` defines owner-scoped refresh for a future authenticated server adapter. The only implementation is `UnavailableMembershipAuthority`: no snapshot, billing unavailable, paid access disabled and core learning available. There is no successful restore or purchased-state simulation. Parsing server-shaped metadata cannot alter this result.

## External prerequisites

Before live billing: owner approval of final prices/benefits and renewal terms; platform-compliant Android/store integration; authenticated owner-scoped backend entitlement storage and receipt verification; server-side idempotency and monotonic revisions for renewals, cancellations, refunds and webhooks; appropriate guardian consent, privacy and legal review; and real store/device validation. A source label in a payload must never substitute for authenticated server verification. Refund eligibility and cancellation effects must be supplied by the eventual provider and published terms, rather than inferred by this preview.

## Verification

Targeted checks: `flutter test test/norie_membership_test.dart test/norie_membership_screen_test.dart`. Tests cover prices, lifecycle validation, malformed/cross-owner/stale/expired responses, fail-closed unavailable access, and the 320-pixel comparison/help flow at 160% text size. The integration agent runs Flutter checks, full analysis/tests and platform builds serially; test/build results must be recorded by that agent before release.
