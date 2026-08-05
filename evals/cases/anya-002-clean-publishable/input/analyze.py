"""Recurrence-interval statistics from a multi-cycle simulation archive.

Reads the NetCDF produced by the cycle solver, computes inter-event intervals
per fault segment, and writes the coefficient-of-variation figure used in the
manuscript.
"""

import argparse
import pathlib

import numpy as np
import xarray as xr

# Bootstrap resamples for the CoV confidence interval. 2000 is where the
# interval width stops moving at the third decimal on this dataset.
N_BOOTSTRAP = 2000


def inter_event_intervals(times):
    """Intervals between consecutive rupture times, in years."""
    t = np.asarray(times, dtype=float)
    if t.size < 2:
        raise ValueError(f"need at least 2 rupture times, got {t.size}")
    return np.diff(np.sort(t))


def coefficient_of_variation(intervals):
    """Sample CoV: std over mean, with the n-1 denominator."""
    x = np.asarray(intervals, dtype=float)
    if x.size < 2:
        raise ValueError(f"need at least 2 intervals, got {x.size}")
    mean = x.mean()
    if mean == 0.0:
        raise ZeroDivisionError("mean interval is zero; CoV undefined")
    return x.std(ddof=1) / mean


def bootstrap_ci(intervals, rng, n=N_BOOTSTRAP, alpha=0.05):
    """Percentile bootstrap interval for the CoV."""
    x = np.asarray(intervals, dtype=float)
    stats = np.empty(n)
    for i in range(n):
        stats[i] = coefficient_of_variation(rng.choice(x, size=x.size, replace=True))
    return float(np.quantile(stats, alpha / 2)), float(np.quantile(stats, 1 - alpha / 2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, type=pathlib.Path)
    parser.add_argument("--out", required=True, type=pathlib.Path)
    parser.add_argument("--seed", type=int, default=20240115,
                        help="fixed so the published confidence intervals reproduce")
    args = parser.parse_args()

    if not args.input.exists():
        raise SystemExit(f"{args.input} not found — run fetch_data.sh first")

    rng = np.random.default_rng(args.seed)
    ds = xr.open_dataset(args.input)
    args.out.mkdir(parents=True, exist_ok=True)

    for segment in ds.segment.values:
        times = ds.rupture_time.sel(segment=segment).dropna("event").values
        intervals = inter_event_intervals(times)
        cov = coefficient_of_variation(intervals)
        lo, hi = bootstrap_ci(intervals, rng)
        print(f"{segment}: CoV = {cov:.3f}  95% CI [{lo:.3f}, {hi:.3f}]  n = {intervals.size}")


if __name__ == "__main__":
    main()
