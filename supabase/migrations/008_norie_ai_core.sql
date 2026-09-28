-- Norie AI Core foundation: quotas, private cache, usage analytics, provider registry, and training/evaluation scaffolding.

create table if not exists public.ai_user_entitlements (
  user_id uuid primary key references auth.users(id) on delete cascade,
  plan text not null default 'free'
    check (plan in ('free', 'plus', 'pro', 'admin')),
  daily_generation_limit integer not null default 3
    check (daily_generation_limit >= 0),
  daily_qa_limit integer not null default 15
    check (daily_qa_limit >= 0),
  updated_at timestamptz not null default now()
);

create table if not exists public.ai_daily_usage (
  user_id uuid not null references auth.users(id) on delete cascade,
  usage_date date not null default current_date,
  generation_credits_used integer not null default 0
    check (generation_credits_used >= 0),
  qa_credits_used integer not null default 0
    check (qa_credits_used >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, usage_date)
);

create table if not exists public.ai_provider_registry (
  provider_key text primary key,
  display_name text not null,
  enabled boolean not null default false,
  priority integer not null default 100,
  provider_class text not null default 'cloud'
    check (provider_class in ('self_hosted', 'cloud', 'fallback')),
  capabilities jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into public.ai_provider_registry (
  provider_key,
  display_name,
  enabled,
  priority,
  provider_class,
  capabilities
)
values
  (
    'gemma',
    'Norie Study Model / Gemma',
    false,
    10,
    'self_hosted',
    '{"text":true,"files":false,"images":false,"structured_output":true}'::jsonb
  ),
  (
    'openai',
    'OpenAI',
    true,
    90,
    'cloud',
    '{"text":true,"files":true,"images":true,"structured_output":true}'::jsonb
  )
on conflict (provider_key) do update set
  display_name = excluded.display_name,
  priority = excluded.priority,
  provider_class = excluded.provider_class,
  capabilities = excluded.capabilities,
  updated_at = now();

create table if not exists public.ai_generation_cache (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete cascade,
  cache_key text not null,
  task_type text not null default 'study_generation'
    check (task_type in ('study_generation', 'study_qa')),
  provider text not null,
  model text not null,
  payload jsonb not null,
  hit_count integer not null default 0 check (hit_count >= 0),
  created_at timestamptz not null default now(),
  last_hit_at timestamptz,
  unique (owner_user_id, cache_key)
);

create table if not exists public.ai_generation_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  request_kind text not null
    check (request_kind in ('study_generation', 'study_qa')),
  source_hash text,
  provider text,
  model text,
  status text not null
    check (status in ('success', 'failed', 'cache_hit', 'rejected')),
  cache_hit boolean not null default false,
  study_set_id uuid references public.study_sets(id) on delete set null,
  latency_ms integer check (latency_ms is null or latency_ms >= 0),
  input_units integer check (input_units is null or input_units >= 0),
  output_units integer check (output_units is null or output_units >= 0),
  error_code text,
  error_message text,
  created_at timestamptz not null default now()
);

create index if not exists ai_generation_requests_user_created_idx
  on public.ai_generation_requests (user_id, created_at desc);

create index if not exists ai_generation_requests_provider_created_idx
  on public.ai_generation_requests (provider, created_at desc);

create table if not exists public.ai_evaluation_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  generation_request_id uuid references public.ai_generation_requests(id) on delete cascade,
  study_set_id uuid references public.study_sets(id) on delete cascade,
  validation_status text not null
    check (validation_status in ('passed', 'partial', 'failed')),
  generated_items integer not null default 0 check (generated_items >= 0),
  rejected_items integer not null default 0 check (rejected_items >= 0),
  grounded_items integer not null default 0 check (grounded_items >= 0),
  created_at timestamptz not null default now()
);

