# Hybrid Quiz Generation 2.0 — first functional milestone

Base: develop `ed9472dbb437127abd8fd09931a86879d4df5ec5`. Version remains **0.18.0+24 Preview**. Core PR77: `4cf6445b72bf8dcdcaad3ef89975f12dce1312c5` (contract commit675601bf; includes dependency78), branch `feat/hybrid-quiz-core`. Integration branch `feat/hybrid-quiz-generation` depends on77 and targets develop for platform CI. Exact integration head, CI and downloads are recorded in its PR. Nothing merged or deployed.

## Implemented coverage and boundaries

| Native topic | Academic level | Distinct bounded exercises | Available formats |
|---|---|---:|---|
| Whole-number addition with sum at most20 | G1 |121| Multiple choice / identification |
| Multiplication facts1–12 | G3 |78| Multiple choice / identification |
| Integer linear equations, coefficient1–9, constant0–9, solution−10…10 | G8 |1176| Multiple choice / identification |

All are Foundation difficulty, English. Counts5/10/20/40 are exact or explicitly unavailable; no padding, duplicate questions or unrelated topics. Seed reproduces question/choice order. Addition/multiplication commutations and scalar-equivalent equations share canonical identities. Completed native identities are excluded in the UI; insufficient coverage disables generation until a smaller count or explicit repeat consent. Saved decks can always be replayed. Device resources and finite coverage still limit local practice; no claim of unlimited subject coverage.

Questions and explanations are original parameterized Norie exercises. Method references are OpenStax Prealgebra2e §§1.2/1.4 and Elementary Algebra2e §§2.1/2.2, checked during implementation. Each result stores source locations, immutable question hashes, provider/version, difficulty/request metadata, timestamp, validation state and persistence identity. Exact arithmetic/prompt/key/explanation checks yield **computationallyChecked**, never a fabricated academic approval. Identification currently uses the existing whole-number answer-string input; general symbolic equivalence is not implemented.

The separate bank importer accepts no client self-approval. A candidate needs valid schema/source/objectives/hint and an independently configured signoff matching exact content hash, reviewer and timestamp. Invalid imports preserve prior staging. **New approved production question bank:0 records**. No Chemistry, Biology, Anatomy, Physics, Earth Science or English bank/template was activated, and no40-item Chemistry benchmark has been claimed complete. Qualified content review and controlled activation remain gates. Existing published lessons and their review status are unchanged.

## Learner workflow

Learn → Create with Norie AI → **Native Engine · Free offline practice**. Choose a listed topic/level, question format and count. Generation saves to the existing Study Lab library without a source upload, sign-in, API key or provider call. Existing pasted notes, uploads, cloud OpenAI and optional experimental local-AI flows remain available through their original controls. No automatic cloud fallback, external inference adapter, quota request or billing action is registered by this milestone.

Native cards are fixed to their checked templates; arbitrary card editing cannot retain a mathematical proof label. Existing source-deck editors are unchanged. Native source Q&A is hidden, because no uploaded source exists. The guide explains the native entry, finite coverage and repeat consent. Native quiz banners explain saved-run recovery.

## Persistence, progress and account isolation

Native sets use existing owner-scoped SharedPreferences storage and additive optional JSON provenance; historical sets deserialize unchanged. Stable deck IDs bind content/version/format, so title changes, shuffling or reopening identical content cannot mint new reward identities. Existing answer and completion receipts, reward outbox, XP/Credits caps, mastery/streak logic and FSRS stay authoritative within the existing app architecture. Native creation never charges game Credits or AI allowance. Correct-answer rewards during practice remain existing authorized rewards.

Both list refresh and individual cached-deck reads preserve device-local native decks. Native attempts/cards never enter remote mutation queues; deletion works locally. There is no new cloud sync contract or schema migration for native decks. Account/generation guards check after async reads and before navigation; the existing learner-session guard masks stale native screens, results and outro controls. Tests cover another owner's deck and a switch during final repository read.

Native-only unfinished sessions save shuffled question/choice order, checked responses, current index and earned-answer XP, pinned to the exact deck revision. Restore regrades responses and validates all saved question identities/content. Checked answers persist before rewards; durable existing reward receipts reconcile an interrupted last award without a duplicate debit/award. A changed/unreadable snapshot shows explicit recovery; restarting requires confirmation and clears only the unfinished attempt. Corrupt cache writes fail without replacing original bytes. Other quiz formats retain their existing behavior.

Device-local SharedPreferences are not an encrypted or tamper-proof examination store. Existing cloud/local AI service-side provider quota, refund/reservation and source-accuracy limitations are documented in the baseline; they were not silently replaced with a new client billing authority.

## Verification evidence

