-- New clients store extensions separately so strict schema-1 clients continue
-- to read learner_state. Both halves use one atomic compare-and-save RPC.
create table public.learner_feature_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint learner_feature_state_shape check (
    jsonb_typeof(state) = 'object'
    and state - array['sync_event_journal','classroom_state','seasonal_state']::text[] = '{}'::jsonb
    and octet_length(state::text) <= 4194304
  )
);
alter table public.learner_feature_state enable row level security;
create policy learner_features_owner on public.learner_feature_state
  for all to authenticated
  using ((select auth.uid()) = user_id and exists (
    select 1 from public.demo_access
    where email = lower(coalesce(auth.jwt() ->> 'email',''))
  ))
  with check ((select auth.uid()) = user_id and exists (
    select 1 from public.demo_access
    where email = lower(coalesce(auth.jwt() ->> 'email',''))
  ));
revoke all on public.learner_feature_state from public, anon;
grant select, insert, update, delete on public.learner_feature_state to authenticated;

create function public.norie_get_learner_bundle(p_user_id uuid) returns jsonb
language plpgsql stable security invoker set search_path = '' as $$
declare v_result jsonb;
begin
  if auth.uid() is null or p_user_id is distinct from auth.uid() then
    raise exception 'learner_owner_mismatch' using errcode='42501';
  end if;
  if not exists (select 1 from public.demo_access
    where email=lower(coalesce(auth.jwt()->>'email',''))) then
    raise exception 'demo_access_required' using errcode='42501';
  end if;
  select jsonb_build_object('state',c.state || coalesce(f.state,'{}'::jsonb),
    'updated_at',greatest(c.updated_at,f.updated_at)) into v_result
  from public.learner_state c left join public.learner_feature_state f using(user_id)
  where c.user_id=p_user_id;
  return v_result;
end;
$$;

create function public.norie_save_learner_bundle_guarded(
  p_user_id uuid, p_state jsonb, p_modified timestamptz, p_expected_state jsonb
) returns boolean language plpgsql security invoker set search_path='' as $$
declare
  v_keys constant text[] := array['sync_event_journal','classroom_state','seasonal_state'];
  v_features jsonb; v_expected_features jsonb; v_current_features jsonb;
begin
  if auth.uid() is null or p_user_id is distinct from auth.uid() then
    raise exception 'learner_owner_mismatch' using errcode='42501';
  end if;
  if not exists (select 1 from public.demo_access
    where email=lower(coalesce(auth.jwt()->>'email',''))) then
    raise exception 'demo_access_required' using errcode='42501';
  end if;
  if p_state is null or jsonb_typeof(p_state)<>'object' or p_modified is null
    or octet_length(p_state::text)>5242880
    or (p_expected_state is not null and jsonb_typeof(p_expected_state)<>'object') then
    raise exception 'invalid_learner_bundle' using errcode='22023';
  end if;
  select coalesce(jsonb_object_agg(key,value),'{}'::jsonb) into v_features
    from jsonb_each(p_state) where key=any(v_keys);
  select coalesce(jsonb_object_agg(key,value),'{}'::jsonb) into v_expected_features
    from jsonb_each(coalesce(p_expected_state,'{}'::jsonb)) where key=any(v_keys);
  -- This exception block is a subtransaction. A stale extension comparison
  -- must roll back the core CAS too, including a first-row insertion.
  begin
    if not public.norie_save_learner_state_guarded(p_user_id,p_state-v_keys,
      p_modified,p_expected_state-v_keys) then return false; end if;
    select state into v_current_features from public.learner_feature_state
      where user_id=p_user_id for update;
    if coalesce(v_current_features,'{}'::jsonb) is distinct from v_expected_features then
      raise exception 'learner_bundle_conflict' using errcode='40001';
    end if;
    insert into public.learner_feature_state(user_id,state,updated_at)
      values(p_user_id,v_features,p_modified)
      on conflict(user_id) do update set state=excluded.state, updated_at=excluded.updated_at;
    return true;
  exception when serialization_failure then return false;
  end;
end;
$$;
revoke all on function public.norie_get_learner_bundle(uuid) from public,anon;
revoke all on function public.norie_save_learner_bundle_guarded(uuid,jsonb,timestamptz,jsonb) from public,anon;
grant execute on function public.norie_get_learner_bundle(uuid) to authenticated;
grant execute on function public.norie_save_learner_bundle_guarded(uuid,jsonb,timestamptz,jsonb) to authenticated;
