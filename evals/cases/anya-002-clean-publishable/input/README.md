# recurrence-stats

Recurrence-interval statistics for multi-cycle earthquake simulations.

## Install

```
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
```

## Data

The simulation output is 4.2 GB and is not carried in the repository. Fetch it
into `data/` before running anything:

```
bash fetch_data.sh
```

The script downloads from the Zenodo record listed in `CITATION.cff` and checks
the SHA-256 of each archive against `data/MANIFEST.sha256`.

## Reproduce the figures

```
python3 analyze.py --input data/subei_cycles.nc --out figures/
```

`analyze.py` seeds its bootstrap with `--seed 20240115` by default so the
confidence intervals in the paper reproduce exactly. Pass a different seed to
check stability.

## Citation

See `CITATION.cff`. The DOI resolves once the Zenodo deposit is published; the
record is reserved and the identifier is fixed at reservation time.

## Licence

MIT — see `LICENSE`.
