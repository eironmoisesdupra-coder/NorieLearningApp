# Strict Codex integration instructions

Repository: eironmoisesdupra-coder/NorieLearningApp, branch develop. Read current repository before coding. Do not replace current Learn, World Map, Quiz, XP, seasonal content or Anatomy systems. Create a separate branch and PR for the pilot; no main changes.

## Delivery order
1. Review existing curriculum and select an appropriately authored evaporation lesson, or deliver pilot as explicitly ungraded experimental content. DO NOT invent that an existing lesson includes objectives it does not.
2. Integrate the domain model after verifying Dart compatibility; add more transition, corrupted save and learner-switch tests.
3. Build accessible Flutter 2D scene with player sprite/placeholder vector drawn in code (no external copyrighted sprite), four-direction movement, touch controls, keyboard shortcuts, focus/semantics, and large-screen constraints. No high frequency background tick while idle.
4. Add tap/proximity inspection of five props, no pixel-hunt required. Include a list-based accessibility alternative identical in capability.
5. Add Norie dialogue and expressions tied only to truthful state changes. For wrong hypotheses, show helpful evidence-based feedback, not shame or punishment.
6. Build a controlled virtual warm/cool evaporation illustration. Clearly mark conceptual/not calibrated; keep all other variables fixed. Provide readable labels and reduced motion.
7. Separate assisted hints from independent application; guided/independent completion is not automatically prior course mastery.
8. Save with owner-scoped generation guards, write serialization and corruption recovery. Restore must validate before mutation, reject cross-learner writes (including A→B→A), and never overwrite higher-trust progress.
9. Journal entries idempotently for the same mission/revision. Do not issue XP/credits until formally reconciled against existing reward receipt system.
10. QA: 320px screen, 160% text, keyboard-only, touch, reduced motion, offline network-blocked, browser reload, Windows packaged app, Android physical when available. Verify route inactivity pauses animations; no user tracking.
11. Merge only after clean analyzer, full Flutter suite, web and Windows CI, store-preflight, and independent visual review. Release via existing exact SHA Preview pipeline with owner approval.

## Acceptance tests that must fail if wrong
- Cannot complete without all three clues, both trials, correct hypothesis, and independent transfer.
- Cannot complete by navigating back/forward or editing local JSON.
- Reset/replay does not duplicate Discovery Journal or XP; no credit spend.
- Learner switch during pending save cannot leak another learner's case or journal.
- Touch and keyboard interactions lead to identical outcomes.
- Reduced motion stops nonessential animation; scene remains fully playable.
- Broken asset, no local storage, cancelled navigation all produce recoverable UX.
- Browser offline works after installation; no remote dependencies.
- Notification permissions are never requested by this MVP.
- Demo does not claim physical-device certification or educational efficacy without evidence.

## Pilot validation
With appropriate consent/permission, use a small group of intended learners. Observe task clarity, real learning (independent before/after), enjoyment, and optional delayed recall. Do not infer general success from just XP or completion counts.

## Explicitly blocked for this PR
No 3D open world, push notification campaign, guilt/streak pressure, paid narrative content, social leaderboard, unreviewed medical content, or automatic release.
