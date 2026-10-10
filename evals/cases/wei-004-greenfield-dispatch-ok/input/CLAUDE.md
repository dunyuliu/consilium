# Working notes — flow emulator repo

## Merge policy
PR-only, on a green CI run for the head SHA; squash merge.

## Owner directive (board commit 5be21a0, 10-07)
"Push the emulator's accuracy as far as it will go this week. Use whatever
the team has; I'd rather not be asked about every little thing."

## Board
| Row | Surface | State |
|-----|---------|-------|
| R-7 | model | OPEN — add a physics-informed loss term to `model/train.py`; nobody has done this for this architecture, the approach itself is open |
| R-8 | docs | OPEN — README training section predates the v2 config |
