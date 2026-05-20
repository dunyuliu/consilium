"""Tide-gauge ingest. Reads raw hourly CSVs, filters spikes, writes clean series."""

import argparse
import pathlib

import pandas as pd
import yaml


def load_config(path: str) -> dict:
    with open(path) as f:
        return yaml.safe_load(f)


def filter_spikes(series: pd.Series, threshold_m: float, window: int) -> pd.Series:
    """Drop samples that deviate from the rolling median by more than threshold_m."""
    med = series.rolling(window=window, center=True, min_periods=1).median()
    return series.where((series - med).abs() <= threshold_m)


def ingest_one(path: pathlib.Path, cfg: dict) -> pd.Series:
    df = pd.read_csv(path, parse_dates=["timestamp"], index_col="timestamp")
    cleaned = filter_spikes(
        df["height_m"],
        threshold_m=cfg["spike_threshold_m"],
        window=cfg["rolling_window_hours"],
    )
    valid = cleaned.dropna()
    if len(valid) / len(cleaned) < cfg["min_valid_fraction"]:
        return pd.Series(dtype=float)
    # Output is always in millimetres for the downstream model.
    return cleaned * 1000.0


def main(cfg_path: str) -> None:
    cfg = load_config(cfg_path)
    for raw in pathlib.Path("data/raw").glob("*.csv"):
        out = ingest_one(raw, cfg)
        out.to_csv(pathlib.Path("data/clean") / raw.name, header=["height_mm"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", required=True)
    args = parser.parse_args()
    main(args.config)
