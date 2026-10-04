import { createHash, randomUUID } from 'node:crypto';
import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { DatabaseSync } from 'node:sqlite';
import PQueue from 'p-queue';

const terminal = new Set(['succeeded', 'failed', 'cancelled', 'expired']);
const digest = value => createHash('sha256').update(value).digest('hex');
const encode = value => JSON.stringify(value, (_key, item) =>
  item && typeof item === 'object' && !Array.isArray(item)
    ? Object.fromEntries(Object.entries(item).sort(([left], [right]) => left.localeCompare(right))) : item);
const failure = (status, message) => Object.assign(new Error(message), { status });

export class LocalJobQueue {
  constructor({ storeDir, execute, concurrency = 1, capacity = 32, maxRecords = 256,
    runTimeoutMs = 1200000, maxWaitMs = 1800000, retentionMs = 86400000 }) {
    if (!Number.isInteger(concurrency) || concurrency < 1 || concurrency > 8 ||
        !Number.isInteger(capacity) || capacity < concurrency || capacity > 1000 ||
        !Number.isInteger(maxRecords) || maxRecords < capacity ||
        ![runTimeoutMs, maxWaitMs, retentionMs].every(value => Number.isFinite(value) && value > 0)) {
      throw new Error('Invalid local job queue limits.');
    }
    mkdirSync(storeDir, { recursive: true });
    this.db = new DatabaseSync(join(storeDir, 'jobs.sqlite'));
    this.db.exec(`PRAGMA journal_mode = WAL;
      CREATE TABLE IF NOT EXISTS jobs (
        id TEXT PRIMARY KEY, key_hash TEXT NOT NULL UNIQUE, fingerprint TEXT NOT NULL,
        kind TEXT NOT NULL, payload TEXT, status TEXT NOT NULL, progress TEXT,
        result TEXT, error TEXT, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
      );`);
    this.execute = execute;
    this.capacity = capacity;
    this.maxRecords = maxRecords;
    this.runTimeoutMs = runTimeoutMs;
    this.maxWaitMs = maxWaitMs;
    this.retentionMs = retentionMs;
    this.queue = new PQueue({ concurrency, autoStart: false });
    this.controllers = new Map();
    this.waiters = new Map();
    this.closed = false;
    this.db.prepare("UPDATE jobs SET status = 'failed', payload = NULL, error = ?, updated_at = ? WHERE status = 'running'")
      .run('The server restarted during this job. Submit a new request.', Date.now());
    this.prune();
    for (const job of this.db.prepare("SELECT * FROM jobs WHERE status = 'queued' ORDER BY rowid").all()) this.schedule(job);
    this.queue.start();
  }

  prune() {
    const now = Date.now();
    for (const job of this.db.prepare("SELECT id FROM jobs WHERE status = 'queued' AND created_at < ?").all(now - this.maxWaitMs)) {
      this.finish(job.id, 'expired', null, 'The job expired while waiting. Submit a new request.');
      this.controllers.get(job.id)?.queued.abort();
    }
    this.db.prepare("DELETE FROM jobs WHERE status IN ('succeeded', 'failed', 'cancelled', 'expired') AND updated_at < ?")
      .run(now - this.retentionMs);
  }

  submit(kind, input, key) {
    if (this.closed) throw failure(503, 'The local queue is shutting down.');
    if (!['generate', 'ask'].includes(kind) || !input || typeof input !== 'object' || Array.isArray(input)) throw failure(400, 'Invalid job request.');
    if (typeof key !== 'string' || !/^[A-Za-z0-9_-]{32,128}$/.test(key)) throw failure(400, 'Supply a unique X-Norie-Job-Key of 32 to 128 characters.');
    this.prune();
    const keyHash = digest(key);
    const fingerprint = digest(encode({ kind, input }));
    const previous = this.db.prepare('SELECT * FROM jobs WHERE key_hash = ?').get(keyHash);
    if (previous) {
      if (previous.fingerprint !== fingerprint) throw failure(409, 'This job key was already used for different input.');
      return this.snapshot(previous);
    }
    const count = this.db.prepare("SELECT COUNT(*) AS count FROM jobs WHERE status IN ('queued', 'running')").get().count;
    if (count >= this.capacity) throw failure(429, 'The local queue is full. Try again later.');
    if (this.db.prepare('SELECT COUNT(*) AS count FROM jobs').get().count >= this.maxRecords) {
      throw failure(429, 'The local job storage limit has been reached. Try again after older jobs expire.');
    }
    const now = Date.now();
    const id = randomUUID();
    this.db.prepare('INSERT INTO jobs (id, key_hash, fingerprint, kind, payload, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)')
      .run(id, keyHash, fingerprint, kind, JSON.stringify(input), 'queued', now, now);
    this.schedule(this.db.prepare('SELECT * FROM jobs WHERE id = ?').get(id));
    return this.get(id, key);
  }

