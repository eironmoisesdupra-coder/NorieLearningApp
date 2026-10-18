# Master WIP implementation plan

> For agentic workers: use superpowers:subagent-driven-development with independent file ownership; root serializes Flutter and release integration.

Goal: integrate the owner-supplied master WIP into working offline-first app features, without fabricated billing, content approval, cloud authorization or certification.
Architecture: extend current economy/profile, authored curriculum registry, classroom codecs and release gates. Local drafts and published learner content remain separate. All cloud publishing and entitlement decisions require a server authority. No production credentials or migrations are applied.
Tech stack: Flutter/Dart, existing Supabase boundaries, Node/Python release checks.
Spec: docs/wip/2026-10-18-master/README.md and packets00-08, inspected manually. Baseline develop 6219b60f198fab7732e3d4c8ac66a20c7e60645d; original dirty checkout untouched.

Global constraints: preserve XP math, saved ranks/cosmetics, credit ledger/catalog IDs and historical receipts, learner ownership, offline curriculum and old backups. Owner approved the proposed seven credit prices on 2026-10-18; remote account purchases remain gated pending server catalog rollout. Membership prices are proposed PHP display values, never Norie Credits or live checkout. No client-side publication or self-assigned teacher/reviewer role. Signed/store/device gates remain pending until real evidence.

Review focus: double-spend/duplicate retry, stale learner callbacks, malformed imports/cycles/dangling revisions, authored draft leakage into live maps, guided-help versus independent evidence, false cloud/payment/certification states.

- [ ]00 inspect latest rank layers/tests; retain supplied rank images and verify motion/reduced motion/ticker pause, truthful layer description and performance.
- [ ]01 Shop: tests before implementation; category browse, temporary current-avatar preview, owned/equip/unequip, balance confirmation, actual pending/retry state and filtered receipts. Reuse ledger; no accounting reimplementation. Review independently, focused PR.
- [ ]02 memberships: explicit proposed plan comparison, renewal/help and disabled billing; strict server entitlement snapshot interface with expiry/revision/source, never grant paid status locally. Tests for malformed/expired/stale/cross-owner data; focused PR.
- [ ]03 registry: stable immutable revisions and published adapters for existing authored curriculum; draft/review/approved/published/retired metadata and content/prerequisite/answer/license checks. Preserve old topic IDs/evidence. Focused PR.
- [ ]04 guided/assessment: real lesson-flow adapter and validated multi-format practice with grade-sensitive scaffolding; independent versus assisted/retention evidence stays separate, no XP reduction. Focused PR.
- [ ]05 studio/path builder: durable owner-scoped local drafts, search/edit/preview/diff/rollback/prerequisite graph validation; protected publication remains unavailable. Focused PR.
- [ ]06 packs: versioned bounded imports/exports, metadata/assets/license/fingerprint/prerequisite validation, staging states; no unreviewed draft becomes a live lesson. Focused PR.
- [ ]07 cloud Classroom: inspect existing backend and consent/role prerequisites; implement disabled-by-default client boundary, class-isolated/idempotent offline outbox and honest configuration status, preserve LAN/file flows. Server contract/security tests and setup instructions; do not apply migrations without permission. Focused PR.
- [ ]08 verify existing strict store/signing/certification checks; add actionable setup status without fake evidence or production signing. Focused PR.
- [ ] Full analysis/tests, phone320px/160%, real web/Windows/Android builds, offline/public checks; exact-head green CI per reviewed packet, develop integration, public web and dual-platform Preview downloads. Record all remaining configuration precisely.

Ruling: user explicitly requests implementation/live app using this concrete supplied backlog. Proceed within existing authorization; optional pricing/backend questions asked early. Apply approved guest prices and keep account purchasing/cloud Classroom unavailable until verified server configuration. Never invent human editorial/reviewer approval. Every externally gated feature must report its actual state; prepared local authoring is not server publication.
