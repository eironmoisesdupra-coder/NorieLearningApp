# Norie Mascot Engine Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reusable, smooth Norie mascot engine that preserves the current character identity and powers tutorials, quiz reactions, AI-generation loading, contextual help, and celebrations across NorieLearning.

**Architecture:** Implement a renderer-agnostic semantic state machine (`NorieMascotController`) and a reusable app-root overlay host (`NorieMascotHost`) through `MaterialApp.builder`, so pushed lesson/quiz/anatomy/study routes share the same mascot controller. Screens emit semantic events such as `correct()`, `think()`, `celebrate()`, or `guide()`; the mascot renderer decides how those states animate. The first renderer uses Flutter-driven motion around Norie's current artwork and derived expression layers, with the API intentionally compatible with a future Rive renderer.

**Tech Stack:** Flutter/Dart, existing Norie asset pipeline, SharedPreferences for tutorial state, existing Study/AI services, Flutter AnimationController/Tween APIs, existing Norie theme and progression systems.

**Spec:** `docs/superpowers/specs/2026-09-29-norie-mascot-engine-design.md`

## Global Constraints

- Preserve the current Norie visual identity and proportions.
- Tutorials/help/search may use animation + text + optional voice.
- Normal quiz gameplay uses animation/expression only; voice must never auto-play in ordinary quizzes.
- Motion style is smooth/polished by default, with stronger celebration/scared/challenge reactions.
- First-time tutorials run automatically once per major feature and remain replayable.
- Search/help is context-aware by current screen.
- AI generation animation must not imply exact backend progress when exact progress is unavailable.
- Reduced-motion users receive fades/minimal translation instead of large movement.
- Mascot failures must never block the underlying app workflow.
- No Rive dependency is required in v1; controller/public APIs remain renderer-agnostic.

## Review Focus

- Rapid consecutive mascot events: latest high-priority reaction should not leave the controller stuck or replay stale states.
- Hidden/background app state: looping idle/thinking animation must pause when the app is not active.
- Reduced-motion enabled: transient reactions must still communicate state without bounce/squash/large translation.
- Tutorial replay after completion: replay must work without clearing the stored completion flag permanently.
- AI/help failure paths: mascot must recover to a usable state while the original screen action remains available.

---

### Task 1: Mascot state machine and semantic controller

**Files:**
- Create: `lib/core/mascot/norie_mascot_state.dart`
- Create: `lib/core/mascot/norie_mascot_controller.dart`
- Test: `test/norie_mascot_controller_test.dart`

**Interfaces:**
- Produces: `enum NorieMascotState`
- Produces: `enum NorieMascotPriority`
- Produces: `class NorieMascotEvent`
- Produces: `class NorieMascotController extends ChangeNotifier`
- Produces semantic methods: `enter()`, `exit()`, `idle()`, `guide()`, `point(String targetId)`, `think()`, `idea()`, `correct()`, `celebrate({NorieCelebrationLevel level})`, `nervous()`, `scared()`, `challengeMode()`, `searching()`, `speak(String message)`, `stopSpeaking()`, `hide()`
- Produces: `enum NorieCelebrationLevel { encouraging, standard, perfect }`

- [ ] **Step 1: Write failing controller tests**

Test names/assertions:
- `correct reaction returns to idle after transient duration`
- `high priority celebration replaces lower priority idle reaction`
- `latest queued transient event wins after current event finishes`
- `hide clears queued events and speech`
- `rapid consecutive events never leave controller in transient state`

Use `fake_async` only if it is already available; otherwise design the controller with an injectable `DurationScheduler` abstraction so tests remain deterministic without sleeping.

- [ ] **Step 2: Run the controller tests and verify RED**

Run: `flutter test test/norie_mascot_controller_test.dart`
Expected: FAIL because mascot domain/controller types do not exist.

- [ ] **Step 3: Implement the minimal semantic state machine**

Required exact transient default durations:
- correct: 700 ms
- idea: 900 ms
- nervous: 900 ms
- scared: 900 ms
- challenge: 1000 ms
- celebrate: 1600 ms

`thinking`, `guiding`, `speaking`, `searching`, `idle`, and `hidden` are persistent until replaced.

Priority order:
`hidden/exit > speaking/guide > celebrate > challenge/scared/nervous > correct/idea > thinking/searching > idle`.

- [ ] **Step 4: Run controller tests and verify GREEN**

Run: `flutter test test/norie_mascot_controller_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/mascot/norie_mascot_state.dart lib/core/mascot/norie_mascot_controller.dart test/norie_mascot_controller_test.dart
git commit -m "feat: add Norie mascot state engine"
```

