// node scripts/verify_guarded_cloud_database.mjs <pglite/dist/index.js>
// Executes PostgreSQL, including real table policies and the production RPC.
// PGlite serializes statements: these tests reproduce stale simultaneous reads,
// but do not claim a multiple-backend lock-contention stress test.
import assert from 'node:assert/strict';
import {readFileSync, readdirSync} from 'node:fs';
import {pathToFileURL} from 'node:url';

const {PGlite} = await import(pathToFileURL(process.argv[2]).href);
const db = new PGlite();
const migrations = new URL('../supabase/migrations/', import.meta.url);
const migration = readdirSync(migrations).find(n => n.endsWith('_guarded_learner_state_save.sql'));
await db.exec(`
  create role anon;
  create role authenticated;
  create schema auth;
  create table auth.users(id uuid primary key);
  create function auth.uid() returns uuid language sql stable as
    $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
  create function auth.jwt() returns jsonb language sql stable as
    $$ select jsonb_build_object('email',current_setting('request.jwt.claim.email',true)) $$;
  grant usage on schema auth, public to authenticated;
  grant execute on function auth.uid(), auth.jwt() to authenticated;
`);
// Reuse the existing production table and owner RLS statements; profile signup
// triggers are unrelated to snapshot synchronization and require full auth.users.
const accounts = readFileSync(new URL('001_accounts_cloud_sync.sql', migrations), 'utf8');
await db.exec(accounts.slice(0, accounts.indexOf('create or replace function')));
await db.exec('grant select,insert,update,delete on public.learner_state to authenticated');
await db.exec(readFileSync(new URL('002_private_demo_access.sql', migrations), 'utf8'));
await db.exec(readFileSync(new URL(migration, migrations), 'utf8'));
const a = '00000000-0000-0000-0000-000000000011';
const b = '00000000-0000-0000-0000-000000000012';
await db.exec(`
  insert into auth.users values ('${a}'),('${b}');
  insert into demo_access(email) values ('alice@example.test'),('bob@example.test');
  set role authenticated;
`);
const identify = async (id, email) => {
  await db.query("select set_config('request.jwt.claim.sub',$1,false), set_config('request.jwt.claim.email',$2,false)", [id, email]);
};
const save = async (id, state, expected) => (await db.query(
  'select public.norie_save_learner_state_guarded($1,$2::jsonb,$3::timestamptz,$4::jsonb) as saved',
  [id, JSON.stringify(state), '2026-10-08T00:00:00Z', expected === null ? null : JSON.stringify(expected)],
)).rows[0].saved;
const read = async () => (await db.query('select state from public.learner_state')).rows[0]?.state;
await identify(a, 'alice@example.test');
const base = {trophies: ['base'], appearance: 'default'};
assert.equal(await save(a, base, null), true, 'first snapshot inserts');
assert.equal(await save(a, {trophies: ['losing-first-writer']}, null), false, 'competing first insert cannot replace winner');
assert.deepEqual(await read(), base);

// Both devices took this exact snapshot before either submitted its own reward.
const snapshotA = await read();
const snapshotB = await read();
const deviceA = {trophies: ['base', 'A'], appearance: 'look-A'};
const deviceB = {trophies: ['base', 'B'], appearance: 'look-B'};
assert.equal(await save(a, deviceA, snapshotA), true);
assert.equal(await save(a, deviceB, snapshotB), false, 'stale device B cannot clobber A');
assert.deepEqual(await read(), deviceA, 'conflict preserves all winning state');
const latest = await read();
const mergedB = {...deviceB, trophies: [...new Set([...latest.trophies, ...deviceB.trophies])].sort()};
assert.equal(await save(a, mergedB, latest), true, 'freshly merged retry succeeds');
assert.deepEqual((await read()).trophies, ['A', 'B', 'base']);
assert.equal((await read()).appearance, 'look-B');
assert.equal(await save(a, mergedB, deviceA), false, 'repeated stale upload is rejected');
assert.equal(await save(a, mergedB, mergedB), true, 'unchanged idempotent retry is safe');

