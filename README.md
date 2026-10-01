# Norie Learning

**Play. Learn. Grow Further.**

Norie Learning is a modern, gamified learning platform designed for:

- Junior and Senior High School students
- College learners
- Professional and self-directed learners

## Initial learning areas

- Mathematics
- Science
  - Chemistry
  - Biology
  - Physics
  - Earth Science
- English Language Proficiency

## Product direction

Norie Learning combines professional educational UX with game-like progression:

- Structured lessons and learning paths
- Active-recall quizzes and interactive challenges
- XP, levels, streaks, achievements, and mastery
- Responsive Android and web experiences
- Hierarchical subjects and specialized fields
- Professional learning tracks in later milestones

## Planned stack

- **Figma** — UI/UX and design system
- **Flutter** — Android and web
- **Flame** — interactive educational minigames
- **Supabase** — authentication, data, progress, and realtime features
- **GitHub** — source control and releases

## Development workflow

`main` is the stable branch. Active implementation should be developed in feature branches and reviewed before merging.

## Current milestone

Build the first complete learning loop:

**Home → Subject → Lesson → Quiz → Challenge → Results → XP**

Status: foundation phase.

## Offline learning

Home, built-in Mathematics/Science/English lessons, practice, challenges,
progress, and mascot tutorials open without signing in. Local learning starts
before optional account and cloud services connect. Downloaded curriculum is
read locally while updates happen in the background.

AI quiz generation, source uploads, and Ask Norie require internet and an account.
Generated quizzes loaded on this device are saved with their questions and
explanations for offline replay. Quiz results are saved locally immediately;
account-owned attempts are queued for upload with stable IDs when cloud access
returns. Each learner's study cache is separate, and completion XP is awarded
once per saved set on this device.

On Android, learning assets are bundled at installation. The web app needs an
initial online visit long enough to finish downloading its offline cache,
including anatomy models and learning assets. Keep the browser's site storage
to retain offline access and progress. Sign-in and cloud synchronization still
require a connection.

## Windows offline app

The Windows 64-bit package bundles the existing Flutter app and its rendering
engine. Extract the whole ZIP and run `NorieLearning.exe`; keep the other files
alongside it. Learning and anatomy work on the first launch without internet.
Progress is retained for the current Windows user when the app closes.
AI quiz generation, uploads, sign-in and cloud sync still need internet.

To build on Windows with Flutter, Node 24 and Microsoft Edge installed:

```powershell
flutter create --platforms=web --project-name norie_learning .
Copy-Item branding/web/* web/ -Force
& 'C:/Program Files/Git/bin/bash.exe' scripts/fetch_anatomy_assets.sh
flutter build web --release --base-href "/" --no-web-resources-cdn
Set-Location desktop
npm ci
npm test
npm run package:windows
npm run test:offline
```

Output: `build/windows-desktop/NorieLearning-win32-x64/`. The offline integration
test launches the packaged executable with an isolated profile and blocked
internet access, completes a lesson quiz and challenge, checks anatomy, then
closes and reopens it to verify saved XP. Windows Desktop CI builds, tests and
uploads the complete portable ZIP.