### Task 2: Smooth mascot renderer with preserved Norie artwork

**Files:**
- Create: `lib/core/mascot/norie_mascot_view.dart`
- Create: `lib/core/mascot/norie_mascot_motion.dart`
- Create: `lib/core/mascot/norie_mascot_expression_painter.dart`
- Modify: `lib/core/assets/norie_assets.dart`
- Add derived assets under: `assets/mascot/rig/`
- Test: `test/norie_mascot_view_test.dart`

**Interfaces:**
- Consumes: `NorieMascotController`, `NorieMascotState`
- Produces: `NorieMascotView({required NorieMascotController controller, double size = 144, bool? reduceMotion})`
- Produces: `NorieMascotMotionSpec forState(NorieMascotState state, {required bool reduceMotion})`

- [ ] **Step 1: Write failing motion-policy/widget tests**

Assertions:
- idle state renders the base Norie asset;
- celebrating state uses the celebrating pose family;
- thinking state uses the studying pose family;
- reduced-motion specs use opacity/scale only and translation magnitude <= 4 logical px;
- a missing optional rig layer still renders a base mascot;
- renderer state changes do not replace the entire widget tree with a broken image placeholder.

- [ ] **Step 2: Run renderer tests and verify RED**

Run: `flutter test test/norie_mascot_view_test.dart`
Expected: FAIL because renderer/motion policy do not exist.

- [ ] **Step 3: Prepare derived rig assets while preserving the current character**

Create transparent derived layers from the current Norie artwork for at minimum:
- eyes/pupils;
- brows;
- mouth expressions: neutral, smile, surprised, nervous, challenge;
- optional left/right gesture overlay if separable without changing character identity.

Do not redraw the mascot into a different character. If a part cannot be separated cleanly, keep that region in the original pose PNG and animate the whole pose rather than inventing anatomy.

Update `NorieAssets` with named constants for every added layer. Add one root-level pre-cache helper used by `NorieMascotHost` to pre-cache the base, celebrating, studying, and derived high-frequency reaction assets before quiz reactions.

- [ ] **Step 4: Implement renderer and motion specs**

Motion requirements:
- idle: subtle 2–3% breathing scale + <= 4 px vertical bob;
- correct: quick anticipation + pop, total 700 ms;
- celebrate: stronger squash/stretch and bounce, total 1600 ms;
- thinking: slow head/body sway with blink/eye movement loop;
- nervous/scared: small recoil/shake, no full-screen movement;
- challenge: controlled tilt + narrowed-eye/challenge expression;
- enter/exit: edge slide + fade;
- expression transitions: `AnimatedSwitcher` or equivalent <= 180 ms.

Respect `MediaQuery.disableAnimations` unless the explicit `reduceMotion` override is supplied.

- [ ] **Step 5: Run renderer tests and verify GREEN**

Run: `flutter test test/norie_mascot_view_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/mascot lib/core/assets/norie_assets.dart assets/mascot/rig test/norie_mascot_view_test.dart
git commit -m "feat: add smooth Norie mascot renderer"
```

### Task 3: Global mascot overlay host and app context

**Files:**
- Create: `lib/core/mascot/norie_mascot_host.dart`
- Create: `lib/core/mascot/norie_app_context.dart`
- Create: `lib/core/mascot/norie_mascot_scope.dart`
- Modify: `lib/app/norie_app.dart`
- Modify: `lib/features/navigation/presentation/main_shell.dart`
- Test: `test/norie_mascot_host_test.dart`

**Interfaces:**
- Produces: `enum NorieAppArea { home, learn, challenge, progress, profile, lesson, anatomy, study, quiz, results, unknown }`
- Produces: `class NorieContextSnapshot`
- Produces: `NorieMascotScope.of(BuildContext context)`
- Produces scope methods: `setContext(NorieContextSnapshot)`, `showAssistant()`, `hideAssistant()`
- Consumes: `NorieMascotController`

- [ ] **Step 1: Write failing host/context tests**

Assertions:
- `NorieApp` contains exactly one app-root mascot host wrapping navigator content;
- a pushed route can resolve the same `NorieMascotScope` as the main shell;
- changing tabs updates `NorieAppArea` without recreating the mascot controller;
- hiding mascot does not remove the underlying `IndexedStack`;
- when app lifecycle becomes paused, persistent animation is suspended;
- when resumed, the last persistent state can continue safely.

- [ ] **Step 2: Run host tests and verify RED**

