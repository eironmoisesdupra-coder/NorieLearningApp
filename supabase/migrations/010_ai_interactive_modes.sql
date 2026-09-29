-- Extend AI study questions to the Sprint 2 interactive activity engine.

alter table public.study_questions
  drop constraint if exists study_questions_kind_check;

alter table public.study_questions
  add constraint study_questions_kind_check
  check (
    kind in (
      'single_select',
      'true_false',
      'identification',
      'matching',
      'drag_drop',
      'ordering',
      'fill_blank',
      'flashcard'
    )
  );

alter table public.study_questions
  add column if not exists ordered_items jsonb not null default '[]'::jsonb;

comment on column public.study_questions.ordered_items is
  'Correct source-supported sequence for ordering activities.';
