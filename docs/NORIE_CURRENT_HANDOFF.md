# Discovery Adventure MVP candidate

Target **0.17.0+23 Preview**, branch `feat/discovery-adventure-mvp`, [PR #70](https://github.com/eironmoisesdupra-coder/NorieLearningApp/pull/70). Current-develop baseline `899b7ab5458583fd8cc5558aca6cc0ba3c444007`. User confirmed the Discovery Adventure MVP ZIP. Original dirty checkout remains untouched.

Implemented the full optional Vanishing Water case under Learn > Activities: original 2D room, five keyboard/touch/list props, three observations, controlled warm/cool trials, hypothesis plus evidence, fresh application, full-body Norie, owner-scoped save/retry/temporary mode and idempotent local Discovery Journal. No XP/credit/mastery writes or remote dependency. Experimental/ungraded pending teacher review and learner testing.

Complete feature revision `07627da38a7f8bc22c20ef29fe6ffa79b53969ce` passed clean analysis, 944 Flutter tests (one existing native interop skip), web build, compiled browser checks at 320/390px and 100/160% text, actual installed-browser offline completion/reload, actual packaged Windows offline mission/reload/replay, independent code/visual review and all three PR CI workflows. Five review issues have RED/GREEN proof. The subsequent version-only packaging follow-up requires fresh exact-head CI; check PR #70 for its current head/results rather than treating historical results as current.

See [Discovery status, requirement evidence and limitations](implementation/discovery-adventure.md). No public promotion/merge/tag/release has occurred. The supplied brief requires owner approval for publication; the owner question is pending. Physical Android certification, qualified teacher/consented learner validation and existing production signing/support/privacy gates remain external. Use the established develop-only, exact-SHA Preview release workflow after approval; never main. Final handoff includes both Windows and Android download links with the real revision.

---

## Historical handoff

# NorieLearning 0.14 native rank animations

Version **0.14.0+18 Preview**, branch `feat/native-rank-animations`, baseline develop `10a0e11b7158c515ba6aeb2e4b56ec44fc1e7463`. Owner supplied NorieLearning-WIP-Native-Rank-Animations-2026-10-17.zip and requested integration. Archive inspected manually; installer never run. Reused isolated integration workspace; original dirty checkout preserved.

Implemented offline native crests for Rookie (Level 1), Novice (Level 5), Veteran (Level 15), Scholar (Level 30) and Master (Level 50). XP curve and all milestones remain unchanged. Saved cosmetic IDs explorer/curious/scholar/specialist/master retain their exact levels and ownership, including old scholar = Veteran (Level 15) and specialist = Scholar (Level 30). Home, Progress ladder/current rank, Profile, appearance studio and reward feedback use the crests. Large views animate; small rows remain static. Existing app/OS reduced motion and route TickerMode stop motion; inactive Progress/Profile tabs explicitly disable tickers. Full-frame mascot, anatomy, lessons, mastery and rewards are preserved. Private league points/tiers are a separate unchanged system.

Local full Flutter suite passed 767 tests, with one intentional packaged interop skip; after SDK lint cleanup, 14 affected tests passed and analysis is clean. Regression proved hidden-tab issue before fix. Independent review has no remaining P1/P2 findings. Source asset audit passed; supplied PNGs preserved byte-for-byte. Web build, actual crest screenshots and packaged Windows checks are in progress. PR CI must validate exact-head full tests, Android APK/AAB, Windows offline behavior and exact artifact budgets before merge; merged-source CI/web and dual-platform publication follow. Final PR/release records exact SHA and verified downloads.

Preview signing and all external store gates from 0.13 remain pending: no production keys, public support/privacy details, hardware certification or store submission. See [rank implementation](implementation/native-rank-animations.md) and [level rules](LEVEL_SYSTEM.md).

---

# NorieLearning 0.13 polish / store-preflight integration

Version **0.13.0+17 Preview**, branch `feat/polish-store-readiness`, baseline develop `6364ff7c043a465653e13cc8108a4be08ee3b312`. User supplied `NorieLearning-WIP-0.13-to-store-ready-2026-10-17.zip` and requested implementation; archive inspected manually, installer never executed. Existing isolated integration worktree reused; original checkout preserved.

Implemented scope: QR-first Classroom with manual fallback, typed recovery and explicit safe retry, capability-negotiated anonymous active device links and current shared assignments; five Learn groups with real resume/progress, preserved tutorials/routes and no preset percentages; evidence-based dashboard/mentor retained and seasonal presentation derived from catalog; deterministic source/exact-artifact budget audit; strict nonpublishing store schema/evidence reports and honest listing drafts. Added separate Preview AAB CI build/provenance and optional protected candidate AAB signing with pinned verification and unchanged payload checks. No production credential, physical certification or store submission is claimed.

Owner explicitly confirmed no signing credentials and no public support email/privacy policy URL. All thirteen production/store readiness gates remain not_tested. Schema preflight may pass while readiness is false; strict readiness rejects blockers. Do not suppress schema failures. Real-key AAB rehearsal and Windows Store identity/package path remain external follow-through, alongside physical migration/Wi-Fi/device and legal review.

Local validation passed: analysis clean; 762 Flutter tests; release web build and Windows Electron package; phone320x640/160% widget checks; browser Classroom/seasonal/Learn navigation and visual checks; packaged Electron teacher/native Dart learner durable exchange, duplicate/reconnect retry and unchanged XP; 35 Node/web-shell tests; release/asset/AAB and store-preflight suites. Symlink privilege cases are explicitly skipped on this Windows host. Independent review has no remaining P1/P2 findings. Android APK/AAB builds, exact platform artifact budgets and publication require remote CI. Final PR/release records exact head/merged SHA and green PR -> develop -> web/dual Preview publication. No main updates. All external store gates remain pending.

See [polish details](implementation/0.13-polish-certification.md), [budgets](implementation/package-optimization.md), [store gates](implementation/store-ready.md) and [plan](superpowers/plans/2026-10-17-polish-store-readiness.md).

---

## Historical0.12 integration notes

# NorieLearning roadmap 18 / 19 / 20 integration

Updated 2026-10-17. Version **0.12.0+16 Preview**, branch `feat/live-lan-release-certification`, current-develop baseline `f4255a04ab71cb313f05c4d3223b7865d380256d` (0.11.0+15 / PR45-46). User supplied NorieLearning-WIP-roadmap-18-19-20-2026-10-17.zip and requested implementation. Archive inspected; its installer was never executed. Reused the isolated NorieLearning-integrate workspace and preserved the original dirty checkout.

## Scope and external prerequisites

- **18 signing:** separate protected manual workflow creates signed production candidates from exact-revision trusted CI artifacts, checks pinned certificate identities, artifact/source/version bindings and Windows timestamps, confines secrets to matching platform runners, cleans credentials, and rejects unsafe ZIPs. Preview release metadata explicitly says `channel: preview`. No signing credential is generated or committed. Owner confirmed **no production credentials yet; keep downloads Preview**. The production workflow has not been triggered. Real signer execution and Android preview-to-production migration evidence remain pending.
- **19 certification:** five-device human report template and strict verifier, twelve scenarios, source/build/artifact-digest bindings and evidence-file checks. Missing/duplicate/unknown hardware classes and incomplete results reject; CI cannot certify hardware. Passing structural checks is not proof of physical results. No real hardware report or certification is claimed.
- **20 LAN Classroom:** installed Windows/Electron and native Android host/join support using explicit selected assignments, temporary code/session and local QR. Existing classroom codecs/resolver/store validate installed content, recompute scores and durably save before ACK. Learners download/practise/return the same saved result; retry/rejoin is idempotent. Roster shows received-result aliases, not attendance. No XP, credits, mastery or league rewards are awarded by this mode.

## Platform and lifecycle behavior

Windows actually ships Electron, so native Dart-only overlay would not work there. Added a sandboxed preload and exact top-level `norie://app/` IPC allowlist. Node handles bounded local HTTP transport; Dart remains the persistence/scoring authority. Native Dart uses the same protocol/handler. Private literal IPv4 + explicit port only, no public/DNS/redirect endpoints, bounded streamed input and readers/pending memory, code throttling, deadlines, no wildcard CORS. Hosting begins only after explicit selection/start and stops on route departure, learner ownership change, reload/crash/exit. Codes are not persisted or cloud-relayed.

Hosted web remains file-based; LAN screens explain that installed Windows/Android apps are required. Existing file exchange stays usable. Android QR scanning uses bundled offline ML Kit and requests camera only when scanning; camera hardware is optional and manual address/code entry remains available. Camera lifecycle belongs to the scanner widget.

## Verification / publication state

Full Flutter suite: **748 passed**, with the packaged interoperability test deliberately skipped in the ordinary runner and run separately against Electron. Analysis clean; release web build and Windows packaging passed. Targeted native LAN: 11 tests; phone/retry widgets: 3 tests at 320px/160% text; desktop: 18 tests; release helpers: 11 tests; certification tools: 2 tests; web shell: 16 tests. Actual browser teacher/learner file exchange, CSV report, installed-app fallback and seasonal navigation passed with external origins blocked. Actual packaged Windows/Electron teacher to native Dart learner loopback passed: UI-authored assignment/QR, wrong-code rejection, download, durable recomputed score, idempotent duplicate/reconnect retry, unchanged XP and stop-on-exit. Screenshots inspected at phone width. Diagnostics export, disabled-history persistence after reload and guest reward controls passed. Remote build and publication gates remain pending. All workflow YAML parses. Independent reviews checked durable ACK, ownership, bridge authorization and honest certification boundaries.

Do not infer publication from this file. Complete local checks and actual packaged Electron/native-Dart interoperability, then canonical focused commits and PR into develop, green exact-head CI, merge, merged-source Android/Windows/web verification, and dual-platform Preview publication. Final PR/release metadata records exact SHA and CI. Never main. Physical Windows-teacher/Android-student isolated Wi-Fi, camera/firewall flow, five-device performance and production-signed migration remain human hardware work, not loopback/CI claims.

See [LAN usage](implementation/classroom-lan.md), [production signing](implementation/production-signing.md), [physical certification](implementation/device-certification.md), and the [implementation plan](superpowers/plans/2026-10-17-lan-signing-certification.md).

---

## Historical 0.11 integration notes

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
