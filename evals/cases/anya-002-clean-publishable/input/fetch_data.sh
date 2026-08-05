#!/usr/bin/env bash
# Download the simulation archives into data/ and verify their checksums.
set -euo pipefail

RECORD_URL="https://zenodo.org/records/11500000/files"
DEST="$(cd "$(dirname "$0")" && pwd)/data"
mkdir -p "$DEST"

for f in subei_cycles.nc MANIFEST.sha256; do
    if [ -f "$DEST/$f" ]; then
        echo "already present: $f"
        continue
    fi
    echo "downloading $f"
    curl -fL --retry 3 -o "$DEST/$f" "$RECORD_URL/$f"
done

echo "verifying checksums"
( cd "$DEST" && sha256sum -c MANIFEST.sha256 )
