# Anatomy Lab 2.0 integration design

User request: implement Anatomy Lab improvements in the attached roadmap #28?33. The archive is an implementation specification, not existing code. Baseline is current develop 3b614d783ef4ce78609be382d4d81882d2e3c6a8 (0.15.1+20). Original requirements are preserved under docs/wip/2026-10-18-anatomy2.

## A: Explorer and flexible quizzes
Extend the existing explorer with beginner/advanced presentation, collapsible systems/details and explicit source/reference metadata without remounting the model during panel changes. Search names, source IDs and ontology using bounded input; synonyms/regions only when explicitly curated. Preserve legacy control labels used by accessibility and offline checks. Configure 5/10/20 unique-part quizzes, guided/standard/challenge presentation, opt-in system questions grounded in catalog data and explicit low-pool fallback. Keep the existing 20-item identification defaults, score*10 XP policy, idempotent reward claims and tutorial entry points.

## B: Guided learning
Add a versioned seven-step Discover/Locate/Understand/Explore/Practice/Apply/Review flow tied to actual catalog IDs and references. Local owner-scoped persistence records identification, assisted learning and independent evidence separately; completion does not grant academic mastery or extra XP. Provide a small representative set of complete navigation samples using already-published catalog facts. New location/function/misconception assertions are drafts until qualified human approval; never invent a reviewer. Source-backed drafts remain separately inspectable, unavailable descriptions are explicit. Existing curriculum infrastructure is optional.

## C: 3D interactions
Add validated per-system visibility/opacity commands, reference-safe compare, owner/reference-scoped bookmarks and named deterministic camera views. Preserve global opacity, selected-object labels, isolate/hide/restore and clean reference resets. No physical measurement without calibrated scene units. Commands validate payload shapes and stale/disposed requests do not mutate scenes.

## D: Performance
Measure the existing renderer in a reproducible desktop browser fixture before changes. Add demand-driven frame scheduling with damping and pointer activity, background pause, explicit quality/DPR profiles, safe resize/context loss/retry and resource disposal. Expose bounded diagnostic counters/timings and compare the same fixture afterward. Report browser measurements as browser measurements, not physical-device certification. Preserve every named selectable mesh and the offline bundle; do not introduce lossy LOD or runtime downloads.

## E: Coverage and release evidence
Generate a per-structure audit for source ID/reference/system/name/license and reviewed/draft/missing teaching metadata. Expose reference-specific coverage limitations and unknown IDs as unreviewed. Preserve all 3,949 selectable model parts, 34 model files, 15 systems, source coordinate frames, labels, attribution, mirrored skeleton and hotspots. No claim of a complete female body, lymph-vessel network or microscopic sensory atlas. Publish only Preview packages through existing develop PR/CI/preview workflow; main and production signing remain untouched.

## Validation
Targeted red/green tests, full Flutter analysis/tests, viewer Node tests, Python catalog pipeline, release web build, compiled model picking/search/quiz/progress checks, 320px/160% layouts, reduced motion/keyboard controls and packaged Windows offline/Android builds. Exact-head and final merged-source CI must pass. Physical-device and expert editorial evidence remain external gates. Final handoff identifies real source SHA and versioned Windows ZIP/Android APK downloads.
