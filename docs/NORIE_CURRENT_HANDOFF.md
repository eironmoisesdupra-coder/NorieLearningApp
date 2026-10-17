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
