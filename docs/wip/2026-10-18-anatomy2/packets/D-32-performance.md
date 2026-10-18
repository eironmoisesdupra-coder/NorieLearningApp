# Phase D — #32 Anatomy Performance Optimization

- Baseline first: record model load time, peak memory, draw calls, actual frame times, GPU availability, asset sizes, and user-visible navigation delays using documented setups.
- Investigate on-demand / throttled renderer frame scheduling when idle; preserve active controls/damping/selection feedback.
- Profile WebGL contexts and dispose meshes/materials/textures safely on reference switches and screen exit.
- Test adaptive device pixel ratio and antialias quality profiles with explicit fallback; reduced-motion must disable decorative motion without breaking interaction.
- Evaluate meshopt level-of-detail, selective asset loading, and caching without losing named selectable source parts or violating attribution.
- Asset size and offline release checks must stay in CI; optional future packs cannot make core models inaccessible offline.
- No claimed fps/memory improvements without before/after measurement on physical Android/Windows; report any cost/regression and rollback strategy.
