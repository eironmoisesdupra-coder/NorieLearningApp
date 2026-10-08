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
await db.close();
console.log('Guarded cloud RPC: 20 PostgreSQL owner/admission/CAS/conflict/retry assertions passed.');
