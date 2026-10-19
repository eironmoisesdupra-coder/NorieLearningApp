-- Preparation only: disabled by default; does not change existing content tables.
-- Private authorization records are provisioned by a trusted operator, never JWT
-- user_metadata. No client receives table writes or permission to assign roles.
create schema norie_publication_private;
revoke all on schema norie_publication_private from public,anon,authenticated;

create table norie_publication_private.settings (
 singleton boolean primary key default true check(singleton),
 enabled boolean not null default false
);
insert into norie_publication_private.settings default values;
create table norie_publication_private.scope_grants (
 user_id uuid not null references auth.users(id),
 role text not null check(role in ('author','reviewer','publisher')),
 subject text not null check(length(subject) between 1 and 100),
 grade text not null check(length(grade) between 1 and 100),
 generation integer not null default 1 check(generation > 0),
 revoked_at timestamptz,
 expires_at timestamptz,
 primary key(user_id,role,subject,grade)
);
create table norie_publication_private.revisions (
 id bigint generated always as identity primary key,
 content_id text not null check(length(content_id) between 1 and 200),
 revision integer not null check(revision > 0),
 subject text not null,
 grade text not null,
 author_id uuid not null references auth.users(id),
 source text not null check(octet_length(source) between 2 and 1048576),
 content_sha256 text not null check(content_sha256 ~ '^[a-f0-9]{64}$'),
 status text not null default 'submitted' check(status in
 ('submitted','changes_requested','approved','scheduled','published','retired')),
 submitted_at timestamptz not null default clock_timestamp(),
 scheduled_at timestamptz,
 unique(content_id,revision)
);
create table norie_publication_private.approvals (
 revision_id bigint primary key references norie_publication_private.revisions(id),
 content_sha256 text not null,
 reviewer_id uuid not null references auth.users(id),
 reviewer_generation integer not null,
 evidence jsonb not null check(octet_length(evidence::text) <= 65536),
 reviewed_at timestamptz not null default clock_timestamp()
);
-- Populated only by a trusted validator after checking the exact source bytes,
-- full lesson schema, answer keys, dependency DAG and actual licensed asset bytes.
-- No authenticated RPC can assert that this automated gate passed.
create table norie_publication_private.structural_gates (
 revision_id bigint primary key references norie_publication_private.revisions(id),
 content_sha256 text not null check(content_sha256 ~ '^[a-f0-9]{64}$'),
 validator_version text not null check(length(validator_version) between 1 and 100),
 report_sha256 text not null check(report_sha256 ~ '^[a-f0-9]{64}$'),
 checked_at timestamptz not null default clock_timestamp()
);
create table norie_publication_private.registry_events (
 sequence bigint primary key,
 revision_id bigint not null references norie_publication_private.revisions(id),
 content_sha256 text not null,
 action text not null check(action in ('publish','rollback','retire')),
 publisher_id uuid not null references auth.users(id),
 created_at timestamptz not null default clock_timestamp()
);
create table norie_publication_private.registry_head (
 singleton boolean primary key default true check(singleton),
 sequence bigint not null default 0
);
insert into norie_publication_private.registry_head default values;
create index publication_events_revision_sequence on norie_publication_private.registry_events(revision_id,sequence desc);
create index publication_revisions_author on norie_publication_private.revisions(author_id);
create index publication_approvals_reviewer on norie_publication_private.approvals(reviewer_id);
create index publication_events_publisher on norie_publication_private.registry_events(publisher_id);

create function norie_publication_private.require_scope(p_role text,p_subject text,p_grade text)
returns integer language plpgsql security definer set search_path='' as $$
declare v_generation integer;
begin
 if auth.uid() is null then raise exception 'publication_scope_denied'; end if;
 select generation into v_generation from norie_publication_private.scope_grants
 where user_id=auth.uid() and role=p_role and subject=p_subject and grade=p_grade
 and revoked_at is null and (expires_at is null or expires_at > clock_timestamp())
 for share;
 if v_generation is null then raise exception 'publication_scope_denied'; end if;
 return v_generation;
end $$;

create function norie_publication_private.immutable_evidence()
returns trigger language plpgsql set search_path='' as $$
begin raise exception 'publication_immutable_evidence'; end $$;
create function norie_publication_private.bump_scope_generation()
returns trigger language plpgsql set search_path='' as $$
begin
 -- Regranting a revoked identity never resurrects a previous approval.
 if (new.user_id,new.role,new.subject,new.grade) is distinct from
 (old.user_id,old.role,old.subject,old.grade) then raise exception 'publication_immutable_scope_identity'; end if;
 new.generation := old.generation+1;
 return new;
