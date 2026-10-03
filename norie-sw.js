const CACHE_NAME = 'norie-offline-5ed28a5408b9fa422e6593811b8639ea49041b12';

const REQUIRED_ASSETS = [
  './',
  './index.html',
  './flutter_bootstrap.js',
  './main.dart.js',
  './manifest.json',
  './norie-logo.svg',
  './assets/assets/fonts/NorieEmoji.ttf',
  './assets/assets/anatomy/overview-skeleton.glb',
  './assets/assets/anatomy/anatomy-organs.glb',
  './assets/assets/anatomy/atlas-viewer.html',
  './assets/assets/anatomy/atlas-viewer.js',
  './assets/assets/anatomy/atlas-catalog.json',
  './assets/assets/audio/sfx/ui_tap.mp3',
  './assets/assets/audio/sfx/ui_select.mp3',
  './assets/assets/audio/sfx/ui_open.mp3',
  './assets/assets/audio/sfx/ui_back.mp3',
  './assets/assets/audio/sfx/quiz_select.mp3',
  './assets/assets/audio/sfx/correct.mp3',
  './assets/assets/audio/sfx/wrong.mp3',
  './assets/assets/audio/sfx/challenge_start.mp3',
  './assets/assets/audio/sfx/complete.mp3',
  './assets/assets/audio/sfx/achievement.mp3',
  './assets/assets/audio/sfx/level_up.mp3',
  './assets/assets/audio/sfx/perfect.mp3',
  './assets/packages/model_viewer_plus/assets/model-viewer.min.js',
];

const OPTIONAL_ASSETS = [
  './assets/AssetManifest.bin',
  './assets/AssetManifest.bin.json',
  './assets/FontManifest.json',
  './assets/NOTICES',
  "./assets/AssetManifest.bin",
  "./assets/AssetManifest.bin.json",
  "./assets/FontManifest.json",
  "./assets/NOTICES",
  "./assets/assets/achievements/.gitkeep",
  "./assets/assets/achievements/Diamond_badge.png",
  "./assets/assets/achievements/Flame_badge.png",
  "./assets/assets/achievements/graduation_badge.png",
  "./assets/assets/achievements/star_badge.png",
  "./assets/assets/anatomy/ATLAS_RENDERER_LICENSES.txt",
  "./assets/assets/anatomy/ATTRIBUTION.md",
  "./assets/assets/anatomy/SPL_EAR_LICENSE.txt",
  "./assets/assets/anatomy/Z_ANATOMY_EXPORT_LICENSE.txt",
  "./assets/assets/anatomy/Z_ANATOMY_NOTICE.txt",
  "./assets/assets/anatomy/Z_ANATOMY_UPSTREAM_LICENSE.txt",
  "./assets/assets/anatomy/anatomy-organs.glb",
  "./assets/assets/anatomy/atlas-catalog.json",
  "./assets/assets/anatomy/atlas-viewer.html",
  "./assets/assets/anatomy/atlas-viewer.js",
  "./assets/assets/anatomy/detail-ear.glb",
  "./assets/assets/anatomy/detail-glands.glb",
  "./assets/assets/anatomy/detail-joint-bones.glb",
  "./assets/assets/anatomy/detail-joints.glb",
  "./assets/assets/anatomy/detail-lymphatic.glb",
  "./assets/assets/anatomy/female-arterial.glb",
  "./assets/assets/anatomy/female-articular.glb",
  "./assets/assets/anatomy/female-cardiovascular.glb",
  "./assets/assets/anatomy/female-digestive.glb",
  "./assets/assets/anatomy/female-integumentary.glb",
  "./assets/assets/anatomy/female-lymphatic.glb",
  "./assets/assets/anatomy/female-muscular.glb",
  "./assets/assets/anatomy/female-nervous.glb",
  "./assets/assets/anatomy/female-reproductive.glb",
  "./assets/assets/anatomy/female-respiratory.glb",
  "./assets/assets/anatomy/female-sensory.glb",
  "./assets/assets/anatomy/female-skeletal.glb",
  "./assets/assets/anatomy/female-urinary.glb",
  "./assets/assets/anatomy/female-venous.glb",
  "./assets/assets/anatomy/male-arterial.glb",
  "./assets/assets/anatomy/male-articular.glb",
  "./assets/assets/anatomy/male-cardiovascular.glb",
  "./assets/assets/anatomy/male-digestive.glb",
  "./assets/assets/anatomy/male-endocrine.glb",
  "./assets/assets/anatomy/male-integumentary.glb",
  "./assets/assets/anatomy/male-lymphatic.glb",
  "./assets/assets/anatomy/male-muscular.glb",
  "./assets/assets/anatomy/male-nervous.glb",
  "./assets/assets/anatomy/male-reproductive.glb",
  "./assets/assets/anatomy/male-respiratory.glb",
  "./assets/assets/anatomy/male-sensory.glb",
  "./assets/assets/anatomy/male-skeletal.glb",
  "./assets/assets/anatomy/male-urinary.glb",
  "./assets/assets/anatomy/male-venous.glb",
  "./assets/assets/anatomy/overview-skeleton.glb",
  "./assets/assets/audio/ATTRIBUTION.md",
  "./assets/assets/audio/MUSIC_GENERATION_SPEC.md",
  "./assets/assets/audio/generation-provenance.json",
  "./assets/assets/audio/music/README.md",
  "./assets/assets/audio/sfx-manifest.json",
  "./assets/assets/audio/sfx/achievement.mp3",
  "./assets/assets/audio/sfx/challenge_start.mp3",
  "./assets/assets/audio/sfx/complete.mp3",
  "./assets/assets/audio/sfx/correct.mp3",
  "./assets/assets/audio/sfx/level_up.mp3",
  "./assets/assets/audio/sfx/perfect.mp3",
  "./assets/assets/audio/sfx/quiz_select.mp3",
  "./assets/assets/audio/sfx/ui_back.mp3",
  "./assets/assets/audio/sfx/ui_open.mp3",
  "./assets/assets/audio/sfx/ui_select.mp3",
  "./assets/assets/audio/sfx/ui_tap.mp3",
  "./assets/assets/audio/sfx/wrong.mp3",
  "./assets/assets/fonts/ATTRIBUTION.md",
  "./assets/assets/fonts/NorieEmoji.ttf",
  "./assets/assets/fonts/NotoEmoji-OFL.txt",
  "./assets/assets/mascot/.gitkeep",
  "./assets/assets/mascot/Norie_001_base.png",
  "./assets/assets/mascot/Norie_002_Congratulations.png",
  "./assets/assets/mascot/Norie_003_studying.png",
  "./assets/assets/ranking/.gitkeep",
  "./assets/assets/ranking/Explorer_rank.png",
  "./assets/assets/ranking/Master_rank.png",
  "./assets/assets/ranking/Specialist_rank.png",
  "./assets/assets/ranking/curiousmind_rank.png",
  "./assets/assets/ranking/scholar_rank.png",
  "./assets/fonts/MaterialIcons-Regular.otf",
  "./assets/fonts/fallback/Roboto-Regular.ttf",
  "./assets/packages/cupertino_icons/assets/CupertinoIcons.ttf",
  "./assets/packages/model_viewer_plus/assets/model-viewer.min.js",
  "./assets/packages/model_viewer_plus/assets/template.html",
  "./assets/shaders/ink_sparkle.frag",
  "./assets/shaders/stretch_effect.frag",
  "./canvaskit/canvaskit.js",
  "./canvaskit/canvaskit.js.symbols",
  "./canvaskit/canvaskit.wasm",
  "./canvaskit/chromium/canvaskit.js",
  "./canvaskit/chromium/canvaskit.js.symbols",
  "./canvaskit/chromium/canvaskit.wasm",
  "./canvaskit/skwasm.js",
  "./canvaskit/skwasm.js.symbols",
  "./canvaskit/skwasm.wasm",
  "./canvaskit/skwasm_heavy.js",
  "./canvaskit/skwasm_heavy.js.symbols",
  "./canvaskit/skwasm_heavy.wasm",
  "./canvaskit/webparagraph/canvaskit.js",
  "./canvaskit/webparagraph/canvaskit.js.symbols",
  "./canvaskit/webparagraph/canvaskit.wasm",
  "./canvaskit/wimp.js",
  "./canvaskit/wimp.js.symbols",
  "./canvaskit/wimp.wasm",
  "./flutter.js"
];

