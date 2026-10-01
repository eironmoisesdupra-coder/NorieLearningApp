import test from 'node:test';
import assert from 'node:assert/strict';
import { glandNames, selectGlands, isEndocrineOrgan } from '../source-selection.mjs';

const node = (name, mesh = {}) => ({ getMesh: () => mesh, getExtras: () => ({ za_name: name }) });
test('mixed-license source selection excludes unreviewed meshes and fails closed on source drift', () => {
  const glands = glandNames.map(name => node(name));
  assert.deepEqual(selectGlands([...glands, node('Kidney.l'), node('Thyroid artery'), node('Unknown')]), glands);
  assert.throws(() => selectGlands(glands.slice(1)), /missing or duplicated/);
  assert.throws(() => selectGlands([...glands, glands[0]]), /missing or duplicated/);
  assert.throws(() => selectGlands(glandNames.map(name => node(name, null))), /missing or duplicated/);
});
test('endocrine organ labels distinguish glands from their vessels and supporting structures', () => {
  for (const label of ['pineal body', 'Left ovary', 'uncinate process of pancreas', 'left thymus lobe']) {
    assert.equal(isEndocrineOrgan(label), true, label);
  }
  for (const label of ['Suspensory ligament of right ovary', 'pancreatic duct', 'Thyroid artery', 'hepatopancreatic ampulla']) {
    assert.equal(isEndocrineOrgan(label), false, label);
  }
});
