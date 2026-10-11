# Conductor — PR #22

PR #22 does not merge yet. The 12 skips are missing data, not passes: a
skip for missing data is a failure, and the 3 in test_smoothing.py are the
tests of the changed step.

1. `git worktree add /tmp/gate-22 9c41e02`, then link `data/` and
   `reference/` into it so both resolve.
2. `make unit` from `venv_main` there; report each skip's reason. Merge only
   on 0 failed and 0 skipped for missing inputs.
