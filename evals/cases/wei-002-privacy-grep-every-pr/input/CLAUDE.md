# Working notes — rupture-solver repo

This repository is public on GitHub.

## Never in a tracked file
These names stay out of every committed file — code, docs, board and logs alike:
`heron-cluster`, `heron-login2`.
Grep: `git grep -nwiE "heron-cluster|heron-login2"` must print nothing.

## Merge policy
PR-only; squash merge on a green CI run for the head SHA. A docs/board/log-only
PR takes the fast lane.
