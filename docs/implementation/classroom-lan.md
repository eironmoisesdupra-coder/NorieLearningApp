# Local Wi-Fi Classroom (Preview)

The installed Windows/Electron package and Android app support explicit LAN sessions. The hosted web app keeps file exchange. Core lessons and existing file exports still work offline. QR rendering is local; Android uses the bundled detector. Camera permission is requested when scanning; manual entry works without a camera.

## Teacher

1. Open Learn > Offline Classroom and build/import the assignments to share.
2. Open Local Wi-Fi Classroom > Host a classroom. Check specific assignments. Sharing begins only after Start local classroom.
3. Connect to a trusted private Wi-Fi/hotspot. Show the temporary QR, address and six-digit code. With multiple adapters, choose the address reachable by students. A127.0.0.1 address works only on the host; reconnect Wi-Fi and restart the session.
4. Keep the teacher screen open. Received results update automatically; Refresh results is also available. Roster entries are result aliases, not verified attendance.
5. Stop classroom or leave the teacher screen to close it. Restarting creates a new code/session. Selection is frozen for that session; restart to change shared assignments.

## Learner

1. Join the same network. Enter the teacher address including http:// and port, plus the six-digit code; alternatively scan the teacher QR on Android or load a copied QR link. Tap Join classroom explicitly.
2. Download and practise imports the existing classroom package and opens the usual offline practice screen. Installed content must match; different questions are rejected rather than silently scored.
3. Finish saves the result locally first. Return to teacher sends that same result. Received by teacher means validated, recomputed and durably saved.
4. If disconnected, keep the saved result. Rejoin with current details, refresh assignments, then Return saved results. Retrying the same ID creates no additional attempt. File export remains available in Offline Classroom.

## Network setup and limits

Windows may prompt for firewall access when hosting. Allow NorieLearning on the trusted Private network. Guest Wi-Fi/client isolation may block device-to-device traffic; use a classroom router or private hotspot with peer access. VPNs may select an unreachable adapter: verify the displayed address.

Endpoints accept private literal IPv4 addresses and explicit ports. Public URLs, DNS names, embedded credentials and redirects are rejected. There is no cloud relay, automatic discovery, automatic hosting or persisted join secret. Local HTTP practice is intended for a trusted network; it is not an encrypted or identity-verified exam service. Classroom work awards no XP, credits, mastery or league points. Ownership guards stop sharing on learner change.

Requests are versioned, bounded and timed. Pending memory/connections are limited. Busy rooms may require a retry; learner results remain saved. Only selected assignments are retrievable. Existing codecs, resolver and store enforce content checks, scoring, durable writes and duplicate/conflict handling.

## QA evidence boundary

Node transport tests, native Dart loopback tests, phone widget tests and packaged Electron/native-Dart interoperability validate automated behavior. They do not certify actual Wi-Fi, camera permissions, firewall prompts, low-end performance or physical devices. Complete the matrix in [device-certification.md](device-certification.md) on real hardware before claiming production readiness. Downloads remain Preview.

Dependencies: [qr_flutter](https://pub.dev/packages/qr_flutter) and [mobile_scanner](https://pub.dev/packages/mobile_scanner). Their licenses are included in Flutter's package license registry.
