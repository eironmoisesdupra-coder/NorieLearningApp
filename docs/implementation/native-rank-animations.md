# Native rank animation integration

Source: owner-supplied NorieLearning-WIP-Native-Rank-Animations-2026-10-17.zip, manually inspected. Installer never executed. Base develop 10a0e11b7158c515ba6aeb2e4b56ec44fc1e7463; integration branch feat/native-rank-animations; version 0.14.0+18 Preview.

## Behavior

Rookie Level 1, Novice 5, Veteran 15, Scholar 30 and Master 50 replace the visible XP rank names. XP requirements, maximum level, rewards, lesson access and mastery remain unchanged. Private league point tiers are a separate system and retain their own names and thresholds.

Five bundled PNG crests gain native pulse/glow, tier accents and a visible higher-tier orbit. Large current-rank views animate; small Home/reward/collection/ladder badges remain static. OS reduced motion, accessible navigation, app reduced motion through the existing AccessibilityHost, and inactive route/tab TickerMode stop the animation. Images decode at display density and the badge owns a repaint boundary. Full-frame mascot artwork is preserved.

## Data compatibility

No saved-ID migration is needed: explorer = Rookie1, curious = Novice5, scholar = Veteran15, specialist = Scholar30, master = Master50. Old active appearances, presets, backup/cloud ownership and unlock levels retain their meaning. Labels derive from levels. Old title aliases Explorer, Curious Mind and Specialist resolve to current crests; the ambiguous title Scholar means the current Level30 rank, so saved appearances must resolve by ID/level. Legacy PNG files remain available. No database schema changes.

## Verification and release

Tests cover exact boundaries and XP arithmetic, old appearance/preset round trips and gating, native animation changes, explicit static mode, TickerMode, app/OS reduced motion and actual asset decoding at 48px/96px. Main-route and studio tests exercise 320px/160% layouts. Full Flutter analysis/tests, web and Android builds, packaged Windows offline checks and exact artifact budgets gate release. Review actual crest screenshots before publication.

Store prerequisites from 0.13 remain pending. Windows is unsigned; Android uses Preview debug signing. No store submission, production signing or hardware certification is claimed. Final PR/release records exact source SHA, green CI and both durable platform downloads.
