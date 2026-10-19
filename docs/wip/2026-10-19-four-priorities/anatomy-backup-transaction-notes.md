# Anatomy portable backup transaction boundary

Status: implementation and verification in progress. This is an intermediate
Anatomy-only backup, not completion of the requested combined progress restore.

The existing progress restore publishes lesson, economy, feature, adventure and
appearance changes through separate stores. These stores have independent save
queues and account transitions can run during awaited writes. Saving an old
progress snapshot in a journal does not by itself make that transaction safe:
rolling back global progress preference keys after a learner change can overwrite
the new learner's progress. Combined restore must remain unavailable until those
stores and identity transitions share a transaction boundary.

The bounded intermediate design puts guided-study evidence and named-view
bookmarks in one owner-bound local preference envelope. Both stores serialize
default persistence through that envelope. A restore changes one preference
value, rather than committing two independently visible preference writes. A
staging write stores the previous committed pair alongside the pending pair;
an interrupted staging record is rolled back before the next read. A second
write publishes the complete new pair. The
legacy preference values remain intact during migration; absence of the envelope
permits reading them, while a damaged envelope fails closed. This is independent
of reward/progression state and never changes XP, credits or mastery.

Each owner's shared queue waits for writes from other store instances, including
identity compensation, without blocking unrelated owners. Drained queues are
removed before the caller's completion is delivered, preventing later sessions
from inheriting deferred bookkeeping futures. A restore revision
invalidates writes captured before the restore; registered stores receive the
committed pair synchronously so their next edit starts from the restored state.
Identity guards must capture learner generation, not just compare account IDs.
Normal study saves upsert only the changed entry into the latest owner state
under the shared queue, so two preloaded instances cannot erase each other's
disjoint evidence by replacing whole snapshots. The mutation captures its prior
row: uncontended edits preserve exact navigation/skip behavior, while conflicting
rows merge acknowledgement flags and separate evidence counters monotonically.
Accepted hints and checks also mark shared owner/revision reveal provenance
synchronously, before disk I/O. Other live stores project that provenance before
classifying an answer or showing feedback. Loading/restoring evidence seeds the
shared flags; explicit reset advances the revision and clears them. Consequently
a stale screen cannot mint a fresh independent check after another screen has
already exposed the same entry, while genuine historical independent evidence
remains intact.
Explicit study reset uses the owner transaction to clear study across every live
instance while retaining bookmarks.

Restore freezes new study and bookmark mutations for that owner before draining
pre-existing queues. Transaction notifications make the guided screen's existing
readiness gate display its busy state. Answer/help/selection callbacks check
acceptance before showing saved feedback or revealing help. Pre-freeze saves
still drain; they are not mistaken for newly rejected actions.
If identity changes during a platform write, compensation restores the previous
owner-specific envelope before the queue admits another operation.
If compensation itself fails, the operation reports a failure; it cannot promise
that the platform persisted the compensation. An interrupted staging record is
recoverable, while a crash after the atomic pair commit can retain the whole
committed pair. This is not a claim of account-switch atomicity across a process
crash or a platform that reports unsuccessful writes after changing its cache.

The portable payload is explicitly versioned and owner-bound, including the guest
boundary. Catalog path, catalog schema, guided content revision, unverified local
provenance, export time, references, structure IDs, named views, study-step values,
field sets, duplicate entries and size limits are validated before any write.
Merge uses maxima within independent and assisted counters separately, unions
acknowledged steps, and keeps skipped steps only where no completion exists.
Counts are not summed. Imported local evidence is not a trusted reward receipt.

The existing full progress v1/v2 format remains separate. A backup without an
Anatomy extension cannot erase Anatomy. An unsupported extension must be rejected
instead of being silently discarded. No Anatomy state is added to cloud state or
uploaded automatically.

Remaining for the original combined-backup requirement: shared progression and
identity transaction coordination, persistent combined checkpoint/recovery before
any store reads, combined export/import UI and undo recovery, then interruption,
disk-failure and real-device file-picker verification across both transaction
domains. A single SharedPreferences value avoids a mixed Anatomy pair but does
not establish physical fsync durability or a whole-app transaction.
