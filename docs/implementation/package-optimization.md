# Package size audit and safe optimization

The audit preserves the complete offline lesson experience. It measures declared
source assets and final packages separately: source byte totals cannot predict APK
compression, Flutter runtime size, Electron overhead, or final ZIP size.

## Inventory boundary

`python scripts/release/asset_budget.py` reads the repository's block-style
`flutter.assets` and `flutter.fonts` declarations from `pubspec.yaml`. It inventories
those asset roots, de-duplicates overlapping declarations, and hashes every included
file with SHA-256. The current roots are `assets/anatomy`, `assets/audio` (including
music and SFX), `assets/achievements`, `assets/ranking`, `assets/mascot`, plus the
explicit fonts and font attribution/license files. Hidden development files,
`node_modules`, `build`, `.dart_tool`, `.pub-cache`, `.git`, and `__pycache__` are
excluded. Symlinks and Windows junctions are never traversed, including declared
paths with linked ancestors; skipped links remain visible in the JSON inventory.
Unsupported asset/font declarations, missing declared assets and unreadable
source directories are errors; directory traversal failures never become silent
empty inventory entries.

`anatomy_viewer/src` is build input, not an additional bundled asset root.
`anatomy_viewer/build.mjs` writes the bundled local renderer, HTML and renderer
licenses into `assets/anatomy`; `convert-models.mjs` writes optimized models and
the catalog there. Research/conversion caches remain under `build/`.
`scripts/fetch_anatomy_assets.sh` prepares these files before release builds.
The Windows packager copies the built Flutter web bundle and adds its pinned
Draco decoder/license and Electron runtime. Flutter package assets, generated web
runtime files, and desktop decoder/runtime bytes are accounted for by the final
artifact measurements, rather than incorrectly counted as source assets.

The source inventory is an audit of eligible files under declared roots, not a
replacement for Flutter's generated AssetManifest or a package-contents parser.
Image variants and future asset subdirectories should still be checked against
that manifest when changing declarations.

## Measurements reviewed on 2026-10-17

Local source assets at the `6364ff7c043a465653e13cc8108a4be08ee3b312` integration
baseline (generated/fetched assets present): **88 files, 172,915,380 bytes
(164.90 MiB)**. No byte-identical asset duplicates were found after excluding
hidden `.gitkeep` placeholders.

| Source group | Bytes | MiB |
| --- | ---: | ---: |
| Anatomy | 107,531,522 | 102.55 |
| Audio, including music, SFX and manifests | 47,929,569 | 45.71 |
| Ranking | 8,581,404 | 8.18 |
| Achievements | 5,315,057 | 5.07 |
| Mascot | 2,874,435 | 2.74 |
| Fonts, attribution and licenses | 683,393 | 0.65 |

Largest files include `assets/anatomy/female-digestive.glb` (20,835,424 bytes),
`assets/audio/music/synthwave_421k.mp3` (18,976,382),
`assets/anatomy/female-sensory.glb` (12,549,360),
`assets/anatomy/male-muscular.glb` (12,337,156), and
`assets/anatomy/female-articular.glb` (11,585,596).

Published **0.12.0+16 Preview** release metadata for source
`6364ff7c043a465653e13cc8108a4be08ee3b312` records Android APK **229,384,836 bytes
(218.76 MiB)** and Windows portable ZIP **315,112,049 bytes (300.51 MiB)**.
These are published metadata observations, not newly rehashed local packages.
The source-only audit leaves both package measurements explicitly `not_measured`.
New package hashes must come from the exact final files supplied to the CLI.

## Reviewed soft limits and CLI contract

`scripts/release/package-budgets.json` retains the WIP guardrails: Android
**251,658,240 bytes (240 MiB)**, Windows **346,030,080 bytes (330 MiB)**, and any
single source asset **83,886,080 bytes (80 MiB)**. Those limits leave 22,273,404
Android bytes and 30,918,031 Windows bytes above the published 0.12 baseline.
They are project budgets, not store size limits or performance certification.
Equality passes; comparisons use integer bytes, never rounded displayed MiB.
`--fail-on-growth` enforces these reviewed ceilings, rather than rejecting every
byte of growth from the historical observation.

Run after licensed asset preparation and final APK creation:

```sh
python -m unittest discover -s test -p asset_budget_test.py
python scripts/release/asset_budget.py --android build/app/outputs/flutter-apk/app-release.apk --json-output build/android-package-size-report.json --fail-on-growth
```

Run after `Compress-Archive` creates the complete Windows portable ZIP:

```sh
python scripts/release/asset_budget.py --windows build/NorieLearning-Windows.zip --json-output build/windows-package-size-report.json --fail-on-growth
```

Both paths can be supplied in a single invocation when both final files exist.
Artifact paths and the output path are relative to the working directory;
`--root` selects the source tree and `--budgets` optionally selects a reviewed
configuration. Reports store artifact basenames and repository-relative source
paths, avoiding private absolute filesystem paths. JSON uses sorted keys and
stable file/group ordering, without timestamps, for repeatable comparisons.

The schema-1 report includes `limits_bytes`, historical `baseline`,
`source_assets` (all file hashes/bytes, grouped totals, skipped links),
`duplicate_candidates` (hash, paths, potential saved bytes), `packages`,
`violations` and `errors`. Each package has `status: measured` with exact bytes
and SHA-256, `not_measured` when its CLI option is absent, or `error` when a
supplied file cannot be measured. Missing, empty, linked or unreadable supplied
artifacts fail even without enforcement. Duplicate candidates are informational;
the audit never deletes or rewrites assets.

Exit **0** means a valid report (soft violations may still exist without the
flag); **1** means a budget was exceeded with `--fail-on-growth`; **2** means
invalid configuration, source declarations, artifact inputs, or report output.
Violations always appear both in console output and JSON, independent of the
flag. Input errors still produce a JSON report when the output is safely writable.
The output must not alias the configuration, pubspec, source assets or supplied
artifacts, including hardlink/symlink aliases. An unsafe output is refused without
modifying the input; the error remains visible in console output.
CI should upload each report with `if: always()` after the relevant measurement,
including failed budget runs, and retain normal artifact/signing protections.

## Safe optimization candidates

1. Review anatomy geometry/texture sizes, beginning with the named large models.
   The current pipeline already uses glTF transforms and mesh optimization;
   compare fidelity, labels, calibrated hotspots, mirrored skeleton and all
   system coverage before accepting any further compression. Keep web paths,
   offline decoder files and third-party notices intact.
2. Trial lower audio bitrates only with listening comparisons and offline playback
   tests. The largest track is a stronger candidate than tiny manifest/license
   cleanup. Preserve music selection, settings and lesson SFX behavior.
3. Compare ranking/achievement image resolution with actual UI presentation.
   Keep the full-body frame-based mascot and its animation frames intact.
4. Inspect generated package contents for accidental research/dev dependencies.
   They are excluded from this source audit; the final artifact ceiling catches
   unexplained aggregate growth but cannot identify package contents by itself.
5. Fonts are already small (0.65 MiB). Preserve required text, mathematics, emoji
   glyph coverage and all attribution rather than assume further subsetting is
   a worthwhile saving.

No assets were removed, no geometry or audio was recompressed, and no lesson
asset was deferred to a network download by this change. Future duplicate
candidates require a reference/attribution and offline behavior review before
any removal. External store requirements remain separate from this audit.
