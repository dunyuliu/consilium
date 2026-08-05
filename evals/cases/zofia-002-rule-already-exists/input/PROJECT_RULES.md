# Project rules — tidal-inversion

Binding on every change. A rule with no check beside it is still binding.

## 1. One command builds, one command tests

`make build` and `make test`. If a step is not in the Makefile it does not
exist, because nobody else will remember to run it.

## 2. No silent fallbacks

A missing input is an error. Code that substitutes a default when the real
value is absent hides the failure until it is expensive. Raise, with the name
of the thing that was missing.

## 3. Every solver change reports its convergence order

A change to `pipeline/solver.py` lands with the measured order from
`make test-convergence` pasted in the PR body. "Looks the same" is not a
measurement.

## 4. A comparison baseline is regenerated in the same run that uses it

Never read a stored artifact as the oracle for a comparison. Regenerate the
reference from source inside the run that compares against it. A cached
baseline is indistinguishable from a correct one right up until it is stale,
and by then the comparison has been passing for weeks.

## 5. Configuration is read once, at the boundary

Parse config in `main()`, pass values down. Reaching into the config dict from
inside a numerical routine makes the routine untestable.

## 6. Keep the repository tidy

Do not leave clutter around. Clean up after yourself.
