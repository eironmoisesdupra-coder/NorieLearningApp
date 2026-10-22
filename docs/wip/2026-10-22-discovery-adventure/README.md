# NorieLearning Discovery Adventure — first playable mission WIP

**Base:** `develop` at `899b7ab5458583fd8cc5558aca6cc0ba3c444007` (0.16.1+22 Preview as last verified). **Not merged or live.**

This is an incremental CODE + IMPLEMENTATION BRIEF for the first 5–8 minute playable mission. It is NOT a claim of a completed game. The overlay includes a deterministic domain model and tests. The next Codex work is scene UI, character movement, persistence, integration, real student testing.

## Mission: The Case of the Vanishing Water
Science, recommended Grades 4–6. Players explore a laboratory, inspect an open water container, dry tabletop and warm window, run a controlled warm/cool comparison, infer evaporation and apply the concept to clothes drying. Learners must observe and reason; do not equate tapping all clues with mastery.

## Scope: first prototype only
- One small 2D room, controllable Explorer (keyboard arrows/WASD and accessible touch buttons), 5 interactive props; fixed camera, no combat or open world.
- Norie companion (curious, puzzlement, encouragement, success); short contextual, non-manipulative dialogue. Optional Skip dialogue and silent mode.
- Evidence notebook with three observations; identify hypothesis vs evidence.
- Warm/cool comparison, same starting water and time, controls accessible without dragging.
- Choice of hypothesis + evidence, then independent transfer problem.
- Save/resume mission and permanent Discovery Journal entry once, scoped by learner and versioned.
- Zero mandatory login or internet, zero real-money purchases.
- One reward receipt at most IF product owner explicitly approves a non-duplicating reward. Default: no new XP/credit award.

## Source files
- `overlay/lib/features/discovery/domain/discovery_mission.dart`: finite-state domain prototype. Offline and side-effect-free.
- `overlay/test/discovery_mission_test.dart`: stage guards, completion invariants and forged-save rejection.
- `CODEX_TASK.md`: implementation steps and strict release conditions.
- `docs/MISSION_SCRIPT.md`: content/copy and learning checks.
- `docs/COMPANION_NOTIFICATIONS.md`: later-phase expressive notifications, not in MVP.

## Rules
Do not run an installer that overwrites existing files. Copy and review overlay files to corresponding paths only if they do not conflict. Run `dart format`, `flutter analyze`, targeted/full tests and compile-time tests on actual current head.

## Follow-on roadmap (not part of the first build)
#34 Adventure Engine; #35 Explorer cosmetics; #36 Companion Expression Engine; #37 Knowledge Inventory; #38 Optional reminders; #39 Discovery Journal/world; #40 seasonal cases; #41 learner pilot. Implement the first vertical slice (#34/#36/#37/#39 minimal parts) before extending.
