# Norie Learning Game Progression and Leaderboards Blueprint

Status: living product blueprint. Adventure-map and public-readiness work may already exist in the current app, but the additions in this revision are design-only. No application, backend, workflow, curriculum-expansion, profile-customization, rank-benefit, or reward changes are authorized by this document.

## Intended experience

Make the subject lesson paths feel like a level-based learning game. As learners advance within a subject, lessons require deeper understanding and more independent application. Add a dedicated Leaderboards section with rankings, learner displays, achievements, and earned perks. Preserve existing progress, the Norie theme, small-phone usability, and offline core learning.

This extends the proposed Norie Adventure mission map. Exact thresholds, scoring formulas, league sizes, season lengths, and reward amounts remain design decisions rather than approved production rules.


## New blueprint additions: rank benefits, curriculum depth, and editable profiles

The next product direction expands NorieLearning beyond the initial five-lesson-per-grade pattern without treating every subject or grade as the same size. It also gives account ranks more identity and gives learners more control over how their profile looks. These are blueprint requirements only until separately authorized for implementation.

### Rank-specific benefits

Existing account ranks should become meaningful milestones rather than labels alone. Each rank may unlock a small bundle of benefits, but rank benefits must not provide paid-style academic advantages, skip prerequisites, inflate assessment scores, or lock essential learning behind progression.

Proposed rank-benefit categories include:

- exclusive profile frames, badges, titles, Norie poses, and celebration effects;
- rank-themed profile backgrounds and interface accents;
- additional profile showcase slots for selected trophies or achievements;
- extra saved appearance presets for quickly switching profile themes;
- cosmetic Norie accessories or collectible variants tied to rank milestones;
- richer progress-summary views or non-competitive personalization features;
- optional rank-specific map decorations that do not change lesson access or mastery requirements.

Rank rewards should remain mostly cosmetic, expressive, and convenience-oriented. A learner at a lower rank must still be able to access the same required lessons, explanations, accessibility options, review tools, and core assessment opportunities as a higher-rank learner.

A rank can contain several milestone benefits rather than only one reward at promotion. The exact rank-benefit table, unlock levels, permanent versus seasonal status, and migration treatment for learners who already passed those milestones remain future design decisions.

### Flexible curriculum size: approximately 5–20 authored lessons per subject-grade

The current five-lesson structure should no longer be treated as the permanent target for every subject-grade combination. Future curriculum expansion may use roughly **5 to 20 authored lessons per subject-grade**, depending on the real scope of that curriculum.

The lesson count is a range, not a quota. A focused grade or subject unit may remain near five lessons, while a broader curriculum may require ten, fifteen, twenty, or another justified count. NorieLearning must not pad a map with filler simply to reach a number.

Expansion rules:

- every added lesson needs a real curriculum objective and authored instructional purpose;
- existing lesson IDs, completion state, XP receipts, mastery history, and previously earned access must be preserved during expansion;
- maps dynamically render the number of real lessons instead of assuming five nodes;
- chapters and checkpoints may divide longer maps into understandable sections;
- chapter challenges require their own authored content and must not be disguised placeholder nodes;
- difficulty should rise through Discover -> Practice -> Apply -> Connect -> Master rather than merely by increasing question count;
- already completed subject-grade maps need a clear migration policy when legitimate new curriculum is later added, so previously earned trophies are not silently revoked;
- content-readiness labels should distinguish fully authored lessons from any temporary starter content during expansion.

A longer subject-grade path may therefore contain several chapters, each with its own lessons and checkpoint, while a shorter path may remain a single compact journey.

### Editable learner profile and appearance studio

Profiles should become editable rather than functioning only as a read-only progress summary. The profile editor should eventually let learners personalize their identity while keeping learning history and verified achievements separate from cosmetic choices.

Planned editable areas:

- **Avatar:** replace the displayed avatar using approved built-in Norie/avatar options and, if enabled later, a learner-selected local image with appropriate privacy and file-safety controls.
- **Theme:** choose or edit an allowed profile theme, including background treatment, accent combination, and compatible subject/rank visual styles.
- **Frame:** equip an unlocked frame around the learner avatar/profile card and preview it before saving.
- **Showcase:** choose which earned badges, trophies, rank title, or selected achievements appear prominently on the profile.
- **Norie appearance:** equip compatible earned accessories, poses, or backgrounds from the learner inventory when those systems are available.

