"""Deterministic offline source inventory and exact final-package budget audit.

Only the simple block asset/font declarations used by this repository are
supported. Unsupported declarations fail closed rather than undercount assets.
"""
from __future__ import annotations

import argparse
from collections import defaultdict
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re

EXCLUDED = frozenset({'node_modules', 'build', '.dart_tool', '.git', '__pycache__', '.pub-cache'})


def linked(path: Path) -> bool:
    """Junctions, like symlinks, must not traverse outside the audited tree."""
    return path.is_symlink() or (hasattr(path, 'is_junction') and path.is_junction())


def hash_file(path: Path) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    with path.open('rb') as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b''):
            size += len(chunk)
            digest.update(chunk)
    return size, digest.hexdigest()


def declarations(root: Path) -> list[str]:
    """Read the repo's pubspec block lists without a third-party YAML dependency."""
    lines = (root / 'pubspec.yaml').read_text(encoding='utf-8').splitlines()
    paths = set()
    in_flutter = False
    section = None
    for raw in lines:
        line = raw.split('#', 1)[0].rstrip()
        if not line.strip():
            continue
        if not line.startswith(' '):
            in_flutter = line == 'flutter:'
            section = None
            continue
        if not in_flutter:
            continue
        match = re.fullmatch(r'  ([\w-]+):(.*)', line)
        if match:
            section = match[1]
            if section in {'assets', 'fonts'} and match[2].strip():
                raise ValueError('Use block declarations for flutter assets/fonts')
            continue
        if section == 'assets':
            match = re.fullmatch(r'    -\s+(.+)', line)
            if not match:
                raise ValueError('Unsupported flutter asset declaration')
            value = match[1].strip().strip('\'"')
        elif section == 'fonts':
            if any(c in line for c in '{}[]'):
                raise ValueError('Unsupported flutter font declaration; use block syntax')
            match = re.fullmatch(r'\s+-\s+asset:\s+(.+)', line)
            if not match:
                continue
            value = match[1].strip().strip('\'"')
        else:
            continue
        path = PurePosixPath(value)
        if path.is_absolute() or '..' in path.parts or '\\' in value or ':' in value or any(c in value for c in '{}[]*'):
            raise ValueError('Asset declarations must be local relative paths')
        if not path.parts or any(part in EXCLUDED for part in path.parts):
            raise ValueError('Asset declaration references a development directory')
        paths.add(path.as_posix())
    if not paths:
        raise ValueError('No flutter assets/fonts declared')
    return sorted(paths)


def inventory(root: Path, errors: list[str]) -> tuple[dict, list[dict]]:
    declared = declarations(root)
    files = set()
    skipped = set()
    for name in declared:
        path = root / name
        # Do not follow links in any ancestor, including a declared directory.
        ancestry = [root / Path(*PurePosixPath(name).parts[:i]) for i in range(1, len(PurePosixPath(name).parts) + 1)]
        if any(linked(parent) for parent in ancestry):
            skipped.add(name)
            continue
        if not path.exists():
            errors.append(f'Missing declared asset: {name}')
            continue
        if path.is_file():
            files.add(path)
        elif path.is_dir():
            def walk_error(error):
                try:
                    relative = Path(error.filename).relative_to(root).as_posix()
                except (TypeError, ValueError):
                    relative = name
                errors.append(f'Cannot read source directory: {relative}')
            for folder, dirs, names in os.walk(path, followlinks=False, onerror=walk_error):
                base = Path(folder)
                for child in sorted(dirs + names):
                    if linked(base / child):
                        skipped.add((base / child).relative_to(root).as_posix())
                dirs[:] = sorted(d for d in dirs if d not in EXCLUDED and not d.startswith('.') and not linked(base / d))
                files.update(base / n for n in names if n not in EXCLUDED and not n.startswith('.') and not linked(base / n) and (base / n).is_file())
    records = []
    groups = defaultdict(list)
    by_root = defaultdict(lambda: {'bytes': 0, 'file_count': 0})
    for path in sorted(files):
        relative = path.relative_to(root).as_posix()
        try:
            size, digest = hash_file(path)
        except OSError:
            errors.append(f'Cannot read source asset: {relative}')
            continue
        item = {'path': relative, 'bytes': size, 'sha256': digest}
        records.append(item)
        groups[(size, digest)].append(relative)
        category = '/'.join(PurePosixPath(relative).parts[:2])
        by_root[category]['bytes'] += size
        by_root[category]['file_count'] += 1
    duplicates = [{'bytes_each': size, 'sha256': digest, 'paths': sorted(paths), 'potential_saved_bytes': size * (len(paths) - 1)} for (size, digest), paths in groups.items() if len(paths) > 1]
    duplicates.sort(key=lambda item: (-item['potential_saved_bytes'], item['paths']))
    records.sort(key=lambda item: (-item['bytes'], item['path']))
    return {'declared_paths': declared, 'file_count': len(records), 'total_bytes': sum(item['bytes'] for item in records), 'by_root': dict(sorted(by_root.items())), 'files': records, 'excluded_symlinks': sorted(skipped)}, duplicates


