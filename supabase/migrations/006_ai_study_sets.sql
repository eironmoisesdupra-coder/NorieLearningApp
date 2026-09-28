-- AI study-set persistence for Norie Learning.

create table if not exists public.study_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  source_type text not null check (
    source_type in ('notes','pdf','docx','pptx','image','youtube')
  ),
  source_name text,
  source_text text,
  source_path text,
  generation_mode text not null default 'mixed' check (
    generation_mode in (
      'multiple_choice','true_false','identification','flashcards','mixed'
    )
  ),
  requested_count integer not null check (requested_count between 1 and 100),
  status text not null default 'draft' check (
    status in ('draft','generating','ready','failed')
  ),
  topic_tag text,
  ai_model text,
  error_message text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.study_questions (
  id uuid primary key default gen_random_uuid(),
  study_set_id uuid not null
    references public.study_sets(id) on delete cascade,
  position integer not null check (position >= 0),
  kind text not null check (
    kind in ('single_select','true_false','identification','flashcard')
  ),
  prompt text not null,
  options jsonb not null default '[]'::jsonb,
  correct_values jsonb not null default '[]'::jsonb,
  explanation text not null default '',
  source_excerpt text not null default '',
  topic_tag text,
  difficulty text not null default 'foundation',
  created_at timestamptz not null default now(),
  unique(study_set_id, position)
);

create table if not exists public.study_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  study_set_id uuid not null
    references public.study_sets(id) on delete cascade,
  correct_count integer not null default 0,
  total_count integer not null default 0,
  answers jsonb not null default '{}'::jsonb,
  xp_awarded integer not null default 0,
  completed_at timestamptz not null default now()
);

create index if not exists study_sets_user_created_idx
  on public.study_sets(user_id, created_at desc);
create index if not exists study_questions_set_position_idx
  on public.study_questions(study_set_id, position);
create index if not exists study_attempts_user_set_idx
  on public.study_attempts(user_id, study_set_id, completed_at desc);

alter table public.study_sets enable row level security;
alter table public.study_questions enable row level security;
alter table public.study_attempts enable row level security;

drop policy if exists "study_sets_own_all" on public.study_sets;
create policy "study_sets_own_all"
on public.study_sets
for all
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "study_questions_own_select" on public.study_questions;
create policy "study_questions_own_select"
on public.study_questions
for select
to authenticated
using (
  exists (
    select 1 from public.study_sets s
    where s.id = study_questions.study_set_id
      and s.user_id = (select auth.uid())
  )
);

drop policy if exists "study_questions_own_insert" on public.study_questions;
create policy "study_questions_own_insert"
on public.study_questions
for insert
to authenticated
with check (
  exists (
    select 1 from public.study_sets s
    where s.id = study_questions.study_set_id
      and s.user_id = (select auth.uid())
  )
);

drop policy if exists "study_questions_own_update" on public.study_questions;
create policy "study_questions_own_update"
on public.study_questions
for update
to authenticated
using (
  exists (
    select 1 from public.study_sets s
    where s.id = study_questions.study_set_id
      and s.user_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1 from public.study_sets s
    where s.id = study_questions.study_set_id
      and s.user_id = (select auth.uid())
  )
);

drop policy if exists "study_questions_own_delete" on public.study_questions;
create policy "study_questions_own_delete"
on public.study_questions
for delete
to authenticated
using (
  exists (
    select 1 from public.study_sets s
    where s.id = study_questions.study_set_id
      and s.user_id = (select auth.uid())
  )
);

drop policy if exists "study_attempts_own_all" on public.study_attempts;
create policy "study_attempts_own_all"
on public.study_attempts
for all
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

revoke all on public.study_sets from anon;
revoke all on public.study_questions from anon;
revoke all on public.study_attempts from anon;

grant select, insert, update, delete on public.study_sets to authenticated;
grant select, insert, update, delete on public.study_questions to authenticated;
grant select, insert, update, delete on public.study_attempts to authenticated;

drop trigger if exists study_sets_set_updated_at on public.study_sets;
create trigger study_sets_set_updated_at
before update on public.study_sets
for each row execute procedure public.set_norie_updated_at();
