# lars-001 — look-ahead in rolling baseline

**Agent under test:** `lars-eriksson`
**Difficulty:** easy — the docstring contradicts the code on the same lines.

## Planted defects

1. **Look-ahead (critical, `compute_returns.py:17`).** `rolling_baseline`
   uses `prices.iloc[i : i + window]`, which includes today and the next
   `window-1` days. The docstring claims "prior `window` days (exclusive of
   today)". The correct slice is `prices.iloc[max(0, i - window) : i]`.

2. **Silent NaN-masking (medium, `compute_returns.py:24`).** The first day's
   `pct_change()` is NaN; `r.fillna(0)` quietly replaces it, making the
   day-1 excess return look defined when it isn't. A loud failure or
   propagating NaN would be safer.

## Why these are good test material

- Defect 1 is the prototypical "ships wrong numbers" bug Lars exists to
  catch. The fix is one slice change; the impact is every excess-return
  series silently using tomorrow's price.
- Defect 2 is the kind of `fillna(0)` Lars's own prompt calls out by name
  (`agents/lars-eriksson.md:33`). Missing it means the prompt's checklist
  isn't being followed.

## Pass criteria

See `case.yaml`. The minimum bar is a finding citing line 16–20 with at
least one of: "look-ahead", "future", "leakage", "lookahead".
