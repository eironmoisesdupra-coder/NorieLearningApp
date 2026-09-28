-- Harden the Norie AI Core schema after security-advisor review.

drop policy if exists "No client access to AI training examples"
  on public.ai_training_examples;

create policy "No client access to AI training examples"
on public.ai_training_examples
for all
to public
using (false)
with check (false);

create or replace function public.get_my_ai_quota()
returns jsonb
language plpgsql
security invoker
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
