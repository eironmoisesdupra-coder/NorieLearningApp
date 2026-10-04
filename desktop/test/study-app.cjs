const assert = require('node:assert/strict');
const path = require('node:path');
const { chromium } = require('playwright');

async function main() {
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const context = await browser.newContext({ viewport: { width: 1200, height: 800 } });
  const page = await context.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  page.setDefaultTimeout(20000);
  const storageKey = 'flutter.norie.study.local.offline.v1';
  await page.addInitScript(key => {
    if (localStorage.getItem(key)) return;
    const question = {
      id: 'preview-answer', position: 0, kind: 'identification',
      prompt: 'Which planet do we live on?', options: [], correct_values: ['Earth'],
      ordered_items: [], explanation: 'Earth is the planet where we live.',
      source_excerpt: 'We live on Earth.', difficulty: 'foundation',
    };
    const deck = {
      id: 'preview-deck', title: 'Local Test Deck', source_type: 'notes',
      source_name: 'Synthetic test notes', generation_mode: 'identification',
      requested_count: 1, status: 'ready', created_at: new Date().toISOString(), questions: [question],
    };
    localStorage.setItem(key, JSON.stringify(JSON.stringify({ sets: { 'preview-deck': deck } })));
  }, storageKey);
  const button = name => page.getByRole('button', { name, exact: true });
  const click = async name => {
    await button(name).waitFor();
    await button(name).click({ force: true });
    await page.waitForTimeout(400);
  };
  const screenshot = name => page.screenshot({ path: path.resolve(__dirname, '../../build', name) });
  const state = () => page.evaluate(key => JSON.parse(JSON.parse(localStorage.getItem(key))), storageKey);
  const settle = () => page.evaluate(() => new Promise(resolve =>
    requestAnimationFrame(() => requestAnimationFrame(resolve))));
  const scrollDown = async () => {
    await page.locator('flt-semantics').evaluateAll(elements => {
      for (const element of elements) {
        if (element.scrollHeight > element.clientHeight + 100) element.scrollTop = element.scrollHeight;
      }
    });
    await settle();
  };
  try {
    await page.goto('http://127.0.0.1:8751/');
    await page.locator('flt-semantics-placeholder').waitFor({ state: 'attached' });
    await page.locator('flt-semantics-placeholder').dispatchEvent('click');
    await click('Learn Learn');
    await button('Skip').waitFor();
    await click('Skip');
    await button('Skip').waitFor({ state: 'hidden' });
    await settle();
    for (let attempt = 0; attempt < 6 && !await button('Open Saved Study Sets').count(); attempt++) {
      await page.mouse.move(600, 450);
      await page.mouse.wheel(0, 1500);
      await page.waitForTimeout(400);
    }
    await click('Open Saved Study Sets');
    const search = page.getByRole('textbox', { name: 'Search decks', exact: true });
    await search.fill('no-match');
    await page.getByText('No matching decks.', { exact: true }).waitFor();
    await search.fill('Local');
    await page.getByRole('button', { name: /Local Test Deck 1 items/ }).click({ force: true });
    await button('Review due cards (1)').waitFor();
    await page.waitForTimeout(400);
    await screenshot('study-deck-desktop.png');

    await page.setViewportSize({ width: 390, height: 844 });
    await page.waitForTimeout(400);
    await scrollDown();
    await click('Add flashcard');
    await page.getByRole('textbox', { name: 'Question', exact: true }).fill('What does a seed become?');
    await page.getByRole('textbox', { name: 'Accepted answers (one per line)', exact: true }).fill('A seedling');
    await page.getByRole('textbox', { name: 'Explanation', exact: true }).fill('A seed grows into a seedling.');
    await screenshot('study-editor-phone.png');
    await click('Save');
    await page.getByRole('textbox', { name: 'Question', exact: true }).waitFor({ state: 'hidden' });
    await page.getByRole('textbox', { name: 'Search cards', exact: true }).fill('seed');
    await page.getByRole('button', { name: 'Card actions', exact: true }).click({ force: true });
    await page.getByRole('menuitem', { name: 'Edit', exact: true }).click({ force: true });
    await page.waitForTimeout(400);
    await page.getByRole('textbox', { name: 'Question', exact: true }).fill('What grows from a seed?');
    await click('Save');
    await page.getByRole('textbox', { name: 'Question', exact: true }).waitFor({ state: 'hidden' });
    assert.equal((await state()).sets['preview-deck'].questions.length, 2);
    assert.ok((await state()).sets['preview-deck'].questions.some(question => question.prompt === 'What grows from a seed?'));
    await page.getByRole('button', { name: 'Card actions', exact: true }).click({ force: true });
    await page.getByRole('menuitem', { name: 'Delete', exact: true }).click({ force: true });
    await click('Delete');
    await page.getByText('Delete this card?', { exact: true }).waitFor({ state: 'hidden' });
    assert.equal((await state()).sets['preview-deck'].questions.length, 1);
    await page.getByRole('textbox', { name: 'Search cards', exact: true }).fill('');
    await click('Review due cards (1)');
    await click('Reveal answer');
    await button('Got it').waitFor();
    await screenshot('study-review-phone.png');
    await click('Got it');
    await page.getByText('Review complete', { exact: true }).waitFor();
    assert.ok((await state()).reviews['preview-deck']['preview-answer']);
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp') || 0)), 0);
    await click('Back to deck');
    await click('Start Practice');
    const check = button('Check Answer');
    await check.waitFor();
    assert.equal(await check.isEnabled(), false);
    await page.getByRole('textbox', { name: 'Your answer', exact: true }).fill('Earth');
    await click('Check Answer');
    await page.getByText('+5 XP', { exact: true }).waitFor();
    await screenshot('study-reward-phone.png');
    await page.getByText('+5 XP', { exact: true }).waitFor({ state: 'hidden' });
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp'))), 5);
    assert.equal((await state()).answerRewards['preview-deck'].length, 1);
    assert.deepEqual(errors, []);
    console.log('PASS: library search, add/edit/delete, phone review persistence, no self-rated XP, typed-answer reward, desktop/phone screenshots');
  } catch (error) {
    await screenshot('study-browser-failure.png');
    console.error(await page.locator('body').innerText());
    throw error;
  } finally {
    await browser.close();
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });