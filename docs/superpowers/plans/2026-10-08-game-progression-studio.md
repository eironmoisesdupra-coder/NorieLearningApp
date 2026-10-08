# Learning Progression, Appearance and Leagues Implementation Plan

> For agentic workers: use executing-plans and dispatching-parallel-agents for independent domains. The user explicitly requested implementation of every suggestion in the updated 2026-10-08 blueprint; its historical design-only restrictions are superseded by that request.

Goal: extend the existing offline learning adventure with real curriculum depth, independent and delayed mastery, permanent rewards, editable appearance, rank benefits, and optional verified competition.

Architecture: preserve topic IDs and the XP policy. Add separate evidence and appearance snapshots to existing backup/cloud ownership boundaries; derive permanent cosmetics from rank and milestone receipts. Keep ranked points in a server-validated ledger, separate from client XP. Extend existing dynamic maps instead of replacing them.

Baseline: develop 22afa6c00d13c303f172e2fa55c5e561e94d3166. Branch feat/game-progression-studio. Original dirty checkout remains untouched.

Source: C:/Users/ronaldo.dupra/Downloads/NorieLearning-game-progression-leaderboards-blueprint-updated-2026-10-08.md.

## Product decisions

- Five to twenty lessons is a justified range, not a quota. Target six authored units per subject-grade/course: 234 lessons across Science, Mathematics and English. Replace the original 125 generic Math/English previews with real instruction and assessment while preserving IDs, rewards and completion. Preserve original approved Grade 1 Science lesson text.
- Optional stars: read/completed, independent practice at least 80% over at least five items, and a new independent successful review at least 24 hours after the first pass. Self-marked/hinted practice cannot certify mastery. Existing completion remains valid; old aggregate statistics do not manufacture delayed evidence.
- No newly mandatory locks on existing lessons. Chapter tasks use real authored questions and have explicit labels.
- Rank bundles at existing levels 1, 5, 15, 30, 50: cosmetic frames/themes/poses and showcase capacity only. No new currency or academic advantage.
- Appearance uses bundled approved avatars and palettes. Learner local-image upload remains optional/later unless a safe validated image path is implemented. Preview, cancel, save, reset and explicit locked ownership labels.
- Trophy receipts are permanent and migrate from the original completed five-lesson cohort before curriculum expansion. New curriculum yields additional completion goals without revoking legacy trophies or issuing XP again.
- Competitive audience is awaiting user clarification. Implement invite-only/private architecture; do not enable public discovery or fabricate competitors. Client XP never certifies a ranked score. Offline boards are timestamped cached views, pending results provisional. Guest personal bests remain functional.
- Preserve private-demo account gate until backend configuration/eligibility is actually validated. No claim that unconfigured remote services are live.

## Tasks and interfaces

1. Curriculum/maps: authored additions, variable-length maps for subjects, chapter details. Own content data and map presentation only. Tests pin existing IDs and useful worked examples/questions, and responsive 5/10/20-node layouts.
2. Appearance/rank benefits: create lib/features/profile/domain/norie_profile_appearance.dart, data/norie_profile_appearance_store.dart and presentation/norie_appearance_studio.dart. Store exposes singleton load(), exportState(), replaceState(Map<String,dynamic>), reset(), and immutable appearance values; notify root for exact interfaces. Profile screen owns entry and preview. Tests pin locked items, cancel/save/reset, and stale save isolation.
3. Leagues: modular private-board UI/backend boundary, SQL/edge functions with RLS and authenticated server verification, deterministic score and receipt tests. UI never presents local/client points as verified. Root owns drawer entry. Backend must report missing configuration honestly.
4. Root evidence/rewards: create NorieAdventureProgress with load/exportState/replaceState/reset; independent attempt receipts and due-review selection. Integrate quiz/activity/challenge evidence and short mistake drill. Three star explanations and reward reveal point to journey/profile.
5. Root ownership/backup: include both stores in guarded progression snapshot import/reset/save notifications; validate before mutation and discard stale account saves. Test migration, malformed backup, duplicate milestones and learner replacement.
6. Verify and promote: centralized Flutter analysis/tests, Node backend/cache tests, actual phone/desktop views, web and APK/Windows CI. Focused PR into develop, green checks, web/release verification, both platform links and exact revision.

## Review focus

- Older completed maps expanding cannot lose permanent trophies.
- Same receipt replay and account changes cannot duplicate awards or leak appearance.
- Hint/reveal/self-mark practice and clock reversal cannot produce independent/delayed mastery.
- A 320px phone with large text retains all editor/map/review actions.
- Ranked API cannot accept client score, access another private cohort, or double-count retries.

## Execution record

- Initial review: supplied blueprint has six remaining areas; existing maps accept variable topic lists but are Science-only. Existing mastery uses aggregate accuracy/confidence, not delayed independent evidence. Account/cloud state already has ownership guards.
- [x] Curriculum and dynamic maps
- [x] Rank benefits and appearance studio
- [x] Evidence, review quests and persistent reward receipts
- [x] Verified optional leagues
- [x] Account/backup integration and validation
- [ ] Tests/builds/review/PR/release

### Verification and integration notes

- Initial combined suite: 451 Flutter tests passed before the final original Math/English content replacements. New save-failure/league tests: 13 passed. Full verification must be repeated after final content integration.
- Verified league backend deployed with three additive RLS migrations and the owner-bound guarded cloud-save RPC. Live rollback checks confirm owner-filtered reads and denial of unauthorized writes/scoring. Edge version 3 uses 234-lesson bank `authored-9f41785c`, JWT verification enabled. No cohorts or approved participants have been created; an authenticated participant staging run remains unverified.
- Original Math G2–College content test failed on generic preview certification, confirming the replacement requirement. Original English content tests failed on absent authored band modules before implementation.
- Guest learning transfer is explicit and recovery-first. Same-owner reconciliation preserves permanent rewards and chosen appearance; XP uses the greater snapshot, rather than summing potentially duplicated independent device awards.
- Profile photos remain the blueprint's optional later extension. Built-in offline avatars, themes, frames, poses, presets and showcases cover the current editor.
- Final local checks: 512 Flutter tests passed; full analysis clean; web release build passed; 30 Node tests passed; 35+ league and 20 cloud PostgreSQL assertions passed. Final package CI, develop integration and trusted release publication are the remaining workflow steps.