Run: `flutter test test/norie_mascot_host_test.dart`
Expected: FAIL because host/scope do not exist.

- [ ] **Step 3: Implement `NorieMascotHost` at the app root**

Wrap `MaterialApp` navigator content through `NorieApp.builder` so all pushed routes inherit the same `NorieMascotScope`. Use one controller per app session. The host owns overlay placement, safe-area positioning, assistant visibility, asset pre-caching, and lifecycle observation. `MainShell` only reports tab context; it must not own another mascot controller.

- [ ] **Step 4: Run host tests and verify GREEN**

Run: `flutter test test/norie_mascot_host_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/mascot lib/app/norie_app.dart lib/features/navigation/presentation/main_shell.dart test/norie_mascot_host_test.dart
git commit -m "feat: host Norie mascot across main navigation"
```

### Task 4: First-time tutorials with Replay Tutorial

**Files:**
- Create: `lib/core/mascot/tutorial/norie_tutorial_models.dart`
- Create: `lib/core/mascot/tutorial/norie_tutorial_store.dart`
- Create: `lib/core/mascot/tutorial/norie_tutorial_coordinator.dart`
- Create: `lib/core/mascot/tutorial/norie_tutorial_overlay.dart`
- Modify: `lib/features/home/presentation/home_screen.dart`
- Modify: `lib/features/learning/presentation/learn_screen.dart`
- Modify: `lib/features/challenge/presentation/challenge_screen.dart`
- Modify: `lib/features/learning/presentation/anatomy_lab_placeholder_screen.dart`
- Modify: `lib/features/study/presentation/study_generator_screen.dart`
- Test: `test/norie_tutorial_test.dart`

**Interfaces:**
- Produces: `NorieTutorialStep(id, targetKey, mascotState, message, preferredPosition, voiceAsset?)`
- Produces: `NorieTutorialDefinition(id, steps)`
- Produces: `Future<bool> NorieTutorialStore.isComplete(String tutorialId)`
- Produces: `Future<void> markComplete(String tutorialId)`
- Produces: `Future<void> replay(String tutorialId)` that starts the flow without deleting completion
- Consumes: `NorieMascotController`

- [ ] **Step 1: Write failing tutorial persistence/coordinator tests**

Assertions:
- incomplete tutorial auto-starts once;
- completion persists;
- completed tutorial does not auto-start again;
- replay works even when completion is already stored;
- skip marks the tutorial complete;
- missing target key falls back to centered speech/mascot rather than crashing.

- [ ] **Step 2: Run tutorial tests and verify RED**

Run: `flutter test test/norie_tutorial_test.dart`
Expected: FAIL because tutorial system does not exist.

- [ ] **Step 3: Implement store and coordinator**

Use SharedPreferences keys under:
`norie.tutorial.<tutorialId>.complete`

Initial tutorial ids:
- `home.v1`
- `learn.v1`
- `challenge.v1`
- `anatomy.v1`
- `ai-study.v1`
- `quiz.v1`

- [ ] **Step 4: Add Replay Tutorial entry points**

Use a consistent icon/menu action on each initial major feature. Replay must invoke the coordinator directly and leave the completion flag intact.

- [ ] **Step 5: Run tutorial tests and verify GREEN**

Run: `flutter test test/norie_tutorial_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/mascot/tutorial lib/features/home lib/features/learning lib/features/challenge lib/features/study test/norie_tutorial_test.dart
git commit -m "feat: add replayable Norie feature tutorials"
```

### Task 5: Quiz reactions and completion celebrations

**Files:**
- Modify: `lib/features/content/presentation/norie_quiz_screen.dart`
- Modify: `lib/features/content/presentation/norie_learning_results_screen.dart`
- Modify: `lib/features/challenge/presentation/challenge_quiz_screen.dart`
- Modify: `lib/features/challenge/presentation/challenge_results_screen.dart`
- Modify: `lib/features/study/presentation/study_quiz_screen.dart`
- Modify: `lib/features/study/presentation/study_results_screen.dart`
- Create: `lib/core/mascot/norie_quiz_reaction_policy.dart`
- Test: `test/norie_quiz_mascot_reactions_test.dart`

**Interfaces:**
- Produces: `NorieCelebrationLevel celebrationFor({required int correct, required int total})`
- Produces: `bool shouldShowDifficultyReaction({required int previousTier, required int nextTier})`
- Consumes: `NorieMascotScope.of(context).controller`

- [ ] **Step 1: Write failing reaction policy/widget tests**

