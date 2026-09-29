# Norie Mascot Engine — Design Specification

Date: 2026-09-29
Status: Proposed for implementation
Baseline: main @ 79a136d68e541e7e4c739d60b71d41f1dd73a328

## 1. Purpose

Create a reusable 2D Norie mascot animation system that preserves the existing character design while giving Norie smooth, game-like movement and contextual reactions across the app.

The mascot should feel alive and expressive without interrupting learning. Tutorial/help contexts may use animation + text + optional voice. Normal quiz gameplay should use animation only.

## 2. User Experience Goals

Norie should:

- preserve the current visual identity and proportions of the existing mascot;
- move smoothly instead of swapping abruptly between static PNGs;
- appear only when useful;
- react quickly without blocking quiz input;
- guide first-time users through major features;
- allow tutorials to be replayed manually;
- provide context-aware help from the search/help entry point;
- visibly “work” while AI study content is being generated;
- celebrate quiz completion every time;
- react to correct answers and higher quiz difficulty;
- support reduced-motion accessibility.

## 3. Confirmed Product Decisions

### Communication policy

- Tutorials/help/search: animation + speech bubble + optional voice.
- Normal quiz gameplay: animation/expression only.
- AI generation/loading: animation only by default.
- Voice must never auto-play during ordinary quiz gameplay.

### Motion style

Hybrid motion style:
- default movement is smooth and polished;
- celebration, scared, challenge/evil, and correct-answer reactions may be exaggerated.

### Tutorial policy

- first-time tutorial is automatic for each major feature;
- each tutorial has a Replay Tutorial option;
- no repeated forced tutorial after completion.

### Search/help scope

Context-aware hybrid assistant:
- Home: app/navigation help;
- lesson screen: lesson/topic help;
- Anatomy Lab: anatomy help;
- AI Study: source/study-set help;
- elsewhere: general app support.

## 4. Architecture

The mascot is implemented as one reusable engine rather than screen-specific animation code.

Primary components:

### NorieMascotController

Owns the mascot state machine and exposes semantic commands such as:

- enter()
- exit()
- idle()
- guide()
- point(target)
- think()
- idea()
- correct()
- celebrate()
- nervous()
- scared()
- challengeMode()
- speak(message)
- stopSpeaking()

Screens trigger semantic actions; they do not directly manipulate animation controllers.

### NorieMascotState

Initial state set:

- hidden
- entering
- idle
- guiding
- pointing
- speaking
- thinking
- idea
- correct
- celebrating
- nervous
- scared
- challenge
- searching
- exiting

Transient states automatically return to idle unless another state is queued.

### NorieMascotView

Reusable visual widget responsible for:

- rendering mascot layers;
- applying transforms;
- face/eye direction;
- body motion;
- expression blending;
- glow and lightweight particles;
- entrance/exit movement;
- reduced-motion behavior.

The first implementation should use a layered Flutter rig while preserving the existing Norie design. The public controller API must remain renderer-agnostic so a future Rive rig can replace the renderer without changing screen integrations.

### NorieMascotOverlay

An overlay host that allows Norie to appear above existing screens without forcing each screen to redesign its layout.

Responsibilities:
- anchor mascot to screen edges or tutorial targets;
- avoid covering answer choices/buttons;
- host speech bubbles;
- dismiss or minimize on demand;
- handle safe-area and mobile/desktop positioning.

### NorieTutorialCoordinator

Coordinates multi-step tutorials.

A tutorial step contains:
- stable step id;
- screen target key;
- mascot pose/state;
- message;
- optional voice line;
- preferred mascot position;
- next/skip behavior.

Tutorial completion is persisted through NorieProgression or a dedicated local preference store.

### NorieHelpAssistant

Opened from the search/help button.

Responsibilities:
- receives current screen context;
- presents Norie with a help panel;
- answers app-help questions;
- routes learning questions to existing AI study/help services where appropriate;
- displays quick actions relevant to the current screen.

This feature must reuse existing AI/backend infrastructure where possible rather than introducing a separate AI stack.

## 5. Rig Design

The existing mascot images remain the visual reference.

For smooth motion, Norie should be split into independently animated logical parts:

- body/core;
- head;
- left/right eye;
- pupils;
- eyebrows;
- mouth/expression layer;
- left/right arm or hand;
- optional accessory/glow layer;
- shadow.

Where the current artwork does not contain separable parts, new derived assets should be created to match the existing mascot as closely as possible.

