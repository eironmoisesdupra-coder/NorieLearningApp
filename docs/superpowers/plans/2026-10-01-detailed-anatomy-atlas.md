# Detailed Anatomy Atlas Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement this plan task by task. Preserve the approved design and record decisions below.

**Goal:** Deliver all fifteen interactive anatomy categories offline on PC and Android, with male and female reproductive study scenes.

**Architecture:** A versioned mesh catalog connects the existing Flutter learning screens to a bundled Three.js renderer. Source conversion produces locally served assets, with source-specific reference scenes and stable anatomical IDs.

**Tech stack:** Flutter/Dart, Three.js, web iframe and Android WebView adapters, Python asset conversion, Node asset bundling and browser tests.

**Spec:** ../specs/2026-10-01-detailed-anatomy-atlas-design.md (approved by user).

## Global constraints

- Work from develop; preserve the existing calibrated skeleton and learning hooks.
- Installed PC and Android exploration and quizzes must work without networking.
- All 15 categories require real selectable geometry; no silent drawn fallback.
- Record source/version/license/checksum and actual modeled coverage.
- Never merge main; promote through a green develop PR and provide both downloads.

## Review focus

Rapid layer changes must not reintroduce stale geometry. Dragging must not count as selecting. Hidden meshes must not remain pickable. Quiz targets must not leak names through labels or search. Empty/missing assets must display a recoverable error rather than falsely reporting readiness.

## Task 1: Reproducible mesh library

Files: scripts/anatomy/*, scripts/anatomy/sources.json, assets/anatomy/ATTRIBUTION.md, test/anatomy_pipeline_test.py.

Interface: catalog schemaVersion=1, references with IDs and labels; structures with id, name, systems, reference, mesh IDs, bounds and source; assets with local filenames and checksums.

- [x] Write failing tests for source integrity, duplicate IDs, missing geometry, empty systems and bounds.
- [x] Fetch official BodyParts3D and versioned HRA sources, record checksums and license evidence.
- [x] Convert geometry into optimized per-system files; preserve source coordinates and ontology mapping.
- [x] Validate every distributed mesh and publish an actual coverage inventory.
- [x] Run pipeline tests and commit the reproducible source manifest and conversion code.

## Task 2: Shared interactive renderer

Files: anatomy_viewer/package.json, src/state.mjs, src/scene.mjs, src/bridge.mjs, src/index.html, test/*.test.mjs.

Interface: commands {version:1, session, type, payload}; events ready, selected, loaded, error; commands configure, select, focus, hide, isolate, restore, opacity, camera, dispose.

- [x] Test layer toggling, stale asynchronous loads and hidden picking; dispose scene resources on view closure.
- [x] Implement local GLB loading, stable mesh mapping, raycast selection, highlight and camera controls.
- [x] Implement focus, hide/isolate/restore, opacity and standard views without resetting selection unexpectedly.
- [x] Bundle all code and decoders; reject external asset URLs and malformed bridge messages.
- [x] Run renderer tests and real WebGL browser tests with outbound networking blocked.

## Task 3: Flutter atlas integration

Files: lib/features/learning/domain/anatomy_atlas_*.dart, presentation/anatomy_atlas_*.dart; modify anatomy_lab_placeholder_screen.dart; test/anatomy_atlas_test.dart.

Interface: AnatomyAtlasCatalog loaded from bundled JSON; AnatomyAtlasView takes selected systems/reference and structured commands, emits selected structure IDs and load/error status.

- [x] Test catalog search/reference boundaries and invalid input; exercise all 15 categories and reference changes in a real browser.
- [x] Implement conditional web/native adapters with source/session validation and lifecycle cleanup.
- [x] Connect existing lab navigation to detailed atlas, preserving access to calibrated skeleton study.
- [x] Add searchable structure browser, information panel, layer controls and source credits in the Norie theme.
- [x] Verify small-screen layouts and actual browser pointer/touch interactions.

## Task 4: Atlas study quizzes

Files: domain/anatomy_atlas_quiz_policy.dart, presentation/anatomy_atlas_quiz_screen.dart; test/anatomy_atlas_quiz_test.dart.

- [x] Write failing tests for eligible renderable targets, answer concealment, reference isolation and reward idempotence.
- [x] Generate offline identification questions from mapped geometry; retain curated function/description questions.
- [x] Connect existing progression APIs and verify a completed quiz updates local progress once.
- [x] Test target rendering, answer feedback and repeat navigation without answer leakage.

## Task 5: Offline packages and promotion

Files: scripts/fetch_anatomy_assets.sh, .github/workflows/{flutter-ci,deploy-pages,windows-desktop}.yml, branding/web/norie-sw.js, desktop/test/offline-app.cjs, relevant build documentation.

- [x] Integrate deterministic renderer/model builds into every package path and offline cache inventory.
- [x] Run flutter analyze, flutter test, renderer/pipeline/cache tests and a release web build.
- [ ] Validate a packaged Windows atlas and quiz with networking disabled; build Android release in CI.
- [x] Request independent whole-branch review, fix substantive findings and rerun affected checks.
- [ ] Open PR into develop, verify green CI, merge and verify preview revision.
- [ ] Supply Windows and Android download links with exact build revision and documented coverage limits.

## Execution ledger

- Baseline: develop be523e3256139713225c3f815b24e495d1e26565; feature/detailed-offline-anatomy-atlas.
- User approved the written design and instructed proceeding. Implement in this session; preserve the existing local AGENTS.md download-link addition.
- Source research: BodyParts3D metadata has 2,234 distinct mesh IDs; HRA female united v1.10 includes mapped vagina, bilateral uterine tubes/ovaries, uterus and supporting ligaments. Actual mesh validation remains required.

- Implemented: 3,312 selectable parts; 2,217 BodyParts3D male parts, 923 HRA female parts, 158 Z-Anatomy lymph-node/organ parts, and 14 SPL ear parts. The detail sources remain separate coordinate references. Full geometry inventory and source boundaries are in docs/anatomy-atlas-coverage.md.
- Source manifest pins 24 downloaded files by URL, bytes and SHA-256. All 31 generated GLBs are validated for selectable geometry. Original notices and adapted-model licenses are bundled and readable through Sources and coverage.
- Renderer supports raycast selection, orbit/zoom/pan, search, focus, hide/isolate/restore, opacity and anatomical camera views. The original calibrated skeleton is available as Skeleton fundamentals. Quiz targets render locally; curated function/description practice remains accessible.
- Independent review fixed hidden-search reveal, pending-load focus and drag-return selection. Corrected SPL RAS conversion so anterior faces the front camera. Browser regressions cover all those paths with external networking blocked.
- Windows accessibility investigation traced blocked pointer events to Flutter Material Slider's full-screen value-indicator semantics leaf. Replaced the atlas opacity slider with a percentage selector. Actual packaged mouse picking now passes with accessibility enabled, without forcing pointer events through overlays.
- Verification so far: flutter analyze clean; 132 Flutter tests, 6 Python pipeline tests, 5 renderer state tests, 5 service-worker tests and 4 desktop boundary tests pass. Release web build and Windows packaging pass. Full offline quiz/persistence test and CI promotion remain in progress.
- Packaged Windows test confirms actual mouse raycast picking with accessibility enabled. At 390x844, all ten atlas questions render/answer offline and award exactly 100 XP once; the selected model retains a usable viewport.
- Full packaged Windows cold-start suite passed: atlas search/isolation/actual raycast, phone-sized ten-question atlas quiz with exactly-once XP, existing lesson/20-item quiz/three challenge rounds, and persisted XP after app restart. No runtime page errors. Android release and remote CI are the remaining validation gates.
