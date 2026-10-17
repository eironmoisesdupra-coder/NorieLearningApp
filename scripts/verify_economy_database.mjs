// node scripts/verify_economy_database.mjs <pglite/dist/index.js>
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
await db.exec('reset role');
for (const suffix of ['_learner_feature_bundle.sql','_learner_feature_core_lifecycle.sql','_authoritative_economy.sql','_economy_private_rpc_boundaries.sql']) {
 const name=readdirSync(migrations).find(n=>n.endsWith(suffix));
 assert.ok(name,`Missing ${suffix}`);
 await db.exec(readFileSync(new URL(name,migrations),'utf8'));
}
const boundaries=(await db.query("select n.nspname,p.proname,p.prosecdef from pg_proc p join pg_namespace n on n.oid=p.pronamespace where p.proname like 'norie_economy_%' and n.nspname in ('public','norie_economy_private')")).rows;
assert.equal(boundaries.filter(p=>p.nspname==='public').length,6);
assert.ok(boundaries.filter(p=>p.nspname==='public').every(p=>p.prosecdef===false),'every exposed economy RPC is invoker');
assert.equal(boundaries.filter(p=>p.nspname==='norie_economy_private' && p.prosecdef).length,6,'guarded definer implementations remain private');
assert.equal((await db.query("select count(*)::int n from pg_policies where schemaname='norie_economy_private' and permissive='RESTRICTIVE' and qual='false' and with_check='false'")).rows[0].n,6,'all ledger tables explicitly deny direct client access');
await db.exec('set role authenticated');
await identify(a,'alice@example.test');
const baseline={schema_version:1,total_xp:100,credits:1000,owned_shop_items:[],streak_shields:2,
 modified_at:'2026-10-17T00:00:00Z',rewarded_lesson_topics:['old'],rewarded_perfect_lesson_topics:[],
 daily_challenge_dates:[],speed_reward_dates:[],weekly_rewarded_weeks:[],rewarded_assessment_attempts:['old-attempt'],onboarding_complete:true};
const sync=async(device,ops=[],base=baseline,owner=a)=>(await db.query(
 'select public.norie_economy_sync($1,$2,$3::jsonb,$4::jsonb) as value',[owner,device,JSON.stringify(base),JSON.stringify(ops)])).rows[0].value;
