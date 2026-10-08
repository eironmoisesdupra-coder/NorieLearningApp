-- Invite-only subject/grade competition. Every client write is denied; the
-- verified-leagues Edge Function authenticates users and verifies bank answers.
-- Administrator provisioning is required. Nothing here creates public boards.
create table public.league_eligibility (
  user_id uuid primary key references auth.users(id) on delete cascade,
  adult_or_guardian_approved boolean not null default false,
  approved_at timestamptz,
  revoked_at timestamptz
);
create table public.league_seasons (
  id uuid primary key default gen_random_uuid(),
  starts_at timestamptz not null, ends_at timestamptz not null,
  bank_version text not null,
  constraint league_season_range check (ends_at > starts_at)
);
create table public.league_cohorts (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 60),
  subject text not null check (subject = 'science'),
  grade text not null check (grade in ('g1','g2','g3','g4','g5','g6','g7','g8','g9','g10','g11','g12','college')),
  season_id uuid not null references public.league_seasons(id),
  invite_hash text not null unique,
  closed boolean not null default false
);
create table public.league_memberships (
  id uuid primary key default gen_random_uuid(),
  cohort_id uuid not null references public.league_cohorts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  nickname text not null check (nickname ~ '^Learner [a-z0-9]{6}$'),
  opted_in boolean not null default false,
  approved_at timestamptz,
  left_at timestamptz,
  unique(cohort_id,user_id)
);
create table public.league_join_requests (
  user_id uuid not null references auth.users(id) on delete cascade,
  cohort_id uuid not null references public.league_cohorts(id) on delete cascade,
  requested_at timestamptz not null default now(),
  primary key(user_id,cohort_id)
);
create table public.league_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cohort_id uuid not null references public.league_cohorts(id),
  season_id uuid not null references public.league_seasons(id),
  lesson_id text not null, bank_version text not null,
  question_ids jsonb not null check (jsonb_array_length(question_ids) = 5),
  nonce_hash text not null,
  opened_at timestamptz not null default now(),
  expires_at timestamptz not null,
  submitted_at timestamptz
);
create index league_attempts_owner on public.league_attempts(user_id,cohort_id,opened_at);
create table public.league_receipts (
  attempt_id uuid primary key references public.league_attempts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  cohort_id uuid not null references public.league_cohorts(id),
  season_id uuid not null references public.league_seasons(id),
  lesson_id text not null, bank_version text not null,
  correct integer not null check (correct between 0 and 5),
  total integer not null default 5 check (total = 5),
  points integer not null check (points in (0,10)),
  reason text not null, verified_at timestamptz not null default now()
);
create unique index league_once_per_lesson on public.league_receipts(user_id,cohort_id,season_id,lesson_id) where points > 0;
create index league_standings on public.league_receipts(cohort_id,season_id,user_id);
-- Permanent cosmetic receipts: season rollover, opt-out and leaving a cohort
-- preserve these. No academic benefits, currency or lifetime XP are awarded.
create table public.league_badges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cohort_id uuid not null references public.league_cohorts(id),
  season_id uuid not null references public.league_seasons(id),
  tier text not null check (tier in ('Explorer','Pathfinder','Scholar','Specialist','Master')),
  title text not null,
  earned_at timestamptz not null default now(),
  unique(user_id,cohort_id,season_id,tier)
);
alter table public.league_memberships add column equipped_badge_id uuid references public.league_badges(id) on delete set null;
create table public.league_reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references auth.users(id) on delete cascade,
  cohort_id uuid not null references public.league_cohorts(id),
  member_id uuid not null references public.league_memberships(id) on delete cascade,
  created_at timestamptz not null default now(),
  resolved_at timestamptz,
  unique(reporter_id,cohort_id,member_id)
);

alter table public.league_eligibility enable row level security;
alter table public.league_seasons enable row level security;
alter table public.league_cohorts enable row level security;
alter table public.league_memberships enable row level security;
alter table public.league_join_requests enable row level security;
alter table public.league_attempts enable row level security;
alter table public.league_receipts enable row level security;
alter table public.league_badges enable row level security;
alter table public.league_reports enable row level security;
revoke all on public.league_eligibility, public.league_seasons, public.league_cohorts,
  public.league_memberships, public.league_join_requests, public.league_attempts,
  public.league_receipts, public.league_badges, public.league_reports from anon, authenticated;
grant select on public.league_eligibility, public.league_memberships,
  public.league_join_requests, public.league_attempts, public.league_receipts, public.league_badges to authenticated;
grant all on public.league_eligibility, public.league_seasons, public.league_cohorts,
  public.league_memberships, public.league_join_requests, public.league_attempts,
  public.league_receipts, public.league_badges, public.league_reports to service_role;
create policy league_eligibility_self on public.league_eligibility for select to authenticated using ((select auth.uid()) = user_id);
create policy league_membership_self on public.league_memberships for select to authenticated using ((select auth.uid()) = user_id);
create policy league_requests_self on public.league_join_requests for select to authenticated using ((select auth.uid()) = user_id);
create policy league_attempts_self on public.league_attempts for select to authenticated using ((select auth.uid()) = user_id);
create policy league_receipts_self on public.league_receipts for select to authenticated using ((select auth.uid()) = user_id);
create policy league_badges_self on public.league_badges for select to authenticated using ((select auth.uid()) = user_id);

