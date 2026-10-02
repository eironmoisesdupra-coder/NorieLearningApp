const fs = require('node:fs/promises');
const path = require('node:path');
const { createHash } = require('node:crypto');
const { chromium } = require('playwright');
const metadata = require('./package.json');

const repo = path.resolve(__dirname, '..');
const web = path.join(repo, 'build', 'web');
const stage = path.join(repo, 'build', 'desktop-app');

async function bundleDecoder() {
  const root = path.join(stage, 'web', 'draco');
  await fs.mkdir(root, { recursive: true });
  const files = {
    'draco_decoder.js': '30e4d486fa020737af10e3c56197693e5b904bdc05b8bfa5d7b06751dec6da04',
    'draco_decoder.wasm': 'c55a594e8ffd18426d36b27fea9618af3df5e173640a3e56d46f09d76f0574f2',
    'draco_wasm_wrapper.js': 'e8049906ef3f8f75d3456c22a3f31bfdfe5b5b5bd09ccdec613b9e9a49d554d8',
    'LICENSE.txt': 'd3709b0fb4b8a94bbb1d02b8a2e484f258b0d9c5c5a01f940391f3fe662cd1a4',
  };
  for (const [name, checksum] of Object.entries(files)) {
    const url = name === 'LICENSE.txt'
      ? 'https://raw.githubusercontent.com/google/draco/1.5.6/LICENSE'
      : `https://www.gstatic.com/draco/versioned/decoders/1.5.6/${name}`;
    const response = await fetch(url, { signal: AbortSignal.timeout(60000) });
    if (!response.ok) throw new Error(`Decoder download failed: ${name} (${response.status})`);
    const bytes = Buffer.from(await response.arrayBuffer());
    if (createHash('sha256').update(bytes).digest('hex') !== checksum) {
      throw new Error(`Decoder checksum mismatch: ${name}`);
    }
    await fs.writeFile(path.join(root, name), bytes);
  }
}

async function makeIcon() {
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  try {
    const page = await browser.newPage({ viewport: { width: 256, height: 256 } });
    const svg = await fs.readFile(path.join(repo, 'branding', 'web', 'norie-logo.svg'), 'utf8');
    await page.setContent(`<style>html,body{margin:0;width:256px;height:256px}svg{width:256px;height:256px}</style>${svg}`);
    const png = await page.screenshot({ omitBackground: true });
    await fs.writeFile(path.join(stage, 'norie-logo.png'), png);
    // Windows supports a PNG-compressed 256px image inside an ICO container.
    const header = Buffer.alloc(22);
    header.writeUInt16LE(1, 2);
    header.writeUInt16LE(1, 4);
    header.writeUInt16LE(1, 10);
    header.writeUInt16LE(32, 12);
    header.writeUInt32LE(png.length, 14);
    header.writeUInt32LE(22, 18);
    const icon = path.join(stage, 'norie-logo.ico');
    await fs.writeFile(icon, Buffer.concat([header, png]));
    return icon;
  } finally {
    await browser.close();
  }
}

async function main() {
  for (const file of [
    'index.html', 'flutter_bootstrap.js', 'main.dart.js',
    'canvaskit/canvaskit.js', 'canvaskit/canvaskit.wasm',
    'assets/assets/fonts/NorieEmoji.ttf',
    'assets/assets/anatomy/overview-skeleton.glb',
    'assets/assets/anatomy/anatomy-organs.glb',
    'assets/packages/model_viewer_plus/assets/model-viewer.min.js',
  ]) await fs.access(path.join(web, file));
  const originalIndex = await fs.readFile(path.join(web, 'index.html'), 'utf8');
  if (!originalIndex.includes('<base href="/">')) {
    throw new Error('Build the desktop web bundle with --base-href "/" first.');
  }
  await fs.mkdir(stage, { recursive: true });
  await fs.cp(web, path.join(stage, 'web'), { recursive: true, force: true });
  await bundleDecoder();
  for (const file of ['main.cjs', 'asset-policy.cjs']) {
    await fs.copyFile(path.join(__dirname, file), path.join(stage, file));
  }
  await fs.writeFile(path.join(stage, 'package.json'), JSON.stringify({
    name: metadata.name, productName: metadata.productName,
    version: metadata.version, description: metadata.description, main: metadata.main,
    author: metadata.author,
  }, null, 2));
  // Every resource is already bundled. Desktop startup never needs to download
  // a service-worker cache, while the ordinary web build retains its worker.
  const index = originalIndex
    .replace('<script type="module"', '<script>self.ModelViewerElement = { dracoDecoderLocation: new URL("./draco/", document.baseURI).href };</script>\n  <script type="module"')
    .replace('startOfflineCache();', '// Desktop learning files are bundled.')
    .replaceAll('__NORIE_BUILD_SHA__', 'desktop-' + metadata.version)
    .replace('Preparing offline access while the app loads.', 'Loading your lessons…');
  await fs.writeFile(path.join(stage, 'web', 'index.html'), index);
  const bootstrapPath = path.join(stage, 'web', 'flutter_bootstrap.js');
  const bootstrap = await fs.readFile(bootstrapPath, 'utf8');
  await fs.writeFile(bootstrapPath, bootstrap.replace(
    /_flutter\.loader\.load\(\{\s*serviceWorkerSettings:\s*\{.*?\}\s*\}\);/s,
    '_flutter.loader.load();',
  ));
  const icon = await makeIcon();
  const { packager } = await import('@electron/packager');
  const outputs = await packager({
    dir: stage, out: path.join(repo, 'build', 'windows-desktop'),
    platform: 'win32', arch: 'x64', name: 'NorieLearning', executableName: 'NorieLearning',
    electronVersion: metadata.devDependencies.electron,
    asar: true, prune: true, overwrite: true, icon,
    appVersion: metadata.version,
    win32metadata: { ProductName: 'NorieLearning', FileDescription: 'NorieLearning offline learning app' },
  });
  for (const output of outputs) {
    await fs.copyFile(path.join(__dirname, 'README.txt'), path.join(output, 'README.txt'));
  }
  console.log('Windows app:', outputs.join(', '));
}

main().catch(error => { console.error(error); process.exitCode = 1; });
