# Live Accounting, Curriculum Quality and Diagnostics Implementation Plan

> **For agentic workers:** Use superpowers:subagent-driven-development and dispatching-parallel-agents for independent domains. Follow test-driven development and independent review.

**Goal:** Complete the supplied roadmap 15B/16/17 archive on develop e320420c2b45a7e3590c8460099e24f48b089ad6, then publish verified web/Windows/Android packages through PR and green CI.

**Spec:** User explicitly requests live implementation of NorieLearning-WIP-roadmap-15B-16-17-2026-10-17.zip. Its README lists unfinished production requirements; copying the stubs does not meet the request. Treat installer as reference, preserve existing architecture and offline learning.

**Architecture:** Independent curriculum quality validator/CI report and strictly redacted local diagnostics. Accounting extends the existing immutable journal and guarded bundle migration with baseline-aware additive projections, server sequence/checkpoints, durable device acknowledgements, safe compaction, and server-issued spending budgets. Existing legacy compatibility must be demonstrated before making numeric snapshots secondary. Detailed accounting interfaces follow inspection of all reward/spend producers and current SQL.

**Tech stack:** Flutter, existing SharedPreferences/file_picker/UUID, Supabase PostgreSQL RPCs; no unsolicited remote diagnostics or new paid services.

## Constraints and review focus

- Preserve every existing feature, the Norie theme, phone layouts, full-body mascot, anatomy geometry/hotspots/cache/licenses, and offline core lessons.
- Never replay a legacy total as a new award; every reward/spend needs stable identity and bounded validated amounts. Two devices must not spend the same account credits.
- Compaction requires authoritative ordering, exact checkpoint coverage, persisted acknowledgements and restart/offline-device safety. Retain evidence until safe; reject conflicting IDs, never silently trim.
- Curriculum checks distinguish structural errors from editorial heuristics; do not rewrite approved lessons merely to satisfy arbitrary text-length thresholds. Review the actual report and visuals/assets.
- Diagnostics must never persist raw exception payloads, answers, notes, email, identifiers or credentials. Use allowlisted categories/routes; bounded rehydration, retention, clear/disable/export, startup failure isolation, and no remote upload.
- Serialize Flutter test runners in this worktree to avoid shared compilation-cache races. Use existing test fixture queue reset/runAsync conventions.

## Tasks

- [x] 15B: inspect accounting producers and existing migrations/branches; finalize baseline/ledger/budget/checkpoint interfaces; add failing numerical, ownership, replay, late-device, reservation-expiry and legacy-client tests; implement and verify SQL plus app integration.
- [x] 16: implement testable curriculum scanner, published-bank report and CLI; check duplicate IDs/options, answer indices, prerequisite graphs, authored coverage and resolvable figures/assets; treat grade/language/length heuristics as reviewed warnings; add CI gate and tests.
- [x] 17: implement strict local diagnostics store with redacted allowlisted schema, durable bounded retention, failure/restart tests and accessible UI; integrate chained Flutter/platform/route handlers and manual export; no automatic telemetry.
- [x] Root integration: wire UI/startup/account/backup/cloud seams, inspect actual phone/browser output, version release, independent review; full analyze/tests and relevant web/native CI builds.
- [ ] Publish: PR into develop, exact-head green CI, merge, merged-source CI/deployment/actual public QA, release publisher and both durable download verification. Never main.
