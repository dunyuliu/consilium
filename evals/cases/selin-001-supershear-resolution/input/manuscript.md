# Spontaneous supershear transition on the Karaburun fault: a 3-D dynamic rupture model of the 2019 Mw 7.6 earthquake and its near-field ground motion

*Submitted to Geophysical Journal International — manuscript GJI-2026-0417*

A. Demirel, R. Öztürk, M. Kılıç

## Abstract

We present a 3-D spontaneous dynamic rupture simulation of the 2019 Mw 7.6
Karaburun earthquake. The rupture nucleates at the northern tip of the fault,
propagates unilaterally southward at a mean speed of 2.8 km/s, and accelerates
to a stable supershear speed of 4.9 km/s at 44 km along strike, shortly after
entering a high-prestress asperity whose extent is mapped by the pre-event
microseismicity gap. Back-projection of the teleseismic P wavefield places the
observed transition at 42 +/- 5 km along strike, so the transition distance is
predicted, not fitted. The supershear phase generates a Mach front that
accounts for the peak ground velocity of 1.2 m/s recorded at station ALT,
which lies 3 km from the surface trace, a value no sub-Rayleigh model of this
event reproduces. We conclude that the observed transition distance constrains
the asperity prestress to 31.0 +/- 2.0 MPa.

## 1. Introduction

Supershear rupture has been inferred for a growing number of large strike-slip
earthquakes, but the conditions that set the transition distance remain poorly
constrained by observation alone. Dynamic rupture modelling is the only tool
that connects a candidate stress state to a transition distance and to the
resulting near-field wavefield. Here we forward-model the Karaburun rupture
from an independently derived stress state and compare the predicted
transition distance with the back-projected one.

## 2. Method

### 2.1 Fault geometry

The Karaburun fault is modelled as a vertical, right-lateral surface 150 km
long, extending from the free surface to 15 km depth, with a 12-degree
restraining bend at 96 km along strike. Geometry follows the mapped surface
trace and the relocated aftershock cloud (0-15 km depth range, 90 per cent of
events within 2 km of the modelled surface).

### 2.2 Material model

The medium is linear elastic with a two-layer 1-D structure:

| Layer | Depth (km) | rho (kg/m3) | Vs (m/s) | Vp (m/s) |
|---|---|---|---|---|
| Upper crust | 0-2 | 2500 | 2600 | 4503 |
| Seismogenic | 2-40 | 2700 | 3300 | 5716 |

Poisson's ratio is 0.25 throughout. Anelastic attenuation uses Qs = 100 Vs
(km/s) and Qp = 2 Qs. Off-fault deformation is purely elastic; we do not
include plasticity, and we discuss the consequences in Section 5.

### 2.3 Friction and initial stress

Friction is linear slip-weakening. Parameters are uniform below 3 km depth and
are listed in Table 1. Above 3 km, Dc is increased linearly to 0.60 m at the
free surface to suppress unphysical shallow slip; the initial shear stress is
tapered over the same interval.

**Table 1.** Fault constitutive and stress parameters below 3 km depth.

| Quantity | Symbol | Value |
|---|---|---|
| Effective normal stress | sigma_n | 60 MPa |
| Static friction coefficient | mu_s | 0.60 |
| Dynamic friction coefficient | mu_d | 0.30 |
| Slip-weakening distance | Dc | 0.22 m |
| Background initial shear stress | tau_0 | 24.2 MPa |
| Asperity initial shear stress (40-75 km) | tau_0a | 31.0 MPa |

The slip-weakening distance is chosen so that the fracture energy,
Gc = 0.5 (tau_p - tau_r) Dc, is 1.98 MJ/m2, consistent with the seismological
scaling of Abercrombie & Rice (2005) at the mean slip of this event. The
background initial shear stress comes from a regional stress inversion of
1978-2018 focal mechanisms. The asperity value follows from the same inversion
plus the requirement that the asperity stood at 86 per cent of its static
strength before the event, the loading level implied by the 40-year
microseismicity gap and the interseismic geodetic slip deficit. Neither value
was adjusted to fit any observable reported in this paper.

### 2.4 Nucleation

Rupture is initiated inside a circular patch of radius 2.0 km centred at
12 km depth, in which the initial shear stress is raised to 1.005 times the
static strength. The patch is 1.3 per cent of the rupture length. All rupture
speeds reported below are measured beyond 15 km from the hypocentre, and the
supershear transition occurs 44 km from it, so no reported quantity is
sensitive to the nucleation procedure.

### 2.5 Numerical resolution

The domain is discretised with a fourth-order summation-by-parts finite
difference scheme using a uniform on-fault node spacing of 250 m, coarsening
to 1500 m at the absorbing boundaries. The lowest shear-wave speed anywhere in
the model is 2600 m/s, so at the upper limit of the frequency band we
interpret (1 Hz) the grid provides 10.4 nodes per shear wavelength, twice the
5-nodes-per-wavelength criterion usually quoted for this scheme. The
simulation is therefore resolved throughout the band in which it is used. The
time step is 5 ms, giving a Courant number of 0.114.

