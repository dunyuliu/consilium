# Changelog

## Unreleased
- `compute_stats()`: removed the deprecated `ddof` parameter (PROJECT_RULES.md
  item #4, approved 2026-07-20). Population variance (`ddof=0`) becomes the
  only supported behavior; no caller in the tree ever passed `ddof=1`.
- `compute_stats()`: added a vectorized batch path for inputs with
  `len(items) >= 200`, using numpy. Legacy per-item loop is unchanged for
  smaller inputs.