async function cacheRequired(cache) {
  for (const path of REQUIRED_ASSETS) {
    const response = await fetch(path, { cache: 'reload' });
    if (!response.ok) {
      throw new Error('Offline prerequisite failed: ' + path);
    }
    await cache.put(path, response);
  }
  const catalog = await (await cache.match('./assets/assets/anatomy/atlas-catalog.json')).json();
  if (catalog.schemaVersion !== 1 || !Array.isArray(catalog.assets)) throw new Error('Invalid offline atlas catalog');
  for (const asset of catalog.assets) {
    if (!/^[\w-]+\.glb$/.test(asset.file)) throw new Error('Invalid offline atlas filename');
    const path = './assets/assets/anatomy/' + asset.file;
    const response = await fetch(path, { cache: 'reload' });
    if (!response.ok) throw new Error('Offline prerequisite failed: ' + path);
    await cache.put(path, response);
  }
}

async function cacheOptional(cache) {
  await Promise.all(
    OPTIONAL_ASSETS.map(async (path) => {
      try {
        if (await cache.match(path)) return;
        const response = await fetch(path, { cache: 'reload' });
        if (response.ok || response.type === 'opaque') {
          await cache.put(path, response);
        }
      } catch (_) {
        // Optional resources can be filled by runtime caching later.
      }
    }),
  );
}

self.addEventListener('install', (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_NAME);
      await cacheRequired(cache);
      await cacheOptional(cache);
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const names = await caches.keys();
      await Promise.all(
        names
          .filter((name) => name.startsWith('norie-offline-') && name !== CACHE_NAME)
          .map((name) => caches.delete(name)),
      );
      await self.clients.claim();
    })(),
  );
});

function normalizedRequest(request) {
  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return request;
  url.search = '';
  // Cache keys only need the URL. Reconstructing a browser navigation request
  // with mode 'navigate' throws and prevents offline page reloads.
  return url.toString();
}

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;
  // Cloud accounts and AI responses are private and must never be stored in
  // the public app-shell cache. Their local storage is owned by the app.
  if (new URL(request.url).origin !== self.location.origin) return;

  event.respondWith(
    (async () => {
      const cache = await caches.open(CACHE_NAME);
      const normalized = normalizedRequest(request);
      const cached =
        (await cache.match(normalized)) ||
        (await cache.match(request));

      if (cached) {
        return cached;
      }

      try {
        const response = await fetch(request);
        if (
          response.ok ||
          response.type === 'opaque'
        ) {
          await cache.put(normalized, response.clone());
        }
        return response;
      } catch (error) {
        if (request.mode === 'navigate') {
          const fallback =
            (await cache.match('./index.html')) ||
            (await cache.match('./'));
          if (fallback) return fallback;
        }
        throw error;
      }
    })(),
  );
});
