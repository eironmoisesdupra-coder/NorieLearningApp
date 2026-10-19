# Priority 4 — Anatomy guided-study backup and bookmark integration

## Scope and constraints
Existing `AnatomyStudyStore` and `AnatomyAtlasBookmarkStore` are local and keyed by owner. `NorieProgressBackup` currently validates 5 MiB v1/v2 portable backups. Extend the backup through an *explicit versioned extension* only after designing and testing cross-version compatibility.

## Export
- Require current learner capture guard, loaded stores and flushed pending writes; fail safely if any write/save error exists. Do not silently export an empty state if persisted learning evidence failed to load.
- Include only owner-matched guided-study evidence and named-view bookmarks, never session tokens, secrets, private files, arbitrary camera transforms, device approvals, funded credit budgets or payment information.
- Embed schema and catalog/content version, export time, canonical catalog reference, bounded entry count, payload byte limit and a clear provenance marker. Keep overall 5 MiB cap or document careful approved adjustment.
- No XP, credits or mastery rewards added on export.

## Import
- Validate all fields, sizes, structure IDs, references, versions, guided study steps, enumerated named views, duplicates and ownership **before modifying any state**.
- Reject cross-account data, mismatched revisions requiring migration, malicious nested JSON, unknown structure, unsafe bytes, stale owner generation, damaged backup; preserve existing data on failure.
- For the current owner, merge using carefully defined monotonic evidence rules. Do not inflate independent evidence by combining assisted and independent results. Timestamps untrusted; no fake study receipts or XP.
- Transactional restore: stage validated combined state; commit atomically across relevant stores or implement checkpoint/rollback with documented failure recovery. Never partially restore one store and claim all complete.
- Make restore idempotent and support interruption/crash/retry. Use captured identity generation guards before and after awaited I/O, including A→B→A case.
- Old v1/v2 backups without anatomy extension must import normally and **must not wipe** current Anatomy data by omission.
- Include user-facing restore summary: how many study entries/views were imported, skipped due to incompatibility or retained.

## Optional cloud later
Do not upload anatomy notes/views automatically. Cloud integration requires owner-protected storage, extension negotiations/legacy client safety, retention/deletion policy and explicit user consent. Portable local backup is first scope.

## Required tests
Export/import same user, different user rejection, guest boundary, A→B→A, malformed schema, 0-byte, over-limit, duplicate IDs, missing catalog part, wrong reference, wrong content version, queued saves, disk write fails halfway, repeated restore, old backup compatibility, independent/assisted separation, rewards unchanged, deletion/reset lifecycle, offline and real device file-picker behavior.
