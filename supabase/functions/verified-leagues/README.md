# Private verified subject leagues

This implementation has **no public discovery or public child leaderboard**.
It is separate from lifetime XP and normal offline lesson completion. The app
offers local personal bests even when Supabase is not configured. This function
and migration were deployed by the parent integrator on 2026-10-08 to the Norie
Supabase project (`lafuuwoohizgwnrbbgqj`), with Edge Function revision **v3**
and content identity `authored-9f41785c`.
Live rollback-only schema/RLS/RPC verification passed, unauthenticated POST
returned 401, and OPTIONS returned 200. There are **zero cohorts, eligibility
records or scores**: no accounts/classes were provisioned. Full authenticated
ranked-attempt integration remains unverified, and competition is inactive until
trusted administrators approve eligibility and private groups.

## Admission and display

Every non-cleanup request validates the bearer with `auth.getUser`, denies
anonymous accounts, requires the existing `demo_access` allowlist, and reads
administrator-owned `league_eligibility`. Adult or guardian approval must be
recorded there; user-editable metadata is never an authorization source.
Joining by invitation only creates a request. An administrator must approve a
membership, and the learner must separately opt in before being displayed or
opening ranked practice. There is no automatic classroom enrollment.

Each cohort has one subject, grade and season. All current ranked content is
authored Science, Mathematics and English: 234 lessons in 39 subject-grade/course
cohorts, with six eligible opportunities per cohort. These boards compare only
their own subject and grade; there is no combined cross-subject ranking.
Display rows
contain a random membership ID, assigned `Learner xxxxxx` nickname, verified
points and an optional owned league emblem. No account IDs, email, exact age,
school identifier, weaknesses, or personal contact details are returned.

Leave and display deletion remain available even after eligibility revocation.
They hide the display and stop membership participation. Historical private
receipts and permanent cosmetic emblems remain for integrity and ownership.
Deleting the underlying Auth user cascades attempts, score receipts, emblems,
memberships and reports; actual account deletion belongs to the account service.
Reports target an existing opted-in member of the same approved cohort and are
visible only to the administrator. Review and resolve them before approving
further classroom use. Nickname editing and public profile search are absent.

## Score/proof rules

* `open` chooses five distinct questions from the deployed authoritative bank.
  It stores their IDs, owner, cohort, season, content version and expiry and
  returns an HMAC nonce plus prompts/options. Answer keys stay in the server
  manifest. A copied or changed owner/version/expiry does not validate.
* `finish` accepts only an attempt ID, signed nonce and question-to-option-index
  answers. It never accepts client XP, points, correctness, or a question bank.
  Exact coverage and valid integer indices are required. The server compares
  selections with its own deployed bank.
* At least four of five correct earns 10 points once per lesson per cohort
  season, with a 200-point cap. Failed attempts can be retried, but repeated
  successful lessons cannot farm points. No speed or AI-usage rewards exist.
* The original server-issued proof expires in 30 minutes or at season close,
  whichever is earlier. Newly opened offline lessons have no ranked proof and
  receive no league credit. A pending request is provisional; it can be retried
  with its original proof until expiry. A confirmed receipt can be returned
  idempotently after expiry/season close without awarding again.
* PostgreSQL locks and a unique eligible-event index serialize receipt issuance,
  caps and permanent emblem receipts across retries/devices. Season rules are
  rechecked with database time; the client clock cannot award points.
* Ties share competition ranks (1, 1, 3). The UI shows the learner's nearby ranks.
  Explorer starts at 0 points; Pathfinder/Scholar/Specialist/Master start at
  20/30/40/60. The first verified pass earns the Explorer cosmetic emblem.
  Each current subject-grade cohort has six eligible authored lessons, so all
  five tiers are attainable with the same 10-point first-pass rule. The 200-point
  cap remains an upper bound for future content, not the current attainable
  total. Review cohort opportunities and calibration before changing the bank;
  there is no automatic points multiplier or claim of fairness across subjects.
  Higher emblems are durable server receipts and can be equipped on a private
  display. These perks do not change lessons, assessment access, XP or currency.

## Provisioning and deployment

1. Review and apply migration `20261008080710_private_verified_leagues.sql` to a
   staging project first. The migration gives authenticated clients only
   owner-filtered reads. All table writes and all privileged RPC execution are
   denied to `anon`/`authenticated`; the Edge Function uses server-only service
   credentials. All exposed tables have RLS, and RPCs use SECURITY INVOKER with
   an empty search path and explicit service-only grants.
   Apply follow-up `20261008083122_league_privacy_indexes.sql` as well: it adds
   explicit restrictive false policies to server-only cohorts/seasons/reports
   and twelve missing FK-leading indexes without duplicating existing coverage.
   The original six owner-filtered read policies remain unchanged. This follow-up
   has been applied and verified live by the parent integrator.
   Apply `20261008084853_league_tier_calibration.sql` to calibrate emblems to
   current six-lesson private cohorts. It replaces only the scoring function's
   cosmetic thresholds, preserving service grants, search path, receipt rules
   and the existing point cap. All three migrations have been applied and
   verified live by the parent integrator. The final regenerated three-subject bank
   is deployed with Edge Function v3; no active cohorts are
   pinned to an earlier bank, and no learner eligibility has been provisioned.
