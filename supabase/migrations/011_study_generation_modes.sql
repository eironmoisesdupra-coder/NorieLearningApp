begin;

alter table public.study_sets
  drop constraint if exists study_sets_generation_mode_check;
alter table public.study_sets
  add constraint study_sets_generation_mode_check check (
    generation_mode in (
      'multiple_choice', 'true_false', 'identification', 'matching',
      'drag_drop', 'ordering', 'fill_blank', 'flashcards', 'mixed'
    )
  );

notify pgrst, 'reload schema';
commit;