Customization should preview before saving, support Reset to default, and clearly distinguish **owned/unlocked** cosmetics from unavailable ones. Changing an avatar, theme, or frame must never alter XP, rank, lesson completion, mastery, leaderboard points, or reward ownership.

Profile appearance should save locally first for offline use and synchronize to the correct signed-in account when connected. Account switching must not leak one learner's avatar, theme, equipped frame, or showcase choices into another learner's profile. Conflict handling should prefer explicit user choices and preserve owned inventory.

For public or competitive displays, the learner should control which eligible profile elements are shown. Private learning data, weaknesses, exact age, contact information, and other sensitive account details remain excluded from public profile cards.

## Three kinds of progression

| System | Meaning | Effect |
| --- | --- | --- |
| Account level | Overall participation and achievements across the app | Existing XP bar, account ranks, profile milestones, cosmetics, and future rank-specific benefits |
| Subject mission level | Progress through a subject and grade curriculum | Unlocks increasingly demanding lessons and chapter challenges |
| Competitive rank | Performance in a defined leaderboard period and comparison group | Seasonal badges, profile displays, cosmetic perks |

Keep the existing account XP and rank milestones as the baseline. Future rank benefits may add cosmetic, profile, and convenience perks, but high account XP alone must not skip subject prerequisites, prove mastery, or raise every subject's difficulty. Learners choose an appropriate grade; a placement check may recognize prior knowledge rather than forcing everyone through Grade 1. Preserve open reference access and previously earned lesson access.

## Subject worlds and mission levels

Subject world -> grade or course -> chapter -> lesson mission -> chapter challenge -> next chapter.

A mission contains a short objective, explanation, useful visual, worked example, guided activity, independent practice, and a clear result. The mission map shows completed, current, available, prerequisite-locked, and review-due states. Each lock explains the specific requirement and links to the next useful activity.

Show both the game level and its curriculum identity, such as "Science mission 7 / Grade 2 / Materials." Game levels do not replace grade labels or imply that every subject has equal-length curricula. Reference tools such as Anatomy Lab remain available independently of the mission path.

| Difficulty stage | Lesson design | Evidence to advance |
| --- | --- | --- |
| Discover | Concrete examples, recognition, strong visual guidance | Identify the concept in simple examples |
| Practice | Compare, classify, explain, use guided steps | Complete varied practice with decreasing help |
| Apply | Solve unfamiliar examples independently | Use the concept without copying a worked example |
| Connect | Combine related concepts and multiple steps | Explain relationships and solve a mixed task |
| Master | Transfer learning to a new situation and revisit it later | Succeed on independent and delayed review |

Illustrative Science sequence: identify a solid or liquid -> classify unfamiliar examples -> explain a change of state -> predict and explain a suitable everyday scenario. Keep the language and scientific depth appropriate to the chosen grade. Increased difficulty means increased reasoning and independence, not merely longer text, more questions, or shorter timers.

The chapter challenge is a culminating learning task presented with game-like anticipation and celebration. Timing is optional unless speed is itself the learning objective. Incorrect answers trigger explanation, targeted practice, and another attempt; they do not consume lives needed to access lessons.

## Grade maps based on the visual reference

User direction: use the supplied winding adventure-path reference for each grade within each lesson subject. Its numbered stepping stones, stars above completed nodes, colorful landscape, and visible upcoming levels establish the desired map style. Create original Norie artwork and retain Norie's colors, mascot, and interface identity.

Navigation: Learn -> subject -> grade -> that grade's adventure map. Each subject and grade has its own saved position, completion state, and rewards; changing maps must not reset another map. College paths use course or module labels rather than inventing additional school grades.

