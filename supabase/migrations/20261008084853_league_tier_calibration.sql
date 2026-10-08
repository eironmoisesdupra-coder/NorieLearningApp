-- Private Science cohorts currently contain six eligible authored lessons.
-- Ten first-pass points per lesson makes 60 points attainable. Calibrate only
-- cosmetic tier thresholds; preserve the independent-pass rules, 200-point cap,
-- idempotency, permanent receipts, SECURITY INVOKER and service-only grants.
create or replace function public.league_finish_verified(p_attempt uuid, p_user uuid,
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
      from (values ('Explorer',10),('Pathfinder',20),('Scholar',30),('Specialist',40),('Master',60)) tiers(name,threshold)
      where season_points >= tiers.threshold
      on conflict(user_id,cohort_id,season_id,tier) do nothing;
  end if;
  return to_jsonb(prior);
end $$;
revoke all on function public.league_finish_verified(uuid,uuid,text,text,integer) from public, anon, authenticated;
grant execute on function public.league_finish_verified(uuid,uuid,text,text,integer) to service_role;

