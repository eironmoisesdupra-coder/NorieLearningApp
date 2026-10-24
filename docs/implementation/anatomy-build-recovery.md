# Recovery of unchanged legacy Anatomy build assets

On2026-10-24 the previously public `yamz8/human-body-simulator` repository and pinned skeleton URL returned404. The unchanged legacy fetch step prevented Flutter, Windows and Store-readiness CI from reaching application checks. This repair retains the existing models, hotspot calibration, mirror transforms, names and licenses.

`scripts/anatomy/legacy_models.py` first accepts only checksum-identical local output. Otherwise it attempts the original checksum-pinned skeleton and newly pinned organ output. An unavailable upstream can recover the two exact models from NorieLearning's already-published v0.18.0 Windows archive, source `ed9472dbb437127abd8fd09931a86879d4df5ec5`. No executable is extracted or run. A changed/corrupt archive or model fails closed; no geometry substitute is permitted. Original mirror provenance remains recorded separately from the actual recovery route.

| Pin | SHA256 |
|---|---|
| Official v0.18.0 Windows ZIP |`d65b2530084e9b6832e7ce0cb3fbeb8bc08c18142ba6da6468de51702452c959`|
| Original skeleton input |`253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce`|
| Bilateral skeleton output |`5cff2708bf15083a034cd4aa0f47361432be1e60687ef0f9993dc4fb3cae78d1`|
| Legacy organ output |`fa0f8a32e6f1fdc8f8c469f81409289b0141cebe5d37e3e0048a134cf8bf6eb6`|

Release/archive origin: https://github.com/eironmoisesdupra-coder/NorieLearningApp/releases/tag/v0.18.0 . The archive hash matches its official release metadata. The actual downloaded archive was verified and both recovered models matched the independently retained prior-build model bytes. Skeleton bounds validation reports252 mesh nodes,2416728 bytes, unchanged dimensions. This is byte/build integrity, not medical verification.

All requested members and hashes are checked before any output replacement. ASAR lengths/offsets/member paths/link flags are bounded; arbitrary ZIP members are never extracted. Temporary files are closed before cleanup/replacement, including on Windows failures. Individual replacements are atomic. Detailed atlas source/cache/conversion/catalog/audit steps continue unchanged. The original CC BY-SA notices and upstream links remain in `assets/anatomy/ATTRIBUTION.md`; the recovery origin is appended without changing those terms.

Run `python -m unittest test.anatomy_legacy_recovery_test test.anatomy_pipeline_test test.anatomy_audit_test` and `python scripts/anatomy/legacy_models.py`. Six recovery tests plus24 existing pipeline/audit tests passed, including tampering, missing members, bounds/links, preserved existing bytes and a RED→GREEN Windows open-file cleanup regression. Actual snapshot recovery and a second verified-cache run passed. `bash -n scripts/fetch_anatomy_assets.sh` and Python compile passed. Independent read-only review is recorded in the PR; complete platform CI remains required.

The fixed release snapshot must remain available; if it changes or disappears, builds deliberately fail until an equally reviewed byte-identical source is supplied. No production deployment, release asset upload, paid operation, new mesh, anatomical mapping or version bump is part of this repair.