end $$;
create trigger scope_generation before update on norie_publication_private.scope_grants
for each row execute function norie_publication_private.bump_scope_generation();
create trigger immutable_scope_history before delete on norie_publication_private.scope_grants
for each row execute function norie_publication_private.immutable_evidence();
create trigger immutable_structural_gate before update or delete on norie_publication_private.structural_gates
for each row execute function norie_publication_private.immutable_evidence();
create trigger immutable_approvals before update or delete on norie_publication_private.approvals
for each row execute function norie_publication_private.immutable_evidence();
create trigger immutable_events before update or delete on norie_publication_private.registry_events
for each row execute function norie_publication_private.immutable_evidence();
create function norie_publication_private.immutable_source()
returns trigger language plpgsql set search_path='' as $$
begin
 if (new.id,new.content_id,new.revision,new.subject,new.grade,new.author_id,new.source,new.content_sha256,new.submitted_at)
 is distinct from
 (old.id,old.content_id,old.revision,old.subject,old.grade,old.author_id,old.source,old.content_sha256,old.submitted_at)
 then raise exception 'publication_immutable_revision'; end if;
 return new;
end $$;
create trigger immutable_revision before update on norie_publication_private.revisions
for each row execute function norie_publication_private.immutable_source();

create function norie_publication_private.submit(p_content_id text,p_revision integer,p_subject text,p_grade text,p_source text,p_sha256 text)
returns bigint language plpgsql security definer set search_path='' as $$
declare v_id bigint; v_doc jsonb;
begin
 perform norie_publication_private.require_scope('author',p_subject,p_grade);
 if p_source is null or octet_length(p_source)>1048576 then raise exception 'publication_source_budget'; end if;
 if p_sha256 is distinct from encode(sha256(convert_to(p_source,'UTF8')),'hex') then
 raise exception 'publication_hash_mismatch'; end if;
 v_doc := p_source::jsonb;
 if jsonb_typeof(v_doc) is distinct from 'object' or
 v_doc->'topic'->>'id' is distinct from p_content_id or
 v_doc->'topic'->>'subject' is distinct from p_subject or
 v_doc->'topic'->>'grade_level' is distinct from p_grade or
 jsonb_typeof(v_doc->'metadata') is distinct from 'object'
 then raise exception 'publication_invalid_schema'; end if;
 perform pg_advisory_xact_lock(hashtextextended(p_content_id,0));
 if exists(select 1 from norie_publication_private.revisions where content_id=p_content_id
 and (subject<>p_subject or grade<>p_grade)) then raise exception 'publication_content_scope_conflict'; end if;
 insert into norie_publication_private.revisions(content_id,revision,subject,grade,author_id,source,content_sha256)
 values(p_content_id,p_revision,p_subject,p_grade,auth.uid(),p_source,p_sha256) returning id into v_id;
 return v_id;
end $$;

