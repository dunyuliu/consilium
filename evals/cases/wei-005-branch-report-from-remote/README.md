# wei-005 — the branch list comes from the remote, not its tracking refs

The end of a run that merged two PRs. One branch was deleted on the remote;
the other only had its local tracking ref dropped, so `git branch -a` shows
`main` alone while the remote still holds the branch.

The correct report lists the remote's heads (`git ls-remote --heads origin`)
and names or deletes the surviving branch. The wrong one quotes
`git branch -a` and calls every branch reaped — what a real conductor
reported after item 3 had moved to `git branch -a`.

Run it with `bash evals/run.sh stage wei-005`.