await assert.rejects(save(b, deviceB, null), /learner_owner_mismatch/, 'cannot target another owner');
await identify(b, 'bob@example.test');
assert.equal(await read(), undefined, 'RLS does not expose Alice to Bob');
await assert.rejects(save(a, deviceA, mergedB), /learner_owner_mismatch/, 'token switch after local capture cannot save old learner');
assert.equal(await save(b, {trophies: ['B-only']}, null), true);
await identify(a, 'alice@example.test');
assert.deepEqual(await read(), mergedB, 'cross-owner call leaves original unchanged');
await identify(a, 'not-allowed@example.test');
await assert.rejects(save(a, {}, mergedB), /demo_access_required/);
await identify(a, 'alice@example.test');
await assert.rejects(save(a, [], mergedB), /invalid_learner_snapshot/);
await db.exec('reset role; set role anon;');
await assert.rejects(save(a, {}, null), /permission denied/);
await db.exec('reset role;');
assert.equal((await db.query('select count(*)::int as n from public.learner_state')).rows[0].n, 2);
// Extend the real PostgreSQL fixture with the compatibility bundle migration.
const bundleMigration = readdirSync(migrations).find(n => n.endsWith('_learner_feature_bundle.sql'));
assert.ok(bundleMigration, 'Feature bundle migration must exist');
await db.exec(readFileSync(new URL(bundleMigration, migrations), 'utf8'));
await db.exec('set role authenticated');
await identify(a, 'alice@example.test');
const bundle = async (state, expected, owner=a) => (await db.query(
  'select public.norie_save_learner_bundle_guarded($1,$2::jsonb,$3::timestamptz,$4::jsonb) as saved',
  [owner, JSON.stringify(state), '2026-10-17T00:00:00Z', expected === null ? null : JSON.stringify(expected)],
)).rows[0].saved;
const readBundle = async (owner=a) => (await db.query('select public.norie_get_learner_bundle($1) as value',[owner])).rows[0].value;
const feature = {sync_event_journal:{version:1,events:[]}, classroom_state:{version:1,assignments:[],submissions:[]}, seasonal_state:{version:1,earned_rewards:[]}};
const combined = {...mergedB,...feature};
assert.equal(await bundle(combined,mergedB),true);
assert.deepEqual(await read(),mergedB,'Old clients receive only their supported snapshot fields');
assert.deepEqual((await readBundle()).state,combined);
assert.equal(await bundle({...combined,appearance:'must-roll-back'},mergedB),false,'stale extension CAS fails');
assert.deepEqual(await read(),mergedB,'extension conflict rolls back the preceding core save');
const oldUpdated={...mergedB,total_xp:55};
assert.equal(await save(a,oldUpdated,mergedB),true,'old binary RPC keeps working');
const afterOld=(await readBundle()).state;
assert.deepEqual(afterOld,{...oldUpdated,...feature},'old writes do not discard new feature data');
const firstNew={...afterOld,sync_event_journal:{version:1,events:[{id:'device-a'}]}};
assert.equal(await bundle(firstNew,afterOld),true);
assert.equal(await bundle({...afterOld,total_xp:999},afterOld),false,'concurrent stale feature writer cannot replace events');
assert.deepEqual((await readBundle()).state,firstNew);
assert.deepEqual(await read(),oldUpdated,'atomic failed bundle did not overwrite counters');
await assert.rejects(bundle(combined,firstNew,b),/learner_owner_mismatch/);
await assert.rejects(readBundle(b),/learner_owner_mismatch/);
await identify(b,'bob@example.test');
assert.equal((await db.query('select count(*)::int as n from public.learner_feature_state')).rows[0].n,0,'feature RLS isolates owners');
await assert.rejects(db.query('insert into public.learner_feature_state(user_id,state) values ($1,$2)',[a,JSON.stringify(feature)]),/row-level security/);
await identify(a,'not-allowed@example.test');
await assert.rejects(readBundle(),/demo_access_required/);
await assert.rejects(bundle(combined,firstNew),/demo_access_required/);
await identify(a,'alice@example.test');
await assert.rejects(bundle([],firstNew),/invalid_learner_bundle/);
await db.exec('reset role; set role anon');
await assert.rejects(readBundle(),/permission denied/);
await assert.rejects(bundle(combined,firstNew),/permission denied/);
await db.exec('reset role');
// Apply additive lifecycle migrations after the original deployed bundle RPC.
for (const name of readdirSync(migrations).filter(n => n.endsWith('_learner_feature_core_lifecycle.sql')).sort()) {
  await db.exec(readFileSync(new URL(name,migrations),'utf8'));
}
await db.exec('set role authenticated');
await identify(a,'alice@example.test');
await db.query('delete from public.learner_state where user_id=$1',[a]);
assert.equal((await db.query('select count(*)::int as n from public.learner_feature_state')).rows[0].n,0,
  'Deleting an owner snapshot must also delete its sidecar, preventing an unrecoverable orphan CAS conflict');
assert.equal(await readBundle(),null);
await assert.rejects(db.query('insert into public.learner_feature_state(user_id,state) values ($1,$2)',
  [a,JSON.stringify(feature)]),/foreign key/,'Cannot create an orphan sidecar');
assert.equal(await bundle(combined,null),true,'Fresh bundle save succeeds after core deletion');
assert.deepEqual((await readBundle()).state,combined);
await identify(b,'bob@example.test');
assert.deepEqual(await read(),{trophies:['B-only']},'Other learner core is unchanged');
await db.exec('reset role');
await db.query('delete from auth.users where id=$1',[a]);
assert.equal((await db.query('select count(*)::int as n from public.learner_state where user_id=$1',[a])).rows[0].n,0);
assert.equal((await db.query('select count(*)::int as n from public.learner_feature_state where user_id=$1',[a])).rows[0].n,0,
  'Account deletion still cascades through core and sidecar');
await db.close();
console.log('Feature bundle: legacy compatibility, atomic CAS rollback, owner/admission/RLS, retry and core/sidecar lifecycle checks passed.');
