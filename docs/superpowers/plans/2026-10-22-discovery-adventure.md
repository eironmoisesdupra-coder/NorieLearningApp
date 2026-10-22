# Discovery Adventure MVP implementation plan

> **For agentic workers:** Use superpowers:executing-plans to implement this plan task by task. Preserve the entire MVP scope until all evidence exists.

**Execution record:** Tasks 1 through 5 below were executed and verified at `07627da38a7f8bc22c20ef29fe6ffa79b53969ce`; see [requirement evidence and limits](../../implementation/discovery-adventure.md). The 0.17.0+23 packaging follow-up requires its own exact-head CI, recorded in PR #70. The owner has approved Preview publication after exact-head and merged-source validation; external learner/device reviews remain pending.

**Goal:** Deliver the archive's first playable Vanishing Water investigation inside NorieLearning.
**Architecture:** A deterministic mission model drives a learner-scoped serialized store and an accessible Flutter room/list presentation. A single persistence envelope contains mission and journal state; it never writes course mastery, reward receipts, XP or credits. The screen uses event-driven movement and existing frame-based Norie assets, with no idle game loop.
**Tech stack:** Existing Flutter/Dart, SharedPreferences, existing identity and mascot services. No new runtime dependency.
**Spec:** `docs/wip/2026-10-22-discovery-adventure/README.md`, `CODEX_TASK.md`, `docs/MISSION_SCRIPT.md` and original domain/tests in that archive directory. The user confirmed this archive and requested implementation.

## Global constraints
- Preserve all existing Learn, map, quiz, XP, seasonal and Anatomy systems; no main changes.
- Experimental, ungraded pilot recommended for Grades 4–6, pending teacher review. G5 Water Cycle already teaches evaporation; offer a reference to it without claiming this case fulfills its whole curriculum.
- Three observations, both controlled trials, correct hypothesis with evidence, and independent transfer are mandatory. Assistance remains distinct from independent application.
- Five accessible props; four-direction keyboard/touch movement; equal-capability list alternative; no pixel hunting or required drag.
- Conceptual warm/cool illustration, never calibrated physics; same amount, time, exposure, airflow, humidity and surface area. Dry table supports but does not prove absence of a spill.
- Owner/generation guards including A→B→A; validated save/resume and recoverable failure UX. Journal is idempotent per mission/revision. No reward writes or notification permissions.
- 320px, 160% text, keyboard-only, touch, reduced motion, inactivity, offline/reload, Windows package and Android physical when available; no invented device or efficacy certification.
- No automatic publication. Reviewable PR into develop, exact-head green CI, independent visual review and explicit release-owner approval before promotion.

## Review focus
- Pending A save during A→B→A must not replace current data or journal.
- Malformed/future-stage saves must not silently create completion. Arbitrary device-local tampering cannot be cryptographically prevented by an offline client: do not claim trusted mastery or tamper-proof journal evidence.
- Hint exposure cannot become independent evidence through reload/replay; independent transfer must use an unrevealed task.
- Lost focus, held keys, navigation, reduced motion and absent storage must not leave movement/ticks running or trap the learner.
- Reset/replay, failed writes and duplicate callbacks must preserve one journal entry and zero reward mutations.

### Task 1: State and teaching contract
**Files:** `lib/features/discovery/domain/discovery_mission.dart`, `test/discovery_mission_test.dart`.
**Produces:** immutable `DiscoveryMissionState`, stage/clue enums, guarded transitions and strict versioned JSON parsing.
- [x] Adapt archive tests and add regressions for mutable clue aliases, premature future evidence, schema types, duplicates/unknown keys, all legal stage round trips and all invalid transitions. Observe failures against the original prototype.
- [x] Harden construction/restore; add typed hypothesis/evidence and assisted/independent application semantics without public setters that bypass guards.
- [x] Run `flutter test --no-pub test/discovery_mission_test.dart`, expected all pass; commit focused domain change.

