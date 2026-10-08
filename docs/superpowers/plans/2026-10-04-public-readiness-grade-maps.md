# Public Readiness and Grade Maps Implementation Plan

> For agentic workers: use executing-plans for the integration work and dispatching-parallel-agents for independent readiness tasks. User authorized implementation of readiness followed by grade maps.

Goal: make the published app easier to update, resume, recover, and install, then deliver illustrated Science maps for every grade using existing curriculum and progress.

Architecture: extend Flutter progression and existing cloud state without replacing its reward policy. Keep update controls in the web shell, introduce a modular progress backup/resume layer, and derive maps and grade trophies from persistent completion IDs. Preserve local-first guest use and private-demo account restrictions.

Tech stack: Flutter, SharedPreferences, existing Supabase account hooks, browser service worker, Node workflow tests, GitHub Actions.

Spec: ../../ideas/game-progression-leaderboards-blueprint.md

## Global constraints

- Work from develop 38b634c in the isolated launch worktree; preserve both original dirty checkouts.
- Keep core lessons, anatomy, fonts, music, and mascots offline with attribution intact.
- No leaderboard, new difficulty policy, or competitive reward implementation in this release.
- Retain open lesson access; map recommends order without newly locking existing learning.
- Backups contain learning data only, never credentials; validate before applying and clearly confirm replacement.
- Cloud access remains gated until its public-account/privacy policy is separately established; clearly report this release limitation.

## Review focus

- Old service workers must discover an update without deleting saved progress or reloading an active quiz automatically.
- Resume and grade maps must handle migrated, missing, and completed topic IDs.
- Backup validation must reject malformed data before mutating learner state and preserve account boundaries.
- Small phones and large text must retain access to lesson actions and the map/list toggle.
- Existing XP and first-completion rewards must not duplicate through reopening maps or restoring progress.

## Readiness work

- [x] Web update module and tests: explicit Check for updates, version, staged update/reload prompt, no automatic reload, offline-safe worker update checks.
- [x] Release downloads: durable public download page and tag-triggered tested release workflow for APK/Windows, installation/version instructions and honest signing status.
- [x] Real resume: persist last topic and reading offset, replace static home progress, include state in backup/cloud export, test restored and missing topic handling.
- [x] Recovery and status: validated versioned JSON learning backup export/import, sync visibility/retry, account-switch safety review, tests for invalid backups and roundtrip.
- [x] First use: short optional welcome guidance with full guide on demand; preserve existing tutorial tests and manual help.
- [x] Content readiness: complete College Science pack under existing curriculum rules, audit remaining subject starter content and label honestly.
- [x] Readiness report: verified tests/builds and explicit remaining public-account/privacy/signing/device-validation limits.

## Grade map work after readiness

- [x] Derived grade-map model with current/completed/available nodes, tests for no progress and migrated completion.
- [x] Original illustrated winding Science trail, 5 actual lesson nodes per grade/course, responsive list alternative, resume current position and lesson details.
- [x] Profile grade completion shelf derived from saved IDs; no new XP award or duplicate economy transactions. Clearly show sync/local state.
- [x] Widget coverage at small width and large text; browser render and offline resume checks.

## Verification and publication

- [x] Baseline and final flutter analyze/test; targeted Node/service worker, backup, resume, map and curriculum tests.
- [ ] Release web build and actual desktop/phone browser inspection; APK and Windows offline CI.
- [ ] Fresh integration review, focused commits, PR to develop, green CI, merge and verify Pages SHA.
- [ ] Supply both platform downloads with exact revision; never push main.

## Execution ledger

- Initial inspection: existing grade pages permit all lessons; preserve access. Home resume card has fixed topic and 72 percent. Existing cloud sync is last-write-wins and private-demo gated. Public rollout must not silently remove that gate.

- Integration 2026-10-08: imported updated ZIP into feat/verified-readiness-adventure; fixed actual small-screen, restore/sync and multi-tab issues. All401 Flutter tests and analysis pass; real browser map, backup and two-tab update/offline checks pass. Public preview limitations remain documented. CI/publication pending.
