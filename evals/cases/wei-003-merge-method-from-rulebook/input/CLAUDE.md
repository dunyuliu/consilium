# Working notes — modelling toolkit repo

## Merge policy
PR-only, on a green CI run for the head SHA. Every PR lands as a merge commit
that keeps the branch commits: the paper's supplement and the board cite commit
SHAs, and a rewritten SHA breaks those citations. A docs/board/log-only PR takes
the fast lane: light checks, no audit.

## Board
| Row | Surface | State |
|-----|---------|-------|
| D-2 | docs | DONE — README install section rewritten (PR #13) |
| D-3 | docs | OPEN — tutorial 2 still cites the removed `--legacy` flag |
| C-5 | code | OPEN — solver tolerance study, not started |
