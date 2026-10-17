-- Public Data API endpoints use invoker rights. The narrow implementations
-- live in a non-exposed schema and perform their own owner/admission checks.
-- Table privileges remain revoked; schema USAGE does not grant table access.
alter function public.norie_economy_sync(uuid,text,jsonb,jsonb) set schema norie_economy_private;
alter function public.norie_economy_ack(uuid,text,text,text,bigint) set schema norie_economy_private;
alter function public.norie_economy_compact(uuid) set schema norie_economy_private;
alter function public.norie_economy_devices(uuid) set schema norie_economy_private;
alter function public.norie_economy_status(uuid) set schema norie_economy_private;
alter function public.norie_economy_retire_device(uuid,text) set schema norie_economy_private;

create function public.norie_economy_sync(p_user_id uuid,p_device_id text,p_baseline jsonb,p_operations jsonb)
returns jsonb language sql security invoker set search_path='' as $$
 select norie_economy_private.norie_economy_sync(p_user_id,p_device_id,p_baseline,p_operations)
$$;
create function public.norie_economy_ack(p_user_id uuid,p_device_id text,p_epoch text,p_checkpoint_id text,p_through_seq bigint)
returns boolean language sql security invoker set search_path='' as $$
 select norie_economy_private.norie_economy_ack(p_user_id,p_device_id,p_epoch,p_checkpoint_id,p_through_seq)
$$;
create function public.norie_economy_compact(p_user_id uuid)
returns jsonb language sql security invoker set search_path='' as $$
 select norie_economy_private.norie_economy_compact(p_user_id)
$$;
create function public.norie_economy_devices(p_user_id uuid)
returns jsonb language sql security invoker set search_path='' as $$
 select norie_economy_private.norie_economy_devices(p_user_id)
$$;
create function public.norie_economy_status(p_user_id uuid)
returns jsonb language sql security invoker set search_path='' as $$
 select norie_economy_private.norie_economy_status(p_user_id)
$$;
create function public.norie_economy_retire_device(p_user_id uuid,p_device_id text)
returns boolean language sql security invoker set search_path='' as $$
 select norie_economy_private.norie_economy_retire_device(p_user_id,p_device_id)
$$;

revoke all on function public.norie_economy_sync(uuid,text,jsonb,jsonb),public.norie_economy_ack(uuid,text,text,text,bigint),public.norie_economy_compact(uuid),public.norie_economy_devices(uuid),public.norie_economy_status(uuid),public.norie_economy_retire_device(uuid,text) from public,anon;
grant execute on function public.norie_economy_sync(uuid,text,jsonb,jsonb),public.norie_economy_ack(uuid,text,text,text,bigint),public.norie_economy_compact(uuid),public.norie_economy_devices(uuid),public.norie_economy_status(uuid),public.norie_economy_retire_device(uuid,text) to authenticated;
grant usage on schema norie_economy_private to authenticated;
revoke all on all tables in schema norie_economy_private from public,anon,authenticated;
revoke all on all functions in schema norie_economy_private from public,anon,authenticated;
grant execute on function norie_economy_private.norie_economy_sync(uuid,text,jsonb,jsonb),norie_economy_private.norie_economy_ack(uuid,text,text,text,bigint),norie_economy_private.norie_economy_compact(uuid),norie_economy_private.norie_economy_devices(uuid),norie_economy_private.norie_economy_status(uuid),norie_economy_private.norie_economy_retire_device(uuid,text) to authenticated;

-- Explicit restrictive denial documents the default-deny boundary and remains
-- effective if a future permissive policy is accidentally introduced. The
-- guarded definer implementations run as the table owner and bypass RLS.
create policy economy_accounts_deny_clients on norie_economy_private.accounts as restrictive for all to authenticated using(false) with check(false);
create policy economy_devices_deny_clients on norie_economy_private.devices as restrictive for all to authenticated using(false) with check(false);
create policy economy_claims_deny_clients on norie_economy_private.claims as restrictive for all to authenticated using(false) with check(false);
create policy economy_receipts_deny_clients on norie_economy_private.receipts as restrictive for all to authenticated using(false) with check(false);
create policy economy_operations_deny_clients on norie_economy_private.operations as restrictive for all to authenticated using(false) with check(false);
create policy economy_reservations_deny_clients on norie_economy_private.reservations as restrictive for all to authenticated using(false) with check(false);
