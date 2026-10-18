import test from 'node:test';
import assert from 'node:assert/strict';
import { validCommand } from '../src/state.mjs';

import { FrameScheduler } from '../src/render_scheduler.mjs';
import { qualityPixelRatio } from '../src/render_quality.mjs';
import { RenderMetrics } from '../src/render_metrics.mjs';

function fixture(update = () => false) {
  assert.equal(typeof FrameScheduler, 'function', 'demand-driven scheduler must exist');
  const pending = new Map();
  let next = 0, renders = 0;
  const scheduler = new FrameScheduler({ update, render: () => renders++,
    request: fn => { pending.set(++next, fn); return next; }, cancel: id => pending.delete(id) });
  const tick = () => { const callbacks = [...pending.values()]; pending.clear(); callbacks.forEach(fn => fn()); };
  return { scheduler, pending, tick, get renders() { return renders; } };
}

test('idle scheduler coalesces invalidations and leaves no perpetual animation callback', () => {
  const f = fixture();
  assert.equal(f.pending.size, 0);
  f.scheduler.invalidate(); f.scheduler.invalidate();
  assert.equal(f.pending.size, 1);
  f.tick();
  assert.equal(f.renders, 1);
  assert.equal(f.pending.size, 0);
  f.scheduler.invalidate(); f.tick();
  assert.equal(f.renders, 2);
});

test('control changes emitted during update render once and damping stops when settled', () => {
  let updates = 0, f;
  f = fixture(() => { f.scheduler.invalidate(); return ++updates < 3; });
  f.scheduler.invalidate();
  f.tick(); f.tick(); f.tick();
  assert.equal(f.renders, 3);
  assert.equal(f.pending.size, 0, 'update change events must not cause an infinite loop');
});

test('gestures stay live until released then stop after the final refresh', () => {
  const f = fixture();
  f.scheduler.setActive(true); f.tick(); f.tick();
  assert.equal(f.renders, 2);
  assert.equal(f.pending.size, 1);
  f.scheduler.setActive(false); f.tick();
  assert.equal(f.pending.size, 0);
});

test('background and context suspension cancel work independently and resume with a refresh', () => {
  const f = fixture();
  f.scheduler.invalidate(); f.scheduler.setVisible(false);
  assert.equal(f.pending.size, 0);
  f.scheduler.invalidate(); f.tick();
  assert.equal(f.renders, 0);
  f.scheduler.setPaused(true); f.scheduler.setVisible(true);
  assert.equal(f.pending.size, 0);
  f.scheduler.setPaused(false); f.tick();
  assert.equal(f.renders, 1);
  assert.equal(f.pending.size, 0);
});

test('dispose cancels pending frames and ignores stale callbacks and repeated disposal', () => {
  const f = fixture();
  f.scheduler.invalidate();
  const stale = [...f.pending.values()][0];
  f.scheduler.dispose(); f.scheduler.dispose();
  stale(); f.scheduler.invalidate(); f.scheduler.setActive(true); f.scheduler.setVisible(true);
  assert.equal(f.pending.size, 0);
  assert.equal(f.renders, 0);
});

test('quality command accepts only named profiles and pixel ratio always stays finite and bounded', () => {
  for (const profile of ['low', 'balanced', 'high']) {
    assert.equal(validCommand({ version: 1, session: 's', type: 'quality', payload: { profile } }, 's'), true);
  }
  for (const payload of [{}, { profile: 'ultra' }, { profile: null }, { profile: 'low', dpr: 5 }, { profile: 'constructor' }]) {
    assert.equal(validCommand({ version: 1, session: 's', type: 'quality', payload }, 's'), false);
  }
  assert.equal(typeof qualityPixelRatio, 'function');
  assert.equal(qualityPixelRatio('low', 3), 1);
  assert.equal(qualityPixelRatio('balanced', 3), 1.5);
  assert.equal(qualityPixelRatio('high', 3), 2);
  assert.equal(qualityPixelRatio('high', .2), .75);
  for (const ratio of [NaN, Infinity, -Infinity, undefined]) assert.equal(qualityPixelRatio('high', ratio), 1);
  assert.throws(() => qualityPixelRatio('unknown', 1), /quality/i);
});

test('diagnostics bound timing histories, retain aggregate counts and report memory honestly', () => {
  assert.equal(typeof RenderMetrics, 'function', 'bounded renderer diagnostics must exist');
  const metrics = new RenderMetrics(3);
  for (let i = 1; i <= 5; i++) metrics.frame(i, { render: { calls: 10, triangles: 100 }, memory: { geometries: 2, textures: 1 } });
  for (let i = 1; i <= 5; i++) metrics.load(i);
  const result = metrics.snapshot();
  assert.equal(result.renderedFrames, 5);
  assert.deepEqual(result.frameJsMs, [3, 4, 5]);
  assert.deepEqual(result.loadMs, [3, 4, 5]);
  assert.equal(result.drawCalls, 10);
  assert.equal(result.geometries, 2);
  assert.equal(result.textures, 1);
  assert.equal(result.peakMemoryBytes, null);
  result.frameJsMs.push(9);
  assert.equal(metrics.snapshot().frameJsMs.length, 3);
});
