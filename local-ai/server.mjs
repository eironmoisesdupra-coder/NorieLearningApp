import { createServer } from 'node:http';
import { readFile, writeFile, mkdir, rename, unlink } from 'node:fs/promises';
import { resolve, join, extname, sep } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { homedir } from 'node:os';
import { randomUUID } from 'node:crypto';
import { generateStudySet, answerSource, defaultModel, validateGenerationInput } from './generator.mjs';
import { LocalJobQueue } from './jobs.mjs';

const project = fileURLToPath(new URL('../', import.meta.url));
const types = { '.html': 'text/html', '.js': 'text/javascript', '.json': 'application/json', '.css': 'text/css', '.wasm': 'application/wasm', '.png': 'image/png', '.svg': 'image/svg+xml', '.ttf': 'font/ttf', '.woff2': 'font/woff2' };
const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export function createLocalServer({
  model = process.env.NORIE_LOCAL_MODEL || defaultModel,
  webRoot = resolve(project, 'build/local-web'),
  storeDir = join(process.env.LOCALAPPDATA || homedir(), 'NorieLearning', 'local-ai'),
  generate = generateStudySet,
  answer = answerSource,
  concurrency = Number(process.env.NORIE_LOCAL_CONCURRENCY || 1),
  capacity = Number(process.env.NORIE_LOCAL_QUEUE_CAPACITY || 32),
} = {}) {
  const jobs = new LocalJobQueue({ storeDir, concurrency, capacity, execute: async (kind, input, { signal, onProgress }) => {
    if (kind === 'ask') {
      const saved = JSON.parse(await readFile(join(storeDir, `${input.study_set_id}.json`), 'utf8'));
      return { answer: await answer(saved.source, input.question, { model, signal }) };
    }
    const set = await generate(input, { model, signal, onProgress });
    signal.throwIfAborted();
    if (!uuid.test(set.id)) throw new Error('Invalid generated deck ID.');
    await mkdir(storeDir, { recursive: true });
    const filename = join(storeDir, `${set.id}.json`);
    const temporary = `${filename}.${randomUUID()}.tmp`;
    let saved = false;
    try {
      await writeFile(temporary, JSON.stringify({ set, source: input.source_text }), { mode: 0o600 });
      signal.throwIfAborted();
      await rename(temporary, filename);
      saved = true;
      signal.throwIfAborted();
      return set;
    } catch (error) {
      await unlink(temporary).catch(() => {});
      if (saved && signal.aborted) await unlink(filename).catch(() => {});
      throw error;
    }
  } });
  const validateJob = async (kind, input) => {
    if (kind === 'generate') { validateGenerationInput(input); return; }
    if (kind !== 'ask' || !input || !uuid.test(input.study_set_id)) throw new Error('Invalid local deck ID or job kind.');
    if (typeof input.question !== 'string' || !input.question.trim() || input.question.length > 1000) throw new Error('Enter a question of 1 to 1,000 characters.');
    await readFile(join(storeDir, `${input.study_set_id}.json`), 'utf8');
  };
  const server = createServer(async (req, res) => {
    const respond = (status, body) => {
      if (res.destroyed || res.writableEnded) return;
      if (status === 429) res.setHeader('Retry-After', '5');
      res.writeHead(status, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' });
      res.end(JSON.stringify(body));
    };
    const port = server.address().port;
    const hosts = [`127.0.0.1:${port}`, `localhost:${port}`];
    if (!hosts.includes(req.headers.host) ||
        (req.headers.origin && !hosts.some(host => req.headers.origin === `http://${host}`))) {
      respond(403, { error: 'Local requests only.' });
      return;
    }
    const pathname = new URL(req.url, 'http://127.0.0.1').pathname;
    const body = async () => {
      if (!req.headers['content-type']?.startsWith('application/json')) throw new Error('Use application/json.');
      const chunks = [];
      let length = 0;
      for await (const chunk of req) {
        length += chunk.length;
        if (length > 100000) throw new Error('Request is too large.');
        chunks.push(chunk);
      }
      return JSON.parse(Buffer.concat(chunks).toString('utf8'));
    };
    try {
      if (pathname === '/api/health' && req.method === 'GET') {
        const status = await fetch('http://127.0.0.1:11434/api/tags', { signal: AbortSignal.timeout(3000) }).then(response => response.json());
        const queue = jobs.stats();
        respond(200, { model, busy: queue.active > 0, queue, ready: status.models?.some(item => item.name === model) ?? false });
      } else if (pathname === '/api/jobs' && req.method === 'POST') {
        const request = await body();
        await validateJob(request?.kind, request?.input);
        respond(202, jobs.submit(request.kind, request.input, req.headers['x-norie-job-key']));
      } else if (pathname.startsWith('/api/jobs/') && ['GET', 'DELETE'].includes(req.method)) {
        const id = pathname.slice('/api/jobs/'.length);
        if (!uuid.test(id)) { respond(404, { error: 'Job not found.' }); return; }
        const key = req.headers['x-norie-job-key'];
        respond(200, req.method === 'DELETE' ? jobs.cancel(id, key) : jobs.get(id, key));
      } else if (['/api/generate', '/api/ask'].includes(pathname) && req.method === 'POST') {
        const input = await body();
        const kind = pathname === '/api/generate' ? 'generate' : 'ask';
        await validateJob(kind, input);
        const key = req.headers['x-norie-job-key'] || randomUUID();
        const job = jobs.submit(kind, input, key);
        const completed = await jobs.wait(job.id, key);
        respond(completed.status === 'succeeded' ? 200 : 400,
          completed.status === 'succeeded' ? completed.result : { error: completed.error });
      } else if (pathname.startsWith('/api/sets/') && req.method === 'DELETE') {
        const id = pathname.slice('/api/sets/'.length);
        if (!uuid.test(id)) throw new Error('Invalid local deck ID.');
        await unlink(join(storeDir, `${id}.json`)).catch(error => { if (error.code !== 'ENOENT') throw error; });
        respond(200, { deleted: true });
      } else if (req.method === 'GET' && !pathname.startsWith('/api/')) {
        const filename = resolve(webRoot, `.${decodeURIComponent(pathname === '/' ? '/index.html' : pathname)}`);
        if (!filename.startsWith(resolve(webRoot) + sep)) { respond(403, { error: 'Invalid path.' }); return; }
        const bytes = await readFile(filename);
        res.writeHead(200, { 'Content-Type': types[extname(filename)] || 'application/octet-stream', 'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff' });
        res.end(bytes);
      } else {
        respond(404, { error: 'Not found.' });
      }
    } catch (error) {
      const message = error.code === 'ENOENT' ? 'Local file or deck not found.' :
        error.message === 'fetch failed' ? 'Ollama is not reachable. Start the local model runtime.' : error.message;
      respond(error.status || (error.code === 'ENOENT' ? 404 : 400), { error: message });
    }
  });
  server.requestTimeout = 15000;
  server.jobQueue = jobs;
  server.once('close', () => { void jobs.close(); });
  return server;
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  const port = Number(process.env.NORIE_LOCAL_PORT || 8752);
  const server = createLocalServer();
  server.listen(port, '127.0.0.1', () => console.log(`Norie local AI: http://127.0.0.1:${port}`));
  for (const signal of ['SIGINT', 'SIGTERM']) process.once(signal, () => {
    server.close();
    void server.jobQueue.close();
  });
}