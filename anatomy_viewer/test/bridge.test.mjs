import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import { build } from 'esbuild';

// WebGL construction is the external boundary. Exercise the real bridge and
// validator with controlled catalog arrival and browser events.
const compiled = await build({ entryPoints: [new URL('../src/bridge.mjs', import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')],
  bundle: true, write: false, format: 'esm', platform: 'browser', plugins: [{ name: 'webgl-boundary', setup(build) {
    build.onResolve({ filter: /^\.\/scene\.mjs$/ }, () => ({ path: 'scene', namespace: 'test' }));
    build.onLoad({ filter: /.*/, namespace: 'test' }, () => ({ contents: `export class AtlasScene {
      constructor() { window.sceneCreated++; this.disposed = false; }
      command(type, payload) { window.commands.push({ type, payload }); }
      dispose() { this.disposed = true; }
    }` }));
  } }] });

function harness() {
  const listeners = new Map();
  const status = { textContent: '', hidden: false };
  let finishFetch;
  const scope = { URL, URLSearchParams, AbortController, console, location: { href: 'http://local/atlas-viewer.html?session=test',
    origin: 'http://local', search: '?session=test' }, document: { getElementById: () => status },
    fetch: () => new Promise(resolve => { finishFetch = resolve; }),
    CustomEvent: class { constructor(type, options) { this.type = type; this.detail = options.detail; } } };
  const window = { sceneCreated: 0, commands: [], events: [],
    addEventListener(type, callback) { if (!listeners.has(type)) listeners.set(type, new Set()); listeners.get(type).add(callback); },
    removeEventListener(type, callback) { listeners.get(type)?.delete(callback); },
    dispatchEvent(event) { this.events.push(event); for (const callback of listeners.get(event.type) ?? []) callback(event); } };
  Object.assign(scope, { window, parent: window });
  const pending = vm.runInNewContext(`(async () => { ${compiled.outputFiles[0].text} })()`, scope);
  return { window, status, listeners, pending, catalogArrives() { finishFetch({ ok: true, json: async () => ({ schemaVersion: 1, structures: [] }) }); } };
}

test('pagehide before catalog arrival cancels initialization and removes bridge listeners', async () => {
  const h = harness();
  h.window.dispatchEvent({ type: 'pagehide' });
  h.catalogArrives();
  await h.pending;
  assert.equal(h.window.sceneCreated, 0);
  assert.equal(h.window.events.some(e => e.detail?.type === 'ready'), false);
  assert.equal(h.listeners.get('message')?.size, 0);
  assert.equal(h.listeners.get('pagehide')?.size, 0);
  assert.equal(h.window.norieAtlasCommand, undefined);
});

test('bridge rejects invalid payloads and cancels commands queued before pagehide', async () => {
  const h = harness();
  h.catalogArrives();
  await h.pending;
  const receive = h.window.norieAtlasCommand;
  receive(JSON.stringify({ version: 1, session: 'test', type: 'opacity', payload: { value: null } }));
  await Promise.resolve();
  assert.equal(h.window.commands.length, 0);
  receive(JSON.stringify({ version: 1, session: 'test', type: 'restore' }));
  h.window.dispatchEvent({ type: 'pagehide' });
  await Promise.resolve();
  assert.equal(h.window.commands.length, 0);
  receive(JSON.stringify({ version: 1, session: 'test', type: 'restore' }));
  await Promise.resolve();
  assert.equal(h.window.commands.length, 0);
});
