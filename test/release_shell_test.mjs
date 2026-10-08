import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync, mkdtempSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {spawnSync} from 'node:child_process';

const yaml = readFileSync(new URL('../.github/workflows/release.yml', import.meta.url), 'utf8').replaceAll('\r\n', '\n');
const publisher = yaml.slice(yaml.indexOf('      - name: Upload draft then publish'));
const marker = '        run: |\n';
const script = publisher.slice(publisher.indexOf(marker) + marker.length).split('\n').map(line => line.replace(/^          /, '')).join('\n');

function publish(existing, resolved = 'a'.repeat(40)) {
  const stub = `gh() {
    if [[ "$1" == api ]]; then
      if [[ "$2" == */git/ref/tags/* ]]; then
        ${existing ? "echo aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa; return 0" : "echo '{\"message\":\"Not Found\"}'; return 1"}
      fi
      ${existing ? "echo '" + resolved + "'; return 0" : "echo 'No commit found'; return 1"}
    fi
    if [[ "$1 $2" == 'release view' ]]; then return 1; fi
    echo "PUBLICATION $1 $2"
  }\n`;
  const bash = process.platform === 'win32' ? 'C:/Program Files/Git/bin/bash.exe' : 'bash';
  return spawnSync(bash, ['--noprofile', '--norc', '-e', '-o', 'pipefail', '-c', stub + script], {
    cwd: mkdtempSync(join(tmpdir(), 'norie-release-')),
    env: {...process.env, GH_REPO: 'example/app', RELEASE_TAG: 'v0.5.0', RELEASE_SHA: 'a'.repeat(40)}, encoding: 'utf8',
  });
}

test('a first release publishes when missing-tag errors include JSON on stdout', () => {
  const result = publish(false);
  assert.equal(result.status, 0, result.stderr);
  assert.match(result.stdout, /PUBLICATION release create/);
  assert.match(result.stdout, /PUBLICATION release upload/);
});

test('an existing tag pointing elsewhere cannot publish checked binaries', () => {
  const result = publish(true, 'b'.repeat(40));
  assert.notEqual(result.status, 0);
  assert.doesNotMatch(result.stdout, /PUBLICATION/);
});
