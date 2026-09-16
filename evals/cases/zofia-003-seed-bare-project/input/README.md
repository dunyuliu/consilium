# tidalflux

A depth-averaged solver for tidal-channel exchange flow, written for the
Sørfjorden campaign and since used on three other fjord systems.

## Why the depth-averaged form

The full three-dimensional problem is not worth its cost here. Channel aspect
ratios in these systems run 40:1 or wider, and the vertical structure of the
exchange flow is set almost entirely by the density gradient at the sill rather
than by anything the interior does. Averaging over depth removes two orders of
magnitude of state at a cost we measured at under 4% in transport through the
sill section, which is inside the observational uncertainty of the ADCP record
we validate against.

## Governing equations

Continuity and momentum are solved in flux form on a staggered C-grid:

    ∂h/∂t + ∂(hu)/∂x = 0
    ∂(hu)/∂t + ∂(hu²)/∂x = -gh ∂η/∂x - c_d u|u| + A_h ∂²(hu)/∂x²

with `c_d` the quadratic drag coefficient and `A_h` a horizontal eddy
viscosity. The baroclinic term enters through a two-layer reduced-gravity
correction at the sill only; the interior is treated as barotropic. This is the
approximation that limits the model, and it is the first thing to revisit if a
future campaign cares about the interior stratification.

## Numerics

Time stepping is a two-stage Runge-Kutta scheme with a CFL-limited step. The
advective term uses a flux-limited upwind reconstruction — plain upwinding
smeared the sill front badly enough to change the transport estimate, which is
the number the whole model exists to produce.

## Validation status

Transport through the sill section agrees with the 2019 ADCP record to within
6% RMS over a spring-neap cycle. The phase of the tidal front at the narrows
lags observations by roughly 20 minutes and nobody has chased it down.

## Where this is going

Next is a two-layer interior so the stratification is not pinned at the sill,
then a proper wetting-drying treatment for the intertidal flats at the head of
the fjord. Both are large enough to want a design written down before any code
is touched.
