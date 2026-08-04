# selin-001 — a supershear transition resolved by 1.7 cells

**Agent under test:** `selin-aydin`
**What is being tested:** DETECTION plus restraint. The manuscript contains one
load-bearing methodological defect and four choices that look aggressive and
are defensible. A run that finds the defect but also calls the station
exclusion cherry-picking fails.
**Difficulty:** medium-hard — the defect is not visible in any single sentence.
It only appears when the reviewer takes five numbers from three different
sections and computes the breakdown-zone width.

## The submission

`input/manuscript.md` — a ~180-line excerpt of a GJI submission reporting a
3-D spontaneous dynamic rupture model of a fictional Mw 7.6 strike-slip
earthquake, claiming a supershear transition at 44 km along strike and using
its position to constrain the asperity prestress to 31.0 +/- 2.0 MPa.

## The planted defect

Section 2.5 justifies a 250 m on-fault grid with a nodes-per-wavelength
argument, which is arithmetically correct (10.4 nodes per shear wavelength at
1 Hz) and governs the wrong physics. The criterion that governs a spontaneous
rupture is the breakdown-zone width:

```
mu      = rho Vs^2 = 2700 x 3300^2            = 29.40 GPa
mu*     = mu/(1-nu), nu = 0.25                = 39.20 GPa
tau_p - tau_r = (0.60 - 0.30) x 60 MPa        = 18.0 MPa
Lambda_0(II)  = (9 pi/32) mu* Dc/(tau_p-tau_r), Dc = 0.22 m = 423 m
Lambda_0(III) = (9 pi/32) mu  Dc/(tau_p-tau_r)             = 318 m

cells at dx = 250 m: 1.69 (mode II), 1.27 (mode III)
```

Fewer than two cells by either mode, against a working threshold of 3-5, and
Lambda_0 is the optimistic quasi-static bound — the zone contracts further at
high rupture speed. Every input to that calculation is stated in the
manuscript (Section 2.2 velocity table, Table 1, Section 2.5); the words
"cohesive zone", "process zone" and "S-ratio" appear nowhere in it.

The second paragraph of Section 2.5 is the same defect's other limb: the
"convergence" check refines **coarser** (250 -> 500 m, never 125 m) and scores
it on Mw and mean slip, the two observables that cannot see breakdown-zone
under-resolution. The grid-sensitive quantities — rupture speed, transition
distance, peak slip rate — are the paper's results and were never compared
across grids. So the headline claim rests on a number that has not been shown
to be independent of the mesh.

## Controls (verified clean)

| # | Looks like | Actually |
|---|---|---|
| C1 | 2 of 14 stations dropped from the fit statistic | Physical cause stated (1.8 km basin absent from a 1-D model), decided before the fits, residuals printed in Table 2 with sign and size, both 12- and 14-station means given, and the four worst non-basin fits retained |
| C2 | "valid to 1 Hz" on a 250 m grid | 10.4 nodes per shear wavelength — twice the quoted criterion; PGA explicitly disclaimed as out of band |
| C3 | 2.0 km nucleation patch | 3.6x the Uenishi & Rice critical half-length of 555 m, 1.3% of rupture length, 44 km from the transition |
| C4 | 6 MPa stress drop, 4.9 km/s rupture | Self-consistent: mean slip, static drop, M0 and Mw all reproduce to within the reported precision; 4.9 km/s sits between sqrt(2)Vs and Vp; background S = 1.90 and asperity S = 0.385 are exactly what the reported sub-Rayleigh-then-supershear history requires |

C1, C2 and C3 are guarded by `must_not_find`. Full arithmetic for all four is
in `case.yaml`.

## Adversarial pass

Three real contaminants were found in the draft input and removed before
shipping: circular reasoning in the asperity-prestress provenance, a
"planar fault with a 12-degree bend" contradiction, and a supershear
transition placed outside the asperity that causes it. Six remaining soft
edges (epicentral vs rupture distance, GNSS covariance, neglected plasticity,
the undiscussed bend, the 0.02 Hz corner, an abstract generalisation) are real
but minor, are deliberately **not** guarded, and must not be scored against a
run that raises them. See the adversarial-pass section of `case.yaml`.

## Pass criteria

See `case.yaml`. The bar: the breakdown zone named and computed, Section 2.5
cited at both paragraphs, the coarser-direction convergence test attacked, the
44 km transition and the prestress constraint identified as the casualties,
and none of C1-C4 flagged.
