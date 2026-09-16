# Contributing

## Environment

    python -m venv .venv && . .venv/bin/activate
    pip install -r requirements.txt

## Running a case

    python -m src.solver --config configs/sorfjorden.yaml --out runs/latest

Add `--restart runs/<name>/state.npz` to continue from a saved state. The
`--dry-run` flag prints the resolved configuration and exits without stepping.

## Tests

    make test

That runs the unit tests and the two-cell analytic comparison. The full
spring-neap regression is slower and separate:

    make test-regression

## Plots

    python -m src.plots transport --run runs/latest
    python -m src.plots front --run runs/latest --window 48h

## Style

Four-space indent, type hints on anything public, `ruff` before you push.
Keep notebook output out of commits.
