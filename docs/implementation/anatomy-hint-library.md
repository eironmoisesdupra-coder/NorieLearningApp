# Anatomy Hint 2.0 — PR A foundation

Baseline develop `ed9472dbb437127abd8fd09931a86879d4df5ec5`, version
0.18.0+24 Preview. PR65 is merged; PR73 is an open independent draft. No code
from PR73 was merged or overwritten. This change does not alter quiz behavior,
scoring, credits, progress storage, renderer assets, account hooks or navigation.

## Exact identity and approval

`anatomy_hint_record.dart` stores immutable schema-v1 content: structure ID,
reference scene, asset ID and SHA-256, the full sorted set of selectable mesh
node names, canonical name, synonyms, system, explicit laterality, three hint
levels, source URL and edition/section/location, content revision and canonical
SHA-256. Draft, pendingReview, approved, rejected and retired are distinct states.
The selectable part identifier is the existing structure ID used by the renderer;
mesh IDs are the catalog's exact GLB node names, including multi-mesh groups.

`anatomy_hint_geometry.dart` imports the existing catalog, rejects unknown
references/systems/assets, malformed hashes, duplicate IDs/files and shared mesh
ownership. It does not infer medical identity or laterality from names. Run
`python scripts/anatomy/catalog.py` to verify actual GLB hashes and node extras;
metadata checks alone are not proof of the geometry's anatomical identity.

`anatomy_hint_library.dart` rejects identity, answer, selection or laterality
mismatches, changed content/assets, missing attribution, empty clues, explicit
opposite-side wording, answer/synonym disclosure, ambiguous active records and
unapproved/retired records. Answer matching is exact, never fuzzy. Conservative
text checks may reject otherwise useful prose and cannot detect every implicit
answer disclosure or factual contradiction.

Approval requires an independently configured `AnatomyHintApproval` binding
reviewer, timestamp, exact content hash and every qualified review attestation:
geometry identity, source support, laterality, answer consistency and no answer
disclosure. Record JSON cannot supply this authority. A fingerprint is integrity,
not a signature or evidence of medical accuracy. Production has **zero records
and zero trusted approvals** in this PR; no runtime loader or authoring approval
command is added. Future activation must control/review registry changes and
revocations independently; an application update is needed for packaged changes.

Missing/untrusted content returns explicit unavailable, no record and a safe
free strategy. No code in this module can debit credits. Detailed hints remain
disabled; atomic authoritative debit/reveal, durable recovery, account isolation
and qualified content approval remain separate activation prerequisites.

## Verification and limits

- 44 dedicated Flutter unit tests pass, including the full current catalog import.
- Flutter analysis is clean; formatting applied to all added Dart files.
- Existing `catalog.py` verifies 3,949 selectable parts across 15 systems.
- All 29 renderer Node tests pass.
- Independent code review found a physical-file alias ownership gap; a failing
  regression reproduced it, then duplicate-file rejection passed the regression.
- Full-suite and exact-head platform CI results are recorded in the PR. This host
  cannot enumerate network interfaces for nine pre-existing LAN transport tests
  (`SocketException: Bad value for ai_flags`); no tests were skipped or weakened.

No academically approved hint coverage, payment activation, merge, deployment,
new version or physical-device certification is claimed. PR B prepares drafts;
PR C may expose safe free guidance. Geometry/source/medical judgments require
qualified human review before any specific clue becomes eligible.
