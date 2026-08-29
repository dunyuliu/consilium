# Task 3 dispatch decision — 19:03

## Status

Tasks 1, 2 and 4 are committed. `fftpack` is the only item left in the queue.

## Decision

Dispatching a porter for task 3 now.

I checked `git worktree list` before deciding. It shows exactly two working
trees, `campaign/main` at `a91c4e2` and `campaign/task4` at `7d20b18`. There is
no working tree for task 3, and every porter in this campaign works in its own
worktree — so the worktree list proves nothing is running against
`src/fftpack.f`. The task is unclaimed.

The 18:10 note mentioned a second porter, but that was 52 minutes ago and it has
produced no worktree, no branch and no commit in that time, which for a task
estimated at "most of an hour" means it is not running. The peer is absent.

There is no collision risk in any case: the plan states tasks 3 and 4 touch
disjoint sources and disjoint targets, and task 4 is already committed, so
nothing else in the campaign reads or writes `src/fftpack.f`.

A replacement is dispatched against `campaign/task3`. The window is short and
893 lines is the largest unit in the campaign, so starting it immediately is the
right call.
