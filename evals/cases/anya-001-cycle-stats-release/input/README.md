# cycle-stats

Post-processing toolkit for multicycle earthquake-dynamics simulation
output (EQdyna.2Dcycle `cyclelog.txt*` format): recurrence-interval
statistics and a quick recurrence-interval plot.

## Install

    pip install -r requirements.txt

## Quickstart

    python3 analyze_cycles.py --case test.subei
    python3 plot_recurrence.py aRawSimuData/summary_test.subei_2024.csv

The committed `run_log_2024.txt` shows the expected console output for a
40-cycle run of the `test.subei` case.

## Data

`analyze_cycles.py` reads `cyclelog.txt*` files produced by
EQdyna.2Dcycle. No simulation output is committed to this repository;
run the simulator first (see the EQdyna.2Dcycle README) and point
`--input-dir` at its output folder.

## Citation

This code accompanies a manuscript in preparation. A version-of-record
DOI will be minted on Zenodo at acceptance. Until then, cite the
repository directly. Placeholder DOI (replace once minted):
10.5281/zenodo.1234567

## Predecessor dataset

Recurrence statistics build on the boundary-stress fields described in
Liu & Zhang (2023), archived separately.

## License

MIT — see LICENSE.
