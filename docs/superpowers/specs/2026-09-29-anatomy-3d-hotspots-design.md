# Anatomy Lab Real 3D Hotspots — Design Specification

Date: 2026-09-29
Status: Proposed for implementation
Baseline: main @ 79a136d68e541e7e4c739d60b71d41f1dd73a328

## 1. Purpose

Replace the old 2D numbered anatomy markers with true 3D hotspots that remain attached to the correct skeletal structures while the user rotates, zooms, pans, or changes camera presets.

This makes the real GLB skeleton usable for identification, inspection, and quizzes without showing misleading screen-space markers.

## 2. Current Problem

The standalone skeletal layer now uses a real GLB model.

The existing anatomy structure coordinates are normalized 2D x/y values created for the previous CustomPaint body. Those coordinates do not follow the real mesh during 3D camera movement.

Therefore, showing the old markers over the rotating GLB would be visually inaccurate.

## 3. User Experience Goals

Users should be able to:

- rotate and zoom the real skeleton freely;
- see numbered hotspots anchored to actual bone locations;
- tap/click a hotspot to select a structure;
- open a structure card with name, description, and function;
- use a clean study mode with names visible;
- use an identification mode with numbers only;
- use the same hotspot definitions for skeletal quizzes;
- hide markers when they want an unobstructed model;
- retain readable marker size at different screen sizes and camera distances.

## 4. Scope

Initial real-hotspot coverage should focus on the major skeletal structures already represented by Norie’s skeletal lesson data, then expand to more bones.

Minimum v1 anchors:
- skull/cranium;
- mandible;
- clavicle;
- scapula;
- sternum;
- rib cage;
- vertebral column;
- pelvis;
- humerus;
- radius;
- ulna;
- femur;
- patella;
- tibia;
- fibula.

Where left/right structures are distinct, the data model should support separate left/right anchor ids even if the introductory lesson displays one shared label.

## 5. Architecture

### AnatomyHotspot

A domain object defining one 3D anchor.

Fields:
- id;
- structureId;
- label;
- system;
- x, y, z model-space coordinates;
- optional side;
- optional camera hint;
- priority;
- enabled.

Coordinates are stored in the skeleton model’s local coordinate system, not screen pixels.

### AnatomyHotspotCatalog

Maps Norie structure ids to one or more model-space anchors.

Responsibilities:
- return hotspots for selected systems;
- provide identification numbering;
- provide quiz candidate anchors;
- allow future model versions to use a different calibration profile.

### AnatomyModelCalibration

The GLB asset needs a calibration record containing:
- model id/version;
- coordinate scale;
- origin reference;
- upright axis;
- front direction;
- optional default camera;
- hotspot schema version.

This prevents hotspot data from silently becoming wrong if the skeleton model is replaced later.

### Anatomy3DHotspotLayer

Responsible for rendering visible markers and converting model-space anchors to current screen-space positions.

It must not guess positions from the old normalized 2D marker coordinates.

## 6. Rendering Strategy

The preferred implementation is to render hotspots in the same 3D/model-viewer scene where possible, because scene-level anchors naturally follow camera rotation.

If the Flutter wrapper does not expose model-viewer hotspot APIs directly, implement a small web/model-viewer bridge rather than approximating rotation in Flutter.

Required behavior:
- hotspot remains attached to its model-space point;
- hotspot is hidden or visually de-emphasized when occluded behind the body where practical;
- hotspot position updates during camera motion;
- marker remains tappable on Android and web.

A pure Flutter screen-space overlay is acceptable only if it uses the exact current model/view/projection transforms. Static 2D coordinates are not acceptable.

## 7. Hotspot Visual Design

Default marker:
- circular numbered marker;
- high-contrast Norie cyan/white treatment;
- thin dark outline for visibility over bone;
- subtle selected pulse;
- minimum accessible touch target around 44 px while the visible dot may be smaller.

Modes:

### Explore
- number + optional short label;
- selected structure card visible after tap.

### Identification
- number only;
- names hidden until the learner answers or reveals.

### Clean
- all markers hidden.

### Quiz
- only required target markers shown;
- numbering may be randomized per attempt.

## 8. Selection Flow

When a marker is tapped:
1. hotspot id resolves to AnatomyStructure;
2. selected marker enters selected visual state;
3. structure information card opens;
4. optional camera focus may move the selected structure closer;
5. current selection is accessible to quiz/tutorial systems.

