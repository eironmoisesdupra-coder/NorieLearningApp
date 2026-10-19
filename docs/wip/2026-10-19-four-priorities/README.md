# NorieLearning — Four-Priority Codex WIP Handoff

**Baseline:** `develop` at `17a5196f3cb2cd14903cd6673930bad5390acf00` (0.16.0+21 Preview), checked October 19, 2026.

**Purpose:** implement and independently validate four agreed priorities without weakening learning outcomes, privacy, account separation, offline mode, credit economy, or publication integrity.

**Important:** This is a detailed, executable engineering brief and review package, NOT implemented app code, a tested release, or permission to merge automatically. Use the latest `develop` at start, document drift from baseline, and re-evaluate instructions against actual code. Keep `main` unchanged.

## Ordered work packages

1. **P0 / PR #65** — Stabilize 5-credit Anatomy hints, verify exact illustrated question mapping, charge once, handle insufficient credits, preserve quiz XP. PR is already open: https://github.com/eironmoisesdupra-coder/NorieLearningApp/pull/65 . Do not duplicate it.
2. **P1 / Teaching depth** — Enrich actual authored lessons progressively: child-friendly stepwise guidance for early grades and concept + multistep quantitative problem solving for higher grades.
3. **P2 / Publication approvals** — Strict server-authorized editorial review and immutable content manifests. Local Studio drafts are never authority to publish.
4. **P3 / Anatomy study backup** — Validated, owner-scoped portable Anatomy evidence/bookmarks, transactional restore and compatibility with old backups. No duplication of account rewards.

Work on isolated feature branches / PRs; do not combine risky migrations with unrelated UI styling. Follow dependencies and run regression checks. Maintain a `ROADMAP_STATUS.json` in the PR with truthful tested/merged/live states.

## Source facts verified at baseline

- PR #65 is OPEN at `f3ba515a356745fb56fa8ae00e07a8d33515a6b7`; it adds optional 5-credit hints to 20-item Atlas quizzes. Tests and merge readiness still require verification.
- `AnatomyAtlasQuizScreen`, `AtlasQuizQuestion`, `NorieProgression.spendCredits`, and the existing `NorieEconomyStore` are integration points.
- `AnatomyStudyStore` tracks learner-scoped local guided evidence; `_maxEntries = 128`, `_maxPayload = 262144`, and guided content version validation currently gate reads.
- `AnatomyAtlasBookmarkStore` saves named views locally with `maxBookmarks = 100`, `maxPerReference = 32`, `maxBytes = 64 KiB` and source reference/structure validation.
- `NorieProgressBackup` supports versions 1 and 2 and a 5 MiB size limit; it currently does not include Anatomy study/bookmark extensions.
- `CurriculumStudioStore` is a local untrusted draft/path editor with owner-specific SharedPreferences persistence, not an approved publication authority.
- The anatomy source audit lists 3,949 selectable model parts; zero approved new teaching descriptions and 1,009 missing ontology labels. Do not invent medically reviewed explanations.

## Global non-negotiable invariants

- Preserve progress, XP/credits, shop ownership, cloud ledger, badges, ranks, lesson/mastery evidence, Classroom state and offline core behavior.
- No feature may give learning or XP advantage for paying credits. Hints are optional; if they influence scoring, make assisted-vs-independent evidence explicit.
- Correct answers and question images must correspond to exact model structure ID and reference; never infer structure from string/name alone when IDs differ.
- Protect learner identity across A→B→A changes, canceled futures, logout, account deletion and concurrent save/restore.
- Do not award XP, credits or mastery during export, import, merge, replay, content preview or hint reveal.
- No `approved` content derived from a client-provided JSON field, unverified reviewer name, AI answer, model inference or imported draft.
- No medical/anatomical claims published until qualified human subject matter review with provenance and version-specific signoff.
- Never generate fake QA, signer credentials, medical editorial approval, or physical test results.
- Existing client backups, local data and legacy IDs must remain compatible; reject malformed data without destructive clearing.
- Keep any production billing or Store subscription integration separate and disabled unless explicitly approved.

## Minimum handoff from Codex per PR

Include exact source SHA, diff summary, test matrix, which tests actually ran, screenshots for 320px & 160% text, real browser/desktop evidence, schema migration & rollback plan, privacy impact, known blockers, and checklist ✅ tested + merged + live / 🟡 partial / 🔵 design / ⬜ pending.
