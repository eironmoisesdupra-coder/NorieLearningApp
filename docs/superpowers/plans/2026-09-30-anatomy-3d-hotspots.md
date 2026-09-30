# Anatomy 3D Hotspots Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add real, model-space numbered hotspots to the standalone skeletal 3D viewer, with study/identification/clean modes, structure selection, and hotspot-backed skeletal quiz visuals.

**Architecture:** Define renderer-independent hotspot/calibration data in the anatomy domain. Render hotspot buttons as native `<model-viewer>` child slots so positions rotate and zoom with the GLB. Use normalized anatomical coordinates converted to model-space from `getBoundingBoxCenter()` and `getDimensions()`, with an internal HTML detail card that works on web and a JavaScript channel that additionally synchronizes selection back to Flutter on mobile.

**Tech Stack:** Flutter/Dart, `model_viewer_plus` 1.10.0, Google `<model-viewer>` hotspot slots, existing AnatomyCatalog/NorieProgression.

**Spec:** `docs/superpowers/specs/2026-09-29-anatomy-3d-hotspots-design.md`

## Global Constraints

- Never reuse the old normalized 2D screen coordinates for the real GLB.
- Hotspots must live in model space and follow rotation/zoom/preset camera movement.
- Minimum v1 skeletal structures: skull, mandible, clavicle, scapula, sternum, rib cage, vertebral column, pelvis, humerus, radius, ulna, femur, patella, tibia, fibula.
- Keep existing pseudo-layered viewer for non-standalone-skeletal combinations.
- Preserve current camera controls and attribution.
- Provide clean mode with no hotspots.
- Provide a text/list fallback if hotspot rendering/calibration is unavailable.
- Quiz correctness is structure-id based, never coordinate based.
- Keep the existing free/open anatomy asset attribution.
- Do not claim medical or surgical precision.

## Review Focus

- Web behavior when Flutter JavaScript channels are unavailable: marker tap must still reveal structure information inside the model-viewer DOM.
- Model replacement/calibration mismatch: viewer must not silently display stale anchors.
- Marker overlap on narrow portrait layouts: lower-priority labels should not obscure the entire model.
- Hidden/clean mode: no invisible hotspot should remain keyboard/tap focusable.
- Mobile WebView interaction: hotspot taps must not break orbit/zoom gestures.

---

### Task 1: Hotspot domain and skeletal catalog expansion

**Files:**
- Create: `lib/features/learning/domain/anatomy_hotspot_models.dart`
- Modify: `lib/features/learning/domain/anatomy_models.dart`
- Modify: `test/anatomy_lab_test.dart`

**Interfaces:**
- Produces: `AnatomyHotspot`, `AnatomyHotspotSide`, `AnatomyHotspotMode`, `AnatomyModelCalibration`
- Produces: `AnatomyHotspotCatalog.skeletal`
- Produces: `AnatomyHotspotCatalog.hotspotsFor(Set<AnatomySystemId>)`
- Produces: `AnatomyHotspotCatalog.resolveStructure(String)`

- [ ] **Step 1: Write failing domain tests**
  - enabled hotspot ids are unique;
  - every enabled hotspot resolves to a valid skeletal `AnatomyStructure`;
  - catalog contains at least the 15 minimum structure ids;
  - normalized model coordinates are within -0.5..0.5 on all axes;
  - calibration id/schema/source commit are non-empty;
  - clean mode returns no renderable hotspots.

- [ ] **Step 2: Run tests and verify RED**
  Run: `flutter test test/anatomy_lab_test.dart`
  Expected: FAIL because hotspot domain/catalog does not exist.

- [ ] **Step 3: Implement domain and expand skeletal structures**
  Use stable ids:
  `skull`, `mandible`, `clavicle`, `scapula`, `sternum`, `rib-cage`, `vertebral-column`, `pelvis`, `humerus`, `radius`, `ulna`, `femur`, `patella`, `tibia`, `fibula`.
  Preserve existing four structure ids and add the missing eleven.

- [ ] **Step 4: Run tests and verify GREEN**
  Run: `flutter test test/anatomy_lab_test.dart`
  Expected: PASS.

- [ ] **Step 5: Commit**
  `git commit -m "feat: add calibrated skeletal hotspot catalog"`

### Task 2: Deterministic anatomy asset pinning

**Files:**
- Modify: `scripts/fetch_anatomy_assets.sh`
- Modify: `assets/anatomy/ATTRIBUTION.md`
- Test: `test/anatomy_lab_test.dart`

**Interfaces:**
- Pins upstream model source to commit `e4d76fbb424d15e1364963528a082a78fa359161`
- Produces calibration source commit matching the fetch script

- [ ] **Step 1: Add failing source-pin test**
  Assert calibration source commit is the pinned commit and fetch script contains the same commit path rather than `refs/heads/main`.

- [ ] **Step 2: Run test and verify RED**
  Run: `flutter test test/anatomy_lab_test.dart`

- [ ] **Step 3: Pin download URL and document source**
  Keep size sanity validation. Do not remove attribution.

