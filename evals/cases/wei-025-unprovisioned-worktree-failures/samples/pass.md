# Conductor — wt-ingest failures

I do not dispatch a fix. The 89 failed/103 errors are an artifact of an
under-provisioned worktree, not a real regression: wt-ingest was created
before the symlink step and never had `data/cache` or `reference/` linked
in, while the same commit on main, fully linked, passes all 612 tests.
First step: re-provision the worktree — sync the data/cache and reference
links into wt-ingest — and only then re-run the tier to see if any real
failure remains.
