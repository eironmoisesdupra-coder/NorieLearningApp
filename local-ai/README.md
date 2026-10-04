# Experimental Local Study AI

This opt-in build connects Norie Study to Ollama on this computer. It uses the
downloaded `qwen2.5:1.5b` model, not a newly trained model or the paid OpenAI API.
The public website and normal cloud build are unchanged.

## Current proof status

**Source-preservation proof passed; learning-quality release gate still pending.**
On 2026-10-03, the revised pipeline generated 20 Taxonomy cards using actual
`qwen2.5:1.5b` inference in 116.4 seconds. Each answer exactly reconstructs its
source sentence when inserted into the cloze prompt. The saved-source Q&A check
also passed: it returned "A family contains genera." for the rank above genus.
This is relevant but less direct than the best sentence available in the notes.

Human review still found ambiguous multiple-choice distractors, including
"classification" versus "classifications". Some selected terms test wording
more than conceptual understanding. These must be addressed and evaluated across
subjects and levels before public release. Do not treat this as a grading system
or an all-subject accuracy certification.

The earlier free-form pipeline produced incorrect keys and only 18 cards. The
new `source_span_v1` path does not let the model write the prompt or answer key:
it selects an exact source term and optional distractors, while code builds the
card. Invalid/partial-word/repeated spans are rejected. At most twice the
requested number of passages are attempted; partial results remain possible.

Q&A is now extractive: the model chooses a passage and code returns the actual
source text, or abstains. Selection can still be irrelevant. Local HTTP calls
use explicit deadlines and response-size limits instead of Node fetch's default
response-header timeout. The proof client allows up to 20 minutes for generation.

Twenty-three Node tests and 203 Flutter tests pass. Unit tests use injected model
responses, separately from the real Taxonomy proof. Flutter analysis and the
dedicated local web release build also passed.

Browser verification generated a separate five-card flashcard deck through the
actual form, opened its due-card review, and revealed the preserved answer
"organisms" with the existing review controls. The local mode menu no longer
offers true/false. This browser check does not establish cross-device sync or
production user isolation.

After the queue integration, a new browser request generated and saved five
biology flashcards through the job API. The existing panel displayed actual
2/5 and 4/5 accepted-card counts. Desktop (1280x900) and phone (390x844) views
were inspected, and the queue returned to zero active/pending jobs.

## Run on this Windows computer

