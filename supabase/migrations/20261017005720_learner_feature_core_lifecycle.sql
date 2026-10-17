-- The feature snapshot belongs to its core snapshot. The original auth.users
-- foreign key remains valid, but alone permits deleting core while leaving a
-- sidecar that no bundle read can discover or first-save CAS can reconcile.
--
-- Existing orphans deliberately fail FK validation instead of silently
-- discarding earned feature data; recover their core snapshots before retrying.
alter table public.learner_feature_state
  add constraint learner_feature_state_core_fkey
  foreign key (user_id) references public.learner_state(user_id)
  on delete cascade;
