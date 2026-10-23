# Explorer, subject choices, ranks, and a dependable app guide

## Intent and authority

Implement the five packets in the owner's 2026-10-23 subject-choice/avatar/rank WIP, plus their explicit request to improve the complete tutorial and repair steps 20–28. The owner confirmed all five packets are in scope. The newer instruction requires frame-by-frame cartoon animation; it supersedes the packet's optional rig suggestion. Norie remains the existing full-body companion. The Explorer is a separate learner character.

## Approach

Extend existing subject, appearance, tutorial, and rank components. Preserve saved internal rank IDs, levels 1/5/15/30/50, XP, credits, inventory, learner boundaries, and existing routes. No dependency or backend schema is required. A 3D avatar would add weight without serving the requested cartoon style; segmented rig animation contradicts the clarification. Use complete authored poses played as discrete frames, with actual expression and silhouette changes rather than interpolating a still image.

## Visible behavior

- Each existing subject hub offers Classic Lessons and Adventure Mode. Science links the released Vanishing Water pilot; other subjects show curriculum-related, explicitly unavailable previews. Existing lessons remain one tap away. An adventure does not grant duplicate lesson rewards.
- Appearance Studio and profile show a separate interactive Explorer. Offer skin, head/hair, outfit, and accessory choices saved through the established appearance persistence/backup/account hooks. Do not change an existing user's equipped choices silently. Show idle/blink and a wave reaction, respect reduced motion, lifecycle, and offscreen ticker mode. Final original art must be inspected; scaffolding must not be described as final hand-drawn art.
- Visible rank names become Rookie, Explorer, Scholar, Expert, Professor with simple pencil/compass/book/science/graduation motifs. Keep internal cosmetic IDs and old-title aliases. Old earned cosmetics and unlock levels remain valid.
- The entire tutorial receives consistent illustrated chapter identity, short actionable prompts, visible chapter/step progress, lively restrained transitions, and accessible controls. Keep searchable Contents, Back, Close, replay, spotlight tracking, and completion behavior. Never require a purchase, upload, AI request, or assessment submission to finish the tour.
- Library/edit/review/Q&A tutorial steps use a clearly labeled offline sample workspace, independent of real cloud/library availability. Interactive examples remain in memory; they never save sample decks, submit requests, mutate reviews, or award rewards. The ordinary library retains real errors and Retry rather than misrepresenting an unavailable cloud library as empty. Closing the tour returns to the original route and draft.

## Verification and limits

Pin offline sample isolation, all affected tutorial steps, navigation cleanup, frame changes/reduced motion, cosmetic save compatibility, rank aliases/thresholds, and subject availability with meaningful tests. Run analyzer, full tests, web and Android builds, desktop/browser layout and offline smoke checks. Inspect output at phone/desktop sizes and enlarged text. Follow a PR into develop and exact-revision CI; never update main. Store signing, real payment subscriptions, and new adventure curriculum are outside this change.
