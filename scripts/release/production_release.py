"""Production-only signing primitives. Never print credentials or generate keys."""
import base64
from contextlib import contextmanager
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import stat
import zipfile

REQUIRED = {
    'android': ('NORIE_ANDROID_KEYSTORE_BASE64', 'NORIE_ANDROID_KEYSTORE_PASSWORD', 'NORIE_ANDROID_KEY_ALIAS', 'NORIE_ANDROID_KEY_PASSWORD', 'NORIE_ANDROID_CERT_SHA256'),
    'windows': ('NORIE_WINDOWS_CERT_BASE64', 'NORIE_WINDOWS_CERT_PASSWORD', 'NORIE_WINDOWS_CERT_SHA256', 'NORIE_WINDOWS_TIMESTAMP_URL'),
}

def validate_environment(platform, env=None):
    env = os.environ if env is None else env
    if platform not in REQUIRED:
        raise ValueError('Unknown signing platform')
    if (env.get('GITHUB_ACTIONS') != 'true' or env.get('GITHUB_EVENT_NAME') != 'workflow_dispatch'
            or env.get('GITHUB_REF') != 'refs/heads/develop' or env.get('NORIE_PROTECTED_ENVIRONMENT') != 'production'):
        raise ValueError('Signing requires a protected production environment and develop dispatch')
    missing = [name for name in REQUIRED[platform] if not env.get(name, '').strip()]
    if missing:
        raise ValueError('Missing signing configuration: ' + ', '.join(missing))
    check_fingerprint(env['NORIE_' + platform.upper() + '_CERT_SHA256'], env['NORIE_' + platform.upper() + '_CERT_SHA256'])

@contextmanager
def secret_file(encoded, target):
    target = Path(target)
    data = base64.b64decode(encoded, validate=True)
    if not data: raise ValueError('Empty signing credential')
    # Exclusive creation avoids replacing an unrelated file; cleanup also on errors.
    descriptor = os.open(target, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o600)
    try:
        with os.fdopen(descriptor, 'wb') as stream:
            stream.write(data)
        yield target
    finally:
        target.unlink(missing_ok=True)

def check_fingerprint(actual, expected):
    normalize = lambda value: value.replace(':', '').replace(' ', '').lower()
    actual, expected = normalize(actual), normalize(expected)
    if not re.fullmatch('[0-9a-f]{64}', expected) or actual != expected:
        raise ValueError('Signer SHA-256 fingerprint does not match the pinned production certificate')

def digest(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

def validate_binding(metadata, artifact, revision, version):
    if not re.fullmatch('[0-9a-f]{40}', revision) or not re.fullmatch(r'\d+\.\d+\.\d+\+\d+', version):
        raise ValueError('Expected full revision and build version')
    if metadata.get('revision') != revision or metadata.get('version') != version or metadata.get('channel') != 'production-candidate':
        raise ValueError('Production channel, source or build version mismatch')
    entries = [entry for entry in metadata.get('assets', []) if entry.get('name') == Path(artifact).name]
    if len(entries) != 1 or entries[0].get('sha256') != digest(artifact):
        raise ValueError('Artifact digest does not match release binding')

def run(arguments):
    return subprocess.run(arguments, check=True, capture_output=True, text=True).stdout

def verified_apk_signer(output):
    """Read successful apksigner output from SDK 36 and SDK 37.

    SDK 37 labels certificates by verified scheme (e.g. V2 Signer) instead
    of Signer #1. Multiple schemes may describe the same single identity;
    conflicting identities and multiple APK signers must still fail closed.
    Callers must execute cryptographic verification successfully first.
    """
    counts = re.findall(r'^Number of signers:[ \t]*(\d+)[ \t\r]*$', output, re.M)
    entries = re.findall(
        r'^(Signer #\d+|V[1-4](?:\.\d+)? Signer:) certificate SHA-256 digest:[ \t]*([^ \t\r\n]+)[ \t\r]*$',
        output, re.M)
    fingerprints = {value.replace(':', '').lower() for _, value in entries}
    if (counts != ['1'] or not entries or len(fingerprints) != 1
            or any(label.startswith('Signer #') and label != 'Signer #1' for label, _ in entries)
            or any(not re.fullmatch('[0-9a-f]{64}', value) for value in fingerprints)):
        raise ValueError('Exactly one verified APK signer required with consistent certificate output')
    return next(iter(fingerprints))

def verify_android(artifact, expected, apksigner='apksigner'):
    # apksigner cryptographically verifies every APK signature, not just a certificate file.
    output = run([apksigner, 'verify', '--verbose', '--print-certs', str(artifact)])
    check_fingerprint(verified_apk_signer(output), expected)
    return expected.replace(':', '').lower()

def verify_aab(artifact, expected):
    # jarsigner verifies signed entries; keytool identifies the embedded signer.
    output = run(['jarsigner', '-J-Duser.language=en', '-J-Duser.country=US',
                  '-verify', '-verbose', '-certs', str(artifact)])
    if ('jar verified.' not in output.lower() or any(warning in output.lower()
            for warning in ('unsigned entries', 'certificate has expired', 'not yet valid'))):
        raise ValueError('AAB signature verification failed or contains unsigned entries')
    output = run(['keytool', '-J-Duser.language=en', '-J-Duser.country=US',
                  '-printcert', '-jarfile', str(artifact)])
    fingerprints = re.findall(r'SHA256:\s*([0-9a-fA-F:]+)', output)
    if len(fingerprints) != 1: raise ValueError('Exactly one AAB signer required')
    check_fingerprint(fingerprints[0], expected)
    return expected.replace(':', '').replace(' ', '').lower()


def verify_windows(artifact, expected):
    # Pass paths as argv, never embed paths or credentials in PowerShell source.
    script = Path(__file__).with_name('verify_authenticode.ps1')
    result = json.loads(run(['pwsh', '-NoProfile', '-File', str(script), str(Path(artifact).resolve())]))
    if result.get('status') != 'Valid' or not result.get('timestamp_valid'):
        raise ValueError('Windows requires a valid Authenticode signature and timestamp')
    check_fingerprint(result.get('sha256', ''), expected)
    return expected.replace(':', '').lower()


def extract_windows_archive(artifact, destination):
    """Validate all entries before writing; never materialize archive symlinks."""
    destination = Path(destination).resolve()
    with zipfile.ZipFile(artifact) as archive:
        members = archive.infolist()
        if len(members) > 30000 or sum(item.file_size for item in members) > 4 * 1024**3:
            raise ValueError('Windows package exceeds extraction bounds')
        seen = set()
        for member in members:
            target = (destination / member.filename).resolve()
            if not target.is_relative_to(destination) or target in seen:
                raise ValueError('Unsafe or duplicate Windows ZIP path')
            if stat.S_ISLNK(member.external_attr >> 16):
                raise ValueError('Windows package must not contain symlinks')
            seen.add(target)
        archive.extractall(destination)
