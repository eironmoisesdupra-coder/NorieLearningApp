import test from 'node:test';
import assert from 'node:assert/strict';
import * as THREE from 'three';
import { AtlasState, validCommand } from '../src/state.mjs';
import { AtlasScene } from '../src/scene.mjs';

const structures = [
  { id: 'bone', reference: 'male', systems: ['skeletal'], asset: 'bones' },
  { id: 'joint', reference: 'male', systems: ['skeletal', 'articular'], asset: 'bones' },
  { id: 'muscle', reference: 'male', systems: ['muscular'], asset: 'muscles' },
  { id: 'uterus', reference: 'female', systems: ['reproductive'], asset: 'female' },
];
const command = (type, payload) => ({ version: 1, session: 'test', type, payload });
function state() {
  const result = new AtlasState(structures);
  result.configure('male', ['skeletal', 'articular', 'muscular']);
  return result;
}
function scene() {
  const result = Object.create(AtlasScene.prototype);
  Object.assign(result, { state: state(), disposed: false, alpha: 1, quiz: false, loaded: new Map(),
    catalog: { references: [{ id: 'male' }, { id: 'female' }], structures, assets: [] },
    entries: new Map(structures.map(s => [s.id, s])), assets: new Map(), scene: new THREE.Scene(),
    events: [], emit(type, payload) { this.events.push({ type, payload }); } });
  return result;
}

test('command schema rejects malformed payloads and accepts only bounded finite values', () => {
  for (const [type, payload] of [
    ['select', null], ['select', {}], ['focus', { id: 4 }], ['hide', { id: '' }], ['isolate', { id: 'bone', script: 'x' }],
    ['configure', { reference: 'male', systems: 'skeletal' }], ['configure', { reference: 'male', systems: [null] }],
    ['configure', { reference: 'male', systems: ['skeletal', 'skeletal'] }],
    ['configure', { reference: 'male', systems: [], quiz: 'true' }],
    ['configure', { reference: 'male', systems: [], target: 3 }],
    ['configure', { reference: 'male', systems: [], requestId: Infinity }],
    ['configure', { reference: 'male', systems: [], requestId: -1 }],
    ['opacity', { value: NaN }], ['opacity', { value: Infinity }], ['opacity', { value: 0 }], ['opacity', { value: 1.1 }],
    ['camera', { view: 'free', position: [1, 2, 3] }], ['camera', { view: 'constructor' }],
    ['systemLayer', { system: 'skeletal' }], ['systemLayer', { system: 'skeletal', visible: 1 }],
    ['systemLayer', { system: 'skeletal', opacity: -0.1 }], ['systemLayer', { system: 'skeletal', opacity: Infinity }],
    ['compare', { ids: ['bone'] }], ['compare', { ids: ['bone', 'bone'] }], ['compare', { ids: ['bone', 7] }],
    ['restore', []], ['dispose', { unexpected: true }], ['quality', { profile: 'low' }],
  ]) assert.equal(validCommand(command(type, payload), 'test'), false, `${type}: ${JSON.stringify(payload)}`);
  for (const [type, payload] of [
    ['systemLayer', { system: 'skeletal', visible: false, opacity: .4 }], ['systemLayer', { system: 'skeletal', opacity: 0 }],
    ['compare', { ids: ['bone', 'muscle'] }], ['compare', { ids: [] }], ['opacity', { value: .15 }],
    ['configure', { reference: 'male', systems: ['skeletal'], target: null, quiz: false, requestId: 0 }],
    ['camera', { view: 'reset' }], ['restore', undefined],
  ]) assert.equal(validCommand(command(type, payload), 'test'), true, type);
});

test('layer opacity composes global alpha and overlapping memberships without hiding shared structures', () => {
  const s = state();
  assert.equal(s.systemLayer({ system: 'skeletal', opacity: .4 }), true);
  assert.equal(s.effectiveOpacity('bone', .5), .2);
  assert.equal(s.effectiveOpacity('joint', .5), .5);
  s.systemLayer({ system: 'articular', visible: false });
  assert.equal(s.effectiveOpacity('joint', .5), .2);
  s.systemLayer({ system: 'skeletal', visible: false });
  assert.deepEqual(s.visibleIds(), ['muscle']);
  assert.equal(s.systemLayer({ system: 'missing', visible: true }), false);
  assert.equal(s.systemLayer({ system: 'reproductive', visible: true }), false);
  assert.equal(s.systemLayer({ system: 'muscular', opacity: NaN }), false);
});

test('comparison accepts only distinct visible structures in the current reference and clears when visibility changes', () => {
  const s = state();
  assert.equal(s.compare(['bone', 'muscle']), true);
  assert.deepEqual(s.compareIds, ['bone', 'muscle']);
  for (const ids of [['bone', 'uterus'], ['bone', 'missing'], ['bone', 'bone'], ['bone'], [null, 'bone']]) {
    assert.equal(s.compare(ids), false);
    assert.deepEqual(s.compareIds, ['bone', 'muscle']);
  }
  s.hide('muscle');
  assert.deepEqual(s.compareIds, []);
  assert.equal(s.compare(['bone', 'muscle']), false);
  s.reveal('muscle');
  s.compare(['bone', 'muscle']);
  s.isolate('bone');
  assert.deepEqual(s.compareIds, []);
  s.restore();
  s.compare(['bone', 'muscle']);
  s.systemLayer({ system: 'muscular', opacity: 0 });
  assert.deepEqual(s.compareIds, []);
  assert.equal(s.select('muscle'), false);
  s.restore();
  assert.equal(s.compare(['bone', 'muscle']), true);
  assert.equal(s.compare([]), true);
  assert.deepEqual(s.compareIds, []);
});

