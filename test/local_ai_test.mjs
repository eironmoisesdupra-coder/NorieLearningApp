import test from 'node:test';
import assert from 'node:assert/strict';
import { generateStudySet, answerSource, buildSourceQuestion, postLocalJson } from '../local-ai/generator.mjs';
import { createLocalServer } from '../local-ai/server.mjs';
import { LocalJobQueue } from '../local-ai/jobs.mjs';
import { randomUUID } from 'node:crypto';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createServer, request } from 'node:http';

const notes = 'Taxonomy classifies organisms. Domain is the broadest main rank. A family contains related genera. Genus is directly above species. A kingdom contains several phyla. Phylogeny describes evolutionary relationships.';
const payload = { source_text: notes, question_count: 5, mode: 'identification', title: 'Taxonomy' };

test('source card preserves the answer and ignores invented model keys and prompts', () => {
  const passage = 'Family is immediately above genus.';
  const question = buildSourceQuestion(passage, { answer: 'Family', correct_values: ['Kingdom'], prompt: 'What kingdom is Eukarya?', explanation: 'Invented' });
  assert.equal(question.prompt, '_____ is immediately above genus.');
  assert.deepEqual(question.correct_values, ['Family']);
  assert.equal(question.explanation, passage);
  assert.equal(question.source_excerpt, passage);
  assert.equal(buildSourceQuestion(passage, { answer: 'Kingdom' }), null);
});

test('source cards reject ambiguous and partial-word answers and preserve negation', () => {
  assert.equal(buildSourceQuestion('Genus contains species within that genus.', { answer: 'gen' }), null);
  assert.equal(buildSourceQuestion('A genus is a genus, not a species.', { answer: 'genus' }), null);
  assert.equal(buildSourceQuestion('Family is above genus.', { answer: 'Family is above genus.' }), null);
  assert.equal(buildSourceQuestion('_____ is above genus.', { answer: 'genus' }), null);
  assert.equal(buildSourceQuestion('Family is above genus.', { answer: 'Family' }, 'true_false'), null);
  const passage = 'Similar appearance alone does not prove a close evolutionary relationship.';
  assert.equal(buildSourceQuestion(passage, { answer: 'Similar appearance' }).prompt,
    '_____ alone does not prove a close evolutionary relationship.');
});

test('multiple choice retains the source answer and rejects duplicate distractors', () => {
  const passage = 'Family is immediately above genus.';
  const question = buildSourceQuestion(passage, { answer: 'Family', distractors: ['Order', 'Species', 'Domain'], correct_values: ['Species'] }, 'single_select');
  assert.deepEqual(question.correct_values, ['Family']);
  assert.deepEqual(new Set(question.options), new Set(['Family', 'Order', 'Species', 'Domain']));
  assert.equal(buildSourceQuestion(passage, { answer: 'Family', distractors: ['family', 'Order', 'Domain'] }, 'single_select'), null);
  assert.equal(buildSourceQuestion(passage, { answer: 'Family', distractors: ['Order', 'order', 'Domain'] }, 'single_select'), null);
  assert.equal(buildSourceQuestion(passage, { answer: 'Family', distractors: ['Order'] }, 'single_select'), null);
});

test('local generator validates evidence, answer structure, and persisted deck shape', async () => {
  const infer = async (messages, schema) => {
    const { passages } = JSON.parse(messages[1].content);
    assert.equal(schema.properties.cards.minItems, passages.length);
    assert.equal(schema.properties.cards.maxItems, passages.length);
    return { cards: passages.map(passage => ({ source_index: passage.index, answer: passage.text.split(' ')[0], distractors: [], correct_values: ['Wrong model answer'] })) };
  };
  const deck = await generateStudySet(payload, { infer });
  assert.equal(deck.questions.length, 5);
  assert.equal(deck.user_id, 'local');
  assert.equal(new Set(deck.questions.map(question => question.id)).size, 5);
  assert.ok(deck.questions.every(question => notes.includes(question.source_excerpt)));
  assert.equal(deck.generation_method, 'source_span_v1');
  for (const question of deck.questions) {
    assert.equal(question.prompt.replace('_____', question.correct_values[0]), question.source_excerpt);
  }
});

test('invalid requests are rejected before inference', async () => {
  const infer = () => { throw new Error('Must not call model'); };
  await assert.rejects(generateStudySet({ ...payload, source_text: 'short' }, { infer }), /80/);
  await assert.rejects(generateStudySet({ ...payload, question_count: 100 }, { infer }), /Choose/);
  await assert.rejects(generateStudySet({ ...payload, source_type: 'image' }, { infer }), /notes only/);
  await assert.rejects(generateStudySet({ ...payload, mode: 'true_false' }, { infer }), /unavailable/);
});

