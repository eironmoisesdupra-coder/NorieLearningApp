import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import vm from 'node:vm';
import {test} from 'node:test';

const origin = 'https://example.test';
const base = `${origin}/NorieLearningApp/`;
const source = readFileSync(new URL('../branding/web/norie-sw.js', import.meta.url), 'utf8');

function worker() {
  const handlers = new Map();
  const entries = new Map();
  let online = true;
  const key = request => new URL(typeof request === 'string' ? request : request.url, base).href;
  const cache = {
    put: async (request, response) => entries.set(key(request), response.clone()),
    match: async request => entries.get(key(request))?.clone(),
  };
  const self = {
    location: {origin}, clients: {claim: async () => {}}, skipWaiting: async () => {},
    addEventListener: (name, handler) => handlers.set(name, handler),
  };
  vm.runInNewContext(source, {
    self, URL, Request, console,
    caches: {open: async () => cache, keys: async () => [], delete: async () => {}},
    fetch: async request => {
      if (!online) throw new Error('offline');
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
  };
}

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
