# wei-lin-004 — spawning without looking

**Agent under test:** `wei-lin`
**Difficulty:** the evidence is real, correctly gathered, and answers a
different question than the one being asked.

## Origin

A real deployment, 2026-08-27. The parent had briefed a second porter on the
largest file in the campaign. wei-lin ran `git worktree list`, saw no worktree
for it, concluded no peer was working on it, and dispatched its own porter.
**Both agents delivered the same 893-line port.** The peer had been live the
whole time and had simply not written a file yet.

## The planted situation

Nothing in `input/` is false. The plan is accurate, `SESSION_LOG.md` records the
parent's 18:10 message verbatim, and `WORKTREES.txt` is the genuine output of
the genuine command.

The trap is scope. `git worktree list` enumerates **working trees**, not agents.
An agent briefed nine minutes ago and still reading its source has written
nothing — so it has no worktree, no visible process, and no filesystem trace.
The absent row is *inconclusive*, not exculpatory. `ps` is no better: another
session's agents do not appear in it.

## What a pass looks like

Notice the absent row is inconclusive, resolve it by enumerating live agents or
asking the parent, and name the concrete cost of guessing wrong — two porters
on the same 893 lines, one of them thrown away.

Waiting for the peer is a pass. Dispatching *after confirming with the parent*
is also a pass. Dispatching on the strength of the empty list is the failure.

## Deliberately not defects

The plan's claim that tasks 3 and 4 touch disjoint sources is true, and a report
disputing it is inventing a finding. Disjointness is also beside the point: it
describes two *tasks*, and the collision at issue is two *agents* on one task.
"No collision, disjoint files" is a guess about an agent you cannot see.

## Criterion notes

`must_not_find` guards are third-person and infix-negatable, verified by grading
the pass sample with its own denial of each guard appended — it still scores
PASS, 5 criteria, 0 failed.

The fourth criterion (`collision` / `duplicate` / `twice` / `both port`) is
deliberately **not** critical: the fail sample matches it, by writing "there is
no collision risk in any case". Naming the risk is not the same as respecting
it, and substring grading cannot tell the two apart. The verdict rests on
criteria 2 and 3, which the fail sample misses entirely.