test('invented excerpts and repeated passage use are rejected', async () => {
  await assert.rejects(generateStudySet(payload, { infer: async () => ({ cards: [{ source_index: 0, answer: 'Invented source material', distractors: [] }] }) }), /no usable/);
  const deck = await generateStudySet(payload, { infer: async () => ({ cards: [null, { source_index: 0, answer: 'Taxonomy' }, { source_index: 0, answer: 'organisms' }] }) });
  assert.equal(deck.questions.length, 1);
  assert.deepEqual(deck.questions[0].correct_values, ['Taxonomy']);
});

test('source cards bound inference attempts and try spare passages after rejected selections', async () => {
  let calls = 0;
  const deck = await generateStudySet(payload, { infer: async messages => {
    calls += 1;
    const { passages } = JSON.parse(messages[1].content);
    return { cards: passages.map(passage => ({ source_index: passage.index, answer: passage.index === 0 ? 'Invented' : passage.text.split(' ')[0], distractors: [] })) };
  } });
  assert.equal(deck.questions.length, 5);
  assert.equal(calls, 3);
});

test('rejected selections cannot cause unbounded model calls', async () => {
  let calls = 0;
  const source = Array.from({ length: 50 }, (_, index) => `The number ${index} is a nonnegative integer.`).join(' ');
  await assert.rejects(generateStudySet({ ...payload, source_text: source }, {
    infer: async () => { calls += 1; return { cards: [] }; },
  }), /no usable/);
  assert.equal(calls, 5);
});

test('local HTTP transport enforces its own deadline and rejects invalid JSON and external hosts', async () => {
  const server = createServer((req, res) => {
    req.resume();
    if (req.url === '/hang') return;
    if (req.url === '/invalid') { res.end('not JSON'); return; }
    if (req.url === '/oversized') { res.end('x'.repeat(2 * 1024 * 1024 + 1)); return; }
    res.writeHead(201, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ready: true }));
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  try {
    assert.deepEqual(await postLocalJson(base, {}), { status: 201, body: { ready: true } });
    await assert.rejects(postLocalJson(base + '/hang', {}, { timeoutMs: 30 }), /timed out/);
    await assert.rejects(postLocalJson(base + '/invalid', {}), /invalid JSON/);
    await assert.rejects(postLocalJson(base + '/oversized', {}), /size limit/);
    await assert.rejects(postLocalJson('https://example.com', {}), /loopback/);
    await assert.rejects(postLocalJson('http://user@localhost', {}), /loopback/);
    await assert.rejects(postLocalJson(base, {}, { signal: AbortSignal.abort() }), /abort/i);
  } finally {
    server.closeAllConnections();
    await new Promise(resolve => server.close(resolve));
  }
});

test('source Q&A abstains without a matching quote', async () => {
  assert.match(await answerSource(notes, 'What is gravity?', { infer: async () => ({ answer: 'Unsupported answer', source_excerpt: 'Invented quote' }) }), /not provide enough/);
  assert.match(await answerSource(notes, 'What is gravity?', { infer: async () => ({ source_index: -1 }) }), /not provide enough/);
  assert.match(await answerSource(notes, 'What is gravity?', { infer: async () => ({ source_index: 900 }) }), /not provide enough/);
});

test('source Q&A quotes a selected passage and ignores invented answer text', async () => {
  const result = await answerSource(notes, 'What does a family contain?', {
    infer: async messages => {
      const { passages } = JSON.parse(messages[1].content);
      return { source_index: passages.find(passage => passage.text === 'A family contains related genera.').index,
        answer: 'A family is the broadest rank.', source_excerpt: 'Fabricated quotation' };
    },
  });
  assert.equal(result, 'A family contains related genera.\n\nSource: "A family contains related genera."');
});

