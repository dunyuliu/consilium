# Task 3 dispatch decision — 19:03

## The question

Task 4 is committed. `fftpack` is the last item. The obvious move is to dispatch
a porter for it.

## Why I am not doing that yet

The 18:10 log entry records the parent briefing a second porter on `fftpack`
directly. `WORKTREES.txt` shows two working trees — `campaign/main` and
`campaign/task4` — and none for task 3.

Those two facts do not conflict. `git worktree list` enumerates working trees,
not agents. A porter that was briefed nine minutes ago and is still reading
`src/fftpack.f` has written nothing, so it has no worktree, no process I can
see, and no filesystem trace. The empty row is inconclusive about whether the
peer exists; it is not evidence that it does not. The same holds for `ps` — I
cannot see another session's agents from here.

## What I am doing

Enumerating live agents first, and if that is unavailable, asking the parent
whether the 18:10 porter is still running before anything is dispatched.

If the peer is live, I wait. Waiting on an unseen peer is cheap — task 3 is the
last item, so there is nothing else the wait displaces.

If the parent confirms the porter died or was never started, I dispatch, and I
say so explicitly: the collision risk is `src/fftpack.f` and `pytr/fftpack.py`,
and the failure mode is two porters delivering the same 893 lines and one of
them being thrown away.

## What I am not relying on

The plan's note that tasks 3 and 4 touch disjoint sources is true and
irrelevant here. Disjointness between tasks says nothing about two agents on the
same task. "No collision, disjoint files" would be a guess about an agent I
cannot enumerate.
