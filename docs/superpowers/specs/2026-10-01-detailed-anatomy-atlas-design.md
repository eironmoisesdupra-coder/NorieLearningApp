# Detailed offline Anatomy Lab

## Agreed outcome

Finish NorieLearning's existing Anatomy Lab as an interactive adult anatomy atlas,
inspired by Anatomy Learning's exploration workflow. The user selected detailed
adult anatomy, including male and female reproductive structures. Support Windows
PC and Android, with the installed atlas available offline. AI quiz generation
remains the only learning feature that requires connectivity.

All fifteen existing categories remain: Skeletal, Articular, Muscular, Heart,
Arteries, Veins, Nervous, Lymphatic, Respiratory, Digestive, Urinary, Reproductive,
Endocrine, Integumentary, and Sense Organs.

## Current implementation and gaps

The current catalog contains broad learning structures, a calibrated bilateral
skeleton, one combined organ GLB, and painted stand-ins. System selection does not
filter the individual organ meshes. The web model-viewer integration inserts
scripts with innerHTML, preventing the expected hotspot initialization and
selection callbacks. A category existing in the menu is not evidence that its
3D system is implemented.

## Selected architecture

Keep the Flutter lab entry, theme, navigation, learning content, and progression
hooks. Add a shared bundled Three.js renderer behind a small platform adapter:
an iframe on web/Windows and a local WebView on Android. Bundle all scripts,
decoders, metadata and models. No CDN, sign-in or AI call is needed to explore,
search, select structures or take atlas identification quizzes.

Use direct mesh picking with stable source identifiers, rather than projected
screen-position guesses. The renderer owns the camera and loaded mesh state;
Flutter owns category selection, searchable structure information and quiz state.
Messages include a protocol version and session identifier. Web messages must
validate their source window and expected origin; native messages must validate
their schema. Only structured commands are allowed, never arbitrary script text.

The existing complete skeleton and its calibrated learning hotspots remain
available as the foundational skeleton study view. Preserve their source assets,
coordinates, credits and tests. The detailed atlas uses its own coherent source
coordinate system; never mix bodies from different datasets using guessed scales.

## Model library and provenance

Use official BodyParts3D 4.0 meshes and ontology relationships for the core adult
body. The inspected archive metadata maps 2,234 distinct mesh identifiers; this
is a source inventory, not a promised number of individually named structures.
The official archive currently licenses its data under CC BY 4.0:
https://dbarchive.biosciencedbc.jp/en/bodyparts3d/lic.html

Use versioned Human Reference Atlas female organ models and their ontology
crosswalks for the female reproductive study scene. These retain their female
reference coordinates and appropriate surrounding organ context. Do not insert
female organs into the male reference body or imply that a partial female
reference is a complete female full-body atlas.
https://humanatlas.io/3d-reference-library

Every distributed source must have recorded authorship, source version, URL,
license, checksum, units, orientation and any conversion changes. Avoid relying
on blanket licensing claims from repackaged mirrors. Additional lymphatic and
sense-organ components require the same provenance checks. Unresolved or missing
geometry is a completion blocker, not permission to substitute unlabeled shapes.

Build scripts fetch verified sources and produce optimized per-system GLBs and a
manifest with stable structure IDs, names, system membership, mesh identifiers,
body reference, bounding boxes and source credits. Shared structures may belong
to multiple categories without loading duplicate geometry. Keep generated large
assets out of ordinary source commits; make every CI/package path reproduce them.

## Exploration behavior

- Rotate, pan and zoom with mouse and touch; standard anatomical views and reset.
- Tap/click visible anatomy to select, highlight, name and focus a structure.
- Search names and browse structures within the selected systems.
- Show multiple systems together; hide a structure, isolate it, adjust opacity,
  and restore the selected systems without losing the camera unexpectedly.
- Separate clearly labeled male and female reproductive reference scenes.
- Show useful loading progress and a recoverable local asset error. Never silently
  fall back to a painted diagram in the detailed atlas.
- Keep controls usable on a small phone, and preserve the navy/cyan/violet theme.
- Provide source credits from the lab itself.

## Study and quizzes

Retain the existing curated function/description learning content and its XP,
mastery, achievements and account hooks. Detailed identification questions can
use only mapped, renderable structures from the selected reference and systems.
Do not invent function descriptions for thousands of structures from their names.
Hide answer labels/search hints while an identification question is active;
highlight the target geometry without revealing its name. Award progress once
per answered question and final reward once per completed quiz.

## Offline delivery and performance

PC and Android installation packages include the complete atlas library. Load
only requested system files, release unused geometry/material resources, and
avoid loading the whole library merely to display its searchable metadata.
Measure actual bundle size, initial system load and interaction behavior before
claiming acceptable phone performance. Browser installation must cache the atlas
and indicate readiness before claiming full offline availability.

## Completion evidence

All fifteen categories must have verified, selectable real geometry and correct
membership. Female and male reproductive scenes must contain the promised
structures and use their proper reference context. Check missing IDs, duplicates,
empty systems, invalid bounds, unknown licenses and checksum failures at build
time. Record actual coverage and remaining dataset limitations explicitly.

Automated tests must cover layer filtering, picking, hide/isolate/restore,
selection during asynchronous loads, repeated scene changes, touch versus drag,
quiz answer concealment and existing progression. Run an actual browser/packaged
Windows test with networking disabled, and validate the Android asset-serving
path and release build. Run flutter analyze, flutter test and relevant renderer,
packaging and service-worker tests.

Use a feature branch from current develop, a reviewed PR, green required CI,
merge into develop, and verify the deployed preview revision. Do not merge main.
The final handoff must include the exact revision, test/CI state, known limits,
and download links for both the updated Windows package and Android APK.

## Alternatives considered

Extending model-viewer hotspots alone preserves the present renderer but does not
provide a reliable public mesh-selection/layer-control interface for a detailed
atlas. A commercial embedded atlas could provide broader curated coverage but
introduces licensing, distribution and potentially network dependencies. A
bundled renderer and attributed open model library best matches this app's
offline requirement and existing Flutter learning experience.
