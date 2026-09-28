-- Private demo signup preflight.
-- Returns only whether a candidate email is currently approved for demo access.

create or replace function public.is_demo_email_approved(candidate_email text)
returns boolean
language sql
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.demo_access
    where email = lower(trim(candidate_email))
  );
$$;

revoke all on function public.is_demo_email_approved(text) from public;
grant execute on function public.is_demo_email_approved(text) to anon;
grant execute on function public.is_demo_email_approved(text) to authenticated;
