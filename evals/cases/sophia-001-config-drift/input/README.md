# Tide-gauge ingest pipeline

Reads hourly tide-gauge CSVs from `data/raw/`, filters out spurious
spikes, and writes a clean hourly series to `data/clean/`.

## Configuration

All parameters live in `config.yaml`:

| Key | Meaning | Default |
|---|---|---|
| `spike_threshold_m` | Reject samples exceeding this many metres above the rolling median. | `0.5` |
| `rolling_window_hours` | Window for the median filter. | `24` |
| `min_valid_fraction` | Reject days with fewer than this fraction of valid samples. | `0.8` |
| `output_units` | Units for the cleaned output. | `metres` |

## Quick start

```
python ingest.py --config config.yaml
```
