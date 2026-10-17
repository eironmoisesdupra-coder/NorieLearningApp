# NorieLearning Roadmap 15B / 16 / 17 integration

Updated 2026-10-17. Integrating **0.11.0+15** on `feat/live-sync-quality-diagnostics`, based on develop `e320420c2b45a7e3590c8460099e24f48b089ad6` (published 0.10.0+14 / PR44). The original dirty checkout remains preserved; work is isolated in NorieLearning-integrate. User authorized live implementation of NorieLearning-WIP-roadmap-15B-16-17-2026-10-17.zip. Archive inspected manually; its installer was not executed.

## Current scope

- **15B accounting:** durable reward/spend operations, stable earning claims, account-authoritative XP/credits/items/shields, origin sequences, atomic device spending reservations, durable checkpoints/acknowledgements and safe detail compaction. Study reward eligibility has a durable outbox so interrupted economy writes can retry. Lessons and rewards work offline; signed-in purchases queue within a funded allowance and unlock only after server confirmation.
- **16 curriculum quality:** deterministic published-content scanner and CI JSON artifact. Structural errors fail CI: duplicate identities/content, invalid options/answers, broken prerequisite graphs, missing authored coverage and invalid figures. Known intentional same-topic Grade1 math quiz/challenge reuse is narrowly allowed. Current scan covers 249 published topics with zero errors/warnings; approved lesson text was not rewritten.
- **17 diagnostics:** bounded local-only, sanitized category/source/route/time history; chained Flutter/platform handlers; retention/clear/disable/retry controls; manual JSON export. No raw errors, stacks, notes, answers, credentials, account identifiers, network telemetry or automatic upload.

## Backend deployment

Migrations `20261017030340_authoritative_economy.sql` and `20261017030617_economy_private_rpc_boundaries.sql` are deployed. Production rollback-only smoke passed after both migrations, using only a disposable learner. All new database advisories were resolved: public endpoints are invoker wrappers over owner/admission-checked private definer implementations, and private tables have explicit restrictive deny policies plus revoked client grants. The only remaining security advisory is the preexisting [disabled leaked-password protection](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection).

## Accounting compatibility and recovery

New migration `20261017030340_authoritative_economy.sql` retains the strict legacy learner-state schema and guards every legacy write with authoritative numeric mirrors after enrollment. Non-economic progress continues through the existing owner-guarded bundle RPC. Portable `economy_state` is validated locally and stripped from legacy server snapshots. Legacy first enrollment uses maximum historical XP, latest legacy balance/shields and permanent-item union; it cannot reconstruct unknown pre-upgrade individual earnings. Old clients cannot overwrite activated balances and must update to earn account XP/credits or purchase rewards reliably.

For an existing account, explicit guest adoption merges learning history and pending earning receipts while retaining confirmed account balances/items; unfunded guest purchases do not transfer as funded entitlements. A new account can adopt its guest baseline once. Backups never clone installation identity, sequence allocation or funded reservations. Manual restore rotates origin identity and requires reconnecting to fund purchases. Account checkpoints cannot be replaced by a legacy scalar backup.

Each reservation lasts seven days and reserves at most650 outstanding credits (the largest catalog price), plus confirmed shields. Separate devices cannot reserve the same funds. Expired or retired-device purchases are rejected and reconciled without having granted entitlements. Checkpoint acknowledgement follows durable local save. Every active registered device must acknowledge the latest checkpoint before detailed operations compact; devices never time out implicitly. Explicit retirement requires recovery on return. Permanent receipt digests, claim tombstones and origin watermarks remain after detail compaction to prevent replay.

Core lessons remain available if optional reward storage is damaged; damaged data is quarantined instead of silently replaced. Export/sync require recovery, and reward/purchase mutations pause until a valid restore. Keep a backup before preview APK replacement; Android remains preview/debug signed and Windows unsigned.

## Local verification

Full Flutter suite: **734 passed**. Full analysis clean. Release web build passed. Curriculum report:249topics, zeroerrors/zerowarnings. All16 webcache/update/download tests passed. Actual390px Edge browser diagnostics download/disabled-history restart/guest-budget controls passed with external origins blocked and screenshots inspected. SQL ledger, compatibility, private-boundary verifier and production rollback-only checks passed. Windows/Android exact-head CI and atomic public release remain mandatory gates; local success is not a publication claim.

## Verification and release gate

Run `flutter analyze`, full `flutter test`, `dart tool/curriculum_health.dart --json --output build/curriculum-health.json`, and `node scripts/verify_economy_database.mjs <pglite-module>`. Database fixtures exercise actual PostgreSQL authorization/RLS, retries/conflicts, sequence gates, escrow/catalog/expiry, legacy-write normalization, acknowledgement/retirement and replay after compaction. PGlite serializes sessions; these tests do not claim production multiple-backend lock stress.

Before live handoff: review/deploy the additive migration, production rollback-only SQL verification, green exact-head PR checks, merge to develop, merged-source Windows/Android/web checks, actual browser inspection, and atomic release publication with both durable downloads. Main is not a deployment target. Exact source SHA, CI state and release links are reported in the final handoff.

