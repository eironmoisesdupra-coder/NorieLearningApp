# Roadmap Part 1: Variable Curriculum Depth Implementation Plan

> Execute inline using superpowers:executing-plans; review the final branch independently.

**Goal:** Enforce 6?20 authored lessons per published subject-grade path, without inventing lessons or changing earned progress.
**Architecture:** A pure depth policy is called when the existing curriculum registry finalizes paths. Existing map/chapter/list/progress code already derives counts from supplied topics.
**Tech Stack:** Flutter/Dart, existing offline authored registry and widget tests.
**Spec:** User ZIP README_WIP.md and docs/ROADMAP_STATUS.md, Part 1 only; base develop@9b0ddb12246180eaac81c04751d92d1a0dde4fef.

## Constraints
- No new subjects (Part 2), skill graph (Part 3), filler, mandatory locks, or changes to IDs/rewards.
- Planning targets are developer guidance, never displayed as published content.
- Retain legacy five-mission rewards and reference paths; limits apply only to published curriculum.

## Review focus
- Boundaries 5/6/20/21 and negative counts.
- Unknown subjects/grades must not fabricate Science or throw misleading depth errors.
- Existing 234 topic IDs and all 39 paths remain authored and unchanged.
- Partial chapters at 7/8/19 missions, saved positions and completed/current states.
- Last mission reachable at 320px and 1.6 text scaling.

## Tasks
- [x] Write policy/registry tests, run red; integrate depth policy and registry finalization; run green.
- [x] Expand existing map/widget regressions to 6/7/8/19/20 and preserve five-mission legacy coverage.
- [x] Analyze, full tests, release web; independently review; fix findings.
- [ ] Focused commit, PR into develop, exact-head CI and packages; publish only after green.

## Rulings
- The archive README refers to a missing changes.patch; apply_wip.py also contains stale UI anchors. Integrate manually, and do not execute the bundled installer.
- Additional subjects are Part 2; no 7/8-mission production pilots added in Part 1. Mixed-length fixtures use existing authored topics solely to test map mechanics.

## Verification ledger
- Targeted map/policy suite: 22 passed before final extra assertions.
- Final full Flutter suite: 520 passed; analyze: no issues.
- Web update/download/release regressions: 16 passed; desktop asset/audio boundaries: 7 passed.
- Independent review: no blocking findings; added variable-length saved/current/completed assertions.
- Release web build passed (151.7 seconds); existing Wasm dry-run compatibility warnings do not prevent the JavaScript release.