-- Deliberately separate from student uploads. Nothing is inserted here automatically.
-- Only editor-authored, public-domain, licensed, or explicitly reviewed synthetic examples
-- may become future Norie model training data.
create table if not exists public.ai_training_examples (
  id uuid primary key default gen_random_uuid(),
  source_kind text not null
    check (source_kind in (
      'editor_authored',
      'public_domain',
      'licensed',
      'synthetic_reviewed'
    )),
  task_type text not null,
  input_payload jsonb not null,
  target_payload jsonb not null,
  license_note text,
  approved boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.ai_user_entitlements enable row level security;
alter table public.ai_daily_usage enable row level security;
alter table public.ai_provider_registry enable row level security;
alter table public.ai_generation_cache enable row level security;
alter table public.ai_generation_requests enable row level security;
alter table public.ai_evaluation_records enable row level security;
alter table public.ai_training_examples enable row level security;

drop policy if exists "Users can read own AI entitlement" on public.ai_user_entitlements;
create policy "Users can read own AI entitlement"
on public.ai_user_entitlements for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can read own AI usage" on public.ai_daily_usage;
create policy "Users can read own AI usage"
on public.ai_daily_usage for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can read enabled AI providers" on public.ai_provider_registry;
create policy "Users can read enabled AI providers"
on public.ai_provider_registry for select
to authenticated
using (enabled = true);

drop policy if exists "Users can read own AI cache" on public.ai_generation_cache;
create policy "Users can read own AI cache"
on public.ai_generation_cache for select
to authenticated
using (auth.uid() = owner_user_id);

drop policy if exists "Users can read own AI requests" on public.ai_generation_requests;
create policy "Users can read own AI requests"
on public.ai_generation_requests for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can read own AI evaluations" on public.ai_evaluation_records;
create policy "Users can read own AI evaluations"
on public.ai_evaluation_records for select
to authenticated
using (auth.uid() = user_id);

revoke all on public.ai_user_entitlements from anon, authenticated;
revoke all on public.ai_daily_usage from anon, authenticated;
revoke all on public.ai_provider_registry from anon, authenticated;
revoke all on public.ai_generation_cache from anon, authenticated;
revoke all on public.ai_generation_requests from anon, authenticated;
revoke all on public.ai_evaluation_records from anon, authenticated;
revoke all on public.ai_training_examples from anon, authenticated;

grant select on public.ai_user_entitlements to authenticated;
grant select on public.ai_daily_usage to authenticated;
grant select on public.ai_provider_registry to authenticated;
grant select on public.ai_generation_cache to authenticated;
grant select on public.ai_generation_requests to authenticated;
grant select on public.ai_evaluation_records to authenticated;

create or replace function public.consume_ai_credit_for_user(
  p_user_id uuid,
  p_kind text,
  p_cost integer default 1
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_generation_limit integer := 3;
  v_qa_limit integer := 15;
  v_used integer := 0;
  v_limit integer := 0;
  v_allowed boolean := false;
begin
  if p_user_id is null or p_cost < 1 or p_kind not in ('generation', 'qa') then
    raise exception 'invalid_ai_credit_request';
  end if;

  select
    daily_generation_limit,
    daily_qa_limit
  into
    v_generation_limit,
    v_qa_limit
  from public.ai_user_entitlements
  where user_id = p_user_id;

  v_generation_limit := coalesce(v_generation_limit, 3);
  v_qa_limit := coalesce(v_qa_limit, 15);

  insert into public.ai_daily_usage (user_id, usage_date)
  values (p_user_id, current_date)
  on conflict (user_id, usage_date) do nothing;

  if p_kind = 'generation' then
    select generation_credits_used
      into v_used
    from public.ai_daily_usage
    where user_id = p_user_id and usage_date = current_date
    for update;

    v_limit := v_generation_limit;
    v_allowed := (v_used + p_cost) <= v_limit;

    if v_allowed then
      update public.ai_daily_usage
      set generation_credits_used = generation_credits_used + p_cost,
          updated_at = now()
      where user_id = p_user_id and usage_date = current_date;
      v_used := v_used + p_cost;
    end if;
  else
    select qa_credits_used
      into v_used
    from public.ai_daily_usage
    where user_id = p_user_id and usage_date = current_date
    for update;

    v_limit := v_qa_limit;
    v_allowed := (v_used + p_cost) <= v_limit;

    if v_allowed then
      update public.ai_daily_usage
      set qa_credits_used = qa_credits_used + p_cost,
          updated_at = now()
      where user_id = p_user_id and usage_date = current_date;
      v_used := v_used + p_cost;
    end if;
  end if;

  return jsonb_build_object(
    'allowed', v_allowed,
    'kind', p_kind,
    'used', v_used,
    'limit', v_limit,
    'remaining', greatest(v_limit - v_used, 0),
    'usage_date', current_date
  );
end;
$$;

create or replace function public.refund_ai_credit_for_user(
  p_user_id uuid,
  p_kind text,
  p_cost integer default 1
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_user_id is null or p_cost < 1 or p_kind not in ('generation', 'qa') then
    raise exception 'invalid_ai_credit_refund';
  end if;

  if p_kind = 'generation' then
    update public.ai_daily_usage
    set generation_credits_used = greatest(generation_credits_used - p_cost, 0),
        updated_at = now()
    where user_id = p_user_id and usage_date = current_date;
  else
    update public.ai_daily_usage
    set qa_credits_used = greatest(qa_credits_used - p_cost, 0),
        updated_at = now()
    where user_id = p_user_id and usage_date = current_date;
  end if;
end;
$$;

revoke all on function public.consume_ai_credit_for_user(uuid, text, integer)
  from public, anon, authenticated;
revoke all on function public.refund_ai_credit_for_user(uuid, text, integer)
  from public, anon, authenticated;
grant execute on function public.consume_ai_credit_for_user(uuid, text, integer)
  to service_role;
grant execute on function public.refund_ai_credit_for_user(uuid, text, integer)
  to service_role;

create or replace function public.get_my_ai_quota()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_generation_limit integer := 3;
  v_qa_limit integer := 15;
  v_generation_used integer := 0;
  v_qa_used integer := 0;
  v_plan text := 'free';
begin
  if v_user_id is null then
    raise exception 'not_authenticated';
  end if;

  select
    plan,
    daily_generation_limit,
    daily_qa_limit
  into
    v_plan,
    v_generation_limit,
    v_qa_limit
  from public.ai_user_entitlements
  where user_id = v_user_id;

  v_plan := coalesce(v_plan, 'free');
  v_generation_limit := coalesce(v_generation_limit, 3);
  v_qa_limit := coalesce(v_qa_limit, 15);

  select
    generation_credits_used,
    qa_credits_used
  into
    v_generation_used,
    v_qa_used
  from public.ai_daily_usage
  where user_id = v_user_id and usage_date = current_date;

  v_generation_used := coalesce(v_generation_used, 0);
  v_qa_used := coalesce(v_qa_used, 0);

  return jsonb_build_object(
    'plan', v_plan,
    'usage_date', current_date,
    'generation_used', v_generation_used,
    'generation_limit', v_generation_limit,
    'generation_remaining', greatest(v_generation_limit - v_generation_used, 0),
    'qa_used', v_qa_used,
    'qa_limit', v_qa_limit,
    'qa_remaining', greatest(v_qa_limit - v_qa_used, 0)
  );
end;
$$;

revoke all on function public.get_my_ai_quota() from public, anon;
grant execute on function public.get_my_ai_quota() to authenticated;
