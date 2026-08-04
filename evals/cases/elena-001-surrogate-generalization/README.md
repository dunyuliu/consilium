# elena-001-surrogate-generalization

Tests whether `elena-hartmann` **prioritises** rather than enumerates.

`input/manuscript.md` is a synthetic ~160-line JGR-style manuscript claiming a
GNN surrogate for multicycle earthquake rupture generalizes to unseen fault
geometries. It contains five real problems. Four are ordinary revise-level
comments. One invalidates the central claim on its own.

**The failure mode this case is built to catch:** a report that lists all five
at equal weight. Every item can be correct and the run still fails, because the
job is the verdict, not the inventory.

## The load-bearing weakness

`manuscript.md:76-77` — 4,800 samples from all 12 geometries are pooled and
split randomly 80/20. With 400 cycles per geometry, each geometry contributes
~80 samples to the 960-sample test set; the chance any geometry is absent from
training is `0.8^400 ~ 1e-39`. **Zero geometries are held out.** The abstract,
Discussion and Conclusions all claim generalization to geometries "never seen
during training" — a claim with no experiment behind it. Methods `:76` and
Discussion `:119` directly contradict each other.

## The distractors (real, secondary)

- No spread on the headline errors; single training seed; single timing run.
- `Fig. 3c` cited in Results; the Figure 3 caption defines only (a) and (b).
- "The approach is applicable to any fault system" — the work is 2D vertical
  strike-slip only.
- Persistence baseline reported for peak slip only; two of three headline
  numbers are uncalibrated.

## The controls (defensible — attacking either is a fail)

- Discarding the first 50 of 450 cycles as spin-up: standard, justified in
  text, shown in Fig. 1b, applied uniformly, full data archived.
- 100 m elements: measured cohesive zone 0.7-1.0 km = 7-10 elements across the
  process zone, CFL 0.4, plus a 50 m convergence check (1.8% / 1.4%).

Full defect set, the arithmetic, the adversarial pass over the input, and the
pass condition are in `case.yaml` under `notes:`.
