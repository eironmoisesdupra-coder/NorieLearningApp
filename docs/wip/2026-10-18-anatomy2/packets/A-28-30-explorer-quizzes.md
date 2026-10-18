# Phase A — #28 Explorer UI 2.0 + #30 Flexible Anatomy Quizzes

## #28 deliverables
- Responsive Explorer screen with compact always-visible model viewport; collapsible Search/Systems/Selected Details controls and explicit reference selector.
- Beginner / Advanced mode: beginner short accessible terms and help; advanced anatomical IDs and detailed filters. These are modes of presentation, not fabricated scientific content.
- Body-region index only when mapped to source anatomical identifiers; no heuristically mislabeled structures.
- Selected details panel: name, reference, system, source ID and verified content when available; indication when educational description unavailable.
- Search by names/IDs plus curated synonyms from approved mapping only; sanitize query, accessible empty/loading/error states.
- Clear gestures controls, reset/front/back/side camera, isolation/hide/restore and opacity. Avoid losing selection across display panel changes.
- Existing links to Skeleton Fundamentals and Norie tutorial must remain.

## #30 deliverables
- Configure 5, 10, or 20-question sessions subject to eligible distinct structures; report counts and never duplicate prompts silently.
- Guided, Standard, Challenge difficulty with no unfair XP/academic penalty for accessibility/help.
- Initially implement grounded identification and system/location questions from validated data. Add function, relationship, interpretation and misconception questions **only with vetted authored answer/feedback data**.
- Distinct progress states for identify / learn / mastered; prevent repeated XP farming and preserve old reward policy unless reviewed migration approved.
- Answer-by-answer explanation, opt-in hint, question review, correct-answer summary and retry.
- Empty system/reference and low-question-count fallback.

## Required tests
- 320px / 160% text, keyboard tab order, semantics, orientation and modal scroll.
- 5/10/20 validity, insufficient pool, duplicate avoidance, hint/mode switching, XP idempotency, save persistence.
- Existing anatomy quiz and hotspot tests remain green.
- Real compiled browser interaction including model click, search/select, quiz finish, progress persistence.