  snapshot(job) {
    return {
      id: job.id, kind: job.kind, status: job.status,
      created_at: new Date(job.created_at).toISOString(),
      progress: job.progress ? JSON.parse(job.progress) : null,
      queue_position: job.status === 'queued' ? this.db.prepare("SELECT COUNT(*) AS count FROM jobs WHERE status = 'queued' AND rowid <= (SELECT rowid FROM jobs WHERE id = ?)").get(job.id).count : null,
      result: job.status === 'succeeded' ? JSON.parse(job.result) : null,
      error: job.error,
    };
  }

  get(id, key) {
    if (typeof key !== 'string') throw failure(404, 'Job not found.');
    this.prune();
    const job = this.db.prepare('SELECT * FROM jobs WHERE id = ? AND key_hash = ?').get(id, digest(key));
    if (!job) throw failure(404, 'Job not found.');
    return this.snapshot(job);
  }

  wait(id, key) {
    const job = this.get(id, key);
    if (terminal.has(job.status)) return Promise.resolve(job);
    if (!this.waiters.has(id)) this.waiters.set(id, Promise.withResolvers());
    return this.waiters.get(id).promise;
  }

  cancel(id, key) {
    const job = this.get(id, key);
    if (terminal.has(job.status)) return job;
    this.finish(id, 'cancelled', null, 'Job cancelled.');
    const controls = this.controllers.get(id);
    if (job.status === 'queued') controls?.queued.abort();
    else controls?.work.abort(new Error('Job cancelled.'));
    return this.get(id, key);
  }

  finish(id, status, result = null, error = null) {
    const changed = this.db.prepare("UPDATE jobs SET status = ?, payload = NULL, result = ?, error = ?, updated_at = ? WHERE id = ? AND status IN ('queued', 'running')")
      .run(status, result === null ? null : JSON.stringify(result), error, Date.now(), id).changes;
    if (changed && this.waiters.has(id)) {
      this.waiters.get(id).resolve(this.snapshot(this.db.prepare('SELECT * FROM jobs WHERE id = ?').get(id)));
      this.waiters.delete(id);
    }
  }

  schedule(job) {
    const queued = new AbortController();
    const work = new AbortController();
    const controls = { queued, work, started: false };
    this.controllers.set(job.id, controls);
    void this.queue.add(async () => {
      const current = this.db.prepare('SELECT * FROM jobs WHERE id = ?').get(job.id);
      if (!current || current.status !== 'queued' || this.closed) return;
      controls.started = true;
      if (Date.now() - current.created_at > this.maxWaitMs) {
        this.finish(job.id, 'expired', null, 'The job expired while waiting.');
        return;
      }
      this.db.prepare("UPDATE jobs SET status = 'running', updated_at = ? WHERE id = ?").run(Date.now(), job.id);
      const deadline = setTimeout(() => work.abort(new Error('The job exceeded its execution deadline.')), this.runTimeoutMs);
      try {
        const result = await this.execute(current.kind, JSON.parse(current.payload), {
          signal: work.signal,
          onProgress: progress => {
            if (!this.closed) this.db.prepare("UPDATE jobs SET progress = ?, updated_at = ? WHERE id = ? AND status = 'running'")
              .run(JSON.stringify(progress), Date.now(), job.id);
          },
        });
        work.signal.throwIfAborted();
        if (!this.closed) this.finish(job.id, 'succeeded', result);
      } catch (error) {
        if (!this.closed) this.finish(job.id, 'failed', null, work.signal.aborted ? work.signal.reason.message : 'Local generation failed. Check the source and model runtime, then submit a new request.');
      } finally {
        clearTimeout(deadline);
      }
    }, { signal: queued.signal }).catch(() => {
      if (!this.closed) this.finish(job.id, 'failed', null, 'The queued job could not start.');
    }).finally(() => this.controllers.delete(job.id));
  }

  stats() {
    this.prune();
    return { active: this.queue.pending, queued: this.queue.size, capacity: this.capacity, concurrency: this.queue.concurrency };
  }

  close() {
    if (this.closing) return this.closing;
    this.closed = true;
    this.queue.pause();
    for (const controls of this.controllers.values()) {
      if (!controls.started) controls.queued.abort();
      controls.work.abort(new Error('The local server is shutting down.'));
    }
    this.closing = this.queue.onIdle().then(() => {
      for (const [id, waiter] of this.waiters) waiter.resolve({ id, status: 'failed', error: 'The local server is shutting down.' });
      this.waiters.clear();
      this.db.close();
    });
    return this.closing;
  }
}