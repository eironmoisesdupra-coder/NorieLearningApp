# LAN Classroom, Signing and Device Certification Implementation Plan

> For agentic workers: use superpowers:subagent-driven-development / dispatching-parallel-agents for independent domains and TDD. Root owns integration, full Flutter runners and release.

**Goal:** Integrate supplied roadmap18/19/20 into current develop f4255a04ab71cb313f05c4d3223b7865d380256d, publish verified preview packages, and provide fail-closed production signing/certification gates without fabricating credentials or hardware evidence.

**Spec:** Supplied NorieLearning-WIP-roadmap-18-19-20-2026-10-17.zip README and overlay, manually inspected. Archive installer is reference, never executed. User requests implementation; preserve all existing architecture and offline features. This plan records the design for that authorized integration.

**Architecture:** Existing classroom codecs/resolver/store remain the sole authority for import, durable writes and recomputed scores. Native Dart and Electron transports share a versioned HTTP protocol; hosted web remains file-based with a clear installed-app explanation. No extra classroom XP, credits, mastery or league awards. Production credentials and physical hardware reports are external prerequisites, not invented test results.

## Global constraints / review focus

- Original dirty checkout stays untouched; reuse isolated NorieLearning-integrate and feature branch based on current develop. Never main.
- All LAN connections use explicitly entered private literal IPv4 endpoints, ephemeral six-digit code and session identity; no DNS/public URL fetching, automatic discovery, cloud relay or persisted secrets. HTTP is for trusted local Wi-Fi practice, not secure exams.
- Teacher explicitly selects assignments and starts/stops. No listener before start; stop on leaving screen, account/ownership change, reload or application exit.
- Bound streamed bodies before decoding to2MiB, nesting/duplicate-key checks via existing classroom codec; deadlines, bounded pending requests and connection errors. Reject cross-session, wrong code, malformed or stale-content packages.
- Submission ACK follows validated durable classroom store write. Repeated IDs are idempotent; conflicts rejected; lost response/reconnect does not lose local results or create extra rewards.
- Never call production signed or physical certified without actual signature/trusted signer verification and human hardware reports. Preview remains accessible.

## Shared LAN contract

HTTP envelopes: {protocol:"norie-classroom-lan",version:1,type,session_id,payload}. GET /v1/hello =>type hello; GET /v1/assignments =>assignment_list with metadata summaries; GET /v1/assignments/<encodedID> =>assignment with payload.package existing encoded classroom assignment. POST /v1/submissions sends type submission with payload.package existing encoded classroom submission, returns type ack with submission_id and accepted (false means already stored). Headers x-norie-join-code always; x-norie-session-id except initial hello; validate returned envelope session/type. Error statuses and bounded sanitized JSON errors. No CORS wildcard. No web-origin access to local host.

QR: norie-classroom://join?endpoint=<private-http-base>&code=<six digits>&session=<uuid>. Android optional camera scan plus manual address/code entry; QR rendered locally. Browser web does not attempt insecure local requests. QR contains temporary connection info only.

Electron bridge: window.norieClassroomLan.invoke(action,dataJSON) ->Promise<JSON string>, context-isolated/sandboxed preload, exact top-level norie://app sender only. Actions start,stop,poll,respond,request. start({}) returns session JSON {session_id,join_code,host,port,started_at,addresses}. poll returns {session,requests:[{request_id,method,path,body}]}; body is bounded raw JSON string or empty. Dart processes each request with shared classroom handler then respond({request_id,status,body:<JSON string>}); HTTP ACK never precedes Flutter durable write. Node bounds/authorizes incoming requests, timers and pending memory; all classroom payload/score decisions remain Dart. request({endpoint,join_code,session_id,method,path,body}) supports installed PC joining too, rejects arbitrary URLs/redirects, returns {status,body}. Stop/reload/exit rejects pending. Node server does not log/persist classroom codes or learner data.

## Task1: Production release hardening and certification (independent)

