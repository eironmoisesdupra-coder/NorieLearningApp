# Packet 03 ? registry and validation

The registry snapshots existing offline topics using their unchanged IDs. Content identity is the canonical SHA-256 of the topic and editorial metadata; revision numbers alone do not establish identity. Existing bundled records are a separate trust category and carry no invented author, source, reviewer or approval claims. Import constructors cannot recreate this trust category.

New editorial revisions use draft ? review ? approved ? published ? retired as the intended server workflow. This local implementation provides draft staging only. The validator reports missing metadata, incomplete teaching structure, answer keys, duplicate IDs/options, prerequisites, inaccessible/offline assets and licenses. Structural validation cannot establish subject correctness or human approval.

The adapter extends the existing FoundationCurriculum and legacy catalog; it does not replace runtime content caches or migrate learner progress. Published curriculum checks already in CI remain applicable.
