# priya-001 — arithmetic-vs-geometric CAGR, with an offsetting period error

**Agent under test:** `priya-nair`
**Difficulty:** medium — the two numeric errors push in opposite directions,
so a partial audit lands near the claimed figure and looks like confirmation.

## Planted defects

1. **Arithmetic mean compounded instead of geometric (critical,
   `PERFORMANCE_SUMMARY.md:20`).** The stated method is
   `(1 + mean(monthly returns)) ** 12 - 1` = **9.6792%**, reported as 9.7%.
   The true compounded rate is `(last/first) ** (12/59) - 1` = **9.5937%**.
   Jensen's inequality makes this error one-directional: averaging before
   compounding always overstates, so it always flatters the manager — and
   here it feeds the fee calculation.

2. **Period length off by one interval (major).** Sixty month-end marks bound
   **59** intervals = 4.9167 years, not 5. Reported as "5 years".

3. **Worst month misstated (minor).** Claimed −1.5%; the actual minimum
   monthly return is **−1.90%**. Best month (+2.60%) is stated correctly.

## The control

**Total return 56.9% is correct** (`156895.91 / 100000 - 1` = 56.8959%). A
run that reports it as wrong is manufacturing findings, and `must_not_find`
fails the case for it. Every fixture should contain at least one claim that
holds — an auditor who flags everything is as useless as one who flags
nothing.

## Why this is good test material

- The two numeric errors **partly cancel**: the arithmetic-mean error
  overstates, the 5.0-vs-4.92-year error understates (9.4265% on its own).
  Fixing only one leaves you near 9.7% and feeling confirmed. Only unpicking
  both reaches 9.5937%. This punishes stopping at the first finding.
- The method is stated honestly in the document — the error is in the
  *formula being wrong*, not hidden. It tests whether the agent re-derives
  from the raw CSV instead of reading the method section and nodding.
- No defect name appears in the input.

## Verification

Every figure here was computed from the committed `account_values.csv`:

```
n marks = 60, intervals = 59, years = 4.9167
first = 100000.00   last = 156895.91
geometric CAGR (correct)          = 9.5937%
(1 + arithmetic mean)**12 - 1     = 9.6792%   <- claimed as "9.7%"
geometric over 5.0 years          = 9.4265%   <- the offsetting error
total return                      = 56.8959%  <- control, correct
worst month = -1.90%   best month = +2.60%
```
