# Explorer and Tutorial Refresh Implementation Plan

> **For agentic workers:** Use superpowers:subagent-driven-development or superpowers:executing-plans. Independent subject/avatar tasks may proceed in parallel under superpowers:dispatching-parallel-agents.

**Goal:** Apply all five approved WIP packets and make the app guide reliable and engaging offline.

**Architecture:** Extend existing modular Flutter systems. Keep the tutorial's example workspace separate from production study persistence. Keep Explorer choices in existing appearance snapshots and preserve legacy rank IDs.

**Tech Stack:** Flutter/Dart, existing SharedPreferences, code-native illustration/discrete full-body animation frames, current GitHub Preview workflows.

**Spec:** docs/superpowers/specs/2026-10-23-explorer-tutorial-design.md

## Global constraints

- Worktree: NorieLearning-integrate; baseline origin/develop 31d24151d2fb05031042df797d9afb49e82445bc. Original dirty checkout untouched.
- Preserve full-body Norie, current anatomy, offline lessons, account/progress/reward hooks and licenses.
- No new rewards from samples, no backend changes, no purchases, no main push.
- Keep rank thresholds 1/5/15/30/50; aliases/internal cosmetic IDs remain compatible.

## Review focus

1. Signed-in empty-cache/offline learners can follow tutorial steps 20–28 without cloud calls or writes.
2. Close/reopen/jump/back leave source drafts and production decks intact.
3. Existing appearance backups and older rank titles load and equip correctly.
4. 320px phones, landscape, enlarged text, and reduced motion keep controls usable.
5. Only the existing Science pilot is playable; previews cannot imply released curriculum or reward claims.

## Tasks

- [x] Tutorial: regression tests for routed sample isolation and all nine steps; reproduce RED, implement a dedicated in-memory study demonstration and accurate step targets; improve complete-guide illustration, chapter identity, transitions and controls; targeted GREEN.
- [x] Subject modes: tests for classic route retention and truthful Science/other-subject availability; RED, implement reusable mode cards and subject adventure hub/registry, GREEN.
- [x] Explorer: tests for appearance backward compatibility/persistence, distinct full-body animation frames, tap response and reduced motion; RED, implement Explorer rendering and editor/preview integration, GREEN. No segmented rig.
- [x] Ranks: tests for thresholds and legacy aliases; RED, introduce simple educational rank visuals and consistent visible names, GREEN.
- [ ] Integration: inspect diffs and actual visuals, format, analyze, targeted/full tests, web and Android builds; independent review and address important findings; PR, exact-head CI, develop/web Preview as authorized. Document placeholders and platform links accurately.

## Investigation evidence

- Baseline targeted tests: 27 passed (tutorial/mascot/study sync).
- Ignored diagnostic test: 2 passed, reproducing signed-in empty-cache load failure under offline transport and confirming cached decks remain available.
- Root cause in guide: NorieTutorialNavigation routes all library/review/Q&A steps to production StudyHubScreen, whose load may require cloud data and whose inner deck/review targets are not actually opened.
- Existing mascot animation interpolates transforms among three PNG poses. The new Explorer must use distinct complete poses, not repeat that limitation.

## Execution ledger

- Scope confirmed by owner: all five WIP packets plus tutorial.
- Ruling: use the supplied detailed brief and direct animation clarification as the design authority; routine implementation choices remain with the builder under AGENTS.md. Do not introduce another approval round for already requested reversible changes.
- Ruling: sample workspace repairs tutorial availability; do not weaken real-library error reporting or silently create/delete user decks.
- Local integrated verification: analyzer clean; full Flutter suite 974 passed, one existing packaged-native-interop skip; desktop Node suite 19 passed; release web build passed; portable Windows package built with actual PE version 0.18.0. Local APK attempt reported no Android SDK; exact-revision CI must build/validate Android.
- Independent review found no confirmed critical/important persistence, account, reward, isolation or route defect. Its enlarged-text landscape candidate was reproduced RED (5px overflow) and fixed by reserving more reading room, with regression included in the passing full suite.
- Final browser/native matrices and exact-head PR CI remain tracked in the PR; do not infer publication from a local build.