create function norie_publication_private.review(p_id bigint,p_sha256 text,p_approve boolean,p_evidence jsonb)
returns void language plpgsql security definer set search_path='' as $$
declare r norie_publication_private.revisions; v_generation integer;
begin
 select * into r from norie_publication_private.revisions where id=p_id for update;
 if not found then raise exception 'publication_revision_missing'; end if;
 v_generation := norie_publication_private.require_scope('reviewer',r.subject,r.grade);
 if r.author_id=auth.uid() then raise exception 'publication_separation_required'; end if;
 if r.content_sha256 is distinct from p_sha256 then raise exception 'publication_stale_revision'; end if;
 if r.status <> 'submitted' or p_approve is null then raise exception 'publication_invalid_transition'; end if;
 if p_evidence is null or jsonb_typeof(p_evidence) <> 'object' or octet_length(p_evidence::text)>65536 or
 jsonb_typeof(p_evidence->'source_editions') is distinct from 'array' or
 coalesce(jsonb_array_length(p_evidence->'source_editions'),0)=0 or
 exists(select 1 from jsonb_array_elements(p_evidence->'source_editions') edition
 where jsonb_typeof(edition) is distinct from 'string' or length(trim(edition#>>'{}'))=0) or
 jsonb_typeof(p_evidence->'rubric') is distinct from 'string' or
 coalesce(length(trim(p_evidence->>'rubric')),0)=0 or
 jsonb_typeof(p_evidence->'factual_corrections') is distinct from 'string' or
 coalesce(length(trim(p_evidence->>'factual_corrections')),0)=0 or
 p_evidence->'asset_licenses_checked' is distinct from 'true'::jsonb or
 p_evidence->'answer_keys_checked' is distinct from 'true'::jsonb
 then raise exception 'publication_review_evidence_required'; end if;
 -- Changes requested is terminal for this immutable revision; author submits a new revision.
 insert into norie_publication_private.approvals(revision_id,content_sha256,reviewer_id,reviewer_generation,evidence)
 values(p_id,p_sha256,auth.uid(),v_generation,p_evidence);
 update norie_publication_private.revisions set status=case when p_approve then 'approved' else 'changes_requested' end where id=p_id;
end $$;

create function norie_publication_private.schedule(p_id bigint,p_sha256 text,p_at timestamptz)
returns void language plpgsql security definer set search_path='' as $$
declare r norie_publication_private.revisions;
begin
 select * into r from norie_publication_private.revisions where id=p_id for update;
 if not found then raise exception 'publication_revision_missing'; end if;
 perform norie_publication_private.require_scope('publisher',r.subject,r.grade);
 if r.content_sha256 is distinct from p_sha256 then raise exception 'publication_stale_revision'; end if;
 if r.status <> 'approved' then raise exception 'publication_invalid_transition'; end if;
 if p_at is null or p_at > clock_timestamp()+interval '180 days' then raise exception 'publication_invalid_schedule'; end if;
 update norie_publication_private.revisions set status='scheduled',scheduled_at=p_at where id=p_id;
end $$;

create function norie_publication_private.release(p_id bigint,p_sha256 text,p_expected_sequence bigint,p_action text)
returns bigint language plpgsql security definer set search_path='' as $$
declare r norie_publication_private.revisions; a norie_publication_private.approvals;
 v_head bigint;
begin
 if not (select enabled from norie_publication_private.settings where singleton) then
 raise exception 'publication_activation_disabled'; end if;
 -- One locked head serializes releases and gives callers a compare-and-swap.
 select sequence into v_head from norie_publication_private.registry_head where singleton for update;
 if p_expected_sequence is distinct from v_head then raise exception 'publication_registry_conflict'; end if;
 select * into r from norie_publication_private.revisions where id=p_id for update;
 if not found then raise exception 'publication_revision_missing'; end if;
 perform norie_publication_private.require_scope('publisher',r.subject,r.grade);
 if r.content_sha256 is distinct from p_sha256 then raise exception 'publication_stale_revision'; end if;
 select * into a from norie_publication_private.approvals where revision_id=p_id;
 if a.reviewer_id is null then raise exception 'publication_review_required'; end if;
 if auth.uid() in (r.author_id,a.reviewer_id) then raise exception 'publication_separation_required'; end if;
 perform 1 from norie_publication_private.scope_grants where user_id=a.reviewer_id and
 role='reviewer' and subject=r.subject and grade=r.grade and generation=a.reviewer_generation and
 revoked_at is null and (expires_at is null or expires_at>clock_timestamp()) for share;
 if not found and p_action is distinct from 'retire' then raise exception 'publication_review_revoked'; end if;
 if not exists(select 1 from norie_publication_private.structural_gates where revision_id=p_id and content_sha256=p_sha256)
 then raise exception 'publication_structural_gate_required'; end if;
 if p_action='publish' then
  if r.status <> 'scheduled' or r.scheduled_at>clock_timestamp() then raise exception 'publication_invalid_transition'; end if;
  if exists(select 1 from norie_publication_private.registry_events e
   join norie_publication_private.revisions previous on previous.id=e.revision_id
   where previous.content_id=r.content_id and previous.revision>=r.revision and e.action='publish')
  then raise exception 'publication_downgrade_requires_rollback'; end if;
 elsif p_action in ('rollback','retire') then
  if r.status <> 'published' or not exists(select 1 from norie_publication_private.registry_events where revision_id=p_id and action='publish')
  then raise exception 'publication_invalid_transition'; end if;
  if p_action='rollback' and not coalesce((select newer.revision>r.revision and e.action<>'retire'
   from norie_publication_private.registry_events e
   join norie_publication_private.revisions newer on newer.id=e.revision_id
   where newer.content_id=r.content_id order by e.sequence desc limit 1),false)
  then raise exception 'publication_rollback_requires_older_approved_revision'; end if;
  if p_action='retire' and p_id is distinct from
   (select e.revision_id from norie_publication_private.registry_events e
    join norie_publication_private.revisions current_revision on current_revision.id=e.revision_id
    where current_revision.content_id=r.content_id order by e.sequence desc limit 1)
  then raise exception 'publication_retire_requires_current_revision'; end if;
 else raise exception 'publication_invalid_transition'; end if;
 insert into norie_publication_private.registry_events(sequence,revision_id,content_sha256,action,publisher_id)
 values(v_head+1,p_id,p_sha256,p_action,auth.uid());
 update norie_publication_private.registry_head set sequence=v_head+1 where singleton;
 update norie_publication_private.revisions set status=case when p_action='retire' then 'retired' else 'published' end where id=p_id;
 return v_head+1;
end $$;

-- Public wrappers are invokers. Definer implementations live only in the private
-- schema, use a fixed empty search path and enforce identity plus live scope.
create function public.norie_publication_submit(p_content_id text,p_revision integer,p_subject text,p_grade text,p_source text,p_sha256 text)
returns bigint language sql security invoker set search_path='' as $$
 select norie_publication_private.submit(p_content_id,p_revision,p_subject,p_grade,p_source,p_sha256) $$;
create function public.norie_publication_review(p_id bigint,p_sha256 text,p_approve boolean,p_evidence jsonb)
returns void language sql security invoker set search_path='' as $$
 select norie_publication_private.review(p_id,p_sha256,p_approve,p_evidence) $$;
create function public.norie_publication_schedule(p_id bigint,p_sha256 text,p_at timestamptz)
returns void language sql security invoker set search_path='' as $$
 select norie_publication_private.schedule(p_id,p_sha256,p_at) $$;
create function public.norie_publication_release(p_id bigint,p_sha256 text,p_expected_sequence bigint,p_action text)
returns bigint language sql security invoker set search_path='' as $$
 select norie_publication_private.release(p_id,p_sha256,p_expected_sequence,p_action) $$;

do $$ declare t text; begin
 foreach t in array array['settings','scope_grants','revisions','approvals','structural_gates','registry_events','registry_head'] loop
 execute format('alter table norie_publication_private.%I enable row level security',t);
 execute format('create policy deny_client_access on norie_publication_private.%I as restrictive for all to authenticated using(false) with check(false)',t);
 end loop;
end $$;
revoke all on all tables in schema norie_publication_private from public,anon,authenticated;
revoke all on all sequences in schema norie_publication_private from public,anon,authenticated;
revoke all on all functions in schema norie_publication_private from public,anon,authenticated;
grant usage on schema norie_publication_private to authenticated;
-- Separate backend validator/exporter credential only; never ship service_role
-- to an app. It cannot assign scopes, enable activation, or write registry events.
grant usage on schema norie_publication_private to service_role;
grant select on norie_publication_private.revisions,norie_publication_private.approvals,
 norie_publication_private.structural_gates,norie_publication_private.registry_events,
 norie_publication_private.registry_head to service_role;
grant insert on norie_publication_private.structural_gates to service_role;
create policy trusted_validator_gate on norie_publication_private.structural_gates
for insert to service_role with check(exists(select 1 from norie_publication_private.revisions r
 where r.id=revision_id and r.content_sha256=structural_gates.content_sha256));
grant execute on function norie_publication_private.submit(text,integer,text,text,text,text),
 norie_publication_private.review(bigint,text,boolean,jsonb),
 norie_publication_private.schedule(bigint,text,timestamptz),
 norie_publication_private.release(bigint,text,bigint,text) to authenticated;
revoke all on function public.norie_publication_submit(text,integer,text,text,text,text),
 public.norie_publication_review(bigint,text,boolean,jsonb),
 public.norie_publication_schedule(bigint,text,timestamptz),
 public.norie_publication_release(bigint,text,bigint,text) from public,anon;
grant execute on function public.norie_publication_submit(text,integer,text,text,text,text),
 public.norie_publication_review(bigint,text,boolean,jsonb),
 public.norie_publication_schedule(bigint,text,timestamptz),
 public.norie_publication_release(bigint,text,bigint,text) to authenticated;
