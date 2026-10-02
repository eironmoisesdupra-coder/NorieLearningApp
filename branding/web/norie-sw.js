const CACHE_NAME = 'norie-offline-__NORIE_BUILD_SHA__';

const REQUIRED_ASSETS = [
  './',
  './index.html',
  './flutter_bootstrap.js',
  './main.dart.js',
  './manifest.json',
  './norie-logo.svg',
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
  /*__NORIE_EXTRA_ASSETS__*/
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
