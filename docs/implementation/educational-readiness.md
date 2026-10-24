# Educational readiness follow-up — 2026-10-23

Baseline: `develop` at `ed9472dbb437127abd8fd09931a86879d4df5ec5`, source 0.18.0+24. PR71 records that Preview as published with successful Flutter, Windows, Store-readiness and deployment workflows. Current follow-up is a separate candidate, with no version bump, deployment or production claim. Existing PR72 source-accuracy work remains separate.

## Inspection and scope

PR65 is merged, not pending. It deliberately removed the unsafe paid-hint debit path. PR66 already enriched three canonical Mathematics/Science lessons; PR67 prepared default-disabled publication; PR68 added separate owner-bound Anatomy study/view backups. The actual handoff is `docs/NORIE_CURRENT_HANDOFF.md`. This environment has a fresh clean checkout; no files on the owner's Windows checkout were available or changed.

This follow-up targets coarse-name inference in free Anatomy hints, three existing English lessons, and guided-study load recovery. It preserves all canonical lesson/question IDs, quiz scoring, XP/credits, saved schema versions, existing backup integration, Classic/Adventure routes, avatar/rank/shop/mascot systems and licenses.

## Anatomy approval and payment boundary

Both free guidance and answer feedback must distinguish atlas catalog metadata from independently reviewed anatomical descriptions. Similar names, laterality prefixes and alternate references cannot authorize exact-part facts. There is no qualified fact bank or atomic durable debit/reveal implementation. Paid activation remains blocked; unavailable hints cost zero. No five-credit purchase is advertised as implemented. Existing scoring and unavailable-hint tests remain required.

Catalog/mesh binding and automated geometry checks are technical checks. They do not certify anatomical correctness for every structure or replace a qualified content review.

## English teaching additions

Three canonical lessons receive original independent transfer, a separately revealed reasoning rubric and next-day retrieval. Existing objectives, worked/guided examples, diagrams, eight practice and three mastery questions remain unchanged.

| Lesson | Independent task and answer audit |
| --- | --- |
| Grade 1 Nouns | In “The dog chases a ball,” dog and ball name an animal and a thing; chases expresses the action. A new school/bag sentence supports delayed retrieval. |
| Grade 7 Sentence Variety | Combine muddy path / continued walking to express contrast. “Although the path was muddy, we continued walking” contains a dependent clause followed by an independent clause. A compound alternative with but also preserves the contrast. A comma alone cannot join the two independent clauses. |
| Grade 11 Source Evaluation | Invented dated library logs can support a bounded visit-count claim, but cannot establish that every pupil learns more. Repeated copies of an advertisement are not independent corroboration. A further invented trial separates attendance from comprehension measures. |

Written responses are self-check activities, not automatic free-text grading or new reward sources. Grade 1 learners may point, speak or draw. Alternative grammatically sound Grade 7 answers are accepted by the rubric if they preserve the intended relationship. All research scenarios are explicitly invented; no real school study or result is implied.

