"""Rolling statistics over a price series. No look-ahead: every window ends
at the sample before the one being labelled."""

from __future__ import annotations

import math
from typing import Sequence

# A trailing std at or below this is treated as zero. Exact equality against
# 0.0 would let an accumulated rounding residue (~1e-16) through and produce a
# z-score of order 1e15 instead of raising.
_STD_FLOOR = 1e-12


def _check_finite(values: Sequence[float]) -> None:
    """Reject NaN and infinity at the boundary.

    Both would otherwise propagate silently through the arithmetic below and
    surface as a plausible-looking number, so they are rejected here with the
    offending index rather than diagnosed later from a corrupted result.
    """
    for i, v in enumerate(values):
        if not math.isfinite(v):
            raise ValueError(f"values[{i}] is {v!r}; expected a finite number")


def trailing_mean(values: Sequence[float], window: int) -> list[float | None]:
    """Mean of the `window` samples strictly before index i.

    Returns None for the first `window` positions, where no complete trailing
    window exists. None is propagated rather than filled: a missing statistic
    and a statistic that happens to be zero are different facts.
    """
    if window < 1:
        raise ValueError(f"window must be >= 1, got {window}")
    _check_finite(values)
    out: list[float | None] = []
    for i in range(len(values)):
        if i < window:
            out.append(None)
            continue
        past = values[i - window : i]
        out.append(sum(past) / window)
    return out


def trailing_std(values: Sequence[float], window: int) -> list[float | None]:
    """Sample standard deviation over the `window` samples strictly before i.

    Uses the n-1 denominator, so `window` must be at least 2.
    """
    if window < 2:
        raise ValueError(f"window must be >= 2 for a sample std, got {window}")
    means = trailing_mean(values, window)
    out: list[float | None] = []
    for i, mu in enumerate(means):
        if mu is None:
            out.append(None)
            continue
        past = values[i - window : i]
        var = sum((v - mu) ** 2 for v in past) / (window - 1)
        out.append(math.sqrt(var))
    return out


def zscore(values: Sequence[float], window: int) -> list[float | None]:
    """(value - trailing mean) / trailing std, using only prior samples.

    Raises on a zero trailing std rather than returning inf: a flat window
    means the z-score is undefined, and a caller must decide what that means.
    """
    means = trailing_mean(values, window)
    stds = trailing_std(values, window)
    out: list[float | None] = []
    for i, value in enumerate(values):
        mu, sd = means[i], stds[i]
        if mu is None or sd is None:
            out.append(None)
            continue
        if sd <= _STD_FLOOR:
            raise ZeroDivisionError(
                f"trailing std is zero at index {i}; z-score undefined"
            )
        out.append((value - mu) / sd)
    return out
