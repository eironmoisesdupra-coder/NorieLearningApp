const path = require('node:path');

function assetFileFor(address, root) {
  try {
    const url = new URL(address);
    if (url.protocol !== 'norie:' || url.hostname !== 'app' ||
        url.port || url.username || url.password) return null;
    const pathname = decodeURIComponent(url.pathname);
    if (/[\\\x00:]/.test(pathname)) return null;
    const file = path.resolve(root, '.' + (pathname === '/' ? '/index.html' : pathname));
    const relative = path.relative(root, file);
    if (!relative || relative.startsWith('..') || path.isAbsolute(relative)) return null;
    return file;
  } catch (_) {
    return null;
  }
}

function externalLinkFor(address) {
  try {
    const url = new URL(address);
    if (!['https:', 'http:'].includes(url.protocol) ||
        !url.hostname || url.username || url.password) return null;
    return url.href;
  } catch (_) {
    return null;
  }
}

module.exports = { assetFileFor, externalLinkFor };