test('restore and configure clear layer overrides, hidden state, isolation and comparison', () => {
  const s = state();
  s.systemLayer({ system: 'skeletal', opacity: .3 });
  s.compare(['bone', 'muscle']);
  s.hide('joint');
  s.isolate('bone');
  s.restore();
  assert.deepEqual(s.visibleIds(), ['bone', 'joint', 'muscle']);
  assert.equal(s.effectiveOpacity('bone', .6), .6);
  assert.deepEqual(s.compareIds, []);
  assert.equal(s.isolated, null);
  assert.equal(s.hide('uterus'), false);
  assert.equal(s.isolate('missing'), false);
  s.systemLayer({ system: 'muscular', opacity: .3 });
  s.configure('male', ['muscular']);
  assert.equal(s.effectiveOpacity('muscle', .5), .5);
});

test('renderer applies effective opacity and comparison highlight while preserving quiz materials', () => {
  const atlas = scene();
  const mesh = new THREE.Mesh(new THREE.BoxGeometry(), new THREE.MeshStandardMaterial({ color: '#d7c4a5' }));
  mesh.userData = { structureId: 'bone', baseColor: mesh.material.color.clone() };
  atlas.meshes = () => [mesh];
  atlas.command('opacity', { value: .5 });
  atlas.command('systemLayer', { system: 'skeletal', opacity: .4 });
  assert.equal(mesh.material.opacity, .2);
  assert.equal(mesh.material.transparent, true);
  assert.equal(mesh.material.depthWrite, false);
  atlas.command('compare', { ids: ['bone', 'muscle'] });
  assert.notEqual(mesh.material.color.getHexString(), 'd7c4a5');
  atlas.quiz = true;
  atlas.updateVisibility();
  assert.equal(mesh.material.color.getHexString(), 'd7c4a5');
  atlas.command('restore');
  assert.equal(mesh.material.opacity, 1);
  assert.deepEqual(atlas.state.compareIds, []);
  mesh.geometry.dispose(); mesh.material.dispose();
});

test('renderer rejects direct malformed and semantic commands without mutating view', async () => {
  const atlas = scene();
  atlas.command('opacity', { value: -4 });
  assert.equal(atlas.alpha, 1);
  assert.equal(atlas.command('hide', { id: 'uterus' }), false);
  assert.equal(atlas.command('focus', { id: 'missing' }), false);
  assert.equal(atlas.command('camera', { view: 'constructor' }), false);
  await assert.rejects(atlas.configure({ reference: 'male', systems: ['unknown'] }), /Invalid atlas/);
  await assert.rejects(atlas.configure({ reference: 'male', systems: ['skeletal'], target: 'uterus' }), /Invalid atlas/);
  assert.equal(atlas.state.reference, 'male');
  assert.deepEqual(atlas.state.visibleIds(), ['bone', 'joint', 'muscle']);
});

test('stale async assets are released and never attached after a newer configure or disposal', async () => {
  for (const dispose of [false, true]) {
    const atlas = scene();
    atlas.assets.set('bones', { file: 'bones.glb' });
    let finish;
    atlas.loader = { loadAsync: () => new Promise(resolve => { finish = resolve; }) };
    const previousLocation = globalThis.location;
    globalThis.location = { href: 'http://localhost/atlas-viewer.html' };
    try {
      const pending = atlas.configure({ reference: 'male', systems: ['skeletal'], requestId: 1 });
      const root = new THREE.Group();
      const mesh = new THREE.Mesh(new THREE.BoxGeometry(), new THREE.MeshStandardMaterial());
      root.add(mesh);
      let geometriesReleased = 0;
      mesh.geometry.addEventListener('dispose', () => geometriesReleased++);
      if (dispose) { atlas.disposed = true; atlas.state.generation++; }
      else atlas.state.configure('female', ['reproductive']);
      finish({ scene: root });
      await pending;
      assert.equal(geometriesReleased, 1);
      assert.equal(atlas.loaded.size, 0);
      assert.equal(root.parent, null);
      assert.equal(atlas.events.some(e => e.type === 'loaded'), false);
      if (dispose) {
        const generation = atlas.state.generation;
        await atlas.configure({ reference: 'male', systems: ['skeletal'] });
        assert.equal(atlas.state.generation, generation);
      }
    } finally { globalThis.location = previousLocation; }
  }
});

test('disposing the renderer twice releases resources and listeners only once', () => {
  const atlas = scene();
  let releases = 0;
  const root = new THREE.Group();
  const mesh = new THREE.Mesh(new THREE.BoxGeometry(), new THREE.MeshStandardMaterial());
  root.add(mesh);
  mesh.geometry.addEventListener('dispose', () => releases++);
  atlas.loaded.set('bones', root);
  let disconnects = 0;
  Object.assign(atlas, { renderer: { setAnimationLoop() {}, dispose() {} }, controls: { dispose() {} },
    resizeObserver: { disconnect() { disconnects++; } }, canvas: { removeEventListener() {} } });
  atlas.dispose();
  const generation = atlas.state.generation;
  atlas.dispose();
  assert.equal(releases, 1);
  assert.equal(disconnects, 1);
  assert.equal(atlas.state.generation, generation);
});
