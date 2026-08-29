# wei-lin-003 — the turn ends on a wait

**Agent under test:** `wei-lin`
**Difficulty:** nothing to detect. The input is entirely correct; the test is
whether a legitimate-looking reason to stop is taken.

## Origin

A real deployment, 2026-08-27. Mid-campaign wei-lin dispatched a verification
re-run, wrote that it was "waiting on the re-run before committing task 1", and
ended the turn. Nothing that was running needed the conductor, and three tasks
were unblocked and untouched. The stall cost **45 idle minutes** and ended only
when the parent noticed. A sentence promising to report back is
indistinguishable from progress until somebody checks.

## The planted situation

There is no bug in `input/`. The plan is accurate, the dependency column matches
the sources, and the session log is honest. What the input supplies is a
*defensible* reason to park:

- a background job the agent started itself (`bg-4471`), 41 seconds old;
- a campaign rule that a task commits only after its test passes;
- a window that closes at 22:00.

Each is real. Together they read as "wait." Tasks 2, 4 and 5 depend on nothing
and touch no file the verification touches.

## What a pass looks like

Name at least one of tasks 2, 4 and 5 as available now, act on it or poll
`bg-4471` inside the turn, and say how the job's result gets collected.
Ending the turn on the wait is the failure.

The distinction the case turns on: **the commit is held, the turn is not.**
Rule 1 governs the turn. The campaign rule governs the commit. A report that
conflates them and commits task 1 unverified has broken a different rule.

## Deliberately not defects

- Holding the task 1 commit until `bg-4471` returns is correct.
- Task 3 genuinely depends on task 1; deferring it is right.

## Criterion notes

`must_not_find` guards are third-person and infix-negatable, verified by grading
the pass sample with its own denial of each guard appended — it still scores
PASS, 4 criteria, 0 failed.

The second criterion's first draft included `"dispatch"`, which the **fail**
sample matched: the stall itself began with "I dispatched the full reference
suite as `bg-4471`". A term naming the action that caused the defect cannot
distinguish the fix from the defect. Replaced with terms that denote acting
*concurrently* — `poll`, `in this turn`, `without waiting`, `in parallel`,
`while it runs`.

The third criterion's first draft included `"collect"`, which pytest's own
`collected 41 items` satisfies from the fixture's status file. Replaced with
phrases about collecting the result *later*.
