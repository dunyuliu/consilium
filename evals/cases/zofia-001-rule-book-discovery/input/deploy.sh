#!/usr/bin/env bash
set -euo pipefail

echo "Deploying build $BUILD_ID"

# Apply pending database migrations before swapping traffic.
alembic upgrade head

make deploy
echo "Deploy complete"
