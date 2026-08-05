# Incident — 2026-07-28 — six hours lost to a stale baseline

## What happened

The nightly regression comparison had been green for eleven days. On 2026-07-28
a reviewer noticed the amplitude column in `reports/nightly.csv` had not moved
since the 17th, despite three solver changes landing in that window.

`pipeline/compare.py` reads `baselines/M2_reference.npy` from disk and compares
the current run against it. That file was last written on 2026-07-16. Every
comparison since had been against an eleven-day-old array, so the three solver
changes were compared against a baseline that predated all of them.

Roughly six hours went into re-running the three changes individually against
freshly generated references to work out which, if any, had actually regressed.
None had — the whole exercise recovered nothing except confidence.

## Root cause

`compare.py` treats a stored artifact as the oracle. Nothing regenerates it,
nothing checks its age, and a stale file looks exactly like a fresh one.

## Recommendation

We should add a rule to `PROJECT_RULES.md` requiring that comparison baselines
be freshly generated, so this cannot happen again.
