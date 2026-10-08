# NorieLearning ChatGPT WIP continuation — 2026-10-08

This workspace continues the transferred 0.5.0+8 WIP. It is still unreleased and must not be described as published.

## Public-release readiness changes continued

- Migrated backup export/import UI to file_picker 13.1.0 static APIs.
- Single-file restore now uses pickFile() and asynchronous PlatformFile byte reads.
- Restore aborts before mutation if the recovery snapshot cannot be persisted.
- Restore passes an ownership/sync guard into progression import and verifies ownership again afterward.
- Lesson-journey replacement/reset now accepts the same guard and rechecks it around asynchronous persistence.
- Backup validation rejects unexpected nested reward/mastery fields and applies size/value limits.
- Added visible pending cloud-sync labels to App & progress, Account, and Profile surfaces.
- Web update bridge now falls back to the downloads page if the update controller/service-worker UI is unavailable.
- Service-worker update activation refuses to proceed while another NorieLearning window is active.
- Previous offline caches are retained through activation and cleaned only after the reloaded client reports ready.
- Resume widget test no longer uses pumpAndSettle across continuously animated UI.

## Science adventure maps implemented

- Added derived grade-map model using existing curriculum topic IDs and completed-topic IDs.
- Science grade pages now default to a winding adventure-map view with a Map/List accessibility toggle.
- Existing lesson access is preserved: later available lessons are not newly hard-locked.
- Supports completed/current/available/locked visual states; locked is reserved for unavailable curriculum content.
- Norie marks the current mission.
- Mission details show title, lesson objective/introduction, progress, and Start/Continue/Review action.
- Map position is stored per Science grade locally.
- Direct grade switching is available from the grade page.
- Profile includes a derived Science journey trophy shelf. Grade trophies do not create XP/credit transactions.
- Added grade-map model tests and a small-phone/large-text widget test.

## Verification completed in this environment

- Node readiness/download/service-worker tests: 12/12 passed.
- Python release/music tests: 6 tests + 11 subtests passed.
- Obsolete FilePicker.platform / withData usage: none remains in lib/ or test/.

## Verification still required on a Flutter-capable machine/CI

This environment does not provide the Flutter/Dart SDK, so the new Dart changes still require:

- flutter analyze
- flutter test (including new map, backup, journey, cloud-race, resume tests)
- release web build and browser inspection
- Android APK build/check
- Windows package build/check
- real browser old-cache -> new-update migration using a persistent profile
- final integration review before commit/PR

Do not publish or merge until these checks are green.
