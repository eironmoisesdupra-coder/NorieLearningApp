-- Private additive ledger. Legacy snapshots remain readable schema-1 mirrors.
create schema if not exists norie_economy_private;
revoke all on schema norie_economy_private from public, anon, authenticated;
create table norie_economy_private.accounts (
 user_id uuid primary key references auth.users(id) on delete cascade,
 epoch uuid not null default gen_random_uuid(), seq bigint not null default 0,
 total_xp bigint not null check(total_xp between 0 and 1000000000),
 credits bigint not null check(credits between 0 and 1000000000),
 owned jsonb not null default '[]', shields bigint not null check(shields between 0 and 1000000000)
);
create table norie_economy_private.devices (
 user_id uuid references norie_economy_private.accounts on delete cascade,
 device_id text not null check(length(device_id) between 1 and 128),
 device_seq bigint not null default 0, ack_seq bigint not null default -1,
 retired boolean not null default false, primary key(user_id,device_id)
);
create table norie_economy_private.claims (
 user_id uuid references norie_economy_private.accounts on delete cascade,
 claim_key text not null check(length(claim_key) between 1 and 1024), primary key(user_id,claim_key)
);
-- Compact detail, never the small id/digest/outcome receipt: retries remain exact.
create table norie_economy_private.receipts (
 user_id uuid references norie_economy_private.accounts on delete cascade,
 id text not null, digest text not null, reason text, seq bigint not null,
 primary key(user_id,id)
);
create table norie_economy_private.operations (
 user_id uuid not null, id text not null, operation jsonb not null,
 primary key(user_id,id), foreign key(user_id,id) references norie_economy_private.receipts on delete cascade
);
create table norie_economy_private.reservations (
 user_id uuid not null, device_id text not null, id uuid not null default gen_random_uuid(),
 credit_limit bigint not null default 0, spent bigint not null default 0,
 shield_limit bigint not null default 0, shields_spent bigint not null default 0,
 expires_at timestamptz not null, revoked boolean not null default false,
 primary key(user_id,id), foreign key(user_id,device_id) references norie_economy_private.devices on delete cascade,
 check(spent between 0 and credit_limit),check(shields_spent between 0 and shield_limit)
);
create index economy_reservations_device on norie_economy_private.reservations(user_id,device_id);
alter table norie_economy_private.accounts enable row level security;
alter table norie_economy_private.devices enable row level security;
alter table norie_economy_private.claims enable row level security;
alter table norie_economy_private.receipts enable row level security;
alter table norie_economy_private.operations enable row level security;
alter table norie_economy_private.reservations enable row level security;
revoke all on all tables in schema norie_economy_private from public,anon,authenticated;

create function norie_economy_private.authorize(p_user_id uuid) returns void
language plpgsql set search_path='' as $$ begin
 if auth.uid() is null or auth.uid() is distinct from p_user_id then
  raise exception 'learner_owner_mismatch' using errcode='42501'; end if;
 if not exists(select 1 from public.demo_access where email=lower(coalesce(auth.jwt()->>'email',''))) then
  raise exception 'demo_access_required' using errcode='42501'; end if;
end $$;

create function norie_economy_private.checkpoint(p_user_id uuid) returns jsonb
language sql set search_path='' as $$
 select jsonb_build_object('epoch',a.epoch,'through_seq',a.seq,'id',a.epoch::text||':'||a.seq,
 'total_xp',a.total_xp,'credits',a.credits,'owned_shop_items',a.owned,'streak_shields',a.shields,
 'claim_keys',coalesce((select jsonb_agg(claim_key order by claim_key) from norie_economy_private.claims where user_id=a.user_id),'[]'),
 'device_sequences',coalesce((select jsonb_object_agg(device_id,device_seq) from norie_economy_private.devices where user_id=a.user_id),'{}'))
 from norie_economy_private.accounts a where a.user_id=p_user_id
$$;

create function norie_economy_private.legacy_mirror() returns trigger
language plpgsql security definer set search_path='' as $$
declare a norie_economy_private.accounts;
begin
 select * into a from norie_economy_private.accounts where user_id=new.user_id for update;
 new.state := new.state-'economy_state';
 if found then
  new.state := new.state || jsonb_build_object('total_xp',a.total_xp,'credits',a.credits,
    'owned_shop_items',a.owned,'streak_shields',a.shields);
 end if;
 return new;
