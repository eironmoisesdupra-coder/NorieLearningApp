const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '../..');

test('all twelve production SFX are real small files with documented provenance', () => {
  const manifest = JSON.parse(fs.readFileSync(path.join(root, 'assets/audio/sfx-manifest.json')));
  assert.equal(manifest.length, 12);
  assert.equal(new Set(manifest.map(item => item.file)).size, 12);
  for (const item of manifest) {
    const bytes = fs.readFileSync(path.join(root, 'assets/audio/sfx', item.file));
    assert.equal(bytes.length, item.bytes);
    assert.ok(bytes.length > 1000 && bytes.length < 100000);
    assert.ok(item.seconds > 0 && item.seconds <= 2.5);
    assert.equal(crypto.createHash('sha256').update(bytes).digest('hex'), item.sha256);
    assert.equal(item.generator, 'scripts/generate_adventure_audio.py');
    assert.equal(item.recipe, path.basename(item.file, '.mp3'));
    assert.ok(fs.existsSync(path.join(root, item.generator)));
    if (item.file.startsWith('ui_') || item.file === 'quiz_select.mp3') {
      assert.ok(item.seconds <= .4, `${item.file} must remain a quick interface cue`);
    }
  }
});

test('audio assets are included by Flutter and the deployed offline asset manifest', () => {
  const pubspec = fs.readFileSync(path.join(root, 'pubspec.yaml'), 'utf8');
  assert.ok(pubspec.includes('- assets/audio/sfx/'));
  assert.ok(pubspec.includes('- assets/audio/sfx/classic/'));
  assert.ok(pubspec.includes('- assets/audio/music/'));
  const deployment = fs.readFileSync(path.join(root, '.github/workflows/deploy-pages.yml'), 'utf8');
  assert.ok(deployment.includes('"assets/**/*"'));
  const worker = fs.readFileSync(path.join(root, 'branding/web/norie-sw.js'), 'utf8');
  assert.ok(worker.includes('/*__NORIE_EXTRA_ASSETS__*/'));
  const manager = fs.readFileSync(path.join(root, 'lib/core/audio/norie_audio_manager.dart'), 'utf8');
  assert.ok(manager.includes('availableMusic = classicMusic'));
  assert.ok(manager.includes('NorieAudioTheme.spaceAdventure'));
});

test('five adventure tracks match the bundled manifest and playlist', () => {
  const manifest = JSON.parse(fs.readFileSync(path.join(root, 'assets/audio/music-manifest.json')));
  const manager = fs.readFileSync(path.join(root, 'lib/core/audio/norie_audio_manager.dart'), 'utf8');
  const credits = fs.readFileSync(path.join(root, 'assets/audio/music/README.md'), 'utf8');
  assert.equal(manifest.license, 'CC0-1.0');
  assert.equal(manifest.licenseUrl, 'https://creativecommons.org/publicdomain/zero/1.0/');
  assert.equal(manifest.origin, 'original-synthesis');
  assert.ok(credits.includes('original, instrumental synth-adventure'));
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
    assert.ok(track.bpm >= 116 && track.bpm <= 130);
    assert.ok(track.seconds >= 90 && track.seconds <= 105);
    assert.equal(track.bars, 48);
    assert.equal(track.generator, 'scripts/generate_adventure_audio.py');
    assert.ok(!track.download, 'Bundled originals never require a download');
  }
});

test('Classic tracks and effects retain their licensed bytes and selectable paths', () => {
  const musicManifest = JSON.parse(fs.readFileSync(
    path.join(root, 'assets/audio/music-classic-manifest.json')));
  const sfxManifest = JSON.parse(fs.readFileSync(
    path.join(root, 'assets/audio/sfx-classic-manifest.json')));
  const manager = fs.readFileSync(
    path.join(root, 'lib/core/audio/norie_audio_manager.dart'), 'utf8');
  const credits = fs.readFileSync(
    path.join(root, 'assets/audio/music/README.md'), 'utf8');
  assert.equal(musicManifest.license, 'CC0-1.0');
  assert.equal(musicManifest.tracks.length, 5);
  assert.equal(sfxManifest.length, 12);
  assert.ok(manager.includes("? 'classic/' : ''"));
  for (const track of musicManifest.tracks) {
    const bytes = fs.readFileSync(path.join(root, 'assets/audio/music', track.file));
    assert.equal(bytes.length, track.bytes, track.file);
    assert.ok(track.seconds > 120 && track.seconds < 500, track.file);
    assert.equal(crypto.createHash('sha256').update(bytes).digest('hex'), track.sha256);
    assert.ok(manager.includes(`'audio/music/${track.file}'`));
    assert.ok(credits.includes(track.title));
  }
  for (const effect of sfxManifest) {
    const bytes = fs.readFileSync(
      path.join(root, 'assets/audio/sfx/classic', effect.file));
    assert.equal(bytes.length, effect.bytes, effect.file);
    assert.equal(crypto.createHash('sha256').update(bytes).digest('hex'), effect.sha256);
  }
});
