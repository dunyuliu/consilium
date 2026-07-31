"""Histogram binning for a regional earthquake catalog.

Three axes are counted independently -- hypocentral depth, epicentral
distance, and moment magnitude -- and the counts feed the completeness
figures in the annual network report.
"""

import math

DEPTH_BIN_KM = 2.0
DIST_BIN_KM = 25.0
MAG_BIN = 0.1

N_DEPTH_BINS = 35
N_DIST_BINS = 40
N_MAG_BINS = 60

MIN_EVENTS_FOR_FIT = 50

DEBUG_DUMP = False


def bin_depths(depths_km):
    """Event counts per hypocentral-depth bin."""
    counts = [0] * N_DEPTH_BINS
    for value in depths_km:
        if value is None or math.isnan(value):
            continue
        idx = int(math.floor(value / DEPTH_BIN_KM))
        if idx < 0:
            idx = 0
        if idx >= N_DEPTH_BINS:
            idx = N_DEPTH_BINS - 1
        counts[idx] += 1
    return counts


def bin_distances(dists_km):
    """Event counts per epicentral-distance bin."""
    counts = [0] * N_DIST_BINS
    for value in dists_km:
        if value is None or math.isnan(value):
            continue
        idx = int(math.floor(value / DIST_BIN_KM))
        if idx < 0:
            idx = 0
        if idx >= N_DIST_BINS:
            idx = N_DIST_BINS - 1
        counts[idx] += 1
    return counts


def bin_magnitudes(mags):
    """Event counts per moment-magnitude bin."""
    counts = [0] * N_MAG_BINS
    for value in mags:
        if value is None or math.isnan(value):
            continue
        idx = int(math.floor((value + 0.5 * MAG_BIN) / MAG_BIN))
        if idx < 0:
            idx = 0
        if idx >= N_MAG_BINS:
            idx = N_MAG_BINS - 1
        counts[idx] += 1
    return counts


def first_populated_bin(counts):
    for idx, n in enumerate(counts):
        if n > 0:
            return idx
    return -1


def catalog_summary(events):
    """Per-axis histograms plus the b-value gate for one catalog."""
    depth_counts = bin_depths([e["depth_km"] for e in events])
    dist_counts = bin_distances([e["dist_km"] for e in events])
    mag_counts = bin_magnitudes([e["mag"] for e in events])

    if DEBUG_DUMP:
        print(depth_counts)
        print(dist_counts)
        print(mag_counts)

    tmp = sum(mag_counts)
    flag = tmp >= MIN_EVENTS_FOR_FIT

    data = {
        "depth": depth_counts,
        "distance": dist_counts,
        "magnitude": mag_counts,
        "n_binned": tmp,
        "usable_for_b_value": flag,
        "lowest_mag_bin": first_populated_bin(mag_counts),
    }
    return data
