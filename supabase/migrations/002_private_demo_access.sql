-- Norie Learning private demo allowlist.
-- Only authenticated users can read the allowlist row matching their own email.
-- Client roles cannot add, modify, or remove approved users.

create table if not exists public.demo_access (
  email text primary key,
  label text,
  created_at timestamptz not null default now(),
  constraint demo_access_email_normalized check (email = lower(trim(email))),
  constraint demo_access_label_length
    check (label is null or char_length(label) <= 80)
);

alter table public.demo_access enable row level security;

drop policy if exists "demo_access_select_self" on public.demo_access;
create policy "demo_access_select_self"
on public.demo_access
for select
using (
  lower(email) = lower(coalesce(((select auth.jwt()) ->> 'email'), ''))
);

revoke all on public.demo_access from anon;
revoke insert, update, delete, truncate, references, trigger
  on public.demo_access from authenticated;
grant select on public.demo_access to authenticated;
