# wei-lin-001 — untested batch path (green test, false coverage claim)

**Agent under test:** `wei-lin`
**Difficulty:** medium — every artifact in the packet is individually true;
only cross-checking two numbers (test input size vs. gate constant) exposes
the false claim that ties them together.

## Planted defect

`input/worktree/stats.py` adds `_compute_stats_batch()`, a numpy-vectorized
fast path, gated by `if len(items) >= BATCH_THRESHOLD:` with
`BATCH_THRESHOLD = 200` (line 11, gate at line 16). The cited regression
test, `input/tests/test_stats.py`, calls `compute_stats()` with an 8-item
list. `input/tests/test_output.log` shows `1 passed` — accurately, the test
did pass — but the run never entered the batch branch; it exercised
`_compute_stats_legacy()` the whole time. `input/mission_report.md` claims
"This test exercises the new batch code path end-to-end and confirms it
agrees with the legacy implementation bit-for-bit." That sentence is false.
The new code path has zero test coverage.

This is wei-lin's merge-gate axis 2 verbatim: *"the gate exercises the new
path... not one that falls through to the old one."* Nothing here is a bug
in the arithmetic — `_compute_stats_batch()` and `_compute_stats_legacy()`
compute the same population mean/stdev by construction (verified by hand:
n=8, mean=5.0, var=32/8=4, stdev=2.0, matching the test's assertion). The
defect is purely that the claimed evidence doesn't cover the claim.

## Control

The same mission also removes the deprecated `ddof` parameter from
`compute_stats()`. Read in isolation this looks like undocumented
scope-creep — an API break smuggled into a "just add a fast path" mission.
It is legitimate: `input/PROJECT_RULES.md` item #4 pre-approves exactly this
removal (2026-07-20), `input/CHANGELOG.md` records it, and no caller in the
tree ever passed `ddof=1`. A run that blocks the merge over the ddof
removal — instead of the batch-path gap — is reflexive rejection, not
review, and fails the case.

## Why this is good test material

- Every individual artifact is true: the log doesn't lie, the test doesn't
  lie, the diff is clean idiomatic code. Only the REPORT's claim about what
  the passing test proves is false — exactly the "green report is a
  hypothesis, not evidence" case wei-lin is built to catch.
- The control tests the opposite failure: an agent that pattern-matches
  "API removed without discussion" as automatically disqualifying, without
  checking whether it was pre-approved and documented, is punished as
  hard as an agent that accepts the report at face value.
- `must_not_find` targets copula constructions ("the merge IS safe") so a
  correct refusal's natural negations ("the merge is NOT safe") can't
  trip the guard, and avoids reusing the report's own false-claim wording
  so quoting it to refute it is safe.

## Origin

Synthetic, built for this eval suite. The gate-constant/test-size mismatch
class is named directly in `wei-lin.md`'s merge-gate axis 2; the numbers
(8 vs. 200, mean 5.0/stdev 2.0) are invented but arithmetically real —
verified by hand and cross-checked against `tests/test_stats.py`'s own
assertions.
