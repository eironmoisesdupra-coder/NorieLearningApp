# NORIELEARNING — CODEX MASTER BUILD ORDER

## Version 0.19.0 — Educational Reliability & Hybrid Quiz 2.0

**Repository:** `eironmoisesdupra-coder/NorieLearningApp`  
**Integration branch:** `develop`  
**Current verified release:** `0.18.0+24 Preview`  
**Current verified develop SHA:** `ed9472dbb437127abd8fd09931a86879d4df5ec5`  
**Proposed target:** `0.19.0 Preview`  
**Priority:** Critical  
**Execution:** Review, repair, integrate, test and prepare a release candidate.

### PRIMARY OBJECTIVE

Complete and integrate the existing educational reliability work without losing functionality already implemented in NorieLearning.

The next milestone must prioritize:

1. Reliable application builds and dependencies.
2. Free, accurate offline Mathematics practice through Hybrid Quiz 2.0.
3. Educational source accuracy and answer validation.
4. Safe Anatomy Hint 2.0 foundations and learner assistance.
5. Progress preservation, compatibility and release readiness.

Do not start by rewriting features already implemented in existing pull requests.

---

## PHASE 0 — REPOSITORY INSPECTION

Before modifying code:

1. Fetch the latest remote `develop` and inspect the current HEAD.
2. Read `AGENTS.md`, `NORIE_CURRENT_HANDOFF.md`, and all relevant development and release documentation.
3. Inspect the working tree and preserve uncommitted changes.
4. Inspect the latest release, CI workflows and existing development branches.
5. Inspect open PRs #72–#79.
6. Identify shared files, dependent commits, merge conflicts and incomplete checks.
7. Confirm which implementations are complete, partial or blocked.
8. Establish a verified baseline before integrating anything.

Do not assume version 0.18.0 is still the latest if a newer release has been published.

**Required output:** An integration dependency map and implementation-status report.

---

## PHASE 1 — BUILD RECOVERY

**Primary PR:** #78

### Objective

Restore reproducible application builds without introducing unlicensed, altered or unverified Anatomy assets.

### Tasks

- Review PR #78 and confirm the cause of the unavailable legacy model mirror.
- Verify recovery of the original licensed Anatomy models.
- Validate source and destination SHA-256 hashes.
- Preserve model geometry, mesh identifiers, dimensions and calibration.
- Preserve original source attribution and licensing records.
- Avoid committing unnecessary large binary assets.
- Confirm the recovery mechanism works in CI and clean development environments.
- Check that normal offline Anatomy usage does not depend on the retired remote mirror.
- Verify no application content or learner data is changed unexpectedly.

### Acceptance criteria

- Asset recovery is reproducible.
- Licensed model integrity is validated.
- Relevant build and calibration tests pass.
- No new external dependency is introduced without justification.
- The repair does not bypass verification safeguards.

**Integration order:** Review and merge PR #78 first, once its own checks and review requirements pass.

---

## PHASE 2 — HYBRID QUIZ 2.0

**Primary PRs:** #77 and #79

### Objective

Deliver a practical, free offline Mathematics quiz experience that supports accurate grading, saved progress and reliable continuation.

### Tasks

1. Review PR #77's generation contracts and deterministic validation engine.
2. Review PR #79's Study Lab integration and persistence behavior.
3. Verify their cumulative commits to prevent duplicated patches.
4. Integrate the foundation before the user-facing quiz implementation.
5. Rebase or refresh dependent branches after approved merges.

### Quiz requirements

- Free offline question generation for supported topics.
- No mandatory AI API key.
- No external provider credits for native quiz generation.
- Explicit supported topic and grade boundaries.
- Multiple-choice and identification questions where implemented.
- Supported quiz lengths of 5, 10, 20 and 40 questions, or an honest shortage response.
- Correct mathematical answers and explanations.
- Stable question identifiers and seeded generation.
- No accidental duplicate questions within a quiz.
- Saved progress and reliable resume.
- Replay without duplicate rewards.
- Safe handling of incorrect answers.
- Compatibility with existing Study Lab workflows.

### Validation

Test the supported Mathematics domains already provided by the PRs.

Do not claim that all Mathematics topics are supported.

Validate:

- Integer arithmetic.
- Multiplication.
- Supported linear equations.
- Correct answer keys.
- Incorrect answers.
- Equivalent representations when explicitly supported.
- Duplicate prevention.
- Interrupted-session recovery.
- Owner/account isolation.
- Offline operation.

An automatically checked question must not automatically receive qualified educator approval.

