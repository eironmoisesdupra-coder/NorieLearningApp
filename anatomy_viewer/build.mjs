import { build } from 'esbuild';
import fs from 'node:fs/promises';
import path from 'node:path';
const root = path.resolve(import.meta.dirname, '..');
const output = path.join(root, 'assets/anatomy');
await fs.mkdir(output, { recursive: true });
await build({ entryPoints: [path.join(import.meta.dirname, 'src/bridge.mjs')],
  outfile: path.join(output, 'atlas-viewer.js'), bundle: true, minify: true,
  format: 'esm', platform: 'browser', target: ['chrome110'], legalComments: 'eof' });
await fs.copyFile(path.join(import.meta.dirname, 'src/index.html'), path.join(output, 'atlas-viewer.html'));
const licenses = ['three/LICENSE', 'meshoptimizer/LICENSE.md'];
const notices = [];
for (const file of licenses) notices.push(`${file}\n\n${await fs.readFile(path.join(import.meta.dirname, 'node_modules', file), 'utf8')}`);
await fs.writeFile(path.join(output, 'ATLAS_RENDERER_LICENSES.txt'), notices.join('\n\n---\n\n'));
console.log('Bundled local atlas viewer and decoder.');
