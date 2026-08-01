# victor-001 — four defects, four domains, one triage

**Agent under test:** `victor-reyes`
**What is being tested:** ROUTING, not detection. Finding all four defects
and filing them under one specialist is the failure mode this case exists to
catch.
**Difficulty:** medium — each defect is individually easy; the hard part is
noticing that they do not share a domain.

## The project

A three-file water-balance tool for a fictional basin: `budget.py`,
`gauge_monthly.csv` (48 months of real-shaped gauge data), and a `README.md`
with a method description, a documented QC threshold, and three headline
figures. Small enough to read end to end, wide enough that a competent
triage has to dispatch four specialists.

## Planted defects

| # | Defect | Location | Domain | Should route to |
|---|---|---|---|---|
| 1 | `volume_m3 / BASIN_AREA_KM2` — km²→m² factor of 1e6 missing, runoff depth 1e6 too large | `budget.py:40` | physical validity / units | `rafael-santos` |
| 2 | `depth_m[i - 1]` at `i = 0` wraps to the last month; the series telescopes to identically zero | `budget.py:52` | numerical / code correctness | `lars-eriksson` |
| 3 | README documents `MIN_VALID_DAYS = 25`; the code has `20` | `README.md` QC vs `budget.py:17` | docs vs code | `sophia-okafor` |
| 4 | "Mean annual precipitation is 812 mm"; the CSV gives 737.5 mm | `README.md` headline figures | claim vs committed data | `priya-nair` |

Every one is load-bearing, and every number in `case.yaml` was computed from
the committed files:

- **1** — as written the basin loses 12 204 407 mm/month; corrected, 4.27
  mm/month. Ratio exactly 1.000000e+06. The corrected annual budget
  (P 737.5, ET 646.0, Q 145.0 mm/yr) reconciles with the observed 0.3779
  m/yr water-table decline at a specific yield of 0.142 — so the data are
  consistent and the code is not.
- **2** — the reported mean water-table change is `0.0000 m/month` for any
  input whatsoever; the true value is 0.031489 m/month, a 1.48 m decline
  over the record that `budget.py` itself prints on the next line.
- **3** — the documented threshold would drop 4 months (2016-02, 2017-08,
  2018-11, 2019-03); the code drops 1.
- **4** — 812 mm matches no annual total (731 / 698 / 776 / 745), no record
  mean (737.5), and no year in the file.

## Controls (verified clean)

The 48-month record length, the 1.48 m water-table decline, the column
table, the sign convention, the calendar month lengths, and the run
instructions in the input README are all correct. `budget.py` contains no
fallback, placeholder, silent failure, or swallowed exception. Flagging any
of these is a false positive. See `case.yaml` notes for how each was checked.

## Pass criteria

See `case.yaml`. The bar: more than one specialist dispatched, the four
names matched to the four domains above, `budget.py:40` and `budget.py:52`
cited, and the `MIN_VALID_DAYS` divergence plus the corrected 737.5 mm
surfaced as findings. Naming `iris-vermeulen` (no tests exist) or
`jordan-kim` (the ingest path) in addition is defensible and not scored.
