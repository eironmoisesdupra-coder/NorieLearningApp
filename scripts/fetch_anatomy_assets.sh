#!/usr/bin/env bash
set -euo pipefail

# Recover only checksum-identical already-licensed legacy models.
python3 scripts/anatomy/legacy_models.py

# Detailed atlas: all generated assets and decoder code are bundled locally.
python3 scripts/anatomy/fetch_sources.py
python3 scripts/anatomy/build_body.py build/anatomy-research build/anatomy-converted
npm ci --prefix anatomy_viewer
node anatomy_viewer/convert-models.mjs
node anatomy_viewer/build.mjs
python3 scripts/anatomy/catalog.py

# Fail closed on catalog, source-pin and license provenance drift.
python3 scripts/anatomy/audit.py --output build/anatomy-coverage-audit.json