---

## Historical 0.10 release notes (superseded accounting boundary)

# NorieLearning Roadmap 13A / 14 / 15 integration

Updated 2026-10-17. Preparing **0.10.0+14** on `feat/live-classroom-seasonal-events`, based on develop `02bacca28fdda0371492ac11b4be34358aaf2e68` (published0.9.0+13 / PR43). Original dirty checkout remains preserved. User supplied `NorieLearning-WIP-roadmap-13A-14-15-2026-10-17.zip` and explicitly requests live implementation. Archive reviewed manually; its installer was not executed.

## Scope

- Classroom Phase A: teacher-authored assignments selecting real published subject/grade/topic questions, portable assignment/submission files, offline learner runner with required question context, attempt/hint policy, duplicate protection and teacher reports with recomputed answers. Practice files do not certify identity, secure examinations, XP or league scores.
- Seasonal Learning: optional coherent Grade1 Discovery2026 missions resolving actual authored lessons, explicit upcoming/active/archive dates, durable idempotent keepsake receipts and accessible lesson navigation. Permanent lessons/rewards never expire. Profile links to saved keepsakes.
- Event-assisted sync migration: immutable bounded operation receipts for lessons, assessment claims, challenges, rewards, classroom and seasonal operations. Restart/load/reset/import/backup/account hooks, deterministic same-ID semantic merge, conflict rejection and observable storage failure. No numeric reward mutators run during journal projection/import.

## Migration compatibility and limits

The supplied WIP's proposed new keys inside the old server snapshot would break strict older app binaries. New RPCs now store `sync_event_journal`, `classroom_state` and `seasonal_state` in owner-protected `learner_feature_state` while `learner_state` retains its supported schema. Read combines both consistently; compare-and-save covers both in one transaction. Extension conflict rolls back the core save too. Old clients can still read/save core snapshots and cannot erase new feature data through the old RPC. Updated backups use envelope version2 and accept legacy version1 imports.

As explicitly required by the archive, **guarded snapshots remain the scalar progression read model during this migration**. Journal merging does not claim conflict-free additive XP/credit accounting across arbitrary old snapshots or concurrent offline purchases. Existing XP maximum and local reward/assessment receipt rules are preserved, with no replay/double award. Numeric CRDT accounting and acknowledged checkpoint compaction require a separate migration; no unacknowledged receipt is silently truncated. Journal limit:10000 events/2MiB; combined feature data4MiB, full backup5MiB. Limits/storage errors remain explicit and local core progress remains available.

## Backend checkpoint

Supabase project `lafuuwoohizgwnrbbgqj`: additive migration `20261017004755_learner_feature_bundle.sql` deployed. New functions are security invoker, bound to authenticated owner and existing private-demo admission. Feature table has owner RLS; anonymous execute denied. Production rollback-only checks passed initial bundle save, strict old-client read compatibility, stale-extension atomic rollback, old RPC preservation and other-owner denial; fixture user/admission rows were verified absent after rollback. Follow-up migration `20261017005720_learner_feature_core_lifecycle.sql` also deployed after verifying zero orphans: core deletion now cascades to its feature snapshot. Real PostgreSQL/PGlite fixture covers the same, core/auth deletion lifecycles and more denial/retry cases; it does not claim simultaneous multiple-backend contention stress.

Pre-existing Supabase advisory remains: leaked-password protection disabled. No new security advisory introduced. Remediation: https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection . Existing private-demo gates remain; this is a public preview, not a claim of production auth readiness.

## Verification / publication

Classroom and seasonal domain/storage/320px160% widget checks passed. Actual Edge browser file exchange passed across isolated teacher/learner profiles: build/export assignment, import/complete/export submission, teacher import/recomputed CSV. Seasonal navigation renders correctly with external origins blocked. Review fixed stale-write disk effects, obsolete account applies, no-op sync notification loops and damaged-file recovery/backup gates. Local full Flutter suite: 671 tests passed. Release web build passed. Full analysis clean; 16 web shell/update/download tests and 3 release-tool tests passed; PostgreSQL bundle/lifecycle fixture passed. Windows offline tests, Android/web CI and exact-revision durable publication remain required before completion. Follow PR -> green CI -> develop -> web preview -> same-source packages. Never main.

Current published downloads remain **0.9.0+13** until the new publisher succeeds:

- Windows: https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/download/v0.9.0/NorieLearning-Windows.zip
- Android: https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/download/v0.9.0/NorieLearning-Android.apk
- App: https://eironmoisesdupra-coder.github.io/NorieLearningApp/

Classroom participants must use matching installed content revisions; content fingerprints reject mismatched assignments rather than scoring different questions. Local aliases and attempt limits are practice aids, not verified identity or tamper-proof exams.

Windows remains unsigned; Android uses preview/debug signing. Physical Android file-flow testing and production signing remain release limitations; back up progress before an Android reinstall. Always report actual source SHA, CI and both current durable package links.