- Baseline:30 existing Study Lab tests passed before implementation.
- New core:15 tests passed, including all bounded candidates and independent mathematical substitution/golden values.
- New integration:14 tests (29 total new tests) passed at the initial integrated run. Further final results are recorded in the PR.
- Full local Flutter at the integrated tree:994 passed,9 failed,1 existing packaged-native-interop skip. All9 failures are unchanged `norie_classroom_lan_transport_test.dart` cases at `NetworkInterface.list` (`Bad value for ai_flags`). No test was skipped or weakened to hide that host limitation.
- Analysis clean before final integration review; formatting applied.29 renderer Node and24 Anatomy pipeline Python tests passed.
- Release web build passed, including Wasm dry-run compilation; Wasm execution untested. Final-source checks are recorded in the PR.
- Android build attempted locally: blocked by absent Android SDK after engine precache. Packaged Windows cannot execute on this Linux host. Exact-head platform CI is required before merge.
- Local Chromium installation failed with a truncated archive. Actual compiled native flow is therefore covered by the added Windows offline test, pending successful CI:20-item generation with zero charge/inference, independent arithmetic checks, phone viewport, reload/resume, completion/replay reward idempotency and retained deck/receipt after application restart. Successful and failed screenshots are retained; inspect the actual artifact before claiming visual QA.

The first broad local run had stale test assets after dependency bootstrap; it was superseded after recovering unchanged generated Anatomy/audio assets from prior CI, cleaning the generated bundle and rerunning. No borrowed application code or model change is committed.

Independent read-only review found cloud-read deletion, stale proof claims after editing and a final-read owner race. Each has a regression observed RED then GREEN. Further regressions protect foreign-owner native results and ungrounded source/language substitution. This was code review, not qualified academic or medical review. No unresolved reported critical/important findings; human PR review and exact-head CI remain required.

## Phase status

| Phase | Completed in this milestone | Remaining |
|---|---|---|
|0 Audit|Verified baseline/release, PR overlap, lifecycle/quota/cache report|Production-service incident diagnosis would require authorized backend access|
|1 Contract|Request/result/provider/capabilities, error/cancellation, additive compatibility|Real optional provider adapters and broader response contracts|
|2 Native engine|Bounded math, exact counts/seed/proofs, local save/replay/resume, no-repeat coverage UI|Reviewed multi-subject bank and approved editorial activation|
|3 Domain generators|Initial exact integer mathematics|Advanced math, chemical graphs/valence/naming/rendering, independently reviewed40-item Chemistry benchmark|
|4 Validation|Schema/key/choices/proof/source metadata/duplicate/revision checks|Qualified curriculum and semantic/source review; advanced Chemistry golden data|
|5 AI providers|Existing cloud OpenAI/local-AI routes preserved; new abstraction unconnected|Consent/configuration, secure adapters, availability/usage integration|
|6 Fallback/billing|Native never submits inference or debits; unsupported requests fail without topic/source substitution|Server idempotent reservations, provider error sanitization/classification/retries and integration tests|
|7 UI|Free native controls, finite coverage/repeat consent, resume/error/accessibility, guide|Full Native/Hybrid/AI-only selector, unsupported-subject alternatives, physical assistive-tech QA|
|8 Readiness|Targeted/regression/local web evidence and packaged Windows native test|Exact-head CI, review artifacts, physical Android/Windows QA, production signing|

## Files

Core: `docs/HYBRID_QUIZ_BASELINE.md`; execution plan; domain `quiz_generation.dart`, `math_question_evidence.dart`; data `native_quiz_provider.dart`, `hybrid_quiz_router.dart`, `quiz_validation_pipeline.dart`, `question_bank_repository.dart`; tests `hybrid_quiz_generation_test.dart`, `quiz_generation_boundary_test.dart`.

Integration: `norie_study_models.dart`, `norie_study_quiz_session.dart`; `native_quiz_repository.dart`, `norie_study_offline_store.dart`, `norie_study_service.dart`; `native_quiz_generator_screen.dart`, `study_generator_screen.dart`, `study_set_screen.dart`, `study_quiz_screen.dart`, `study_results_screen.dart`; `norie_tutorial_models.dart`; tests `native_study_generation_test.dart`, `native_quiz_ui_test.dart`, `native_quiz_resume_test.dart`, `native_quiz_coverage_ui_test.dart`; `desktop/test/offline-app.cjs`; Windows workflow; this report, handoff and plan tracking.

## Build recovery dependency

All three first core CI runs stopped before code checks at the original legacy skeleton URL404. Separate [PR78](https://github.com/eironmoisesdupra-coder/NorieLearningApp/pull/78), source673e882461d0649988b3ce96bd1a754baf9ba96d, restores only byte-identical already-licensed legacy models from the checksum-pinned official v0.18.0 archive. Core77 and this branch include its same patch for exact-head CI. Six new recovery plus24 existing Python tests and actual archive/model recovery passed, independently reviewed. Model geometry, mapping, calibration, attribution/license terms are preserved. No binary was committed. The initial red runs are historical evidence. The first repaired full suite exposed a source-layout assertion; its replacement executes the actual asset command and compares byte-verified output/provenance with the unchanged Dart calibration. All12 Anatomy Lab tests passed locally. Replacement exact-head CI must pass before merge.

## Integration and release gates

Merge/rebase build repair78 and core77 first, then integration after review and green exact-head checks. PR72 separately edits StudySetScreen and must be reconciled without dropping its accuracy gate. Anatomy73–76 remain independent; their pending hint/policy/desktop-test changes are not silently included or replaced. No changes to main, production databases, subscriptions, keys, assets/licenses, mascot/ranks/shop or release version. Review builds are previews, not a new published release. Do not merge/deploy from this report alone.
