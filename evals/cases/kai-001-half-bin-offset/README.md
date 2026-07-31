# kai-001 — the third block is not a copy

**Agent under test:** `kai-fischer`
**Difficulty:** hard — the file is engineered to reward a careless dedupe.

## What the fixture is testing

Not "can Kai find duplication" — the duplication is unmissable, which is the
point. The test is whether he reads the third block before folding it in.

`input/binning.py` has three counting loops that are byte-identical apart
from their constants:

| Function | Line | Index expression |
|---|---|---|
| `bin_depths` | 29 | `floor(value / DEPTH_BIN_KM)` |
| `bin_distances` | 44 | `floor(value / DIST_BIN_KM)` |
| `bin_magnitudes` | 59 | `floor((value + 0.5 * MAG_BIN) / MAG_BIN)` |

Depth and distance bins are **edge-aligned**: bin *k* spans `[kw, (k+1)w)`.
Magnitude bins are **centred**: bin *k* spans `[0.1k - 0.05, 0.1k + 0.05)`,
the convention catalogues report magnitudes in. No comment says so. The only
evidence is the `+ 0.5 * MAG_BIN` term, and a merge that parameterises on
`(width, n_bins)` — the obvious parameterisation — drops it.

## Why the difference is consequential

Measured on this file with python3.11, stdlib only:

- **One event.** M 4.96 lands in bin 50 (centre M 5.0) as written, bin 49
  (centre M 4.9) after a naive merge. M 4.95, M 5.06 and M 3.98 also move.
- **One catalogue.** 5000 synthetic Gutenberg–Richter events (b = 1.0,
  Mc = 2.5, magnitudes on a 0.01 grid): **2118 events (42.4 %) change bin.**
  The histogram-implied mean magnitude drops from 2.9242 to 2.8818 against a
  true sample mean of 2.9279 — a half-bin low bias across the whole
  distribution, straight into the b-value and completeness figures the
  module's docstring says it feeds.

Control: on 2000 random values each, a merged edge-aligned helper reproduces
`bin_depths` and `bin_distances` **exactly**. Those two are safe to extract;
only the third is not.

## The genuinely safe cleanup

A fixture whose only right answer is "change nothing" tests nothing, so there
is real work here:

1. **Dead scaffolding, lines 81–84.** `if DEBUG_DUMP:` — `DEBUG_DUMP` is a
   module constant fixed to `False` at line 20. Delete both.
2. **Names that carry no information, lines 86–87, 89.** `tmp` is the binned
   event total, `flag` is the b-value-fit gate, `data` is the returned
   summary. All three are function-local, so renaming touches no caller.

## Deliberate non-defects

Raising these is not a false positive — they are flag-don't-fix items under
Kai's own contract — but they are not scored:

- The `None`/NaN `continue` (lines 27, 42, 57) drops events silently.
- `first_populated_bin` returns a `-1` sentinel (line 72) instead of raising.
- **There is no test suite.** That is deliberate: a test asserting
  `bin_magnitudes([4.96])` would catch the merge mechanically and turn this
  into a test-discipline fixture instead of a reading-discipline one. Flagging
  the gap for `iris-vermeulen` is a correct extra.

## Pass criteria

See `case.yaml`. The decisive check is mechanical and wording-independent:
`0.5 * MAG_BIN` — or an exactly equivalent rounding, including a shared
helper parameterised by an explicit offset — must survive in the edited file.
Parameterising all three is fine. Absorbing the third into an offset-free
helper is the failure this case exists to catch.

## Running it

Kai holds `Edit` and will modify the file in place. Run on a **copy** of
`input/`; `git status` inside `evals/` must be clean afterwards.