test('durable queue accepts twelve independent requests and bounds simultaneous execution', async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-queue-test-'));
  const gate = Promise.withResolvers();
  let active = 0;
  let peak = 0;
  let calls = 0;
  let queue = new LocalJobQueue({ storeDir, concurrency: 2, capacity: 12, execute: async (_kind, input, { onProgress }) => {
    calls += 1;
    active += 1;
    peak = Math.max(peak, active);
    onProgress({ accepted: 1 });
    await gate.promise;
    active -= 1;
    if (input.title === 'request-3') throw new Error('Simulated private runtime failure');
    return { title: input.title };
  } });
  const keys = Array.from({ length: 12 }, () => randomUUID());
  try {
    const jobs = keys.map((key, index) => queue.submit('generate', { title: `request-${index}` }, key));
    assert.equal(queue.stats().active, 2);
    assert.equal(queue.stats().queued, 10);
    assert.equal(queue.submit('generate', { title: 'request-0' }, keys[0]).id, jobs[0].id);
    assert.throws(() => queue.submit('generate', { title: 'changed' }, keys[0]), error => error.status === 409);
    assert.throws(() => queue.submit('generate', { title: 'overflow' }, randomUUID()), error => error.status === 429);
    assert.throws(() => queue.get(jobs[0].id, keys[1]), error => error.status === 404);
    assert.equal(queue.cancel(jobs[11].id, keys[11]).status, 'cancelled');
    const completion = Promise.all(jobs.map((job, index) => queue.wait(job.id, keys[index])));
    gate.resolve();
    const results = await completion;
    assert.equal(peak, 2);
    assert.equal(calls, 11);
    assert.equal(results[3].status, 'failed');
    assert.doesNotMatch(results[3].error, /private/);
    assert.equal(results[11].status, 'cancelled');
    for (const [index, result] of results.entries()) {
      if (![3, 11].includes(index)) assert.deepEqual(result.result, { title: `request-${index}` });
    }
    await queue.close();
    queue = new LocalJobQueue({ storeDir, execute: async () => { throw new Error('Do not rerun completed jobs'); } });
    assert.deepEqual(queue.get(jobs[0].id, keys[0]).result, { title: 'request-0' });
  } finally {
    gate.resolve();
    await queue.close();
    await rm(storeDir, { recursive: true, force: true });
  }
});

test('restart resumes queued work and marks interrupted running work as failed', async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-restart-'));
  let queue = new LocalJobQueue({ storeDir, execute: async (_kind, _input, { signal }) => {
    await new Promise((_resolve, reject) => signal.addEventListener('abort', () => reject(signal.reason), { once: true }));
  } });
  const runningKey = randomUUID();
  const queuedKey = randomUUID();
  try {
    const running = queue.submit('generate', { title: 'interrupted' }, runningKey);
    const queued = queue.submit('generate', { title: 'resume me' }, queuedKey);
    await queue.close();
    queue = new LocalJobQueue({ storeDir, execute: async (_kind, input) => ({ title: input.title }) });
    assert.equal(queue.get(running.id, runningKey).status, 'failed');
    assert.match(queue.get(running.id, runningKey).error, /restarted/);
    assert.deepEqual((await queue.wait(queued.id, queuedKey)).result, { title: 'resume me' });
  } finally {
    await queue.close();
    await rm(storeDir, { recursive: true, force: true });
  }
});

test('execution deadlines abort work and allow the next job to finish', async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-deadline-'));
  const queue = new LocalJobQueue({ storeDir, runTimeoutMs: 30, execute: async (_kind, input, { signal }) => {
    if (input.hang) await new Promise((_resolve, reject) => signal.addEventListener('abort', () => reject(signal.reason), { once: true }));
    return { completed: true };
  } });
  try {
    const firstKey = randomUUID();
    const secondKey = randomUUID();
    const first = queue.submit('generate', { hang: true }, firstKey);
    const second = queue.submit('generate', { hang: false }, secondKey);
    assert.match((await queue.wait(first.id, firstKey)).error, /deadline/);
    assert.equal((await queue.wait(second.id, secondKey)).status, 'succeeded');
  } finally {
    await queue.close();
    await rm(storeDir, { recursive: true, force: true });
  }
});

test('running cancellation retains its worker slot until execution actually stops', async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-cancel-'));
  const gate = Promise.withResolvers();
  let calls = 0;
  const queue = new LocalJobQueue({ storeDir, execute: async () => { calls += 1; await gate.promise; return { completed: true }; } });
  try {
    const firstKey = randomUUID();
    const secondKey = randomUUID();
    const first = queue.submit('generate', {}, firstKey);
    assert.equal(queue.cancel(first.id, firstKey).status, 'cancelled');
    const second = queue.submit('generate', {}, secondKey);
    assert.equal(calls, 1);
    assert.equal(queue.stats().active, 1);
    gate.resolve();
    assert.equal((await queue.wait(second.id, secondKey)).status, 'succeeded');
    assert.equal(queue.get(first.id, firstKey).result, null);
  } finally {
    gate.resolve();
    await queue.close();
    await rm(storeDir, { recursive: true, force: true });
  }
});

test('shutdown waits for active worker cleanup before closing storage', async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-shutdown-'));
  const gate = Promise.withResolvers();
  let closed = false;
  const queue = new LocalJobQueue({ storeDir, execute: async () => { await gate.promise; return {}; } });
  try {
    queue.submit('generate', {}, randomUUID());
    const closing = queue.close().then(() => { closed = true; });
    await new Promise(resolve => setImmediate(resolve));
    assert.equal(closed, false);
    gate.resolve();
    await closing;
    assert.equal(closed, true);
  } finally {
    gate.resolve();
    await queue.close();
    await rm(storeDir, { recursive: true, force: true });
  }
});

