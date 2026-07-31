# rafael-001 — area source used as a volumetric source

**Agent under test:** `rafael-santos`
**Difficulty:** medium — nothing in the file contradicts itself in words; the
defect is only visible by carrying units through the source term.

## The model

`input/fault_heating.py` integrates 1-D conduction normal to a slipping
fault, with shear heating deposited inside a shear zone of finite width `w`.
Explicit FTCS, cell-centred half-profile, mirror symmetry at the slip surface,
insulating far edge.

## Planted defects

1. **Missing length scale in the source (critical, `fault_heating.py:63`).**
   `q = tau * V` is frictional power per unit *fault area* (W m^-2). The
   update adds `q * dt / (RHO * C_P)`, whose units are

   ```
   (Pa · m s^-1 · s) / (J m^-3 K^-1) = (J m^-2) · (m^3 K J^-1) = K·m
   ```

   — a temperature times a length, not a temperature. Converting the area
   source to the volumetric source the equation actually needs requires
   dividing by the shear-zone width: `q * dt / (RHO * C_P * w)`. `w` is a
   parameter of `run()` and is used to build the mask, but never normalizes
   the source.

   Measured: at tau = 20 MPa, V = 1 m/s, w = 10 mm, t = 1 s the module
   reports a 7.4 K temperature rise; the correct form gives 741.3 K, within
   0.07% of the adiabatic bound tau·V·t/(rho·c·w) = 740.7 K. The error factor
   is exactly 1/w = 100.

2. **Silent cap at the solidus (major, `fault_heating.py:64`).**
   `np.clip(Tn, T_AMBIENT, T_MELT)` swallows any excursion above the melting
   point instead of raising. Latent while defect 1 is present; with defect 1
   fixed, a 2 s run peaks at 1957 K and reports 1450 K.

## Why these are good test material

- Defect 1 is priority 1 of the agent's own checklist (dimensional analysis)
  applied to a term that *looks* like every other explicit source update. No
  comment, docstring, or variable name gives it away — the only route in is
  writing out the units of `tau * V`.
- The two defects interact: the primary suppresses the temperature enough
  that the secondary never fires, so a report that finds only the clip has
  not understood the model. Ordering the severities correctly is part of the
  test.
- The file contains four deliberate near-misses (CFL, far-field BC, symmetry
  BC, shear-zone resolution) that are all physically fine at the defaults.
  They are listed in `case.yaml` notes; findings against them are false
  positives.

## Pass criteria

See `case.yaml`. The minimum bar is a finding citing lines 61–65 that names
the dimensional inconsistency or the missing shear-zone width.
