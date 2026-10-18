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
  const page = await browser.newPage({ viewport: { width: 800, height: 800 } });
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  const base = `http://127.0.0.1:${server.address().port}`;
  await page.route('**/*', route => route.request().url().startsWith(base) ? route.continue() : route.abort());
  await page.goto(`${base}/test.html`);
  await page.waitForFunction(() => window.AtlasScene);
  const ids = await page.evaluate(async () => {
    const catalog = await (await fetch('atlas-catalog.json')).json();
    window.events = [];
    window.atlas = new window.AtlasScene(document.querySelector('canvas'), catalog, (type, payload) => window.events.push({ type, payload }));
    await window.atlas.command('configure', { reference: 'male', systems: ['skeletal', 'muscular'] });
    const right = catalog.structures.find(s => s.reference === 'male' && /^right femur$/i.test(s.name)).id;
    const left = catalog.structures.find(s => s.reference === 'male' && /^left femur$/i.test(s.name)).id;
    const foreign = catalog.structures.find(s => s.reference === 'female').id;
    window.atlas.command('isolate', { id: right });
    return { right, left, foreign };
  });
  await page.waitForTimeout(250);
  await page.locator('canvas').click({ position: { x: 400, y: 400 } });
  await page.waitForFunction(id => window.events.some(e => e.type === 'selected' && e.payload.id === id), ids.right);
  const checks = await page.evaluate(({ right, left, foreign }) => {
    const atlas = window.atlas;
    atlas.command('restore');
    const pairAccepted = atlas.command('compare', { ids: [right, left] });
    const material = id => atlas.meshes().find(m => m.userData.structureId === id).material;
    const colors = [material(right).color.getHexString(), material(left).color.getHexString()];
    const foreignRejected = atlas.command('compare', { ids: [right, foreign] }) === false;
    const invalidRejected = atlas.command('compare', { ids: [right, 'missing'] }) === false;
    atlas.command('opacity', { value: .5 });
    atlas.command('systemLayer', { system: 'skeletal', opacity: .4 });
    const alpha = material(right).opacity;
    atlas.command('hide', { id: left });
    const hiddenRejected = atlas.command('compare', { ids: [right, left] }) === false;
    const clearedWhenHidden = atlas.state.compareIds.length === 0;
    atlas.command('systemLayer', { system: 'skeletal', visible: false });
    const invisible = !atlas.meshes().find(m => m.userData.structureId === right).visible;
    atlas.command('restore');
    const restored = material(right).opacity === 1 && atlas.state.compareIds.length === 0 && atlas.state.layerOverrides.size === 0 && atlas.state.isolated === null;
    atlas.command('camera', { view: 'left' });
    const cameraFinite = [...atlas.camera.position].every(Number.isFinite);
    atlas.command('isolate', { id: right });
    return { pairAccepted, colors, foreignRejected, invalidRejected, alpha, hiddenRejected, clearedWhenHidden, invisible, restored, cameraFinite };
  }, ids);
  assert.equal(checks.pairAccepted, true);
  assert.notEqual(checks.colors[0], checks.colors[1]);
  assert.equal(checks.alpha, .2);
  for (const name of ['foreignRejected', 'invalidRejected', 'hiddenRejected', 'clearedWhenHidden', 'invisible', 'restored', 'cameraFinite']) assert.equal(checks[name], true, name);
  await page.waitForTimeout(250);
  if (process.argv[3]) await page.screenshot({ path: process.argv[3] });
  await page.evaluate(() => { window.atlas.dispose(); window.atlas.dispose(); });
  assert.deepEqual(errors, []);
  console.log('PASS: actual mesh picking, same-reference comparison colors, cross-reference/invalid/hidden rejection, layer/global alpha, restore, camera preset and repeated disposal; external networking blocked.');
} finally {
  await browser?.close();
  await new Promise(resolve => server.close(resolve));
}
