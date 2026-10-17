# Production signing and release controls

The public release workflow remains the preview channel: Windows is unsigned and
Android uses a generated debug key. `production-signing.yml` is a separate manual
workflow that produces **production candidates**, never a public production
promotion. No production keys, certificates or physical certification are included
in this repository. Production signing and physical-device certification remain
blocked until the owner supplies those external prerequisites.

Configure a GitHub environment named `production` with required reviewers, restrict
it to `develop`, and prohibit self approval. Repository administrators must enforce
these settings; a workflow environment label alone does not establish trust. Run
only reviewed source. Dispatch from `develop` with a full 40-character commit and
matching `vMAJOR.MINOR.PATCH` tag. Both Android and Windows push CI at that exact
revision must have succeeded; a newer failed rerun rejects the candidate. The gate
also requires the desktop and Flutter versions to agree. Candidates reuse the
actual tested binaries, rather than rebuilding untested source with credentials.

Environment secrets:

- Android: `NORIE_ANDROID_KEYSTORE_BASE64`, `NORIE_ANDROID_KEYSTORE_PASSWORD`,
  `NORIE_ANDROID_KEY_ALIAS`, `NORIE_ANDROID_KEY_PASSWORD`.
- Windows: `NORIE_WINDOWS_CERT_BASE64`, `NORIE_WINDOWS_CERT_PASSWORD`.

Protected environment variables:

- `NORIE_ANDROID_CERT_SHA256`: SHA-256 certificate fingerprint independently
  confirmed by the signing owner. Do not use a debug certificate fingerprint.
- `NORIE_WINDOWS_CERT_SHA256`: SHA-256 certificate fingerprint, **not** the common
  SHA-1 Windows thumbprint.
- `NORIE_WINDOWS_TIMESTAMP_URL`: the certificate provider's supported Authenticode
  timestamp endpoint. Windows candidates require a valid signature, timestamp
  certificate and trusted timestamp chain. Revocation checks require connectivity.

The helper refuses absent credentials and untrusted dispatch contexts. Credentials
are decoded into exclusively created temporary files, deleted in `finally`, and
never logged or uploaded. Windows uses an ephemeral in-memory certificate without
importing it into the persistent certificate store; APK password arguments refer
to environment variables. A cancelled runner must be destroyed rather than reused
with residual process state. Use GitHub-hosted disposable runners for this workflow.
No helper generates signing keys. Hardware-token/remote-signing certificates need a
reviewed provider adapter; an exportable PFX must not be assumed available.

APK versionName/versionCode and Windows ProductVersion must match checked-out
source. The original tested input digest and final signed digest are recorded in
schema-1 compatible candidate metadata with `channel: production-candidate` and
pinned signer information. APK verification runs `apksigner verify --print-certs`;
Windows verifies every packaged EXE, DLL and native Node module using
`Get-AuthenticodeSignature`, pinned certificate SHA-256 and timestamp trust.
`production_release.verify_aab` verifies signed AAB entries and embedded signer
using JDK tools. The optional 0.13 AAB candidate path consumes the exact-revision
Preview bundle and provenance sidecar from trusted CI; neither builds nor
publishes store packages inside the signing job. Real-key rehearsal and
bundletool/console validation remain pending.

Before a production promotion, download both candidates and their metadata. Verify
source/version/channel/digests with `validate_binding`, rerun both platform signature
checks on the actual extracted packages, then complete and review the five-device
matrix against those final signed hashes. Keep original candidate hashes immutable.
Do not publish a candidate as production while certification is pending. The
workflow intentionally has no production publish job; a reviewed promotion step
must carry the human evidence and signer verification forward before it is enabled.
Preview downloads remain available independently of these missing prerequisites.

## Android preview to production migration

The preview and production package use the same Android application ID but different
signing keys. Android rejects an in-place replacement. Never instruct a learner to
uninstall before exporting their local data. No account sync or automatic backup
should be assumed to contain local progress.

1. On the existing preview, open Settings and export the progress backup. Save a
   second copy outside the app's private storage (for example Files/Downloads and
   a PC). Keep classroom assignment/submission exports separately where needed.
2. Record learner profiles, XP, mastery, achievements and a recent lesson's
   completion state. Confirm the backup file is nonempty and can be selected in
   the restore picker. Keep the previous preview installer and do not erase backup
   copies during rollback.
3. On a spare physical device, demonstrate backup and restoration using the exact
   preview and candidate builds. Inspect every recorded progress field after a
   full restart, then test offline lessons and classroom records. Record any
   unsupported fields or migration loss; a failure blocks production promotion.
4. Only after the backup has been independently verified, uninstall the preview,
   install the production APK, restore through Settings and compare the recorded
   fields after restart. A fresh installation has no prior data until restoration.
5. If restoration fails, stop distribution. Reinstall the previous preview and
   restore the retained backup where supported. Do not discard the export.

This document is a migration procedure, not evidence that a physical migration has
passed. Subsequent production upgrades must retain the same production signing
identity (or follow a separately tested Android signing-key rotation procedure).


## Optional tested AAB candidate

0.13 adds android_format=apk/aab to this same protected workflow (APK remains default). AAB candidates require the matching exact-push-CI Preview bundle plus its byte-bound provenance sidecar. Jarsigner uses environment-password references, pinned certificate verification and unchanged-payload comparison. No keys or store upload are created. See [production-aab.md](production-aab.md) and the [official JDK jarsigner reference](https://docs.oracle.com/en/java/javase/17/docs/specs/man/jarsigner.html). Actual credential-backed execution and physical/store review remain pending.