Score mapping:
- accuracy < 0.60 => `encouraging`
- accuracy >= 0.60 and < 1.0 => `standard`
- perfect => `perfect`

Assertions:
- correct answer triggers `correct()`;
- incorrect answer does not trigger a celebratory reaction;
- Next remains tappable while a correct reaction plays;
- every result screen triggers one celebration;
- low score still uses an encouraging positive state, never scared/evil;
- difficulty-tier increase triggers nervous -> challenge sequence without voice.

- [ ] **Step 2: Run quiz mascot tests and verify RED**

Run: `flutter test test/norie_quiz_mascot_reactions_test.dart`
Expected: FAIL because reaction policy/integrations are missing.

- [ ] **Step 3: Implement reaction policy and wire quiz screens**

Do not await transient mascot animations from answer-check handlers. They must be fire-and-forget UI feedback so quiz controls stay responsive.

- [ ] **Step 4: Replace static result-only mascot usage where appropriate**

Existing static celebration images may remain as fallback content, but when a mascot host is present the engine owns the animated reaction.

- [ ] **Step 5: Run quiz mascot tests and verify GREEN**

Run: `flutter test test/norie_quiz_mascot_reactions_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/mascot/norie_quiz_reaction_policy.dart lib/features/content lib/features/challenge lib/features/study test/norie_quiz_mascot_reactions_test.dart
git commit -m "feat: add Norie quiz reactions and celebrations"
```

### Task 6: AI Study generation thinking sequence

**Files:**
- Create: `lib/core/mascot/norie_ai_generation_sequence.dart`
- Modify: `lib/features/study/presentation/study_generator_screen.dart`
- Test: `test/norie_ai_generation_mascot_test.dart`

**Interfaces:**
- Produces: `NorieAiGenerationSequence`
- Produces captions in deterministic order: `Reading…`, `Organizing…`, `Building questions…`
- Consumes: `NorieMascotController.think()`, `idea()`, `nervous()`, `idle()`

- [ ] **Step 1: Write failing generator mascot tests**

Assertions:
- entering `_working` starts thinking state;
- captions cycle without representing percentages;
- success triggers `idea()` before navigation;
- failure triggers a brief concerned/nervous state and returns to usable form;
- generator buttons remain disabled only by existing `_working` logic, not by mascot animation.

- [ ] **Step 2: Run generation tests and verify RED**

Run: `flutter test test/norie_ai_generation_mascot_test.dart`
Expected: FAIL because generation sequence does not exist.

- [ ] **Step 3: Implement sequence and integrate with generator**

The mascot animation is visual feedback only. Do not derive fake completion percentage from caption cycles.

- [ ] **Step 4: Run generation tests and verify GREEN**

Run: `flutter test test/norie_ai_generation_mascot_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/mascot/norie_ai_generation_sequence.dart lib/features/study/presentation/study_generator_screen.dart test/norie_ai_generation_mascot_test.dart
git commit -m "feat: animate Norie during AI study generation"
```

### Task 7: Context-aware Norie search/help assistant

**Files:**
- Create: `lib/core/mascot/help/norie_help_models.dart`
- Create: `lib/core/mascot/help/norie_help_service.dart`
- Create: `lib/core/mascot/help/norie_help_sheet.dart`
- Modify: `lib/features/learning/presentation/learn_screen.dart`
- Modify: `lib/core/mascot/norie_mascot_host.dart`
- Test: `test/norie_help_assistant_test.dart`

**Interfaces:**
- Produces: `NorieHelpRequest(text, context)`
- Produces: `NorieHelpResponse(text, quickActions, destination?)`
- Produces: `Future<NorieHelpResponse> NorieHelpService.answer(NorieHelpRequest request)`
- Consumes: `NorieContextSnapshot`
- Consumes mascot states: searching/listening through idle/speaking/thinking

- [ ] **Step 1: Write failing help-assistant tests**

Assertions:
- Learn search button opens the Norie help sheet;
- current `NorieAppArea.learn` is included in the request context;
- empty input is rejected locally;
- known app-help intents return deterministic local guidance;
- unsupported learning questions expose an action to AI Study rather than inventing an answer;
- service failure leaves navigation quick actions usable;
- closing the help sheet stops speech and returns mascot to idle.

- [ ] **Step 2: Run help tests and verify RED**

Run: `flutter test test/norie_help_assistant_test.dart`
Expected: FAIL because help assistant types/sheet do not exist.

- [ ] **Step 3: Implement v1 context-aware help service**

V1 app-help topics:
- navigation;
- Credits/XP;
- quizzes/challenges;
- Anatomy Lab;
- AI Study;
- tutorial replay.

