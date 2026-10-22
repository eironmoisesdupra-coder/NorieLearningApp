# Discovery Adventure Preview candidate

Target version: **0.17.0+23 Preview**, branch `feat/discovery-adventure-mvp`,
[PR #70](https://github.com/eironmoisesdupra-coder/NorieLearningApp/pull/70).
Baseline: current develop `899b7ab5458583fd8cc5558aca6cc0ba3c444007`.
The user confirmed `NorieLearning-Discovery-Adventure-MVP-WIP.zip` and requested
its implementation. The original dirty checkout is preserved.

## Delivered activity

Open **Learn > Activities > Discovery Adventure**. The Case of the Vanishing
Water is an optional, experimental, ungraded investigation suggested for Grades
4–6. It supplements evaporation study; it does not replace the whole Grade 5
Water Cycle lesson or issue verified course mastery.

An original code-drawn Explorer moves through a 2D room using arrows/WASD and
E/Enter, or touch movement/inspection controls. All five props also appear in a
capability-equivalent list. Three observations, both controlled warm/cool trials,
a correct hypothesis with comparison evidence, and a fresh damp-clothes
application are required before the local Discovery Journal records completion.
The comparison is qualitative and explicitly not calibrated physics. A dry table
alone never proves that no spill occurred; water becomes invisible vapor rather
than being destroyed.

The existing full-body Norie supplies optional dialogue and expressions. Case
effects start muted. Skipping dialogue does not skip evidence or application.
Movement is event-driven; focus, route and lifecycle guards reject inactive
input. No idle game timer or new runtime dependency is introduced.

## Persistence and invariants

- One owner/mission/revision envelope serializes fresh reads and writes across
  live store instances. Owner generations include A→B→A and old UI callbacks.
- Invalid, oversized, cross-owner and impossible-state saves are rejected before
  mutation. Corrupt data is retained; retry and explicit temporary play remain
  available. Temporary completion never claims a durable save.
- A stale-generation write is compensated while holding the owner queue. If
  compensation fails, subsequent loads stay blocked until recovery succeeds.
  Recovery survives store disposal within the process; no fsync/power-loss
  durability guarantee is claimed.
- Reset clears answers and stage evidence while retaining revision-lifetime
  assistance, application-attempt history and the original journal. Reload and
  replay do not duplicate that entry or disguise past practice as a fresh attempt.
- This activity does not mutate XP, credits, course mastery or reward receipts,
  request notifications, require sign-in, upload case data, or fetch remote assets.
  Existing lessons, maps, seasonal activities, Anatomy, licenses and account hooks
  remain intact.
- The journal is local and unverified. Validation rejects malformed/impossible
  state; an offline client cannot cryptographically prevent someone fabricating
  an otherwise valid local JSON history. The journal is never a reward authority.

## Verification evidence

The complete feature at `07627da38a7f8bc22c20ef29fe6ffa79b53969ce` passed:

| Requirement | Evidence |
| --- | --- |
| State/store/UI and existing app regressions | Clean `flutter analyze`; full `flutter test`: 944 passed, one existing environment-dependent native interoperability skip; includes 46 Discovery tests |
| Web build | Release build succeeded; normal deploy-pages offline preparation applied |
| Small screens/accessibility | Actual compiled 320/390px × 100/160% text, reduced motion; keyboard room, touch/list, reachable feedback and all stage gates |
| Save/reload/replay | Compiled browser and actual packaged Windows: completion/reload/replay, cleared answers, retained attempts, one unchanged journal and unchanged reward keys |
| Installed browser offline | Exact-source custom worker installed; browser offline plus server returning 503; resumed a clue, completed case, retained journal after another reload; zero successful network responses |
| Native Windows | Actual packaged Electron, fresh profile and network disabled; full mission/reload/replay passed; native captures inspected |
| Exact-head CI | Flutter CI [39779845838](https://github.com/eironmoisesdupra-coder/NorieLearningApp/actions/runs/39779845838), Windows [39779846006](https://github.com/eironmoisesdupra-coder/NorieLearningApp/actions/runs/39779846006), Store readiness [39779845982](https://github.com/eironmoisesdupra-coder/NorieLearningApp/actions/runs/39779845982): all successful |
| Independent review | Code review findings reproduced RED then fixed GREEN; independent actual compiled screenshot review found no remaining product defects |

Five review fixes have regression proof: replay history retention, failed ABA
rollback quarantine, cleared replay selections, repeat hints after reload, and
visible inline incorrect-answer feedback. No second review loop replaced those
tests. Local logs, JSON results, computed accessibility trees and screenshots are
preserved under ignored `build/discovery-*`. The verified compiled JS SHA256 was
`f425c42c225b82b8c72c84d1dd5ac5dde5ed630c531d0ac7ba5ca05ee0291c15`.
Hidden Windows capture used actual native content bounds and awake captures;
synthetic viewport/stale-frame harness artifacts were corrected without product
changes.

The 0.17.0+23 packaging change separates this candidate from public 0.16.1+22.
A subsequent compiled recovery probe uncovered an optimistic SharedPreferences
cache issue that normal save/replay tests did not cover: after a denied write,
retry/reopen could accept memory-only evidence as saved. Discovery now reloads
platform preferences before each read. Four adapter regressions observed RED then
GREEN cover false/throwing writes, durable retry, reopening a failed completion
without a phantom journal, and observing backend changes. Existing injected
store and screen regressions also passed. Current-head full CI, compiled
recovery and candidate downloads are recorded in PR #70; historical results
above do not claim that a later head has passed those checks.

## External gates and publication

Physical Android testing, qualified educator review, consented learner testing,
measured 5–8 minute pacing, educational efficacy and delayed recall remain
unverified. Android APK/AAB compilation is CI evidence, not hardware certification.
The activity remains experimental and ungraded. No server configuration is
needed for its offline features. Existing production signing, public support and
privacy-policy gates remain pending as previously agreed.

The supplied `CODEX_TASK.md` item 11 requires owner approval for the exact-SHA
Preview pipeline. The owner has approved publication after green Flutter,
Windows and Store readiness checks at the latest PR head, final review, develop
merge, merged-source CI/web validation and verified dual-platform versions and
checksums. No release is implied by this file or green PR checks alone. Use the
established PR, green CI, develop merge, merged-head verification and exact-SHA
Preview workflow. Never push or merge into main. Final handoff must identify
both PC/APK packages and their actual revision; CI artifacts are temporary
GitHub-authenticated downloads, not durable public release assets.
