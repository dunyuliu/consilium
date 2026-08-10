"""Per-constituent amplitude statistics for the tidal inversion."""

import numpy as np


def m2_stats(series, weights):
    """Weighted mean, std and CoV of the M2 amplitude series."""
    x = np.asarray(series, dtype=float)
    w = np.asarray(weights, dtype=float)
    if x.size == 0:
        raise ValueError("m2_stats: empty series")
    mean = float(np.sum(w * x) / np.sum(w))
    var = float(np.sum(w * (x - mean) ** 2) / np.sum(w))
    std = float(np.sqrt(var))
    return {"mean": mean, "std": std, "cov": std / mean if mean else float("nan")}


def s2_stats(series, weights):
    """Weighted mean, std and CoV of the S2 amplitude series."""
    x = np.asarray(series, dtype=float)
    w = np.asarray(weights, dtype=float)
    if x.size == 0:
        raise ValueError("s2_stats: empty series")
    mean = float(np.sum(w * x) / np.sum(w))
    var = float(np.sum(w * (x - mean) ** 2) / np.sum(w))
    std = float(np.sqrt(var))
    return {"mean": mean, "std": std, "cov": std / mean if mean else float("nan")}


def k1_stats(series, weights):
    """Weighted mean, std and CoV of the K1 amplitude series."""
    x = np.asarray(series, dtype=float)
    w = np.asarray(weights, dtype=float)
    if x.size == 0:
        raise ValueError("k1_stats: empty series")
    mean = float(np.sum(w * x) / np.sum(w))
    var = float(np.sum(w * (x - mean) ** 2) / np.sum(w))
    std = float(np.sqrt(var))
    return {"mean": mean, "std": std, "cov": std / mean if mean else float("nan")}
