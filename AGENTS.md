# NorieLearning working agreement

Use current `develop` as the integration baseline unless the user says otherwise.

Before implementing, inspect the relevant code and tests, search for related
systems, and check older branches/PRs for useful work. Never blindly merge stale
work over newer `develop`. Extend the existing architecture, keep Flutter code
modular, and make the smallest reasonable change consistent with the product.
Ask only when a missing decision would significantly change behavior or architecture.

Preserve working features, the Norie theme, small-phone usability, and local-first
behavior. Core lessons must not require network access. Preserve progression, XP,
mastery, achievements, tutorials, and account hooks. Keep the full-body frame-based
mascot; do not restore segmented or distorted limb rigs. Preserve the mirrored
skeleton, calibrated hotspots, anatomy web asset paths, offline cache, and all
third-party attribution and licenses.

After changes, run `flutter analyze`, `flutter test`, and relevant targeted tests.
Build web when web behavior changes, and Android when native behavior changes.
Inspect actual output where possible. Investigate and fix failures, rerun affected
checks, and never call the task complete while CI is red.

For substantial work, branch from current `develop`, use descriptive branch names
and focused commits, and open/update a PR into `develop`. Follow the established
PR -> CI -> merge -> web preview workflow. Report the exact head SHA and CI status.
Never merge or push into `main` without an explicit user request.

Educational content must teach the actual subject at the learner's grade level.
Do not generate generic study-habit questions, vague definitions without examples,
or decorative diagrams that teach nothing. Production lessons need objectives,
readable explanations, useful diagrams, worked and guided examples, step-by-step
reasoning, common mistakes, recap, lesson-specific practice, and mastery items.

During large tasks, report meaningful findings, root causes, affected systems,
test/build results, and deployment status without narrating minor implementation
steps. Done means requested behavior implemented, relevant tests updated,
analysis/tests green, relevant builds validated, no obvious regressions, and a
clearly reported branch/PR state. State exactly what remains if incomplete.

After every app update or promotion, always include download links for both the
Windows PC package and the Android APK in the final handoff. Identify the build
or revision each link provides. Prefer durable links that the user can open on
another device. If either platform's updated build is unavailable, say so
explicitly and label any previous build accurately; do not omit that platform.