Use deterministic local responses for app mechanics. Route actual learning-content questions toward existing AI Study/QA experiences where a source/context exists; otherwise provide a quick action to AI Study rather than fabricating domain answers.

- [ ] **Step 4: Make the Learn search control interactive**

Convert the current decorative search container into a semantic `IconButton` or equivalent 44x44 control and open `NorieHelpSheet`.

- [ ] **Step 5: Run help tests and verify GREEN**

Run: `flutter test test/norie_help_assistant_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/mascot/help lib/core/mascot/norie_mascot_host.dart lib/features/learning/presentation/learn_screen.dart test/norie_help_assistant_test.dart
git commit -m "feat: add context-aware Norie help assistant"
```

### Task 8: Optional tutorial/help voice policy

**Files:**
- Create: `lib/core/mascot/voice/norie_voice_controller.dart`
- Create: `lib/core/mascot/voice/norie_voice_policy.dart`
- Modify: `lib/core/mascot/tutorial/norie_tutorial_coordinator.dart`
- Modify: `lib/core/mascot/help/norie_help_sheet.dart`
- Test: `test/norie_voice_policy_test.dart`

**Interfaces:**
- Produces: `NorieVoicePolicy.canAutoPlay(NorieAppArea area, {required bool userEnabled})`
- Produces: `NorieVoiceController.playAsset(String assetPath)`
- Produces: `stop()`
- Produces persisted preference methods `loadEnabled()`, `setEnabled(bool)` using SharedPreferences key `norie.mascot.voiceEnabled`, default `false`
- Consumes existing audio stack; do not add a second audio package if `audioplayers` is already present.

- [ ] **Step 1: Write failing voice-policy tests**

Assertions:
- quiz => auto-play false even when userEnabled;
- tutorial => auto-play true only when userEnabled;
- help => auto-play true only when userEnabled;
- closing tutorial/help calls stop;
- missing voice asset does not block text/animation;
- voice preference defaults to disabled and persists after `setEnabled(true)`.

- [ ] **Step 2: Run voice policy tests and verify RED**

Run: `flutter test test/norie_voice_policy_test.dart`
Expected: FAIL because voice policy/controller do not exist.

- [ ] **Step 3: Implement voice controller and wire only tutorial/help**

Initial dynamic assistant answers remain text-only unless a fixed local voice asset exists. Do not add TTS in v1.

- [ ] **Step 4: Run voice tests and verify GREEN**

Run: `flutter test test/norie_voice_policy_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/mascot/voice lib/core/mascot/tutorial/norie_tutorial_coordinator.dart lib/core/mascot/help/norie_help_sheet.dart test/norie_voice_policy_test.dart
git commit -m "feat: add optional Norie tutorial and help voice"
```

### Task 9: Full integration, accessibility, and release verification

**Files:**
- Modify only files required by failures discovered during this task.
- Test: existing full suite plus all mascot tests.

**Interfaces:**
- Consumes all prior tasks.
- Produces no new product API unless a verified integration defect requires one.

- [ ] **Step 1: Add integration assertions for reduced motion and app lifecycle**

Extend the owning tests so:
- reduced motion communicates correct/celebrate states without large transforms;
- lifecycle pause stops looping animation work;
- lifecycle resume does not replay already-consumed transient events.

- [ ] **Step 2: Run full analyzer**

Run: `flutter analyze`
Expected: no issues.

- [ ] **Step 3: Run the full test suite**

Run: `flutter test`
Expected: all tests pass.

- [ ] **Step 4: Build Android release**

Run: `flutter build apk --release`
Expected: exit 0 and release APK generated.

- [ ] **Step 5: Build web release**

Run: `flutter build web --release`
Expected: exit 0 and `build/web` generated.

- [ ] **Step 6: Manual behavior checklist**

Verify on at least one mobile-sized viewport and one desktop-sized viewport:
- tutorial first-run and replay;
- correct-answer reaction remains non-blocking;
- difficulty reaction sequence;
- every results screen celebrates;
- AI generator thinking -> idea/failure transition;
- Learn search opens contextual assistant;
- reduced-motion mode;
- mascot never covers primary CTA/answer controls.

- [ ] **Step 7: Commit verification fixes only if needed**

```bash
git add <only files changed by verified integration fixes>
git commit -m "fix: harden Norie mascot integrations"
```

- [ ] **Step 8: Request whole-branch review before merge**

Use the review workflow required by the chosen execution method. Do not merge until analyzer, tests, Android build, and web build are all freshly green.
