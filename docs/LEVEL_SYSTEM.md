# Norie Learning — Level System

## Rank milestones

| Level | Rank |
| ---: | --- |
| 1 | Explorer |
| 5 | Curious Mind |
| 15 | Scholar |
| 30 | Specialist |
| 50 | Master |

A learner keeps the most recently unlocked rank until the next milestone.

Examples:

- Level 3 → Explorer
- Level 8 → Curious Mind
- Level 21 → Scholar
- Level 37 → Specialist
- Level 50 → Master

## XP curve

The XP required to advance increases every level.

Formula:

```text
XP required for next level = 100 + ((current level - 1) × 25)
```

Examples:

| Current level | XP required to reach next level |
| ---: | ---: |
| 1 | 100 XP |
| 2 | 125 XP |
| 5 | 200 XP |
| 8 | 275 XP |
| 15 | 450 XP |
| 30 | 825 XP |
| 49 | 1,300 XP |

Level 50 is currently the maximum level.

## Current demo state

The prototype begins with **1,250 total XP**, which resolves to:

- Level 8
- Curious Mind
- 25 / 275 XP toward Level 9

The Home screen reads this data dynamically instead of using a hard-coded level.

## XP sources currently implemented

- Quiz: 20 XP per correct answer
- Atom challenge: 25 XP per correct round
- Lesson completion: 50 XP
- Initial onboarding completion: 50 XP

The results screen awards earned XP, updates the level bar, and announces level-ups and rank unlocks.

## Future persistence

The current prototype keeps progression in app memory for the active session. Persistent progression will later move into the learner account/backend so XP survives refreshes and syncs across devices.
