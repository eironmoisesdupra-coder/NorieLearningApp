-- Run as the database administrator after deploying the additive migration.
-- This is rollback-only and creates no Auth users, emails, learner-state rows,
-- eligibility, memberships, scores, cohorts or personal records.
-- Full receipt/cap/tie fixtures are isolated in scripts/verify_league_database.mjs.
begin;

do $$
declare item record; table_count integer; policy_count integer;
begin
  select count(*) into table_count from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname in ('league_eligibility','league_seasons',
      'league_cohorts','league_memberships','league_join_requests','league_attempts',
      'league_receipts','league_badges','league_reports') and c.relkind = 'r';
  if table_count <> 9 then raise exception 'Expected nine league tables, found %',table_count; end if;
  for item in select c.relname, c.relrowsecurity from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname like 'league_%' and c.relkind = 'r'
  loop
    if not item.relrowsecurity then raise exception 'RLS missing on %',item.relname; end if;
    if has_table_privilege('anon','public.' || item.relname,'SELECT,INSERT,UPDATE,DELETE') then
      raise exception 'Anon table grant exposed on %',item.relname;
    end if;
    if has_table_privilege('authenticated','public.' || item.relname,'INSERT,UPDATE,DELETE') then
      raise exception 'Authenticated writes exposed on %',item.relname;
    end if;
  end loop;
  select count(*) into policy_count from pg_catalog.pg_policies
    where schemaname = 'public' and tablename like 'league_%'
      and cmd = 'SELECT' and qual like '%auth.uid()%user_id%';
  if policy_count <> 6 then raise exception 'Expected six owner-filtered select policies, found %',policy_count; end if;
  select count(*) into policy_count from pg_catalog.pg_policies
    where schemaname = 'public' and tablename in ('league_cohorts','league_seasons','league_reports')
      and cmd = 'ALL' and permissive = 'RESTRICTIVE' and qual = 'false' and with_check = 'false'
      and roles @> array['anon','authenticated']::name[];
  if policy_count <> 3 then raise exception 'Expected three explicit restrictive client-deny policies, found %',policy_count; end if;
  if exists (
    select 1 from pg_catalog.pg_constraint fk
    join pg_catalog.pg_class c on c.oid = fk.conrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where fk.contype = 'f' and n.nspname = 'public' and c.relname like 'league_%'
      and not exists (select 1 from pg_catalog.pg_index idx where idx.indrelid = fk.conrelid
        and idx.indisvalid and idx.indpred is null and idx.indkey[0] = fk.conkey[1])
  ) then raise exception 'League foreign key missing a full leading index'; end if;
  if position('(''Pathfinder'',20)' in pg_get_functiondef('public.league_finish_verified(uuid,uuid,text,text,integer)'::regprocedure)) = 0
    or position('(''Scholar'',30)' in pg_get_functiondef('public.league_finish_verified(uuid,uuid,text,text,integer)'::regprocedure)) = 0
    or position('(''Specialist'',40)' in pg_get_functiondef('public.league_finish_verified(uuid,uuid,text,text,integer)'::regprocedure)) = 0
    or position('(''Master'',60)' in pg_get_functiondef('public.league_finish_verified(uuid,uuid,text,text,integer)'::regprocedure)) = 0 then
    raise exception 'Private cohort tier calibration is not applied';
  end if;
  for item in select p.oid,p.proname,p.prosecdef,p.proconfig
    from pg_catalog.pg_proc p join pg_catalog.pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public' and p.proname in ('league_finish_verified','league_delete_display','league_board_rows')
  loop
    if item.prosecdef then raise exception 'Unexpected SECURITY DEFINER: %',item.proname; end if;
    if not exists (select 1 from unnest(item.proconfig) setting where setting like 'search_path=%') then
      raise exception 'Explicit search path missing: %',item.proname;
    end if;
    if has_function_privilege('anon',item.oid,'EXECUTE') or has_function_privilege('authenticated',item.oid,'EXECUTE') then
      raise exception 'Privileged RPC exposed: %',item.proname;
    end if;
    if not has_function_privilege('service_role',item.oid,'EXECUTE') then
      raise exception 'Server RPC grant missing: %',item.proname;
    end if;
  end loop;
end $$;

set local role authenticated;
-- Random nonexistent owner; never impersonates a real account or reads its data.
select set_config('request.jwt.claim.sub',gen_random_uuid()::text,true);
do $$
begin
  if exists (select 1 from public.league_memberships)
    or exists (select 1 from public.league_eligibility)
    or exists (select 1 from public.league_attempts)
    or exists (select 1 from public.league_receipts)
    or exists (select 1 from public.league_badges)
    or exists (select 1 from public.league_join_requests) then
    raise exception 'RLS disclosed rows to nonexistent owner';
  end if;
  begin
    update public.league_memberships set opted_in = true where false;
    raise exception 'Authenticated membership write unexpectedly allowed';
  exception when insufficient_privilege then null; end;
  begin
    delete from public.league_receipts where false;
    raise exception 'Authenticated score delete unexpectedly allowed';
  exception when insufficient_privilege then null; end;
  begin
    perform public.league_finish_verified(gen_random_uuid(),gen_random_uuid(),'fixture','fixture',5);
    raise exception 'Authenticated receipt RPC unexpectedly allowed';
  exception when insufficient_privilege then null; end;
  begin
    perform public.league_board_rows(gen_random_uuid(),gen_random_uuid());
    raise exception 'Authenticated board RPC unexpectedly allowed';
  exception when insufficient_privilege then null; end;
  begin
    perform public.league_delete_display(gen_random_uuid());
    raise exception 'Authenticated privileged cleanup RPC unexpectedly allowed';
  exception when insufficient_privilege then null; end;
end $$;

reset role;
set local role anon;
do $$
begin
  begin
    perform 1 from public.league_receipts limit 1;
    raise exception 'Anon score read unexpectedly allowed';
  exception when insufficient_privilege then null; end;
  begin
    perform public.league_delete_display(gen_random_uuid());
    raise exception 'Anon privileged RPC unexpectedly allowed';
  exception when insufficient_privilege then null; end;
end $$;

reset role;
set local role service_role;
do $$
declare result jsonb;
begin
  result := public.league_board_rows(gen_random_uuid(),gen_random_uuid());
  if result <> '[]'::jsonb then raise exception 'Unknown private cohort disclosed a board'; end if;
  begin
    perform public.league_finish_verified(gen_random_uuid(),gen_random_uuid(),'fixture','fixture',5);
    raise exception 'Unknown proof unexpectedly produced a receipt';
  exception when raise_exception then
    if sqlerrm <> 'invalid_attempt' then raise; end if;
  end;
end $$;
reset role;
select 'passed: nine RLS tables, owner-filtered reads, client write/RPC denial, unknown private cohort/proof denial; no personal fixtures' as verification;
rollback;
