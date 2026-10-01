import fs from 'node:fs/promises';
import http from 'node:http';
import path from 'node:path';
import assert from 'node:assert/strict';
import { chromium } from '../../desktop/node_modules/playwright/index.mjs';

const root = path.resolve(import.meta.dirname, '../..');
const assets = path.join(root, 'assets/anatomy');
const catalog = JSON.parse(await fs.readFile(path.join(assets, 'atlas-catalog.json')));
const server = http.createServer(async (req, res) => {
  const name = path.basename(new URL(req.url, 'http://localhost').pathname);
  try {
    const bytes = await fs.readFile(path.join(assets, name));
    res.setHeader('Content-Type', name.endsWith('.html') ? 'text/html' : name.endsWith('.js') ? 'text/javascript' : name.endsWith('.json') ? 'application/json' : 'model/gltf-binary');
    res.end(bytes);
  } catch { res.writeHead(404).end(); }
});
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const base = `http://127.0.0.1:${server.address().port}`;
const browser = await chromium.launch({ channel: process.platform === 'win32' ? 'msedge' : undefined, headless: true,
  args: ['--enable-unsafe-swiftshader'] });
const page = await browser.newPage({ viewport: { width: 900, height: 900 } });
page.setDefaultTimeout(60000);
const errors = [];
page.on('pageerror', e => errors.push(e.message));
page.on('console', m => { if (m.type() === 'error') console.error(m.text()); });
await page.route('**/*', route => route.request().url().startsWith(base) ? route.continue() : route.abort());
await page.addInitScript(() => {
  window.atlasEvents = [];
  window.addEventListener('atlas-event', e => window.atlasEvents.push(e.detail));
});
const command = (type, payload = {}) => page.evaluate(({ type, payload }) => window.norieAtlasCommand({ version: 1, session: 'smoke', type, payload }), { type, payload });
async function load(reference, systems, options = {}) {
  await page.evaluate(() => { window.atlasEvents = []; });
  await command('configure', { reference, systems, ...options });
  await page.waitForFunction(() => window.atlasEvents.some(e => ['loaded', 'error'].includes(e.type)));
  const events = await page.evaluate(() => window.atlasEvents);
  assert.equal(events.some(e => e.type === 'error'), false, JSON.stringify(events));
  assert.ok(events.find(e => e.type === 'loaded').payload.count > 0);
}
try {
  await page.goto(`${base}/atlas-viewer.html?session=smoke`);
  await page.waitForFunction(() => window.atlasEvents.some(e => e.type === 'ready'));
  for (const system of ['skeletal', 'articular', 'muscular', 'cardiovascular', 'arterial', 'venous', 'nervous', 'lymphatic', 'respiratory', 'digestive', 'urinary', 'reproductive', 'endocrine', 'integumentary', 'sensory']) {
    await load('male', [system]);
    console.log('Rendered', system);
  }
  await load('male', ['skeletal']);
  const femur = catalog.structures.find(s => s.reference === 'male' && /^right femur$/i.test(s.name));
  assert.ok(femur, 'A named right femur is required for the actual-picking test');
  await command('isolate', { id: femur.id });
  await page.waitForTimeout(600);
  await page.locator('canvas').click({ position: { x: 450, y: 450 } });
  await page.waitForFunction(id => window.atlasEvents.some(e => e.type === 'selected' && e.payload.id === id), femur.id);
  await page.evaluate(() => { window.atlasEvents = []; });
  await page.mouse.move(450, 450);
  await page.mouse.down();
  await page.mouse.move(550, 450, { steps: 8 });
  await page.mouse.move(450, 450, { steps: 8 });
  await page.mouse.up();
  assert.equal(await page.evaluate(() => window.atlasEvents.some(e => e.type === 'selected')), false, 'A drag returning to its origin must not pick');
  await command('hide', { id: femur.id });
  await page.evaluate(() => { window.atlasEvents = []; });
  await page.locator('canvas').click({ position: { x: 450, y: 450 } });
  assert.equal(await page.evaluate(() => window.atlasEvents.some(e => e.type === 'selected')), false);
  await command('select', { id: femur.id });
  await command('focus', { id: femur.id });
  await page.waitForTimeout(400);
  await page.locator('canvas').click({ position: { x: 450, y: 450 } });
  await page.waitForFunction(id => window.atlasEvents.some(e => e.type === 'selected' && e.payload.id === id), femur.id);
  await load('female', ['reproductive']);
  await page.screenshot({ path: path.join(root, 'build/anatomy-female-reference.png') });
  await load('lymphatic', ['lymphatic']);
  await page.screenshot({ path: path.join(root, 'build/anatomy-lymphatic-reference.png') });
  await load('ear', ['sensory']);
  await page.screenshot({ path: path.join(root, 'build/anatomy-ear-reference.png') });
  await page.route('**/male-skeletal.glb', async route => { await new Promise(resolve => setTimeout(resolve, 150)); await route.continue(); });
  await page.evaluate(() => { window.atlasEvents = []; });
  await command('configure', { reference: 'male', systems: ['skeletal'] });
  await command('select', { id: femur.id });
  await command('focus', { id: femur.id });
  await page.waitForFunction(() => window.atlasEvents.some(e => e.type === 'loaded'));
  await page.locator('canvas').click({ position: { x: 450, y: 450 } });
  await page.waitForFunction(id => window.atlasEvents.some(e => e.type === 'selected' && e.payload.id === id), femur.id);
  await load('male', ['skeletal'], { target: femur.id, quiz: true });
  await page.evaluate(() => { window.atlasEvents = []; });
  await page.locator('canvas').click({ position: { x: 450, y: 450 } });
  assert.equal(await page.evaluate(() => window.atlasEvents.some(e => e.type === 'selected')), false, 'Quiz clicking cannot disclose names');
  assert.equal((await page.locator('body').innerText()).includes(femur.name), false);
  await load('male', ['skeletal', 'muscular']);
  await page.screenshot({ path: path.join(root, 'build/anatomy-body-reference.png') });
  assert.deepEqual(errors, []);
  console.log('PASS: 15 systems, female reproductive, lymphatic and ear detail scenes, actual mesh picking and hidden-mesh rejection; external networking blocked.');
} finally { await browser.close(); await new Promise(resolve => server.close(resolve)); }
