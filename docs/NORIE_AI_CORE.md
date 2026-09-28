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

The database defaults are intentionally conservative and subscription-ready:

- Free generation credits: 3/day
- Free Ask Norie credits: 15/day

Overrides live in `ai_user_entitlements`; Flutter does not decide or enforce authoritative quota values.

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

Planned long-term provider:

- Norie Study Model based on a suitable Gemma-family open-weight model.

The app should not need a Flutter release when the backend provider changes.

Future adapters may include Gemini, Azure-hosted models, Claude, or other approved inference providers.

## Cache scope

AI cache entries are private to the learner by default. Student-uploaded results must not be shared between users.

A separate explicitly public/licensed curriculum cache can be added later for Norie-authored curriculum material.

## Subscription direction

The quota schema supports future Free / Plus / Pro plans. Payment integration is intentionally outside the AI Core Foundation sprint.
