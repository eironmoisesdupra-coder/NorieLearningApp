# NorieLearning 0.19 Educational Integration Plan

> **For agentic workers:** Use superpowers:executing-plans for implementation and independent read-only PR reviews before integration.

**Goal:** Integrate reviewed PR72–79 into develop, repair demonstrated reliability gaps, and prepare an unpublished 0.19.0 Preview candidate.

**Architecture:** Preserve the existing Flutter, account-scoped SharedPreferences, curriculum and renderer architecture. Refresh dependent branches by merging verified develop without rewriting their history; integrate cumulative changes once. Source-comparison records are distinct from FSRS, immutable-content-bound and never qualified editorial approval.

**Tech Stack:** Flutter/Dart, SharedPreferences, existing Node/Electron and Python asset tooling; GitHub PR/CI workflows.

**Spec:** docs/superpowers/specs/2026-10-24-019-integration-order.md

## Global Constraints

- Never push or merge main. No automatic release publication or production deployment.
- Publication requires explicit owner approval of the exact release SHA after the candidate is reviewable.
- Do not activate purchases, detailed paid Anatomy hints, provider credentials or billing.
- Preserve downloaded content, lesson/question IDs, progress, rewards, source attribution, models and calibration.
- Automated arithmetic checks, learner source comparison and qualified educational approval remain independent.
- Native coverage remains G1 addition, G3 multiplication and bounded G8 integer equations; no broader subject claim.
- Keep the 30 Anatomy authoring drafts unapproved and production trusted registry empty.
- No production schema/auth/permission changes.

## Review Focus

1. Leaving native practice while an answer save is pending must not update a disposed screen; reopening reconciles the saved answer once.
2. Flags/comparisons survive restart only for the same learner and exact question/source revision; corrupt data and failed writes never become successful review.
3. Missing sources stay disclosed; native arithmetic practice does not require learner source approval; flashcards retain independent review access.
4. Guided-study write failure must not claim durability, and stale controls after a step/owner change must not alter the current activity.
5. Cumulative Anatomy and Math patches must be integrated once while preserving both free assistance and independent English/recovery changes.

## Task 1 — Verified baseline and build foundation

Files: integration report, existing PR78 recovery files and PR77 contracts. Interfaces: pinned model recovery output and deterministic generation contracts.

- [x] Fetch develop, preserve clean/uncommitted work, inspect AGENTS/handoff/release and PR72–79 ancestry/checks/reviews.
- [x] Obtain independent per-PR reviews; reproduce PR72 parser failure and identify integration gaps.
- [ ] Verify existing local targeted baseline and recovery checks; retain historical exact-head CI evidence.
- [ ] Mark and merge PR78 only after its own review/checks pass; verify develop SHA and resulting source tree.
- [ ] Refresh PR77 against verified develop, retain identical recovery bytes, obtain green exact-head CI and merge; verify develop.

## Task 2 — Repair and integrate Native quiz lifecycle

Files: study_quiz_screen.dart; new lifecycle widget regression; PR79 integration and existing native tests.

- [ ] Write and run a delayed preference-write widget test: submit a correct native answer, leave, complete persistence, expect no disposed-state update and durable recovery without duplicate reward.
- [ ] Add the minimal mounted/owner continuation guard; rerun regression and affected suite.
- [ ] Refresh PR79 against merged foundations, preserve all native UI/provenance/session/receipt behavior, independently review repair evidence.
- [ ] Green exact-head full/platform CI, merge and verify develop.

## Task 3 — Durable source accuracy review

Files: source accuracy screen, StudySetScreen, source-review domain model, study store/service, new domain/store/widget tests.

Interfaces: owner-scoped source review records keyed by set/question with exact content/source revision; separate from FSRS reviews. Store/service load/save APIs propagate persistence failure and reject changed owners. Practice consumes current review decisions, not a route-local Boolean.

- [ ] Preserve PR72's parser failure as RED evidence, then reconcile its screen with PR79.
- [ ] RED tests for persisted compared/flagged decisions, relevant-field/source changes, another owner, failed/corrupt writes, missing source, empty set, flashcard review access and native bypass.
- [ ] Implement content-bound source review records and serialized durable store/service calls. Render source availability and learner comparison separately; no qualified-approval writer.
- [ ] Keep review access independent from practice; source-based graded practice requires current nonflagged comparisons; native practice keeps its computational disclaimer.
- [ ] Expose reusable capability/check outcomes using existing Math validation; units/science/diagram/qualified-review checks return unsupported or needs review unless a real validator/signoff is supplied.
- [ ] Run domain/store/widget, existing Study Lab/native and full/platform checks, independent review, then merge repaired PR72 and verify develop.

## Task 4 — English enrichment and guided-study recovery

Files: PR73 English/recovery files and tests; guided screen/store lifecycle and failure regressions.

- [ ] RED widget/store tests for failed write, explicit retry/reopen and step-away/back stale controls.
- [ ] Remove premature saved-success wording; guard demonstrated stale activity callbacks without changing IDs/reward rules.
- [ ] Retain all three English lesson enrichments and existing corruption/owner recovery guards.
- [ ] Refresh PR73, test/review/green exact-head CI, merge and verify develop.

## Task 5 — Anatomy library, authoring and assistance integration

Files: PR74/75/76 exact library, CLI/30 drafts, hint panel, policy, guide, renderer/desktop tests.

- [ ] Refresh, test, review and merge PR74 then75 with preserved ancestry and no duplicate foundation patch.
- [ ] Resolve PR76 policy using safe general guidance plus PR73's catalog-qualified explanation; retain all coarse-name/side regressions.
- [ ] Combine tutorial/recovery/native paragraphs and both actual desktop offline scenarios.
- [ ] Run 50 library/CLI tests plus eligibility/zero-charge/readiness/account/5–10–20Q/accessibility/guided/English regression tests; approved count remains0, drafts30, paid detail disabled.
- [ ] Green exact-head platform CI, merge PR76 and verify develop.

## Task 6 — Candidate hardening and release preparation

Files: pubspec/desktop version, release/readiness metadata and integration/handoff report; focused candidate PR.

- [ ] Merge latest verified develop into the isolated candidate worktree; retain all integrated fixes and plan history.
- [ ] Set a consistent 0.19.0+25 Preview candidate after final scope is stable; update established metadata only.
- [ ] Run format/analyze/full Flutter, affected Node/Python/checksum/license/offline tests, web build, Android CI and packaged Windows CI.
- [ ] Inspect actual compiled desktop/phone/narrow/enlarged/reduced-motion/keyboard/accessibility flows where supported; explicitly record physical-device limits.
- [ ] Independently review final candidate, fix demonstrated regressions RED→GREEN, merge approved code into develop, verify merged-source CI/packages/version/checksums.
- [ ] Prepare exact source/artifact/checksum/signing/review-limitation manifest. Do not publish; request owner approval only for the concrete exact release SHA.

## Execution notes

The user supplied the integration design and execution order. Routine branch-refresh and test choices are made inline; no additional design approval pause. Confirmed blockers are repaired before merge. GitHub branch rules remain enforced by normal merge endpoints; no bypass or fabricated review approval.
