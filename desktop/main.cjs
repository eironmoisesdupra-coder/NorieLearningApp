const { app, BrowserWindow, Menu, net, protocol, session, shell } = require('electron');
const path = require('node:path');
const { pathToFileURL } = require('node:url');
const { assetFileFor, externalLinkFor } = require('./asset-policy.cjs');

app.setName('NorieLearning');
app.setAppUserModelId('com.norielearning.desktop');
const explicitUserData = app.commandLine.getSwitchValue('user-data-dir');
if (explicitUserData) app.setPath('userData', path.resolve(explicitUserData));

protocol.registerSchemesAsPrivileged([{
  scheme: 'norie',
  privileges: { standard: true, secure: true, supportFetchAPI: true, stream: true },
}]);

const webRoot = path.join(__dirname, 'web');
const hidden = app.commandLine.hasSwitch('test-hidden');
let window;

function openWebLink(address) {
  const link = externalLinkFor(address);
  if (link) void shell.openExternal(link);
}

function createWindow() {
  window = new BrowserWindow({
    width: 1100, height: 850, minWidth: 420, minHeight: 620,
    title: 'NorieLearning', backgroundColor: '#071126', show: false,
    icon: path.join(__dirname, 'norie-logo.png'),
    webPreferences: {
      nodeIntegration: false, contextIsolation: true, sandbox: true,
      backgroundThrottling: !hidden,
    },
  });
  window.once('ready-to-show', () => { if (!hidden) window.show(); });
  window.webContents.setWindowOpenHandler(({ url }) => {
    openWebLink(url);
    return { action: 'deny' };
  });
  window.webContents.on('will-navigate', (event, url) => {
    if (!assetFileFor(url, webRoot)) {
      event.preventDefault();
      openWebLink(url);
    }
  });
  window.on('closed', () => { window = null; });
  void window.loadURL('norie://app/');
}

if (!app.requestSingleInstanceLock()) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (window) {
      if (window.isMinimized()) window.restore();
      if (!hidden) window.show();
      window.focus();
    }
  });
  app.whenReady().then(() => {
    Menu.setApplicationMenu(null);
    session.defaultSession.setPermissionRequestHandler((_contents, _permission, callback) => callback(false));
    protocol.handle('norie', async (request) => {
      if (!['GET', 'HEAD'].includes(request.method)) return new Response(null, { status: 405 });
      const file = assetFileFor(request.url, webRoot);
      if (!file) return new Response(null, { status: 403 });
      try {
        return await net.fetch(pathToFileURL(file).href);
      } catch (_) {
        return new Response(null, { status: 404 });
      }
    });
    createWindow();
  });
  app.on('activate', () => { if (!window) createWindow(); });
  app.on('window-all-closed', () => app.quit());
}
