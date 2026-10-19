// Real PostgreSQL security/transition fixtures. No remote database connection.
// node scripts/verify_curriculum_publication_database.mjs <pglite/dist/index.js>
import assert from 'node:assert/strict';
import {readFileSync, readdirSync} from 'node:fs';
import {pathToFileURL} from 'node:url';
import {createHash} from 'node:crypto';

const {PGlite} = await import(pathToFileURL(process.argv[2]).href);
const db = new PGlite();
await db.exec(`create role anon; create role authenticated; create role service_role bypassrls;
 create schema auth; create table auth.users(id uuid primary key);
 create function auth.uid() returns uuid language sql stable as
 $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
 grant usage on schema auth to authenticated;
 grant execute on function auth.uid() to authenticated;`);
const migrations = new URL('../supabase/migrations/', import.meta.url);
const name = readdirSync(migrations).find(n => n.endsWith('_curriculum_publication_boundary.sql'));
assert.ok(name, 'publication migration exists');
await db.exec(readFileSync(new URL(name, migrations), 'utf8'));
const rpcBoundaries=(await db.query(`select p.prosecdef from pg_proc p join pg_namespace n on n.oid=p.pronamespace
 where n.nspname='public' and p.proname like 'norie_publication_%'`)).rows;
assert.equal(rpcBoundaries.length,4);
assert.ok(rpcBoundaries.every(p=>p.prosecdef===false),'exposed publication RPCs use invoker rights');
const users = Array.from({length:6}, (_,i) => `00000000-0000-0000-0000-00000000000${i+1}`);
const [author, reviewer, publisher, outsider, learner, validator] = users;
await db.query('insert into auth.users select unnest($1::uuid[])', [users]);
for (const [user, role, subject] of [[author,'author','science'],[author,'reviewer','science'],
 [reviewer,'reviewer','science'],[publisher,'publisher','science'],[outsider,'reviewer','math']]) {
 await db.query(`insert into norie_publication_private.scope_grants(user_id,role,subject,grade)
 values ($1,$2,$3,'g1')`, [user,role,subject]);
}
const identify = async id => {
 await db.exec('reset role; set role authenticated');
 await db.query("select set_config('request.jwt.claim.sub',$1,false)", [id]);
};
const source = JSON.stringify({topic:{id:'sci-one',subject:'science',grade_level:'g1'},metadata:{}});
const hash = createHash('sha256').update(source).digest('hex');
const submit = (revision=1, digest=hash) => db.query(
 'select public.norie_publication_submit($1,$2,$3,$4,$5,$6) id',
 ['sci-one',revision,'science','g1',source,digest]).then(r=>r.rows[0].id);
const evidence = {source_editions:['Textbook 2026 p12'], rubric:'subject accuracy v1',
 factual_corrections:'none', asset_licenses_checked:true, answer_keys_checked:true};
const review = (id, approve=true, digest=hash) => db.query(
 'select public.norie_publication_review($1,$2,$3,$4::jsonb)', [id,digest,approve,JSON.stringify(evidence)]);
const schedule = id => db.query('select public.norie_publication_schedule($1,$2,now())', [id,hash]);
const publish = (id, expected=0, action='publish') => db.query(
 'select public.norie_publication_release($1,$2,$3,$4)', [id,hash,expected,action]).then(r=>r.rows[0].norie_publication_release);
await db.exec('set role anon');
await assert.rejects(submit(), /permission denied/);
await identify(learner);
await assert.rejects(submit(), /publication_scope_denied/);
await assert.rejects(db.query(`insert into norie_publication_private.scope_grants(user_id,role,subject,grade)
 values ($1,'publisher','science','g1')`, [learner]), /permission denied/);
await identify(author);
await assert.rejects(submit(1,'0'.repeat(64)), /publication_hash_mismatch/);
await assert.rejects(db.query('select public.norie_publication_submit($1,$2,$3,$4,$5,$6)',
 ['sci-one',1,'science','g2',source,hash]), /publication_scope_denied/);
const id = await submit();
await assert.rejects(submit(), /duplicate key/);
await assert.rejects(review(id), /publication_separation_required/);
await assert.rejects(db.query('update norie_publication_private.revisions set source=$1', ['{}']), /permission denied/);
await identify(outsider);
await assert.rejects(review(id), /publication_scope_denied/);
await identify(reviewer);
await assert.rejects(review(id,true,'0'.repeat(64)), /publication_stale_revision/);
await assert.rejects(db.query('select public.norie_publication_review($1,$2,true,$3::jsonb)',
 [id,hash,JSON.stringify({...evidence,source_editions:['']})]), /publication_review_evidence_required/);
