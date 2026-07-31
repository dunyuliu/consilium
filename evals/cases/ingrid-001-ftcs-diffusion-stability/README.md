# ingrid-001 — FTCS diffusion above its stability limit

**Agent under test:** `ingrid-lindqvist`
**Difficulty:** medium — the code is dimensionally consistent, the analytic
solution is correct, and the docstring gives a plausible-sounding (but false)
stability argument instead of naming the defect.

`input/thermal_column.py` marches a 1-D thermal-diffusion column with forward
Euler in time and the three-point Laplacian in space, then runs a refinement
study against the analytic first-eigenmode decay.

## Planted defects

1. **Stability condition violated (critical, `thermal_column.py:26`).**
   `stable_timestep` returns `cfl * dx**2 / kappa` with `cfl = 0.9`. For
   FTCS applied to `dT/dt = kappa d2T/dx2` the amplification factor is
   `g(k) = 1 - 4 r sin^2(k dx / 2)` with `r = kappa dt / dx^2`, so von
   Neumann stability requires `r <= 1/2`, i.e. `dt <= dx^2 / (2 kappa)`.
   The docstring defends `cfl < 1` with a convexity argument that only
   holds for `r <= 1/2` — the update coefficient `1 - 2r` goes negative
   above that. The `0.9` is the advective-CFL habit transplanted to a
   parabolic problem.

   Measured on the fixture as shipped (`t_end = 1e12 s`, initial amplitude
   100 K): `|g|max = 2.57`, and `max|T|` at `t_end` is 9.06e+01 K at
   `nx = 51`, 3.70e+31 at `nx = 101`, 7.29e+169 at `nx = 201`, `nan` at
   `nx = 401`. `convergence_study()` returns
   `orders = [-111.2, -inf, nan]`.

   Note the coarsest grid completes only 28 steps and still looks healthy —
   the roundoff-seeded sawtooth needs ~40 steps at a growth of 2.57/step to
   surface. The defect is invisible on the first grid a reviewer would try.

2. **Unnormalised discrete L2 norm (major, `thermal_column.py:64`).**
   `l2_error` claims a "grid-normalised discrete L2 norm" but computes the
   plain Euclidean vector norm. Because `||e||_2 ~ sqrt(N) ||e||_{L2}`, the
   measured order is depleted by exactly 1/2. With `cfl` forced to 0.5 so
   the run is stable, the shipped norm measures **1.500** where the scheme
   is genuinely **2.000**. The module's stated acceptance criterion
   ("order ~2") therefore fails even after defect 1 is fixed.

## Why this is good test material

- Defect 1 is the single most common error in explicit parabolic solvers and
  sits squarely in Ingrid's section 3 (numerical stability and convergence).
  The false convexity justification tests whether she checks the argument
  rather than accepting a confident docstring.
- Defect 2 tests the distinction between *the scheme's order* and *the
  measurement of the order* — the module docstring's second-order claim is
  correct mathematics wrecked by a wrong norm. Catching it requires actually
  running the refinement study, which her operating principles demand.
- Nothing in the file names either defect. No occurrence of "stability
  limit", "von Neumann", "CFL condition", "unstable", or "normalisation
  factor" in a comment.

## Reproducing the evidence

```bash
python3 input/thermal_column.py          # errors go to inf/nan, orders nonsense
```

Both numbers in this README were produced by fresh runs of the fixture file
(python 3.12.4, numpy 1.26.4). Full tables in `case.yaml` `notes:`.

## Pass criteria

See `case.yaml`. The minimum bar is a finding citing lines 19–26 that states
the stability requirement `r <= 1/2` (or `dt <= dx^2 / (2 kappa)`), with at
least one of: "1/2", "0.5", "von Neumann", "diffusion number", "unstable",
"stability limit".
