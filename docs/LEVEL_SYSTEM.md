# Norie Learning — Level System

## Rank milestones

| Level | Rank |
| ---: | --- |
| 1 | Rookie |
| 5 | Novice |
| 15 | Veteran |
| 30 | Scholar |
| 50 | Master |

A learner keeps the most recently unlocked rank until the next milestone.

Examples:

- Level 3 → Rookie
- Level 8 → Novice
- Level 21 → Veteran
- Level 37 → Scholar
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

## XP example

A learner with **1,250 total XP** resolves to:

- Level 8
- Novice
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

## Rank visuals and saved cosmetics

Ranks use bundled native Flutter crests, with pulse/glow and higher-tier orbit accents in large views. Small badges and rank rows remain static. OS accessibility, app reduced motion and inactive-route TickerMode stop motion. Cosmetics grant no extra XP, mastery or lesson access.

Persistent IDs remain unchanged: `explorer` = Rookie (1), `curious` = Novice (5), `scholar` = Veteran (15), `specialist` = Scholar (30), `master` = Master (50). Appearance presets, ownership and cloud/backup data retain their meaning. Labels derive from levels; the ambiguous old visible title Scholar is never used as a saved cosmetic identifier. Legacy rank image files remain available.
