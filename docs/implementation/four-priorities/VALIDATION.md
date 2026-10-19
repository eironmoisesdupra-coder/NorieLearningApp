# Four-priority follow-up validation

Baseline: `17a5196f3cb2cd14903cd6673930bad5390acf00` (`develop`, 0.16.0+21 Preview).
Candidate: 0.16.1+22 Preview. See the release metadata for its final source SHA,
package checksums and signing status. This record is evidence of the checks below,
not a claim of production activation or complete delivery of every archive item.

## Implemented scope

- PR65: exact target/reference readiness and fail-closed 20-question hints.
  No paid hints or credit debits. Short-quiz hints, free answer feedback and
  10 XP per correct answer remain available.
- PR66: three existing lesson pilots: G1 Science living/nonliving, G7 Mathematics
  proportions and G11 Science mechanics. IDs and reward quantities are preserved.
- PR67: default-disabled database publication boundary and signed offline
  verification protocol, tested in disposable fixtures. No production migration,
  protected signer, client installer or approval authority has been deployed.
- PR68: separate owner-bound Anatomy study/bookmark export and merge, paired
  persistence, failure recovery and conservative study evidence. Imports do not
  create XP, credit or mastery receipts. Legacy full backups preserve omitted
  Anatomy. A single atomic full-progress-plus-Anatomy restore is still pending.

## Automated and rendered evidence

- `flutter analyze --no-pub`: no issues.
- Full `flutter test --no-pub --concurrency 4 --reporter expanded`: 898 passed;
  one existing packaged-Windows interop test skipped in this local invocation.
  Windows CI separately exercises packaged native interop; consult exact-head CI.
- Web release build succeeded, including the Wasm dry run. Browser-tested combined
  runtime `main.dart.js` SHA256:
  `8faaa4bdd46945a53f120cd078adda333b3a83f4b44b0a34026d98581258102c`.
  That build predates the metadata-only 0.16.1+22 version bump. Final release
  artifacts must come from successful CI at the release source revision.
- Anatomy renderer: 29 Node unit tests; actual WebGL picking after idle,
  orbit/damping, visibility, resized render, context loss/restore, load retry
  and disposal passed with outbound networking blocked.
- Anatomy Python suite: 24 tests passed; coverage audit reported zero critical
  errors. This is a technical audit, not qualified anatomical approval.
- Publication: actual isolated Postgres/PGlite authorization and immutable hash
  checks, plus WebCrypto Ed25519 offline fixtures passed. Review caught and fixed
  approved-asset digest binding and the publication-history boundary.
- Quiz browser: all 35 questions across 5/10/20 modes used exact model targets,
  visible meshes and unique options. Correct 20-question completion awarded
  200 XP once; two reloads did not duplicate it. Guided/Challenge, 320px at 160%
  text, reduced motion, left/right models, six reference families and actual
  context-loss Retry were exercised. No JavaScript page errors.
- Lesson browser: 12/12 cases (three pilots, 320/390px, 100/160% text, reduced
  motion). Independent prompts precede answers; actual reveal controls work.
  Computed Chrome accessibility names include answers in every case. Playwright
  snapshots omit some Flutter expansion names, so full Chrome AX trees were
  checked as well. Representative screenshots show readable wrapping without
  horizontal overlap. Optional external fallback fonts were intentionally blocked;
  teaching/reveal checks still passed. No Flutter overflow/exception was reported.
- Anatomy backup browser: six actual FilePicker checks passed: export/import,
  idempotent merge, wrong-owner/corrupt rejection, offline reload/reimport and
  legacy full-progress restore preserving Anatomy. Rewards remained unchanged.

Local evidence logs, JSON, Chrome AX trees and screenshots are under ignored
`build/four-priorit*`. They are browser/desktop automation evidence, not physical
Android/Windows device certification or independent human educator signoff.

## Remaining gates

1. Paid hints need qualified approval of exact-structure facts and a durable,
   idempotent debit/reveal transaction before activation. Current cost is zero.
2. Publication needs production roles, consent, reviewed content, protected signing,
   migration review and the Flutter verification/cache installer. Default is off.
3. Full progression and Anatomy need a shared identity-aware restore transaction
   before they can honestly be advertised as one atomic portable backup.
4. Three pilot lessons are not a completed curriculum. Human educator review,
   broader content rollout and physical-device acceptance remain pending.
5. Production signing, public support contact and privacy-policy gates remain
   pending. Native downloads stay labeled Preview.
