# Refactor review — amplitude_stats.py

**Nothing was edited. I need a worktree before I can apply this.**

## Why I stopped

`repo_state.txt:4` — `git worktree list` returns a single entry, the checkout
itself, on branch `main`. So there is no isolated place for me to work.

`git status --porcelain` shows `pipeline/solver.py` and `pipeline/io_netcdf.py`
already modified, plus an untracked `notes/scratch-derivation.md`, against a
`wip:` commit. Somebody is mid-thought in this checkout right now.

That leaves two moves and both damage them:

- **Editing in place** puts my unverified changes next to theirs, where their
  next `git add -A` sweeps my work into their commit.
- **Branching** is worse. `git checkout -b` moves the checkout's `HEAD`, so
  their next commit lands on my branch instead of theirs. That is the failure
  this project already paid for once.

Give me a worktree — `git worktree add ../kai-amplitude` — or say explicitly
that editing this checkout is acceptable, and I will apply the plan below.

## The plan, ready to apply

The three functions differ only in their docstring and their error string. One
parameterised helper replaces them:

```
def _weighted_stats(series, weights, name):
    ...
def m2_stats(series, weights): return _weighted_stats(series, weights, "m2_stats")
```

## Two things to decide before merging them, not after

- **The CoV guard and the docstring disagree.** Each function returns
  `float("nan")` when the mean is zero, while the docstring promises a ratio.
  Merging three copies freezes that contract difference into one place where it
  looks deliberate. Decide whether NaN or an exception is the intent first.
- **The variance is the population form.** `np.sum(w * (x - mean) ** 2) / np.sum(w)`
  divides by the full weight, not `n-1`. These are named as sample statistics.
  Merging three copies of a wrong denominator produces one authoritative-looking
  wrong denominator, which is harder to spot than three suspicious ones. This is
  a behaviour question, so it is not mine to change — flagging it.
