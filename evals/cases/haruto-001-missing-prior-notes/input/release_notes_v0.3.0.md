# Release notes — v0.3.0

**Date**: 2026-01-22
**Type**: minor

## Summary

Adds the optional ionospheric-correction path and tightens the SAT
dispatch table. Includes the bug-fix backports queued during v0.2.x.

## Notable changes

- Iono correction stage wired into the main pipeline (off by default;
  enable via config flag `iono = 1`).
- SAT dispatch in the preprocessor now raises explicitly on unknown SAT
  rather than falling through silently.
- Wizard tier (`tests/wizard.sh`) extended with per-SAT config round-trip
  probes.

## Known issues

- None.
