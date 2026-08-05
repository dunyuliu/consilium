"""Compare the current tidal-amplitude run against the stored reference."""

import pathlib

import numpy as np

BASELINE = pathlib.Path("baselines/M2_reference.npy")
TOLERANCE = 1e-6


def load_baseline():
    """Read the stored reference amplitudes."""
    if not BASELINE.exists():
        raise FileNotFoundError(f"{BASELINE} is missing; cannot compare")
    return np.load(BASELINE)


def compare(current):
    """Max absolute deviation of the current run from the reference."""
    ref = load_baseline()
    if current.shape != ref.shape:
        raise ValueError(f"shape {current.shape} does not match reference {ref.shape}")
    return float(np.abs(current - ref).max())


def main(current_path):
    current = np.load(current_path)
    dev = compare(current)
    print(f"max deviation: {dev:.3e}  tolerance: {TOLERANCE:.3e}")
    return 0 if dev <= TOLERANCE else 1
