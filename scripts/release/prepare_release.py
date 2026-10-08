"""Validate release provenance and describe already-tested binaries; stdlib only."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import urllib.parse
import urllib.request


def select_run(runs, revision, repository):
    candidates = [run for run in runs if run['head_sha'] == revision
                  and run['event'] == 'push' and run['head_branch'] == 'develop'
                  and run.get('head_repository', {}).get('full_name') == repository]
    if not candidates:
        raise ValueError('No trusted develop push CI run exists at the release revision')
    run = max(candidates, key=lambda item: (item['run_number'], item.get('run_attempt', 1)))
    if run['status'] != 'completed' or run['conclusion'] != 'success':
        raise ValueError('Latest CI run at release revision has not succeeded')
    return run


def metadata(directory, version, tag, revision):
    if not re.fullmatch(r'\d+\.\d+\.\d+\+\d+', version) or tag != 'v' + version.split('+')[0]:
        raise ValueError('Release tag must match the pubspec version (vMAJOR.MINOR.PATCH)')
    if not re.fullmatch(r'[0-9a-f]{40}', revision):
        raise ValueError('Release requires a full commit SHA')
    assets = []
    for name in ('NorieLearning-Windows.zip', 'NorieLearning-Android.apk'):
        path = directory / name
        if not path.stat().st_size:
            raise ValueError('Release package is empty: ' + name)
        with path.open('rb') as stream:
            digest = hashlib.file_digest(stream, 'sha256').hexdigest()
        assets.append(dict(name=name, bytes=path.stat().st_size, sha256=digest))
    return dict(schema=1, version=version, tag=tag, revision=revision, assets=assets,
                signing=dict(windows='unsigned', android='Flutter debug signing; not a production release key'))


def api(path):
    request = urllib.request.Request('https://api.github.com/' + path, headers={
        'Authorization': 'Bearer ' + os.environ['GH_TOKEN'],
        'Accept': 'application/vnd.github+json', 'X-GitHub-Api-Version': '2022-11-28'})
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.load(response)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('command', choices=['gate', 'metadata'])
    parser.add_argument('--revision', required=True)
    parser.add_argument('--tag', required=True)
    args = parser.parse_args()
    version = re.search(r'^version:\s*(\S+)', Path('pubspec.yaml').read_text(), re.M).group(1)
    if args.command == 'gate':
        if args.tag != 'v' + version.split('+')[0]:
            raise ValueError('Tag does not match pubspec version')
        desktop_version = json.loads(Path('desktop/package.json').read_text())['version']
        if desktop_version != version.split('+')[0]:
            raise ValueError('Desktop package version does not match pubspec')
        repository = os.environ['GITHUB_REPOSITORY']
        if api('repos/' + repository)['private']:
            raise ValueError('Public anonymous downloads require a public repository')
        for key, workflow in [('android_run', 'flutter-ci.yml'), ('windows_run', 'windows-desktop.yml')]:
            query = urllib.parse.urlencode(dict(head_sha=args.revision, event='push', branch='develop', per_page=100))
            runs = api(f'repos/{repository}/actions/workflows/{workflow}/runs?{query}')['workflow_runs']
            run = select_run(runs, args.revision, repository)
            with open(os.environ['GITHUB_OUTPUT'], 'a') as output:
                output.write(f"{key}={run['id']}\n")
    else:
        directory = Path('release-assets')
        data = metadata(directory, version, args.tag, args.revision)
        (directory / 'release-metadata.json').write_text(json.dumps(data, indent=2) + '\n')
        (directory / 'SHA256SUMS.txt').write_text(''.join(f"{item['sha256']}  {item['name']}\n" for item in data['assets']))
        notes = f"NorieLearning {version}\n\nBuilt from commit `{args.revision}`. Both packages passed the develop push CI workflows at this exact revision.\n\nWindows: unsigned portable x64 ZIP. Extract the entire folder, then open NorieLearning.exe.\n\nAndroid: APK uses Flutter's generated debug signing configuration, not a production release key. Install as a preview only; updates may require an uninstall when signing keys change. Back up any important local progress before uninstalling.\n\nSee SHA256SUMS.txt to verify downloaded bytes. Core lessons work offline; optional AI and account services may require connectivity and configuration.\n\n<!-- norie-release-metadata -->\n```json\n{json.dumps(data, indent=2)}\n```\n"
        Path('release-notes.md').write_text(notes)


if __name__ == '__main__':
    main()
