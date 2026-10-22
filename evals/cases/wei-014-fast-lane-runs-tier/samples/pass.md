# Conductor — landing PR #52 and the checkpoint

Fast lane does not mean no gate: the smoke tier holds the tracked-text
guard, the one check a docs edit can break, and CI skips markdown.

1. In a bare clone of main with PR #52 merged (never a worktree, which
   inherits data and env) run `python3 tests/run.py smoke` at that merge head; merge only on green, quoting the summary line.
2. Write the checkpoint on its own branch, run the privacy grep and the
   smoke tier at its merge head, open its PR, merge on green.
3. Report both summary lines; main stays green.
