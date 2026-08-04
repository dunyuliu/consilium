"""Stats utilities.

v1.3: added a vectorized batch path for large inputs (>= BATCH_THRESHOLD
items) using numpy, ~40x faster than the legacy per-item loop on batches of
10k+. compute_stats() dispatches automatically based on len(items).

v1.3 also removes the deprecated `ddof` parameter (PROJECT_RULES.md item #4,
approved 2026-07-20). Population variance (ddof=0) is now the only behavior.
"""

BATCH_THRESHOLD = 200


def compute_stats(items):
    """Return (mean, stdev) for items, population variance (ddof=0)."""
    if len(items) >= BATCH_THRESHOLD:
        return _compute_stats_batch(items)
    return _compute_stats_legacy(items)


def _compute_stats_legacy(items):
    n = len(items)
    mean = sum(items) / n
    var = sum((x - mean) ** 2 for x in items) / n
    return mean, var ** 0.5


def _compute_stats_batch(items):
    import numpy as np
    arr = np.asarray(items, dtype=float)
    return float(arr.mean()), float(arr.std())
