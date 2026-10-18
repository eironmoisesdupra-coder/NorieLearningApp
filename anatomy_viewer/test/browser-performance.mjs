// Real WebGL and offline models; visibility transitions are dispatched explicitly.
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import http from 'node:http';
import path from 'node:path';
import { pathToFileURL } from 'node:url';
import { build } from 'esbuild';

const root = path.resolve(import.meta.dirname, '../..');
const assets = path.resolve(process.argv[2] ?? path.join(root, 'assets/anatomy'));
const { chromium } = await import(pathToFileURL(process.env.ATLAS_PLAYWRIGHT ?? path.join(root, 'desktop/node_modules/playwright/index.mjs')));
const bundle = await build({ stdin: { contents: `import {AtlasScene} from './src/scene.mjs'; window.AtlasScene = AtlasScene;`, resolveDir: path.join(root, 'anatomy_viewer') }, bundle: true, write: false, format: 'esm', platform: 'browser' });
const server = http.createServer(async (req, res) => {
  const name = path.basename(new URL(req.url, 'http://localhost').pathname);
  try {
    if (name === 'test.html') { res.setHeader('Content-Type', 'text/html'); res.end('<style>body{margin:0}canvas{width:800px;height:800px}</style><canvas></canvas><script type="module" src="scene.js"></script>'); }
    else if (name === 'scene.js') { res.setHeader('Content-Type', 'text/javascript'); res.end(bundle.outputFiles[0].contents); }
    else { res.setHeader('Content-Type', name.endsWith('.json') ? 'application/json' : 'model/gltf-binary'); res.end(await fs.readFile(path.join(assets, name))); }
  } catch { res.writeHead(404).end(); }
});
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
let browser;
try {
  browser = await chromium.launch({ channel: process.platform === 'win32' ? 'msedge' : undefined, headless: true, args: ['--enable-unsafe-swiftshader'] });
  const page = await browser.newPage({ viewport: { width: 800, height: 800 }, deviceScaleFactor: 1 });
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const base = `http://127.0.0.1:${server.address().port}`;
  await page.route('**/*', route => route.request().url().startsWith(base) ? route.continue() : route.abort());
  await page.goto(`${base}/test.html`);
  await page.waitForFunction(() => window.AtlasScene);
  await page.evaluate(async () => {
    const catalog = await (await fetch('atlas-catalog.json')).json();
    window.events = [];
    const atlas = window.atlas = new window.AtlasScene(document.querySelector('canvas'), catalog, (type, payload) => window.events.push({ type, payload }));
    window.frames = 0;
    const render = atlas.renderer.render.bind(atlas.renderer);
    atlas.renderer.render = (...args) => { window.frames++; return render(...args); };
    await atlas.configure({ reference: 'male', systems: ['skeletal', 'muscular'] });
    window.femur = catalog.structures.find(s => s.reference === 'male' && /^right femur$/i.test(s.name)).id;
    atlas.command('isolate', { id: window.femur });
  });
  const count = () => page.evaluate(() => window.frames);
  await page.waitForTimeout(1000);
  let before = await count();
  await page.waitForTimeout(350);
  assert.equal(await count(), before, 'idle scene must stop rendering');

  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.locator('canvas').click({ position: { x: 400, y: 400 } });
  await page.waitForFunction(() => events.some(e => e.type === 'selected' && e.payload.id === window.femur));
  // Selection is emitted synchronously; the invalidated render runs on the next RAF.
  await page.waitForFunction(previous => frames > previous, before);
  assert.ok(await count() > before, 'mesh picking must refresh after idle');
  if (process.argv[3]) await page.screenshot({ path: process.argv[3] });
  const position = await page.evaluate(() => [...atlas.camera.position]);
  before = await count();
  await page.mouse.move(400, 400); await page.mouse.down();
  await page.mouse.move(520, 430, { steps: 8 }); await page.mouse.up();
  await page.waitForTimeout(1800);
  assert.notDeepEqual(await page.evaluate(() => [...atlas.camera.position]), position, 'real orbit input must move camera');
  assert.ok(await count() > before, 'orbit input must wake idle renderer');
  before = await count(); await page.waitForTimeout(350);
  assert.equal(await count(), before, 'damping must settle and stop');

  before = await count();
  await page.evaluate(() => { Object.defineProperty(document, 'hidden', { configurable: true, value: true }); document.dispatchEvent(new Event('visibilitychange')); atlas.command('camera', { view: 'front' }); });
  await page.waitForTimeout(250);
  assert.equal(await count(), before, 'hidden document must pause rendering');
  await page.evaluate(() => { Object.defineProperty(document, 'hidden', { configurable: true, value: false }); document.dispatchEvent(new Event('visibilitychange')); });
  await page.waitForFunction(previous => frames > previous, before);

  const quality = await page.evaluate(() => {
    const accepted = atlas.command('quality', { profile: 'low' });
    const ratio = atlas.renderer.getPixelRatio();
    const bad = atlas.command('quality', { profile: 'ultra' });
    return { accepted, ratio, bad };
  });
  assert.deepEqual(quality, { accepted: true, ratio: 1, bad: false });
  before = await count();
  await page.evaluate(() => { document.querySelector('canvas').style.width = '640px'; });
  await page.waitForFunction(previous => frames > previous, before);
  assert.equal(await page.evaluate(() => atlas.camera.aspect), .8);

  await page.evaluate(() => { window.loss = atlas.renderer.getContext().getExtension('WEBGL_lose_context'); window.loss.loseContext(); });
  await page.waitForFunction(() => atlas.contextLost === true);
  before = await count();
  await page.evaluate(() => atlas.command('camera', { view: 'left' }));
  await page.waitForTimeout(300);
  assert.equal(await count(), before, 'lost context must pause rendering');
  await page.evaluate(() => window.loss.restoreContext());
  await page.waitForFunction(() => atlas.contextLost === false);
  await page.waitForFunction(previous => frames > previous, before);
  assert.ok(await page.evaluate(() => events.some(e => e.type === 'error')), 'context loss must show recoverable error');
  assert.equal(await page.evaluate(() => events.filter(e => e.type === 'loaded').at(-1).payload.count), 1,
    'context recovery must report current visible count after isolation');

  const retry = await page.evaluate(async () => {
    let released = 0;
    const oldGeometries = new Set(atlas.meshes().map(mesh => mesh.geometry));
    oldGeometries.forEach(geometry => geometry.addEventListener('dispose', () => released++));
    const original = atlas.loader.loadAsync.bind(atlas.loader);
    let fail = true;
    atlas.loader.loadAsync = url => { if (fail) { fail = false; return Promise.reject(Error('fixture load failure')); } return original(url); };
    let failed = false;
    try { await atlas.configure({ reference: 'female', systems: ['reproductive'], requestId: 7 }); } catch { failed = true; }
    await atlas.configure({ reference: 'female', systems: ['reproductive'], requestId: 8 });
    return { failed, loaded: events.some(e => e.type === 'loaded' && e.payload.requestId === 8),
      released, expectedReleases: oldGeometries.size, assets: [...atlas.loaded.keys()], diagnostics: atlas.metrics.snapshot() };
  });
  assert.equal(retry.failed, true);
  assert.equal(retry.loaded, true);
  assert.equal(retry.released, retry.expectedReleases, 'reference switch must dispose old geometries');
  assert.deepEqual(retry.assets, ['female-reproductive']);
  assert.ok(retry.diagnostics.renderedFrames > 0);
  assert.equal(retry.diagnostics.peakMemoryBytes, null);

  await page.evaluate(() => { atlas.command('camera', { view: 'front' }); atlas.dispose(); atlas.dispose(); });
  before = await count();
  await page.evaluate(() => { document.dispatchEvent(new Event('visibilitychange')); document.querySelector('canvas').dispatchEvent(new Event('webglcontextrestored')); });
  await page.waitForTimeout(250);
  assert.equal(await count(), before, 'dispose must cancel all future rendering');
  assert.deepEqual(errors, []);
  console.log('PASS: offline picking after idle, live orbit/damping, visibility pause/resume, quality/resize refresh, actual WebGL context loss/restore, failed-load retry and idempotent dispose.');
} finally {
  await browser?.close();
  await new Promise(resolve => server.close(resolve));
}
