const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const { _electron: electron } = require('playwright');

const appPath = process.env.NORIE_DESKTOP_EXE || path.resolve(
  __dirname, '../..', 'build/windows-desktop/NorieLearning-win32-x64/NorieLearning.exe',
);

async function main() {
  await fs.access(appPath);
  const profile = await fs.mkdtemp(path.join(os.tmpdir(), 'norie-offline-'));
  const environment = { ...process.env };
  // Coding terminals can set this for their own Node helpers; the tested app
  // must start as a desktop application, as it does from Windows Explorer.
  delete environment.ELECTRON_RUN_AS_NODE;
  const launch = () => electron.launch({
    executablePath: appPath,
    env: environment,
    args: ['--test-hidden', `--user-data-dir=${profile}`,
      '--host-resolver-rules=MAP * ~NOTFOUND', '--no-proxy-server'],
    timeout: 60000,
  });
  let application = await launch();
  const errors = [];
  let page;
  async function enableAccessibility() {
    await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60000 });
    await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
    await page.getByRole('button', { name: 'Home Home', exact: true }).waitFor();
  }
  async function checkAnatomy() {
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    const lab = page.getByRole('progressbar', { name: /3D Anatomy Lab/ });
    await lab.waitFor();
    await page.mouse.move(700, 500);
    await page.mouse.wheel(0, 450);
    await page.waitForTimeout(500);
    await lab.click({ position: { x: 40, y: 20 } });
    await page.getByRole('button', { name: /Open 3D Viewer/ }).click();
    const viewer = page.frameLocator('iframe[title="NorieLearning interactive anatomy atlas"]');
    await viewer.locator('canvas').waitFor({ state: 'visible', timeout: 60000 });
    await viewer.locator('#status').waitFor({ state: 'hidden', timeout: 60000 });
    await page.getByRole('button', { name: /Search \d+ parts/ }).click();
    await page.getByRole('textbox').fill('Right femur');
    await page.getByText(/^Right femur\s+Skeletal$/).click({ force: true });
    await page.getByRole('button', { name: 'Isolate', exact: true }).click();
    const canvas = viewer.locator('canvas');
    await page.waitForTimeout(500);
    const size = await canvas.boundingBox();
    await canvas.click({ position: { x: size.width / 2, y: size.height / 2 } });
    const atlasFrame = page.frames().find(frame => frame.url().includes('atlas-viewer.html'));
    await atlasFrame.waitForFunction(() => window.atlasEvents.some(e => e.type === 'selected'));
    await page.screenshot({ path: path.resolve(__dirname, '../../build/windows-offline-anatomy.png') });
    console.log('PASS: detailed atlas loaded, searched, isolated and picked a real mesh offline');
    // Exercise the same responsive UI at a small phone's CSS viewport width.
    const originalSize = await page.evaluate(() => ({ width: innerWidth, height: innerHeight }));
    await page.setViewportSize({ width: 390, height: 844 });
    await page.waitForTimeout(300);
    assert.ok((await canvas.boundingBox()).height > 150, 'The model retains usable phone space');
    await page.screenshot({ path: path.resolve(__dirname, '../../build/windows-offline-anatomy-phone.png') });
    const catalog = JSON.parse(await fs.readFile(path.resolve(__dirname, '../../assets/anatomy/atlas-catalog.json')));
    const beforeXp = await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp')));
    await page.getByRole('button', { name: 'Quiz', exact: true }).click();
    await page.getByText('Identify · 1/10', { exact: true }).waitFor();
    const quizFrame = page.frames().filter(frame => frame.url().includes('atlas-viewer.html')).at(-1);
    for (let item = 0; item < 10; item++) {
      await page.getByText(`Identify · ${item + 1}/10`, { exact: true }).waitFor();
      await quizFrame.waitForFunction(index => window.atlasCommands.filter(c => c.type === 'configure').length >= index + 1, item);
      const target = await quizFrame.evaluate(() => window.atlasCommands.filter(c => c.type === 'configure').at(-1).payload.target);
      const answer = catalog.structures.find(s => s.id === target).name;
      await answerClick(page.getByRole('button', { name: answer, exact: true }));
      await answerClick(page.getByRole('button', { name: 'Check answer', exact: true }));
      await page.getByText(`Correct: ${answer}`, { exact: true }).waitFor();
      await answerClick(page.getByRole('button', { name: item === 9 ? 'Finish quiz' : 'Next structure', exact: true }));
    }
    await page.getByText('Atlas quiz complete', { exact: true }).waitFor();
    await page.waitForFunction(xp => Number(localStorage.getItem('flutter.norie.totalXp')) === xp + 100, beforeXp);
    await page.getByRole('button', { name: 'Back to Anatomy Lab', exact: true }).click();
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp'))), beforeXp + 100);
    console.log('PASS: phone-sized atlas quiz completed offline and awarded exactly 100 XP once');
    let referenceLabel = 'Adult male · BodyParts3D';
    for (const [label, name, count] of [
      ['Joints & ligaments · detail', 'Anterior cruciate ligament (left)', 626],
      ['Endocrine glands · detail', 'Inferior parathyroid gland (left)', 11],
    ]) {
      await page.getByRole('button', { name: referenceLabel, exact: true }).click();
      await page.getByText('Choose an anatomy reference', { exact: true }).waitFor();
      // Flutter merges each ListTile's title and coverage description.
      await page.getByText(new RegExp('^' + label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\s+')).click({ force: true });
      referenceLabel = label;
      await viewer.locator('#status').waitFor({ state: 'hidden', timeout: 60000 });
      const search = page.getByRole('button', { name: `Search ${count} parts`, exact: true });
      await search.click();
      await page.getByRole('textbox').fill(name);
      await page.getByText(new RegExp('^' + name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\s+')).click({ force: true });
      await page.getByRole('button', { name: 'Isolate', exact: true }).click();
      await page.waitForTimeout(500);
      const detailSize = await canvas.boundingBox();
      assert.ok(detailSize.height > 150, `${label} retains usable phone model space`);
      // Reference-specific controls can remount the platform view. Resolve its
      // current frame after switching rather than retaining the previous one.
      const detailFrame = page.frames().find(frame => frame.url().includes('atlas-viewer.html'));
      await detailFrame.evaluate(() => { window.atlasEvents = []; });
      await canvas.click({ position: { x: detailSize.width / 2, y: detailSize.height / 2 } });
      const target = catalog.structures.find(s => s.name === name);
      await detailFrame.waitForFunction(id => window.atlasEvents.some(e => e.type === 'selected' && e.payload.id === id), target.id);
      await page.screenshot({ path: path.resolve(__dirname, `../../build/windows-offline-${target.reference}-phone.png`) });
      console.log(`PASS: ${label} searched, focused and picked offline at phone size`);
    }
    await page.setViewportSize(originalSize);
    await page.reload();
    await enableAccessibility();
  }
  async function answerClick(locator) {
    await locator.waitFor();
    // The quiz uses animated Flutter semantics. Hit the actual canvas target
    // without waiting for every decorative animation to stop moving.
    for (let check = 0; check < 100 && !await locator.isEnabled(); check++) {
      await page.waitForTimeout(50);
    }
    assert.equal(await locator.isEnabled(), true);
    await locator.click({ force: true });
    await page.waitForTimeout(100);
  }
  try {
    await application.context().setOffline(true);
    application.context().setDefaultTimeout(30000);
    page = await application.firstWindow();
    page.on('pageerror', error => errors.push(error.message));
    page.on('console', message => {
      if (message.type() === 'error') console.error('Renderer:', message.text());
    });
    await enableAccessibility();
    assert.equal(await page.getByText('Norie Account', { exact: true }).count(), 0);
    console.log('PASS: first launch with no internet or browser cache');
    await application.context().addInitScript(() => {
      window.atlasEvents = [];
      window.addEventListener('atlas-event', e => window.atlasEvents.push(e.detail));
      window.atlasCommands = [];
      window.addEventListener('message', e => {
        try { const value = typeof e.data === 'string' ? JSON.parse(e.data) : e.data;
          if (value?.version === 1) window.atlasCommands.push(value);
        } catch { /* Non-atlas messages are irrelevant to the test. */ }
      });
      for (const id of ['home.v1', 'learn.v1', 'challenge.v1']) {
        localStorage.setItem(`flutter.norie.tutorial.${id}.complete`, 'true');
      }
    });
    await page.reload();
    await enableAccessibility();
    await checkAnatomy();
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    await page.getByRole('progressbar', { name: /Mathematics/ }).click();
    await page.getByRole('button', { name: /Grade 1 / }).first().click();
    await page.getByRole('button', { name: /Counting to 100/ }).click();
    // Flutter builds the long lesson lazily as the learner scrolls down.
    await page.mouse.move(700, 600);
    for (let scroll = 0; scroll < 8; scroll++) {
      if (await page.getByRole('button', { name: /Choose practice mode/ }).count()) break;
      await page.mouse.wheel(0, 700);
      await page.waitForTimeout(250);
    }
    await page.getByRole('button', { name: /Choose practice mode/ }).click();
    await page.getByRole('button', { name: /Multiple Choice Choose/ }).click();
    for (let item = 0; item < 20; item++) {
      await answerClick(page.getByRole('group', { name: 'Choose the best answer.', exact: true })
        .getByRole('button').first());
      await answerClick(page.getByRole('button', { name: 'Check answer', exact: true }));
      await answerClick(page.getByRole('button', {
        name: item === 19 ? 'Continue to challenge' : 'Next randomized item', exact: true,
      }));
      if ((item + 1) % 5 === 0) console.log(`Answered ${item + 1}/20 offline quiz items`);
    }
    // Wait for Flutter's route transition before selecting the first challenge
    // answer; the outgoing quiz still exposes its Back button during animation.
    await page.getByRole('button', { name: 'Next round', exact: true }).waitFor();
    await page.getByRole('button', { name: 'Back', exact: true }).waitFor({ state: 'hidden' });
    for (let round = 0; round < 3; round++) {
      await page.getByText(`ROUND ${round + 1} OF 3`, { exact: true }).waitFor();
      await page.getByRole('button').first().click();
      await page.getByRole('button', { name: round === 2 ? 'View results' : 'Next round', exact: true }).click();
    }
    await page.waitForFunction(() => Number(localStorage.getItem('flutter.norie.totalXp')) > 0);
    const xp = await page.evaluate(() => JSON.parse(localStorage.getItem('flutter.norie.totalXp')));
    assert.ok(xp > 0);
    const assets = await page.evaluate(async () => Promise.all(
      ['overview-skeleton.glb', 'anatomy-organs.glb'].map(async name => {
        const response = await fetch(`assets/assets/anatomy/${name}`);
        return { name, status: response.status, bytes: (await response.arrayBuffer()).byteLength };
      }),
    ));
    for (const asset of assets) {
      assert.equal(asset.status, 200);
      assert.ok(asset.bytes > 300000);
    }
    console.log('PASS: lesson, 20 quiz answers, 3 challenge rounds and both bundled anatomy models');
    await application.close();
    application = await launch();
    await application.context().setOffline(true);
    application.context().setDefaultTimeout(30000);
    page = await application.firstWindow();
    page.on('pageerror', error => errors.push(error.message));
    await enableAccessibility();
    await page.getByRole('button', { name: 'Progress Progress', exact: true }).click();
    assert.equal(await page.evaluate(() => JSON.parse(localStorage.getItem('flutter.norie.totalXp'))), xp);
    console.log(`PASS: ${xp} XP persisted after closing and reopening offline`);
    await page.screenshot({ path: path.resolve(__dirname, '../../build/windows-offline-progress.png') });
    assert.deepEqual(errors, []);
  } catch (error) {
    if (page) {
      console.error(await page.locator('body').innerText());
      await page.screenshot({ path: path.resolve(__dirname, '../../build/windows-offline-failure.png'), timeout: 5000 })
        .catch(screenshotError => console.error('Failure screenshot:', screenshotError.message));
    }
    throw error;
  } finally {
    await application.close();
    // Retain the isolated temporary profile if investigation is needed.
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });
