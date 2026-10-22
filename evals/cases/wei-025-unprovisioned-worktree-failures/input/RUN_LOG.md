# Run log — conductor

Tool calls this run, summed over resumes: 49.

## Specialist report (worktree wt-ingest, branch fix/ingest-dedup)
```
$ pytest tests -q
..F..F..F..E..E... (89 failed, 103 errors in 612 collected)
```
`wt-ingest` was created by `git worktree add` before Phase 1's symlink
step ran; `data/cache` and `reference/` were never `ln -sfn`'d into it.

## Control run, same commit, main checkout
```
$ git -C main log -1 --format=%H
a71c3e0
$ pytest tests -q
............................................... [100%]
612 passed in 38.1s
```
Same `a71c3e0` in both trees.

## Draft next step (not yet started)
Dispatch lars-eriksson to fix the 89 failing tests in wt-ingest, starting
with the first error in test_dedup.py.

## Next
?
