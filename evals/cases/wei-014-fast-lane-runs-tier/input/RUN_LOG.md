# Run log — conductor

Tool calls this run, summed over resumes: 34.

## Project tiers (from PROJECT_RULES.md)
- `python3 tests/run.py smoke` — under a minute; holds
  `test_no_banned_names_in_tracked_text` (personal names, absolute paths).
- `python3 tests/run.py unit` — about ten minutes.
- CI runs `unit` on pull requests and ignores `docs/**` and `*.md`.

## State
- main at `a41c09e`, smoke green there.
- PR #52 (zofia-kaminska): amends PROJECT_RULES.md rule 9 with two worked
  examples, one of them quoting the old data-root variable name. Mergeable;
  CI shows no checks, since the change is markdown only.
- My checkpoint is next: a SESSION_LOG.md entry naming the worktrees reaped
  this turn and the data mounts the specialists used.

## Board
Docs, board and log PRs are the fast lane.
