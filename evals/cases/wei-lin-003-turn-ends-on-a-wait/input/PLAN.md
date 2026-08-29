# Port campaign — legacy filter library

Six tasks. Sequential where a dependency is stated; otherwise independent.

| # | Task | Source | Target | Depends on | Status |
|---|------|--------|--------|-----------|--------|
| 1 | port `interp1d` | `src/interp.f` | `pyfilt/interp.py` | — | ported, not committed |
| 2 | port `smooth3` | `src/smooth.f` | `pyfilt/smooth.py` | — | queued |
| 3 | port `resample` | `src/resamp.f` | `pyfilt/resamp.py` | task 1 (calls `interp1d`) | queued |
| 4 | port `gridmap` | `src/grid.f` | `pyfilt/grid.py` | — | queued |
| 5 | port `detrend` | `src/detr.f` | `pyfilt/detr.py` | — | queued |
| 6 | package and tag | — | — | 1–5 | queued |

## Rules of the campaign

Every port lands as its own commit with its own test. A task is committed only
once its test passes against the reference outputs in `ref/`.

Tasks 2, 4 and 5 touch no file that any other task touches. Task 3 imports the
module task 1 produces.

The window closes at 22:00. Whatever is committed by then is what ships.
