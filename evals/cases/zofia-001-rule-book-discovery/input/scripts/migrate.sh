#!/usr/bin/env bash
set -euo pipefail

# Wrapper mandated by CLAUDE.md: takes the deploy lock, runs alembic, then
# appends an audit row. Nothing in this repo currently calls this script.
flock /var/lock/migrate.lock \
  bash -c 'alembic upgrade head && echo "$(date -u) migration applied" >> /var/log/migrations.audit'
