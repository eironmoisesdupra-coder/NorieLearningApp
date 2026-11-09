"""Verify existing-learner APK compatibility without signing or creating keys."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess

from production_release import run, verified_apk_signer

# Public identities independently extracted from the exact published v0.18 APK.
# Changing these requires a reviewed migration, not an automatically rotated key.
BASELINE_APK_SHA256 = '27b3b42f9c12adbbee350f2492bfe2025166bd5099268be801b22f99339af3a5'
BASELINE_CERTIFICATE = '4168b181761eb975fd329c2d21f0d8f19a8840067705e96888a405d23b1ce2b6'
BASELINE_PACKAGE = 'com.example.norie_learning'


def sdk_tool(name):
    installed = shutil.which(name)
    if installed:
        return installed
    root = os.environ.get('ANDROID_SDK_ROOT') or os.environ.get('ANDROID_HOME')
    if root:
        directory = Path(root) / 'build-tools'
        versions = sorted((p for p in directory.glob('*') if re.fullmatch(r'\d+\.\d+\.\d+', p.name)),
                          key=lambda p: tuple(map(int, p.name.split('.'))), reverse=True)
        for version in versions:
            tool = version / (name + ('.bat' if os.name == 'nt' and name == 'apksigner' else '.exe' if os.name == 'nt' else ''))
            if tool.is_file():
                return str(tool)
    raise ValueError('Android SDK tool unavailable: ' + name)


def inspect(apk, signer, aapt):
    # A successful subprocess is required: extracted certificate bytes alone
    # are not cryptographic APK signature verification.
    output = run([signer, 'verify', '--verbose', '--print-certs', str(apk)])
    certificate = verified_apk_signer(output)
    package = re.search(r"^package: name='([^']+)' versionCode='(\d+)' versionName='([^']+)'", run([aapt, 'dump', 'badging', str(apk)]), re.M)
    if package is None:
        raise ValueError('Cannot establish APK package/version identity')
    with apk.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    return dict(schema=1, apk_sha256=digest, package=package[1], version_code=int(package[2]),
                version_name=package[3], certificate_sha256=certificate,
                baseline_release='v0.18.0', baseline_apk_sha256=BASELINE_APK_SHA256,
                baseline_certificate_sha256=BASELINE_CERTIFICATE,
                compatible=package[1] == BASELINE_PACKAGE and certificate == BASELINE_CERTIFICATE,
                physical_upgrade_tested=False)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--apk', type=Path, required=True)
    parser.add_argument('--apksigner')
    parser.add_argument('--aapt')
    parser.add_argument('--report', type=Path, required=True)
    parser.add_argument('--require-compatible', action='store_true')
    args = parser.parse_args()
    try:
        signer = args.apksigner or sdk_tool('apksigner')
        aapt = args.aapt or sdk_tool('aapt')
        print(f'APK verification tools: apksigner={signer}, aapt={aapt}')
        result = inspect(args.apk, signer, aapt)
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        # These diagnostics contain only tool/metadata validation errors. Keep
        # the reason visible so CI failures can be investigated, not bypassed.
        parser.exit(2, 'APK compatibility verification failed: ' + type(error).__name__ + ': ' + str(error) + '\n')
    if not result['compatible']:
        print('Upgrade blocked: package or signing identity differs from the published baseline. Preserve installed learner data; original signing authority or reviewed migration is required.')
        return 1 if args.require_compatible else 0
    print('APK package and signer match the published baseline; physical upgrade QA remains separate.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
