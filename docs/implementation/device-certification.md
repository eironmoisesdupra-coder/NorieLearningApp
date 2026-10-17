# Physical device certification

No hardware has been certified by adding these tools. CI, emulators, loopback LAN
and automated browser tests are useful engineering checks, but cannot establish
physical performance or isolated classroom Wi-Fi behavior.

Generate an untested template without overwriting existing evidence:

```
dart tool/device_certification.dart build/device-certification/report.json
```

The version-2 matrix requires five classes: low-end Android, midrange Android,
Android tablet, low-spec Windows laptop and Windows desktop. Record actual model,
OS, RAM and display; retain identifying device details privately when appropriate.
A named human operator records real observation start/end UTC timestamps and marks
`origin` as `human_physical` only after running the scenarios on physical hardware.
Bind the matrix to a full source revision, `version+build`, and SHA-256 of the exact
installed Android APK or Windows ZIP. A rebuilt or resigned artifact needs new
certification or a documented, reviewed retest; source revision alone is insufficient.

Every device must cover all twelve fixed scenarios: offline cold start, persistence
after process termination, classroom file import/export, offline audio, anatomy
responsiveness, 160% text, reduced motion, backup/restore, update/migration, isolated
Wi-Fi classroom exchange and disconnect/reconnect with duplicate submission retry.
For `update_path`, follow the production migration guide and compare actual profile,
progress and reward values. For LAN, use a Windows teacher and Android student on
Wi-Fi with internet disconnected, include firewall consent, wrong code, stop/restart,
lost acknowledgement/retry and no duplicate awards. Record cross-device partners
in notes. All five hardware classes must participate in their applicable scenario.

Record each result's measured `elapsed_ms`, observation notes and a nonempty local
evidence file relative to the report directory. Capture screenshots/video/logs
that show the build and outcome; avoid learner personal data and never include
keys or join codes. Status begins as `not_tested`. `fail` and `not_tested` block
acceptance. Do not replace observations with generated PASS records. The sample
fixtures used in automated tests are synthetic fixtures, never hardware evidence.

Review the complete package locally, outside CI:

```
dart tool/verify_device_certification.dart path/report.json FULL_40_HEX_SHA 0.12.0+16 ANDROID_APK_SHA256 WINDOWS_ZIP_SHA256
```

The verifier rejects CI contexts by default, missing classes/scenarios, duplicates,
nonphysical declarations, missing measurements or evidence, mismatched hashes,
source or version, and incomplete results. It checks report structure and bindings;
it cannot prove that a human told the truth, that evidence shows the claimed result,
or that a particular machine meets its claimed performance class. A reviewer must
inspect the hardware identification and evidence, rerun questionable scenarios and
sign off through the protected release review. Retain the evidence with the
immutable candidate metadata. Passing automation alone must never be described
as physical-device certification.