Prerequisites: Node.js 24 or newer, Flutter, Ollama, and a downloaded `qwen2.5:1.5b` model.
Ollama 0.35.1 and the model are already installed on the development computer.
The runtime executable is at `%USERPROFILE%\.codex\tools\ollama\ollama.exe`.
The model uses the Apache 2.0 license; see the
[official model page](https://ollama.com/library/qwen2.5:1.5b).

From the NorieLearning project directory:

```powershell
npm ci --prefix local-ai
& "$env:USERPROFILE/.codex/tools/flutter/bin/flutter.bat" build web --release --no-web-resources-cdn --no-wasm-dry-run --dart-define=NORIE_LOCAL_AI=true --output=build/local-web
node local-ai/prepare-web.mjs
& ./local-ai/start.ps1
```

Open <http://127.0.0.1:8752>. If the local server is already running, reuse it;
do not start a second copy. Check <http://127.0.0.1:8752/api/health> for model
availability. `ready` means installed, not that generation quality is verified.

In Learn, open the study generator and paste notes. Supported modes are multiple
choice, identification, flashcards, and mixed. Local true/false generation is
disabled until false statements can be reliably verified; cloud modes are
unchanged. Files and images are not supported locally. Requests need
80-16,000 characters and a supported count
of 5, 10, 20, or 40. CPU generation can take several minutes. Multiple generation
and Q&A requests can be accepted together; one worker runs by default on this CPU.
Results may contain fewer questions than requested.
Generation currently uses short source sentences of at most 25 words. The
validated proof uses English notes, not an all-language or all-grade benchmark.

## Concurrent requests

The local adapter uses `p-queue` for bounded execution and Node SQLite for durable
job records. Flutter submits a short request, polls status every two seconds,
and shows queue position or accepted-card progress. Different inputs have
independent job keys. Duplicate submissions with the same key and input reuse
the job; reusing a key for different input returns HTTP 409.

| Setting | Default / behavior |
| --- | --- |
| `NORIE_LOCAL_CONCURRENCY` | 1 worker; supported range 1-8 |
| `NORIE_LOCAL_QUEUE_CAPACITY` | 32 pending/running jobs; at least the worker count, at most 256 with the default record limit |
| Execution deadline | 20 minutes per job; abort propagates to the model HTTP request |
| Queue wait limit | 30 minutes; expired jobs do not start |
| Job retention | 24 hours after completion; pruning happens on queue access/startup |
| Retained record limit | 256; full capacity or storage returns HTTP 429 |

Increasing worker concurrency is not a GPU upgrade. `start.ps1` keeps Ollama's
parallelism at one on this laptop. Larger model parallelism requires separate
hardware benchmarking and runtime configuration. Run only one API process per
storage directory; this SQLite scheduler is not a distributed worker system.

On restart, queued requests resume. Previously running requests are marked failed
instead of silently rerun. Graceful shutdown waits for worker cleanup. Cancellation
does not free an active worker slot until its execution stops. Failures in one job
do not prevent later jobs from running.

The app retains a random retry key in local preferences until a terminal result.
After a connection interruption, retry with the same input and settings to
reconnect without submitting duplicate work, while the job record is retained.
This is not automatic navigation recovery after closing a tab: notes must be
provided again. Changing input creates a separate job. Generation and source Q&A
both use the same queue; the old synchronous API remains available for the proof
script and older clients.

API contract (all endpoints remain loopback-only):

- `POST /api/jobs`: JSON `{ "kind": "generate", "input": { ... } }` or kind `ask`.
  Supply a unique random `X-Norie-Job-Key` header (32-128 URL-safe characters).
  Returns HTTP 202 with `id`, `status`, `queue_position`, `progress`, and `result`.
- `GET /api/jobs/:id`: status/result, with the same header. A missing/wrong key
  returns HTTP 404. No job-list endpoint or source payload is exposed.
- `DELETE /api/jobs/:id`: cancel with the same header. Cancellation is available
  through the API; the app does not yet expose a cancel button.
- States: `queued`, `running`, `succeeded`, `failed`, `cancelled`, `expired`.
  Only `succeeded` includes a result. Keys never go in URLs or server logs.

Tests cover twelve queued requests with two executing workers, ten simultaneous
HTTP submissions, result separation, duplicate submissions, capacity rejection,
key checks, queued/running cancellation, restart recovery, deadlines, and shutdown.
These use controlled workers: they do not prove ten simultaneous model inferences
or authenticated separation between public users.

## Data and scope

- AI requests go to local Ollama at `127.0.0.1:11434`; the adapter binds only to
  `127.0.0.1` and rejects other browser origins and Host headers.
- Sources and decks are stored unencrypted under
  `%LOCALAPPDATA%/NorieLearning/local-ai`. Treat them as private local files.
- `jobs.sqlite` and its WAL contain queued inputs and retained results. Completed
  jobs clear their input field, but this is not secure disk erasure. Deleting a
  saved deck does not immediately remove its retained job result. Browser retry
  keys are also local data; they are access capabilities, not account authentication.
- Decks generated through the app are also cached in its browser storage. A deck
  generated by the CLI is not automatically imported into the app's library.
- This is a single-computer prototype, not an authenticated multi-user service.
  Do not expose these ports publicly. Other app cloud features are unchanged.
- Existing rewards and spaced repetition use ordinary app code, not the model.
- No updated Windows installer or Android APK contains this local integration.

## Reproduce checks

```powershell
node --test test/local_ai_test.mjs test/study_generation_test.mjs
& "$env:USERPROFILE/.codex/tools/flutter/bin/flutter.bat" analyze
& "$env:USERPROFILE/.codex/tools/flutter/bin/flutter.bat" test
node local-ai/prove.mjs
```

`prove.mjs` uses actual inference and intentionally requires 20 questions plus
source Q&A. It checks exact source reconstruction and writes the generated deck
to `build/local-ai-proof/taxonomy-deck.json`. It does not validate the semantic
correctness of distractors. Never substitute canned questions to report a pass.

The authenticated multi-user queue, two-free-generations-per-day enforcement,
paid subscriptions, grade-adaptive generation, cloud deployment, and broad
educational evaluations remain separate work. This local server is not their
implementation and must not be exposed publicly.