-- SECURITY INVOKER: only service_role has execute/table grants. Serialize all
-- finishes for one member+cohort+season before checking the first-pass/cap rules.
create function public.league_finish_verified(p_attempt uuid, p_user uuid,
  p_nonce_hash text, p_bank_version text, p_correct integer)
returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  a public.league_attempts%rowtype;
  prior public.league_receipts%rowtype;
  award integer := 0;
  why text := 'Practice recorded; independent pass requires 4 of 5 correct.';
  season_points integer;
begin
  select * into a from public.league_attempts where id = p_attempt and user_id = p_user for update;
  if not found or a.nonce_hash <> p_nonce_hash or a.bank_version <> p_bank_version then
    raise exception 'invalid_attempt';
  end if;
  select * into prior from public.league_receipts where attempt_id = a.id;
  if found then return to_jsonb(prior); end if;
  if p_correct < 0 or p_correct > 5 then raise exception 'invalid_answers'; end if;
  if a.submitted_at is not null or now() >= a.expires_at then raise exception 'expired_attempt'; end if;
  if not exists (select 1 from public.league_seasons s join public.league_cohorts c on c.season_id = s.id
    where s.id = a.season_id and c.id = a.cohort_id and not c.closed
      and s.bank_version = a.bank_version and now() >= s.starts_at and now() < s.ends_at) then
    raise exception 'season_closed';
  end if;
  if not exists (select 1 from public.league_memberships m join public.league_eligibility e on e.user_id = m.user_id
    where m.user_id = p_user and m.cohort_id = a.cohort_id and m.opted_in and m.approved_at is not null
      and m.left_at is null and e.adult_or_guardian_approved and e.approved_at is not null and e.revoked_at is null) then
    raise exception 'not_eligible';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(p_user::text || a.cohort_id::text || a.season_id::text, 0));
  if p_correct >= 4 then
    if exists (select 1 from public.league_receipts where user_id = p_user and cohort_id = a.cohort_id
      and season_id = a.season_id and lesson_id = a.lesson_id and points > 0) then
      why := 'This lesson already earned its season points.';
    elsif (select coalesce(sum(points),0) from public.league_receipts where user_id = p_user
      and cohort_id = a.cohort_id and season_id = a.season_id) >= 200 then
      why := 'The 200 point season cap has been reached.';
    else award := 10; why := 'First independent lesson pass this season.';
    end if;
  end if;
  insert into public.league_receipts(attempt_id,user_id,cohort_id,season_id,lesson_id,bank_version,correct,points,reason)
    values(a.id,p_user,a.cohort_id,a.season_id,a.lesson_id,a.bank_version,p_correct,award,why)
    returning * into prior;
  update public.league_attempts set submitted_at = now() where id = a.id;
  if award > 0 then
    select coalesce(sum(points),0) into season_points from public.league_receipts
      where user_id = p_user and cohort_id = a.cohort_id and season_id = a.season_id;
    insert into public.league_badges(user_id,cohort_id,season_id,tier,title)
      select p_user,a.cohort_id,a.season_id,tiers.name,tiers.name || ' league emblem'
      from (values ('Explorer',10),('Pathfinder',50),('Scholar',100),('Specialist',150),('Master',200)) tiers(name,threshold)
      where season_points >= tiers.threshold
      on conflict(user_id,cohort_id,season_id,tier) do nothing;
  end if;
  return to_jsonb(prior);
end $$;
revoke all on function public.league_finish_verified(uuid,uuid,text,text,integer) from public, anon, authenticated;
grant execute on function public.league_finish_verified(uuid,uuid,text,text,integer) to service_role;

-- Removes display AND participation, including join requests. Historical private
-- receipts remain for idempotency; account deletion cascades personal rows.
create function public.league_delete_display(p_user uuid)
returns void language sql security invoker set search_path = '' as $$
  update public.league_memberships set opted_in = false, left_at = now() where user_id = p_user;
  delete from public.league_join_requests where user_id = p_user;
$$;
revoke all on function public.league_delete_display(uuid) from public, anon, authenticated;
grant execute on function public.league_delete_display(uuid) to service_role;

create function public.league_board_rows(p_cohort uuid, p_viewer uuid)
returns jsonb language sql stable security invoker set search_path = '' as $$
  select coalesce(jsonb_agg(to_jsonb(board) order by board.points desc, board.member_id), '[]'::jsonb)
  from (
    select m.id as member_id, m.nickname, m.user_id = p_viewer as is_me, badge.title as badge_title,
      coalesce(sum(r.points),0) as points
    from public.league_memberships m
    join public.league_cohorts c on c.id = m.cohort_id
    join public.league_eligibility e on e.user_id = m.user_id
    left join public.league_badges badge on badge.id = m.equipped_badge_id and badge.user_id = m.user_id
    left join public.league_receipts r on r.user_id = m.user_id and r.cohort_id = m.cohort_id and r.season_id = c.season_id
    where m.cohort_id = p_cohort and m.approved_at is not null and m.left_at is null and m.opted_in
      and e.adult_or_guardian_approved and e.approved_at is not null and e.revoked_at is null
      and exists (select 1 from public.league_memberships viewer where viewer.user_id = p_viewer
        and viewer.cohort_id = p_cohort and viewer.approved_at is not null and viewer.left_at is null)
    group by m.id, m.nickname, m.user_id, badge.title
  ) board;
$$;
revoke all on function public.league_board_rows(uuid,uuid) from public, anon, authenticated;
grant execute on function public.league_board_rows(uuid,uuid) to service_role;
