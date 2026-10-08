const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const path = require('node:path');
const http = require('node:http');
const {chromium} = require('playwright');

async function main() {
  const branding = path.resolve(__dirname, '../../branding/web');
  const worker = await fs.readFile(path.join(branding, 'norie-sw.js'), 'utf8');
  const updates = await fs.readFile(path.join(branding, 'norie-updates.mjs'), 'utf8');
  let version = 'first';
  const server = http.createServer((request, response) => {
    const name = new URL(request.url, 'http://localhost').pathname;
    response.setHeader('Cache-Control', 'no-store');
    if (name.endsWith('/norie-sw.js')) {
      response.setHeader('Content-Type', 'text/javascript');
      response.end(worker.replaceAll('__NORIE_BUILD_SHA__', version));
    } else if (name.endsWith('/norie-updates.mjs')) {
      response.setHeader('Content-Type', 'text/javascript'); response.end(updates);
    } else if (name.endsWith('/atlas-catalog.json')) {
      response.setHeader('Content-Type', 'application/json');
      response.end(JSON.stringify({schemaVersion: 1, assets: []}));
    } else if (name.endsWith('/index.html') || name.endsWith('/')) {
      response.setHeader('Content-Type', 'text/html');
      response.end(`<html data-norie-build="${version}"><body><p id="version">${version}</p><script type="module" src="norie-updates.mjs"></script></body></html>`);
    } else {response.end('offline fixture');}
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const base = `http://127.0.0.1:${server.address().port}/NorieLearningApp/`;
  const browser = await chromium.launch({channel: 'msedge', headless: true});
  try {
    const context = await browser.newContext();
    const page = await context.newPage();
    const errors = [];
    page.on('pageerror', error => errors.push(error.message));
    await page.goto(base);
    await page.evaluate(() => navigator.serviceWorker.ready);
    await page.reload();
    await page.waitForFunction(() => !!navigator.serviceWorker.controller);
    await page.evaluate(() => localStorage.setItem('learner-progress', 'preserve-me'));
    const second = await context.newPage();
    await second.goto(base);
    version = 'second';
    await page.evaluate(() => window.dispatchEvent(new Event('norie-check-update')));
    await page.getByRole('button', {name: 'Reload to update', exact: true}).waitFor();
    await page.getByRole('button', {name: 'Reload to update', exact: true}).click();
    await page.getByText(/Close other NorieLearning tabs/).waitFor();
    assert.equal(await page.locator('#version').innerText(), 'first');
    assert.equal(await second.locator('#version').innerText(), 'first');
    await second.close();
    await page.getByRole('button', {name: 'Reload to update', exact: true}).click();
    await page.waitForFunction(() => document.querySelector('#version')?.textContent === 'second');
    assert.equal(await page.evaluate(() => localStorage.getItem('learner-progress')), 'preserve-me');
    await context.setOffline(true);
    await page.reload();
    await page.locator('#version').waitFor();
    assert.equal(await page.locator('#version').innerText(), 'second');
    assert.deepEqual(errors, []);
    console.log('PASS: actual two-tab update blocked until safe, new bundle loaded, progress preserved, offline reload passed');
  } finally {
    await browser.close(); await new Promise(resolve => server.close(resolve));
  }
}
main().catch(error => {console.error(error); process.exitCode = 1;});
