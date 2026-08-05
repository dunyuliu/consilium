# Release notes — v2.3.0

**Date:** 2026-08-05
**Bump:** minor — adaptive time-stepping for the tidal solver

## Summary

Adds adaptive time-stepping to `solver.py`, cutting the runtime of the M2
inversion from 41 to 12 minutes with no change in the converged amplitudes.

## Verification

- `bash tests/check.sh` — 118 passed, 0 failed.
- Convergence order re-measured at 1.98 (was 1.99).
