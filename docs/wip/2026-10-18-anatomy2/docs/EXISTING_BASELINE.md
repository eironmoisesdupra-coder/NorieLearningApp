# Inspected starting point

- `docs/anatomy-atlas-coverage.md`: 15 systems, 3,949 selectable model parts, 34 models totaling 102.7MB before compression. Female reference is partial; other limitations documented.
- `lib/features/learning/presentation/anatomy_atlas_screen.dart`: searchable structures, reference switching, isolate/hide/restore, global preset opacity, six camera views, quiz entry, license display and tutorial integration.
- `lib/features/learning/presentation/anatomy_atlas_quiz_setup_screen.dart`: currently a fixed 20-question Atlas quiz with selectable systems/references.
- `anatomy_viewer/src/scene.mjs`: Three.js WebGL renderer, OrbitControls, GLTFLoader with Meshopt, raycast picking, active animation loop, source-aware async loading, and resource dispose.
- `lib/features/learning/presentation/anatomy_atlas_model_view.dart`: bridge loads/configures and handles error/retry.

Inspect actual latest source again before making any code changes. Avoid regressing what exists.
