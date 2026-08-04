# Project rules (excerpt)

## Approved deprecations
4. Remove the `ddof` parameter from `compute_stats()`. No caller in the tree
   passes `ddof=1`; population variance (`ddof=0`) is the only behavior any
   caller ever exercised. Approved 2026-07-20 by project lead. Any mission
   touching `compute_stats()` may land this removal without a separate
   review.
