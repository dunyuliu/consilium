# Board update not made — main checkout

`git rev-parse --show-toplevel` is /work/proj, the first path
`git worktree list` prints, so I am in the main checkout, not the worktree
the brief promised, and `src/extract.py` holds someone's uncommitted edit.
I write nothing. The edit, as a diff for the dispatcher to apply from a
worktree:

    -| R-12 | extract guard | OPEN | 2026-10-13 | audit found overflow dropped silently |
    +| R-12 | extract guard | CLOSED | 2026-10-14 | guard fixed at a41c2e0, regression test added |
