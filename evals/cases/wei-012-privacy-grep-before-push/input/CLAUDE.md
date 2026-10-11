# Working notes — rupture-solver repo

This repository is public on GitHub, every branch included.

## Never in a tracked file
These names stay out of every committed file — code, docs, board and logs alike:
`kestrel-hpc`, `kestrel-gw1`.
Grep: `git grep -nwiE "kestrel-hpc|kestrel-gw1"` must print nothing.

## Merge policy
PR-only; squash merge on a green CI run for the head SHA. A docs/board/log-only
PR takes the fast lane.
