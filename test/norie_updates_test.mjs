import {test} from 'node:test';
import assert from 'node:assert/strict';
import {createUpdateController} from '../branding/web/norie-updates.mjs';

function fixture() {
  const handlers = {};
  let reloads = 0;
  const states = [];
  const messages = [];
  const registration = {waiting: null, installing: null, addEventListener: (n, f) => handlers[n] = f, update: async () => {}};
  const serviceWorker = {register: async () => registration, addEventListener: (n, f) => handlers[n] = f};
  const controller = createUpdateController({serviceWorker, onState: s => states.push(s), reload: () => reloads++});
  return {controller, handlers, states, registration, messages, get reloads() {return reloads;}};
}

test('an available update never reloads without the learner applying it', async () => {
  const f = fixture();
  f.registration.waiting = {postMessage: m => f.messages.push(m)};
  await f.controller.check();
  assert.equal(f.states.at(-1), 'ready');
  f.handlers.controllerchange();
  assert.equal(f.reloads, 0);
  f.controller.apply();
  assert.deepEqual(f.messages, [{type: 'NORIE_ACTIVATE_UPDATE'}]);
  f.handlers.controllerchange();
  assert.equal(f.reloads, 1);
});

test('offline check preserves the running app and allows retry', async () => {
  const f = fixture();
  f.registration.update = async () => {throw Error('offline');};
  await f.controller.check();
  assert.equal(f.states.at(-1), 'offline');
  assert.equal(f.reloads, 0);
  f.registration.update = async () => {};
  await f.controller.check();
  assert.equal(f.states.at(-1), 'current');
});

test('installation in progress is not reported as up to date', async () => {
  const f = fixture();
  f.registration.installing = {state: 'installing', addEventListener() {}};
  await f.controller.check();
  assert.equal(f.states.at(-1), 'downloading');
});


test('multi-tab activation is surfaced instead of reloading the learner', async () => {
  const f = fixture();
  f.registration.waiting = {postMessage: m => f.messages.push(m)};
  await f.controller.check();
  f.controller.apply();
  f.handlers.message({data: {type: 'NORIE_UPDATE_BLOCKED_MULTITAB'}});
  assert.equal(f.states.at(-1), 'multitab');
  f.handlers.controllerchange();
  assert.equal(f.reloads, 0);
});