Files: scripts/release/* signing/verifier helpers; tool/device_certification.dart and verifier; docs/implementation/*; focused Python/Dart-tool tests; new production workflow. Preserve existing preview workflows and metadata schema compatibility.
- [x] Write failing tests for absent credentials, mismatched version/source/digest/signer, preview-vs-production channel and incomplete/forged certification reports.
- [x] Implement trusted-environment only secret decode/cleanup, Android APK/AAB signer verification and Windows Authenticode verification, explicit production signing workflow and migration guide for debug-to-production Android backup/restore. Do not create private keys or purchase certificates.
- [x] Implement honest five-device report template/verifier tied to revision/build/scenarios and measured results; no machine-generated PASS certification.
- [x] Run relevant tests; document missing external prerequisites.

## Task2: Electron LAN transport (independent)

Files: desktop/classroom-lan*.cjs, preload.cjs, main.cjs, package-windows.cjs, Node tests. Consumes bridge contract above; no Flutter files.
- [x] Failing tests for authentication/session, endpoint allowlist, streaming bounds/deadlines, busy limits, host stop/restart, same-response relay and sender-frame access controls.
- [x] Implement HTTP host and private client, narrow IPC bridge, lifecycle cleanup; package every required module/preload.
- [x] Run Node tests with actual loopback HTTP; report interfaces/evidence.

## Task3: Dart LAN protocol/transport (independent)

Files: lib/features/classroom/lan/* and test/norie_classroom_lan*transport/protocol tests. Consumes existing store/codec/resolver and bridge contract. Root owns UI, dependencies, platform permission configuration and full-suite runner.
- [x] Failing tests for private endpoint/QR validation, envelope/session/version checks, actual IO host/client transfer, durable ACK/idempotent retry/conflict, wrong code, bounds/deep nesting, stale learner guards, stop/reconnect and zero economy mutations.
- [x] Implement modular common protocol handler/models, client and host API with conditional native IO, Electron web bridge and browser stub. Native host delegates same Dart handler; web host polls/responds through narrow bridge with durable store guard.
- [x] Host API constructor({store,stillCurrent}), supported/session getters, start({required assignments}), refresh(), stop(), dispose(); client supported, connect(endpoint,joinCode,{expectedSessionId}), fetchAssignments/downloadAssignment/submit tied to session; document final exact signatures before UI integration.
- [x] Coordinate targeted Flutter runner with root; no concurrent Flutter runners.

## Task4: Root integration/UI and verification

Files: classroom hub/runner, LAN teacher/join/scan screens, pubspec/platform branding, CI check steps, docs/handoff/release version.
- [x] Add teacher explicit selection, QR/address/code, roster with refresh and automatic updates, stop; student join/scan/manual fallback, download/import, existing practice runner and saved submission retry/reconnect. Use existing ownership guards. Keep file exchange fully functional.
- [x] Add bundled offline QR rendering/scanning; Android network/camera permissions only as needed, private-endpoint validation confines LAN cleartext use; Electron browser stub explanatory.
- [x] Meaningful phone widget/UI and actual packaged Electron-to-native-Dart loopback integration tests; independent review, full analyze/test, web and Android builds, existing offline regression tests. Never represent loopback/CI as physical Wi-Fi certification.
- [ ] Update to0.12.0+16 preview, focused canonical commits/PR develop, exact-head green CI then merge; merged-source CI/public UI, dual-platform publication and verified version/source/download URLs. Report what external signing/hardware checks remain.

Local integration evidence: 748 Flutter tests passed (packaged-only test skipped in ordinary runner), analysis clean, release web build and Windows package passed. Actual packaged teacher/native learner loopback passed separately, including durable grading, duplicate/reconnect, unchanged XP and listener shutdown. Browser file exchange/CSV/seasonal/LAN fallback and diagnostics/reload controls passed. Android and Windows exact-head CI builds remain publication gates; physical-device certification and production signer execution remain external prerequisites.