2. Regenerate the reviewed bank from repository root:
   `dart run scripts/export_ranked_bank.dart`. This imports authored curriculum
   directly. Do not replace it with client uploads. Commit and deploy the bank
   together with the function. Seasons must use its exact `version` value.
   An existing season rejects new proofs if a mismatched bank is deployed;
   coordinate version transitions at a season boundary.
3. A dedicated random `LEAGUE_NONCE_SECRET` of at least 32 characters is optional
   and preferred for independent rotation. Otherwise the function derives its
   HMAC secret as SHA-256 of `norie-league-nonce:v1:` plus Supabase's automatic
   server-only `SUPABASE_SERVICE_ROLE_KEY`. Domain separation avoids using the
   service credential directly as a signing key. Supabase also supplies
   `SUPABASE_URL`. Neither the source key nor derived secret is logged, returned,
   included in cache, or added to Flutter defines. A provided short override
   fails closed. Rotating either the dedicated secret or the source service key
   invalidates unsubmitted proofs, whose lifetime is at most 30 minutes;
   coordinate a maintenance boundary rather than promising late credit.
4. Use the Supabase CLI's current `functions deploy --help` and deploy
   `verified-leagues` with its `deno.json` and manifest. Keep JWT verification
   enabled and keep the explicit `getUser` check. No remote secrets were modified
   during implementation.
5. Trusted administrators provision `league_eligibility`, `league_seasons` and
   `league_cohorts`. Supply explicit UTC season start/end, subject `science`,
   grade `g1`…`g12`/`college`, and exact bank version. Store only the SHA-256 hex
   hash of a high-entropy invitation token in `invite_hash`. Share the plaintext
   privately; do not put it in source control or a public screen. Invitation
   requests should be checked against adult/guardian approval and class roster
   before adding/updating `league_memberships.approved_at`. Use a generated
   `Learner [a-z0-9]{6}` alias and leave `opted_in` false for the learner's choice.
6. Run database advisors and authenticated staging tests with two separate
   accounts/cohorts before activation. Verify the Data API exposure and explicit
   grants for your project; new tables are not universally auto-exposed.

Audience approval remains pending. Provision only private invitation groups;
public discovery requires a separate product/eligibility/moderation review.
No live leaderboard availability is implied by applying app UI changes.

## APIs

`POST verified-leagues` takes an `action`: `boards`, `badges`, `lessons`, `open`,
`finish`, `opt_in`, `join_request`, `equip_badge`, `report`, `leave`, or
`delete_display`. The Dart boundary is `NorieLeagueService.call`/`boards`/`badges`;
navigation uses `NorieLeaderboardsScreen()`. A pending proof and timestamped board
and emblem caches are isolated by account ID. Guests have no remote enrollment.
Account changes hide previous rows immediately and discard stale async responses.

## Validation

* `node --test test/verified_leagues_test.mjs`: authoritative answer/index/expiry
  checks, ties, caps, static RLS/RPC assertions, auth boundaries and actual bank.
* `flutter test test/norie_leagues_test.dart`: owner-isolated caches, durable
  emblem cache, ties/nearby positions and guest UI at 320 pixels/2× text.
* `npx deno check --config supabase/functions/verified-leagues/deno.json supabase/functions/verified-leagues/index.ts`
* For real PostgreSQL WASM validation, install pinned `@electric-sql/pglite@0.3.14`
  outside the repository and run
  `node scripts/verify_league_database.mjs <pglite/dist/index.js>`.
  It executes the migration and asserts actual role denial/RLS, cross-cohort
  isolation, edited proof rejection, replay/expiry/season close, first-pass caps,
  permanent emblems, cleanup and account-deletion cascades.

Local Docker/Supabase was unavailable during implementation. A connected remote
project was subsequently discovered and the initial migration/function deployed
by the parent integrator; limited live verification results are recorded above.
PostgreSQL WASM validation
does not replace HTTP/function integration, production advisor checks or
real-account verification. `supabase/tests/private_verified_leagues_live.sql`
provides rollback-only schema/grant/RPC checks without adding Auth users or
reading/modifying learner records.

Current official references checked during implementation:
[RLS and grants](https://supabase.com/docs/guides/database/postgres/row-level-security),
[Edge authentication](https://supabase.com/docs/guides/functions/auth),
[new table exposure change](https://supabase.com/changelog/45329-breaking-change-tables-not-exposed-to-data-and-graphql-api-automatically),
[PostgreSQL security release](https://supabase.com/changelog/postgres-15-19-17-11-breaking-changes).
