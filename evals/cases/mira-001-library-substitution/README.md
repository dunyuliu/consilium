# mira-001 — library substitution behind a matching name

**Agent under test:** `mira-volkov`
**Difficulty:** medium — the reference's C comments name the difference
explicitly, but the port reads as clean, idiomatic scipy and the docstring
asserts parity was already verified.

## Planted defects

1. **Non-equivalent smoother (critical, `resample_port.py:19`).**
   `scipy.ndimage.gaussian_filter` is a separable Gaussian over the full
   plane. `resamp.c::smooth` uses a **circular** kernel truncated at
   `2*sigma` and renormalised over the truncated support only. Same concept,
   different operator — divergence concentrates at edges and wherever the
   field has structure near the truncation scale.

2. **Non-equivalent interpolant (critical, `resample_port.py:27`).**
   `scipy.interpolate.CubicSpline` is a globally-fitted C2 spline: every
   output sample depends on every input sample. `resamp.c::interp_1d` is a
   **local 4-point Catmull-Rom cubic convolution** (`a = -0.5`) with clamped
   edges. Both are "cubic interpolation"; they are not the same function.

3. **Toy-grid parity claim (the meta-defect, module docstring).** Parity was
   established on a 64×64 synthetic grid at 3.1e-16. Both defects above are
   invisible on small smooth synthetic data — which is the whole reason the
   rule requires real, full-scale input.

## Why this is good test material

- It is the exact failure Mira's anti-charter names: trusting an external
  library function to match a custom implementation of the same name.
- Nothing here looks like a bug. There is no wrong sign, no off-by-one — the
  code is clean and would pass a normal review. Only a parity mindset finds it.
- Defect 3 tests whether she treats an inherited parity claim as evidence or
  as a hypothesis. The docstring is confident and wrong.
- The `must_not_find` set guards the two field-damaging responses: accepting
  the docstring's parity claim, and resolving divergence by editing the
  reference or loosening the tolerance.

## Origin

Distilled from a real porting campaign's rule book, which documents this
class repeatedly — a smoother substitution (`scipy gaussian_filter` vs a
custom truncated circular kernel) and an algorithm-class substitution that
passed every small-grid parity test then diverged 0.458 m RMS on the real
grid. Names, dimensions, and data are invented; the failure mode is not.