### Acceptance criteria

Learners can generate, answer, save, resume and replay supported offline Mathematics quizzes without an AI subscription or API key.

---

## PHASE 3 — EDUCATIONAL ACCURACY GUARDIAN

**Primary PR:** #72  
**Related:** #73, #77 and #79

### Objective

Prevent unsupported educational content from being treated as verified.

### Tasks

- Review the existing source-comparison implementation in PR #72.
- Identify overlapping Study Lab changes introduced by PR #79.
- Integrate their UI and state-management changes without losing either workflow.
- Require accurate source visibility where source-based review is supported.
- Preserve learner-controlled review and flagging.
- Invalidate review status when relevant content changes.
- Distinguish automated arithmetic checks from human educational review.
- Prevent unsupported claims of correctness or editorial certification.

### Important rules

- AI-generated content is not automatically approved.
- Mathematical verification does not prove curriculum suitability.
- Learner source comparison is not qualified editorial review.
- Missing sources must be disclosed.
- Citations must not be fabricated.
- Unsupported question types must fail safely.
- Offline learning must remain accessible.

### Additional accuracy coverage

Develop reusable validation interfaces for:

- Mathematics answers and permitted equivalences.
- Units and tolerances.
- Scientific calculations where supported.
- Answer-key/explanation consistency.
- Diagram-to-answer relationships.
- Curriculum review status.

Implement these incrementally with tests rather than claiming universal automatic validation.

### Acceptance criteria

The accuracy system transparently identifies what was computationally checked, manually reviewed, approved or still unverified.

---

## PHASE 4 — ANATOMY HINT 2.0

**Dependencies:** PR #74 → PR #75 → PR #76  
**Related overlap:** PR #73

### Objective

Provide safe, useful Anatomy quiz assistance while maintaining strict correctness and payment protections.

### Step A — Exact Structure Library

Review PR #74.

Validate:

- Exact anatomical structure identifiers.
- Asset and mesh binding.
- Canonical terminology and synonyms.
- Structure and region metadata.
- Source references.
- Immutable revision information.
- Qualified reviewer requirements.

Incorrect or ambiguous mappings must fail closed.

### Step B — Content Authoring and Review

Review PR #75.

Preserve the existing 30-part draft review queue.

Do not fabricate:

- Anatomical descriptions.
- Citations.
- Reviewer identities.
- Approval dates.
- Educational verification.

Draft content must remain separate from approved content.

### Step C — Progressive Assistance

Review PR #76.

Verify:

- Free general assistance works.
- Specific structure clues require valid exact-structure records.
- Unqualified hints use safe fallback explanations.
- Shorter Anatomy quizzes remain functional.
- Detailed paid hints remain locked.
- No accidental credit deductions occur.

### Integration constraints

Resolve overlap with PR #73 before merging.

Preserve #73's independent English lesson improvements and Anatomy recovery protections where appropriate.

Merge dependencies in the correct order. Avoid merging duplicate cumulative commits.

### Payment restriction

**Do not activate 5-credit detailed hints during this milestone unless all required safeguards independently pass.**

Activation requires:

1. Qualified educational approval of actual content.
2. Exact figure-to-description validation.
3. Trusted reviewer identity and signoff.
4. Transaction-safe debit and reveal.
5. Protection against repeated charges.
6. Insufficient-credit handling.
7. Regression tests.
8. Explicit owner approval.

If those requirements remain incomplete, leave paid hints disabled and report the limitation clearly.

---

## PHASE 5 — SAVE & RECOVERY REGRESSION PROTECTION

This phase introduces reliability safeguards relevant to the current milestone. It does not require completing the entire future Save & Recovery Guardian roadmap.

### Verify persistence for

- Hybrid quiz sessions.
- Study Lab review state.
- Anatomy quiz progress.
- Existing Classic Lessons.
- Discovery Adventure.
- Profile Explorer appearance.
- Existing account XP and credits.

### Test scenarios

- App restart during an activity.
- Interrupted write.
- Corrupt saved data.
- Repeated completion.
- Replay after a completed attempt.
- Account switching.
- Guest-to-account transition where supported.
- Offline reload.
- Repeated hint views.
- Backgrounding and resuming.

Avoid destructive reset behavior on unreadable progress.

Never silently claim a successful save if durable persistence failed.

---

## PHASE 6 — CROSS-FEATURE INTEGRATION

Ensure that all new work coexists with the existing 0.18.0 functionality.

Preserve:

