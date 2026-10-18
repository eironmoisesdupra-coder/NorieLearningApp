# NorieLearning Anatomy Lab 2.0 — Codex Implementation WIP (#28–#33)

**Repository:** eironmoisesdupra-coder/NorieLearningApp
**Base develop SHA:** `3b614d783ef4ce78609be382d4d81882d2e3c6a8`
**Base version:** `0.15.1+20` Preview
**Status:** Implementation specification, NOT implemented, merged, tested or published by this ZIP.

## Goal
Ship six improvements to the real Anatomy Lab, through reviewed Codex PRs into `develop`, with existing offline content, XP/progress and licensing preserved. Avoid mock UI, disconnected demos or claims of physical QA from CI.

## Codex execution plan
1. Inspect current repository before editing. Compare planned features with existing implementations and do not duplicate controls.
2. Work in ordered feature branches/PRs: **A (#28+#30)**, **B (#29)**, **C (#31)**, **D (#32)**, **E (#33)**.
3. In each PR integrate navigation, UI state, model bridge and tests. Mark complete only when user can access/use the feature in compiled app.
4. Verify `flutter analyze`, full `flutter test`, anatomy viewer Node tests, Python pipeline tests, release web build, Windows offline package and Android build. Preserve existing license notices and no-runtime-download behavior.
5. Test on phone 320px at 160% text, reduced motion, keyboard and pointer/touch, no network, route transitions and loading/error retry.
6. For each PR verify exact-head and merged-source CI. Public Preview release only after owner approval, artifact provenance and public-browser verification.
7. Real physical device/performance and expert medical editorial claims stay pending until actual evidence is recorded.

## Invariants
- Preserve all 15 system categories, existing 3,949 selectable *model part* catalog (not 3,949 unique organs), source IDs, labels, reference boundaries and licenses.
- Preserve XP award semantics, idempotent claims, progress backups and cloud account ownership.
- Keep core anatomy models and essentials offline. No unlicensed or unverifiable additional anatomy assets.
- Preserve separate reference coordinate frames (do not falsely superimpose ear/gland/joint scenes on bodies).
- Human anatomical descriptions must be reviewed and cited to trustworthy sources before published; AI drafts cannot silently become medical facts.
- Female whole-body reference, lymphatic vessel networks and microscopic sensory coverage are NOT complete; clearly disclose limits.
- New content should align with planned Curriculum Library #22, Guided Learning #23 and Flexible Assessment #26 without making the feature depend on unimplemented infrastructure.

See `CODEX_TASK.md` and individual `packets/*.md`. Record exact evidence in `ROADMAP_STATUS.json` after each PR.
