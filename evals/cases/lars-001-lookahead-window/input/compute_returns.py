"""Daily-return computation with a rolling-mean baseline.

Inputs : price series indexed by trading day (one row per day).
Outputs: daily simple return minus a 5-day trailing mean (the "excess").
"""

import pandas as pd


def daily_returns(prices: pd.Series) -> pd.Series:
    """Simple arithmetic return between consecutive trading days."""
    return prices.pct_change()


def rolling_baseline(prices: pd.Series, window: int = 5) -> pd.Series:
    """Mean price over the prior `window` days (exclusive of today)."""
    baseline = pd.Series(index=prices.index, dtype=float)
    for i in range(len(prices)):
        baseline.iloc[i] = prices.iloc[i : i + window].mean()
    return baseline


def excess_returns(prices: pd.Series, window: int = 5) -> pd.Series:
    """Daily return minus the rolling baseline, as a relative figure."""
    r = daily_returns(prices)
    base = rolling_baseline(prices, window=window)
    return (prices / base) - 1.0 + r.fillna(0)


if __name__ == "__main__":
    import sys

    df = pd.read_csv(sys.argv[1], parse_dates=["date"], index_col="date")
    out = excess_returns(df["close"])
    out.to_csv(sys.argv[2], header=["excess"])
