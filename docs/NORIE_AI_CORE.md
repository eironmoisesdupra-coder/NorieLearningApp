# Norie AI Core

Norie AI is the provider-independent intelligence layer behind Study Lab.

## Runtime flow

Flutter calls only:

`norie-ai-gateway`

The gateway currently routes:

- `generate_study_set` -> `generate-study-set`
- `study_qa` -> `study-qa`

Provider-specific credentials never enter Flutter or GitHub.

## Generation flow

1. Authenticate the learner.
2. Validate the source and generation settings.
3. Build a private per-user source/cache hash.
4. Return a validated private cache hit when available.
5. Check the learner's server-side daily AI quota.
6. Call the configured provider through the provider adapter.
7. Validate and normalize the result to Norie study-question schema.
8. Save the study set/questions.
9. Cache the normalized result for that learner.
10. Log provider/model/latency/token-unit information.
11. Save validation metrics.

Failed backend/provider generations refund the learner's generation credit.

## Default quotas

The existing foundation documents these baseline defaults:

- Free generation credits: 3/day
- Free Ask Norie credits: 15/day

Overrides live in `ai_user_entitlements`; Flutter does not decide or enforce authoritative quota values.

The confirmed product requirement is now **2 free generations per day**, with
higher configurable allowances and features for paid users. This document does
not change the database defaults or deploy that rule. A migration and concurrent
request tests are required. Keep AI allowances separate from game XP and coins.

## AI Core tables

- `ai_user_entitlements`: plan and daily quota overrides.
- `ai_daily_usage`: authoritative daily credit use.
- `ai_provider_registry`: non-secret provider capabilities and routing metadata.
- `ai_generation_cache`: private per-user normalized-result cache.
- `ai_generation_requests`: generation/Q&A telemetry.
- `ai_evaluation_records`: validation-quality metrics without training on uploads.
- `ai_training_examples`: future curated training data.

## Privacy and future training

Student-uploaded material is not automatically inserted into the training dataset.

`ai_training_examples.source_kind` only permits:

- `editor_authored`
- `public_domain`
- `licensed`
- `synthetic_reviewed`

Training examples require a separate curation/approval path.

## Provider strategy

Current adapter:

- OpenAI (temporary; may be unavailable when API credits are exhausted)

Previously proposed long-term provider:

- Norie Study Model based on a suitable Gemma-family open-weight model.

Model selection is not final. Compare commercially permitted open-weight models
on Norie's reviewed study-generation cases before selecting a family or paying
for hosting. The original local `qwen2.5:1.5b` experiment returned 18 questions
and included incorrect answer keys. The revised source-span pipeline now passes
the 20-card source-preservation and extractive-Q&A proof, but ambiguous
distractors remain a public-release blocker. See
[local prototype status](../local-ai/README.md).

The app should not need a Flutter release when the backend provider changes.

Future adapters may include Gemini, Azure-hosted models, Claude, or other approved inference providers.

## Cache scope

AI cache entries are private to the learner by default. Student-uploaded results must not be shared between users.

A separate explicitly public/licensed curriculum cache can be added later for Norie-authored curriculum material.

## Subscription direction

The quota schema supports future Free / Plus / Pro plans. Payment integration is intentionally outside the AI Core Foundation sprint.

## Gizmo research and Norie implementation blueprint

Researched 2026-10-03 using public documentation. This section is a proposed
implementation, not a claim that these services are installed or deployed.
No access to Gizmo's private code, model weights, accounts, or infrastructure is
needed. Preserve Norie's own interface, mascot, curriculum, and learning logic.

### What is publicly verified

