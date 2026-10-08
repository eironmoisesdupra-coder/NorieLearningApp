import { createClient } from '@supabase/supabase-js';
import bank from './ranked-bank.json' with { type: 'json' };
import { verifyAnswers, rankRows } from './verification.mjs';
import { digest, nonceMessage, signNonce, validNonce, resolveNonceSecret } from './nonce.mjs';

const cors = { 'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type' };
const reply = (data: unknown, status = 200) => new Response(JSON.stringify(data),
  {status, headers: {...cors, 'Content-Type': 'application/json'}});
function checked<T>(result: {data:T,error:unknown}): T {
  if (result.error) throw new Error('backend_request_failed');
  return result.data;
}
function stringField(body: Record<string,unknown>, key: string, limit = 100) {
  const value = body[key];
  if (typeof value !== 'string' || !value || value.length > limit) throw new Error('invalid_request');
  return value;
}

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return reply({});
  if (request.method !== 'POST') return reply({error:'method_not_allowed'},405);
  try {
    const url = Deno.env.get('SUPABASE_URL'), key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!url || !key) return reply({error:'league_backend_not_configured'},503);
    const secret = await resolveNonceSecret(key,Deno.env.get('LEAGUE_NONCE_SECRET'));
    const bearer = request.headers.get('Authorization')?.match(/^Bearer (.+)$/)?.[1];
    if (!bearer) return reply({error:'account_required'},401);
    const admin = createClient(url,key,{auth:{persistSession:false,autoRefreshToken:false}});
    const {data: auth, error: authError} = await admin.auth.getUser(bearer);
    if (authError || !auth.user || auth.user.is_anonymous) return reply({error:'account_required'},401);
    const user = auth.user;
    if (Number(request.headers.get('content-length') ?? 0) > 20000) return reply({error:'request_too_large'},413);
    const text = await request.text();
    if (text.length > 20000) return reply({error:'request_too_large'},413);
    const body = JSON.parse(text) as Record<string,unknown>;
    const action = stringField(body,'action');
    const allowed = ['boards','badges','equip_badge','lessons','open','finish','opt_in','join_request','report','leave','delete_display'];
    if (!allowed.includes(action)) return reply({error:'unknown_action'},400);
    // Cleanup remains accessible after eligibility is revoked.
    if (action === 'delete_display') {
      checked(await admin.rpc('league_delete_display',{p_user:user.id}));
      return reply({removed:true});
    }
    if (action === 'leave') {
      const cohortId = stringField(body,'cohort_id');
      checked(await admin.from('league_memberships').update({opted_in:false,left_at:new Date().toISOString()})
        .eq('user_id',user.id).eq('cohort_id',cohortId));
      checked(await admin.from('league_join_requests').delete().eq('user_id',user.id).eq('cohort_id',cohortId));
      return reply({left:true});
    }
    const demo = checked(await admin.from('demo_access').select('email').eq('email',user.email?.toLowerCase() ?? '').maybeSingle());
    const eligibility = checked(await admin.from('league_eligibility').select('adult_or_guardian_approved,approved_at,revoked_at').eq('user_id',user.id).maybeSingle());
    if (!demo || !eligibility?.adult_or_guardian_approved || !eligibility.approved_at || eligibility.revoked_at) {
      return reply({error:'administrator_approval_required'},403);
    }
    if (action === 'badges') {
      const badges = checked(await admin.from('league_badges').select('id,cohort_id,season_id,tier,title,earned_at')
        .eq('user_id',user.id).order('earned_at',{ascending:false}));
      return reply({badges});
    }
    if (action === 'join_request') {
      const inviteHash = await digest(stringField(body,'code',64));
      const cohort = checked(await admin.from('league_cohorts').select('id').eq('invite_hash',inviteHash).eq('closed',false).maybeSingle());
      if (!cohort) return reply({error:'invitation_unavailable'},404);
      checked(await admin.from('league_join_requests').upsert({user_id:user.id,cohort_id:cohort.id}, {onConflict:'user_id,cohort_id'}));
      return reply({pending_approval:true});
    }
    const memberships = checked(await admin.from('league_memberships').select('id,cohort_id,opted_in')
      .eq('user_id',user.id).not('approved_at','is',null).is('left_at',null)) ?? [];
    if (action === 'boards') {
      const boards = [];
      for (const member of memberships) {
        const cohort = checked(await admin.from('league_cohorts').select('id,title,subject,grade,season_id').eq('id',member.cohort_id).single());
        if (!cohort) throw new Error('backend_request_failed');
        const season = checked(await admin.from('league_seasons').select('ends_at').eq('id',cohort.season_id).single());
        if (!season) throw new Error('backend_request_failed');
        const rows = checked(await admin.rpc('league_board_rows',{p_cohort:cohort.id,p_viewer:user.id}));
        boards.push({cohort_id:cohort.id,title:cohort.title,subject:cohort.subject,grade:cohort.grade,
          season_end:season.ends_at,fetched_at:new Date().toISOString(),opted_in:member.opted_in,rows:rankRows(rows)});
      }
      return reply({boards});
    }
    if (action === 'finish') {
      const attemptId = stringField(body,'attempt_id'), nonce = stringField(body,'nonce');
      const attempt = checked(await admin.from('league_attempts').select('*').eq('id',attemptId).eq('user_id',user.id).maybeSingle());
      if (!attempt || !memberships.some(m => m.cohort_id === attempt.cohort_id && m.opted_in)) return reply({error:'invalid_attempt'},403);
      const proof = nonceMessage(attempt);
      if (!await validNonce(nonce,proof,secret) || attempt.nonce_hash !== await digest(nonce)) return reply({error:'invalid_nonce'},403);
      // A lost HTTP response can replay the receipt even after the expiry.
      const prior = checked(await admin.from('league_receipts').select('correct,total,points,reason').eq('attempt_id',attempt.id).maybeSingle());
      if (prior) return reply(prior);
      const lesson = bank.lessons.find(l => l.id === attempt.lesson_id);
      if (!lesson) return reply({error:'source_version_changed'},409);
      const result = verifyAnswers(attempt,lesson,body.answers,bank.version,Date.now());
      const receipt = checked(await admin.rpc('league_finish_verified',{p_attempt:attempt.id,p_user:user.id,
        p_nonce_hash:await digest(nonce),p_bank_version:bank.version,p_correct:result.correct}));
      return reply({correct:receipt.correct,total:receipt.total,points:receipt.points,reason:receipt.reason});
    }
    const cohortId = stringField(body,'cohort_id');
    const member = memberships.find(m => m.cohort_id === cohortId);
    if (!member) return reply({error:'approved_membership_required'},403);
    if (action === 'equip_badge') {
      const badgeId = body.badge_id === null ? null : stringField(body,'badge_id');
      if (badgeId) {
        const badge = checked(await admin.from('league_badges').select('id').eq('id',badgeId).eq('user_id',user.id).maybeSingle());
        if (!badge) return reply({error:'owned_badge_required'},403);
      }
      checked(await admin.from('league_memberships').update({equipped_badge_id:badgeId}).eq('id',member.id).eq('user_id',user.id));
      return reply({equipped:true});
    }
    if (action === 'opt_in') {
      if (typeof body.enabled !== 'boolean') return reply({error:'invalid_request'},400);
      checked(await admin.from('league_memberships').update({opted_in:body.enabled}).eq('id',member.id).eq('user_id',user.id));
      return reply({opted_in:body.enabled});
    }
    if (action === 'report') {
      const target = checked(await admin.from('league_memberships').select('id').eq('id',stringField(body,'member_id')).eq('cohort_id',cohortId).eq('opted_in',true).is('left_at',null).maybeSingle());
      if (!target) return reply({error:'display_unavailable'},404);
      checked(await admin.from('league_reports').upsert({reporter_id:user.id,cohort_id:cohortId,member_id:target.id}, {onConflict:'reporter_id,cohort_id,member_id'}));
      return reply({reported:true});
    }
    const cohort = checked(await admin.from('league_cohorts').select('*').eq('id',cohortId).single());
    const season = checked(await admin.from('league_seasons').select('*').eq('id',cohort.season_id).single());
    if (cohort.closed || Date.now() < Date.parse(season.starts_at) || Date.now() >= Date.parse(season.ends_at)) return reply({error:'season_closed'},409);
    if (season.bank_version !== bank.version) return reply({error:'source_version_changed'},409);
    const lessons = bank.lessons.filter(l => l.subject === cohort.subject && l.grade === cohort.grade);
    if (action === 'lessons') return reply({lessons:lessons.map(l => ({id:l.id,title:l.title}))});
    if (!member.opted_in) return reply({error:'opt_in_required'},403);
    const lesson = lessons.find(l => l.id === stringField(body,'lesson_id'));
    if (!lesson) return reply({error:'ineligible_lesson'},400);
    const questions = [...lesson.questions];
    for (let i = questions.length - 1; i > 0; i--) {
      const random = crypto.getRandomValues(new Uint32Array(1))[0];
      const j = random % (i + 1); [questions[i],questions[j]] = [questions[j],questions[i]];
    }
    const selected = questions.slice(0,5);
    const attemptId = crypto.randomUUID();
    const expires = new Date(Math.min(Date.now() + 30 * 60 * 1000,Date.parse(season.ends_at))).toISOString();
    // Bind to an epoch value: PostgreSQL may strip fractional trailing zeros.
    const expiresDb = expires.replace('Z','+00:00');
    const nonce = await signNonce(nonceMessage({id:attemptId,user_id:user.id,
      bank_version:bank.version,expires_at:expiresDb}),secret);
    checked(await admin.from('league_attempts').insert({id:attemptId,user_id:user.id,cohort_id:cohortId,
      season_id:season.id,lesson_id:lesson.id,bank_version:bank.version,question_ids:selected.map(q => q.id),
      nonce_hash:await digest(nonce),expires_at:expiresDb}));
    return reply({attempt_id:attemptId,nonce,expires_at:expires,source_version:bank.version,
      questions:selected.map(q => ({id:q.id,prompt:q.prompt,options:q.options}))});
  } catch (error) {
    const message = error instanceof Error ? error.message : 'league_request_failed';
    // Explicit validation failures are useful; database/auth details never leak.
    const safe = ['league_backend_not_configured','expired_attempt','source_version_changed','unexpected_question','invalid_answers',
      'invalid_answer_index','missing_authoritative_question','invalid_attempt_bank','invalid_request'];
    return reply({error:safe.includes(message) ? message : 'league_request_failed'},message === 'league_backend_not_configured' ? 503 : 400);
  }
});
