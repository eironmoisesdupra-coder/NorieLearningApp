// Browser-only renderer measurements. This does not certify physical devices.
import fs from 'node:fs/promises';
import http from 'node:http';
import path from 'node:path';
import { build } from 'esbuild';
import { pathToFileURL } from 'node:url';

const root = path.resolve(import.meta.dirname, '../..');
const assets = path.resolve(process.argv[2] ?? path.join(root, 'assets/anatomy'));
const output = process.argv[3];
const playwrightPath = process.env.ATLAS_PLAYWRIGHT ?? path.join(root, 'desktop/node_modules/playwright/index.mjs');
const { chromium } = await import(pathToFileURL(playwrightPath));
const bundle = await build({ stdin: { contents: `import {AtlasScene} from './src/scene.mjs'; window.AtlasScene = AtlasScene;`, resolveDir: path.join(root, 'anatomy_viewer') }, bundle: true, write: false, format: 'esm', platform: 'browser' });
const server = http.createServer(async (req, res) => {
  const name = path.basename(new URL(req.url, 'http://localhost').pathname);
  try {
    if (name === 'benchmark.html') { res.setHeader('Content-Type', 'text/html'); res.end('<style>html,body{margin:0}canvas{width:800px;height:800px}</style><canvas id="canvas"></canvas><script type="module" src="scene.js"></script>'); }
    else if (name === 'scene.js') { res.setHeader('Content-Type', 'text/javascript'); res.end(bundle.outputFiles[0].contents); }
    else { res.setHeader('Content-Type', name.endsWith('.json') ? 'application/json' : 'model/gltf-binary'); res.end(await fs.readFile(path.join(assets, name))); }
  } catch { res.writeHead(404).end(); }
});
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const base = `http://127.0.0.1:${server.address().port}`;
let browser;
try {
  browser = await chromium.launch({ channel: process.platform === 'win32' ? 'msedge' : undefined, headless: true, args: ['--enable-unsafe-swiftshader'] });
  const page = await browser.newPage({ viewport: { width: 800, height: 800 }, deviceScaleFactor: 1 });
  await page.route('**/*', route => route.request().url().startsWith(base) ? route.continue() : route.abort());
  await page.goto(`${base}/benchmark.html`);
  await page.waitForFunction(() => window.AtlasScene);
  const report = await page.evaluate(async () => {
    const catalog = await (await fetch('atlas-catalog.json')).json();
    const events = [];
    const atlas = new window.AtlasScene(document.querySelector('canvas'), catalog, (type, payload) => events.push({ type, payload }));
    window.benchmarkAtlas = atlas;
    let frames = [];
    const render = atlas.renderer.render.bind(atlas.renderer);
    atlas.renderer.render = (...args) => {
      const started = performance.now();
      render(...args);
      frames.push({ ms: performance.now() - started, calls: atlas.renderer.info.render.calls, triangles: atlas.renderer.info.render.triangles });
    };
    const loadStarted = performance.now();
    await atlas.configure({ reference: 'male', systems: ['skeletal', 'muscular'], requestId: 1 });
    const loadMs = performance.now() - loadStarted;
    const sample = async action => {
      frames = [];
      const started = performance.now();
      action?.();
      await new Promise(resolve => setTimeout(resolve, 2000));
      const elapsedMs = performance.now() - started;
      const timings = frames.map(f => f.ms).sort((a, b) => a - b);
      return { elapsedMs, renderedFrames: frames.length, meanRenderMs: timings.length ? timings.reduce((a, b) => a + b, 0) / timings.length : 0,
        p95RenderMs: timings[Math.max(0, Math.ceil(timings.length * .95) - 1)] ?? 0,
        lastDrawCalls: frames.at(-1)?.calls ?? null, lastTriangles: frames.at(-1)?.triangles ?? null };
    };
    const idle = await sample();
    const camera = await sample(() => atlas.command('camera', { view: 'left' }));
    const gl = atlas.renderer.getContext();
    const debug = gl.getExtension('WEBGL_debug_renderer_info');
    const gpu = debug ? gl.getParameter(debug.UNMASKED_RENDERER_WEBGL) : gl.getParameter(gl.RENDERER);
    const result = { reference: 'male', systems: ['skeletal', 'muscular'], viewport: [800, 800], devicePixelRatio, userAgent: navigator.userAgent,
      gpu, loadMs, visibleStructures: atlas.state.visibleIds().length, loadedAssets: atlas.loaded.size, idle, camera,
      errors: events.filter(e => e.type === 'error'), scope: 'Headless desktop browser only; no physical-device, FPS, memory, power, or thermal certification.' };
    atlas.dispose();
    return result;
  });
  report.browserVersion = browser.version();
  report.recordedAt = new Date().toISOString();
  const json = JSON.stringify(report, null, 2);
  if (output) await fs.writeFile(output, json + '\n');
  console.log(json);
} finally {
  await browser?.close();
  await new Promise(resolve => server.close(resolve));
}
