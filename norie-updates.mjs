// Updating the offline bundle must never interrupt a learner's active attempt.
export function createUpdateController({serviceWorker, onState, reload}) {
  let registration;
  let requested = false;
  let pending;
  const watched = new WeakSet();
  function report() {
    if (registration.waiting) onState('ready');
    else if (registration.installing) onState('downloading');
    else onState('current');
  }
  function watch(worker) {
    if (!worker || watched.has(worker)) return;
    watched.add(worker);
    worker.addEventListener('statechange', () => {
      if (worker.state === 'redundant') onState('offline');
      else report();
    });
  }
  serviceWorker.addEventListener('message', event => {
    if (event.data?.type === 'NORIE_UPDATE_BLOCKED_MULTITAB') {
      requested = false;
      onState('multitab');
    }
  });
  serviceWorker.addEventListener('controllerchange', () => {
    if (requested) {
      requested = false;
      reload();
    }
  });
  return {
    async check() {
      if (pending) return pending;
      pending = (async () => {
        onState('checking');
        try {
          if (!registration) {
            registration = await serviceWorker.register('norie-sw.js', {scope: './', updateViaCache: 'none'});
            registration.addEventListener('updatefound', () => {
              watch(registration.installing);
              report();
            });
          }
          watch(registration.installing);
          if (registration.waiting) {onState('ready'); return;}
          await registration.update();
          report();
        } catch (_) {onState('offline');}
      })();
      try {await pending;} finally {pending = null;}
    },
    apply() {
      if (!registration?.waiting || requested) return;
      requested = true;
      onState('applying');
      registration.waiting.postMessage({type: 'NORIE_ACTIVATE_UPDATE'});
    },
  };
}

if (typeof window !== 'undefined' && 'serviceWorker' in navigator && /^https?:$/.test(location.protocol)) {
  document.documentElement.setAttribute('data-norie-update-controller', 'ready');
  const panel = document.createElement('aside');
  panel.setAttribute('aria-label', 'App update');
  panel.style.cssText = 'position:fixed;bottom:100px;right:12px;z-index:999999;box-sizing:border-box;width:min(340px,calc(100vw - 24px));padding:16px;border:1px solid #36d7ed;border-radius:16px;background:#101c35;color:#eef4ff;font:14px/1.5 system-ui;box-shadow:0 8px 28px #0006';
  const text = document.createElement('div');
  text.setAttribute('role', 'status');
  const actions = document.createElement('div');
  actions.style.cssText = 'display:flex;gap:8px;flex-wrap:wrap;margin-top:10px';
  const button = (label, action) => {
    const element = document.createElement('button');
    element.textContent = label;
    element.style.cssText = 'min-height:44px;padding:8px 14px;border:1px solid #36d7ed;border-radius:12px;background:#16324a;color:#fff;font:inherit;cursor:pointer';
    element.addEventListener('click', action);
    return element;
  };
  let explicit = false;
  let dismissedReady = false;
  let timer;
  const controller = createUpdateController({
    serviceWorker: navigator.serviceWorker,
    reload: () => location.reload(),
    onState: state => {
      clearTimeout(timer);
      const messages = {
        checking: 'Checking for an app update…',
        downloading: 'Saving the offline learning library. You can keep learning.',
        ready: 'Update ready. Finish your lesson or quiz before reloading. Your saved progress stays on this device.',
        current: 'Offline learning library ready. Your app is up to date.',
        offline: 'Could not check or finish the download. Your saved offline app is still available. Retry when connected.',
        applying: 'Applying the downloaded update…',
        multitab: 'Close other NorieLearning tabs or windows, then try Reload to update again. This keeps the running lesson files consistent.',
      };
      text.textContent = messages[state];
      actions.replaceChildren();
      if (state === 'ready' || state === 'multitab') actions.append(button('Reload to update', () => controller.apply()));
      actions.append(button(state === 'ready' || state === 'multitab' ? 'Later' : 'Close', () => {
        panel.remove();
        if (state === 'ready' || state === 'multitab') dismissedReady = true;
      }));
      if (explicit || (state === 'ready' && !dismissedReady)) {
        panel.replaceChildren(text, actions);
        document.body.append(panel);
      }
      if (state === 'current') timer = setTimeout(() => panel.remove(), 6000);
      if (state !== 'checking' && state !== 'downloading') explicit = false;
    },
  });
  window.addEventListener('norie-check-update', () => {
    explicit = true;
    dismissedReady = false;
    controller.check();
  });
  window.addEventListener('online', () => controller.check());
  navigator.serviceWorker.ready.then(registration => {
    registration.active?.postMessage({type: 'NORIE_CLIENT_READY', build: document.documentElement.getAttribute('data-norie-build')});
  }).catch(() => {});
  controller.check();
}