def load_budgets(path: Path) -> dict:
    data = json.loads(path.read_text(encoding='utf-8'))
    if not isinstance(data, dict) or data.get('schema') != 1:
        raise ValueError('Invalid budget schema')
    limits = data.get('limits_bytes')
    if not isinstance(limits, dict) or set(limits) != {'android', 'windows', 'single_asset'}:
        raise ValueError('Budgets require android, windows and single_asset limits')
    if any(type(value) is not int or value <= 0 for value in limits.values()):
        raise ValueError('Budget limits must be positive integer bytes')
    return data


def aliases(output: Path, source: Path) -> bool:
    if os.path.normcase(os.path.abspath(output)) == os.path.normcase(os.path.abspath(source)):
        return True
    try:
        return os.path.samefile(output, source)
    except OSError:
        return False


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', default='.')
    parser.add_argument('--budgets', default=str(Path(__file__).with_name('package-budgets.json')))
    parser.add_argument('--android', help='Final APK; relative paths use the current working directory')
    parser.add_argument('--windows', help='Final portable ZIP; relative paths use the current working directory')
    parser.add_argument('--json-output', default='build/package-size-report.json')
    parser.add_argument('--fail-on-growth', action='store_true', help='Fail when any reviewed soft byte limit is exceeded')
    args = parser.parse_args(argv)
    report = {'schema': 1, 'source_assets': {}, 'duplicate_candidates': [], 'packages': {}, 'violations': [], 'errors': []}
    errors = report['errors']
    try:
        budgets = load_budgets(Path(args.budgets))
        report['limits_bytes'] = budgets['limits_bytes']
        report['baseline'] = budgets.get('baseline', {})
    except (OSError, ValueError, TypeError):
        errors.append('Cannot load valid budget configuration')
        budgets = None
    try:
        report['source_assets'], report['duplicate_candidates'] = inventory(Path(args.root).absolute(), errors)
    except (OSError, ValueError) as error:
        errors.append(str(error) if isinstance(error, ValueError) else 'Cannot read source inventory/pubspec')
    for kind in ('android', 'windows'):
        supplied = getattr(args, kind)
        artifact = {'status': 'not_measured'}
        if supplied is not None:
            path = Path(supplied)
            artifact = {'status': 'error', 'path': path.name}
            try:
                if not path.is_file() or linked(path):
                    raise ValueError('not a regular file')
                size, digest = hash_file(path)
                if size == 0:
                    raise ValueError('empty artifact')
                artifact.update(status='measured', bytes=size, sha256=digest)
                if budgets and size > budgets['limits_bytes'][kind]:
                    report['violations'].append({'kind': kind, 'path': path.name, 'bytes': size, 'limit_bytes': budgets['limits_bytes'][kind]})
            except (OSError, ValueError):
                errors.append(f'{kind} artifact must be an existing nonempty regular file')
        report['packages'][kind] = artifact
    if budgets:
        for item in report['source_assets'].get('files', []):
            if item['bytes'] > budgets['limits_bytes']['single_asset']:
                report['violations'].append({'kind': 'single_asset', 'path': item['path'], 'bytes': item['bytes'], 'limit_bytes': budgets['limits_bytes']['single_asset']})
    output = Path(args.json_output)
    root = Path(args.root).absolute()
    inputs = [Path(args.budgets), root / 'pubspec.yaml']
    inputs.extend(Path(value) for value in (args.android, args.windows) if value is not None)
    inputs.extend(root / item['path'] for item in report['source_assets'].get('files', []))
    inputs.extend(root / name for name in report['source_assets'].get('declared_paths', []))
    if any(aliases(output, source) for source in inputs):
        errors.append('JSON report must not overwrite an input file or its alias')
    else:
        try:
            output.parent.mkdir(parents=True, exist_ok=True)
            output.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n', encoding='utf-8')
        except OSError:
            errors.append('Cannot write JSON report')
    source = report['source_assets']
    print(f"Source inventory: {source.get('file_count', 0)} files, {source.get('total_bytes', 0)} bytes")
    for kind, artifact in report['packages'].items():
        print(f"{kind}: {artifact['status']}" + (f", {artifact['bytes']} bytes, SHA256 {artifact['sha256']}" if artifact['status'] == 'measured' else ''))
    for violation in report['violations']:
        print(f"BUDGET: {violation['kind']} {violation['path']} {violation['bytes']} bytes exceeds {violation['limit_bytes']} bytes")
    for error in errors:
        print(f'ERROR: {error}')
    return 2 if errors else (1 if args.fail_on_growth and report['violations'] else 0)


if __name__ == '__main__':
    raise SystemExit(main())
