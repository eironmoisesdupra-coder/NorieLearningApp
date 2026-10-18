# Anatomy Lab 2.0 implementation evidence

Source baseline: develop 3b614d783ef4ce78609be382d4d81882d2e3c6a8, 0.15.1+20 Preview. Original ZIP is plan-only and archived unchanged under docs/wip/2026-10-18-anatomy2.

| Phase | Implementation | Evidence | External gates |
|---|---|---|---|
| A ? Explorer / quizzes | Responsive controls, stable model state across rotation, keyboard-safe search, ID lookup, source details, 5/10/20 sessions, three modes and catalog system questions | 28 focused Flutter tests pass; analysis clean; independent review fixes verified | PR #60 merged as e4d772702eb30abba4b08fb222112c8c7eece595; all three PR workflows green; compiled offline UI/picking/5-question reward/reload checks pass |
| B ? Guided learning | Metadata-only seven-step guides, explicit structure entry, resume/skip and owner-scoped evidence | 15 focused guided tests and 6 Explorer regressions pass; scoped re-review clean | New medical lesson descriptions require qualified human review; local study evidence is not yet in account backup/sync |
| C ? Interactions | Per-system visibility/opacity, same-reference comparison, owner-scoped named-view bookmarks with delete/reset/JSON export | 22 Node tests and real browser interactions pass; 18 Flutter tools/Explorer tests pass; analysis clean; review fixes verified | Physical touch testing remains pending |
| D ? Performance | Demand rendering, named render-quality profiles, bounded diagnostics, visibility/context lifecycle recovery | 29 Node tests, actual browser picking/orbit/context recovery, 7 focused Flutter tests and analysis pass; renderer review clean | No physical-device FPS/memory certification |
| E ? Coverage review | Preparing per-part source/license/teaching audit and limitations panel | Source audit prototype finds no critical asset errors; runtime integration pending | Human approval cannot be replaced by automated checks |

No final release is claimed by this intermediate status. The final Preview will report exact merged source, platform build checks and durable Windows/Android URLs. Production signing, main publication and expert anatomical certification remain outside this task.
