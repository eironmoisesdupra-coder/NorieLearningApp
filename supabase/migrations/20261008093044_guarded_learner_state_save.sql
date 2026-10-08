-- Compare-and-save for cooperating devices. Local progress is not a verified
-- competitive score; this only protects the private learner snapshot from loss.
create or replace function public.norie_save_learner_state_guarded(
  p_user_id uuid,
  p_state jsonb,
  p_modified timestamptz,
  p_expected_state jsonb
) returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_owner uuid := auth.uid();
  v_current jsonb;
begin
  -- Bind the client's captured owner to the actual request session. In
  -- particular, switching tokens between the local guard and RPC cannot save
  -- the previous learner's snapshot into the newly signed-in account.
  if v_owner is null or p_user_id is distinct from v_owner then
    raise exception 'learner_owner_mismatch' using errcode = '42501';
  end if;
  if not exists (
    select 1 from public.demo_access
    where email = lower(coalesce(auth.jwt() ->> 'email', ''))
  ) then
    raise exception 'demo_access_required' using errcode = '42501';
  end if;
  if p_state is null or jsonb_typeof(p_state) <> 'object'
     or p_modified is null
     or (p_expected_state is not null
         and jsonb_typeof(p_expected_state) <> 'object') then
    raise exception 'invalid_learner_snapshot' using errcode = '22023';
  end if;

  if p_expected_state is null then
    -- The unique owner index also serializes two devices creating their first
    -- snapshot. Only one insert can succeed; the other must read and merge.
    insert into public.learner_state(user_id, state, updated_at)
    values (v_owner, p_state, p_modified)
    on conflict (user_id) do nothing;
    if found then return true; end if;
  end if;

  select state into v_current from public.learner_state
  where user_id = v_owner for update;
  if not found or p_expected_state is null
     or v_current is distinct from p_expected_state then
    return false;
  end if;
  update public.learner_state set state = p_state, updated_at = p_modified
  where user_id = v_owner;
  return true;
end;
$$;

revoke all on function public.norie_save_learner_state_guarded(uuid,jsonb,timestamptz,jsonb)
  from public, anon;
grant execute on function public.norie_save_learner_state_guarded(uuid,jsonb,timestamptz,jsonb)
  to authenticated;
