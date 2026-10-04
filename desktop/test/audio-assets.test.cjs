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
  assert.ok(pubspec.includes('- assets/audio/music/'));
  const deployment = fs.readFileSync(path.join(root, '.github/workflows/deploy-pages.yml'), 'utf8');
  assert.ok(deployment.includes('"assets/**/*"'));
  const worker = fs.readFileSync(path.join(root, 'web/norie-sw.js'), 'utf8');
  assert.ok(worker.includes('/*__NORIE_EXTRA_ASSETS__*/'));
  const manager = fs.readFileSync(path.join(root, 'lib/core/audio/norie_audio_manager.dart'), 'utf8');
  assert.ok(manager.includes('availableMusic = expectedMusic'));
});

test('five production music files match the licensed source manifest and playlist', () => {
  const manifest = JSON.parse(fs.readFileSync(path.join(root, 'assets/audio/music-manifest.json')));
  const manager = fs.readFileSync(path.join(root, 'lib/core/audio/norie_audio_manager.dart'), 'utf8');
  const credits = fs.readFileSync(path.join(root, 'assets/audio/music/README.md'), 'utf8');
  assert.equal(manifest.license, 'CC0-1.0');
  assert.equal(manifest.licenseUrl, 'https://creativecommons.org/publicdomain/zero/1.0/');
  assert.ok(credits.includes(manifest.artist));
  assert.equal(manifest.tracks.length, 5);
  assert.equal(new Set(manifest.tracks.map(track => track.file)).size, 5);
  for (const track of manifest.tracks) {
    const bytes = fs.readFileSync(path.join(root, 'assets/audio/music', track.file));
    assert.equal(bytes.length, track.bytes, track.file);
    assert.ok(bytes.length > 1000000);
    assert.equal(crypto.createHash('sha256').update(bytes).digest('hex'), track.sha256, track.file);
    assert.ok(bytes.subarray(0, 3).toString() === 'ID3' || (bytes[0] === 0xff && (bytes[1] & 0xe0) === 0xe0), track.file);
    assert.ok(manager.includes(`'audio/music/${track.file}'`));
    assert.ok(credits.includes(track.title));
    assert.ok(credits.includes(track.source));
    assert.equal(new URL(track.download).hostname, 'opengameart.org');
  }
});
