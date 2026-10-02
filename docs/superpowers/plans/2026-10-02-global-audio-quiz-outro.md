# Global audio and quiz outro implementation

The user authorized both supplied briefs on 2026-10-02, in order: global music and SFX, then the shared quiz result experience. Subsequently the user authorized the four supplied Grade 1 Science lessons after the pop-up. The optional five-question mistake drill remains deferred.

## Architecture

Extend core/audio with one injectable NorieAudioManager and playback backend. Keep persisted Music and SFX preferences separate. A two-player music transport provides bounded-memory rotation and crossfades; pooled SFX provide category gains, duplicate suppression, and transient ducking. One app host handles user-gesture unlock and lifecycle; route/context scopes handle lesson and quiz attenuation. Settings becomes a real audio settings screen. Existing reward sounds delegate to the manager.

Core/quiz will own a shared immutable result summary, per-answer evidence, centralized percentage tiers, bounded local comparable-attempt history, and an accessible animated outro with mistake review. Completion adapters preserve each flow's existing reward owner and continue destination. No result widget awards XP on rebuild. Norie uses the existing complete-frame mascot machinery; low scores receive studying/coaching poses. Perfect celebration is distinct and limited per comparable quiz/session. Real concept tags drive at most two review priorities; absent metadata never yields fabricated concept analytics.

## Tasks and validation

1. Inspect existing audio, all answer and completion paths, settings, lifecycle, mascot, progression, and offline cache. Check current develop and old work before implementation.
2. Implement and test the global audio manager, transport, persisted settings, app host, context handling, and reward delegation. Add original bundled SFX with attribution. Verify disable/volume/rotation/duck/lifecycle behavior using an injectable backend. Generate original soundtrack if the connected tool permits it; otherwise implement the specified documented fallback without production placeholder music.
3. After the audio foundation, implement shared quiz summaries, history, tier/message policies, and responsive outro/review UI. Test zero/incomplete/perfect attempts, percentage boundaries, real improvement, two-concept limit, reduced motion, and small-screen layouts.
4. Integrate every inventoried quiz/practice submission and completion path, with selection/result SFX, per-answer review evidence, guarded completion, contextual continue/retry/review actions, and no changes to lesson prose or grade restrictions. Test representative routes and static coverage inventory.
5. Independently review, run flutter analyze and flutter test, relevant Node/cache tests, web and Windows builds/offline app checks, and Android CI. Create focused commits and PR to develop; merge only green checks, verify web deployment, and hand off exact SHA and Windows/Android links. Report missing music and any device validation honestly.

## Asset capability finding

Runway music generation was attempted and rejected with paid_plan_required on the connected Free workspace. No purchase or plan change is authorized. Runway sound-effect generation accepted the first original correct-answer sound. Continue independent implementation; prepare MUSIC_GENERATION_SPEC.md with the five tracks and retain explicit missing-music status until generation becomes available.

## Progress

- Audio foundation implemented with 12 original normalized local SFX, separate persisted controls, bounded players, crossfades, ducking, lifecycle handling and browser gesture priming. Five music tracks remain unavailable; generation brief is bundled, with no production placeholder tracks.
- Shared result summary/history, all quiz adapters, mistake review, responsive full-frame mascot celebration, improvement and optional result details implemented. History is scoped to each account with a separate anonymous local bucket.
- Independent review found inaccessible underlying results and cross-learner history; fixes added with behavior regressions. Study Details route verified separately.
- Full Flutter suite: 186 passed. Final full analyzer: no issues. Web release build validated. Focused audio/settings checks: 11 passed; final Science/foundation checks: 10 passed.
- Real packaged-browser testing exposed a self-await in audio priming cleanup and semantic-click activation gap. Both were fixed; actual offline SFX decoding, mute and re-enable verified. Zero-volume races are covered by the manager regression. Release CI and final browser checks remain in progress.
- Approved follow-on work: preserve all learner text from the four attached Science lessons, original offline diagrams, individual quick-check reveals, and 20 MC + 3 mastery questions per lesson. Preserve existing topic IDs and lesson 5.