- Use a vertically scrolling, winding trail with large numbered lesson nodes, landmarks, chapter checkpoints, and an end-of-grade destination. Node numbers restart within each grade map; account level remains separate.
- Completed nodes show earned stars or checkmarks; the current node receives a clear highlight and Norie marker; available nodes are tappable; locked nodes explain prerequisites. Use icons and text as well as color.
- Tapping a node opens its real lesson title, learning objective, completion markers, and Start, Continue, or Review action. Keep lesson names visible or readily accessible rather than presenting unexplained numbers alone.
- Open the map near the learner's current mission. Include grade switching, overall completion, reward preview, and a list-view alternative with accessible navigation and reduced motion.
- Use landscape variation to distinguish subject and grade maps. Younger grades may use playful islands or forests; older grades can use a more restrained expedition style with the same navigation rules. Final art themes remain proposals.
- Map length follows actual authored lessons. The reference's ten nodes are illustrative, not a requirement to invent ten lessons per grade. Existing five-lesson paths may remain five lessons until deliberately expanded, while future subject-grade curricula may contain roughly 5–20 authored lessons when the real curriculum justifies that depth. Any separate chapter challenge needs real authored content and a distinct label.

Proposed completion stars retain the three meanings defined below: lesson completed, independent practice passed, and retained understanding demonstrated later. Show what each star requires. Full stars are optional mastery goals unless explicitly required by an authored prerequisite; they must not silently become a requirement for every subsequent lesson.

## Completion rewards saved to account profiles

User requirement: completing missions and grade paths awards rewards that are saved on the learner's account profile. The map and profile must display the same earned state.

| Completion milestone | Proposed reward | Profile record |
| --- | --- | --- |
| First eligible lesson completion | Existing-policy XP and credits, plus lesson completion marker | Subject, grade, lesson, completion date, earned markers and reward receipt |
| Chapter challenge completion | Chapter badge or collectible | Chapter achievement and unlocked item |
| All required missions in a subject grade completed | Subject-and-grade completion trophy, celebratory Norie animation, proposed cosmetic | Permanent grade trophy and completed map summary |
| Optional mastery of the subject grade | Distinct mastery decoration or badge | Mastery achievement, separate from ordinary completion |

For example, completing the Grade 1 Science map earns a "Grade 1 Science Complete" trophy. It does not claim completion of all Grade 1 subjects. A separate whole-grade award may be proposed later only after its required subject coverage is defined.

After completion, show a concise reward reveal with the earned XP, badge or item, and two actions: Continue Journey and View Profile. The profile includes a trophy shelf, badges, completed subject-grade maps, and an inventory for equipping earned frames or Norie accessories. A future profile editor adds avatar replacement, theme selection/customization, frame selection, and showcase controls without changing verified learning progress. Learners choose which eligible achievements appear on their public display; the full private learning history stays private.

Save the completion and reward receipt locally before announcing success. When signed in and connected, synchronize them to that learner's account for access on another device. Clearly distinguish "Saved on this device / sync pending" from "Saved to your account." Offline use remains supported, but cross-device availability cannot be promised until synchronization succeeds.

Rewards are issued once for each eligible milestone. Replaying a lesson, reopening a result popup, retrying an upload, or completing on two devices must not duplicate the original reward. Preserve the best earned markers and permanent trophies when merging progress. Improvement rewards, if introduced, have separate explicit eligibility rules.

Guest rewards remain local until an explicit transfer to an account. Account switching must isolate inventories and progress. Define a guest-transfer and conflict-resolution flow before implementation so one learner's rewards cannot be silently assigned to another. Previously completed lessons must migrate without requiring a repeat playthrough or double-awarding existing XP.

Exact XP amounts, completion thresholds, trophy artwork, and cosmetic choices remain pending design decisions. The account-save requirement and per-grade illustrated map direction are recorded user requirements.

## Unlocks and mastery

Separate completion from mastery. Proposed lesson markers are: lesson completed, independent practice passed, and retained understanding demonstrated later. Reviewing with hints is useful practice but does not count as independent mastery evidence.

Advance using authored prerequisites and a grade-appropriate assessment policy. Require varied questions and coverage of the key concepts, not repeated success on one memorized item. Keep exact passing thresholds configurable and pending review. Unlocks already earned remain available when later review identifies a weakness.