end $$;
create trigger norie_economy_legacy_mirror before insert or update on public.learner_state
for each row execute function norie_economy_private.legacy_mirror();

create function public.norie_economy_sync(p_user_id uuid,p_device_id text,p_baseline jsonb,p_operations jsonb)
returns jsonb language plpgsql security definer set search_path='' as $$
declare
 a norie_economy_private.accounts; d norie_economy_private.devices;
 r norie_economy_private.reservations; old norie_economy_private.receipts;
 core jsonb; base jsonb; source jsonb; pair record; op jsonb;
 bootstrap jsonb; features jsonb;
 feature_keys constant text[]:=array['sync_event_journal','classroom_state','seasonal_state'];
 accepted jsonb:='[]'; rejected jsonb:='[]'; reason text; oid text; origin text; claim text;
 xp bigint; cr bigint; ds bigint; price bigint; hold bigint; shield_hold bigint;
 item text; kind text; digest text; retired_submit boolean;
begin
 perform norie_economy_private.authorize(p_user_id);
 if p_device_id is null or length(p_device_id) not between 1 and 128
 or p_baseline is null or jsonb_typeof(p_baseline)<>'object'
 or octet_length(p_baseline::text)>5242880
 or p_operations is null or jsonb_typeof(p_operations)<>'array'
 or jsonb_array_length(p_operations)>500 or octet_length(p_operations::text)>1048576 then
  raise exception 'invalid_economy_request' using errcode='22023'; end if;
 bootstrap:=coalesce(p_baseline->'legacy_state',p_baseline);
 if jsonb_typeof(bootstrap)<>'object' then
  raise exception 'invalid_economy_baseline' using errcode='22023'; end if;
 if p_baseline ? 'claim_keys' then
  if jsonb_typeof(p_baseline->'claim_keys')<>'array' then
   raise exception 'invalid_economy_claims' using errcode='22023'; end if;
  if jsonb_array_length(p_baseline->'claim_keys')>100000 or exists(
   select 1 from jsonb_array_elements(p_baseline->'claim_keys') v
   where jsonb_typeof(v)<>'string' or length(v#>>'{}') not between 1 and 1024) then
   raise exception 'invalid_economy_claims' using errcode='22023'; end if;
 end if;
 -- Serialize first enrollment too. Always lock legacy core before ledger to
 -- match the direct legacy UPDATE trigger lock order.
 perform pg_advisory_xact_lock(hashtextextended(p_user_id::text,15311));
 select state into core from public.learner_state where user_id=p_user_id for update;
 if not found then
  -- Optional full snapshot creates a valid legacy row, but is not a second
  -- economic baseline: its scalar mirrors may already include pending rewards.
  select coalesce(jsonb_object_agg(key,value),'{}') into features
   from jsonb_each(bootstrap) where key=any(feature_keys);
  insert into public.learner_state(user_id,state) values(p_user_id,bootstrap-feature_keys-'economy_state'-'claim_keys'-'legacy_state') on conflict do nothing returning state into core;
  if found then
   -- The core/sidecar creation is one transaction; a failed feature shape
   -- rolls back enrollment too. Never replace a sidecar from an existing row.
   if features<>'{}'::jsonb then
    insert into public.learner_feature_state(user_id,state) values(p_user_id,features) on conflict do nothing;
   end if;
   core:='{}';
  else select state into core from public.learner_state where user_id=p_user_id for update; end if;
 end if;
 select * into a from norie_economy_private.accounts where user_id=p_user_id for update;
 if not found then
  base:=case when coalesce(p_baseline->>'modified_at','') > coalesce(core->>'modified_at','') then p_baseline else core end;
  if jsonb_typeof(coalesce(base->'owned_shop_items','[]'))<>'array'
    or jsonb_array_length(coalesce(base->'owned_shop_items','[]'))>512
    or exists(select 1 from jsonb_array_elements(coalesce(base->'owned_shop_items','[]')) v where jsonb_typeof(v)<>'string') then
   raise exception 'invalid_economy_baseline' using errcode='22023'; end if;
  insert into norie_economy_private.accounts(user_id,total_xp,credits,owned,shields)
  values(p_user_id,greatest(coalesce((core->>'total_xp')::bigint,0),coalesce((p_baseline->>'total_xp')::bigint,0)),
   coalesce((base->>'credits')::bigint,0),
   (select coalesce(jsonb_agg(value order by value),'[]') from (select distinct value from jsonb_array_elements_text(coalesce(core->'owned_shop_items','[]')||coalesce(p_baseline->'owned_shop_items','[]'))) items),
   coalesce((base->>'streak_shields')::bigint,0)) returning * into a;
  for source in select core union all select p_baseline loop
   insert into norie_economy_private.claims select p_user_id,value
    from jsonb_array_elements_text(coalesce(source->'claim_keys','[]')) on conflict do nothing;
   for pair in select * from (values
    ('rewarded_lesson_topics','lesson:'),('rewarded_perfect_lesson_topics','perfect:'),
    ('daily_challenge_dates','daily:'),('speed_reward_dates','speed:'),
    ('weekly_rewarded_weeks','weekly:'),('rewarded_assessment_attempts','assessment:')) as v(k,prefix) loop
    insert into norie_economy_private.claims select p_user_id,pair.prefix||value
     from jsonb_array_elements_text(coalesce(source->pair.k,'[]')) on conflict do nothing;
   end loop;
   if coalesce((source->>'onboarding_complete')::boolean,false) then
    insert into norie_economy_private.claims values(p_user_id,'onboarding') on conflict do nothing;
   end if;
  end loop;
 end if;
 insert into norie_economy_private.devices(user_id,device_id) values(p_user_id,p_device_id) on conflict do nothing;
 if found then
  a.seq:=a.seq+1;
  update norie_economy_private.accounts set seq=a.seq where user_id=p_user_id;
 end if;
 select retired into retired_submit from norie_economy_private.devices where user_id=p_user_id and device_id=p_device_id;
 if retired_submit then
  return jsonb_build_object('version',1,'checkpoint',norie_economy_private.checkpoint(p_user_id),'reservation',null,
    'accepted','[]'::jsonb,'rejected','[]'::jsonb,'device_seq',(select device_seq from norie_economy_private.devices where user_id=p_user_id and device_id=p_device_id),'must_recover',true);
 end if;
 for op in select value from jsonb_array_elements(p_operations) loop
  oid:=op->>'id'; origin:=op->>'device_id'; kind:=op->>'kind'; claim:=nullif(op->>'claim_key',''); item:=op->>'item_id';
  if jsonb_typeof(op)<>'object' or oid is null or length(oid) not between 1 and 512
   or origin is null or length(origin) not between 1 and 128 or kind is null or kind not in ('reward','spend','consume_shield')
   or jsonb_typeof(op->'xp')<>'number' or jsonb_typeof(op->'credits')<>'number'
   or jsonb_typeof(op->'device_seq')<>'number'
   or (claim is not null and length(claim)>1024)
   or coalesce(op->>'occurred_at','') !~ '(Z|[+-][0-9]{2}:[0-9]{2})$' then
   raise exception 'invalid_economy_operation' using errcode='22023'; end if;
  xp:=(op->>'xp')::bigint; cr:=(op->>'credits')::bigint; ds:=(op->>'device_seq')::bigint;
  if xp not between 0 and 1000000000 or cr not between -1000000000 and 1000000000 or ds<1
   or (op->>'xp') !~ '^[0-9]+$' or (op->>'credits') !~ '^-?[0-9]+$' or (op->>'device_seq') !~ '^[0-9]+$' then
   raise exception 'invalid_economy_amount' using errcode='22023'; end if;
  perform (op->>'occurred_at')::timestamptz;
  digest:=encode(sha256(convert_to(op::text,'UTF8')),'hex');
  select * into old from norie_economy_private.receipts where user_id=p_user_id and id=oid;
  if found then
   if old.digest<>digest then raise exception 'conflicting_economy_operation' using errcode='22023'; end if;
   if old.reason is null then accepted:=accepted||jsonb_build_array(oid);
   else rejected:=rejected||jsonb_build_array(jsonb_build_object('id',oid,'reason',old.reason)); end if;
   continue;
  end if;
  insert into norie_economy_private.devices(user_id,device_id) values(p_user_id,origin) on conflict do nothing;
  if found then a.seq:=a.seq+1; end if;
  select * into d from norie_economy_private.devices where user_id=p_user_id and device_id=origin;
  if ds<>d.device_seq+1 then raise exception 'economy_device_sequence_gap' using errcode='22023'; end if;
  reason:=null;
  if kind='reward' then
   if cr<0 or xp+cr=0 or item is not null then reason:='invalid_reward';
   elsif claim is not null and exists(select 1 from norie_economy_private.claims where user_id=p_user_id and claim_key=claim) then reason:='claim_already_accepted';
   elsif a.total_xp+xp>1000000000 or a.credits+cr>1000000000 then reason:='economy_limit';
   else a.total_xp:=a.total_xp+xp; a.credits:=a.credits+cr;
    if claim is not null then insert into norie_economy_private.claims values(p_user_id,claim); end if;
   end if;
  else
   select * into r from norie_economy_private.reservations where user_id=p_user_id and id::text=op->>'reservation_id' and device_id=origin;
   if not found or r.revoked or r.expires_at<=clock_timestamp() or d.retired then reason:='reservation_expired';
   elsif xp<>0 then reason:='invalid_spend';
   elsif kind='consume_shield' then
    if cr<>0 or item is not null or r.shields_spent>=r.shield_limit or a.shields<1 then reason:='shield_unavailable';
    else a.shields:=a.shields-1; update norie_economy_private.reservations set shields_spent=shields_spent+1 where user_id=p_user_id and id=r.id; end if;
   else
    price:=case item when 'streak-shield' then 300 when 'frame-cyan-orbit' then 150 when 'frame-violet-scholar' then 300
     when 'badge-atom' then 200 when 'badge-streak' then 250 when 'theme-aurora' then 500 when 'theme-ember' then 650 else null end;
    if cr>=0 or (item is not null and (price is null or -cr<>price)) then reason:='invalid_price';
    elsif item is not null and item<>'streak-shield' and a.owned ? item then reason:='item_already_owned';
    elsif -cr>r.credit_limit-r.spent or a.credits+cr<0 then reason:='reservation_exceeded';
    elsif item='streak-shield' and a.shields>=1000000000 then reason:='economy_limit';
    else a.credits:=a.credits+cr;
     update norie_economy_private.reservations set spent=spent-cr where user_id=p_user_id and id=r.id;
     if item='streak-shield' then a.shields:=a.shields+1;
     elsif item is not null then a.owned:=a.owned||jsonb_build_array(item); end if;
    end if;
   end if;
  end if;
  a.seq:=a.seq+1;
  insert into norie_economy_private.receipts values(p_user_id,oid,digest,reason,a.seq);
  insert into norie_economy_private.operations values(p_user_id,oid,op);
  update norie_economy_private.devices set device_seq=ds where user_id=p_user_id and device_id=origin;
  if reason is null then accepted:=accepted||jsonb_build_array(oid);
  else rejected:=rejected||jsonb_build_array(jsonb_build_object('id',oid,'reason',reason)); end if;
 end loop;
 update norie_economy_private.accounts set seq=a.seq,total_xp=a.total_xp,credits=a.credits,owned=a.owned,shields=a.shields where user_id=p_user_id;
 update public.learner_state set state=state||jsonb_build_object('total_xp',a.total_xp,'credits',a.credits,'owned_shop_items',a.owned,'streak_shields',a.shields),updated_at=clock_timestamp() where user_id=p_user_id;
 -- Expired/revoked holds are excluded. Existing active budgets only grow:
 -- outstanding offline operations cannot be invalidated by another sync.
 select * into r from norie_economy_private.reservations where user_id=p_user_id and device_id=p_device_id and not revoked and expires_at>clock_timestamp() order by expires_at desc limit 1;
 if not found then
  insert into norie_economy_private.reservations(user_id,device_id,expires_at) values(p_user_id,p_device_id,clock_timestamp()+interval '7 days') returning * into r;
 end if;
 select coalesce(sum(credit_limit-spent),0),coalesce(sum(shield_limit-shields_spent),0) into hold,shield_hold
 from norie_economy_private.reservations where user_id=p_user_id and not revoked and expires_at>clock_timestamp();
 update norie_economy_private.reservations set credit_limit=credit_limit+greatest(0,least(650-(credit_limit-spent),a.credits-hold)),
  shield_limit=shield_limit+greatest(0,a.shields-shield_hold) where user_id=p_user_id and id=r.id returning * into r;
 return jsonb_build_object('version',1,'checkpoint',norie_economy_private.checkpoint(p_user_id),
 'reservation',jsonb_build_object('id',r.id,'device_id',r.device_id,'limit',r.credit_limit,'spent',r.spent,'expires_at',r.expires_at,'shield_limit',r.shield_limit,'shields_spent',r.shields_spent),
 'accepted',accepted,'rejected',rejected,'device_seq',(select device_seq from norie_economy_private.devices where user_id=p_user_id and device_id=p_device_id),'must_recover',false);
end $$;

create function public.norie_economy_ack(p_user_id uuid,p_device_id text,p_epoch text,p_checkpoint_id text,p_through_seq bigint)
returns boolean language plpgsql security definer set search_path='' as $$
declare a norie_economy_private.accounts;
begin
 perform norie_economy_private.authorize(p_user_id);
 select * into a from norie_economy_private.accounts where user_id=p_user_id for update;
 if not found or p_epoch is distinct from a.epoch::text or p_checkpoint_id is distinct from a.epoch::text||':'||p_through_seq
  or p_through_seq is null or p_through_seq<0 or p_through_seq>a.seq then return false; end if;
 update norie_economy_private.devices set ack_seq=greatest(ack_seq,p_through_seq) where user_id=p_user_id and device_id=p_device_id and not retired;
 return found;
end $$;

create function public.norie_economy_compact(p_user_id uuid) returns jsonb
language plpgsql security definer set search_path='' as $$
declare a norie_economy_private.accounts; n bigint;
begin
 perform norie_economy_private.authorize(p_user_id);
 select * into a from norie_economy_private.accounts where user_id=p_user_id for update;
 if not found then return jsonb_build_object('compacted',false,'deleted',0); end if;
 if exists(select 1 from norie_economy_private.devices where user_id=p_user_id and not retired and ack_seq<a.seq) then
  return jsonb_build_object('compacted',false,'deleted',0); end if;
 delete from norie_economy_private.operations o using norie_economy_private.receipts r
  where o.user_id=p_user_id and r.user_id=o.user_id and r.id=o.id and r.seq<=a.seq;
 get diagnostics n=row_count;
 return jsonb_build_object('compacted',true,'deleted',n,'through_seq',a.seq);
end $$;

create function public.norie_economy_devices(p_user_id uuid) returns jsonb
language plpgsql security definer set search_path='' as $$ begin
 perform norie_economy_private.authorize(p_user_id);
 return coalesce((select jsonb_agg(jsonb_build_object('device_id',device_id,'device_seq',device_seq,'ack_seq',ack_seq,'retired',retired) order by device_id) from norie_economy_private.devices where user_id=p_user_id),'[]');
end $$;
create function public.norie_economy_status(p_user_id uuid) returns jsonb
language plpgsql security definer set search_path='' as $$ begin
 perform norie_economy_private.authorize(p_user_id);
 return norie_economy_private.checkpoint(p_user_id);
end $$;
create function public.norie_economy_retire_device(p_user_id uuid,p_device_id text) returns boolean
language plpgsql security definer set search_path='' as $$ begin
 perform norie_economy_private.authorize(p_user_id);
 perform 1 from norie_economy_private.accounts where user_id=p_user_id for update;
 update norie_economy_private.devices set retired=true where user_id=p_user_id and device_id=p_device_id;
 if not found then return false; end if;
 update norie_economy_private.reservations set revoked=true where user_id=p_user_id and device_id=p_device_id;
 return true;
end $$;

revoke all on all functions in schema norie_economy_private from public,anon,authenticated;
revoke all on function public.norie_economy_sync(uuid,text,jsonb,jsonb),public.norie_economy_ack(uuid,text,text,text,bigint),public.norie_economy_compact(uuid),public.norie_economy_devices(uuid),public.norie_economy_retire_device(uuid,text) from public,anon;
grant execute on function public.norie_economy_sync(uuid,text,jsonb,jsonb),public.norie_economy_ack(uuid,text,text,text,bigint),public.norie_economy_compact(uuid),public.norie_economy_devices(uuid),public.norie_economy_retire_device(uuid,text) to authenticated;
revoke all on function public.norie_economy_status(uuid) from public,anon;
grant execute on function public.norie_economy_status(uuid) to authenticated;

-- Local portable economy envelopes never enter the legacy strict schema.
create or replace function public.norie_save_learner_bundle_guarded(
  p_user_id uuid, p_state jsonb, p_modified timestamptz, p_expected_state jsonb
) returns boolean language plpgsql security invoker set search_path='' as $$
declare
  v_keys constant text[] := array['sync_event_journal','classroom_state','seasonal_state'];
  v_features jsonb; v_expected_features jsonb; v_current_features jsonb;
begin
  p_state := p_state - 'economy_state';
  p_expected_state := p_expected_state - 'economy_state';
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