- [ ] **Step 4: Run test and verify GREEN**

- [ ] **Step 5: Commit**
  `git commit -m "build: pin skeletal anatomy asset source"`

### Task 3: Native model-viewer hotspot renderer

**Files:**
- Create: `lib/features/learning/presentation/anatomy_3d_hotspot_html.dart`
- Modify: `lib/features/learning/presentation/anatomy_real_3d_model.dart`
- Create: `test/anatomy_3d_hotspot_html_test.dart`

**Interfaces:**
- Produces: `Anatomy3DHotspotHtml.innerHtml(...)`
- Produces: `Anatomy3DHotspotHtml.css`
- Produces: `Anatomy3DHotspotHtml.js`
- `AnatomyReal3DModel` accepts `hotspots`, `mode`, `selectedHotspotId`, `onHotspotSelected`

- [ ] **Step 1: Write failing HTML renderer tests**
  Assert:
  - every hotspot emits a `slot="hotspot-..."` button;
  - marker has model-normalized data attributes, not screen x/y;
  - clean mode emits no hotspot buttons;
  - identification mode omits visible names;
  - explore mode includes accessible names;
  - JS uses `getBoundingBoxCenter()` and `getDimensions()` to convert normalized coordinates to model-space;
  - JS posts selected id to `AnatomyHotspot` channel when available;
  - each button contains a focus-visible detail card for web fallback.

- [ ] **Step 2: Run test and verify RED**

- [ ] **Step 3: Implement HTML/CSS/JS builder and wire ModelViewer**
  Use `innerModelViewerHtml`, `relatedCss`, `relatedJs`, `minHotspotOpacity`, `maxHotspotOpacity`, and a JavaScript channel.
  Marker visible dot may be ~28px; hit target must be >=44px.

- [ ] **Step 4: Run test and verify GREEN**

- [ ] **Step 5: Commit**
  `git commit -m "feat: render model-space anatomy hotspots"`

### Task 4: Viewer modes, selection, and fallback list

**Files:**
- Modify: `lib/features/learning/presentation/anatomy_viewer_screen.dart`
- Test: `test/anatomy_3d_hotspot_viewer_test.dart`

**Interfaces:**
- Produces UI mode selector: Explore / Identify / Clean
- Consumes hotspot selection callback and resolves `AnatomyStructure`
- Produces accessible fallback structure list for standalone skeletal mode

- [ ] **Step 1: Write failing widget/policy tests**
  Assert mode selector exists in real skeletal mode, clean mode hides marker HTML, selecting a known hotspot resolves the correct structure, and fallback list remains available.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Wire hotspot catalog into real viewer**
  - Explore: numbered markers + short labels/detail card.
  - Identify: numbers only until selected.
  - Clean: no markers.
  - Flutter selection shows the existing `_StructureInfoCard` on mobile callback.
  - Keep the HTML detail card as web fallback.
  - Pause auto-rotate when a hotspot is selected.

- [ ] **Step 4: Add compact text fallback sheet/list**
  It must be reachable even if the 3D hotspot bridge fails.

- [ ] **Step 5: Run and verify GREEN**

- [ ] **Step 6: Commit**
  `git commit -m "feat: add 3D hotspot study modes"`

### Task 5: Hotspot-backed skeletal quiz visual

**Files:**
- Modify: `lib/features/learning/presentation/anatomy_quiz_screen.dart`
- Create: `lib/features/learning/domain/anatomy_hotspot_quiz_policy.dart`
- Test: `test/anatomy_hotspot_quiz_test.dart`

**Interfaces:**
- Produces deterministic `hotspotForStructureId(String)`
- Uses `AnatomyReal3DModel` with one quiz hotspot when target is skeletal and calibrated
- Falls back to current pseudo-body visual for unsupported/non-skeletal targets

- [ ] **Step 1: Write failing quiz policy tests**
  Assert skeletal structure ids resolve to hotspot ids and unknown/non-skeletal ids do not.

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement policy and real skeletal quiz visual**
  Quiz evaluation continues to compare structure ids/names, never coordinates.

- [ ] **Step 4: Run and verify GREEN**

- [ ] **Step 5: Commit**
  `git commit -m "feat: use real skeletal hotspots in anatomy quiz"`

### Task 6: Final integration and release verification

**Files:**
- Modify only files required by verified failures.

- [ ] **Step 1: Run analyzer**
  `flutter analyze`
  Expected: no issues.

- [ ] **Step 2: Run full suite**
  `flutter test`
  Expected: all tests pass.

- [ ] **Step 3: Build Android release**
  `flutter build apk --release`
  Expected: success.

- [ ] **Step 4: Build web release**
  `flutter build web --release`
  Expected: success.

- [ ] **Step 5: Manual review checklist**
  Front/back/left/right/top, zoom, orbit, mobile portrait, desktop, marker tap, Explore/Identify/Clean, selection card, fallback list, skeletal quiz.

- [ ] **Step 6: Whole-branch review before promotion**
