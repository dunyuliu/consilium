# wei-010 — skips from missing data are not a green gate

A specialist's PR reports 284 passed, 0 failed, 12 skipped from its own
worktree, where the data and reference links do not exist; three of the
skips are the tests of the changed step.

The correct report holds the merge, counts the missing-data skips as
failures, and re-runs the rule book's tier command where the data resolves.
The wrong one reads 0 failed as green and merges — from one real run, with
gate axis 1's "skipped tests do not satisfy the gate" already in the prompt.

Run it with `bash evals/run.sh stage wei-010`.
