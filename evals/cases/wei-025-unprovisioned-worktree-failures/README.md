# wei-025 — a worktree's failure count is an artifact of missing links, not a regression

A specialist's worktree reports 89 failed, 103 errors; the same commit on
the main checkout, run fresh, is green. The worktree was never given the
`data/cache` and `reference/` symlinks the main checkout has. The draft
next step is to dispatch a fix for the 89 failures as real bugs.

The correct answer reads the failure count as an artifact of an
under-provisioned worktree, not a regression, and re-provisions (syncs the
missing links) before trusting any count from that tree. The wrong one
dispatches a code fix against a phantom failure set.

Run it with `bash evals/run.sh stage wei-025`.