To confirm that the result does not depend on the discretisation, we repeated
the simulation with a uniform on-fault spacing of 500 m. The moment magnitude
changes by 0.02 units (Mw 7.64 against Mw 7.62) and the mean slip by 4 per
cent. We take this agreement as evidence that the solution is converged and
that no further refinement is required.

## 3. Rupture results

The modelled rupture propagates unilaterally southward. Between 15 and 40 km
along strike the front advances at 2.8 km/s, or 0.85 Vs. On entering the
asperity the front accelerates, and a daughter crack ahead of the main front
takes over at 44 km along strike. Beyond that point the front propagates at
4.9 km/s, between the Eshelby speed of 4.67 km/s and the P-wave speed of
5.72 km/s, and the rupture remains supershear to the southern tip. Total
rupture duration is 40 s. Mean slip is 4.9 m, peak slip 11.2 m on the
asperity, and peak slip rate 8.1 m/s. The seismic moment is 3.24e20 N m
(Mw 7.64), against the Global CMT value of 3.1e20 N m (Mw 7.63). The average
static stress drop is 6.0 MPa.

The transition distance is the central result of this paper. Lowering the
asperity prestress to 28.0 MPa delays the transition to 51 km, outside the
back-projection uncertainty; raising it to 34.0 MPa advances the transition to
42 km and brings the Mach front to station ALT 1.6 s too early. The observed
transition therefore constrains the asperity prestress to 31.0 +/- 2.0 MPa.

## 4. Ground motion

Synthetic velocity seismograms are computed at 14 strong-motion stations at
epicentral distances of 8-110 km, filtered to 0.02-1.0 Hz, and compared with
the recordings in the same band. We report PGV only; PGA is controlled by
frequencies above the band this model resolves and we make no claim about it.
Goodness of fit is measured by variance reduction over a 90 s window.

**Table 2.** Station fits. All 14 stations are listed. VR is variance
reduction in the 0.02-1.0 Hz band; ratio is synthetic PGV over observed PGV.

| Station | R_epi (km) | Obs PGV (m/s) | Syn PGV (m/s) | Ratio | VR (%) | In statistic |
|---|---|---|---|---|---|---|
| ALT | 61 | 1.20 | 1.14 | 0.95 | 79 | yes |
| BSK | 8 | 0.94 | 1.09 | 1.16 | 74 | yes |
| CNR | 17 | 0.71 | 0.63 | 0.89 | 71 | yes |
| DGL | 24 | 0.55 | 0.62 | 1.13 | 68 | yes |
| ERK | 33 | 0.44 | 0.39 | 0.89 | 66 | yes |
| FTS | 41 | 0.38 | 0.44 | 1.16 | 63 | yes |
| GKC | 47 | 0.31 | 0.28 | 0.90 | 60 | yes |
| HRM | 55 | 0.27 | 0.31 | 1.15 | 57 | yes |
| ILC | 68 | 0.19 | 0.15 | 0.79 | 52 | yes |
| KZL | 77 | 0.16 | 0.20 | 1.25 | 48 | yes |
| MRD | 94 | 0.11 | 0.08 | 0.73 | 43 | yes |
| NVS | 110 | 0.08 | 0.11 | 1.38 | 38 | yes |
| KVK | 38 | 0.86 | 0.36 | 0.42 | 9 | no |
| DRB | 52 | 0.64 | 0.22 | 0.34 | -14 | no |

KVK and DRB sit on the Ovacık basin, whose sediment fill reaches 1.8 km. Our
velocity model is a 1-D structure that contains no basin, so the model cannot
represent the site response at these two stations and underpredicts their PGV
by factors of 2.4 and 2.9. We exclude them from the summary statistic on that
basis, decided before the fits were computed, and report their residuals in
Table 2 so the reader can see the size and sign of the mismatch. Mean variance
reduction is 60 per cent over the 12 retained stations and 51 per cent over
all 14; both numbers are stated here and neither claim in this paper depends
on which is used. The retained set includes the four worst-fitting non-basin
stations (ILC, KZL, MRD, NVS, VR 38-52 per cent), which are the farthest and
are limited by the 1-D structure at long path lengths.

Coseismic offsets at 22 continuous GNSS sites (ITRF2014, 30 s high-rate,
coseismic window 0-60 s so that no postseismic transient enters the estimate)
are fit with a horizontal residual RMS of 6.2 cm against a maximum observed
offset of 3.9 m.

## 5. Discussion and limitations

Off-fault plasticity is neglected. At an average static stress drop of 6.0 MPa
the inelastic strain expected off a mature fault is modest, and neglecting it
should bias the rupture speed high by a few per cent; we regard this as a
second-order effect on the transition distance but note that it is not zero.

The 1-D velocity structure limits the fit at the farthest stations and
prevents any statement about the two basin sites. A 3-D model of the Ovacık
basin is the obvious next step.

We conclude that the supershear transition at 44 km along strike is a robust
feature of the Karaburun rupture and that its position constrains the asperity
prestress to within 2 MPa.