await review(id);
await assert.rejects(review(id), /publication_invalid_transition/);
await assert.rejects(schedule(id), /publication_scope_denied/);
await identify(publisher);
await schedule(id);
await assert.rejects(publish(id), /publication_activation_disabled/);
await db.exec('reset role; update norie_publication_private.settings set enabled=true');
await assert.rejects(db.query('update norie_publication_private.revisions set source=$1 where id=$2',['{}',id]),/publication_immutable_revision/);
await assert.rejects(db.query('delete from norie_publication_private.approvals where revision_id=$1',[id]),/publication_immutable_evidence/);
await db.query(`update norie_publication_private.scope_grants set revoked_at=now()
 where user_id=$1 and role='reviewer'`, [reviewer]);
await identify(publisher);
await assert.rejects(publish(id), /publication_review_revoked/);
await db.exec('reset role');
await db.query(`update norie_publication_private.scope_grants set revoked_at=null
 where user_id=$1 and role='reviewer'`, [reviewer]);
await identify(publisher);
await assert.rejects(publish(id), /publication_review_revoked/);
// Immutable approval cannot revive on regrant; a new submitted revision is needed.
await identify(author); const id2 = await submit(2);
await identify(reviewer); await review(id2);
await identify(publisher); await schedule(id2);
await assert.rejects(publish(id2), /publication_structural_gate_required/);
await db.exec('reset role; set role service_role');
await db.query(`insert into norie_publication_private.structural_gates(revision_id,content_sha256,validator_version,report_sha256)
 values ($1,$2,'test-validator-1',$2)`, [id2,hash]);
await assert.rejects(db.query('update norie_publication_private.settings set enabled=true'),/permission denied/);
await identify(publisher);
assert.equal(await publish(id2), 1);
await assert.rejects(publish(id2), /publication_invalid_transition|publication_registry_conflict/);
await identify(author); const id3 = await submit(3);
await identify(reviewer); await review(id3);
await identify(publisher); await schedule(id3);
await db.exec('reset role');
await db.query(`insert into norie_publication_private.structural_gates(revision_id,content_sha256,validator_version,report_sha256)
 values ($1,$2,'test-validator-1',$2)`, [id3,hash]);
await identify(publisher);
await assert.rejects(publish(id3,0), /publication_registry_conflict/);
assert.equal(await publish(id3,1), 2);
await assert.rejects(publish(id2,2,'retire'),/publication_retire_requires_current_revision/);
assert.equal(await publish(id2,2,'rollback'), 3);
await assert.rejects(publish(id2,3,'rollback'),/publication_rollback_requires_older_approved_revision/);
await assert.rejects(publish(id3,1,'rollback'), /publication_registry_conflict/);
await identify(author); const rejected = await submit(4);
await identify(reviewer); await review(rejected,false);
await identify(publisher); await assert.rejects(schedule(rejected), /publication_invalid_transition/);
await assert.rejects(db.query(`insert into norie_publication_private.structural_gates
 (revision_id,content_sha256,validator_version,report_sha256) values ($1,$2,'forged',$2)`, [rejected,hash]), /permission denied/);
await db.exec('reset role');
assert.equal((await db.query('select count(*)::int n from norie_publication_private.registry_events')).rows[0].n,3);
await assert.rejects(db.query('delete from norie_publication_private.scope_grants where user_id=$1',[reviewer]),/publication_immutable_evidence/);
await identify(publisher);
assert.equal(await publish(id2,3,'retire'),4);
await identify(author); const future = await submit(5);
await identify(reviewer); await review(future);
await identify(publisher);
await db.query("select public.norie_publication_schedule($1,$2,now()+interval '1 day')",[future,hash]);
await db.exec('reset role; set role service_role');
await db.query(`insert into norie_publication_private.structural_gates(revision_id,content_sha256,validator_version,report_sha256)
 values ($1,$2,'test-validator-1',$2)`,[future,hash]);
await identify(publisher);
await assert.rejects(publish(future,4),/publication_invalid_transition/);
assert.equal((await db.query(`select count(*)::int n from pg_class c join pg_namespace n on n.oid=c.relnamespace
 where n.nspname='norie_publication_private' and c.relkind='r' and not c.relrowsecurity`)).rows[0].n,0);
await db.close();
console.log('Publication PostgreSQL authorization, immutable approvals, revocation, gates and rollback passed.');
console.log('PGlite serializes sessions; multi-backend contention and deployed Supabase integration remain activation checks.');
