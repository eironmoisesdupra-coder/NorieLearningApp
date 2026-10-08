// Pure verifier shared by the Edge Function and Node tests. It receives ONLY
// server-loaded bank questions and attempt IDs; clients submit option indices.
export function verifyAnswers(attempt, lesson, answers, bankVersion, now) {
  if (attempt.bank_version !== bankVersion) throw new Error('source_version_changed');
  if (Date.parse(attempt.expires_at) <= now) throw new Error('expired_attempt');
  if (!answers || typeof answers !== 'object' || Array.isArray(answers)) throw new Error('invalid_answers');
  const ids = attempt.question_ids;
  if (!Array.isArray(ids) || ids.length !== 5 || new Set(ids).size !== 5) throw new Error('invalid_attempt_bank');
  if (Object.keys(answers).length !== ids.length || Object.keys(answers).some(id => !ids.includes(id))) {
    throw new Error('unexpected_question');
  }
  let correct = 0;
  for (const id of ids) {
    const question = lesson.questions.find(q => q.id === id);
    if (!question) throw new Error('missing_authoritative_question');
    const value = answers[id];
    if (!Number.isInteger(value) || value < 0 || value >= question.options.length) throw new Error('invalid_answer_index');
    if (value === question.correctIndex) correct++;
  }
  return {correct, total: ids.length};
}

export function eligibleAward({correct, alreadyAwarded, seasonPoints}) {
  return correct >= 4 && !alreadyAwarded && seasonPoints < 200 ? 10 : 0;
}

export function rankRows(rows) {
  const sorted = [...rows].sort((a,b) => b.points - a.points || a.member_id.localeCompare(b.member_id));
  return sorted.map(row => ({...row, rank: 1 + sorted.filter(other => other.points > row.points).length}));
}
