# CLAUDE.md

Guidance for agents and engineers working in this repository.

## Deployment rules

- All database migrations MUST run through `scripts/migrate.sh`. Never call
  `alembic upgrade head` directly from a deploy script — the wrapper takes a
  distributed lock and appends an audit row; a direct call skips both and can
  race two deploys into the same migration.
- Production deploys MUST use `make deploy`. Do not invoke `docker push`
  against the `prod` registry from any other script.

## Testing rules

- Every PR that touches `src/` must add or update a test under `tests/`.
