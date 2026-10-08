// Run with an externally installed PGlite ESM entrypoint:
// node scripts/verify_league_database.mjs <path-to-pglite/dist/index.js>
// This executes the real migration in PostgreSQL WASM; it is not a text check.
import assert from 'node:assert/strict';
import {readFileSync,readdirSync} from 'node:fs';
import {pathToFileURL} from 'node:url';
const {PGlite} = await import(pathToFileURL(process.argv[2]).href);
const db = new PGlite();
await db.exec(`
  create role anon;
  create role authenticated;
  create role service_role bypassrls;
  create schema auth;
  create table auth.users(id uuid primary key);
  create function auth.uid() returns uuid language sql stable as
    $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
  grant usage on schema auth to authenticated;
  grant execute on function auth.uid() to authenticated;
`);
const name = readdirSync(new URL('../supabase/migrations/',import.meta.url)).find(n => n.endsWith('_private_verified_leagues.sql'));
await db.exec(readFileSync(new URL(`../supabase/migrations/${name}`,import.meta.url),'utf8'));
const indexMigration = readdirSync(new URL('../supabase/migrations/',import.meta.url)).find(n => n.endsWith('_league_privacy_indexes.sql'));
await db.exec(readFileSync(new URL(`../supabase/migrations/${indexMigration}`,import.meta.url),'utf8'));
const tierMigration = readdirSync(new URL('../supabase/migrations/',import.meta.url)).find(n => n.endsWith('_league_tier_calibration.sql'));
await db.exec(readFileSync(new URL(`../supabase/migrations/${tierMigration}`,import.meta.url),'utf8'));
// Execute the exact rollback-only live verification before inserting isolated
// fixtures. This catches script mistakes before the parent runs it remotely.
await db.exec(readFileSync(new URL('../supabase/tests/private_verified_leagues_live.sql',import.meta.url),'utf8'));
const a = '00000000-0000-0000-0000-000000000001';
const b = '00000000-0000-0000-0000-000000000002';
const cohort = '10000000-0000-0000-0000-000000000001';
const other = '10000000-0000-0000-0000-000000000002';
const season = '20000000-0000-0000-0000-000000000001';
await db.exec(`
  insert into auth.users values ('${a}'),('${b}');
  insert into public.league_eligibility(user_id,adult_or_guardian_approved,approved_at)
    values ('${a}',true,now()),('${b}',true,now());
  insert into public.league_seasons(id,starts_at,ends_at,bank_version) values ('${season}',now()-interval '1 day',now()+interval '1 day','v1');
  insert into public.league_cohorts(id,title,subject,grade,season_id,invite_hash)
    values ('${cohort}','Science group','science','g1','${season}','hash-a'),
      ('${other}','Other group','science','g2','${season}','hash-b');
  insert into public.league_memberships(cohort_id,user_id,nickname,opted_in,approved_at)
    values ('${cohort}','${a}','Learner abc123',true,now()),
      ('${other}','${b}','Learner def456',true,now());
`);
await db.exec(`set role authenticated; set request.jwt.claim.sub = '${a}';`);
assert.equal((await db.query('select * from league_memberships')).rows.length,1,'RLS own membership only');
assert.equal((await db.query('select * from league_eligibility')).rows.length,1,'RLS own eligibility only');
await assert.rejects(db.query('select * from league_cohorts'),/permission denied/);
await assert.rejects(db.query(`update league_memberships set opted_in = true`),/permission denied/);
await assert.rejects(db.query(`insert into league_receipts(attempt_id,user_id,cohort_id,season_id,lesson_id,bank_version,correct,points,reason)
 values ('30000000-0000-0000-0000-000000000001','${a}','${cohort}','${season}','lesson','v1',5,10,'forged')`),/permission denied/);
await assert.rejects(db.query(`select league_finish_verified('30000000-0000-0000-0000-000000000001','${a}','nonce','v1',5)`),/permission denied/);
await db.exec('reset role; set role service_role;');
const insertAttempt = async (id,lesson,expires = "now()+interval '30 minutes'") => db.exec(`
  insert into league_attempts(id,user_id,cohort_id,season_id,lesson_id,bank_version,question_ids,nonce_hash,expires_at)
  values ('${id}','${a}','${cohort}','${season}','${lesson}','v1','["q0","q1","q2","q3","q4"]','nonce',${expires});`);
const finish = async (id,correct = 5) => (await db.query(
  'select league_finish_verified($1,$2,$3,$4,$5) as receipt',[id,a,'nonce','v1',correct])).rows[0].receipt;
