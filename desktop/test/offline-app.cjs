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
  const externalFontRequests = new Set();
  let page;
  let foregroundPage;
  async function enableAccessibility() {
    if (foregroundPage !== page) {
      const browser = await application.context().newCDPSession(page);
      await browser.send('Emulation.setFocusEmulationEnabled', { enabled: true });
      await browser.send('Page.setWebLifecycleState', { state: 'active' });
      foregroundPage = page;
    }
    await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60000 });
    await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
    const home = page.getByRole('button', { name: 'Home Home', exact: true });
    const closeGuide = page.getByRole('button', { name: 'Close', exact: true });
    await home.or(closeGuide).first().waitFor();
    if (await closeGuide.isVisible()) await closeGuide.click();
    await home.waitFor();
    // The test window stays hidden; emulate the foreground learner session.
    await page.evaluate(() => window.dispatchEvent(new Event('focus')));
  }
  async function checkAnatomy() {
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    await page.getByRole('checkbox', { name: 'Activities', exact: true }).click();
    const lab = page.getByRole('button', { name: /^3D Anatomy Lab/ });
    await lab.waitFor();
    await page.waitForTimeout(350);
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
    await captureHiddenPage('windows-offline-anatomy.png');
    console.log('PASS: detailed atlas loaded, searched, isolated and picked a real mesh offline');
    // The retained skeleton lesson must never fall back to painted body layers.
    for (const exitLabel of ['Articular', 'Open full 3D atlas']) {
      await page.getByRole('button', { name: 'Skeleton fundamentals', exact: true }).click();
      await page.getByText('Calibrated skeleton study view', { exact: true }).waitFor();
      await page.getByRole(exitLabel === 'Articular' ? 'checkbox' : 'button',
        { name: exitLabel, exact: true }).click();
      await page.getByText('Calibrated skeleton study view', { exact: true }).waitFor({ state: 'hidden' });
      const activeViewer = page.frameLocator('iframe[title="NorieLearning interactive anatomy atlas"]:visible');
      await activeViewer.locator('canvas').waitFor({ state: 'visible', timeout: 60000 });
      await activeViewer.locator('#status').waitFor({ state: 'hidden', timeout: 60000 });
      const systems = await activeViewer.locator('canvas').evaluate(canvas => canvas.ownerDocument.defaultView.atlasCommands.filter(c => c.type === 'configure').at(-1).payload.systems);
      assert.deepEqual([...systems].sort(), exitLabel === 'Articular' ? ['articular', 'skeletal'] : ['skeletal']);
      // The first Back is navigation; the other presets the rear camera view.
      await page.getByRole('button', { name: 'Back', exact: true }).first().click();
      await page.locator('iframe[title="NorieLearning interactive anatomy atlas"]').nth(1)
        .waitFor({ state: 'detached' });
    }
    console.log('PASS: skeleton fundamentals category and full-atlas exits use real geometry offline');
    // Exercise the same responsive UI at a small phone's CSS viewport width.
    const originalSize = await page.evaluate(() => ({ width: innerWidth, height: innerHeight }));
    await setHiddenViewport({ width: 390, height: 844 });
    await page.waitForTimeout(300);
    assert.ok((await canvas.boundingBox()).height > 150, 'The model retains usable phone space');
    await captureHiddenPage('windows-offline-anatomy-phone.png');
    const catalog = JSON.parse(await fs.readFile(path.resolve(__dirname, '../../assets/anatomy/atlas-catalog.json')));
    const beforeXp = await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp')));
    await page.getByRole('button', { name: 'Quiz', exact: true }).click();
    await page.getByRole('button', { name: 'Start 20-question quiz', exact: true }).click();
    await page.getByText('Identify · 1/20', { exact: true }).waitFor();
    const quizFrame = page.frames().filter(frame => frame.url().includes('atlas-viewer.html')).at(-1);
    for (let item = 0; item < 20; item++) {
      await page.getByText(`Identify · ${item + 1}/20`, { exact: true }).waitFor();
      await quizFrame.waitForFunction(index => window.atlasCommands.filter(c => c.type === 'configure').length >= index + 1, item);
      const target = await quizFrame.evaluate(() => window.atlasCommands.filter(c => c.type === 'configure').at(-1).payload.target);
      const answer = catalog.structures.find(s => s.id === target).name;
      await answerClick(page.getByRole('button', { name: answer, exact: true }));
      await answerClick(page.getByRole('button', { name: 'Check answer', exact: true }));
      await page.getByText(`Correct: ${answer}`, { exact: true }).waitFor();
      await answerClick(page.getByRole('button', { name: item === 19 ? 'Finish quiz' : 'Next structure', exact: true }));
    }
    await page.getByRole('button', { name: 'Continue', exact: true }).waitFor();
    await page.waitForFunction(xp => Number(localStorage.getItem('flutter.norie.totalXp')) === xp + 200, beforeXp);
    await page.getByRole('button', { name: 'Continue', exact: true }).click();
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp'))), beforeXp + 200);
    console.log('PASS: phone-sized atlas quiz completed offline and awarded exactly 200 XP once');
    await page.getByText('Atlas quiz setup', { exact: true }).waitFor();
    await page.getByRole('button', { name: 'Back', exact: true }).click();
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
      await captureHiddenPage(`windows-offline-${target.reference}-phone.png`);
      console.log(`PASS: ${label} searched, focused and picked offline at phone size`);
    }
    // Windows display scaling can round restored content bounds by one CSS pixel.
    await setHiddenViewport(originalSize, 1);
    const sounds = await page.evaluate(() => window.norieAudioEvents);
    assert.ok(sounds.some(e => e.played && e.volume > 0 && e.source.endsWith('/correct.mp3')),
      'Actual offline correct-answer audio must play after a gesture');
    assert.ok(!sounds.some(e => e.error), 'No blocked or broken audio');
    console.log(`PASS: bundled SFX decoded and played after a real user gesture offline (${sounds.length} playback events)`);
    await page.reload();
    await enableAccessibility();
  }
  let nativeDeckId;
  async function nativeScroll(locator) {
    for (let i = 0; i < 18 && !await locator.count(); i++) {
      await page.mouse.move(180, 450);
      await page.mouse.wheel(0, 420);
      await page.waitForTimeout(120);
    }
    await locator.waitFor();
    // Flutter can replace semantics nodes during the phone viewport resize.
    // Locator hover scrolls and re-resolves a detached node without activating
    // it; scrollIntoViewIfNeeded retains a stale ElementHandle. Do not combine
    // trial clicks with force: force can bypass trial's event interception.
    await locator.hover({ force: true });
  }
  async function nativeLibrary() {
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    await page.getByRole('checkbox', { name: 'Study Tools', exact: true }).click();
    const library = page.getByRole('button', { name: 'Open Saved Study Sets', exact: true });
    await nativeScroll(library);
    await library.click({ force: true });
    await page.getByRole('button', { name: /Integer linear equations\s+20 items/ }).click({ force: true });
    const start = page.getByRole('button', { name: 'Start Practice', exact: true });
    await nativeScroll(start);
    await start.click({ force: true });
  }
  async function checkNativeQuiz() {
    const viewport = await page.evaluate(() => ({ width: innerWidth, height: innerHeight }));
    const baseline = await page.evaluate(() => ({
      credits: Number(localStorage.getItem('flutter.norie.credits')),
      xp: Number(localStorage.getItem('flutter.norie.totalXp')),
    }));
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    await page.getByRole('button', { name: 'Create with Norie AI', exact: true }).click();
    await page.getByRole('button', { name: 'Native Engine · Free offline practice', exact: true }).click();
    await setHiddenViewport({ width: 390, height: 844 });
    const count = page.getByRole('checkbox', { name: '20', exact: true });
    await nativeScroll(count);
    await count.click({ force: true });
    await captureHiddenPage('windows-native-generator-phone.png');
    const generate = page.getByRole('button', { name: 'Generate Native Quiz', exact: true });
    await nativeScroll(generate);
    await answerClick(generate);
    await page.getByText('Study Set', { exact: true }).waitFor();
    const deck = await page.evaluate(() => {
      const raw = JSON.parse(localStorage.getItem('flutter.norie.study.local.offline.v1'));
      const state = typeof raw === 'string' ? JSON.parse(raw) : raw;
      return Object.values(state.sets).find(set => set.source_type === 'native');
    });
    assert.ok(deck);
    nativeDeckId = deck.id;
    assert.equal(deck.questions.length, 20);
    assert.equal(deck.generation_metadata.provider, 'native');
    assert.equal(deck.generation_metadata.validation, 'computationallyChecked');
    assert.equal(new Set(deck.questions.map(q => q.id)).size, 20);
    for (const q of deck.questions) {
      const m = /^Solve for x: (\d+)x \+ (\d+) = (-?\d+)\.$/.exec(q.prompt);
      assert.ok(m);
      assert.equal(Number(m[1]) * Number(q.correct_values[0]) + Number(m[2]), Number(m[3]));
      assert.equal(q.kind, 'single_select');
    }
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.credits'))), baseline.credits);
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp'))), baseline.xp);
    console.log('PASS: native20 generated offline with distinct identities, independently checked answers and no generation charge/reward');
    const start = page.getByRole('button', { name: 'Start Practice', exact: true });
    await nativeScroll(start);
    await answerClick(start);
    // A live-region update also creates flt-announcement-polite with the same
    // text. Match the actual counter without assuming a progressbar parent.
    const nativeQuestion = number => page.getByText(`Question ${number} of 20`, { exact: true })
      .and(page.locator(':not(flt-announcement-polite):not(flt-announcement-assertive)'));
    await nativeQuestion(1).waitFor();
    async function checkWrongChoice() {
      const question = await page.evaluate(id => {
        const raw = JSON.parse(localStorage.getItem('flutter.norie.study.local.offline.v1'));
        const state = typeof raw === 'string' ? JSON.parse(raw) : raw;
        const snapshot = state.quizSessions[id].snapshot;
        return snapshot.questions[snapshot.index];
      }, nativeDeckId);
      await page.mouse.move(180, 240); await page.mouse.wheel(0, -2000);
      await page.getByText(question.prompt, { exact: true }).waitFor();
      const wrong = question.options.find(option => !question.correct_values.includes(option));
      const choice = page.getByText(wrong, { exact: true });
      await nativeScroll(choice); await answerClick(choice);
      const check = page.getByRole('button', { name: 'Check Answer', exact: true });
      await nativeScroll(check); await answerClick(check);
    }
    await checkWrongChoice();
    const next = page.getByRole('button', { name: 'Next', exact: true });
    await nativeScroll(next); await answerClick(next);
    await page.reload(); await enableAccessibility();
    await nativeLibrary();
    await nativeQuestion(2).waitFor();
    await captureHiddenPage('windows-native-resume-phone.png');
    console.log('PASS: native20 resumes at question2 after reload at390x844');
    async function completeWrong(from) {
      for (let i = from; i < 20; i++) {
        await nativeQuestion(i + 1).waitFor();
        await checkWrongChoice();
        const advance = page.getByRole('button', { name: i === 19 ? 'View Results' : 'Next', exact: true });
        await nativeScroll(advance); await answerClick(advance);
      }
      await page.getByRole('button', { name: 'Continue', exact: true }).waitFor();
    }
    await completeWrong(1);
    await page.waitForFunction(xp => Number(localStorage.getItem('flutter.norie.totalXp')) === xp + 20, baseline.xp);
    console.log('PASS: native20 completion awarded the existing20XP');
    await page.getByRole('button', { name: 'Try Again', exact: true }).click({ force: true });
    await completeWrong(0);
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.totalXp'))), baseline.xp + 20);
    assert.equal(await page.evaluate(() => Number(localStorage.getItem('flutter.norie.credits'))), baseline.credits);
    console.log('PASS: native20 generated offline without credits/inference; exact math, reload/resume, completion20XP once and replay zeroXP');
    await setHiddenViewport(viewport, 1);
    await page.reload(); await enableAccessibility();
  }
  let originalMinimum;
  async function setHiddenViewport(size, tolerance = 0) {
    // Native capture and the rendered surface must share the same viewport/DPR.
    // CDP emulation can crop a hidden Electron surface on scaled Windows displays.
    const window = await application.browserWindow(page);
    const browser = await application.context().newCDPSession(page);
    try {
      originalMinimum ??= await window.evaluate(browserWindow => browserWindow.getMinimumSize());
      await browser.send('Emulation.clearDeviceMetricsOverride');
      await window.evaluate((browserWindow, { size, minimum }) => {
        browserWindow.setMinimumSize(0, 0);
        browserWindow.setContentSize(size.width, size.height);
        if (size.width >= minimum[0] && size.height >= minimum[1]) {
          browserWindow.setMinimumSize(...minimum);
        }
      }, { size, minimum: originalMinimum });
      await page.waitForFunction(({ size, tolerance }) =>
        Math.abs(innerWidth - size.width) <= tolerance &&
        Math.abs(innerHeight - size.height) <= tolerance, { size, tolerance });
    } finally {
      await browser.detach();
      await window.dispose();
    }
  }
  async function captureHiddenPage(fileName, settleMs = 100, timeoutMs = 30000) {
    // CDP capture stalls on idle WebGL and animated Flutter surfaces in a
    // hidden Electron window. Native capture validates the same real scene
    // without showing the window or changing demand rendering/offline checks.
    const window = await application.browserWindow(page);
    let captureTimeout;
    try {
      const image = await Promise.race([
        window.evaluate(async (browserWindow, delay) => {
          await browserWindow.webContents.capturePage(undefined,
            { stayHidden: true, stayAwake: true });
          // The first capture wakes painting but can return the preceding frame.
          // Let the requested UI transition paint before the artifact.
          if (delay) await new Promise(resolve => setTimeout(resolve, delay));
          const snapshot = await browserWindow.webContents.capturePage(undefined,
            { stayHidden: true, stayAwake: true });
          return { png: snapshot.toDataURL(), size: snapshot.getSize(), empty: snapshot.isEmpty(), visible: browserWindow.isVisible() };
        }, settleMs),
        new Promise((_, reject) => {
          captureTimeout = setTimeout(() => reject(new Error('Hidden page capture timed out')), timeoutMs);
        }),
      ]);
      assert.equal(image.empty, false);
      assert.equal(image.visible, false);
      assert.ok(image.size.width > 0 && image.size.height > 0);
      assert.ok(image.png.startsWith('data:image/png;base64,'));
      await fs.writeFile(path.resolve(__dirname, '../../build', fileName),
        Buffer.from(image.png.split(',')[1], 'base64'));
    } finally {
      clearTimeout(captureTimeout);
      await window.dispose();
    }
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
    page.on('request', request => {
      const url = new URL(request.url());
      if (url.hostname === 'fonts.gstatic.com') externalFontRequests.add(url.origin + url.pathname);
    });
    page.on('console', message => {
      if (message.type() === 'error') console.error('Renderer:', message.text());
    });
    await enableAccessibility();
    assert.equal(await page.getByText('Norie Account', { exact: true }).count(), 0);
    console.log('PASS: first launch with no internet or browser cache');
    await application.context().addInitScript(() => {
      window.norieAudioEvents = [];
      const originalPlay = HTMLMediaElement.prototype.play;
      HTMLMediaElement.prototype.play = function () {
        const source = this.src;
        const volume = this.volume;
        return originalPlay.call(this).then(result => {
          window.norieAudioEvents.push({ source, volume, played: true });
          return result;
        }, error => {
          window.norieAudioEvents.push({ source, volume, error: error.name });
          throw error;
        });
      };
      window.atlasEvents = [];
      window.addEventListener('atlas-event', e => window.atlasEvents.push(e.detail));
      window.atlasCommands = [];
      window.addEventListener('message', e => {
        try { const value = typeof e.data === 'string' ? JSON.parse(e.data) : e.data;
          if (value?.version === 1) window.atlasCommands.push(value);
        } catch { /* Non-atlas messages are irrelevant to the test. */ }
      });
      for (const id of ['complete.v2', 'home.v1', 'learn.v1', 'challenge.v1']) {
        localStorage.setItem(`flutter.norie.tutorial.${id}.complete`, 'true');
      }
    });
    await page.reload();
    await enableAccessibility();
    await checkAnatomy();
    await checkNativeQuiz();
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    await page.getByRole('checkbox', { name: 'Subjects', exact: true }).click();
    await page.getByRole('button', { name: /^Mathematics\b/ }).click();
    await page.getByRole('button', { name: /Grade 1 / }).first().click();
    await page.getByRole('button', { name: /Counting to 100/ }).click();
    await page.getByRole('button', { name: 'Start mission', exact: true }).click();
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
    await page.getByRole('button', { name: 'Continue', exact: true }).click();
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
    await page.getByRole('button', { name: 'Continue', exact: true }).waitFor();
    assert.deepEqual([...externalFontRequests], [], 'Core lessons/results must use bundled fonts, without online fallback attempts');
    await captureHiddenPage('windows-offline-quiz-outro.png', 2000);
    await page.getByRole('button', { name: 'Continue', exact: true }).click();
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
    page.on('request', request => {
      const url = new URL(request.url());
      if (url.hostname === 'fonts.gstatic.com') externalFontRequests.add(url.origin + url.pathname);
    });
    await enableAccessibility();
    await page.getByRole('button', { name: 'Progress Progress', exact: true }).click();
    assert.equal(await page.evaluate(() => JSON.parse(localStorage.getItem('flutter.norie.totalXp'))), xp);
    const nativeRetained = await page.evaluate(id => {
      const raw = JSON.parse(localStorage.getItem('flutter.norie.study.local.offline.v1'));
      const state = typeof raw === 'string' ? JSON.parse(raw) : raw;
      return state.sets[id]?.questions.length === 20 && state.rewarded.includes(id);
    }, nativeDeckId);
    assert.equal(nativeRetained, true, 'Native questions and completion receipt persist across app restart');
    console.log(`PASS: ${xp} XP persisted after closing and reopening offline`);
    await captureHiddenPage('windows-offline-progress.png');
    assert.deepEqual([...externalFontRequests], [], 'Restarted offline app must not request online fonts');
    assert.deepEqual(errors, []);
  } catch (error) {
    if (page) {
      console.error(await page.locator('body').first().innerText());
      await captureHiddenPage('windows-offline-failure.png', 0, 5000)
        .catch(screenshotError => console.error('Failure screenshot:', screenshotError.message));
    }
    throw error;
  } finally {
    await application.close();
    // Retain the isolated temporary profile if investigation is needed.
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });
