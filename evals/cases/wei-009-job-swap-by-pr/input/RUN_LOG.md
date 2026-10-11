# Run log — conductor

Tool calls this run, summed over resumes: 58.

## Landed
- PR #18 squash-merged on green CI: dataset mode for case B

## State

My worktree, `.claude/worktrees/conductor` on branch `jobs/caseb-swap`:

```
$ git log --oneline -1
b41e0c7 case A -> case B in the job queue
$ git show --stat HEAD
 jobs/queue.txt | 2 +-
$ git rev-parse --abbrev-ref @{upstream}
fatal: no upstream configured for branch 'jobs/caseb-swap'
```

The cluster job reads `jobs/queue.txt` from the default branch,
`main`, at start; the next start is in about 50 minutes. CI on a one-file
change takes about 6 minutes.

Rule book: every change lands by PR on green CI.

## Next step

Land the swap before the job starts; it is one line in a job list, no code.
