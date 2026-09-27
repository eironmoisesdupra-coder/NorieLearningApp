-- Norie Learning: accounts + cloud progression sync
-- Apply this migration to the Supabase project before enabling cloud sync.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_display_name_length
    check (display_name is null or char_length(display_name) between 1 and 80)
);

create table if not exists public.learner_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.learner_state enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "profiles_delete_own" on public.profiles;
create policy "profiles_delete_own"
on public.profiles
for delete
using (auth.uid() = id);

drop policy if exists "learner_state_select_own" on public.learner_state;
create policy "learner_state_select_own"
on public.learner_state
for select
using (auth.uid() = user_id);

drop policy if exists "learner_state_insert_own" on public.learner_state;
create policy "learner_state_insert_own"
on public.learner_state
for insert
with check (auth.uid() = user_id);

drop policy if exists "learner_state_update_own" on public.learner_state;
create policy "learner_state_update_own"
on public.learner_state
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "learner_state_delete_own" on public.learner_state;
create policy "learner_state_delete_own"
on public.learner_state
for delete
using (auth.uid() = user_id);

create or replace function public.handle_new_norie_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    nullif(trim(coalesce(new.raw_user_meta_data ->> 'display_name', '')), '')
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created_norie on auth.users;
create trigger on_auth_user_created_norie
after insert on auth.users
for each row execute procedure public.handle_new_norie_user();

create or replace function public.set_norie_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute procedure public.set_norie_updated_at();

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.learner_state to authenticated;
