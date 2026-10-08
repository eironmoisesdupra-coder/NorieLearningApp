-- Server-only league administration tables: retain revoked client grants and
-- make intentional denial explicit, including against future permissive rules.
create policy league_cohorts_server_only on public.league_cohorts
  as restrictive for all to anon, authenticated using (false) with check (false);
create policy league_seasons_server_only on public.league_seasons
  as restrictive for all to anon, authenticated using (false) with check (false);
create policy league_reports_server_only on public.league_reports
  as restrictive for all to anon, authenticated using (false) with check (false);

-- Cover remaining FK-leading lookups/cascades. Existing PK/unique/standings
-- indexes already cover other references; do not duplicate those indexes.
create index league_attempts_cohort_idx on public.league_attempts(cohort_id);
create index league_attempts_season_idx on public.league_attempts(season_id);
create index league_badges_cohort_idx on public.league_badges(cohort_id);
create index league_badges_season_idx on public.league_badges(season_id);
create index league_cohorts_season_idx on public.league_cohorts(season_id);
create index league_join_requests_cohort_idx on public.league_join_requests(cohort_id);
create index league_memberships_badge_idx on public.league_memberships(equipped_badge_id);
create index league_memberships_user_idx on public.league_memberships(user_id);
create index league_receipts_season_idx on public.league_receipts(season_id);
-- The first-pass unique index is partial, so it does not cover all user FK rows.
create index league_receipts_user_idx on public.league_receipts(user_id);
create index league_reports_cohort_idx on public.league_reports(cohort_id);
create index league_reports_member_idx on public.league_reports(member_id);
