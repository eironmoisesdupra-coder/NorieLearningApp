const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const path = require('node:path');
const http = require('node:http');
const { chromium } = require('playwright');

async function main() {
  const root = path.resolve(__dirname, '../../build/web');
  const mime = { '.js': 'text/javascript', '.mjs': 'text/javascript', '.json': 'application/json',
    '.wasm': 'application/wasm', '.html': 'text/html', '.ttf': 'font/ttf', '.svg': 'image/svg+xml' };
  const server = http.createServer(async (req, res) => {
    try {
      let name = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
      if (name.endsWith('/')) name += 'index.html';
      const target = path.resolve(root, '.' + name);
      if (!target.startsWith(root + path.sep)) { res.writeHead(403); res.end(); return; }
      res.setHeader('Content-Type', mime[path.extname(target)] || 'application/octet-stream');
      res.end(await fs.readFile(target));
    } catch { res.writeHead(404); res.end(); }
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const site = `http://127.0.0.1:${server.address().port}/`;
  let browser, page;
  try {
    browser = await chromium.launch({ channel: 'msedge', headless: true });
    const context = await browser.newContext({ viewport: { width: 390, height: 844 }, reducedMotion: 'reduce', serviceWorkers: 'block' });
    await context.route('**/*', route => new URL(route.request().url()).origin === new URL(site).origin
      ? route.continue() : route.abort());
    const key = 'flutter.norie.study.local.offline.v1';
    await context.addInitScript(key => {
      for (const id of ['complete.v2', 'home.v1', 'learn.v1', 'challenge.v1']) {
        localStorage.setItem(`flutter.norie.tutorial.${id}.complete`, 'true');
      }
      if (localStorage.getItem(key)) return;
      const q = { id: 'source-card', position: 0, kind: 'identification',
        prompt: 'Which planet do we live on?', options: [], correct_values: ['Earth'],
        ordered_items: [], explanation: 'We live on Earth.', source_excerpt: 'We live on Earth.', difficulty: 'foundation' };
      const sets = {};
      for (const [id, title, mode] of [['source-practice', 'Source Review Fixture', 'identification'],
        ['source-flashcards', 'Flashcard Source Fixture', 'flashcards']]) {
        sets[id] = { id, user_id: 'local', title, source_type: 'notes', source_name: 'Synthetic test notes',
          generation_mode: mode, requested_count: 1, status: 'ready', created_at: '2026-10-24T00:00:00Z',
          questions: [{ ...q, kind: mode === 'flashcards' ? 'flashcard' : 'identification' }] };
      }
      localStorage.setItem(key, JSON.stringify(JSON.stringify({ sets })));
    }, key);
    page = await context.newPage();
    page.setDefaultTimeout(30000);
    const errors = [];
    page.on('pageerror', error => errors.push(error.message));
    const button = name => page.getByRole('button', { name, exact: true });
    async function click(locator) {
      for (let attempt = 0; attempt < 18 && !await locator.count(); attempt++) {
        await page.mouse.move(180, 450);
        await page.mouse.wheel(0, 420);
        await page.waitForTimeout(120);
      }
      await locator.waitFor();
      // Semantics nodes are rebuilt while Flutter scrolls. Re-resolve the
      // locator after bringing its painted target into the viewport.
      await locator.hover({ force: true });
      await page.waitForTimeout(350);
      await locator.click({ force: true });
    }
    async function open(title) {
      await page.goto(site, { waitUntil: 'domcontentloaded' });
      await page.locator('canvas').first().waitFor({ state: 'visible' });
      await page.locator('flt-semantics-placeholder').waitFor({ state: 'attached' });
      await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
      await button('Home Home').waitFor();
      await click(button('Learn Learn'));
      await click(page.getByRole('checkbox', { name: 'Study Tools', exact: true }));
      await click(button('Open Saved Study Sets'));
      await click(page.getByRole('button', { name: new RegExp(title + '\\s+1 items') }));
      await click(button('Compare answers with source'));
      await page.getByText('Source Accuracy Review', { exact: true }).waitFor();
    }
    const read = () => page.evaluate(key => {
      const raw = JSON.parse(localStorage.getItem(key));
      return typeof raw === 'string' ? JSON.parse(raw) : raw;
    }, key);
    const compared = () => page.getByRole('checkbox', { name: /I checked the answer and explanation against my source/ });
    await open('Flashcard Source Fixture');
    const rewards = () => page.evaluate(() => [localStorage.getItem('flutter.norie.totalXp'), localStorage.getItem('flutter.norie.credits')]);
    const beforeRewards = await rewards();
    assert.equal(await button('Done').count(), 0);
    await click(button('Flag for correction'));
    await page.getByText(/^Flagged:/).waitFor();
    await page.waitForFunction(key => JSON.parse(JSON.parse(localStorage.getItem(key)))
      .sourceReviews?.['source-flashcards']?.records?.['source-card']?.decision === 'flagged', key);
    await open('Flashcard Source Fixture');
    await page.getByText(/^Flagged:/).waitFor();
    await click(button('Clear flag'));
    await click(compared());
    await button('Done').waitFor();
    assert.equal(await button('Done').isEnabled(), true);
    await page.screenshot({ path: 'build/windows-source-comparison-phone.png' });
    await click(button('Done'));
    await click(button('Compare answers with source'));
    assert.equal(await compared().getAttribute('aria-checked'), 'true');
    assert.equal((await read()).sourceReviews['source-flashcards'].records['source-card'].decision, 'compared');
    await button('Back').click();
    // Flutter adds the tooltip text to the menu's accessible name on hover.
    await click(page.getByRole('button', { name: /Card actions/ }));
    await page.getByRole('menuitem', { name: 'Edit', exact: true }).click();
    await page.getByRole('textbox', { name: 'Explanation', exact: true }).fill('Changed synthetic explanation.');
    await click(button('Save'));
    await page.getByRole('textbox', { name: 'Explanation', exact: true }).waitFor({ state: 'hidden' });
    await click(button('Compare answers with source'));
    assert.equal(await compared().getAttribute('aria-checked'), 'false');
    await page.getByText('Changed synthetic explanation.', { exact: true }).waitFor();
    await open('Source Review Fixture');
    await click(compared());
    await click(button('Done'));
    await click(button('Review source and start practice'));
    await page.getByRole('textbox', { name: 'Your answer', exact: true }).waitFor();
    assert.deepEqual(await rewards(), beforeRewards);
    assert.deepEqual(errors, []);
    console.log('PASS: compiled phone source review flags survive reload, flashcards compare independently, edits invalidate comparison, reviewed source practice opens; all external origins blocked');
  } catch (error) {
    if (page) {
      await page.screenshot({ path: 'build/windows-source-review-failure.png' }).catch(() => {});
      console.error('Source fixture semantics:', await page.locator('body').innerText().catch(() => 'unavailable'));
    }
    throw error;
  } finally {
    if (browser) await browser.close();
    await new Promise(resolve => server.close(resolve));
  }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
