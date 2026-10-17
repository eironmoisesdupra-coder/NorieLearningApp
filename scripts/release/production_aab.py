"""Bound tested AAB bytes and preserve payload while replacing JAR signatures.

Structure/provenance checks do not establish bundletool validity, production
signing, physical certification, or Play approval. Never generate signing keys.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
from pathlib import Path
import re
import shutil
import stat
import zipfile
import zlib

MAX_ARCHIVE_BYTES = 512 * 1024**2
MAX_ENTRIES = 30000
MAX_ENTRY_BYTES = 512 * 1024**2
MAX_TOTAL_BYTES = 2 * 1024**3
CHUNK_BYTES = 1024 * 1024
REQUIRED_ENTRIES = {'BundleConfig.pb', 'base/manifest/AndroidManifest.xml'}
PROVENANCE_KEYS = {'schema', 'format', 'revision', 'version', 'sha256', 'bytes'}


def _expected(revision: str, version: str) -> None:
    if (not isinstance(revision, str) or not re.fullmatch(r'[0-9a-f]{40}', revision)
            or not isinstance(version, str) or not re.fullmatch(r'\d+\.\d+\.\d+\+\d+', version)):
        raise ValueError('Expected exact source revision and version+build')


def _is_signature(name: str) -> bool:
    # Only direct JAR signing entries. Never remove all of META-INF: it also
    # contains licenses, service declarations and application-owned metadata.
    parts = name.upper().split('/')
    return (len(parts) == 2 and parts[0] == 'META-INF'
            and (parts[1] == 'MANIFEST.MF'
                 or re.fullmatch(r'[^/]+\.(SF|RSA|DSA|EC)', parts[1]) is not None))


def _members(archive: zipfile.ZipFile) -> list[zipfile.ZipInfo]:
    members = archive.infolist()
    if not members or len(members) > MAX_ENTRIES:
        raise ValueError('AAB entry count exceeds bounds or is empty')
    names = set()
    files = set()
    total = 0
    for member in members:
        name = member.filename
        bare = name[:-1] if member.is_dir() else name
        parts = bare.split('/')
        if (not bare or member.orig_filename != name or '\\' in name or ':' in name
                or any(part in {'', '.', '..'} for part in parts)
                or any(ord(char) < 32 for char in name)):
            raise ValueError('Unsafe AAB entry path')
        if bare in names:
            raise ValueError('Duplicate AAB entry path')
        mode = stat.S_IFMT(member.external_attr >> 16)
        if mode not in {0, stat.S_IFREG, stat.S_IFDIR}:
            raise ValueError('AAB symlinks and special entries are forbidden')
        if mode == stat.S_IFDIR and not member.is_dir():
            raise ValueError('Inconsistent AAB directory entry')
        if member.flag_bits & 1 or member.compress_type not in {zipfile.ZIP_STORED, zipfile.ZIP_DEFLATED}:
            raise ValueError('Encrypted or unsupported AAB compression')
        if member.file_size > MAX_ENTRY_BYTES or member.file_size < 0:
            raise ValueError('AAB entry exceeds byte bounds')
        if member.is_dir() and member.file_size:
            raise ValueError('AAB directory entry contains payload')
        total += member.file_size
        if total > MAX_TOTAL_BYTES:
            raise ValueError('AAB uncompressed bytes exceed bounds')
        names.add(bare)
        if not member.is_dir():
            files.add(bare)
    for name in names:
        parts = name.split('/')
        if any('/'.join(parts[:i]) in files for i in range(1, len(parts))):
            raise ValueError('AAB file/directory path conflict')
    by_name = {member.filename: member for member in members}
    if not REQUIRED_ENTRIES.issubset(files) or any(by_name[name].file_size <= 0 for name in REQUIRED_ENTRIES):
        raise ValueError('AAB requires nonempty BundleConfig.pb and base manifest')
    return members


def _stream_digest(archive: zipfile.ZipFile, member: zipfile.ZipInfo) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    with archive.open(member) as source:
        for chunk in iter(lambda: source.read(CHUNK_BYTES), b''):
            size += len(chunk)
            if size > MAX_ENTRY_BYTES or size > member.file_size:
                raise ValueError('AAB entry exceeds declared byte bounds')
            digest.update(chunk)
    if size != member.file_size:
        raise ValueError('AAB entry size mismatch')
    return size, digest.hexdigest()


def _payload(artifact: Path) -> dict[str, tuple[int, str]]:
    artifact = Path(artifact)
    if not artifact.is_file() or artifact.is_symlink() or not 0 < artifact.stat().st_size <= MAX_ARCHIVE_BYTES:
        raise ValueError('AAB must be a nonempty regular file within byte bounds')
    try:
        with zipfile.ZipFile(artifact) as archive:
            result = {}
            for member in _members(archive):
                # Read signing entries too: their CRC/integrity must not escape
                # validation just because payload comparisons exclude them.
                measured = _stream_digest(archive, member)
                if not member.is_dir() and not _is_signature(member.filename):
                    result[member.filename] = measured
            return result
    except (zipfile.BadZipFile, NotImplementedError, RuntimeError, EOFError, zlib.error) as error:
        raise ValueError('Invalid or unreadable AAB ZIP contents') from error


def _artifact_digest(artifact: Path) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    with Path(artifact).open('rb') as source:
        for chunk in iter(lambda: source.read(CHUNK_BYTES), b''):
            size += len(chunk)
            if size > MAX_ARCHIVE_BYTES:
                raise ValueError('AAB exceeds archive byte bounds')
            digest.update(chunk)
    return size, digest.hexdigest()


def _strict_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError('Duplicate provenance JSON key')
        result[key] = value
    return result


def write_provenance(artifact: Path, output: Path, revision: str, version: str) -> dict:
    """Record the exact structurally checked CI bundle; never overwrite inputs."""
    _expected(revision, version)
    _payload(artifact)
    size, digest = _artifact_digest(artifact)
    data = dict(schema=1, format='norie-tested-aab', revision=revision,
                version=version, sha256=digest, bytes=size)
    with Path(output).open('x', encoding='utf-8', newline='\n') as target:
        target.write(json.dumps(data, indent=2, sort_keys=True) + '\n')
    return data


def validate_provenance(artifact: Path, metadata: Path | dict, revision: str, version: str) -> None:
    """Match trusted CI provenance to the expected source/build and exact bytes."""
    _expected(revision, version)
    if not isinstance(metadata, dict):
        path = Path(metadata)
        if path.stat().st_size > 65536:
            raise ValueError('AAB provenance exceeds byte bounds')
        metadata = json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=_strict_object)
    if (not isinstance(metadata, dict) or set(metadata) != PROVENANCE_KEYS
            or type(metadata['schema']) is not int or metadata['schema'] != 1
            or metadata['format'] != 'norie-tested-aab'
            or metadata['revision'] != revision or metadata['version'] != version
            or type(metadata['bytes']) is not int or not 0 < metadata['bytes'] <= MAX_ARCHIVE_BYTES
            or not isinstance(metadata['sha256'], str)
            or not re.fullmatch('[0-9a-f]{64}', metadata['sha256'])):
        raise ValueError('Invalid AAB provenance schema or source/build binding')
    _payload(artifact)
    size, digest = _artifact_digest(artifact)
    if metadata['bytes'] != size or metadata['sha256'] != digest:
        raise ValueError('AAB bytes/digest do not match tested CI provenance')


def prepare_unsigned(source: Path, target: Path) -> None:
    """Strip only old direct JAR signature entries; never extract or edit source."""
    _payload(source)
    created = False
    try:
        # Exclusive creation also refuses source/target hardlink/symlink aliases.
        with Path(target).open('xb') as output:
            created = True
            with zipfile.ZipFile(source) as original, zipfile.ZipFile(output, 'w') as unsigned:
                for member in _members(original):
                    if _is_signature(member.filename):
                        continue
                    with original.open(member) as entry, unsigned.open(copy.copy(member), 'w') as destination:
                        shutil.copyfileobj(entry, destination, length=CHUNK_BYTES)
        validate_same_payload(source, target)
    except BaseException:
        if created:
            Path(target).unlink(missing_ok=True)
        raise


def validate_same_payload(before: Path, signed: Path) -> None:
    """Compare nonsigning file names/bytes; directory headers are validated only."""
    if _payload(before) != _payload(signed):
        raise ValueError('Signed AAB payload differs from the tested bundle')


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    provenance = commands.add_parser('provenance')
    provenance.add_argument('artifact', type=Path)
    provenance.add_argument('--revision', required=True)
    provenance.add_argument('--version', required=True)
    provenance.add_argument('--output', type=Path, required=True)
    args = parser.parse_args(argv)
    try:
        write_provenance(args.artifact, args.output, args.revision, args.version)
    except (OSError, ValueError) as error:
        print(f'AAB provenance rejected: {error}')
        return 2
    print('AAB structure and exact bytes recorded; signing and store approval are not certified.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
