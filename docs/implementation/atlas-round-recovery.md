# Atlas round recovery and Android publication compatibility

Baseline: develop 2578b809d5b1649e51ef52f72ac007ad8454b3d4, version 0.19.0+25. This is a reviewed-PR follow-up; the PR is authoritative for exact source, CI and merge status. No publication or paid hint activation is authorized.

## Local round protocol

One round per learner stores exact settings, ordered questions/options, catalog/asset/mesh fingerprints, responses, position, attempt UUID and delivery acknowledgements. Reopening resumes that round. Different settings require an explicit Resume/Start decision; completed retries use a new UUID only after the prior reward has settled. New-round confirmation keeps the old raw document as a recovery copy.

An answer is saved as pending before its mastery effect. Counters and local receipts share one existing `norie.topicMastery` JSON write. An acknowledged answer never replays. An unacknowledged answer retries the same content-bound receipt; a replaced receipt lineage blocks uncertain grading instead of inventing success. Completed rounds keep an outbox until the existing `anatomy-atlas:<attemptUUID>` economy claim has flushed and its acknowledgement is saved. The XP amount remains ten per correct answer; hints remain free/locked exactly as before.

The round's owner queue excludes explicit backup retirement while an accepted effect is being reconciled. Manual backup restore retires that owner's epoch before replacing progression and keeps old round bytes. Ordinary account/cloud replacements invalidate live callbacks through account generation and progression revision. Owner readiness is checked against the persisted cloud owner before mastery or reward effects, including the interval before a newly selected account finishes loading.

Round reads use isolated backend snapshots, not optimistic preference-cache values. Writes compare attempt/revision, serialize per owner, restore only the affected key on failure, and preserve corrupt data. Unreadable mastery cannot be exported or synchronized as an empty history; validated replacement first quarantines its original raw value with its persisted owner. Existing four-field cloud/portable mastery schemas are unchanged; local receipt metadata is never published. Other offline learning remains available while the damaged mastery slice needs recovery.

Round snapshots are device-local and are not portable backup/cloud curriculum records. Acknowledged answers remain recorded under the existing cloud snapshot semantics. Seamless reconciliation of uncertain pending answers after arbitrary remote progress replacement is not claimed. SharedPreferences backend acknowledgement is not physical power-loss certification or cross-process transaction authority. No paid hint uses this storage as a debit authority. Receipt capacity is bounded and fails explicitly without deleting old receipts.

## Rendering and learner feedback

Loading/saving/error/conflict states prevent accidental submission during storage operations. Reload rotates the renderer session, rejecting stale ready callbacks; ordinary question transitions retain the renderer and update its exact target. Restored options/answer keys must remain in the eligible catalog pool with the requested difficulty/count. Changed geometry revisions, malformed answers and truncated sessions cannot grade. Metadata checks do not establish medical truth.

Setup and the guide explain resume, explicit restart and backup retirement. Existing Classic/Adventure, profiles, cosmetics, rewards and Anatomy assets remain unchanged.

## Android publication safeguard

The published 0.18 APK uses package `com.example.norie_learning` and certificate SHA256 `4168b181761eb975fd329c2d21f0d8f19a8840067705e96888a405d23b1ce2b6`; its APK SHA256 is `27b3b42f9c12adbbee350f2492bfe2025166bd5099268be801b22f99339af3a5`. Prior 0.19 CI APKs have different generated debug certificates. Public identity comparison cannot recover the original private key.

`android_preview_upgrade.py` executes Android SDK `apksigner verify` and `aapt dump badging`. Non-publishing CI records an explicit compatible/blocked result, actual package/version and hashes. The publisher requires compatible package and certificate before preparing either platform's public packages. Failed signature verification never becomes a success report. Tests fake only SDK subprocess boundaries; actual cryptographic verification is a separate CI step.

This safeguard prevents incompatible publication; it does not repair signing credentials. Original signing authority or an independently reviewed/tested migration is still required. No new key, production secret or installation/uninstallation is requested. Windows remains unsigned; physical upgrade, hardware and assistive-technology certification remain untested.

Actual SDK 37 testing exposed its new `V2 Signer:` certificate label, replacing SDK 36's `Signer #1`. Both the preview guard and existing APK verifier now share a parser requiring the explicit single-signer count and one consistent SHA-256 certificate across verified schemes. Real SDK 36 and 37 verification of the known baseline APK passed locally; its different certificate still blocks upgrade publication. This changes output parsing, not signing authority or credential gates.

## Evidence

The original widget audit reproduced 2/5→1/5 before implementation. Current regression commands cover cold recreation, pending answer before/after mastery, failed acknowledgement, 5/10/20-question reward replay, duplicate taps, unmount, progress replacement, owner mismatch, corruption, strict export and backup retirement. Additional existing widget suites cover phone layout, hints, scoring and outro navigation. Exact test counts, full-suite host limitations and compiled Windows reload evidence are recorded in the PR after execution. Do not infer passing CI or release readiness from this document.

New qualified Anatomy coverage remains 0, draft templates 30. Detailed five-credit hints remain disabled, with no debit/unlock path.
