#!/usr/bin/env bash
set -euo pipefail

mkdir -p assets/anatomy

TARGET="assets/anatomy/overview-skeleton.glb"
SOURCE_COMMIT="e4d76fbb424d15e1364963528a082a78fa359161"
EXPECTED_SHA256="253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce"
SOURCE="https://raw.githubusercontent.com/yamz8/human-body-simulator/${SOURCE_COMMIT}/public/models/overview-skeleton.glb"

echo "Fetching Open3Dmodel skeleton..."
curl -L --fail --retry 3 --retry-delay 2 "$SOURCE" -o "$TARGET"

ACTUAL_SHA256=$(sha256sum "$TARGET" | awk '{print $1}')
if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
  echo "Anatomy skeleton checksum mismatch: $ACTUAL_SHA256" >&2
  exit 1
fi

SIZE=$(wc -c < "$TARGET")
if [ "$SIZE" -lt 1000000 ]; then
  echo "Downloaded anatomy asset is unexpectedly small: $SIZE bytes" >&2
  exit 1
fi

python3 scripts/inspect_glb_bounds.py "$TARGET"

echo "Anatomy skeleton ready: $SIZE bytes"
