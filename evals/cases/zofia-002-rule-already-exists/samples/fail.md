# Codification review — stale baseline, 2026-07-28

Six hours is a real cost and the incident is well documented. This incident is
not covered by any existing rule, so I have added rule 7.

## Proposed rule 7

> **7. Comparison baselines must be freshly generated**
>
> Never compare against a stored artifact. Regenerate the reference inside the
> run that uses it. Lost ~6 hours on 2026-07-28.

Placed after rule 6 and added to the index. A new rule must be added here
because I find no rule covering stale baselines.

## Tier

Tier 2 — judgment. A reviewer can read `compare.py` and see whether it loads a
stored file.
