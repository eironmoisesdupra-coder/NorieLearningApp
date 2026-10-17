# Store readiness preflight

NorieLearning 0.13 remains a Preview. The store manifest records external work;
passing CI, a signed preview installer or a listing draft does not establish store
approval. No production credentials, public support contact or published privacy
policy URL were supplied. All 13 gates in `store/readiness.json` are intentionally
`not_tested`; no certification or approval is manufactured.

## CLI and CI contract

From the repository root, using a standalone Dart SDK:

```text
dart tool/store_readiness.dart store/readiness.json --check-schema --json-report store-report.json
dart tool/store_readiness.dart store/readiness.json --require-ready
```

`--check-schema` returns 0 for a well-formed pending manifest and reports every
blocker. Default mode and `--require-ready` return 1 when any gate is not `pass`.
Malformed JSON, wrong/missing/unknown fields, unknown/duplicate/missing gate IDs,
`required` other than `true`, unsupported statuses, invalid evidence, usage or I/O
errors return 2 in either mode. Do not suppress these exits in CI. JSON output
contains `schema_valid`, `ready`, `blockers` and `errors`; valid manifests also
include source/build/artifact bindings and a structural-validation notice.
`--json-report PATH` writes that same report, including on validation failure.
It refuses to overwrite the input manifest or referenced gate/review evidence,
including normalized paths, Windows case variants, hard links and symbolic-link
aliases. Protection runs even when schema validation fails. An oversized or
unreadable manifest that cannot be safely inspected prevents report-file writing;
the failure still appears on stdout/stderr with exit 2. Choose a dedicated output
path outside the input evidence bundle.

A schema check must not be labelled certification. Even a report with `ready: true`
means the declarations and bindings passed structural checks: independent human,
security, legal and store review remain required. No automation can authenticate
the reviewer's identity or prove that their observation is true.

## Manifest and evidence format

The top-level fields are exactly `format`, `version`, `source_revision`,
`app_version`, `artifact_sha256` and `gates`. Format is `norie-store-readiness`,
version is integer 1. `artifact_sha256` has exactly `android` and `windows`.
Pending source/build/digests may be empty. Nonempty values must be a lowercase
40-character Git SHA, `major.minor.patch+build`, and lowercase 64-character SHA256
artifact digests respectively. Never substitute a preview digest for a signed
production candidate digest.

Each exact gate has `id`, `required: true`, `status`, `evidence`, `review`.
Statuses are `not_tested`, `blocked`, `fail`, `pass`. Nonpassing gates use null
`evidence` and `review`; retain investigation notes separately until reviewed.
Every pass requires nonempty source/build and both actual signed candidate
artifact digests. Reviewers must record how those digests were obtained and
match them against the production release's independent signing evidence.

For a pass, `evidence` is a relative forward-slash path to an actual nonempty UTF-8
report within the manifest directory. Traversal, absolute paths, links escaping
the directory, self-reference and files larger than 64 KiB are rejected. The
manifest is bounded to 2 MiB. The evidence report must contain both bound artifact
digests and explain the gate's actual result, procedure, observations and relevant
supporting artifacts/URLs. Referenced screenshots, signing reports and physical
device reports still need independent review; the CLI does not inspect their
contents or fetch remote URLs. Do not put credentials or private learner data in
committed evidence. Keep sensitive review material in an appropriately restricted
release evidence bundle and run the validator there.

`review` has exactly these fields (this is a schema description, not filled evidence):

```text
origin: human
reviewer: actual responsible human's name/identity
reviewed_at: actual UTC timestamp YYYY-MM-DDTHH:MM:SSZ, not in the future
decision: pass
gate_id: exact gate being reviewed
source_revision: exact manifest source SHA
app_version: exact manifest version+build
artifact_sha256: {android: exact bound SHA256, windows: exact bound SHA256}
evidence_path: exact gate evidence path
evidence_text: exact UTF-8 contents the human reviewed
```

The exact text snapshot binds the declaration to the reviewed evidence without
an additional package/runtime dependency. Any later evidence edit invalidates the
binding. Preserve actual line endings when recording the text snapshot (for
example, Python `path.read_bytes().decode("utf-8")` avoids newline normalization). The CLI validates this declaration; it cannot issue human review itself.
Synthetic fixtures in the regression tests are never production evidence.

## Required gate evidence

| Gate ID | Evidence the responsible reviewer must inspect |
| --- | --- |
| `production_android_signing` | Production signing identity, exact AAB hash, verified signing/build path and console candidate validation; retain existing release signing controls. |
| `production_windows_signing` | Actual production signature/timestamp, publisher identity, exact package digest and reviewed Store package route. A portable ZIP alone is insufficient. |
| `physical_device_matrix` | All five existing physical device classes and complete scenario set; run `tool/verify_device_certification.dart` with exact source/build and APK/Windows digests outside CI, then review its referenced observations. |
| `preview_to_production_migration` | Actual preview backup -> candidate restore/update observations, ownership/account separation and preserved progress/XP/mastery; record old and new versions/digests. |
| `classroom_real_wifi` | Real LAN hardware/session observations including join, assignment, result, retry, duplicate ACK and recovery; a simulated transport test is insufficient. |
| `privacy_policy_published` | Owner-approved public URL, observed reachable policy and review against actual shipped data flows. |
| `account_deletion_flow` | Actual production account deletion and recovery rules, tested retention/ownership outcomes and public instructions; current account hooks do not prove production availability. |
| `content_rating_completed` | Owner's actual completed content/age/target-audience console declarations and review. |
| `store_graphics_ready` | Real production screenshots, icons and graphics with reviewed source/build, readability and learner privacy. |
| `support_contact_ready` | Owner-provided public contact and evidence a support request can reach the responsible operator. |
| `package_size_reviewed` | Exact APK/AAB and Windows artifact byte/hash audit, documented budget review and performance measurements; unmeasured performance remains pending. |
| `accessibility_regression` | Actual small-phone/160% text, keyboard/focus, contrast, reduced-motion and platform regression observations. |
| `data_safety_privacy_declarations` | Actual owner-reviewed data-safety/privacy declarations, including optional connected services, retention, permissions and learner data; do not infer legal answers from local-first operation. |

The final gate deliberately makes the WIP's required data-safety/privacy review
explicit instead of hiding it inside the privacy-policy gate. Existing signing
and physical-certification controls remain authoritative for their own checks.

## Listing and submission handoff

`store/play-store-listing-template.md` and
`store/microsoft-store-listing-template.md` are honest editorial drafts. Their
local-first learning claims must still be checked in the exact production build.
Account configuration and availability must be verified; do not advertise
production sync, AI, deletion, recovery or public rankings solely because account
hooks or development services exist. The drafts contain no invented legal,
advertising, purchase or child-audience declarations.

The owner must provide public support/privacy details, production accounts and
identities, certificates, human physical observations and declaration decisions.
Review console requirements at submission time. This preflight neither submits
to a store nor changes backend configuration. Keep external gates pending until
actual evidence exists and the responsible human has reviewed it.

## Regression verification

```text
# Set DART to the standalone SDK executable if it is not on PATH.
python test/store_readiness_tools_test.py -v
```

These CLI tests exercise pending/strict behavior, malformed roots and schemas,
exact required gates, missing/unbounded/stale evidence and human/source/build/
artifact bindings, plus output alias regressions that preserve original manifest
and evidence bytes. Symlink creation tests may skip where the OS disallows them.
The integration owner runs the repository Flutter checks and
release builds separately.
