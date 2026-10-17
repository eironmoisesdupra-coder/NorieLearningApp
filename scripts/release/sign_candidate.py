"""Sign exact-revision CI packages; generate candidate metadata, never publish."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
from production_release import (validate_environment, secret_file, digest,
                                verify_android, verify_windows, extract_windows_archive, run)

def main():
    p = argparse.ArgumentParser()
    p.add_argument('platform', choices=['android', 'windows'])
    p.add_argument('artifact', type=Path)
    p.add_argument('--revision', required=True)
    p.add_argument('--version', required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    validate_environment(a.platform)
    if run(['git', 'rev-parse', 'HEAD']).strip() != a.revision:
        raise ValueError('Checked-out source revision mismatch')
    import re
    version = re.search(r'^version:\s*(\S+)', Path('pubspec.yaml').read_text(), re.M).group(1)
    if version != a.version or json.loads(Path('desktop/package.json').read_text())['version'] != version.split('+')[0]:
        raise ValueError('Source version mismatch')
    a.output.mkdir(parents=True, exist_ok=True)
    original_digest = digest(a.artifact)
    env = os.environ
    with tempfile.TemporaryDirectory(prefix='norie-sign-') as temp:
        root = Path(temp)
        if a.platform == 'android':
            sdk = Path(env['ANDROID_HOME']) / 'build-tools'
            tools = sorted(sdk.iterdir(), key=lambda x: tuple(int(n) for n in x.name.split('.') if n.isdigit()))[-1]
            signer = str(tools / ('apksigner.bat' if os.name == 'nt' else 'apksigner'))
            aapt = str(tools / ('aapt.exe' if os.name == 'nt' else 'aapt'))
            info = run([aapt, 'dump', 'badging', str(a.artifact)])
            name, build = version.split('+')
            if f"versionName='{name}'" not in info or f"versionCode='{build}'" not in info:
                raise ValueError('Tested APK version does not match source')
            target = a.output / 'NorieLearning-Android.apk'
            with secret_file(env['NORIE_ANDROID_KEYSTORE_BASE64'], root/'release.keystore') as key:
                run([signer, 'sign', '--ks', str(key), '--ks-key-alias', env['NORIE_ANDROID_KEY_ALIAS'],
                     '--ks-pass', 'env:NORIE_ANDROID_KEYSTORE_PASSWORD', '--key-pass', 'env:NORIE_ANDROID_KEY_PASSWORD',
                     '--out', str(target), str(a.artifact)])
            fingerprint = verify_android(target, env['NORIE_ANDROID_CERT_SHA256'], signer)
        else:
            unpacked = root/'unpacked'; unpacked.mkdir()
            extract_windows_archive(a.artifact, unpacked)
            executables = list(unpacked.rglob('NorieLearning.exe'))
            if len(executables) != 1: raise ValueError('Expected exactly one app executable')
            with secret_file(env['NORIE_WINDOWS_CERT_BASE64'], root/'release.pfx') as key:
                run(['pwsh','-NoProfile','-File',str(Path(__file__).with_name('sign_windows.ps1')),
                     str(unpacked), str(key), name_version(version)])
            fingerprint = env['NORIE_WINDOWS_CERT_SHA256'].replace(':','').lower()
            for binary in sorted(unpacked.rglob('*')):
                if binary.suffix.lower() in ('.exe','.dll','.node'):
                    verify_windows(binary, fingerprint)
            target = a.output/'NorieLearning-Windows.zip'
            shutil.make_archive(str(target.with_suffix('')), 'zip', unpacked)
    data = dict(schema=1, channel='production-candidate', revision=a.revision, version=a.version,
                assets=[dict(name=target.name, bytes=target.stat().st_size, sha256=digest(target))],
                signing={a.platform: dict(status='verified',cert_sha256=fingerprint)},
                tested_input=dict(name=a.artifact.name, sha256=original_digest),
                certification='pending human physical-device evidence; not production approved')
    (a.output/(a.platform+'-candidate.json')).write_text(json.dumps(data,indent=2)+'\n')

def name_version(version):
    return version.split('+')[0]

if __name__ == '__main__': main()
