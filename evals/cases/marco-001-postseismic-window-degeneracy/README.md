# marco-001-postseismic-window-degeneracy

Tests whether `marco-bianchi` finds the rheology-specific load-bearing
weakness instead of reaching for the more obvious-looking, but defensible,
reference-frame or elastic-thickness critiques.

`input/manuscript.md` is a synthetic ~137-line JGR-style manuscript claiming
that 20 months of postseismic GPS following a Mw 7.5 strike-slip earthquake
require an anomalously weak asthenosphere (Maxwell viscosity eta = 1.3e19
Pa s) beneath a continental rift.

## The load-bearing weakness

`manuscript.md:82-89` -- the manuscript fits its Maxwell viscosity from a
600-day (~1.64 yr) postseismic window. With mu = 30 GPa (:13) and the
best-fit eta = 1.3e19 Pa s (:14, :93), the implied Maxwell relaxation time is
tau_M = eta/mu ~ 13.7 yr. The window covers only ~12% of one Maxwell time --
early enough that the predicted viscoelastic transient is not distinguishable
in shape from a logarithmic afterslip decay. The manuscript's only defense
against residual afterslip is an unverifiable "not shown" synthetic test
restricted to four near-field surface stations (:82-85), which says nothing
about deeper afterslip contributing to the far-field network used for the
fit. **The window is too short to separate the two mechanisms the paper's
own cited references (Hearn 2003; Barbot & Fialko 2010) identify as
degenerate**, so the "anomalously weak asthenosphere" conclusion has no
supporting experiment.

## The distractors (real, secondary)

- No confidence interval on eta -- disclosed honestly, still a fair ask, does
  not fix the identifiability problem.
- Coseismic slip model from a single ascending-track InSAR interferogram,
  not jointly inverted with GPS.
- Results cites "Table 2"; only Table 1 is defined in the captions.

## The controls (defensible -- attacking either is a fail)

- Reference frame: postseismic series are residuals relative to an 11-year
  pre-earthquake secular trend per station, not raw ITRF displacements, and
  an IGS14-vs-ITRF2014 reprocessing test on 4 stations shows <0.05 mm/yr
  difference against 0.3 mm/yr formal uncertainty.
- Fixed elastic thickness H = 25 km: tied to an independent seismogenic
  depth estimate and bracketed by a disclosed sensitivity test (H = 20, 30
  km) showing eta changes by a factor of 1.6 -- every value in that range is
  still an order of magnitude below normal continental viscosities, so the
  qualitative conclusion is robust to the trade-off even though the point
  estimate is not.

Full defect set, the arithmetic, the adversarial pass over the input, and the
pass condition are in `case.yaml` under `notes:`.
