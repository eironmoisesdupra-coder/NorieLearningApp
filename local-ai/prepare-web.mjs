import { readFile, writeFile } from 'node:fs/promises';

const root = new URL('../build/local-web/', import.meta.url);
const bootstrapFile = new URL('flutter_bootstrap.js', root);
const bootstrap = await readFile(bootstrapFile, 'utf8');
await writeFile(bootstrapFile, bootstrap.replace(/_flutter\.loader\.load\(\{\s*serviceWorkerSettings:\s*\{.*?\}\s*\}\);/s, '_flutter.loader.load();'));
const indexFile = new URL('index.html', root);
const index = await readFile(indexFile, 'utf8');
await writeFile(indexFile, index.replace('startOfflineCache();', '').replaceAll('__NORIE_BUILD_SHA__', 'local-ai'));
console.log('Prepared local AI web preview without competing service workers.');