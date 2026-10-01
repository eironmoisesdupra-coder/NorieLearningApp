# Anatomy Atlas coverage - NorieLearning 0.2.1

The bundled catalog contains **3,949 selectable model parts** across two adult body references and four detail references. The 34 model files total **102.7 MB** before installer compression. Counts include separately modeled segments, groups and alternative reference models; they are not counts of unique whole organs.

| System | Male reference | Female reference |
|---|---:|---:|
| Skeletal | 234 | 33 |
| Articular | 65 | 90 |
| Muscular | 406 | 4 |
| Heart | 27 | 14 |
| Arteries | 630 | 47 |
| Veins | 393 | 49 |
| Nervous | 147 | 312 |
| Lymphatic | 3 | 13 |
| Respiratory | 119 | 56 |
| Digestive | 111 | 84 |
| Urinary | 6 | 87 |
| Reproductive | 12 | 38 |
| Endocrine | 11 | 13 |
| Integumentary | 4 | 20 |
| Sense organs | 57 | 76 |

The separate lymph-node/organ reference adds **158** selectable parts; the ear detail reference adds **14**. Detail references preserve their own coordinates and are not superimposed on either body.

The joint detail reference adds **349** ligament, capsule, disc and related parts,
plus **277** matching skeletal parts that can be toggled for context. The gland
detail reference adds **11** parts: thyroid, four parathyroids, separate anterior
and posterior pituitary, pineal, two adrenals and pancreas. These alternative
source scenes add detail; their counts must not be described as 637 new unique
anatomical structures. Search, isolate, opacity and offline quizzes work in each.

Some parts belong to more than one system, so column totals can exceed unique parts.

## Dataset boundaries

- The male library derives from BodyParts3D 4.0; 17 source meshes with no name or anatomical ID are excluded rather than guessed.
- The female HRA reference supplies reproductive organs and additional organ detail, with partial musculoskeletal coverage. It is not a complete female whole-body atlas.
- Lymphatic coverage includes the spleen, thymus, tonsillar anatomy and a detailed lymph-node reference; it does not model the complete distributed lymph-vessel network.
- Sense-organ coverage emphasizes the eyes and external ear. The separate SPL detail scene adds 14 middle/inner-ear surfaces, including the combined labyrinth, three ossicles, tympanic membrane and related nerves/vessels. The labyrinth is a combined structure, not individually segmented cochlear microanatomy.
- The reproductive references include the source-modeled internal structures. This is not an exhaustive atlas of external genital anatomy. Pregnancy-specific placenta and umbilical models are excluded.
- Skin is modeled at whole-body/organ scale, without a complete microscopic hair-follicle or sweat-gland atlas.
- Endocrine filters cross-list the modeled pineal, thymus, pancreas and gonads; exocrine pancreatic ducts and ovarian support ligaments are excluded. The gland detail scene does not contain gonads; use the male/female references for those.
- The existing calibrated, mirrored skeleton remains accessible through Skeleton fundamentals.

## Reproduce and verify

Run `bash scripts/fetch_anatomy_assets.sh` from the repository root. This downloads checksum-pinned sources, builds the model library, bundles the offline renderer and validates every selectable mesh. Requires Python 3.11+ and Node 24. No download occurs at runtime in the packaged apps.

Checks: `python -m unittest discover -s test -p anatomy_pipeline_test.py`, `python scripts/anatomy/catalog.py`, `node --test anatomy_viewer/test/*.test.mjs`, and `node anatomy_viewer/test/browser-smoke.mjs` (after desktop npm dependencies are installed).

Source authors, licenses and conversion changes are recorded in [asset attribution](../assets/anatomy/ATTRIBUTION.md).
