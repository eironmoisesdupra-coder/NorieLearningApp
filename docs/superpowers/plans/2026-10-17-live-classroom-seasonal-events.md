# Live Classroom, Seasonal Learning and Event Sync Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans and dispatching-parallel-agents for isolated feature ownership. Follow focused test cycles and review integrations before release.

**Goal:** Finish supplied Roadmap 13A/14/15 WIP on develop02bacca28fdda0371492ac11b4be34358aaf2e68 and publish verified web/Windows/Android updates.

**Spec:** User explicitly requests live implementation of the supplied NorieLearning-WIP-roadmap-13A-14-15-2026-10-17.zip. Its README defines classroom as offline practice, seasonal content as optional, and event journals as a migration beside guarded snapshot sync. Installer is reference only; reviewed manual integration avoids incomplete load/import/reset wiring.

**Architecture:** Modular classroom models/codecs/store/builder/runner/reports, authored seasonal catalog/store/hub, and a durable owner-bound event journal merged through the existing compare-and-save snapshot protocol. Preserve established progression and competitive-score boundaries. Feature stores expose validated state for backups/ownership; no sample or claimed client score becomes verified league evidence.

**Tech Stack:** Existing Flutter, SharedPreferences, file_picker13.1, UUID, Supabase snapshot RPC. No new runtime dependencies.

## Constraints and review focus
- Preserve offline lessons, all live features, XP receipts, full-body mascot, anatomy geometry/cache/licenses, accessibility and account guards.
- Classroom packages are bounded, versioned, validated practice files. Recompute scores from actual authored questions; reject duplicate/conflicting/invalid responses and stale account saves. Teach real subject content. Builder and reports work on small phones.
- Seasonal missions resolve actual published topic IDs, have explicit date boundaries and durable idempotent keepsakes. Expiration never removes permanent lessons/rewards. No fake XP or league scoring.
- Journal replay/merge must be deterministic under reorder/duplicate events, account A/B/A changes, crash/restart, old-client snapshot import, concurrent edits and failed durable writes. Never silently discard events at a limit. Keep snapshot CAS and legacy compatibility until verified; disclose exact migration scope.
- Tests must exercise failure paths, persistence, ownership, malformed/oversized files, reward idempotency and multi-device convergence. Use 320px/160% UI checks and inspect actual web/Windows output.

## Tasks
- [x] Classroom: adapt supplied models/codecs/file IO; implement teacher builder, student runner, recomputed report import/export; add meaningful domain/storage/widget tests.
- [x] Seasonal: review catalog topic IDs and publish optional discovery campaign with clear lifecycle; persistent owner-bound keepsakes, lesson navigation, tests.
- [x] Event migration: durable immutable journal, strict bounded schema, deterministic merge/replay, startup/import/reset/backup/ownership and operation integration; convergence and legacy migration tests.
- [x] Integration: Learn/Profile entry points, account lifecycle and persistence hooks, versioning, independent review and full analyze/tests/builds.
- [ ] Publish: focused PR into develop, green exact-head CI, merged-source CI/web QA, durable same-revision Windows/Android release, final SHA and download verification. Never main.
