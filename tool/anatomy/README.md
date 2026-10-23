# Development-only hint authoring

Run from the repository root with the installed Dart SDK. These tools are not
bundled or imported by the application. PR B depends on PR A (#74); its changes
should be reviewed after that foundation. No approval command exists.

First verify source assets and GLB-to-catalog nodes:

```
python scripts/anatomy/catalog.py
```

Export an empty template for every selectable catalog part, or restrict it using
`--structures bp-FJ3259,bp-FJ3365` (exact IDs only):

```
dart run tool/anatomy/hints.dart templates --output build/hint-templates.json
```

The checked-in `pilot-drafts.json` contains **30 draft skeletal candidates**:
left/right clavicle, scapula, humerus, radius, ulna, femur, patella, tibia, fibula,
calcaneus, talus, cuboid and parietal catalog parts; frontal, occipital, mandible
and body-of-sternum catalog parts. These names are copied from the existing
catalog, not independently validated anatomical identities. Candidate selection
favors introductory structures with distinct selectable meshes; a qualified
reviewer must still verify each mapping, including orientation and laterality.

All hints and source citations are blank; all reviewer/approval fields are null.
Laterality is explicitly unknown because the catalog does not provide reviewed
side metadata. Do not infer an approved side from a name or screenshot. No
AI-generated prose or fabricated editorial metadata is included.

Produce full awaiting-review and per-system coverage exports:

```
dart run tool/anatomy/hints.dart report --records tool/anatomy/pilot-drafts.json --output build/hint-review.json
dart run tool/anatomy/hints.dart validate --records tool/anatomy/pilot-drafts.json --output build/hint-validation.json
```

`report` exits 0 after writing the inventory, even when records need review.
`validate` exits 1 when any record is ineligible. Invalid input/options, unknown
parts, unsafe inventory or existing output paths exit 2. Choose a fresh output
path on each run; the tool never overwrites files. Neither exit 0 nor correct
SHA-256 means academically approved or medically verified. Status counts reflect
**declared** editorial states; `eligibleRecords`/system `eligible` reflect trusted
eligibility, which is zero because authoring cannot supply independent signoff.
System counts may overlap. Reports include missing records, duplicates, invalid
source/geometry/answer metadata and all outstanding human checks.

Fill draft content using real sources with edition/section/page or applicable
source location. Increment the revision on changes, compute the canonical content
hash with the shared model's `computedHash`, and request qualified review in an
independently controlled process. This tool deliberately does not rewrite authored
records or grant approvals. A production registry requires verified reviewer scope,
explicit version-specific human signoff, controlled code review and revocation.
See ../../docs/anatomy-editorial-review.md and
../../docs/implementation/anatomy-hint-library.md.

Paid hints remain disabled. These drafts cannot unlock any clue or spend credits.
