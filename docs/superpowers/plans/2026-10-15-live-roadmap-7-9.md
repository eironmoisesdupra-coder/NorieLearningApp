# Roadmap 7–9: live learning adventures

Goal: Publish Boss Missions, a Subject World Map and educational collectible cards on current develop d0fe7d6b24229e8c8e786e462e865c1cde881df6.

Spec: October 15 user request and existing approved progression blueprint. No additional roadmap 7–9 source archive exists in Downloads or the current branch. Implement against the existing authored curriculum, not stale WIP source.

Architecture: Keep the existing grade maps, assessments, progression and profile serializers. Split real authored paths into chapters of at most five lessons. Each optional boss samples independent foundation and transfer questions from that chapter, with at least five distinct items and an 80% unrounded passing threshold. Boss entry requires its lessons complete; lessons and reference tools remain accessible. A content-fingerprinted boss receipt awards one permanent knowledge card, never XP or league points. Retries do not duplicate rewards. Existing account guards, durable saves, backup and cloud merge carry these receipts without schema changes.

The world map shows only actual subject/grade paths, their honest completion counts, and links to current grade adventures. Five subject islands offer a list alternative and small-screen layout. Pilot subjects display Grade 1 only. Educational cards contain real chapter lesson explanations/objectives, ownership and earning requirements, and link back to study. Earned cards can use the existing profile trophy showcase; unearned cards cannot be equipped. Full-body Norie assets remain intact.

## Tasks
- [x] Boss model and tests: stable/content-aware IDs, chapter boundaries, transfer coverage, no unknown/unavailable topics, five distinct items on a one-lesson final chapter.
- [x] Boss screen and progress: explicit optional preparation, blocked until prepared, pass/fail/retry, durable idempotent reward, owner-switch safety, no lesson evidence or XP inflation. Integrate in grade map/list.
- [x] World map and tests: subject islands, actual grades only, live completed/current counts, accessible list route and grade navigation; entry from Learn.
- [x] Collectible gallery and tests: meaningful source-linked knowledge cards, earned/locked filters, correct per-account ownership, profile entry and showcase label.
- [ ] Full regression, phone/offline output review, version 0.8.0+12, focused commits, independent review, PR/develop CI and exact-revision Windows/Android release.

## Review focus
- Partial chapters, curricula expansion and reordered topic input must not revoke or mislabel old receipts.
- An account switch during a mission must never award the next learner.
- Failed local saves must not show confirmed success until retry; completed receipts are idempotent.
- Existing adaptive practice, legacy chapter rewards, league bank and account serialization remain compatible.
- 320px phones, enlarged text, reduced motion and offline navigation must work without filler grades or lessons.

Ruling: User explicitly requested implementation and publication. Proceed within that authorization without requesting repeated design or release permission. Parallel work is confined to separate UI/model files; root owns boss policy, persistence, grade integration and release.

Verification: final local analysis clean, 579 Flutter tests passed, 16 web cache/update/download/release regressions passed. Independent review addressed boss improvement duplication and misleading replay reward announcement. Release web build, phone output and platform CI/publication tracked in handoff/PR.
