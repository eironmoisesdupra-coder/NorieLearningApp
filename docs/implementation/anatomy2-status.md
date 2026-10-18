# Anatomy Lab 2.0 implementation evidence

Baseline: develop 3b614d783ef4ce78609be382d4d81882d2e3c6a8, 0.15.1+20 Preview. The original plan-only ZIP is archived unchanged under docs/wip/2026-10-18-anatomy2. Target: 0.16.0+21 Preview.

| Phase | Implemented behavior | Verified evidence | Remaining gates |
|---|---|---|---|
| A, Explorer and quizzes | Responsive controls, stable model on rotation, keyboard-safe name/ID search, source details, explicit 5/10/20 sessions, difficulty and system questions | PR #60 merged as e4d772702eb30abba4b08fb222112c8c7eece595; all three PR workflows green. Offline compiled UI, real picking, unique five-question quiz and exactly one durable 50-XP reward across two reloads pass | Final combined source validation |
| B, Guided study | Seven-step catalog identification guides, exact selected structure, resume/skip and owner-scoped local evidence; durable assistance provenance | PR #61 merged as 2cda4d5376a6134e7575585c271ebe1964620b46; all three PR workflows green. 15 guided tests and Explorer regressions pass; independent review clean | New medical lesson prose requires qualified human review |
| C, Interactions | System visibility/opacity, same-reference comparison, owner-scoped named-view bookmarks, delete/reset and JSON export | PR #62; 22 renderer tests and real offline picking/layer/comparison browser checks pass; tools/Explorer tests and analysis pass; review fixes verified | Exact-head CI and final app validation |
| D, Rendering | Demand rendering, quality profiles, bounded diagnostics, visibility/context lifecycle recovery | PR #63; 29 Node tests, browser orbit/picking/context-loss/retry/disposal, 7 Flutter tests and analysis pass; independent review clean. Raw measurements are adjacent files | Physical-device performance/touch certification remains pending |
| E, Coverage and recovery | Coverage panel, per-part inventory, provenance gate for all retained assets and 27 source inputs; fresh renderer state replay and preserved context-recovery isolation | 24 Python tests pass; actual audit reports 3,949 parts, 34 assets, 15 systems, six references, seven sources, zero critical errors and 1,009 missing source ontology labels. Final 27 focused Flutter tests, analysis and scoped recovery review pass | Combined full suite, compiled browser, web/Windows/Android CI and Preview publication pending |

## Explicit limits

Guides teach source catalog names/classifications and navigation; they are not reviewed medical lessons. No anatomy subject-matter reviewer or independently trusted approval registry is configured. All 3,949 per-part authored teaching descriptions remain missing, with zero approved records. See ../anatomy-editorial-review.md for the source-checking and editorial workflow. Existing skeleton fundamentals remain available.

Study evidence and saved views stay local to the learner on this device. The study store has no account backup/cloud integration or user-facing reset yet; saved views have explicit deletion/reset/JSON export but no import or account sync. They do not grant XP, progression or medical mastery. Existing quiz reward/account hooks remain in place.

Source/model assets, IDs, licensing and reference coordinate frames are unchanged. Alternative female, joint, gland, lymphatic and ear references retain their dataset coverage boundaries. Model-part totals are not organ or textbook structure counts. Browser measurements demonstrate reduced idle rendering, not a general FPS, load-speed, peak-memory or battery improvement.

This intermediate record does not claim a final public release. Final delivery must identify the merged source, trusted CI, durable Windows ZIP and Android APK. Preview signing remains Windows unsigned/Android debug; production signing, store publishing, support/privacy configuration and main promotion remain outside this task.
