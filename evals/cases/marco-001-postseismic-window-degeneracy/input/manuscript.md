# Weak Asthenospheric Viscosity Beneath the Arqala Rift Inferred from GPS Postseismic Transients Following the 2019 Mw 7.5 Kestrel Fault Earthquake

**Authors:** A. Renkema, T. Okonkwo, S. Baptiste
**Affiliation:** Institute for Continental Tectonics
**Target journal:** JGR Solid Earth (draft, not yet submitted)

## Abstract

The 14 March 2019 Mw 7.5 Kestrel Fault earthquake ruptured 120 km of the right-lateral
Kestrel Fault system bounding the Arqala Rift, offering a rare opportunity to constrain
upper-mantle rheology beneath an active continental rift from postseismic GPS
transients. We invert 20 months of continuous GPS displacement time series from 18
stations for the viscosity of a Maxwell viscoelastic half-space beneath a 25 km elastic
lid. The best-fitting viscosity, eta = 1.3e19 Pa s, is roughly an order of magnitude
below typical continental upper-mantle estimates and implies rapid postseismic stress
relaxation, consistent with the elevated heat flow inferred from a magnetotelluric
conductor at 40-60 km depth beneath the rift axis. We interpret this as direct geodetic
evidence for an anomalously weak asthenosphere, most plausibly driven by partial melt
or enhanced water content in the shallow mantle wedge.

## 1. Introduction

Postseismic geodetic transients following large continental earthquakes are routinely
used to constrain the viscosity of the lower crust and upper mantle (Pollitz, 2003;
Freed, 2007). Two mechanisms compete to produce the characteristic decelerating surface
deformation seen in the months to years after a mainshock: afterslip on the down-dip
extension of the coseismic rupture, and viscoelastic relaxation of the ductile crust or
mantle loaded by the coseismic stress change. Distinguishing the two is a long-standing
problem, and their relative contribution depends on fault depth, rheology, and network
geometry (Hearn, 2003; Barbot and Fialko, 2010). The Arqala Rift has a magnetotelluric
survey (Okonkwo et al., 2016) showing a conductive body at 40-60 km depth beneath the
rift axis, interpreted as a zone of partial melt or hydrated mantle; the 2019 Kestrel
Fault earthquake produced a rich postseismic GPS record that we use here to place an
independent geodetic constraint on mantle viscosity beneath the rift.

## 2. Tectonic Setting and the 2019 Earthquake

The Kestrel Fault system accommodates right-lateral shear along the eastern margin of
the Arqala Rift at 6-9 mm/yr, estimated from offset Pleistocene terraces (Baptiste et
al., 2012). The 2019 rupture spans 120 km, and the relocated aftershock catalog extends
to a maximum depth of 24.6 km, consistent with a seismogenic thickness of about 25 km
for this part of the rift margin. Static coseismic offsets at the nearest GPS stations
(5-20 km from the surface trace) reached 1.8 m.

## 3. GPS Data and Reference Frame

We use daily positions from 18 continuous GPS stations within 150 km of the rupture,
all operating since at least 2008, giving 11 years of pre-earthquake data per station.
Coordinates are computed in the IGS14 reference frame; at each station we fit a linear
interseismic velocity to the 2008-14 March 2019 window and subtract it from the full
series, so the postseismic series analyzed below is a residual relative to the
pre-earthquake secular trend, not a raw ITRF14 displacement. As a check on frame
realization, we reprocessed four representative stations in ITRF2014 instead of IGS14:
fitted secular rates changed by less than 0.05 mm/yr, well within the 0.3 mm/yr formal
velocity uncertainty, and the recovered postseismic transient at those stations was
unchanged within the noise floor.

## 4. Coseismic Slip Model

The coseismic slip distribution used to initialize the postseismic models comes from a
single ascending-track Sentinel-1 interferogram, inverted for slip on a planar fault in
a homogeneous elastic half-space (mu = 30 GPa). A usable descending-track interferogram
was unavailable due to decorrelation over the rift's alluvial cover, and the static GPS
offsets were used only for co-registration, not jointly inverted with the InSAR data.
The preferred model has an average slip of 4 m over a 120 km x 15 km rupture plane,
giving a seismic moment M0 = mu*A*D = 3.0e10 Pa x 1.8e9 m^2 x 4 m = 2.16e20 N m,
equivalent to Mw 7.49, consistent with the regional moment-tensor solution (Mw 7.5).
The single-track geometry weakly constrains the dip-slip component, so the along-dip
position of peak slip carries larger uncertainty than the along-strike position.