After difficulty, Norie recommends one or two concepts to revisit and offers a short mistake drill. Once ready, the learner retries equivalent new items. Recognize improvement and persistence as well as perfect scores. Avoid making every quest a demand for perfection.

## Leaderboards section

Proposed tabs: My League, Subject Rankings, Friends or Class, and Hall of Achievements. An overall seasonal board may be added after scoring is demonstrably fair across subjects. Begin with subject and grade or course cohorts so rankings compare similar learning opportunities.

The screen includes the learner's own position even when outside the top list, nearby positions, a podium, progress toward the next tier, time remaining, last synchronization time, and an explanation of how points are earned. Provide clear empty, offline, unranked, provisional, and season-completed states.

Each learner row or profile card may display an approved nickname, Norie avatar, cosmetic frame, account level, subject mastery badge, competitive tier, verified seasonal points, rank movement, and selected achievements. Keep school identifiers, exact age, private learning difficulties, and personal contact details out of public displays.

Illustrative league names: Explorer, Pathfinder, Scholar, Specialist, and Master League. These names and thresholds are proposals; the interface must distinguish league tiers from existing account rank titles. Optional competition should not block the core learning path. Offer a private personal-best view for learners who do not join public rankings.

## Scoring and fair competition

Maintain competitive points separately from lifetime XP. Proposed sources are first-time mission success, capped improvement rewards, successful due reviews, and chapter mastery challenges. Repeating an easy lesson indefinitely must not produce unlimited competitive points. Purchased items, AI usage, and time spent with the app open do not increase ranking.

Use comparable content and assessment rules within each board. Difficulty multipliers, if used, require calibration; do not assume questions from different subjects are equivalent. A leaderboard must not penalize accessibility settings or favor speed unless it is explicitly a separate optional speed event.

The server validates ranked attempts and awards each eligible event once. Retried uploads, multiple devices, edited client XP, and clock changes must not duplicate points. Pending offline results remain provisional; only verified results enter a public board. Define fair season-close and late-sync rules before launch, and do not promise that unverified offline attempts will receive competitive credit.

Season transitions reset only seasonal standings. Account XP, completed lessons, mastery history, and permanently earned cosmetics remain. Define tie handling, promotion rules, minimum participation, moderation, and recovery from incorrect scores before enabling competition publicly.

## Perks and rewards

| Achievement | Proposed perk |
| --- | --- |
| Subject milestone | Subject badge, themed profile background, Norie accessory |
| Chapter mastery | Chapter trophy and celebration animation |
| Sustained improvement | Improvement badge and earnable cosmetic currency |
| League promotion | League frame, title, or victory pose |
| Season participation | Participation collectible and personal progress recap |

Integrate with the existing credits and cosmetics system instead of adding another currency by default. Account-rank milestones may also unlock profile frames, themes, Norie poses/accessories, showcase capacity, or other non-academic convenience perks. Clearly label permanent versus season-only rewards. Rewards must not buy correctness, bypass mastery, restrict essential lessons, or multiply leaderboard points. Prefer predictable earned rewards; exclude paid random rewards from this blueprint.

## Supportive gaming experience

NorieLearning should feel like a learning adventure rather than a pressure system. Game elements are there to celebrate progress, make review inviting, and give learners visible reasons to keep going without turning mistakes into punishment.

Core principles:

- Norie celebrates improvement, persistence, recovery after mistakes, and mastery—not only perfect scores or first-place finishes.
- Feedback should stay supportive and specific. After errors, explain the misconception, recommend one or two priority concepts, and offer targeted practice before a retry.
- Music, sound effects, mascot animations, chapter celebrations, map landmarks, achievement reveals, review quests, and profile cosmetics can make progress feel rewarding, but essential learning must remain fully usable with audio muted, reduced motion enabled, or cosmetic systems ignored.
- Core learning must not depend on lives, energy systems, paid retries, premium boosts, or purchased advantages. A learner who makes mistakes must still be able to continue learning and retry meaningful practice.
- Difficulty should come from deeper reasoning and independence, not artificial frustration, shorter timers, punishment mechanics, or excessive repetition.
- Review quests should feel like a helpful return journey: short, focused, and based on actual weak concepts rather than requiring the learner to replay an entire grade.
- Completion celebrations should provide clear next actions such as Continue Journey, Review a Priority Concept, or View Profile rather than trapping the learner in long animations.
- Optional competitive systems must remain secondary to learning. Learners who opt out of public rankings should still receive personal milestones, private bests, rewards, and the full curriculum experience.
- Younger grades may use brighter, more playful celebrations and character reactions. Older learners should be able to use a more restrained visual presentation while keeping the same progression structure, accessibility, and rewards.
- Accessibility settings such as reduced motion, readable text sizing, contrast support, captions/text alternatives for audio cues, and list navigation must not reduce XP eligibility, mastery credit, or competitive fairness.

