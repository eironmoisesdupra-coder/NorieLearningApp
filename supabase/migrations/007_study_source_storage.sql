insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'study-sources',
  'study-sources',
  false,
  10485760,
  array[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'text/plain',
    'text/markdown',
    'image/png',
    'image/jpeg',
    'image/webp'
  ]
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "study_sources_own_select" on storage.objects;
create policy "study_sources_own_select"
on storage.objects
for select to authenticated
using (
  bucket_id = 'study-sources'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

drop policy if exists "study_sources_own_insert" on storage.objects;
create policy "study_sources_own_insert"
on storage.objects
for insert to authenticated
with check (
  bucket_id = 'study-sources'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

drop policy if exists "study_sources_own_update" on storage.objects;
create policy "study_sources_own_update"
on storage.objects
for update to authenticated
using (
  bucket_id = 'study-sources'
  and (storage.foldername(name))[1] = (select auth.uid())::text
)
with check (
  bucket_id = 'study-sources'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

drop policy if exists "study_sources_own_delete" on storage.objects;
create policy "study_sources_own_delete"
on storage.objects
for delete to authenticated
using (
  bucket_id = 'study-sources'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);
