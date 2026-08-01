#!/usr/bin/env python3
"""Quick recurrence-interval histogram from an analyze_cycles.py summary CSV.

Usage:
    python3 plot_recurrence.py aRawSimuData/summary_subei_2024.csv
"""
import argparse
import csv

import matplotlib.pyplot as plt


def read_intervals(csv_path):
    with open(csv_path, newline="") as f:
        reader = csv.DictReader(f)
        return [float(row["interval_yr"]) for row in reader]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_path", help="summary CSV written by analyze_cycles.py")
    parser.add_argument("--out", default="recurrence_hist.png")
    args = parser.parse_args()

    intervals = read_intervals(args.csv_path)
    fig, ax = plt.subplots()
    ax.hist(intervals, bins=10)
    ax.set_xlabel("recurrence interval (yr)")
    ax.set_ylabel("count")
    fig.savefig(args.out, dpi=150)
    print(f"wrote {args.out}")


if __name__ == "__main__":
    main()
