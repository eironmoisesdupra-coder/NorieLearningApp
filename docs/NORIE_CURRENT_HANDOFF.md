# NorieLearning Current Integration Handoff

Updated 2026-10-09. Current source prepares Flutter **0.6.1+10** and desktop **0.6.1**, integrating Roadmap Part 1 from the supplied 0.6.0+9 WIP ZIP.

## Workspace and publication

Active worktree: `C:/Users/ronaldo.dupra/Documents/NorieLearning-integrate`. Branch `feat/roadmap-1-curriculum-depth`, based on develop `9b0ddb12246180eaac81c04751d92d1a0dde4fef` (published 0.6.0+9, PR #39). The original dirty checkout and older WIP worktrees remain preserved. GitHub release metadata identifies the exact package revision; publication requires green Android and Windows push builds for that exact develop SHA.

## Roadmap Part 1

- Production curriculum paths validate 6?20 authored missions; future authored additions retain dynamic counts/maps/chapters instead of padding to a fixed size.
- Long-term per-subject/grade targets are developer guidance only. All 234 current lessons remain unchanged, six in each of 39 paths. This release does not claim expanded content already exists.
- Unknown subjects/grades return no curriculum, rather than fabricating a Science path.
- Existing legacy five-mission rewards, IDs, maps, local saves and account hooks remain unchanged.
- Parts 2 (additional subjects) and 3 (skill graph) are outside the user's current request. The ZIP installer was not executed; its missing patch/stale UI anchors were integrated manually only where Part 1 required them.
- New policy/registry regressions and expanded map checks exercise 6, 7, 8, 19 and 20 missions, including 320px with enlarged text; legacy five-mission behavior remains covered.

## Implemented scope

- 234 authored offline lessons: 78 each in Science, Mathematics and English, six per Grade 1–12 or college course path. These focused units do not claim to replace national curricula or entire college courses.
- Preserved original lesson IDs, rewards, approved Grade 1 Science content and completion history. Added 39 focused units and replaced 125 generic Math/English previews. New units have objectives, real explanations, useful diagrams/models, worked reasoning, guided solutions, common mistakes, recap and separate practice/mastery questions. Shuffled questions carry required passages and quantities.
- Illustrated maps for all three subjects; dynamic lesson counts, saved position, grade switching, chapter summaries, optional mixed expeditions and accessible list navigation. Reference anatomy and essential learning remain available.
- Separate completion, independent-practice and retained-understanding stars. Independence requires at least 80% on five distinct items; retention requires a successful independent review at least 24 hours later. Hints/self-rating cannot certify mastery. Short mistake drills use actual missed concepts.
- Permanent original/expanded path trophies, chapter emblems, improvement badges, lesson retention badges and whole-path mastery trophies. Durable assessment receipts protect XP from result remounts/retries. Saves complete before reward reveals.
- Offline appearance studio: original avatars and full-body Norie poses, readable palettes/accents, frames, preview/save/cancel/reset, presets and earned trophy showcases. Existing levels 1, 5, 15, 30 and 50 unlock permanent cosmetic bundles and showcase/preset capacity.
- Reward/appearance state participates in validated backups and account sync. Explicit recovery-first guest transfer and identity guards isolate restores, results and editor saves. Same-owner merges retain permanent collections and local appearance choices. Conditional database saves reject stale snapshots and refetch before retry.
- Optional private leagues with nearby ranks, ties, season state, permanent emblems, opt-in display, administrator-approved invitation requests, reporting and display removal. Personal bests work offline; cached standings show their timestamp.
- Live server-issued five-question attempts use all 234 authored lessons in separate subject-grade groups. At least 80% earns 10 points once per lesson/season; six opportunities per cohort can reach all five cosmetic tiers. Local XP, AI usage, speed and client-submitted scores never certify ranking.
- Prior offline cache/update safety, backup recovery, Continue Learning, audio/SFX, quiz outro, full-body mascot, anatomy paths/calibration and licenses remain intact.

## Verification and backend

Prior 0.6.0 baseline: Flutter analysis clean and **513 tests passed**. Part 1: analysis has no issues, all 520 Flutter tests pass, 16 web update/download/release regressions and seven desktop asset/audio tests pass, and the release web build passes. Final platform/deployment evidence is in exact-revision Actions runs. Node worker/update/download/release/league tests: **30 passed**. Real PostgreSQL checks: **35+ league assertions and 20 guarded-cloud assertions passed**. Independent review recomputed 105 Math keys and checked 395 numeric distractor sets. Standalone assessment regressions cover 47 data/source cases. The final review's full-storage startup regression is fixed: failed optional collection writes retain in-memory milestones and allow the offline library to open; explicit retry persists them.

Actual phone maps and appearance views were inspected. Appearance presets saved and survived reload with external networking blocked. The packaged Windows app passed cold offline launch, real anatomy interaction, 20 Math quiz answers, three challenge rounds and XP persistence after closing/reopening. Native audio decoding, disable/re-enable and persisted mute tests passed. Its smoke navigation now presses Start mission after opening a map node. Platform CI supplies final exact-revision package and release checks; consult Actions/release metadata for their final state.

Supabase project `lafuuwoohizgwnrbbgqj`: three league migrations and the owner-bound compare-and-save migration deployed. Edge verified-leagues **v3**, JWT verification enabled, bank **authored-9f41785c**. Live rollback permissions checks passed; unauthenticated POST returns 401 and OPTIONS 200. No groups, eligibility or participants were provisioned. An authenticated participant staging run has not been performed.

## Product limits

This remains a public preview. Windows is unsigned; Android uses preview/debug signing until production signing is provisioned. Back up progress before replacing an Android installation signed with a different key. Account services retain the private-demo approval gate.

Competition needs trusted administrator setup and invitations. Public discovery, global mixed-subject boards and public child profiles are not enabled. Local photos remain the blueprint's optional later extension. Cross-device XP uses the greater snapshot rather than summing potentially duplicated independent device awards; conflict-free accumulation of every legacy counter is not claimed. Legacy direct-save compatibility remains, so concurrency guarantees apply to cooperating updated clients.

## Downloads and next integration

The [download page](https://eironmoisesdupra-coder.github.io/NorieLearningApp/downloads.html) reads complete verified release metadata. Expected durable 0.6.1 links become available after the trusted publisher succeeds:

- Windows: https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/download/v0.6.1/NorieLearning-Windows.zip
- Android: https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/download/v0.6.1/NorieLearning-Android.apk
- Web: https://eironmoisesdupra-coder.github.io/NorieLearningApp/

Continue through PR → green CI → develop merge → preview verification → exact-revision release. Never push or merge main without explicit instruction. Final handoffs must state the real head SHA, CI status, both platform revisions and any unavailable updated package.