- Classic and Adventure Mode navigation.
- Current authored lessons.
- Playable Discovery Adventure.
- Explorer character customization.
- Rookie, Explorer, Scholar, Expert and Professor ranks.
- Shop purchases and cosmetics.
- Existing XP and mastery calculations.
- Anatomy models and saved views.
- Offline functionality.
- Current Windows, Android and Web workflows.

Do not modify production billing, credential configuration, account permissions or learner data without a separate reviewed requirement.

---

## PHASE 7 — TESTING AND VALIDATION

### Required checks

Run:

- `dart format`
- `flutter analyze`
- Full `flutter test`
- Relevant desktop test suites
- Flutter web release build
- Windows package/build validation
- Android build CI
- Source checksum and licensing tests
- Offline persistence tests
- Existing lesson and profile regressions

### Educational validation

Test:

- Correct arithmetic and equation solutions.
- Incorrect answer handling.
- Quiz generation boundaries.
- Source-review invalidation.
- Missing or conflicting sources.
- Anatomy structure mapping.
- Hint eligibility and zero-charge safeguards.
- Resume and replay.
- Account isolation.

### Interface validation

Test at least:

- Desktop layout.
- Typical mobile portrait.
- Narrow mobile viewport.
- Enlarged text.
- Reduced motion.
- Keyboard navigation.
- Screen-reader labels and focus order.

Document failures rather than suppressing them.

A green build is not evidence that every educational item is academically correct.

---

## PHASE 8 — PULL REQUEST INTEGRATION ORDER

Use the following dependency-aware sequence:

| Order | PR | Action |
|---|---|---|
| 1 | #78 | Review and repair build foundation |
| 2 | #77 | Review Mathematics validation contracts |
| 3 | #79 | Integrate Hybrid Quiz UI and persistence |
| 4 | #72 | Reconcile Study Lab accuracy review |
| 5 | #73 | Review Anatomy recovery and English work |
| 6 | #74 | Integrate Anatomy structure foundation |
| 7 | #75 | Integrate dependent Anatomy authoring tools |
| 8 | #76 | Integrate progressive Anatomy assistance |

This order is provisional. Adjust it based on the actual dependency graph, overlapping commits, and review findings.

For each PR:

1. Inspect its changes.
2. Resolve confirmed defects.
3. Confirm the correct base.
4. Run targeted and required full checks.
5. Conduct an independent review.
6. Merge only when ready.
7. Verify integration into `develop`.

Do not automatically merge all PRs merely because they exist.

---

## PHASE 9 — PREVIEW RELEASE READINESS

After integration, prepare a candidate for **NorieLearning 0.19.0 Preview**, provided the final scope is stable.

### Required release gates

- Verified merged-source SHA.
- Successful merged-source CI.
- Successful web build.
- Windows package validation.
- Android APK build and version verification.
- Correct release metadata.
- Published asset checksums prepared.
- No confirmed critical correctness defects.
- Explicit documentation of educational review limitations.
- No paid hint activation without approval.
- No claim of production signing unless real signing credentials are in place.

### Release authorization

**Do not publish automatically.**

Prepare the candidate and report readiness. Request explicit owner approval for the exact release SHA before executing the established Preview publication workflow.

Do not push to `main`.

---

## PHASE 10 — REQUIRED FINAL REPORT

Return the following:

### A. Repository status
- Latest verified branch SHA.
- Actual current release.
- Open and merged PRs.

### B. Completed features
- Hybrid Quiz 2.0.
- Accuracy review.
- Anatomy assistance.
- Build recovery.

Distinguish fully implemented functionality from draft or incomplete work.

### C. Test evidence
- Test commands.
- Pass/fail counts.
- CI links.
- Known failures.
- Build outputs.

### D. Educational review status
- Automated checks available.
- Human-approved material.
- Unreviewed content.
- Missing or invalid Anatomy content.
- Disabled paid functionality.

### E. Release readiness
- Ready / blocked.
- Blocking issues.
- Exact commit.
- Required owner approvals.

### F. Roadmap checklist
Use:

- ✅ Implemented and verified.
- 🟡 In progress or gated.
- 🔵 Planned only.
- ⬜ Not started.

---

## FINAL INSTRUCTION

**Prioritize reliability, educational accuracy, and preservation of existing learner progress over feature quantity.**

Do not claim a feature is live merely because code exists in an open pull request.

Do not replace accurate educational content with unsupported generated explanations.

Do not activate purchases, paid hints, or experimental assessments without their required safeguards.

Complete this milestone through careful dependency review, incremental integration, actual tests, and verifiable release evidence.