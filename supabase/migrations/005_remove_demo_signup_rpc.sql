revoke all on function public.is_demo_email_approved(text) from public;
revoke all on function public.is_demo_email_approved(text) from anon;
revoke all on function public.is_demo_email_approved(text) from authenticated;
drop function if exists public.is_demo_email_approved(text);
