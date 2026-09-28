-- Norie Learning cloud curriculum schema.

create table if not exists public.content_subjects (
  id text primary key,
  title text not null,
  description text not null default '',
  sort_order integer not null default 0,
  is_published boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.content_categories (
  id text primary key,
  subject_id text not null
    references public.content_subjects(id) on delete cascade,
  title text not null,
  description text not null default '',
  sort_order integer not null default 0,
  is_published boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.content_topics (
  id text primary key,
  category_id text not null
    references public.content_categories(id) on delete cascade,
  title text not null,
  subtitle text not null default '',
  sort_order integer not null default 0,
  accent text not null default 'cyan',
  prerequisite_topic_id text
    references public.content_topics(id) on delete set null,
  payload jsonb not null,
  is_published boolean not null default false,
  updated_at timestamptz not null default now(),
  constraint content_topics_payload_object
    check (jsonb_typeof(payload) = 'object')
);

create index if not exists content_categories_subject_order_idx
  on public.content_categories(subject_id, sort_order);
create index if not exists content_topics_category_order_idx
  on public.content_topics(category_id, sort_order);
create index if not exists content_topics_prerequisite_idx
  on public.content_topics(prerequisite_topic_id);

alter table public.content_subjects enable row level security;
alter table public.content_categories enable row level security;
alter table public.content_topics enable row level security;

drop policy if exists "published_subjects_for_authenticated"
  on public.content_subjects;
create policy "published_subjects_for_authenticated"
on public.content_subjects
for select
to authenticated
using (is_published = true);

drop policy if exists "published_categories_for_authenticated"
  on public.content_categories;
create policy "published_categories_for_authenticated"
on public.content_categories
for select
to authenticated
using (is_published = true);

drop policy if exists "published_topics_for_authenticated"
  on public.content_topics;
create policy "published_topics_for_authenticated"
on public.content_topics
for select
to authenticated
using (is_published = true);

revoke all on public.content_subjects from anon;
revoke all on public.content_categories from anon;
revoke all on public.content_topics from anon;

revoke insert, update, delete, truncate, references, trigger
  on public.content_subjects from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.content_categories from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.content_topics from authenticated;

grant select on public.content_subjects to authenticated;
grant select on public.content_categories to authenticated;
grant select on public.content_topics to authenticated;

drop trigger if exists content_subjects_set_updated_at
  on public.content_subjects;
create trigger content_subjects_set_updated_at
before update on public.content_subjects
for each row execute procedure public.set_norie_updated_at();

drop trigger if exists content_categories_set_updated_at
  on public.content_categories;
create trigger content_categories_set_updated_at
before update on public.content_categories
for each row execute procedure public.set_norie_updated_at();

drop trigger if exists content_topics_set_updated_at
  on public.content_topics;
create trigger content_topics_set_updated_at
before update on public.content_topics
for each row execute procedure public.set_norie_updated_at();
