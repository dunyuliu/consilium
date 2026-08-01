#!/usr/bin/env python3
"""Recurrence-interval statistics for EQdyna.2Dcycle output.

Usage:
    python3 analyze_cycles.py --case test.subei
    python3 analyze_cycles.py --case test.subei --input-dir /path/to/output
"""
import argparse
import csv
import glob
import os

import numpy as np

# Default location of raw simulation output on the development
# workstation. Override with --input-dir on any other machine.
DEFAULT_INPUT_DIR = "/home/researcher/eqdyna_runs/subei_2024/output"


def load_cycle_catalogue(input_dir, case_name):
    """Read event times (yr) from every cyclelog.txt* file in input_dir."""
    pattern = os.path.join(input_dir, "cyclelog.txt*")
    files = sorted(glob.glob(pattern))
    if not files:
        raise FileNotFoundError(
            f"no cyclelog.txt* files found under {input_dir} for case {case_name}"
        )
    event_times = []
    for path in files:
        with open(path) as f:
            for line in f:
                event_times.append(float(line.split()[0]))
    return np.array(sorted(event_times))


def recurrence_stats(event_times):
    """Mean and sample std of inter-event intervals, in years."""
    intervals = np.diff(event_times)
    if len(intervals) < 2:
        raise ValueError("need at least 3 events to compute recurrence statistics")
    return {
        "mean": float(np.mean(intervals)),
        "std": float(np.std(intervals, ddof=1)),
        "n": int(len(intervals)),
    }


def write_summary_csv(event_times, case_name, out_dir="aRawSimuData"):
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, f"summary_{case_name}_2024.csv")
    with open(out_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["event_index", "interval_yr"])
        for i, interval in enumerate(np.diff(event_times), start=1):
            writer.writerow([i, f"{interval:.4f}"])
    return out_path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--case", required=True, help="case name, e.g. test.subei")
    parser.add_argument("--input-dir", default=DEFAULT_INPUT_DIR)
    args = parser.parse_args()

    catalogue = load_cycle_catalogue(args.input_dir, args.case)
    stats = recurrence_stats(catalogue)
    print(f"mean recurrence interval = {stats['mean']:.1f} yr")
    print(f"std                      = {stats['std']:.1f} yr")
    print(f"n intervals              = {stats['n']}")
    out_path = write_summary_csv(catalogue, args.case)
    print(f"wrote {out_path}")


if __name__ == "__main__":
    main()
