# Supabase setup for Norie Learning

Norie remains local-first. If Supabase is not configured, the app continues using device/browser storage.

## 1. Create or connect a Supabase project

Apply:

`supabase/migrations/001_accounts_cloud_sync.sql`

This creates:
- `profiles` for learner display names.
- `learner_state` for the versioned Norie progression JSON.
- Row Level Security policies so an authenticated user can only read/write their own rows.
- A signup trigger that creates the learner profile from auth metadata.

## 2. Authentication

Enable Email authentication in Supabase Auth.

Email confirmation can stay enabled. When enabled, a newly created account may need to confirm its email before a session becomes available and cloud sync starts.

## 3. GitHub deployment secrets

In the GitHub repository, add these Actions secrets:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Use the project URL and public anon/publishable key. Never place a Supabase service-role key in the Flutter app or GitHub Pages build.

The workflows pass those values through Dart compile-time defines.

## 4. Local development

Use:

```bash
flutter run \
  --dart-define=SUPABASE_URL="https://YOUR_PROJECT.supabase.co" \
  --dart-define=SUPABASE_ANON_KEY="YOUR_PUBLIC_ANON_KEY"
```

Without the defines, Account shows local-only mode and the rest of Norie remains functional.

## Sync behavior

- Local progress is loaded first.
- When a user signs in, Norie checks `learner_state`.
- If no cloud row exists, current local progress is uploaded.
- If cloud data is newer than local data, cloud data is restored.
- Otherwise local data is uploaded.
- Later local progression changes are debounced and uploaded automatically.
- Manual **Sync Now** is available on the Account screen.

The synced state includes XP, lesson/session counts, answer statistics, subjects explored, streak dates, Challenge history, weekly rewards, Speed Quiz best score, onboarding state, and topic mastery/weak-topic evidence.
