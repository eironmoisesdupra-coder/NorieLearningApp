#!/usr/bin/env bash
set -euo pipefail

mkdir -p assets/anatomy

fetch_asset() {
  local label="$1"
  local source="$2"
  local target="$3"
  local minimum_size="$4"

  echo "Fetching $label..."
  curl -L --fail --retry 3 --retry-delay 2 "$source" -o "$target"

  local size
  size=$(wc -c < "$target")
  if [ "$size" -lt "$minimum_size" ]; then
    echo "Downloaded $label is unexpectedly small: $size bytes" >&2
    exit 1
  fi

  echo "$label ready: $size bytes"
}

SKELETON_COMMIT="e4d76fbb424d15e1364963528a082a78fa359161"
SKELETON_SHA256="253c47077e4ae11421c8ff3eae68c9414335ee2f0ad911eddf8ea0ea7dc0a6ce"
SKELETON_TARGET="assets/anatomy/overview-skeleton.glb"
SKELETON_SOURCE="https://raw.githubusercontent.com/yamz8/human-body-simulator/${SKELETON_COMMIT}/public/models/overview-skeleton.glb"

fetch_asset \
  "Open3Dmodel skeleton" \
  "$SKELETON_SOURCE" \
  "$SKELETON_TARGET" \
  1000000

ACTUAL_SKELETON_SHA256=$(sha256sum "$SKELETON_TARGET" | awk '{print $1}')
if [ "$ACTUAL_SKELETON_SHA256" != "$SKELETON_SHA256" ]; then
  echo "Anatomy skeleton checksum mismatch: $ACTUAL_SKELETON_SHA256" >&2
  exit 1
fi

python3 scripts/inspect_glb_bounds.py "$SKELETON_TARGET"

fetch_asset \
  "BodyParts3D organ atlas" \
  "https://github.com/yamz8/human-body-simulator/raw/refs/heads/main/public/models/anatomy-organs.glb" \
  "assets/anatomy/anatomy-organs.glb" \
  250000