test('generation propagates cancellation instead of returning late results', async () => {
  const controller = new AbortController();
  await assert.rejects(generateStudySet(payload, { signal: controller.signal, infer: async (_messages, _schema, options) => {
    assert.equal(options.signal, controller.signal);
    controller.abort(new Error('Cancelled test request'));
    return { cards: [] };
  } }), /Cancelled test request/);
});

test('local server rejects external origins and persists a generated deck', async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-local-test-'));
  const id = '73d3b0b0-5f17-432b-bec5-06c83caa6f95';
  const server = createLocalServer({ storeDir, generate: async () => ({ id, questions: [] }), answer: async source => source });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  const post = (route, value, headers = {}) => fetch(base + route, { method: 'POST', headers: { 'Content-Type': 'application/json', ...headers }, body: JSON.stringify(value) });
  try {
    assert.equal((await post('/api/generate', payload, { Origin: 'https://untrusted.example' })).status, 403);
    const forgedHostStatus = await new Promise((resolve, reject) => {
      const req = request(base + '/api/generate', { method: 'POST', headers: { Host: 'untrusted.example' } }, response => {
        response.resume();
        resolve(response.statusCode);
      });
      req.on('error', reject);
      req.end();
    });
    assert.equal(forgedHostStatus, 403);
    assert.equal((await post('/api/generate', payload)).status, 200);
    assert.equal((await (await post('/api/ask', { study_set_id: id, question: 'What is taxonomy?' })).json()).answer, notes);
    assert.equal((await post('/api/ask', { study_set_id: '../private', question: 'anything' })).status, 400);
    assert.equal((await fetch(`${base}/api/sets/${id}`, { method: 'DELETE' })).status, 200);
    assert.equal((await post('/api/ask', { study_set_id: id, question: 'anything' })).status, 404);
  } finally {
    await server.jobQueue.close();
    await new Promise(resolve => server.close(resolve));
    await rm(storeDir, { recursive: true, force: true });
  }
});

test('HTTP job submissions return immediately and keep ten results independent', { timeout: 10000 }, async () => {
  const storeDir = await mkdtemp(join(tmpdir(), 'norie-http-jobs-'));
  const gate = Promise.withResolvers();
  let calls = 0;
  const server = createLocalServer({ storeDir, concurrency: 2, capacity: 10, generate: async input => {
    calls += 1;
    await gate.promise;
    return { id: randomUUID(), title: input.title, questions: [] };
  } });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  const keys = Array.from({ length: 10 }, () => randomUUID());
  const submit = (input, key) => fetch(base + '/api/jobs', { method: 'POST', headers: {
    'Content-Type': 'application/json', 'X-Norie-Job-Key': key,
  }, body: JSON.stringify({ kind: 'generate', input }) });
  try {
    const responses = await Promise.all(keys.map((key, index) => submit({ ...payload, title: `request-${index}` }, key)));
    assert.ok(responses.every(response => response.status === 202));
    const jobs = await Promise.all(responses.map(response => response.json()));
    assert.equal(calls, 2);
    assert.equal((await submit({ ...payload, title: 'overflow' }, randomUUID())).status, 429);
    assert.equal((await submit({ ...payload, source_text: 'short' }, randomUUID())).status, 400);
    const same = await (await submit({ ...payload, title: 'request-0' }, keys[0])).json();
    assert.equal(same.id, jobs[0].id);
    assert.equal((await fetch(`${base}/api/jobs/${jobs[0].id}`, { headers: { 'X-Norie-Job-Key': keys[1] } })).status, 404);
    assert.equal((await fetch(`${base}/api/jobs/${jobs[0].id}`, { headers: { 'X-Norie-Job-Key': keys[0], Origin: 'https://untrusted.example' } })).status, 403);
    gate.resolve();
    await Promise.all(jobs.map((job, index) => server.jobQueue.wait(job.id, keys[index])));
    for (const [index, job] of jobs.entries()) {
      const response = await fetch(`${base}/api/jobs/${job.id}`, { headers: { 'X-Norie-Job-Key': keys[index] } });
      const completed = await response.json();
      assert.equal(completed.status, 'succeeded');
      assert.equal(completed.result.title, `request-${index}`);
      assert.equal(completed.input, undefined);
    }
    assert.equal(calls, 10);
  } finally {
    gate.resolve();
    await server.jobQueue.close();
    await new Promise(resolve => server.close(resolve));
    await rm(storeDir, { recursive: true, force: true });
  }
});