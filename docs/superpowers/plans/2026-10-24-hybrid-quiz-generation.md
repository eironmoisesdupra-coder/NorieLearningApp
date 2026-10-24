# Hybrid Quiz Generation Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans task by task, with RED/GREEN tests and independent final review.

**Goal:** Deliver the requested first functional milestone: zero-inference native Mathematics practice within explicit coverage while keeping existing AI services and saved study progress compatible.

**Architecture:** Add pure Dart versioned generation contracts/provider/router/validator beside Study Lab. Deterministic integer arithmetic and linear equations carry exact evidence and source references; no external calls. Adapt to existing study models/store/rewards, preserve device-local decks through cloud refresh, and add version-bound in-progress session snapshots.

**Tech Stack:** Existing Flutter/Dart, SharedPreferences, existing curriculum fingerprint and UUID implementation. No dependencies or migrations.

**Spec:** User-supplied Hybrid Quiz Generation 2.0 development order; docs/HYBRID_QUIZ_BASELINE.md records actual baseline.

## Global constraints

No main writes, merges, production deployment, provider activation or credentials. No new claimed editorial approval. Native never makes billable requests. Counts5/10/20/40 exact or explicit shortage; no implicit repeats/topic/source substitution. Preserve quiz models, reward rules, Classic/Adventure/Anatomy/assets. Keep pending PR72/73/74–76 independent. User explicitly directed implementation without further design approval; use the existing Flutter architecture and PR sequence.

## Review focus

- A signed-in native deck survives a successful empty cloud refresh and failed sync.
- Switching accounts during generation/save/resume cannot expose or overwrite another learner's content.
- Same mathematical identity recreated with shuffled choices cannot farm a new reward.
- A source-bound or unsupported request never invokes an external provider or becomes unrelated practice.
- Interrupted storage cannot invent success or erase an existing study cache/session.

### Task1: Contract, validation and native engine

Files: domain/quiz_generation contracts; data/quiz_generation native provider/router/validator/bank repository; test/hybrid_quiz_generation_test.dart.
Consumes: NorieStudyQuestion and curriculumFingerprint. Produces: QuizGenerationRequest/Result, QuizGenerationProvider, NativeQuizProvider, HybridQuizRouter.
- [ ] Write and run RED tests for seeded exact counts/answers, cancellation, source/language/difficulty/grade/format constraints, canonical duplicate detection, shortage, bank trust and no unauthorized inference.
- [ ] Implement minimal pure Dart contracts, deterministic proof checking, approved-bank boundary and local-only router.
- [ ] Run targeted GREEN tests, analyzer and meaningful golden mathematical checks.

### Task2: Persistence and native practice UI

Files: NorieStudySet additive metadata; native repository; NorieStudyService refresh/delete/sync preservation; native generator screen reached from existing generator; quiz-session store/screen; tutorial; test/native_study_generation_test.dart and widget tests.
Consumes: Task1 validated results. Produces: durable owner-isolated native decks, visible offline generator and quiz resume with unchanged rewards.
- [ ] Write and run RED tests for native create/reload/delete, old JSON compatibility, empty cloud refresh, no native upload, duplicate rewards, account change and resumed quiz state.
- [ ] Integrate local generation/save, clear coverage and free mode controls, preserve source AI route and tutorial.
- [ ] Run targeted GREEN tests, whole Flutter tests, analysis, web build, relevant Node tests; report host restrictions precisely.

### Task3: Independent review and delivery

- [ ] Request fresh read-only code review; reproduce substantive findings RED/GREEN.
- [ ] Publish focused draft PRs into develop using exact-tree commits; inspect exact-head CI and platform artifacts.
- [ ] Record source SHAs, file list, coverage, validation evidence, pending Chemistry/provider/billing work, Android/Windows links and preview-only status. No merge.

Pre-flight: Task2 consumes Task1 study-question-compatible validated result; retain exact existing answer strings and additive metadata. Task3 reviews both. No conflicting interfaces.
