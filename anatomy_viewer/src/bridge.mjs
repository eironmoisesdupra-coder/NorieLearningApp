import { AtlasScene } from './scene.mjs';
import { validCommand } from './state.mjs';

const params = new URLSearchParams(location.search);
const session = params.get('session') ?? '';
const parentOrigin = params.get('parentOrigin') ?? location.origin;
const status = document.getElementById('status');
let atlas;
function emit(type, payload = {}) {
  const message = { version: 1, session, type, payload };
  if (type === 'loading') {
    status.hidden = false;
    status.textContent = `Loading anatomy ${payload.completed}/${payload.total}…`;
  }
  if (type === 'loaded') status.hidden = true;
  if (type === 'error') { status.hidden = false; status.textContent = payload.message; }
  if (window.NorieAtlas?.postMessage) window.NorieAtlas.postMessage(JSON.stringify(message));
  else if (parent !== window) parent.postMessage(JSON.stringify(message), parentOrigin);
  window.dispatchEvent(new CustomEvent('atlas-event', { detail: message }));
}
function receive(value) {
  if (typeof value === 'string') {
    try { value = JSON.parse(value); } catch { return; }
  }
  if (!validCommand(value, session) || !atlas) return;
  Promise.resolve().then(() => atlas.command(value.type, value.payload)).catch(error => {
    console.error('Atlas command failed', error);
    emit('error', { requestId: value.payload?.requestId, message: 'The local anatomy model could not be opened. Retry this view.' });
  });
}
window.norieAtlasCommand = receive;
window.addEventListener('message', event => {
  if (event.source === parent && event.origin === parentOrigin) receive(event.data);
});
window.addEventListener('pagehide', () => atlas?.dispose());
try {
  const response = await fetch(new URL('atlas-catalog.json', location.href));
  if (!response.ok) throw Error('Missing atlas catalog');
  const catalog = await response.json();
  if (catalog.schemaVersion !== 1) throw Error('Unsupported atlas catalog');
  atlas = new AtlasScene(document.getElementById('anatomy'), catalog, emit);
  status.textContent = 'Choose an anatomy system';
  emit('ready');
} catch (error) {
  console.error('Atlas initialization failed', error);
  emit('error', { message: 'The 3D atlas could not start. Check WebGL support or reopen Anatomy Lab.' });
}