const reward=(id,device,seq,xp,credits=0,claim=null)=>({id,device_id:device,device_seq:seq,kind:'reward',claim_key:claim,xp,credits,item_id:null,occurred_at:'2026-10-17T00:00:00Z',reservation_id:null});
const spend=(id,device,seq,amount,reservation,item=null)=>({...reward(id,device,seq,0,-amount),kind:'spend',reservation_id:reservation,item_id:item});
const ack=async(device,checkpoint)=>(await db.query('select public.norie_economy_ack($1,$2,$3,$4,$5) as value',[a,device,checkpoint.epoch,checkpoint.id,checkpoint.through_seq])).rows[0].value;
const compact=async()=>(await db.query('select public.norie_economy_compact($1) as value',[a])).rows[0].value;
const retire=async device=>(await db.query('select public.norie_economy_retire_device($1,$2) as value',[a,device])).rows[0].value;
let A=await sync('A'); let B=await sync('B');
assert.ok(B.checkpoint.through_seq>A.checkpoint.through_seq,'registering a device changes checkpoint metadata and sequence together');
assert.equal(A.reservation.limit,650);assert.equal(B.reservation.limit,350);
assert.equal(A.reservation.shield_limit,2);assert.equal(B.reservation.shield_limit,0);
const opA=reward('a1','A',1,5,10,'lesson:new');
A=await sync('A',[opA]);
B=await sync('B',[reward('b1','B',1,7,20,'lesson:other')]);
assert.equal(B.checkpoint.total_xp,112);assert.equal(B.checkpoint.credits,1030);
assert.equal((await sync('A',[opA])).checkpoint.total_xp,112,'lost reply retry does not award twice');
await assert.rejects(sync('A',[{...opA,xp:999}]),/conflicting_economy_operation/);
B=await sync('B',[reward('b2','B',2,999,999,'lesson:new'),reward('b3','B',3,999,0,'lesson:old'),reward('b4','B',4,999,0,'assessment:old-attempt')]);
assert.equal(B.checkpoint.total_xp,112);assert.equal(B.rejected.length,3);
assert.equal(B.checkpoint.device_sequences.B,4);
await assert.rejects(sync('B',[reward('gap','B',6,1)]),/sequence_gap/);
// Catalog price enforcement and disjoint escrow even with stale device balances.
A=await sync('A',[spend('purchaseA','A',2,650,A.reservation.id,'theme-ember')]);
assert.ok(A.checkpoint.owned_shop_items.includes('theme-ember'));
B=await sync('B',[spend('purchaseB','B',5,650,B.reservation.id,'theme-ember')]);
assert.equal(B.rejected[0].reason,'item_already_owned');
B=await sync('B',[spend('tooMuch','B',6,500,B.reservation.id,'theme-aurora')]);
assert.equal(B.rejected[0].reason,'reservation_exceeded');
assert.equal(B.checkpoint.credits,380);
const shield={...reward('shield','A',3,0),kind:'consume_shield',reservation_id:A.reservation.id};
A=await sync('A',[shield]); assert.equal(A.checkpoint.streak_shields,1);
B=await sync('B',[{...shield,id:'no-shield','device_id':'B',device_seq:7,reservation_id:B.reservation.id}]);
assert.equal(B.rejected[0].reason,'shield_unavailable');
// Expiry uses authoritative server time, including equality, never occurred_at.
await db.exec('reset role');
await db.query('update norie_economy_private.reservations set expires_at=clock_timestamp() where user_id=$1 and id=$2',[a,B.reservation.id]);
await db.exec('set role authenticated');
B=await sync('B',[spend('late','B',8,150,B.reservation.id,'frame-cyan-orbit')]);
assert.equal(B.rejected[0].reason,'reservation_expired');
assert.ok(!B.checkpoint.owned_shop_items.includes('frame-cyan-orbit'));
// All legacy writes keep authoritative economy but preserve other snapshot data.
let current=await read();
assert.equal(await save(a,{...current,total_xp:999999,credits:999999,owned_shop_items:['fake'],streak_shields:999,appearance:'new'},current),true);
assert.equal((await read()).total_xp,112);assert.equal((await read()).credits,380);assert.equal((await read()).appearance,'new');
await db.query('update public.learner_state set state=$1 where user_id=$2',[JSON.stringify({...current,total_xp:0,credits:0,owned_shop_items:[],streak_shields:0}),a]);
assert.equal((await read()).total_xp,112);assert.equal((await read()).streak_shields,1);
current=await read();
assert.equal((await db.query('select public.norie_save_learner_bundle_guarded($1,$2::jsonb,$3::timestamptz,$4::jsonb) as value',
 [a,JSON.stringify({...current,total_xp:99999,economy_state:{local_only:true}}),'2026-10-17T00:00:00Z',JSON.stringify({...current,economy_state:{local_only:true}})])).rows[0].value,true);
