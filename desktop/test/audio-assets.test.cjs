const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '../..');

test('all twelve production SFX are real small files with documented provenance', () => {
  const manifest = JSON.parse(fs.readFileSync(path.join(root, 'assets/audio/sfx-manifest.json')));
  const provenance = JSON.parse(fs.readFileSync(path.join(root, 'assets/audio/generation-provenance.json')));
  assert.equal(manifest.length, 12);
  assert.equal(new Set(manifest.map(item => item.file)).size, 12);
  for (const item of manifest) {
    const bytes = fs.readFileSync(path.join(root, 'assets/audio/sfx', item.file));
    assert.equal(bytes.length, item.bytes);
    assert.ok(bytes.length > 1000 && bytes.length < 100000);
    assert.ok(item.seconds > 0 && item.seconds <= 2.5);
    assert.equal(crypto.createHash('sha256').update(bytes).digest('hex'), item.sha256);
    assert.ok(provenance.some(p => p.file === `sfx/${item.file}` && p.taskId && p.prompt));
  }
});

test('audio assets are included by Flutter and the deployed offline asset manifest', () => {
  const pubspec = fs.readFileSync(path.join(root, 'pubspec.yaml'), 'utf8');
  assert.ok(pubspec.includes('- assets/audio/sfx/'));
  const deployment = fs.readFileSync(path.join(root, '.github/workflows/deploy-pages.yml'), 'utf8');
  assert.ok(deployment.includes('"assets/**/*"'));
  const worker = fs.readFileSync(path.join(root, 'web/norie-sw.js'), 'utf8');
  assert.ok(worker.includes('/*__NORIE_EXTRA_ASSETS__*/'));
  const manager = fs.readFileSync(path.join(root, 'lib/core/audio/norie_audio_manager.dart'), 'utf8');
  assert.ok(manager.includes('availableMusic = []'), 'Missing production music must not be presented as available');
});
