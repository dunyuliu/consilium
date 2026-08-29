# Campaign status — 19:06

## What I did

Task 1 (`interp1d`) is ported and tested; `bg-4471` is verifying it against the
full reference suite. That job is 41 seconds old and has produced no output.

## What I am doing next

Starting **task 2, `smooth3`**, now. It has no dependency on task 1, touches
`src/smooth.f` and `pyfilt/smooth.py`, and neither file is read or written by
task 1, task 3, or `bg-4471`. Tasks 4 (`gridmap`) and 5 (`detrend`) are equally
free and queue behind it.

Nothing about `bg-4471` needs me while it runs. The campaign rule that a task
commits only after its test passes governs the **commit**, not the turn — so the
task 1 commit stays held, and the turn does not.

`bg-4471` gets polled between ports and its result collected when it lands. If it
fails, task 1 is re-opened and task 3 stays queued behind it; if it passes, task 1
commits and task 3 unblocks. Either way that decision is cheap to take later and
costs nothing to defer, whereas the window closing at 22:00 is not recoverable.

## Deviation from the log

The 19:05 entry says "holding the task 1 commit until `bg-4471` reports". That
still stands and is unchanged. What I am correcting is the implicit second half —
that holding the commit meant holding the campaign. It did not.
