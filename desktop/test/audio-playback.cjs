const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const { _electron: electron } = require('playwright');

async function main() {
  const profile = await fs.mkdtemp(path.join(os.tmpdir(), 'norie-audio-offline-'));
  const environment = { ...process.env };
  delete environment.ELECTRON_RUN_AS_NODE;
  const application = await electron.launch({
    executablePath: process.env.NORIE_DESKTOP_EXE || path.resolve(__dirname,
      '../../build/windows-desktop/NorieLearning-win32-x64/NorieLearning.exe'),
    env: environment,
    args: ['--test-hidden', `--user-data-dir=${profile}`,
      '--host-resolver-rules=MAP * ~NOTFOUND', '--no-proxy-server'],
    timeout: 60000,
  });
  let page;
  try {
    await application.context().setOffline(true);
    await application.context().addInitScript(() => {
      window.norieAudioEvents = [];
      window.norieAudioPlayers = new Set();
      const play = HTMLMediaElement.prototype.play;
      const pause = HTMLMediaElement.prototype.pause;
      HTMLMediaElement.prototype.play = function () {
        const source = this.src;
        const volume = this.volume;
        window.norieAudioPlayers.add(this);
        window.norieAudioEvents.push({ type: 'attempt', source, volume });
        return play.call(this).then(result => {
          window.norieAudioEvents.push({ type: 'play', source, volume });
          return result;
        }, error => {
          window.norieAudioEvents.push({ type: 'error', source, error: error.name });
          throw error;
        });
      };
      HTMLMediaElement.prototype.pause = function () {
        window.norieAudioEvents.push({ type: 'pause', source: this.src });
        return pause.call(this);
      };
      for (const id of ['complete.v2', 'home.v1', 'learn.v1', 'challenge.v1']) {
        localStorage.setItem(`flutter.norie.tutorial.${id}.complete`, 'true');
      }
    });
    page = await application.firstWindow();
    const browser = await application.context().newCDPSession(page);
    await browser.send('Emulation.setFocusEmulationEnabled', { enabled: true });
    await browser.send('Page.setWebLifecycleState', { state: 'active' });
    await page.setViewportSize({ width: 1000, height: 800 });
    const errors = [];
    page.on('console', message => {
      if (message.type() === 'error') console.error('Renderer:', message.text());
    });
    page.on('requestfailed', request => console.log('Failed request:', request.url(), request.failure()));
    page.on('pageerror', error => errors.push(error.message));
    async function enableAccessibility() {
      await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60000 });
      await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
      await page.getByRole('button', { name: 'Home Home', exact: true }).waitFor();
      await page.evaluate(() => window.dispatchEvent(new Event('focus')));
    }
    async function openSettings() {
      await page.getByRole('button', { name: 'Open menu', exact: true }).click();
      await page.waitForTimeout(300);
      await page.mouse.move(100, 350);
      for (let scroll = 0; scroll < 6; scroll++) {
        if (await page.getByText('Settings', { exact: true }).count()) break;
        await page.mouse.wheel(0, 500);
        await page.waitForTimeout(200);
      }
      await page.getByText('Settings', { exact: true }).click();
      await page.getByRole('button', { name: 'Test Sound', exact: true }).waitFor();
      await page.waitForTimeout(800);
    }
    const key = suffix => `flutter.norie.audio.${suffix}`;
    const correctCount = () => page.evaluate(() => window.norieAudioEvents.filter(
      event => event.type === 'play' && event.source.endsWith('/correct.mp3')).length);
    await page.reload();
    await enableAccessibility();
    // Semantic buttons bypass Flutter's widget pointer Listener. A real click
    // must still reach the browser gesture capture and prime all six players.
    await page.getByRole('button', { name: 'Learn Learn', exact: true }).click();
    await page.waitForFunction(() => window.norieAudioEvents.filter(
      event => event.type === 'play' && event.source.startsWith('data:audio/wav')).length === 6);
    await openSettings();
    const testSound = page.getByRole('button', { name: 'Test Sound', exact: true });
    async function playTestSound() {
      const bounds = await testSound.boundingBox();
      assert.ok(bounds && bounds.y > 0 && bounds.y + bounds.height < 800);
      await page.mouse.click(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2);
    }
    await playTestSound();
    await page.waitForFunction(() => window.norieAudioEvents.some(event =>
      event.type === 'play' && event.source.endsWith('/correct.mp3') && event.volume > 0));
    console.log('PASS: real accessibility gesture unlocks and decodes bundled correct-answer SFX offline');

    await page.getByRole('switch', { name: 'Sound Effects', exact: true }).click({ force: true });
    await page.waitForFunction(storageKey => localStorage.getItem(storageKey) === 'false', key('sfxEnabled'));
    for (let frame = 0; frame < 30 && await testSound.isEnabled(); frame++) {
      await page.waitForTimeout(50);
    }
    assert.equal(await testSound.isEnabled(), false);
    const mutedCount = await correctCount();
    const mutedEffectCount = await page.evaluate(() => window.norieAudioEvents.filter(
      event => event.type === 'play' && event.source.includes('/audio/sfx/')).length);
    await page.getByRole('switch', { name: /Quiet Music During Lessons/ }).click({ force: true });
    await page.waitForTimeout(250);
    assert.equal(await correctCount(), mutedCount);
    assert.equal(await page.evaluate(() => window.norieAudioEvents.filter(
      event => event.type === 'play' && event.source.includes('/audio/sfx/')).length), mutedEffectCount);
    assert.equal(await page.evaluate(() => [...window.norieAudioPlayers].every(player => player.paused)), true);
    await page.getByRole('switch', { name: 'Sound Effects', exact: true }).click({ force: true });
    await page.waitForFunction(storageKey => localStorage.getItem(storageKey) === 'true', key('sfxEnabled'));
    for (let frame = 0; frame < 30 && !await testSound.isEnabled(); frame++) {
      await page.waitForTimeout(50);
    }
    assert.equal(await testSound.isEnabled(), true);
    await page.waitForTimeout(200);
    await playTestSound();
    await page.waitForFunction(count => window.norieAudioEvents.filter(event =>
      event.type === 'play' && event.source.endsWith('/correct.mp3')).length > count, mutedCount);
    console.log('PASS: SFX disable stops playback, and re-enable restores playback');

    await page.getByRole('switch', { name: 'Sound Effects', exact: true }).click({ force: true });
    await page.waitForFunction(storageKey => localStorage.getItem(storageKey) === 'false', key('sfxEnabled'));
    await page.reload();
    await enableAccessibility();
    await openSettings();
    assert.equal(await page.evaluate(storageKey => localStorage.getItem(storageKey), key('sfxEnabled')), 'false');
    assert.equal(await testSound.isEnabled(), false);
    await playTestSound();
    await page.waitForTimeout(250);
    assert.equal(await correctCount(), 0);
    assert.equal(await page.evaluate(() => window.norieAudioEvents.some(event => event.type === 'error')), false);
    assert.deepEqual(errors, []);
    console.log('PASS: muted SFX preference persists after reload and prevents playback');
  } catch (error) {
    if (page) {
      console.error('Visible UI:', await page.locator('body').innerText());
      console.error('Audio diagnostics:', await page.evaluate(() => window.norieAudioEvents));
      console.error('Media states:', await page.evaluate(() => [...window.norieAudioPlayers].map(player => ({
        source: player.src, currentSource: player.currentSrc, ready: player.readyState,
        network: player.networkState, error: player.error?.message, paused: player.paused,
      }))));
      await page.screenshot({ path: path.resolve(__dirname, '../../build/windows-audio-failure.png'), timeout: 5000 }).catch(() => {});
    }
    throw error;
  } finally {
    await application.close();
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });
