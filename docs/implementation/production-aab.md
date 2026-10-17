# Exact tested AAB candidate path

This helper supports a future protected production candidate. A Preview AAB is a
separate CI artifact from the learner-facing Preview APK. Producing it, recording
provenance or passing these synthetic ZIP tests does not establish production
signing, Play approval or physical-device certification. Production credentials
were not available for this implementation; no keys were generated and no
credential-backed signing or store submission was run.

## CI provenance

After the existing trusted CI build/test steps produce the actual bundle:

```text
python scripts/release/production_aab.py provenance build/app/outputs/bundle/release/app-release.aab --revision <full-source-sha> --version <major.minor.patch+build> --output build/tested-aab.json
```

The producer must derive the revision/version from the exact tested source and
build, retain the exact AAB and JSON together, and upload them through the trusted
CI artifact path. The helper does not infer version information from a protobuf
manifest. Trust depends on the existing protected workflow checking the trusted
run, source revision and version; matching a self-authored JSON file alone is not
proof that CI tested a build.

The JSON has exactly these schema-1 fields:

```text
schema: 1
format: norie-tested-aab
revision: lowercase full 40-character Git SHA
version: major.minor.patch+build
sha256: lowercase 64-character digest of exact AAB bytes
bytes: positive exact integer artifact size
```

The CLI exits 0 after checked bytes are recorded, or 2 on invalid input/output.
The output must not already exist and its parent directory must exist. Exclusive
creation prevents accidental replacement of the tested AAB, a link to it or any
existing output. Do not overwrite and regenerate provenance after signing: the
metadata describes the original tested CI input, while candidate metadata must
identify the final signed bytes separately.

## Protected signing integration

The integration owner keeps the existing protected production environment,
explicit dispatch/source checks, secret lifecycle and pinned certificate identity.
The default APK path and Windows production signing controls remain in force.
An explicitly selected AAB candidate must use this sequence:

1. Obtain the exact trusted CI AAB plus its provenance and expected source/build.
2. Call `validate_provenance(artifact, metadata, revision, version)`. `metadata`
   accepts a dictionary or a JSON file path. It rejects missing/unknown/duplicate
   JSON fields, wrong types, stale source/build, mismatched digest/bytes or unsafe
   bundle contents before signing. JSON input is bounded to 64 KiB.
3. Call `prepare_unsigned(source, target)` with a **new** target path. It leaves
   the tested source untouched and strips only direct, case-insensitive JAR
   signing entries: `META-INF/MANIFEST.MF` and direct `.SF`, `.RSA`, `.DSA`, `.EC`
   files. It preserves services, licenses, nested metadata and every payload byte.
4. The existing protected signing wrapper invokes `jarsigner` with the owner's
   configured production/upload identity. This module never accesses credentials
   or invokes a signing command. The integration must retain safe password
   handling and temporary secret cleanup.
5. Run existing `production_release.verify_aab` to verify the JAR signature and
   pinned certificate. `verify_android` is the separate APK verifier.
6. Call `validate_same_payload(tested_input, signed_candidate)` to reject added,
   removed, renamed or changed non-signing files. It compares exact file names,
   sizes and SHA-256 of all decompressed bytes. ZIP timestamps/compression and
   explicit directory headers are not application payload; a signer-added
   `META-INF/` directory is allowed. Directory paths are still validated.
7. Record the final signed artifact digest in candidate metadata, retaining the
   tested input digest and exact source/build. Keep physical certification and
   human/store approval pending until actual evidence exists.

Do not use APK `apksigner` for an AAB. Do not widen signing permissions, create a
fallback key or turn a Preview/debug signature into claimed production evidence.
The helper neither chooses Play App Signing ownership nor confirms console or
package identity configuration; the responsible owner must review these.

## ZIP boundary

No archive is extracted. Every bundle requires nonempty `BundleConfig.pb` and
`base/manifest/AndroidManifest.xml`. These names establish a minimum AAB shape,
not semantic validation of the protobufs or a replacement for bundletool/Play
validation. All entry paths are checked before payload measurement: absolute,
traversing, noncanonical, backslash/drive-qualified, duplicate, file-directory
conflicting and control-character paths are rejected. Symlinks, special entries,
encryption, unsupported compression and inconsistent directory entries fail.
Only stored and deflated ZIP content is accepted.

Caps are 512 MiB compressed archive, 30,000 entries, 512 MiB per decompressed
entry and 2 GiB decompressed total. Payload reads use 1 MiB chunks, check declared
sizes and ZIP CRCs, and hash rather than loading whole entries into memory.
Malformed compressed data fails closed. Signature entries are integrity-checked
even though their content is excluded from payload comparison. Signature removal
copies through bounded ZIP streams, preserves notices/services and validates the
resulting file payload before returning; a failed preparation removes only its
newly created target.

## Validation and outstanding evidence

```text
python test/production_aab_test.py -v
```

Fixtures are synthetic and exercise source/version/hash/byte binding, strict
metadata, unsafe paths, duplicate/symlink entries, bounds, corrupt compression,
multiple old signatures, preserved licenses/services, same-size payload tampering,
added signer directory headers and refusal to overwrite source/hardlink aliases.
They do not demonstrate an installable AAB or successful production signing.

Still required: a real CI AAB from the exact source/build, bundletool/console
validation, protected production-key signing and verification, production
identity review, physical installation/certification and human/store approval.
No external readiness gate should pass solely because this helper passes tests.
