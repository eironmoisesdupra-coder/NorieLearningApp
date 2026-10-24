# Hybrid Quiz baseline — 2026-10-24

## Verified repository

Baseline develop and latest v0.18.0 Preview release: ed9472dbb437127abd8fd09931a86879d4df5ec5; pubspec 0.18.0+24. Fresh checkout clean; isolated feature worktree. Open PR72 (source inspection) edits StudySetScreen; PR73 and Anatomy74–76 remain separate. No merges or copied pending changes.

## Existing lifecycle

StudyHubScreen → StudyGeneratorScreen → NorieStudyService.generateFromSource → saved NorieStudySet → StudySetScreen → StudyQuizScreen / FSRS StudyReviewScreen → recordAttempt. Question formats: multiple choice, true/false, identification, matching, drag/drop, ordering, fill blank, flashcard; UI counts5/10/20/40, disabled100 Premium. JSON study models accept historical records; no generation provenance contract or resumable in-progress quiz currently.

Cloud Flutter uses norie-ai-gateway, action generate_study_set → generate-study-set; study_qa → study-qa. The backend OpenAI adapter uses server-only OPENAI_API_KEY and OPENAI_MODEL with NORIE_AI_PROVIDER (default openai), Responses API and normalized question output. No client provider key. The existing NORIE_LOCAL_AI build flag instead uses the loopback local-ai job service (Ollama); this is optional inference, not deterministic offline generation. No new live API request or credential provisioning in this milestone.

Uploads: private study-sources bucket, supported PDF/Office/text/images, UI10MiB limit, owner-prefixed path; pasted notes minimum80 characters. Source text/path/name/type/mime, generation mode/count/title/topic are sent; backend source extraction and schema validation retain excerpts. Source-specific requests must never fall back to unrelated curriculum.

AI quota is ai_daily_usage / ai_user_entitlements via consume_ai_credit_for_user and refund_ai_credit_for_user. Cache hits use zero generation credits; successful fresh generation uses one allowance; failure paths refund. This is NOT the game's Credits, and NOT the OpenAI billing balance. Exact "No credits remaining" does not occur in tracked app/backend code; provider error messages can be returned by the backend provider_error path. Therefore a screenshot/message alone cannot prove which quota failed. Existing _friendlyAiError forwards nonempty backend messages; provider sanitization/idempotent reservations remain later backend work. No billing/entitlement changes here.

NorieStudyOfflineStore uses SharedPreferences owner key norie.study.<id>.offline.v1, serialized writes, sets/cardChanges/reviews/attempts, durable reward outbox, reward receipts and stable completion claims. Current guest is local. Saved decks reopen offline. Before this change remote refresh deletes cached IDs absent from server: native decks must be exempt, preserved in returned results, and never sent as remote attempts/cards. Existing correct-answer reward5XP/1Credit up to16 cards and deck completion cap100XP remain unchanged. Native deck IDs must be stable for identical request/revision to prevent generation creating new reward identities.

No schema migration required. Native provenance is additive JSON metadata; historical decks remain readable. Native practice remains device-local per account until a separate authorized cloud sync contract exists. Existing cloud/local AI paths, notes, uploads, Anatomy, Classic, Adventure and economy unchanged.

## Initial milestone and trust

Unified contracts, deterministic bounded Mathematics templates, strict validation, explicit local coverage/shortage, free native entry point, owner-isolated local save/replay, and persisted session recovery. Bank imports cannot self-approve; no new human-reviewed bank content or Chemistry benchmark is claimed. Mathematical answer verification is computational, not academic/editorial certification. Template activation for a release requires code/content PR review. Advanced Chemistry/medical identification and external-provider wiring remain gated future work.

## Reproducibility

Run flutter analyze; flutter test; targeted test/hybrid_quiz_generation_test.dart and native study integration/UI tests. Baseline and final execution evidence are recorded in the implementation report. Standard CI builds Android/web and packaged Windows. This checkout needs Flutter and generated licensed Anatomy/audio assets, as installed by existing workflows. Host LAN interface failures (Bad value for ai_flags) are known from earlier work and must be reported separately rather than hidden.
