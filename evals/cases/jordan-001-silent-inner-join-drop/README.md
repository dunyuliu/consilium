# jordan-001 — silent inner-join drop in trade enrichment

**Agent under test:** `jordan-kim`
**Mode:** pipeline audit (Mode 2) — trace trades end-to-end through the merge.
**Difficulty:** easy-medium — the drop has zero diagnostic footprint; you
have to run the pipeline (or hand-trace the join) to see it.

## Planted defect

`input/ingest_merge.py:28`, inside `enrich()`:

```python
merged = trades.merge(instruments, on="symbol")
```

`pd.merge` defaults to `how="inner"`. `input/trades.csv` carries fills for
three symbols — `ENRN`, `WCOM`, `LEH` (legacy/delisted positions) — that are
absent from `input/instruments.csv`, the current instrument reference
master. Those 10 rows are silently excluded from `merged`: no row-count
check, no log of unmatched symbols, no exception. `run()` then prints
`Processed {len(enriched)} trades successfully`, using the *post*-merge
count as though it were the input count — the pipeline reports success on
a blotter that quietly lost a fifth of its rows.

## Measured row counts

Run from `input/`:

```
python3 ingest_merge.py trades.csv instruments.csv out/
```

```
Processed 40 trades successfully.
Total notional: 1,607,795.00 across 5 sectors.
```

- `trades.csv`: 50 data rows (10 known symbols x 4 rows, plus ENRN x4,
  WCOM x3, LEH x3).
- `instruments.csv`: 10 symbols (ENRN/WCOM/LEH not present).
- `out/enriched_trades.csv`: 40 data rows.
- **10 rows dropped (20% of input)** — all of ENRN, WCOM, LEH — with no
  warning anywhere in stdout or the output files.

Verified directly:

```python
import pandas as pd
trades = pd.read_csv("trades.csv")
instruments = pd.read_csv("instruments.csv")
merged = trades.merge(instruments, on="symbol")
len(trades), len(merged)   # -> (50, 40)
set(trades["symbol"]) - set(instruments["symbol"])   # -> {'ENRN', 'WCOM', 'LEH'}
```

## Why this is good test material

- It is the exact "inner join drops rows silently" pattern
  `jordan-kim`'s own prompt names as the archetypal pipeline-audit finding
  — testing whether the checklist is actually applied to code, not just
  recited.
- The drop has no error, no warning, no shape mismatch assertion anywhere
  in the pipeline — the only way to catch it is to compare input and
  output row counts, which is exactly Jordan's end-to-end trace method.
- The success message (`"Processed 40 trades successfully"`) is actively
  misleading: it is true of the post-drop count and gives no signal that
  40 != 50.

## Pass criteria

See `case.yaml`. The report must cite `ingest_merge.py:28` (or the
`enrich()` function, lines 26-30) with inner-join / silent-drop language,
and must name at least one of the dropped symbols (ENRN/WCOM/LEH) or state
the 50-in/40-out (10-row) count — evidence the trace was actually run
rather than asserted from reading the join alone.
