import assert from 'node:assert/strict';
import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { normalizeQuestions } from '../supabase/functions/generate-study-set/questions.mjs';
import { postLocalJson } from './generator.mjs';

const base = 'http://127.0.0.1:8752';
const input = JSON.parse(await readFile(new URL('./taxonomy.json', import.meta.url), 'utf8'));
const started = Date.now();
console.log('Requesting 20 Taxonomy questions from the real local model...');
const response = await postLocalJson(`${base}/api/generate`, input, { timeoutMs: 1200000 });
const set = response.body;
assert.equal(response.status, 200, JSON.stringify(set));
const directory = new URL('../build/local-ai-proof/', import.meta.url);
await mkdir(directory, { recursive: true });
await writeFile(new URL('taxonomy-deck.json', directory), JSON.stringify(set, null, 2));
assert.equal(normalizeQuestions(set.questions, { count: 20, mode: input.mode, sourceText: input.source_text }).length, set.questions.length);
assert.equal(set.generation_method, 'source_span_v1');
for (const question of set.questions) {
  assert.equal(question.correct_values.length, 1);
  assert.equal(question.prompt.replace('_____', question.correct_values[0]), question.source_excerpt);
  assert.ok(input.source_text.includes(question.source_excerpt));
  assert.equal(question.explanation, question.source_excerpt);
}
console.log(`Model: ${set.ai_model}; generated: ${set.questions.length}/20; seconds: ${((Date.now() - started) / 1000).toFixed(1)}`);
for (const [index, question] of set.questions.entries()) console.log(`${index + 1}. [${question.kind}] ${question.prompt}\n   Answer: ${question.correct_values.join(' / ')}\n   Evidence: ${question.source_excerpt}`);
assert.equal(set.questions.length, 20, 'Partial generation: inspect rejected passages before claiming the full proof passed.');
const ask = await postLocalJson(`${base}/api/ask`, { study_set_id: set.id, question: 'Which rank is immediately above genus?' });
const answer = ask.body;
assert.equal(ask.status, 200);
assert.match(answer.answer, /family/i);
console.log(`Source Q&A: ${answer.answer}`);
console.log('PASS: real local inference, 20 source-preserved answers, persisted source, source Q&A. Human content review still required.');