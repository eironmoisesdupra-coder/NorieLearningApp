# Priority 3 — Curriculum Publication Approval (trust boundary)

## Current boundary
The local `CurriculumStudioStore` saves untrusted drafts and path plans. Its `approved`, `reviewed`, `published`, `reviewer` and similar client fields MUST NEVER confer publish authority.

## Proposed server-side workflow
Draft → Submitted for Review → Changes Requested or Approved → Scheduled for Publication → Published → Superseded/Retired (with rollback policy). Reject unauthorized/invalid transitions server-side.

### Roles
Author may create/edit draft and submit. Reviewer must be independently authorized for subject/grade, not same user if separation-of-duties policy requires it. Publisher may publish a **specific approved immutable revision** only after signoff and automated structural gate. Admin role self-assignment is prohibited. No public client direct write to trusted manifests; deny `anon` and unprivileged `authenticated` access to approval mutation RPCs.

### Approval evidence
Record: stable content ID, revision/hash, subject/grade, source editions, reviewer identity in backend verified identity system, reviewer scope, review date, rubric, factual corrections, required assets/licenses, quiz answer-key checks, exact approved SHA-256 content digest. A changed byte invalidates old approval. Avoid publishing user PII in public manifests.

### Delivery and offline
Export deterministic signed/validated content manifest and approved offline pack. Validate schema, unique IDs, dependency DAG, asset existence/licenses, file size/depth, revision pin and version compatibility. Runtime reads only bundled or trusted published manifests. Malformed/replayed/stale package cannot override bundled vetted lessons. Client draft sync must preserve untrusted status.

### Rollback
An emergency withdrawal requires a signed registry change pointing to a known approved older revision; no silent delete of learner history or incompatible mastery overwrite. App must remain usable offline and explain unavailable/retired lessons appropriately.

### Required tests
RBAC/RLS: anonymous, learner, author, reviewer outside subject, publisher, rogue client, same-author-reviewer, revoked reviewer, concurrent review, stale hashes, duplicate submits, forged approval JSON, replayed tokens, unsigned manifest, rollback. Use disposable DB fixtures and non-destructive live checks only by permission. Verify accessibility and no accidental publish from imported packs.

### Completion gate
Even perfect CI does not mean qualified editorial review happened. Don't label any new medical content published/approved absent external signoff.