const first = '30000000-0000-0000-0000-000000000001';
await insertAttempt(first,'lesson0');
const receipt = await finish(first);
assert.equal(receipt.points,10);
assert.deepEqual(await finish(first),receipt,'retry receipt unchanged');
const duplicate = '30000000-0000-0000-0000-000000000002';
await insertAttempt(duplicate,'lesson0');
assert.equal((await finish(duplicate)).points,0,'same lesson second attempt earns no more points');
const failed = '30000000-0000-0000-0000-000000000003';
await insertAttempt(failed,'failedLesson');
assert.equal((await finish(failed,3)).points,0,'80% requirement enforced');
const expired = '30000000-0000-0000-0000-000000000004';
await insertAttempt(expired,'expired',"now()-interval '1 second'");
await assert.rejects(finish(expired),/expired_attempt/);
await assert.rejects(db.query('select league_finish_verified($1,$2,$3,$4,$5)',[first,a,'tampered','v1',5]),/invalid_attempt/);
await assert.rejects(db.query('select league_finish_verified($1,$2,$3,$4,$5)',[first,b,'nonce','v1',5]),/invalid_attempt/);
await assert.rejects(db.query('select league_finish_verified($1,$2,$3,$4,$5)',[first,a,'nonce','altered',5]),/invalid_attempt/);
for (let i=1;i<=20;i++) {
  const id = `40000000-0000-0000-0000-${i.toString().padStart(12,'0')}`;
  await insertAttempt(id,`lesson${i}`);
  const result = await finish(id);
  assert.equal(result.points,i===20 ? 0 : 10,'season cap checked in real SQL');
  if (i === 5) {
    const emblems = (await db.query('select tier from league_badges where user_id = $1',[a])).rows.map(r => r.tier);
    assert.equal(emblems.length,5,'six distinct first passes (60 points) can reach all current cohort tiers');
    assert.ok(emblems.includes('Master'),'Master is attainable within six eligible Science lessons');
  }
}
const rowsA = (await db.query('select league_board_rows($1,$2) as rows',[cohort,a])).rows[0].rows;
assert.equal(rowsA.length,1);
assert.equal(rowsA[0].points,200);
const seasonClosedAttempt = '60000000-0000-0000-0000-000000000001';
await insertAttempt(seasonClosedAttempt,'season-closed');
await db.exec(`update league_seasons set ends_at = now()-interval '1 second' where id = '${season}';`);
await assert.rejects(finish(seasonClosedAttempt),/season_closed/);
assert.equal((await db.query('select * from league_badges where user_id = $1',[a])).rows.length,5,'season close preserves permanent emblems');
assert.deepEqual(await finish(first),receipt,'confirmed receipt survives late retry after season close');
await db.exec(`update league_seasons set ends_at = now()+interval '1 day' where id = '${season}';`);
assert.equal(rowsA[0].is_me,true);
assert.equal((await db.query('select * from league_badges where user_id = $1',[a])).rows.length,5,'all five permanent cosmetic emblems issued exactly once');
assert.equal((await db.query('select count(*)::int as n from league_badges where user_id = $1 and tier = $2',[a,'Explorer'])).rows[0].n,1,'duplicate attempt never reissues emblems');
assert.equal('user_id' in rowsA[0],false,'board does not expose account ID');
assert.deepEqual((await db.query('select league_board_rows($1,$2) as rows',[other,a])).rows[0].rows,[],'private cohort cross-access denied');
await db.exec(`update league_memberships set opted_in = false where user_id = '${a}';`);
assert.deepEqual((await db.query('select league_board_rows($1,$2) as rows',[cohort,a])).rows[0].rows,[],'opt-out hides display');
const optedOut = '50000000-0000-0000-0000-000000000001';
await insertAttempt(optedOut,'opted-out');
await assert.rejects(finish(optedOut),/not_eligible/);
await db.exec(`update league_memberships set opted_in = true where user_id = '${a}'; update league_eligibility set revoked_at = now() where user_id = '${a}';`);
await assert.rejects(finish(optedOut),/not_eligible/);
await db.exec(`update league_eligibility set revoked_at = null where user_id = '${a}';`);
await db.query('select league_delete_display($1)',[a]);
assert.equal((await db.query('select * from league_badges where user_id = $1',[a])).rows.length,5,'leaving/deleting display preserves earned cosmetic receipts');
assert.deepEqual((await db.query('select league_board_rows($1,$2) as rows',[cohort,a])).rows[0].rows,[],'delete display leaves membership');
await db.exec('reset role; set role anon;');
await assert.rejects(db.query('select * from league_receipts'),/permission denied/);
await assert.rejects(db.query(`select league_delete_display('${a}')`),/permission denied/);
await db.exec('reset role;');
await db.exec(`insert into league_reports(reporter_id,cohort_id,member_id)
  select '${b}','${cohort}',id from league_memberships where user_id = '${a}';`);
await db.exec(`delete from auth.users where id = '${a}';`);
assert.equal((await db.query('select * from league_attempts where user_id = $1',[a])).rows.length,0,'account deletion cascades attempts');
assert.equal((await db.query('select * from league_receipts where user_id = $1',[a])).rows.length,0,'account deletion cascades receipts');
assert.equal((await db.query('select * from league_badges where user_id = $1',[a])).rows.length,0,'account deletion cascades earned emblems');
assert.equal((await db.query('select * from league_reports')).rows.length,0,'reports targeting a deleted account do not block its deletion');
await db.close();
console.log('Verified leagues migration executed: 35+ real PostgreSQL admission/RLS/receipt/cap/delete assertions passed.');
