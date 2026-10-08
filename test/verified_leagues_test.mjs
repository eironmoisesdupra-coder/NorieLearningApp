import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync, readdirSync} from 'node:fs';
import {verifyAnswers,eligibleAward,rankRows} from '../supabase/functions/verified-leagues/verification.mjs';
import {digest,nonceMessage,signNonce,validNonce,resolveNonceSecret} from '../supabase/functions/verified-leagues/nonce.mjs';
const lesson = {questions:Array.from({length:5},(_,i) => ({id:`q${i}`,options:['a','b','c','d'],correctIndex:i%4}))};
const attempt = {question_ids:lesson.questions.map(q => q.id),bank_version:'v1',expires_at:'2026-10-08T12:30:00Z'};
const answers = Object.fromEntries(lesson.questions.map(q => [q.id,q.correctIndex]));
const now = Date.parse('2026-10-08T12:00:00Z');
test('nonce secret resolution is domain separated, deterministic, overridable and never exposes its source', async () => {
  const source = 'fixture-service-credential-32chars-minimum';
  const derived = await resolveNonceSecret(source);
  assert.equal(derived,await digest(`norie-league-nonce:v1:${source}`));
  assert.notEqual(derived,await digest(source));
  assert.equal(derived.includes(source),false);
  assert.match(derived,/^[a-f0-9]{64}$/);
  assert.equal(await resolveNonceSecret(source,''),derived);
  assert.notEqual(await resolveNonceSecret(`${source}:rotated`),derived);
  const dedicated = 'dedicated-secret-fixture-32chars-minimum';
  assert.equal(await resolveNonceSecret(source,dedicated),dedicated);
  await assert.rejects(resolveNonceSecret(source,'short'),/league_backend_not_configured/);
  await assert.rejects(resolveNonceSecret('short'),/league_backend_not_configured/);
  const edge = readFileSync(new URL('../supabase/functions/verified-leagues/index.ts',import.meta.url),'utf8');
  assert.equal(/console\.(?:log|error|warn)|reply\([^\n]*(?:secret|serviceKey|\{key)/.test(edge),false);
});
test('actual HMAC proof binds attempt/owner/bank/expiry and canonicalizes PostgreSQL timestamp formats', async () => {
  const serverAttempt = {id:'attempt-a',user_id:'owner-a',bank_version:'v1',expires_at:'2026-10-08T12:30:00.000Z'};
  const secret = 'server-only-random-secret-fixture-32chars';
  const nonce = await signNonce(nonceMessage(serverAttempt),secret);
  assert.equal(await validNonce(nonce,nonceMessage({...serverAttempt,expires_at:'2026-10-08T12:30:00+00:00'}),secret),true);
  for (const changed of [{id:'attempt-b'},{user_id:'owner-b'},{bank_version:'v2'},{expires_at:'2026-10-08T13:30:00Z'}]) {
    assert.equal(await validNonce(nonce,nonceMessage({...serverAttempt,...changed}),secret),false);
  }
  assert.equal(await validNonce(nonce,nonceMessage(serverAttempt),'different-secret'),false);
  assert.equal(await validNonce('forged',nonceMessage(serverAttempt),secret),false);
  assert.notEqual(await digest(nonce),await digest('forged'));
});
test('authoritative option indices determine correctness; client score cannot influence it', () => {
  assert.deepEqual(verifyAnswers(attempt,lesson,answers,'v1',now),{correct:5,total:5});
  assert.deepEqual(verifyAnswers(attempt,lesson,{...answers,q0:1},'v1',now),{correct:4,total:5});
  assert.throws(() => verifyAnswers(attempt,lesson,{...answers,score:99999},'v1',now),/unexpected_question/);
});
test('reject altered bank version, missing/duplicate questions and expired proofs', () => {
  assert.throws(() => verifyAnswers(attempt,lesson,answers,'v2',now),/source_version_changed/);
  assert.throws(() => verifyAnswers(attempt,lesson,answers,'v1',Date.parse(attempt.expires_at)),/expired_attempt/);
  assert.throws(() => verifyAnswers({...attempt,question_ids:['q0','q0','q1','q2','q3']},lesson,answers,'v1',now),/invalid_attempt_bank/);
  assert.throws(() => verifyAnswers(attempt,{questions:[]},answers,'v1',now),/missing_authoritative_question/);
});
test('require exact complete question coverage and integer in-range selections', () => {
  for (const value of [-1,4,1.5,'0',null,true,{correctIndex:0}]) {
    assert.throws(() => verifyAnswers(attempt,lesson,{...answers,q0:value},'v1',now),/invalid_answer_index/);
  }
  const missing = {...answers}; delete missing.q0;
  assert.throws(() => verifyAnswers(attempt,lesson,missing,'v1',now),/unexpected_question/);
  assert.throws(() => verifyAnswers(attempt,lesson,[], 'v1',now),/invalid_answers/);
});
test('season rules exclude repeats and limit awards without speed/client-XP inputs', () => {
  assert.equal(eligibleAward({correct:4,alreadyAwarded:false,seasonPoints:190}),10);
  assert.equal(eligibleAward({correct:3,alreadyAwarded:false,seasonPoints:0}),0);
  assert.equal(eligibleAward({correct:5,alreadyAwarded:true,seasonPoints:10}),0);
  assert.equal(eligibleAward({correct:5,alreadyAwarded:false,seasonPoints:200}),0);
});
test('competition ties are 1,1,3 and stable ordering does not add a speed tiebreaker', () => {
  assert.deepEqual(rankRows([{member_id:'c',points:5},{member_id:'b',points:10},{member_id:'a',points:10}])
    .map(r => [r.member_id,r.rank]),[['a',1],['b',1],['c',3]]);
});
const sqlName = readdirSync(new URL('../supabase/migrations/',import.meta.url)).find(n => n.endsWith('_private_verified_leagues.sql'));
const sql = readFileSync(new URL(`../supabase/migrations/${sqlName}`,import.meta.url),'utf8');
const edge = readFileSync(new URL('../supabase/functions/verified-leagues/index.ts',import.meta.url),'utf8');
test('privacy follow-up explicitly denies server-only tables and indexes all twelve missing foreign-key lookups', () => {
  const name = readdirSync(new URL('../supabase/migrations/',import.meta.url)).find(n => n.endsWith('_league_privacy_indexes.sql'));
  const followup = readFileSync(new URL(`../supabase/migrations/${name}`,import.meta.url),'utf8');
  assert.equal((followup.match(/create index /g) ?? []).length,12);
  for (const table of ['cohorts','seasons','reports']) {
    assert.match(followup,new RegExp(`create policy league_${table}_server_only on public\\.league_${table}\\s+as restrictive for all to anon, authenticated using \\(false\\) with check \\(false\\)`));
  }
  assert.match(followup,/league_receipts\(user_id\)/);
  assert.match(followup,/league_memberships\(user_id\)/);
});
test('six eligible lesson opportunities can reach every calibrated private tier without changing point awards', () => {
  const name = readdirSync(new URL('../supabase/migrations/',import.meta.url)).find(n => n.endsWith('_league_tier_calibration.sql'));
  const followup = readFileSync(new URL(`../supabase/migrations/${name}`,import.meta.url),'utf8');
  assert.match(followup,/create or replace function public\.league_finish_verified/);
  assert.match(followup,/\('Explorer',10\),\('Pathfinder',20\),\('Scholar',30\),\('Specialist',40\),\('Master',60\)/);
  assert.match(followup,/award := 10/);
  assert.match(followup,/>= 200/);
  assert.match(followup,/security invoker set search_path = ''/);
  assert.match(followup,/from public, anon, authenticated/);
});
test('all exposed league tables have RLS; client grants are read-only and owner restricted', () => {
  const tables = [...sql.matchAll(/create table public\.(league_\w+)/g)].map(m => m[1]);
  assert.equal(tables.length,9);
  for (const table of tables) assert.ok(sql.includes(`alter table public.${table} enable row level security`));
  assert.match(sql,/revoke all on public\.league_eligibility[\s\S]*?from anon, authenticated/);
  assert.equal(/grant (?:all|insert|update|delete)[^;]*to authenticated/i.test(sql),false);
  for (const policy of sql.matchAll(/create policy[^;]+;/g)) assert.match(policy[0],/auth\.uid\(\)\) = user_id/);
});
test('privileged RPCs deny public/client execution and use an empty search path', () => {
  for (const name of ['league_finish_verified','league_delete_display','league_board_rows']) {
    assert.match(sql,new RegExp(`revoke all on function public\\.${name}\\([^;]+from public, anon, authenticated`));
    assert.match(sql,new RegExp(`grant execute on function public\\.${name}\\([^;]+to service_role`));
  }
  assert.equal(/security definer/i.test(sql),false);
  assert.equal((sql.match(/security invoker set search_path = ''/g) ?? []).length,3);
});
test('receipt finalization serializes caps, deduplicates lesson events and checks server time', () => {
  assert.match(sql,/pg_advisory_xact_lock/);
  assert.match(sql,/unique index league_once_per_lesson/);
  assert.match(sql,/attempt_id uuid primary key/);
  assert.match(sql,/now\(\) >= a\.expires_at/);
  assert.match(sql,/now\(\) < s\.ends_at/);
  assert.match(sql,/adult_or_guardian_approved/);
  assert.match(sql,/left_at is null/);
});
test('Edge authentication/admission excludes editable metadata and private cohort cross-access', () => {
  assert.match(edge,/admin\.auth\.getUser\(bearer\)/);
  assert.match(edge,/auth\.user\.is_anonymous/);
  assert.match(edge,/\.from\('demo_access'\)/);
  assert.match(edge,/\.from\('league_eligibility'\)/);
  assert.equal(/user_metadata|userMetadata/.test(edge),false);
  assert.match(edge,/memberships\.find\(m => m\.cohort_id === cohortId\)/);
  assert.match(edge,/approved_membership_required/);
  assert.match(edge,/verifyAnswers\(attempt,lesson,body\.answers,bank\.version,Date\.now\(\)\)/);
  assert.equal(/body\.(?:score|xp|points|correctIndex|correct)/.test(edge),false);
});
test('bank manifest contains actual authored items in 39 separate subject-grade cohorts', () => {
  const bank = JSON.parse(readFileSync(new URL('../supabase/functions/verified-leagues/ranked-bank.json',import.meta.url),'utf8'));
  assert.match(bank.version,/^authored-[a-f0-9]+$/);
  assert.equal(bank.lessons.length,234);
  const opportunities = new Map();
  for (const lesson of bank.lessons) {
    const cohort=`${lesson.subject}.${lesson.grade}`;
    opportunities.set(cohort,(opportunities.get(cohort) ?? 0)+1);
  }
  assert.equal(opportunities.size,39);
  for (const count of opportunities.values()) assert.equal(count,6,'tier calibration must be reviewed if eligible cohort content changes');
  assert.equal(new Set(bank.lessons.map(l => l.id)).size,bank.lessons.length);
  for (const lesson of bank.lessons) {
    assert.ok(['science','mathematics','english'].includes(lesson.subject));
    assert.ok(lesson.questions.length >= 5);
    assert.equal(new Set(lesson.questions.map(q => q.id)).size,lesson.questions.length);
    for (const question of lesson.questions) {
      assert.ok(question.prompt.trim().length > 0);
      if (question.prompt.length <= 10) {
        // Compact Grade 1 arithmetic is complete instruction, even at 9 chars.
        assert.equal(lesson.subject,'mathematics');
        const expression=question.prompt.match(/^(\d+)\s*([+−])\s*(\d+)\s*=\s*\?$/);
        assert.ok(expression,question.id);
        const result=expression[2]==='+' ? Number(expression[1])+Number(expression[3]) : Number(expression[1])-Number(expression[3]);
        assert.equal(Number(question.options[question.correctIndex]),result,question.id);
      }
      assert.ok(question.correctIndex >= 0 && question.correctIndex < question.options.length);
      assert.equal(question.options.length,new Set(question.options).size);
    }
  }
});
