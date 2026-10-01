import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';

const catalog = JSON.parse(fs.readFileSync(new URL('../../assets/anatomy/atlas-catalog.json', import.meta.url)));
test('joint detail includes capsules, cruciates and matching source bones', () => {
  const parts = catalog.structures.filter(s => s.reference === 'joints');
  assert.equal(parts.filter(s => s.systems.includes('articular')).length, 349);
  assert.equal(parts.filter(s => s.systems.includes('skeletal')).length, 277);
  for (const name of ['Anterior cruciate ligament (left)', 'Articular capsule of hip joint (right)', 'Nucleus pulposus L4-L5']) {
    assert.ok(parts.some(s => s.name === name), name);
  }
});
test('gland extraction contains only the reviewed endocrine meshes', () => {
  const names = catalog.structures.filter(s => s.reference === 'glands').map(s => s.name).sort();
  assert.deepEqual(names, ['Adenohypophysis', 'Neurohypophysis', 'Pineal gland', 'Thyroid gland',
    'Inferior parathyroid gland (left)', 'Inferior parathyroid gland (right)',
    'Superior parathyroid gland (left)', 'Superior parathyroid gland (right)',
    'Suprarenal gland (left)', 'Suprarenal gland (right)', 'Pancreas'].sort());
});
test('distributed gland GLB has no undeclared geometry from the mixed source', () => {
  const bytes = fs.readFileSync(new URL('../../assets/anatomy/detail-glands.glb', import.meta.url));
  const doc = JSON.parse(bytes.subarray(20, 20 + bytes.readUInt32LE(12)).toString());
  const nodes = doc.nodes.filter(n => n.mesh !== undefined);
  const entries = catalog.structures.filter(s => s.asset === 'detail-glands');
  assert.equal(nodes.length, 11);
  assert.deepEqual(nodes.map(n => n.extras.atlasStructure).sort(), entries.map(s => s.id).sort());
  assert.equal(new Set(nodes.map(n => n.mesh)).size, doc.meshes.length, 'No orphan/unreviewed meshes');
});
test('endocrine filters include gland organs and exclude ducts and ligaments', () => {
  for (const reference of ['male', 'female']) {
    const parts = catalog.structures.filter(s => s.reference === reference && s.systems.includes('endocrine'));
    assert.ok(parts.some(s => /pineal/i.test(s.name)), reference + ' pineal');
    assert.ok(parts.some(s => /pancreas/i.test(s.name)), reference + ' pancreas');
    assert.ok(parts.every(s => !/duct|ligament/i.test(s.name)), reference + ' exocrine/support structures');
  }
});
