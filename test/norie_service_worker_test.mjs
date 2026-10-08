import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import vm from 'node:vm';
import {test} from 'node:test';

const origin = 'https://example.test';
const base = `${origin}/NorieLearningApp/`;
const source = readFileSync(new URL('../branding/web/norie-sw.js', import.meta.url), 'utf8');

function worker({failAsset = '', windowCount = 1, waiting = false} = {}) {
  const handlers = new Map();
  const entries = new Map();
  let online = true;
  const key = request => new URL(typeof request === 'string' ? request : request.url, base).href;
  const cache = {
    put: async (request, response) => entries.set(key(request), response.clone()),
    match: async request => entries.get(key(request))?.clone(),
  };
  let skipped = 0;
  const deleted = [];
  const clients = Array.from({length: windowCount}, (_, index) => ({id: `client-${index}`, url: base, postMessage() {}}));
  const self = {
    location: {origin},
    registration: {scope: base},
    clients: {matchAll: async options => waiting && !options.includeUncontrolled ? [] : clients},
    skipWaiting: async () => {skipped++;},
    addEventListener: (name, handler) => handlers.set(name, handler),
  };
  vm.runInNewContext(source, {
    self, URL, Request, console,
    caches: {open: async () => cache, keys: async () => ['norie-offline-old', 'norie-offline-__NORIE_BUILD_SHA__'], delete: async name => {deleted.push(name); return true;}},
    fetch: async request => {
      if (!online) throw new Error('offline');
      if (key(request).endsWith(failAsset) && failAsset) return new Response('missing', {status: 404});
      if (key(request).endsWith('atlas-catalog.json')) return new Response(JSON.stringify({schemaVersion: 1, assets: [{file: 'female-reproductive.glb'}]}));
      return new Response(`asset:${key(request)}`, {status: 200});
    },
  });
  return {
    entries,
    install: async () => {
      let completion;
      handlers.get('install')({waitUntil: promise => completion = promise});
      await completion;
    },
    goOffline: () => online = false,
    fetch: request => {
      let response;
      handlers.get('fetch')({request, respondWith: promise => response = promise});
      return response;
    },
    message: async (data, source = clients[0]) => {
      let completion = Promise.resolve();
      handlers.get('message')({data, source, waitUntil: promise => completion = promise});
      await completion;
    },
    deleted,
    get skipped() {return skipped;},
  };
}

test('detailed atlas models are mandatory before offline installation succeeds', async () => {
  const app = worker();
  await app.install();
  app.goOffline();
  const response = await app.fetch(new Request(`${base}assets/assets/anatomy/female-reproductive.glb`));
  assert.equal(response.status, 200);
  const broken = worker({failAsset: 'female-reproductive.glb'});
  await assert.rejects(broken.install(), /Offline prerequisite failed/);
});

test('organ atlas is cached before the learner opens Anatomy Lab', async () => {
  const app = worker();
  await app.install();
  app.goOffline();
  const response = await app.fetch(new Request(`${base}assets/assets/anatomy/anatomy-organs.glb`));
  assert.equal(response.status, 200);
});

test('cached Flutter bootstrap works offline with the build query', async () => {
  const app = worker();
  await app.install();
  app.goOffline();
  const response = await app.fetch(new Request(`${base}flutter_bootstrap.js?v=build123`));
  assert.equal(response.status, 200);
});

test('authenticated cloud requests never enter the public app cache', async () => {
  const app = worker();
  await app.install();
  const response = app.fetch(new Request('https://project.supabase.co/rest/v1/study_sets'));
  if (response) await response;
  assert.equal(response, undefined);
  assert.equal([...app.entries.keys()].some(url => url.includes('supabase.co')), false);
});

test('a browser navigation request can reload the app offline', async () => {
  const app = worker();
  await app.install();
  app.goOffline();
  // Browsers create navigate-mode requests; Request constructors forbid them.
  const request = {url: base, method: 'GET', mode: 'navigate', headers: new Headers(), credentials: 'include', redirect: 'manual'};
  const response = await app.fetch(request);
  assert.equal(response.status, 200);
});


test('update activation waits for other tabs and cleanup waits for the new client', async () => {
  const blocked = worker({windowCount: 2});
  let blockedMessage;
  const source = {id: 'client-0', postMessage: message => blockedMessage = message};
  await blocked.message({type: 'NORIE_ACTIVATE_UPDATE'}, source);
  assert.equal(blocked.skipped, 0);
  assert.equal(blockedMessage?.type, 'NORIE_UPDATE_BLOCKED_MULTITAB');
  assert.deepEqual(blocked.deleted, []);

  const safe = worker({windowCount: 1});
  await safe.message({type: 'NORIE_ACTIVATE_UPDATE'});
  assert.equal(safe.skipped, 1);
  assert.deepEqual(safe.deleted, []);
  await safe.message({type: 'NORIE_CLIENT_READY', build: '__NORIE_BUILD_SHA__'});
  assert.deepEqual(safe.deleted, ['norie-offline-old']);
});

test('waiting worker counts uncontrolled tabs before activation', async () => {
  const app = worker({windowCount: 2, waiting: true});
  await app.message({type: 'NORIE_ACTIVATE_UPDATE'});
  assert.equal(app.skipped, 0);
});

test('old client readiness cannot delete an old cache needed by another tab', async () => {
  const app = worker({windowCount: 2});
  await app.message({type: 'NORIE_CLIENT_READY', build: 'old'});
  assert.deepEqual(app.deleted, []);
  await app.message({type: 'NORIE_CLIENT_READY', build: '__NORIE_BUILD_SHA__'});
  assert.deepEqual(app.deleted, []);
});
