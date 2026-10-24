# Educational Readiness Implementation Plan

**Goal:** close feasible safety and teaching gaps on current develop, without enabling unreviewed paid hints or publication.
**Authority:** the owner's Educational Systems Completion & Production Readiness build order in this session explicitly authorizes implementation in priority order and continuing past external blockers. Routine choices follow AGENTS.md; no additional approval round is needed.
**Baseline:** ed9472dbb437127abd8fd09931a86879d4df5ec5, clean fresh checkout, feat/educational-readiness. Other device checkouts are inaccessible and untouched.
**Architecture:** extend existing quiz policy, English authored lesson renderer, and owner-scoped Anatomy store. Preserve all canonical lesson/question IDs, rewards, Classic/Adventure routes, and backup formats. No new dependency, migration, deployment, billing, or publishing authority.

## Tasks and verification

- [x] Anatomy: reproduce unsafe coarse-name hint inference in a unit test. Replace inferred descriptions with explicitly labeled catalog-group guidance. Preserve short-session free hints and zero debit for unavailable paid hints; test laterality/reference and current charging/scoring regressions.
- [x] Lessons: add original independent transfer, hidden reasoning, and delayed retrieval to three existing English lessons (G1 Nouns, G7 Sentence Variety, G11 Source Evaluation), via optional authored sections keyed by grade/order. Verify literal answer reasoning, original IDs/rewards, serialization and real reveal interaction at 320px/160% text. Existing Mathematics/Science pilots remain in the regression run.
- [x] Publication: inspect current disabled workflow and run existing security fixtures. Record required Draft/In Review/Approved/Published/Archived mapping and differences; no production migration or activation without external prerequisites.
- [x] Offline: reproduce unreadable/wrong-version/invalid-entry restore being writable. Validate the complete study snapshot before adopting it, block writes while recovery is required, add owner-safe explicit retry and reachable UI. Verify persisted bytes survive failed load/flush and progress resumes after storage recovery; run owner-switch and pair-backup tests.
- [ ] Integration: update tutorial and README where behavior changes. Format, analyze, targeted/full Flutter tests, Node/Python suites, web build; attempt supported native checks and report unavailable tooling precisely. Open draft PR; never merge or deploy.

## Review focus

- Unknown and similarly named structures never acquire authoritative descriptions through name matching.
- Corrupt, oversized or future-version saves are never replaced by empty or partial progress.
- Retrying a read cannot adopt a previous learner's data or enable stale renderer callbacks.
- New review reveals do not award rewards or change assessment IDs.
- Publication remains disabled and downloaded curriculum/progress remain unchanged.

## Execution ledger

Inspection: PR65 merged as 6452f71; PR66 lesson pilots, PR67 publication preparation and PR68 Anatomy backup are already merged. PR72 source-review work is open and excluded from this branch. Root handoff lives at docs/NORIE_CURRENT_HANDOFF.md. Current source version is 0.18.0+24; this is not evidence of publication.
Environment: Flutter absent initially; installing isolated stable SDK. Windows host and Android SDK not supplied.


Verification ledger:
- New behavior: initial RED run had 8 expected failures; fixes pass the focused tests. The English widget test was corrected to scroll the lesson (not an embedded diagram) and tap the actual Reveal answer control.
- Independent read-only review identified strict schema completeness and stale mutation callbacks as important findings. Both were reproduced RED. Schema now requires all four top-level fields and integer versions; callbacks capture owner generation, guide/step and model session.
- An additional stale recovery-button regression was reproduced RED: invoking an old retry control selected the original route target over a newly selected guide. Recovery controls now capture generation and loading state too.
- Final targeted set: 76 passed, including charging safety, scoring, figure/reference binding, owner changes, portable backups, recovery and existing Mathematics/Science pilots.
- Final analyzer rerun after a brace-style lint: clean.
- Node Anatomy renderer: 29 passed. Python Anatomy: 24 passed. Source audit: zero critical errors. Web cache/update/download/release-shell: 16 passed. Publication offline signature/rollback and actual isolated PostgreSQL security fixtures passed.
- Full-suite, current web build and remote PR results are recorded in the implementation report when available; no clean full-suite claim is authorized while LAN interface enumeration fails on this host.

Ruling: keep paid activation disabled and zero-cost — no qualified exact-structure fact approvals or atomic durable debit/reveal transaction exist; paid hints remain unavailable.
Ruling: preserve already merged Mathematics/Science pilots and add three English pilots — avoid duplicate authoring or overwriting existing content; wider enrichment remains future work.
Ruling: retain the production publication gate and original schema — deployment, qualified reviewers, signer/verifier/cache adapter and real-backend security checks are absent; operational publication remains incomplete.
Ruling: create only a draft reviewable PR despite host-specific LAN failures, as the owner explicitly directs independent work past external blockers; never merge/deploy or claim full green.

Final full Flutter result: 975 passed, 9 unchanged LAN tests failed due host NetworkInterface.list, 1 existing packaged-native interop skip. Standalone Dart interface enumeration reproduces the host failure. Desktop tests: 9 passed/10 LAN failures from uv_interface_addresses. Android build explicitly reports no Android SDK. Browser installer returns truncated ZIPs; no rendered browser QA claimed. No test was skipped to hide these failures.

Final web release build passed (96.1 seconds); Wasm dry run succeeded, not a tested Wasm deployment.
