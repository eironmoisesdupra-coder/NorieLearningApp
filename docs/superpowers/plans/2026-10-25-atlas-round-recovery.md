# Atlas round recovery implementation plan

> **For agentic workers:** Use superpowers:executing-plans to implement these tasks in order.

**Goal:** Resume an owner’s graded Atlas round without replaying mastery or XP.
**Architecture:** Persist the exact round, answer outbox and reward acknowledgement in an owner-scoped local document. Keep mastery counters and local-only answer receipts together in the existing mastery JSON value; remote/portable four-field mastery records remain unchanged. A pending answer whose local lineage was replaced must fail closed. Acknowledged answers never replay.
**Tech stack:** Existing Flutter, SharedPreferences platform snapshot, crypto, UUID and economy receipts.
**Spec:** Owner’s Anatomy Hint 2.0 and 0.19 build orders; PR80’s failed restart audit and signing evidence.

## Constraints

- Preserve existing quiz counts, geometry bindings, scoring, account boundaries and reward amounts.
- No paid hints, production credentials, schema migration, main changes or publication.
- Preserve unreadable bytes; never report a save before backend acknowledgement.
- Explicit backup restore invalidates the affected owner’s local rounds before replacing progression.
- Existing cloud snapshot semantics remain; uncertain pending effects after lineage replacement require recovery.
- Android signing continuity requires the original signing authority or separately reviewed migration; generating a new key does not repair it.

## Review focus

- Interruption before/after mastery and reward commits must not duplicate their effects.
- A→B→A and same-owner progress replacement must invalidate active callbacks.
- Failed setters can leave optimistic preference caches; read authoritative backend snapshots.
- Corruption or catalog revision drift must preserve the original round and block grading.
- A new round must not replace an undelivered completed reward.

## Tasks

- [ ] Reproduce screen recreation resetting2/5→1/5 in an actual widget regression.
- [ ] Add local mastery receipt metadata and awaited Atlas APIs; test duplicate/conflicting receipts, failed writes, cold reload, ordinary mastery updates, strict exports and corruption preservation.
- [ ] Add round codec/store; test exact request/question/asset binding, owner isolation, compare-and-save, interruption, corruption and restore invalidation.
- [ ] Integrate async round loading, durable answer→mastery→ack and completion→reward→ack; show retry/recovery/conflict states and explicit new-round controls.
- [ ] Update setup/guide/backup lifecycle and regression tests for5/10/20Q, recreation, repeated completion and account/progress changes.
- [ ] Run affected tests, full analysis/tests, release web and exact-head platform CI. Obtain independent review; report actual remaining limitations.
- [ ] Investigate existing signing verification and prepare a publication compatibility safeguard without generating/replacing credentials. Retain the unresolved original-key/migration blocker if no matching authority is available.
