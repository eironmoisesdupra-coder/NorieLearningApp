import test from 'node:test';
import assert from 'node:assert/strict';
import { AtlasState, isSelectionGesture, validCommand } from '../src/state.mjs';
import * as THREE from 'three';
import { AtlasScene } from '../src/scene.mjs';

const structures = [
  { id: 'bone', reference: 'male', systems: ['skeletal'], asset: 'bones' },
  { id: 'muscle', reference: 'male', systems: ['muscular'], asset: 'muscles' },
  { id: 'uterus', reference: 'female', systems: ['reproductive'], asset: 'female' },
];

test('switching layers or reference rejects stale load completion', () => {
  const s = new AtlasState(structures);
  const first = s.configure('male', ['skeletal']);
  s.configure('male', ['muscular']);
  assert.equal(s.accepts(first), false);
  assert.deepEqual(s.visibleIds(), ['muscle']);
  s.configure('female', ['reproductive']);
  assert.deepEqual(s.visibleIds(), ['uterus']);
});

test('hidden and isolated structures cannot be selected; restore retains layers', () => {
  const s = new AtlasState(structures);
  s.configure('male', ['skeletal', 'muscular']);
  s.hide('bone');
  assert.equal(s.select('bone'), false);
  assert.equal(s.select('muscle'), true);
  s.restore();
  s.isolate('bone');
  assert.deepEqual(s.visibleIds(), ['bone']);
  assert.equal(s.select('muscle'), false);
  s.restore();
  assert.deepEqual(s.visibleIds(), ['bone', 'muscle']);
});

test('drag or multi-touch gesture does not select', () => {
  assert.equal(isSelectionGesture({ x: 10, y: 10, pointers: 1 }, { x: 13, y: 12 }), true);
  assert.equal(isSelectionGesture({ x: 10, y: 10, pointers: 1 }, { x: 25, y: 10 }), false);
  assert.equal(isSelectionGesture({ x: 10, y: 10, pointers: 2 }, { x: 10, y: 10 }), false);
  assert.equal(isSelectionGesture({ x: 10, y: 10, pointers: 1, moved: true }, { x: 10, y: 10 }), false);
});

test('explicit search selection reveals a hidden target and exits another isolation', () => {
  const s = new AtlasState(structures);
  s.configure('male', ['skeletal', 'muscular']);
  s.hide('muscle');
  s.isolate('bone');
  assert.equal(s.reveal('muscle'), true);
  assert.equal(s.selected, 'muscle');
  assert.ok(s.visibleIds().includes('muscle'));
  assert.equal(s.reveal('uterus'), false);
});

test('bridge rejects unexpected versions, sessions and arbitrary commands', () => {
  assert.equal(validCommand({ version: 1, session: 'abc', type: 'restore' }, 'abc'), true);
  for (const patch of [{ version: 2 }, { session: 'other' }, { type: 'eval' }]) {
    assert.equal(validCommand({ version: 1, session: 'abc', type: 'restore', ...patch }, 'abc'), false);
  }
});

test('quiz targets keep their anatomical material instead of the selection glow', () => {
  const material = new THREE.MeshStandardMaterial({ color: '#d7c4a5', roughness: 0.8 });
  const mesh = new THREE.Mesh(new THREE.BoxGeometry(), material);
  mesh.userData = { structureId: 'bone', baseColor: material.color.clone() };
  const scene = Object.create(AtlasScene.prototype);
  scene.state = new AtlasState(structures);
  scene.state.configure('male', ['skeletal']);
  scene.state.select('bone');
  scene.alpha = 1;
  scene.meshes = () => [mesh];
  scene.quiz = false;
  scene.updateVisibility();
  assert.equal(material.color.getHexString(), '42e8e0');
  scene.quiz = true;
  scene.updateVisibility();
  assert.equal(material.color.getHexString(), 'd7c4a5');
  assert.equal(material.emissive.getHexString(), '000000');
  assert.equal(material.roughness, 0.8);
  assert.equal(material.opacity, 1);
  assert.equal(mesh.visible, true);
  mesh.geometry.dispose();
  material.dispose();
});