Closing the card does not reset the camera.

## 9. Camera and Marker Interaction

The existing camera controls remain:
- rotate/orbit;
- pinch/scroll zoom;
- pan/target shift;
- front/back/left/right/top presets;
- reset;
- optional auto-rotation.

Hotspot requirements:
- marker anchors survive every camera operation;
- marker screen size should not become microscopic when zoomed out;
- overlapping markers should reduce clutter through priority or clustering;
- auto-rotation should pause briefly after a user selects a hotspot.

## 10. Quiz Integration

The Anatomy quiz should be able to request hotspot-based questions.

Question types:
- “Tap structure N” after a name prompt;
- identify the name of a numbered hotspot;
- function question linked to a selected bone;
- optional camera-targeted structure question.

Quiz logic still uses NorieProgression.recordTopicAnswer and existing XP/reward systems.

For correctness:
- quiz evaluation uses structure/hotspot ids, never visual screen coordinates.

## 11. Tutorial Integration

The Norie mascot tutorial can later use the hotspot system to:
- point toward the skeleton;
- instruct “rotate the model”;
- highlight one real bone;
- demonstrate tapping a numbered marker;
- transition into a first identification question.

The hotspot API should expose selected/highlighted state so the mascot engine does not manipulate renderer internals.

## 12. Calibration Workflow

Hotspot calibration should be explicit and reviewable.

Process:
1. load the exact production GLB;
2. establish model origin and axes;
3. place anchors at recognizable anatomical landmarks;
4. verify front/back/side camera views;
5. verify mobile portrait and desktop layouts;
6. record coordinates in the catalog;
7. review each anchor visually before enabling it.

Calibration data must be versioned with the model. If the GLB checksum/version changes, a test or runtime assertion should flag the mismatch.

## 13. Asset Reproducibility and Security

The 3D asset fetch should be deterministic.

Before production promotion:
- pin the skeleton source to a specific upstream commit/version rather than a moving branch;
- store/verify a SHA-256 checksum;
- preserve required attribution;
- avoid enabling broad Android cleartext networking unless the chosen renderer actually requires it.

The current free model remains a development model and may later be replaced by a more accurate licensed asset without changing the hotspot/quiz API.

## 14. Performance

Targets:
- marker updates stay smooth during camera movement;
- do not rebuild the entire Anatomy screen for every animation frame;
- only visible/enabled hotspots participate in layout/hit testing;
- support at least the initial major-bone set comfortably on mid-range Android devices;
- expanded full-skeleton labeling may use level-of-detail or category filtering.

## 15. Accessibility

- marker touch targets remain large enough for touch users;
- selected structure is also available in a text/list alternative;
- keyboard users on web can move through visible structures;
- marker numbers are not the only semantic information exposed to accessibility services;
- color is not the only selected/correct indicator.

## 16. Error Handling

If the GLB loads but hotspot calibration is unavailable:
- show the skeleton without misleading markers;
- provide the structure list as a fallback;
- disable hotspot quiz modes with an explanatory message.

If a hotspot references a missing structure id:
- ignore that hotspot safely;
- surface the mismatch in debug/test output.

## 17. Testing

Unit tests:
- all enabled hotspots resolve to valid AnatomyStructure ids;
- hotspot ids are unique;
- model calibration version is present;
- side-specific anchors are valid;
- quiz target resolution is deterministic.

Widget/integration tests:
- marker selection opens the expected structure;
- marker modes toggle correctly;
- clean mode hides hotspots;
- hotspot quiz records correct/incorrect answers correctly;
- fallback structure list remains usable.

Visual/manual verification:
- front, back, left, right, top;
- zoomed in/out;
- portrait mobile;
- desktop/web;
- representative bones in skull, torso, arm, pelvis, and leg.

Build verification:
- Flutter analyze;
- full tests;
- Android release APK;
- web release.

## 18. Non-Goals for v1

- labeling every individual carpal/tarsal/vertebral element;
- surgical/clinical precision;
- mesh deformation or bone animation;
- X-ray rendering;
- automatic AI-generated hotspot coordinates;
- pretending the free model is medically certified.

## 19. Upgrade Path

The hotspot system is model-calibrated but not renderer-specific.

A future premium/licensed skeleton should require:
1. a new calibration profile;
2. hotspot coordinate review;
3. asset/license update.

Lesson, quiz, tutorial, and mascot integrations should remain unchanged.
