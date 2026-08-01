# Release notes — v1.9.0

**Date:** 2026-07-31
**Previous:** v1.8.0 (archived to `docs/`)
**Bump:** minor — routing coverage, three fixtures verified by running, and the case for a runner

## 1. Summary of scope

13 fixtures, **14 of 20 agents** covered, and — for the first time — the
orchestrator itself is under test.

Three fixtures were executed and passed: `kai-001`, the corrected
`ziyan-001`, and `victor-001`. The releases before this one kept finding
defects *in* the suite; this one mostly found the suite working, which is a
different and better result.

## 2. `victor-001-multidomain-basin` — routing under test

Authored by `dunyu-liu`. Four defects spanning four specialist domains in one
small basin-water-balance project, so a lazy triage that names one specialist
fails while a correct one fans out:

| Defect | Routes to |
|---|---|
| `volume_m3 / BASIN_AREA_KM2 * 1000.0` — missing the 1e6 m²/km² factor | `rafael-santos` |
| `depth_m[i - 1]` at `i = 0` wraps to the last month | `lars-eriksson` |
| `MIN_VALID_DAYS = 20` in code, documented as 25 | `sophia-okafor` |
| README claims 812 mm mean annual precipitation; the CSV gives 737.5 | `priya-nair` |

All four verified independently before the run. The indexing defect is the
nastiest: the wraparound telescopes the series so the reported mean
water-table change is **exactly 0.0000 m/month for any input**, on the line
directly above one printing a 1.48 m decline.

**Result: PASS, on the criterion that matters.** Victor dispatched six
specialists and routed every planted defect to the right one, naming the
responsible specialist per finding rather than returning one undifferentiated
list.

The panel also closed the physics unprompted: with the 1e6 fix, the annual
deficit and the observed 1.48 m decline imply a specific yield of 0.145 and
runoff coefficients of 0.190–0.203 — both squarely physical, independently
confirming that 1240 km² is the right area and 1e6 the exact error factor.
`priya-nair` ruled out every plausible derivation of the 812 mm figure
(day-weighting, leap adjustment, every rolling window, every QC subset) and
recorded it as unsupported rather than guessing at a cause.

## 3. The fixture-authoring lesson propagated, and worked

`victor-001`'s brief carried the instruction earned from three consecutive
contaminated fixtures: *audit your own input adversarially before shipping.*
Its author is the first to have done so and **found a contaminant** — a
December water-table rise that broke the seasonal pattern every other year
showed — and regenerated the column before shipping.

That is the first time a fixture defect was caught before a run rather than
by one.

## 4. Two more passes

**`kai-001-half-bin-offset` — PASS.** Kai merged all three binning loops but
preserved the half-bin centring term as an explicit `center_offset` parameter,
which is the fixture's stated correct answer. Verified per-value rather than
from his summary: M 4.96 → bin 50 (a naive merge gives 49), while M 5.00 and
5.04 are unchanged, matching the author's predicted set exactly. He also
declined to assume the `DEBUG_DUMP` removal was safe, flagging that he could
not check callers outside his isolated directory.

**`ziyan-001` — PASS** on re-run. The controls corrected in v1.8.0 are now
correctly silent. It then found **two more** real defects — an uncited numeric
coefficient, and "et al." used for a two-author reference — both verified and
now **declared** rather than deleted, since a thorough run should be credited
for them.

## 5. The finding: instruction is not a gate

Two failure modes have now occurred that no wording can prevent:

- **Answer-key leakage** (`haruto-001`, v1.5.0) — an agent read `case.yaml`
  and the case `README.md`, which sit one directory above `input/`.
- **Read-only violation** (`victor-001`, this release) — a dispatched
  specialist imported a fixture module, creating `input/__pycache__/`, then
  deleted it. Victor **self-reported** it rather than burying it, which is why
  it is known. Two other cases were found carrying the same residue from
  earlier runs; removed.

Both have the **same structural fix**: a runner must hand the agent an
isolated *copy* of `input/`, not a path inside the repo. Read-only-by-
instruction and no-peeking-by-instruction are honour systems, and an honour
system is not a gate.

This is now the strongest argument for building the runner — ahead of the
automated grading it would also enable.

## 6. Verification

- `bash tests/check.sh` — **292 passed, 0 failed**.
- `victor-001`'s four defects re-derived independently before the run: 737.5
  vs 812 mm from the CSV, the `depth_m[i - 1]` wraparound, `MIN_VALID_DAYS`
  20-vs-25.
- `kai-001` verified by executing the refactored module per-value, not by
  reading the report. My first check was itself wrong — it asserted the first
  populated bin should be 50 while feeding a value that correctly bins to 40 —
  and is recorded in the case notes as the same defect class the fixtures keep
  exhibiting.
- `evals/` clean; all `__pycache__` residue removed.
- Cut holding the lock.

## 7. Totals

| | v1.8.0 | v1.9.0 |
|---|---|---|
| Eval fixtures | 12 | **13** |
| Agents covered | 12 | **14 of 20** |
| Fixtures executed | 11 | **13 of 13** |
| Structural checks | 290 | **292** |

## 8. Open issues

1. **6 agents uncovered** — wei-lin, zofia-kaminska, dunyu-liu, nadia-hadid,
   anya-petrov, elena-hartmann, selin-aydin, marco-bianchi.
2. **The runner** — now justified by isolation, not just grading. Should copy
   `input/` to a scratch dir per run, which closes leakage and read-only
   violations structurally.
3. **`must_not_find` cannot measure precision** — a report that is 25% signal
   still passes. Unsolved.
4. **A fixture author cannot certify their own input clean.** Four cases
   proved it. `victor-001` shows an adversarial self-pass helps; it is not a
   substitute for a run.

## 9. Assumptions

- Minor, not patch: new coverage of the orchestrator and three verified cases.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