| Finding | Official source |
| --- | --- |
| Magic Import creates flashcards and highlights answer terms from notes, PDFs, photos, recordings, presentations, websites, and existing decks. It recommends reviewing results and splitting large documents into smaller sections. | [Magic Import](https://help.gizmo.ai/en/articles/15647624-what-is-magic-import) |
| Import controls include destination deck, topic subdecks, selected pages, target card count, additional instructions, and card language. | [Import customization](https://help.gizmo.ai/en/articles/15654559-how-do-i-customise-my-magic-import) |
| Highlighted terms are editable and become blanks in quizzes; more terms can be hidden as familiarity increases. | [Highlighting](https://help.gizmo.ai/en/articles/13166301-how-does-highlighting-work) |
| Memorise uses saved cards, active recall, spaced repetition, and several question styles; multiple-choice wrong answers are AI-generated. | [Memorise](https://help.gizmo.ai/en/articles/13906596-how-does-memorise-mode-work) |
| Cards support text/front-back, multiple choice, matching, ordering, and true/false. | [Card types](https://help.gizmo.ai/en/articles/16527223-what-types-of-flashcards-can-i-make) |
| The documented free import rule is a 20-minute wait; Unlimited removes that wait and unlocks other features. This is not Norie's two-per-day policy. | [Unlimited](https://help.gizmo.ai/en/articles/15647627-what-do-i-get-with-gizmo-unlimited) |
| The privacy notice discloses sharing educational/user-generated data with an AI supplier. It names PostHog, LogRocket, Cloudflare, and Sentry for analytics/diagnostics, not as the generation engine. | [Privacy notice](https://gizmo.ai/privacy) |

The sources reviewed do not identify the exact generation model, model host,
queue technology, training recipe, GPU fleet, or cost per generation. They do
not establish that Gizmo uses an exclusively self-hosted open model, vLLM,
Docling, Supabase, or FSRS. Its product label "Unlimited" is not evidence of
unlimited compute or zero operating costs. The notice discusses pre-training
and possible fine-tuning but does not disclose a reproducible training setup.

The privacy notice also generally restricts use to ages 13 and older. Norie's
all-grade ambition therefore needs its own child-privacy and age-appropriate
design; copying Gizmo's access policy would not meet that ambition.

### Main adaptation: generate cards, reuse them for practice

The strongest transferable pattern is an editable card with an explicit answer,
not asking an LLM to invent a fresh answer key for every practice session.

Proposed flow:

```text
Private source -> extracted sections -> source-backed cards + answer spans
							 -> validation -> editable saved deck -> practice variants
```

Example using author-written source text:

```text
Source/card: Family is immediately above genus.
Answer term: Family
Typing prompt: _____ is immediately above genus.
Grading key: Family
```

Code can retain the exact removed answer and create a cloze prompt without
another model call. The learner can reveal the same card as a flashcard. The
model may propose distractors for a multiple-choice variant, but must not
replace the stored correct answer. Distractors still need checking: a distinct
string can be another valid answer. Do not silently switch an explicitly
requested multiple-choice deck to a different format when validation fails.

Store provenance, source section/page, the answer span, card revision, and
validation status alongside existing study questions. A card edit invalidates
dependent practice variants. Reuse the existing source excerpts, card editor,
offline store, review screen, and FSRS scheduling rather than replacing them.
Cross-device review-state sync is a separate follow-up; current local scheduling
does not establish that sync is implemented.

This reduces unnecessary inference but does not guarantee truth: source text
may be wrong, extraction may omit a negation, and a paraphrase may change meaning.
Preserve qualifiers and source links, support corrections/reporting, and never
label quotation matching as semantic answer verification. Do not generate
false-statement answer keys merely by choosing True or False at random.

### Proposed technology choices, not claims about Gizmo

| Component | Norie choice and reason |
| --- | --- |
| App | Keep Flutter and the existing study service; retain offline learning and Norie's design. |
| Authentication/data | Keep Supabase Auth, PostgreSQL, private storage, entitlements, and per-user cache. |
| Import parsing | Evaluate [Docling](https://docling-project.github.io/docling/) for PDF/PPTX/document extraction and OCR in an isolated worker. Start with pasted notes; parser and OCR support must be tested on actual school documents. |
| Model development | Keep Ollama for local evaluation. It is not evidence of public capacity. |
| Production inference | Evaluate [vLLM](https://docs.vllm.ai/en/latest/) on a private cloud GPU worker: it documents continuous batching, structured outputs, and an OpenAI-compatible HTTP interface. Pin a tested stable release rather than developer-preview docs. |
| Model | Select a commercially permitted instruction model using held-out correctness and latency tests; no model family is approved yet. |
| Queue | Durable PostgreSQL-backed jobs initially, with atomic claims, leases, bounded retries, fair scheduling, and queue expiry. |
| Review scheduling | Retain the existing FSRS dependency. No LLM is required to schedule a review or award XP. |
| Operations | Structured, redacted job metrics first; optionally add error monitoring later. Do not copy advertising trackers or collect private note text in session replays. |

An OpenAI-compatible interface describes request syntax; when pointed at our
own server it does not require an OpenAI subscription. GPU time, storage,
networking, and maintenance still cost money. Review each chosen library,
model-weight, OCR, and transcription license separately before deployment.
Avoid adding agent frameworks or a vector database until a demonstrated task
needs them. Chunked generation from one document does not inherently need either.

### Multi-user and allowance contract

- Derive ownership from verified authentication, never a user ID supplied by the app.
- Extend the existing entitlement/usage system; do not create a parallel quota authority.
- Atomically reserve one allowance and create the job. Enforce a unique per-user
	idempotency key, rejecting reuse with a different request payload.
- Count a successfully delivered usable deck once; release reservations on terminal
	failure or expiry. Settle against the reservation's original quota date.
- UTC daily reset is a proposal; show its local equivalent and obtain product approval.
- Reopening, editing, or studying a saved deck does not consume a generation.
	Separate optional tutor/hint inference needs its own explicit allowance policy.
- Verify paid entitlements server-side. Paid limits/features remain configurable
	and unapproved tiers must not be purchasable.
- A worker lease must include a claim token so an expired worker cannot overwrite
	a newer attempt. Completion and refunds must be idempotent.
- Enforce owner-only source, job, deck, and status access. Keep inference endpoints
	private; never place service-role credentials in Flutter.
- Cache only within the learner account by default, including source revision,
	grade, language, mode, and generator version in the cache identity. Never reuse
	another learner's private notes just because a topic name matches.
- Bound pending jobs, source tokens, output tokens, retries, queue depth, and job
	age. Reject overload before reserving allowance; reserve service for free users
	even when paid jobs have priority.

Thousands or millions of accounts are not the same as simultaneous inference
requests. The queue absorbs only bounded bursts; it cannot replace GPU capacity.
Use measured jobs/hour, queue latency, failure rate, and cost per usable deck to
size workers. Test infrastructure with simulated workers separately from actual
model-throughput and educational-quality tests.

### Convenience and grade-level controls

Keep a short normal flow: choose source, grade/learning level, language, format,
and count; submit; leave and return to a persisted job; review/edit the result.
Use profile defaults without guessing age from grade. Additional instructions
must not override backend safety, allowance, or source-boundary rules.

Add page selection and topic organization after document extraction is proven.
Website imports require SSRF defenses and redirect/size limits; recordings need
appropriate permission and retention controls. Do not bypass restrictions on
third-party content or import private decks without authorization.

### Implementation order and release gates

The local prototype now has a persistent SQLite/`p-queue` job adapter, bounded
workers, short submission/status APIs, cancellation/deadlines, restart handling,
and Flutter polling/progress with retry keys. Tests cover concurrent independent
requests. This is a single-process loopback implementation, not the production
PostgreSQL queue or authenticated account isolation. It does not enforce daily
allowances or provide cloud capacity. See the [local queue contract](../local-ai/README.md#concurrent-requests).

1. Initial source-backed card/answer-span path is implemented in the local
	generator, keeping existing question fields compatible. The real Taxonomy
	source-preservation proof passes at 20 cards; local true/false is disabled.
	Next, address ambiguous distractors and evaluate reviewed materials across
	several levels and subjects. Passing source reconstruction is not sufficient.
2. Add transactional two-per-day allowance reservations and durable private jobs
	 behind `norie-ai-gateway`. Test concurrent submissions, duplicate requests,
	 cross-user denial, UTC rollover, refunds, worker crashes, and stale claims.
3. Add the production model adapter and Flutter progress/reconnect flow. Keep
	 synchronous cloud generation available until the new path passes staging tests.
	 The known live `ordered_items` schema mismatch must be reconciled before promotion.
4. Add sandboxed document extraction and targeted OCR tests. Reuse the card editor
	 for corrections instead of exposing unreviewable generated output.
5. Benchmark a bounded cloud pilot, verify subscription lifecycle and account/data
	 deletion, test child-appropriate access, then consider public release.

No fine-tuning on student uploads by default. Build a separately licensed,
reviewed dataset only if evaluation identifies a problem fine-tuning can solve.
An additional model judging answers is a fallible check, not a substitute for
human-reviewed evaluations. Establish subject/grade-specific release criteria
before beta; block release on known systematic incorrect grading.

Public hosting purchases, a production model choice, paid tier values, and the
launch capacity target require separate decisions. This research does not deploy
anything, change the live provider, install the proposed libraries, or establish
million-user readiness.
