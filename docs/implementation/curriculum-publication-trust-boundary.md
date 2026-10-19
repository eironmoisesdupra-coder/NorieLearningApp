# Curriculum publication preparation

This change prepares a server trust boundary. **Publication remains disabled.**
It does not deploy a migration, assign an editorial role, configure signing keys,
certify medical content, or install new curriculum in the learner application.
Existing bundled lessons and draft-only Studio/pack behavior remain unchanged.

## Server authorization

`20261019130259_curriculum_publication_boundary.sql` adds a private schema and
four invoker RPC wrappers. Direct client access to every private table/sequence
is revoked; RLS adds restrictive denial for authenticated clients. Anonymous
callers cannot execute the RPCs. Private definer implementations fix the search
path and check `auth.uid()` against current subject/grade scope rows. No JWT
user metadata, client `approved` JSON, or self-assigned role confers authority.
No RPC can assign scopes or enable publication.

An author submits a public-safe `{topic, metadata}` JSON source string and its
**raw UTF-8 SHA-256**. This is intentionally separate from the Studio canonical
JSON fingerprint. Store and approve the exact serialized bytes; whitespace and
all other byte changes require a new immutable revision and new approval.
The subject, grade and stable ID must match the source. A stable ID cannot be
claimed under a different subject/grade. Existing legacy `content_topics`
tables and their policies are unchanged.

The state machine is submitted → approved or changes_requested → scheduled →
published, with published revisions eligible for explicit rollback/retirement.
Changes requested requires a new revision. The reviewer is a different identity
from the author, with source editions, rubric, factual correction notes,
asset/license confirmation and answer-key confirmation recorded privately.
Publisher must differ from both author and reviewer. Publication rechecks the
reviewer's live scope, expiry and generation; revoke/regrant cannot revive an
old approval. Scope identity and revocation history cannot be deleted/rekeyed
through ordinary DML. Approval evidence, content bytes, structural attestations,
and registry audit events are immutable. Operator table-owner powers remain a
separate infrastructure trust boundary.

Publication also needs a hash-matching structural gate from a trusted backend
validator. Only `service_role` or the database owner can insert gate rows; the
backend credential can read export inputs and insert gates but has no grant to
assign roles, change settings or write registry events. It must never be embedded
in an app. The validator must examine actual offline asset bytes, licenses, full
lesson schema/teaching quality, dependency closure and answer keys before writing
an attestation. This change does **not** supply that deployed validator or assert
that existing drafts passed it.

Registry changes lock a singleton head and require the caller's exact expected
sequence. Duplicate or stale release attempts cannot append a second event.
Ordinary publication cannot downgrade a previously published revision. Rollback
references a known previously published, approved older revision and appends a
new event. Retirement targets the current revision and can withdraw a lesson
even if its reviewer's grant has since been revoked. Learner history, XP, mastery
and account data are never written by this workflow.

## Offline verification protocol

`supabase/functions/curriculum-publication/offline-verification.mjs` is a portable
WebCrypto Ed25519 verification module, **not a deployed Edge Function or signer**.
The signed manifest contains no editorial user identities. Review identities
and private evidence are rejected in public revision metadata; a real exporter
still needs a full privacy and attribution review. Prepare public-safe bytes
before submission/signoff, never strip fields from already approved bytes.

The envelope carries exact signed manifest bytes, signature, key ID, revision
bytes and actual offline asset bytes. Keys come exclusively from the caller's
trusted map, never the envelope. Pins cover ID/revision, subject/grade and raw
SHA-256. Verification enforces strict manifest fields, format/schema, client
version bounds, size/depth/count budgets, signature, revision and asset hashes,
asset paths/licenses/accessibility, assessment answer indices and unique IDs,
and a complete dependency DAG. The verifier supplements rather than replaces
the full trusted structural validator and independent subject review.
Each referenced `metadata.assets` entry must include its asset's `sha256` before
the revision is submitted for review. The approved source hash therefore binds
the asset bytes transitively. A newly signed registry cannot replace an asset at
the same path under an unchanged approved revision; changing asset bytes requires
a new source digest, revision, structural gate and independent approval.

The caller must provide a trusted initial checkpoint and a trusted time value.
Signed validity is limited to 30 days. An expired/unavailable update leaves
bundled lessons usable; expiry must not disable core offline learning. Every
accepted manifest is the next sequence and links the prior manifest hash.
Gaps require the missing signed registry chain, not a bypass. The checkpoint
includes verified historical pins and active pins; a signed rollback can restore
only a known older pin. Ordinary signed publication cannot silently downgrade,
change a pinned revision's bytes, or remove a lesson. Retirement is explicit.
Persist the accepted checkpoint and payload atomically before exposing an update.
The returned immutable candidate does not install anything. Protect/checkpoint
storage and provision a minimum sequence/root in the app to prevent replays after
storage reset. Device clock manipulation and local storage rollback are not
solved by JSON checksums or a signature alone.
Historical pins use a separate explicit limit of 4,096 entries, independent of
the 128-field lesson-object and 128-active-revision limits. Both received and
returned checkpoints are fully parsed and validated under the same budgets.
Adding a pin beyond that limit rejects the candidate before acceptance and
preserves the previous reusable checkpoint. Repeated snapshots with existing
pins remain usable at the cap. A future audited trust-root/history migration is
required to grow past this limit; no historical approval is silently evicted.

## Activation blockers and validation

Required external work before activation:

- Qualified subject/grade reviewers and independent publishers provisioned by an
  authorized operator, with documented editorial qualifications and rubrics.
- A deployed full structural/asset validator, private evidence inspection tools,
  and deterministic exporter that reads only committed approved registry events.
- A protected Ed25519 signing service, key IDs/rotation/revocation policy,
  public trust keys and a trusted initial sequence/hash checkpoint.
- A Flutter signature-verification adapter and atomic verified cache/registry
  installation path, with offline/restart/storage-rollback/device tests. None is
  wired into the app by this preparation change.
- Disposable multi-backend PostgreSQL contention tests, Supabase gateway/JWT/RLS
  integration, database advisor review, then explicit migration and activation.

Local executable checks:

```text
node scripts/test_curriculum_publication_offline.mjs
node scripts/verify_curriculum_publication_database.mjs <pglite/dist/index.js>
flutter test test/norie_curriculum_publication_boundary_test.dart test/norie_content_pack_test.dart test/norie_curriculum_studio_test.dart
```

The database fixture executes actual isolated PostgreSQL SQL, roles and
permissions through PGlite, including unauthorized authors/reviewers, same-author
review, stale digests, duplicate submissions/reviews/releases, immutable source
and evidence, revoked/regranted reviewer, gated publication, backend credential
limits, CAS registry updates and rollback. PGlite serializes sessions: this is
**not** a multi-backend concurrency stress test or a deployed Supabase audit.
The offline fixture generates ephemeral test-only Ed25519 keys and exercises
unsigned/forged signatures, changed bytes, incompatible schema/version, bounds,
answer keys, asset hashes/licenses/paths, duplicate IDs, dependency cycles,
expired/future packages, replay, historical rollback and explicit retirement.

Current primary references checked on 2026-10-19:

- [Supabase changelog](https://supabase.com/changelog.md): fetched the current
  index; upcoming November TLS cipher changes concern transport and do not
  alter this local SQL implementation.
- [Database functions](https://supabase.com/docs/guides/database/functions):
  invoker/definer isolation, explicit execution grants and fixed search path.
