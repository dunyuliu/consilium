# Release v3.4.0 -- 2026-09-15

## Summary
Config loader now validates unknown keys against the declared schema and
raises `ConfigSchemaError` instead of silently accepting them.

## Files changed
- `src/config/loader.py` -- schema validation added
- `tests/test_config.py` -- two new cases (unknown key, empty schema)

## Verification section
`bash tests/check.sh` -- 214 passed, 0 failed, on the local pre-push hook.

## Release gate
- audit: victor-reyes, 0 findings
- correctness: no issues found
- conciseness: no refactor needed
- fixes: n/a
- docs: reconciled against filesystem
- refactor: kai-fischer, none needed
- tree: clean, one worktree, no lock, level with upstream
- ci: pending -- gated on the run for this commit's exact SHA
- publish: pending
- clone: pending
- rules: zofia-kaminska, no violations