Primary concept references inspected on 2026-10-23 (links only, no reproduced exercises or passages): [Purdue OWL sentence variation](https://owl.purdue.edu/owl/general_writing/academic_writing/sentence_variety/index.html), [Purdue OWL evaluating sources](https://owl.purdue.edu/owl/research_and_citation/conducting_research/evaluating_sources_of_information/general_guidelines.html). The noun task uses the existing lesson's person/place/animal/thing definition. These references support authoring; they do not confer qualified editorial approval. Wider curriculum enrichment and educator/learner review remain pending.

## Publication workflow: existing preparation versus requested completion

| Requested state | Existing implementation | Remaining work |
| --- | --- | --- |
| Draft | Local Studio drafts are untrusted | No change to publishing authority |
| In Review | Immutable submitted revision | Editorial workflow UI and deployed validator |
| Approved | Independent scoped approval plus digest/evidence | Qualified reviewers provisioned by authorized operator |
| Published | Scheduled revision plus gated registry event | Protected signer, Flutter verifier/cache adapter, explicit activation |
| Archived | Retirement event / historical approved revisions retained | User-facing archive representation; names are not an exact enum match |

Rejection requires a new immutable revision. Rollback references an approved previously published revision; history and downloaded learner data are not rewritten. Current fixtures exercise authorization, revocation, hashes and rollback, but PGlite serializes sessions and is not a deployed Supabase audit. No production schema is applied. Protected signing, real multi-backend contention, gateway/JWT/RLS verification and reviewed content remain activation blockers. This phase is preparation, not a completed operational publication system.

## Offline recovery contract

Unreadable, oversized, incompatible or partly invalid guided-study snapshots must remain intact. A failed restore cannot be treated as an empty ready-to-save session; flush/reset/selection must not replace it. Validate all entries before adopting any. Offer explicit loading retry after storage becomes available. Retrying must invalidate stale owner/model callbacks and preserve A→B→A account boundaries. Other offline lessons and atlas exploration remain available; a damaged saved guided session is held for recovery rather than silently discarded.

Existing separate Anatomy backup remains separate from general progression backup. Combining those stores still needs a shared recoverable transaction boundary; do not claim this follow-up supplies one.

## Validation

The execution ledger in `docs/superpowers/plans/2026-10-23-educational-readiness.md` and the PR record actual executed commands/results. No unrun check, physical-device test, subject-expert signoff or production readiness is implied by this document.


### Executed validation for this candidate

Flutter 3.47.7 / Dart 3.13.5, Linux host. No package or lockfile change is included.

| Check | Actual result |
| --- | --- |
| Changed Dart files formatted; `git diff --check` | Passed |
| `flutter analyze --no-pub` | No issues |
| Nine affected Flutter test files | 76 passed |
| `flutter test --no-pub --reporter expanded` | 975 passed, 9 failed, 1 existing packaged-interop skip |
| Anatomy renderer Node suite | 29 passed |
| Anatomy Python suite | 24 passed |
| Anatomy source audit | Zero critical errors |
| Offline web cache/update/download/release-shell tests | 16 passed |
| Publication offline verification | Passed signatures, hashes, schema/budgets/assets/dependencies, replay and signed rollback; 3 additional regression tests passed |
| Isolated publication PostgreSQL fixture | Passed authorization, immutable approvals, revocation, gates and rollback; serialized PGlite only |
| Desktop `npm test` | 9 passed, 10 failed; all failures in unchanged LAN transport tests |
| Web release build (`--no-web-resources-cdn`) | Passed; JS release built, Wasm dry run succeeded (Wasm runtime not tested) |
| Android release APK attempt | Blocked: no Android SDK |
| New Windows package / installed native QA | Not built or executed on this Linux host |
| Actual browser QA | Not executed: Chromium installation failed with truncated ZIP archives |

The nine Flutter failures are all in `test/norie_classroom_lan_transport_test.dart`, at `NetworkInterface.list`, with `SocketException: Failed listing interfaces (OS Error: Bad value for ai_flags)`. A standalone Dart program containing only `NetworkInterface.list()` reproduces the same host error. Desktop LAN failures likewise report `uv_interface_addresses` errors. No LAN source or tests are changed, and no test was disabled or relabeled as passing. Remote CI on a supported runner must confirm the full suite before review/merge.

The targeted tests include real 320px / 160% text interactions, free/unavailable-hint charging safety at 0/4/5/10 credits, unchanged scoring and canonical lesson/reward IDs, owner changes, stale renderer and button callbacks, load/flush/reset preservation, portable backups and the existing Mathematics/Science pilots. They do not provide complete anatomical geometry/medical certification, physical-device certification, or browser/native offline-startup evidence.

Independent read-only review raised two important issues, both reproduced and fixed with regression tests: incomplete snapshot validation and stale mutation callbacks. The follow-up stale recovery-control regression was also reproduced before fixing. The tutorial's selected-length guidance was corrected. Human PR review and exact-head CI remain merge gates.

Release assessment: **partial implementation; not production-ready, no merge or deployment**. Paid five-credit debit/reveal, qualified anatomical facts, wider curriculum enrichment, operational publication infrastructure, physical-device/installed-cache QA and production signing remain pending. The current published downloads remain 0.18.0+24 Preview, source `ed9472dbb437127abd8fd09931a86879d4df5ec5`: [Windows ZIP](https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/download/v0.18.0/NorieLearning-Windows.zip) and [Android APK](https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/download/v0.18.0/NorieLearning-Android.apk). Neither package contains this follow-up.
