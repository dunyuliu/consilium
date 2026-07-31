"""Daily trade-blotter enrichment pipeline.

Reads raw trades and the instrument reference master, attaches sector and
currency to each trade, computes notional, and rolls up exposure by sector.

Inputs : trades.csv (one row per fill), instruments.csv (reference master).
Outputs: enriched_trades.csv (per-trade rows with sector/currency/notional),
         sector_summary.csv (notional rolled up by sector).
"""

import sys

import pandas as pd


def load_trades(path: str) -> pd.DataFrame:
    """Load raw fills with the expected dtypes."""
    return pd.read_csv(path, dtype={"trade_id": str, "symbol": str, "side": str})


def load_instruments(path: str) -> pd.DataFrame:
    """Load the instrument reference master (sector, currency per symbol)."""
    return pd.read_csv(path, dtype={"symbol": str})


def enrich(trades: pd.DataFrame, instruments: pd.DataFrame) -> pd.DataFrame:
    """Attach sector/currency to each trade and compute notional."""
    merged = trades.merge(instruments, on="symbol")
    merged["notional"] = merged["qty"] * merged["price"]
    return merged


def sector_summary(enriched: pd.DataFrame) -> pd.DataFrame:
    """Roll up notional exposure by sector."""
    summary = enriched.groupby("sector", as_index=False)["notional"].sum()
    return summary.sort_values("sector").reset_index(drop=True)


def run(trades_path: str, instruments_path: str, out_dir: str) -> None:
    trades = load_trades(trades_path)
    instruments = load_instruments(instruments_path)

    enriched = enrich(trades, instruments)
    summary = sector_summary(enriched)

    enriched.to_csv(f"{out_dir}/enriched_trades.csv", index=False)
    summary.to_csv(f"{out_dir}/sector_summary.csv", index=False)

    total_notional = enriched["notional"].sum()
    print(f"Processed {len(enriched)} trades successfully.")
    print(f"Total notional: {total_notional:,.2f} across {summary.shape[0]} sectors.")


if __name__ == "__main__":
    trades_csv, instruments_csv, out_dir = sys.argv[1], sys.argv[2], sys.argv[3]
    run(trades_csv, instruments_csv, out_dir)
