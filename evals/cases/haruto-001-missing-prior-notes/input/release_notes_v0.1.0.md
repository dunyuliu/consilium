# Release notes — v0.1.0

**Date**: 2025-09-12
**Type**: initial release

## Summary

First public cut of the project. Sets the baseline directory structure,
introduces the CLI entry point, and establishes the testing convention
(`tests/wizard.sh` → `tests/sweep.sh` two-tier).

## Notable changes

- Initial implementation of the core engine (`src/engine.py`).
- Quick test wizard (`tests/wizard.sh`) — runs in under 10 s and covers
  syntax + import sanity.
- Long-run regression sweep (`tests/sweep.sh`) — full coverage,
  ~30 minutes wall time.
- Project rules codified in `project_rules.md`.

## Known issues

- None at this initial release.
