# Norie Learning Game Progression and Leaderboards Blueprint

Status: proposed design for future implementation. The user requested this blueprint only; no application, backend, workflow, or reward changes are authorized by this document.

## Intended experience

Make the subject lesson paths feel like a level-based learning game. As learners advance within a subject, lessons require deeper understanding and more independent application. Add a dedicated Leaderboards section with rankings, learner displays, achievements, and earned perks. Preserve existing progress, the Norie theme, small-phone usability, and offline core learning.

This extends the proposed Norie Adventure mission map. Exact thresholds, scoring formulas, league sizes, season lengths, and reward amounts remain design decisions rather than approved production rules.

## Three kinds of progression

| System | Meaning | Effect |
| --- | --- | --- |
| Account level | Overall participation and achievements across the app | Existing XP bar, account ranks, profile milestones, cosmetics |
| Subject mission level | Progress through a subject and grade curriculum | Unlocks increasingly demanding lessons and chapter challenges |
| Competitive rank | Performance in a defined leaderboard period and comparison group | Seasonal badges, profile displays, cosmetic perks |

Keep the existing account XP and rank milestones as the baseline. High account XP alone must not skip subject prerequisites, prove mastery, or raise every subject's difficulty. Learners choose an appropriate grade; a placement check may recognize prior knowledge rather than forcing everyone through Grade 1. Preserve open reference access and previously earned lesson access.

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
- Map length follows actual authored lessons. The reference's ten nodes are illustrative, not a requirement to invent ten lessons per grade. Existing five-lesson Science grades initially map to five lesson nodes; any separate chapter challenge needs real authored content and a distinct label.

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

After completion, show a concise reward reveal with the earned XP, badge or item, and two actions: Continue Journey and View Profile. The profile includes a trophy shelf, badges, completed subject-grade maps, and an inventory for equipping earned frames or Norie accessories. Learners choose which eligible achievements appear on their public display; the full private learning history stays private.

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

Integrate with the existing credits and cosmetics system instead of adding another currency by default. Clearly label permanent versus season-only rewards. Rewards must not buy correctness, bypass mastery, restrict essential lessons, or multiply leaderboard points. Prefer predictable earned rewards; exclude paid random rewards from this blueprint.

## Offline access and public readiness

Lessons, mission progression, earned local rewards, and review practice work offline. Leaderboards require a connection to refresh; previously downloaded standings show their timestamp and cannot appear live. Account sign-in is needed for verified public competition, while guest learning remains usable.

Before public leaderboards, define age-appropriate participation, privacy defaults, nickname moderation, reporting, account deletion behavior, and classroom access. Public profiles should be opt-in, with stricter defaults for children. Exact eligibility and consent rules require a dedicated release review; this document does not claim legal compliance.

Migration must preserve existing account XP, ranks, achievements, completed lessons, and mastery history. Recognize already completed missions, distinguish missing assessment evidence from lost progress, and prevent duplicate first-completion rewards. AI generation remains optional and online; authored progression content remains bundled offline.

## Proposed implementation sequence

1. Reliable update notices, actual Continue Learning state, and progress backup.
2. Illustrated maps per Science grade and persistent subject mission levels using existing authored content, followed by other subject-grade maps.
3. Progressive difficulty, chapter challenges, targeted reviews, and completion versus mastery markers.
4. Completion reward reveals, profile trophy shelves, and account-saved cosmetics with offline queuing and duplicate-award protection.
5. Optional verified subject leagues and private or classroom boards, followed by broader rankings after fairness testing.

Later implementation must verify save migration, grade-appropriate difficulty, understandable unlocks, duplicate-reward prevention, offline and reconnect behavior, small-screen layouts, and leaderboard privacy. Product code and release workflows remain unchanged until implementation is separately requested.

## Decisions to settle before implementation

- Final mission and chapter structure within the existing lesson curriculum.
- Grade-specific advancement and delayed mastery criteria.
- First leaderboard cohorts and eligible audiences.
- Ranked point formula, season duration, ties, and late offline synchronization.
- Permanent and seasonal cosmetic catalog and earn rates.

Related background: [existing level system notes](../LEVEL_SYSTEM.md). Those notes contain historical prototype details; use this blueprint for the proposed extension and verify current code before implementation.
