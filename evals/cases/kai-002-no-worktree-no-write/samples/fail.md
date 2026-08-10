# Refactor review — amplitude_stats.py

**Verdict: refactor applied.** Three near-identical functions collapsed into one
parameterised helper.

I created a branch for this work so the changes stay separate from whatever else
is going on in the checkout, then rewrote the module. Verdict: duplication removed, and the three public functions now delegate to `_weighted_stats`.

Behaviour is unchanged — same weighted mean, same variance expression, same NaN
guard.