The rig should support:
- blink;
- eye tracking;
- head tilt;
- breathing/idle bob;
- arm gesture;
- squash/stretch;
- anticipation/recoil;
- expression changes;
- enter/exit movement.

## 6. Trigger Integration

### Tutorial

On first entry to a major feature:
1. screen reports tutorial context;
2. tutorial coordinator checks completion state;
3. Norie enters;
4. each step highlights a target and plays the matching guide/point/speak state;
5. completion is persisted;
6. Replay Tutorial remains available.

Initial tutorial targets:
- Home/navigation;
- Learn;
- quizzes;
- AI Study generator;
- Anatomy Lab;
- Challenges.

### Correct quiz answer

When an answer is confirmed correct:
- trigger a short correct reaction;
- duration target: about 500–900 ms;
- no voice;
- must not block Next or other quiz controls.

### Difficulty increase

When a quiz enters a higher difficulty tier:
- trigger nervous/scared anticipation;
- optionally transition into a playful challenge expression;
- do not describe the mascot as threatening;
- no voice during active quiz.

### Quiz completion

Every quiz/results flow triggers celebrate().
Celebration may scale based on score:
- low score: encouraging happy reaction;
- medium score: normal celebration;
- high/perfect score: full celebration.

The reaction is celebratory and must not shame low scores.

### AI generation/loading

When StudyGeneratorScreen enters working state:
1. mascot appears in thinking/work mode;
2. loop uses several subtle actions instead of one frozen spinner;
3. optional cycling captions: “Reading…”, “Organizing…”, “Building questions…”;
4. on success: idea/result-ready transition;
5. on failure: concerned/helpful expression, then return to form.

Generation animation must never imply exact backend progress when exact progress is unavailable.

### Search/help

The existing Learn search control becomes a real action.
When pressed:
1. Norie pops into the help panel;
2. current app context is passed in;
3. user can ask a question or tap quick actions;
4. Norie uses speaking/listening/thinking animation states;
5. optional voice applies only inside this assistant/tutorial context.

The same global assistant entry should later be available from other major screens.

## 7. Voice

Voice is optional and user-controlled.

Rules:
- default off unless explicitly enabled in settings/tutorial;
- never auto-play in quizzes;
- stop immediately when the assistant/tutorial closes;
- subtitles/text bubble always remain available;
- voice playback must not be required to understand any tutorial.

Initial implementation may use pre-generated voice clips for fixed tutorial lines. Dynamic text answers should not require TTS in v1.

## 8. Performance

Targets:
- no continuous full-screen animation when mascot is hidden;
- pause mascot loops when app is backgrounded;
- lightweight transforms preferred over large frame-by-frame sprites;
- pre-cache required mascot assets before high-frequency quiz reactions;
- avoid creating a separate AnimationController per screen.

## 9. Accessibility

- respect MediaQuery disableAnimations / reduced-motion preference;
- reduced-motion mode uses fades and minimal translation;
- speech bubbles remain readable without voice;
- tutorial targets remain keyboard/focus accessible on desktop/web;
- mascot must not cover primary controls;
- user can skip any tutorial.

## 10. Error Handling

If a mascot asset fails:
- preserve screen functionality;
- show no broken-image placeholder;
- fall back to a static base mascot where appropriate.

If assistant AI fails:
- Norie displays a concise service-unavailable state;
- app navigation/help quick actions remain usable.

## 11. Testing

Unit tests:
- state transitions;
- transient states return to idle;
- score-to-celebration mapping;
- tutorial completion persistence;
- reduced-motion behavior policy.

Widget tests:
- correct-answer reaction does not block quiz controls;
- quiz results trigger celebration;
- generator working state shows thinking mascot;
- help button opens context-aware assistant;
- replay tutorial launches completed tutorial again.

Integration/build verification:
- Flutter analyze;
- full test suite;
- Android release build;
- web release build.

## 12. Non-Goals for v1

- full lip-sync for arbitrary speech;
- complex character physics;
- network-downloaded animation assets;
- replacing Norie’s visual identity;
- voice during normal quiz gameplay;
- requiring Rive for the first implementation.

## 13. Future Upgrade Path

The semantic controller API is intentionally renderer-independent. A future Rive state-machine rig can replace the Flutter layered renderer while preserving:
- tutorial definitions;
- quiz triggers;
- help assistant integration;
- AI loading states;
- screen APIs.
