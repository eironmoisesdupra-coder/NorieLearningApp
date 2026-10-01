# Anatomy coverage expansion implementation plan

> Execute inline using superpowers:executing-plans, with a whole-branch review.

**Goal:** Prioritize additional genuine 3D coverage: joint ligaments/capsules and endocrine glands.
**Architecture:** Extend the existing catalog and source conversion pipeline. Keep Z-Anatomy joint/bone and gland scenes in their own source coordinates; retain existing body, female, lymph and ear references.
**Tech stack:** Flutter, Three.js, glTF Transform, Python, existing offline packaging.
**Spec:** ../specs/2026-10-01-detailed-anatomy-atlas-design.md; user clarification: additional 3D coverage first.

## Constraints and review focus

- Preserve the original skeleton view, progress, offline quizzes and every current system.
- Pin source bytes/hashes and retain attribution. Only explicitly reviewed gland meshes may leave the mixed-license visceral source; exclude kidney and nervous-source geometry.
- Keep source world transforms; joint bones must come from the same Z-Anatomy export.
- Counts mean selectable model parts, including context bones, not new unique anatomical structures.
- Test reference switching, small targets, source whitelist drift, endocrine duct exclusion and offline loading.

## Tasks

- [x] Add failing pipeline tests for joint/gland coverage and endocrine classification; observe failure on the current catalog.
- [x] Pin joints, skeletal context and visceral source files in `scripts/anatomy/sources.json`. Add a strict source selection module and conversion entries for `joints` and `glands` references. Reject missing or duplicated whitelist names.
- [x] Correct explicit endocrine organ overlap in `build_body.py` and HRA conversion, excluding ducts and ovarian ligaments; regenerate and validate the catalog and actual GLB nodes.
- [x] Add reference defaults, detail entry links and accurate coverage/license text to `anatomy_atlas_screen.dart`. Keep existing controls and quiz behavior.
- [ ] Extend real-browser smoke tests with new scenes and gland/joint picking. Run Python, Node, Flutter analysis/tests, web build and packaged desktop offline checks.
- [ ] Review the whole branch, address findings, publish PR into develop, wait for Windows/Android CI, merge and verify preview. Provide both exact-revision download links.

## Decisions

This is an extension of the already-approved atlas design. Implementation continues under the user's instruction to finish categories and prioritize models; no additional design approval is needed. Use the existing workspace feature branch, preserving the user's AGENTS.md edit. Additional skin microanatomy and female perineal sources remain research candidates until downloadable geometry and licensing can be verified.

## Verification ledger

133 Flutter tests passed, including 320x568 layout with a selected gland; analysis clean. Seven Python tests, eleven Node atlas tests, nine cache/desktop boundary tests and catalog GLB validation passed. Offline browser rendered every system and picked ACL, thyroid and parathyroid. Review confirmed all 637 new mesh world bounds within 0.02 mm of source after compression. Review findings fixed: one horizontal detail-link row, horizontal selection actions and exact output-gland mesh whitelist. Final packaged desktop/CI release checks continue.

Release-gate finding: the Flutter reference dropdown painted its menu but did not expose operable menu items with web semantics enabled; the packaged check and Windows CI reproduced it. Replaced it with a bounded, scrollable reference chooser using the proven search-sheet ListTile pattern, showing source coverage descriptions. The 320x568 widget test now scrolls to and selects glands, verifying the 11-part result.
