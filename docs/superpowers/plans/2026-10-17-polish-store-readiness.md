# 0.13 Polish and Store Readiness Implementation Plan

> **For agentic workers:** Use superpowers:subagent-driven-development for independent tasks; root owns Flutter runner and release integration.

**Goal:** Implement the supplied 0.13-to-store WIP as working preview polish and truthful release tooling, preserving offline learning.
**Architecture:** Extend existing Flutter Learn/Classroom/mentor/seasonal UI and existing release checks. Keep evidence validation separate from external store readiness; reuse 0.12 signing/certification controls.
**Tech Stack:** Flutter/Dart, Python stdlib, Electron/Node, GitHub Actions.
**Spec:** User-supplied NorieLearning-WIP-0.13-to-store-ready-2026-10-17.zip README and implementation documents, manually inspected (installer never run).

## Global constraints
- Baseline develop 6364ff7c043a465653e13cc8108a4be08ee3b312; branch feat/polish-store-readiness in existing isolated NorieLearning-integrate.
- Version 0.13.0+17 Preview. Preserve lessons, account/ownership guards, XP/mastery, mascot frames, anatomy paths/assets/licenses, tutorials and phone accessibility.
- No production credentials available. User confirms public support/privacy details unavailable: keep gates pending. Never invent contact/legal declarations, certification or production readiness; no store submission.
- All Flutter tests/builds serialized by root; agents may run Python or standalone Dart tools. Root owns all workflow edits/version/release integration.

## Review focus
- Malformed/missing/duplicate store gates or forged pass without actual evidence must reject; pending external gates remain visible without hiding schema errors in CI.
- LAN errors must not assert a diagnosed firewall/different network or ended session when transport cannot know; saved-result retries reuse the same durable ID.
- Learn regrouping retains live tutorial targets, all destinations, resume guards and lazy-scroll accessibility at 320px/160% text.
- Asset audit excludes development dependencies/symlinks and reports exact artifact SHA/bytes, duplicate candidates and explicit not-measured states; preserve every offline asset.
- No invented attendance, traits, trends or completion. Counts and advice derive from current learner/session evidence.

## Task 1: Store readiness controls (independent)
Files: tool/store_readiness*.dart, store/*, test/store_readiness_tools_test.py, docs/implementation/store-ready.md.
- [x] Add failing CLI cases for invalid JSON/root, exact required gate set, duplicate/unknown IDs, required=false bypass, invalid statuses, pass without bounded evidence.
- [x] Implement strict reusable validator plus CLI modes: --check-schema accepts well-formed pending manifest and reports blockers; default/--require-ready rejects pending. Invalid schema always nonzero. Produce optional JSON report. No implicit certification.
- [x] Add honest store templates/checklist and source/evidence requirements; preserve external statuses not_tested; test standalone tool.

## Task 2: Asset and artifact audit (independent)
Files: scripts/release/asset_budget.py, scripts/release/package-budgets.json, test/asset_budget_test.py, docs/implementation/package-optimization.md.
- [x] Add meaningful failing tests for exclusions/symlinks/duplicate content, missing/empty artifacts, exact hash/byte accounting, budget boundaries and deterministic reports.
- [x] Implement source inventory of actual offline assets, duplicate candidates (not automatic deletions), artifact SHA/size, baseline-reviewed soft limits (240 MiB Android, 330 MiB Windows from WIP), explicit unmeasured report, violations visible always and enforcement with --fail-on-growth.
- [x] Measure local source assets and published 0.12 metadata baseline; document real measurements and safe optimization candidates; no asset removal or deferred network requirement.

## Task 3: Learn / mentor / dashboard / seasonal polish (independent)
Files: learn_screen.dart and modular helpers, existing mentor/dashboard/seasonal presentation, focused test/norie_polish_navigation_test.dart and related widgets.
- [x] Add behavior tests before changes; root runs Flutter tests on request.
- [x] Group Learn into Continue Learning, Subjects, Activities, Study Tools, Classroom with compact section navigation rather than another flat list. Keep all routes/tutorial IDs, use actual resume/progress evidence, no fake progress bars or generic coming-soon tiles masquerading as lessons.
- [x] Preserve existing evidence-based mentor policy; improve dashboard next-action clarity and seasonal bounded identity using existing widgets/theme without new assets or reward mutations.
- [x] Test all sections/destinations and 320px/160% text; report root-needed harness adaptations.

## Task 4: Classroom QR and recovery (root)
Files: LAN presentation and typed client error metadata, focused connection-copy/widget/transport tests.
- [x] Test typed 401/409/429/503 and unknown transport errors, retained saved result/duplicate ACK, QR-first layouts and current-session summaries.
- [x] Add actionable copy from WIP through typed transport exceptions (no fragile arbitrary error string matching); preserve format/ownership/content-validation messages. Retry explicit last action, no repeated automatic submissions.
- [x] Put QR and temporary code first, manual address in accessible fallback; expose current shared assignment list/session/result counts. Count only provable session connections if implemented, never attendance.

## Task 5: Integration / release (root)
- [x] Add nonpublishing store-readiness workflow with strict schema validation (no || true), report upload and external blockers. Wire exact APK/Windows ZIP audit into existing build jobs and artifact reports; preserve signing protections.
- [x] Review future AAB/MSIX path against existing signing architecture. Add only a safe tested build path where feasible; real production signing/store identity remains external. Document exact prerequisites rather than claim store-ready.
- [x] Bump 0.13.0+17 Preview; full analyze/tests, web build/Windows packaging, actual browser/packaged regressions and independent code review.
- [ ] Focused canonical commits, PR develop, green exact-head CI, merge, green merged-source CI/web, durable dual-platform Preview release; verify exact SHA/digests/URLs and final download page.

## Execution ledger
- Archive inspected in memory; no installer or pycache executed. Older readiness/mentor/seasonal branches searched; useful implementations already on current develop. Clean isolated worktree reused; original checkout untouched.
- Ruling: request to implement supplied WIP authorizes its concrete integration; no repeated design permission needed under working agreement. Public legal/support data and production credentials remain pending rather than inferred.

- Local verification complete: flutter analyze clean; 762 Flutter tests passed (one packaged interop test intentionally skipped then passed separately); release web build and Windows Electron packaging passed. Actual browser Classroom/seasonal, five Learn groups and 320px screenshots checked. Packaged Electron teacher/native Dart learner exchange passed, including durable duplicate/reconnect retry and unchanged XP. 35 Node/web-shell tests and 42 release/asset/AAB Python tests passed (one Windows symlink privilege skip); store CLI suite passed with its symlink privilege skip. Independent review found no remaining P1/P2 issues. All thirteen store gates remain pending. Android APK/AAB and exact platform budgets require CI; publication tracked in PR/release.
