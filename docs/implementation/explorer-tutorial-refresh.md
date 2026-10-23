# Explorer and tutorial refresh — 0.18.0+24 Preview

The 2026-10-23 WIP is a design brief, not a source-code archive. Its five packets are implemented on `feat/explorer-tutorial-refresh` from develop `31d24151d2fb05031042df797d9afb49e82445bc`, together with the owner's tutorial repair request. The original dirty checkout is preserved. Use the PR for the exact candidate SHA and current CI/publication status.

## Implemented checklist

- [x] Classic Lessons and Adventure Mode in the active grade-selection subject pages, including World Map entry points. Classic keeps the existing lesson/grade destinations.
- [x] Curriculum-related adventure hub for Mathematics, Science, English, Filipino, and Araling Panlipunan. Only the previously released Science Vanishing Water pilot launches. Other missions explicitly say planned preview/not playable.
- [x] Learner Explorer separate from Norie, visible in the shared Profile/Appearance Studio preview. Original complete vector poses provide idle/blink, preparation, wave and settling; no articulated rig or interpolated still-image rotation is used for this character.
- [x] Skin, hair, outfit and accessories in the existing isolated studio draft; Save/Cancel/presets/backup/account snapshot hooks remain authoritative. Existing equipped cosmetics and earned unlocks remain intact.
- [x] Rookie / Explorer / Scholar / Expert / Professor at unchanged Levels 1 / 5 / 15 / 30 / 50, using original educational pencil, compass, book, science flask, and graduation artwork. Internal cosmetic IDs and old-title aliases remain compatible. Private league tiers are a separate unchanged system.
- [x] Every guide step has illustrated chapter context, an actionable cue, and animated accessible progress. Searchable Contents, Previous, Close, replay, spotlight tracking and completion remain available. Minimize/Show guide makes samples easier to use.
- [x] Steps 20–28 use a visibly labeled, offline, in-memory practice space for search, card correction/deletion, recall/review and evidence-based Q&A. There are no sample study-service requests, persistence writes, review scheduling changes or reward claims.

## Library failure and repair boundary

The guide previously routed all nine library/review/Q&A steps into the real `StudyHubScreen`. For signed-in learners without cached decks, a failed cloud load correctly produces a library error; the guide consequently displayed that error instead of useful examples. It also described card/review controls without opening those controls.

Diagnostic tests reproduced the empty-cache offline failure and verified cached decks still load under the same transport failure. The tour now has a dedicated sample route with specific spotlight targets. The ordinary Study Library still reports real failures and offers Retry. An unavailable cloud library is never relabeled as empty, and real learner data is not replaced with sample content.

## Compatibility and limits

The new character and rank illustrations are code-native, original and bundled offline. Norie's existing full-body PNG companion, anatomy assets/hotspots/licenses, lesson curriculum, XP curve, economy, mastery and achievements are preserved. Reduced-motion, route visibility and app lifecycle suppress automatic Explorer motion; a deliberate tap or keyboard activation can show a static greeting.

These changes do not add new playable missions, grade coverage, paid subscription checkout or backend configuration. New mission previews remain plans. Existing store/signing, public support/privacy, physical-device and qualified educator/learner validation gates remain pending. Distribute tested unsigned/debug-signed packages only as Preview, with accurate provenance.

## Validation record

Tests cover legacy appearance import and presets, draft save/cancel, nine distinct full-body poses and reaction sequence, reduced-motion changes mid-wave, lifecycle/TickerMode, rank thresholds and aliases, real subject entry points, adventure resume/recovery, all 56 guide steps at 320px/2× text, targeted landscape at 2× text, integrated guide minimize/reveal/close and unchanged sample learner storage. The implementation plan and PR record final command results, inspected browser/desktop output and exact-revision CI.

Download links in the final PR/release handoff must identify the actual revision for both Windows and Android; do not confuse the previous 0.17.0 Preview with this candidate.