## 5. Postseismic Model: Afterslip and Viscoelastic Relaxation

We model postseismic surface displacements with a Maxwell viscoelastic half-space
(Savage and Prescott, 1978): an elastic layer of thickness H, loaded by the coseismic
slip model of Section 4, overlying a Maxwell viscoelastic half-space of unknown
viscosity eta. We fix H = 25 km, matching the seismogenic thickness from the aftershock
catalog (Section 2). To assess sensitivity to this choice we repeated the inversion
with H = 20 km and H = 30 km; the best-fit viscosity shifts to 1.0e19 Pa s and
1.6e19 Pa s respectively, about a factor of 1.6 for a +/-5 km change in H, consistent
with the trade-off documented by Hearn (2003) for comparable geometries.

Afterslip is not included as a separate term in the forward model. Forward synthetic
tests (not shown) indicate that the shallow fault-parallel creep signal at the four GPS
stations closest to the surface trace (5-20 km) decays below the GPS detection
threshold (< 1 mm) within the first three weeks after the mainshock. We therefore
consider the displacement time series from day 20 onward to be purely viscoelastic in
origin, and use a 600-day window (day 20 to day 620 after the mainshock, approximately
20 months) of daily positions from all 18 stations to constrain eta via nonlinear
least squares.

## 6. Results

Table 1 summarizes the inversion. The best-fitting Maxwell viscosity is eta = 1.3e19
Pa s, with an RMS misfit of 2.1 mm across the network. We did not compute a formal
confidence interval on eta (e.g., bootstrap or MCMC); the reported value should be read
as a point estimate rather than a bounded range, and we flag this as a target for a
follow-up study. Station-by-station residuals, including the two stations with the
largest misfit (both within 10 km of a mapped secondary fault strand), are given in
Table 2. The recovered viscosity is lowest directly beneath the rift axis and increases
by roughly a factor of three toward the rift flanks, mirroring the lateral extent of
the magnetotelluric conductor of Okonkwo et al. (2016).

## 7. Discussion

A Maxwell viscosity of 1.3e19 Pa s is roughly an order of magnitude below viscosities
typically inferred beneath stable continental interiors (10^20-10^21 Pa s; Pollitz,
2003), and instead comparable to values reported for young, thermally weakened
lithosphere in active rift and back-arc settings. Combined with the spatial coincidence
between the low-viscosity zone and the magnetotelluric conductor, we interpret the
postseismic transient as direct geodetic confirmation that the shallow mantle beneath
the Arqala Rift is anomalously weak, most plausibly due to partial melt or elevated
water content associated with active rifting.

## 8. Conclusions

Inversion of 20 months of postseismic GPS data yields a Maxwell viscosity of eta =
1.3e19 Pa s beneath the Arqala Rift, roughly an order of magnitude below typical
continental values, consistent with independent magnetotelluric evidence for a shallow
conductive body and supporting a weak-asthenosphere interpretation for rift
localization.

## References

Barbot, S., and Fialko, Y. (2010). A unified continuum representation of post-seismic relaxation mechanisms. Geophys. J. Int.
Baptiste, S., et al. (2012). Late Quaternary slip rate of the Kestrel Fault from offset terraces. Tectonics.
Freed, A. M. (2007). Afterslip, transient creep, and viscoelastic relaxation. Annu. Rev. Earth Planet. Sci.
Hearn, E. H. (2003). What can GPS data tell us about the dynamics of postseismic deformation? Geophys. J. Int.
Okonkwo, T., et al. (2016). Magnetotelluric imaging of the Arqala Rift. JGR Solid Earth.
Pollitz, F. F. (2003). Transient rheology of the uppermost mantle beneath the Mojave Desert. Earth Planet. Sci. Lett.
Savage, J. C., and Prescott, W. H. (1978). Asthenosphere readjustment and the earthquake cycle. J. Geophys. Res.

## Table and Figure Captions

**Table 1.** Best-fitting Maxwell viscosity and RMS misfit for the preferred model (H = 25 km) and the two sensitivity tests (H = 20, 30 km).
**Figure 1.** Map of the Kestrel Fault system, the 18 GPS stations, and the magnetotelluric conductor outline of Okonkwo et al. (2016).
**Figure 2.** Observed and modeled postseismic displacement time series at four representative GPS stations, day 20 to day 620 after the mainshock.
**Figure 3.** Recovered viscosity as a function of distance from the rift axis.