The intended emotional loop is: **attempt -> receive useful feedback -> improve -> retry -> succeed -> celebrate -> continue**. The app should avoid loops built around fear of losing progress, streak punishment, or artificial scarcity.

Exact animation sets, celebration durations, audio cues, review-quest frequency, and age/grade presentation presets remain future design decisions. This section is blueprint-only and does not authorize implementation by itself.

## Offline access and public readiness

Lessons, mission progression, earned local rewards, and review practice work offline. Leaderboards require a connection to refresh; previously downloaded standings show their timestamp and cannot appear live. Account sign-in is needed for verified public competition, while guest learning remains usable.

Before public leaderboards, define age-appropriate participation, privacy defaults, nickname moderation, reporting, account deletion behavior, and classroom access. Public profiles should be opt-in, with stricter defaults for children. Exact eligibility and consent rules require a dedicated release review; this document does not claim legal compliance.

Migration must preserve existing account XP, ranks, achievements, completed lessons, and mastery history. Recognize already completed missions, distinguish missing assessment evidence from lost progress, and prevent duplicate first-completion rewards. AI generation remains optional and online; authored progression content remains bundled offline.

## Proposed implementation sequence

Current direction after the initial public-readiness and Science-map work:

1. Verify and stabilize the already introduced public-readiness and Science adventure-map behavior across supported platforms.
2. Expand authored curriculum depth subject-by-subject and grade-by-grade, allowing approximately 5–20 real lessons where curriculum scope warrants it.
3. Add progressive difficulty, chapter challenges, targeted reviews, and completion-versus-mastery markers across the expanded paths.
4. Design and implement rank-specific benefits that remain cosmetic, expressive, or convenience-oriented rather than academic shortcuts.
5. Add the editable profile/appearance studio: avatar replacement, theme customization, frame settings, showcase controls, and equipped Norie cosmetics.
6. Extend completion reward reveals, trophy shelves, rank collections, and account-saved cosmetics with offline queuing and duplicate-award protection.
7. Add optional verified subject leagues and private/classroom boards, followed by broader rankings only after fairness and privacy testing.

Later implementation must verify save migration, curriculum expansion migration, grade-appropriate difficulty, understandable unlocks, duplicate-reward prevention, profile/account isolation, offline and reconnect behavior, small-screen layouts, avatar/file safety, and leaderboard privacy. No new rank-benefit, lesson-expansion, or profile-customization product code is authorized by this blueprint revision.

## Decisions to settle before implementation

- Final mission and chapter structure within the existing lesson curriculum.
- Grade-specific advancement and delayed mastery criteria.
- First leaderboard cohorts and eligible audiences.
- Ranked point formula, season duration, ties, and late offline synchronization.
- Permanent and seasonal cosmetic catalog and earn rates.
- Rank-by-rank benefit table, including which perks are permanent, seasonal, cosmetic, or convenience-only.
- Curriculum expansion plan for each subject-grade, including which paths remain near five lessons and which require longer 10–20 lesson structures.
- Migration policy when new authored lessons are added to a subject-grade that a learner previously completed.
- Profile avatar sources, local-image policy, theme editing limits, frame inventory behavior, showcase limits, and synchronization/conflict rules.

Related background: [existing level system notes](../LEVEL_SYSTEM.md). Those notes contain historical prototype details; use this blueprint for the proposed extension and verify current code before implementation.