### Task 2: Learner-scoped persistence and journal
**Files:** `lib/features/discovery/data/discovery_store.dart`, `test/discovery_store_test.dart`.
**Consumes:** Task 1 state. **Produces:** ChangeNotifier store with initialize, guarded action dispatch, retry, reset and journal; injectable read/write and owner Listenable for deterministic failure tests.
- [x] Write failing tests for serialized writes, A→B→A, delayed load/save, cancelled route, corrupt/oversized saves, no storage, retry, duplicate completion and preserving journal on replay.
- [x] Implement one versioned envelope and per-owner queues using existing identity capture pattern, zero economy imports. Validate before mutation; retain recoverable corruption evidence rather than silently overwriting it.
- [x] Run `flutter test --no-pub test/discovery_store_test.dart test/discovery_mission_test.dart`, expected all pass; commit.

### Task 3: Room, controls and companion
**Files:** `lib/features/discovery/presentation/discovery_screen.dart`, `discovery_room.dart`, `discovery_experiment.dart`, `discovery_dialogue.dart`, `test/discovery_screen_test.dart`.
**Consumes:** Store from Task 2. **Produces:** fully playable one-room scene and capability-equivalent list mode.
- [x] Write failing widget tests for five props, same keyboard/touch actions, proximity/tap inspection, gated progression, both trials, evidence selection and independent application; unreachable content must fail tests.
- [x] Implement original code-drawn Explorer, scene and touch controls with keyboard focus; event-driven movement and route/focus cancellation. Reuse full-body Norie assets; skip dialogue and silent mode are optional, never skip learning gates.
- [x] Implement readable controlled comparison and notebook/journal, retry/corruption recovery, helpful incorrect feedback. Respect text scale/reduced motion. No high-frequency idle timer.
- [x] Run targeted widget/store/domain tests at 320px and 160% text; expected all pass, no overflow; commit.

### Task 4: App integration and regression checks
**Files:** `lib/features/learning/presentation/learn_screen.dart`, existing app/desktop smoke tests as needed.
- [x] Add failing navigation test; expose optional Discovery Adventure under Activities with experimental/ungraded label, without recording ordinary lesson completion or rewarding entry.
- [x] Integrate the route and owned store lifecycle; confirm existing activities stay reachable.
- [x] Run formatter, `flutter analyze`, full `flutter test`, web build and Android build; investigate failures before claiming completion. Open/update focused PR into develop.

### Task 5: Actual rendering, review and handoff
- [x] Inspect compiled web at 320/390px, 100/160% text, keyboard-only/touch/list, reduced motion, no outbound network, reload and route-inactivity; exercise full completion, retry/reset/journal/reward invariants.
- [x] Run packaged Windows checks and web/Windows/store-preflight CI at exact head. Physical Android and consented learner/teacher pilot need actual external evidence, not inferred success.
- [x] Request independent code and visual review; fix important findings with observed regression failures then rerun affected checks.
- [x] Record each requirement's evidence and remaining external gates. Keep goal active if any required implementation or verification is missing. No automatic merge/release; request owner approval only with a concrete verified candidate. Any release handoff includes both PC and Android links with real revisions, or labels prior builds accurately.

## Remaining publication and external gates
- [x] Obtain the owner?s explicit Preview publication decision required by the supplied brief: approved after latest-head and merged-source checks, final review, web verification and checksum validation.
- [ ] After approval, integrate through develop, verify the merged revision and publish both versioned Preview packages using the existing exact-SHA pipeline.
- [ ] Perform physical Android QA and qualified teacher/consented learner pilot; no certification or efficacy claim before evidence.

Ruling: the late browser denied-write probe exposed SharedPreferences optimistic-cache reuse. Reload durable platform values before Discovery reads; four real-adapter RED/GREEN regressions supplement injected store tests. Record final current-head checks and publication evidence in PR #70; previous normal-path checks do not prove storage-failure handling.