assert.equal((await read()).total_xp,112);assert.equal((await read()).economy_state,undefined,'portable envelope does not enter legacy schema');
await assert.rejects(sync('A',[reward('fake-old-seq','A',1,900)]),/sequence_gap/);
assert.equal(await ack('A',{...B.checkpoint,id:'invented'}),false);
assert.equal(await ack('A',{...B.checkpoint,through_seq:B.checkpoint.through_seq+100}),false);
assert.equal(await ack('A',B.checkpoint),true);
assert.equal((await compact()).compacted,false,'dormant registered device blocks compaction');
assert.equal(await ack('B',B.checkpoint),true);
let C=await sync('C');assert.equal((await compact()).compacted,false,'new unacknowledged device blocks deletion');
assert.equal(await retire('C'),true);
assert.equal(await ack('A',C.checkpoint),true);
assert.equal(await ack('B',C.checkpoint),true);
assert.equal((await compact()).compacted,true);
await db.exec('reset role');
assert.equal((await db.query('select count(*)::int n from norie_economy_private.operations')).rows[0].n,0);
assert.ok((await db.query('select count(*)::int n from norie_economy_private.receipts')).rows[0].n>0);
await db.exec('set role authenticated');
A=await sync('A',[opA]);assert.equal(A.checkpoint.total_xp,112,'compacted replay does not award again');
await assert.rejects(sync('A',[{...opA,credits:11}]),/conflicting_economy_operation/);
assert.equal((await sync('C')).must_recover,true);
// Portable backup replay accepts old origin reward once, rejects retired spends.
A=await sync('A',[reward('lateReward','C',1,9)]);assert.equal(A.checkpoint.total_xp,121);
A=await sync('A',[spend('lateRetiredSpend','C',2,1,C.reservation.id)]);
assert.equal(A.rejected[0].reason,'reservation_expired');
await assert.rejects(sync('A',[],baseline,b),/learner_owner_mismatch/);
await identify(a,'not-allowed@example.test');await assert.rejects(sync('A'),/demo_access_required/);
await identify(b,'bob@example.test');
assert.equal((await db.query('select public.norie_economy_status($1) as value',[b])).rows[0].value,null,'status does not enroll');
assert.equal(await save(b,{total_xp:0,credits:5,streak_shields:0,owned_shop_items:['old-item'],modified_at:'2026-01-01T00:00:00Z'},null),true);
const bobBase={total_xp:0,credits:0,streak_shields:0,owned_shop_items:['new-item'],modified_at:'2026-10-01T00:00:00Z',claim_keys:['guest-folded']};
const other=await sync('other',[],bobBase,b);assert.equal(other.checkpoint.total_xp,0);
assert.deepEqual(other.checkpoint.owned_shop_items,['new-item','old-item'],'baseline preserves older permanent ownership');
assert.ok(other.checkpoint.claim_keys.includes('guest-folded'),'canonical baseline seeds collapsed guest claims');
const blocked=await sync('other',[reward('folded','other',1,50,0,'guest-folded')],bobBase,b);
assert.equal(blocked.checkpoint.total_xp,0);assert.equal(blocked.rejected[0].reason,'claim_already_accepted');
await assert.rejects(db.query('select * from norie_economy_private.accounts'),/permission denied/);
await assert.rejects(db.query('select norie_economy_private.checkpoint($1)',[b]),/permission denied/,'unguarded private helpers cannot be called');
await assert.rejects(db.query('select norie_economy_private.norie_economy_status($1)',[a]),/learner_owner_mismatch/,'direct guarded implementation still enforces owner');
await db.exec('reset role;set role anon');await assert.rejects(sync('A'),/permission denied/);
await db.exec('reset role');
const c='00000000-0000-0000-0000-000000000013';
await db.query('insert into auth.users(id) values ($1)',[c]);
await db.query('insert into public.demo_access(email) values ($1)',['carol@example.test']);
await db.exec('set role authenticated');await identify(c,'carol@example.test');
const fresh=await sync('fresh',[reward('pending-first','fresh',1,50,0,'lesson:pending')],{
 total_xp:100,credits:0,streak_shields:0,owned_shop_items:[],claim_keys:[],
 legacy_state:{total_xp:150,credits:0,streak_shields:0,owned_shop_items:[],rewarded_lesson_topics:['pending'],marker:'full-legacy-shape',
  sync_event_journal:{version:1,events:[]},classroom_state:{version:1,assignments:[],submissions:[]},seasonal_state:{version:1,earned_rewards:[]},economy_state:{must:'never enter legacy'}}
},c);
assert.equal(fresh.checkpoint.total_xp,150,'first enrollment never seeds optimistic full-snapshot totals or pending claims');
assert.equal((await read()).marker,'full-legacy-shape','bootstrap preserves the complete legacy snapshot shape');
for(const key of ['sync_event_journal','classroom_state','seasonal_state','economy_state','claim_keys','legacy_state']) assert.equal((await read())[key],undefined,`first legacy core excludes ${key}`);
const freshBundle=(await db.query('select public.norie_get_learner_bundle($1) as value',[c])).rows[0].value.state;
assert.deepEqual(freshBundle.sync_event_journal,{version:1,events:[]});
assert.deepEqual(freshBundle.classroom_state,{version:1,assignments:[],submissions:[]});
assert.deepEqual(freshBundle.seasonal_state,{version:1,earned_rewards:[]});
await assert.rejects(sync('fresh',[],{claim_keys:'invalid'},c),/invalid_economy_claims/);
await assert.rejects(sync('fresh',[],{claim_keys:['']},c),/invalid_economy_claims/);
await assert.rejects(sync('fresh',[],{claim_keys:[42]},c),/invalid_economy_claims/);
await assert.rejects(sync('fresh',[],{legacy_state:[]},c),/invalid_economy_baseline/);
await db.exec('reset role');
// Legacy DELETE/recreate cannot reset the auth-owned economy epoch.
await db.query('delete from public.learner_state where user_id=$1',[a]);
await db.exec('set role authenticated');await identify(a,'alice@example.test');
A=await sync('A');assert.equal(A.checkpoint.total_xp,121);assert.equal((await read()).total_xp,121);
await db.exec('reset role');
await db.query('delete from auth.users where id=$1',[a]);
assert.equal((await db.query('select count(*)::int n from norie_economy_private.accounts where user_id=$1',[a])).rows[0].n,0);
await db.close();
console.log('Economy SQL passed: additive claims, retries/conflicts, funded escrow/catalog/shields/expiry, legacy protection, durable acknowledgments/compaction, retirement/backup replay, owner/admission/RLS and deletion lifecycle. PGlite serializes sessions; live concurrent-backend stress remains a deployment check.');

