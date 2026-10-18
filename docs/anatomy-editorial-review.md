# Anatomy source and teaching review

The anatomy catalog describes selectable model parts. A catalog name, system
association or ontology label does not establish that an authored explanation is
accurate or appropriate for a learner. No anatomy subject-matter reviewer or
trusted approval registry is configured for this release.

`scripts/anatomy/audit.py` is an AI-assisted implementation of an automated,
offline inventory. It checks catalog integrity, source/reference/asset boundaries,
the attribution mapping, retained license notices and checksum-pinned source
manifest entries. Every catalog asset requires provenance evidence, including
retained assets without selectable structures. Required inputs include all six
BodyParts3D metadata tables and all fourteen SPL ear VTK surfaces as well as the
ear scene metadata and geometry archives/GLBs. It does not download sources, validate the medical meaning of
an ontology ID, assess a source's authority, or grant human approval. Run the
existing model pipeline and `catalog.py` as well for actual geometry and file
checksum validation. Source and license facts come from the existing
`assets/anatomy/ATTRIBUTION.md` and `scripts/anatomy/sources.json`; the audit does
not replace those notices.

Run from the repository root after generating the source catalog:

```powershell
python scripts/anatomy/audit.py --catalog assets/anatomy/atlas-catalog.json --output build/anatomy-coverage-audit.json
```

An optional `--teaching path/to/metadata.json` inventories draft teaching
metadata. The audit writes JSON evidence and exits 1 on a critical failure,
including invalid references/systems, duplicate IDs, asset/source/reference
mismatches, unlicensed assets, absent provenance evidence or malformed teaching
metadata. Missing teaching is an explicit coverage gap; it does not make existing
catalog exploration fail. Unknown teaching IDs appear under `unmatchedTeaching`
as `unreviewed` and cannot inherit another structure's content or approval.

The output reports every structure's displayed name, optional source synonyms,
reference, systems, source, asset, source URLs, license, original ontology label
and teaching status. Ontology labels are syntax checked and preserved verbatim;
absent labels and the source placeholder `-` remain missing. No label is inferred.
System counts can overlap. Alternative reference scenes remain separate.

Teaching metadata uses this shape (the empty list is deliberate; it contains no
new anatomical assertions):

```json
{
  "schemaVersion": 1,
  "structures": []
}
```

Each future entry must have `id` and its exact catalog `reference`. Draft
`claims` are objects with `text` and a list of HTTPS `sources`; URLs are checked
for safe syntax, never treated as proof of authority or claim support. Record a
version and reviewer information for traceability. The rubric flags absent
`gradeBand`, `objectives`, `explanation`, `diagram`, `workedExample`,
`guidedExample`, `reasoning`, `commonMistakes`, `recap`, `practice`,
`masteryItems` and `feedback`. These fields accept nonempty text or lists of
nonempty text. The presence of a field does not prove pedagogical quality.

Status rules are deliberately conservative:

- `missing`: no per-structure authored teaching record exists.
- `review`: a draft record exists and needs human review, even if its metadata
  claims `approved` or labels its reviewer as human.
- `approved`: reserved; the current implementation never emits this status.
  A future change needs an independently verified human reviewer process and
  version-specific signoff, not a self-declared JSON field.

Before publishing new anatomical assertions, the product owner must appoint a
qualified anatomy subject-matter reviewer and verify their identity and scope.
That reviewer must check each claim against authoritative primary or educational
sources, confirm the exact structure/reference and ontology associations,
review diagrams and spatial relationships, assess grade-level explanations and
step-by-step examples, and check practice, mastery answers and misconception
feedback. Record the reviewed content version, source editions/sections, review
date, corrections and explicit signoff in an independently controlled process.
AI-assisted/source-checking reports can help prepare that work; they cannot
substitute for it. Until then, anatomy learning modules should remain bounded to
existing catalog labels and system associations and must not present newly
generated location/function/relationship prose as approved anatomy instruction.
