const assert = require('node:assert/strict');
const path = require('node:path');
const { test } = require('node:test');
const { assetFileFor, externalLinkFor } = require('../asset-policy.cjs');

const root = path.resolve('offline-bundle');

test('app entry and versioned learning files resolve inside the bundled app', () => {
  assert.equal(assetFileFor('norie://app/', root), path.join(root, 'index.html'));
  assert.equal(assetFileFor('norie://app/main.dart.js?v=build1', root), path.join(root, 'main.dart.js'));
  assert.equal(assetFileFor('norie://app/assets/assets/anatomy/overview-skeleton.glb', root),
    path.join(root, 'assets', 'assets', 'anatomy', 'overview-skeleton.glb'));
});

test('requests cannot read files outside the learning bundle', () => {
  for (const url of [
    'norie://app/%2e%2e%2fprivate.txt',
    'norie://app/%5c..%5cprivate.txt',
    'norie://app/C:%5cprivate.txt',
    'norie://app/index.html:secret',
    'norie://app/%00',
    'norie://app/%invalid',
  ]) assert.equal(assetFileFor(url, root), null, url);
});

test('only the app host may request bundled assets', () => {
  for (const url of ['https://app/index.html', 'norie://other/index.html',
    'norie://user:password@app/index.html', 'norie://app:123/index.html', 'file:///private.txt']) {
    assert.equal(assetFileFor(url, root), null, url);
  }
});

test('external links can open web pages but cannot execute local or script URLs', () => {
  assert.equal(externalLinkFor('https://example.com/help'), 'https://example.com/help');
  for (const url of ['javascript:alert(1)', 'file:///private.txt', 'data:text/html,test',
    'norie://app/index.html', 'https://user:password@example.com/', 'not a url']) {
    assert.equal(externalLinkFor(url), null, url);
  }
});
