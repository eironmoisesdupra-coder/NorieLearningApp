# Master WIP Preview availability

This implementation extends develop baseline 6219b60f198fab7732e3d4c8ac66a20c7e60645d. The original proposal is archived unchanged under docs/wip/2026-10-18-master; its original status JSON is a source snapshot, not the current release status.

## Included in this Preview revision

- Rank motion regression coverage preserves the supplied crest assets, stable IDs, milestones, independent decorative layers and reduced-motion/hidden-route behavior.
- Shop category browsing, temporary current-avatar preview, purchase confirmation, inventory equip/unequip, visible Profile cosmetics, receipt filters and persistence/sync retry. Owner approved guest prices: shield 250, cyan frame 200, violet frame 400, atom badge 300, streak badge 350, aurora 600 and ember 750 Credits. Historical receipt amounts are preserved.
- Free/Plus/Pro/Family comparison with proposed PHP prices and renewal/cancellation/refund/restore help. Billing and paid access remain unavailable.
- Immutable bundled curriculum registry, revision fingerprints, structural/editorial checks and strict import budgets.
- Guided reading and rehearsal using actual authored teaching; assisted and independent rehearsal stay separate. Explicitly authored numeric+unit, multiselect, text and ordering formats are supported. Normal quizzes retain reward/mastery authority.
- Local curriculum Studio: owner-scoped drafts, JSON editing, validation, preview, diff, rollback and fingerprint-pinned path designs.
- Bounded content pack import/export and draft staging. The Curriculum workspace menu opens the offline library, Studio and packs. Drafts never replace published lessons or learner history.
- Read-only Preview configuration screen and offline Classroom setup link. File exchange remains available; LAN requires installed Windows/Android.

## Still requires configuration or real review

Account-backed Shop purchases stay blocked until a reviewed server-price rollout preserves old pending requests and receipts. New local guest prices do not change the existing authoritative SQL catalog.

Cloud Classroom was explicitly left unconfigured by the owner. Server-managed teacher/reviewer roles, invitations, class RLS, consent, deletion/retention, durable idempotent submission/outbox and multi-account testing are required before connection. Existing account sync does not enable classroom uploads. See master-wip-configuration.md.

Memberships require platform billing, verified server receipts/webhooks, approved final pricing/benefits/renewal/refund terms and guardian/privacy review. Parsing a plan label or importing a backup cannot grant access.

New curricula, sources/licenses, worked examples, assessment mixes, Filipino/AP expansion and final editorial approval require real authoring and review. Local validation checks structure; it cannot certify factual accuracy. Publication, live path replacement and migrations remain protected future integrations.

Production Android/Windows signing, published privacy policy, support contact, account deletion/store declarations, store graphics/ratings and actual physical-device/Wi-Fi/migration evidence remain pending. Existing store/readiness.json gates are preserved. Downloads remain Preview.

## Promotion

Each packet has a focused PR into develop; dependent curriculum PRs retain their reviewed parent commits. Promotion requires exact-head CI and merged-source web/Windows/Android validation. Release notes and final handoff identify the actual published source SHA and durable package URLs; implementation availability above does not claim production certification.
