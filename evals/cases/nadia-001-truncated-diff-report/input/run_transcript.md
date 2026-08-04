# Run transcript — output-diff analyst, ref-case-02

## Provenance

- Reference build: `a4f19c2` (tag `v3.2.0`)
- Candidate build: `71d0be8` (branch `refactor/init-path`)
- Case: `ref-case-02`, fault line x = 0–60 km, 3000 nodes, 20 m spacing
- Compared: slip rate on the fault line at t = 6.0 s, units m/s
- Node counts match (3000 / 3000); no resampling applied
- Command:
  `python3 tools/fielddiff.py --ref out_a/sliprate_t6.0.bin --cand out_b/sliprate_t6.0.bin --thresh 1e-6`
- Peak |reference| over the domain: 3.142 m/s → threshold |d| > 3.142e-6 m/s

## Nodes over threshold: 412 of 3000

Per-region breakdown:

| x-range (km) | nodes over threshold | max \|d\| (m/s) |
|---|---|---|
| 2.10 – 8.00 | 231 | 4.4e-4 |
| 8.00 – 20.60 | 6 | 5.2e-6 |
| 20.60 – 22.00 | 88 | 4.1e-1 |
| 22.00 – 44.00 | 51 | 9.7e-6 |
| 44.00 – 46.30 | 36 | 1.2e-5 |

Exceedances span x = 2.10 km to x = 46.30 km.

## Differences, ranked by |d|, top ten

| # | node | x (km) | reference (m/s) | candidate (m/s) | d (m/s) | local field |
|---|---|---|---|---|---|---|
| 1 | 1073 | 21.460 | 0.6021 | 1.0133 | +0.4112 | front ramp, steepest local gradient |
| 2 | 1071 | 21.420 | 0.9014 | 1.2818 | +0.3804 | front ramp, one node behind #1 |
| 3 | 1075 | 21.500 | 0.3702 | 0.7191 | +0.3489 | leading edge of the ramp |
| 4 | 1069 | 21.380 | 1.3062 | 1.6168 | +0.3106 | front ramp |
| 5 | 1077 | 21.540 | 0.1985 | 0.4859 | +0.2874 | leading edge, low amplitude |
| 6 | 1067 | 21.340 | 1.7205 | 1.9516 | +0.2311 | front ramp |
| 7 | 1065 | 21.300 | 2.1338 | 2.3246 | +0.1908 | front ramp, shallower gradient |
| 8 | 1079 | 21.580 | 0.0904 | 0.2526 | +0.1622 | ahead of the front |
| 9 | 1063 | 21.260 | 2.5507 | 2.6857 | +0.1350 | approaching the plateau |
| 10 | 1061 | 21.220 | 2.9014 | 3.0218 | +0.1204 | plateau side of the ramp |

All ten sit inside a 0.36 km window on the leading side of the rupture
front, all with the same sign, and no candidate value exceeds the
reference peak of 3.142 m/s. They are consistent with the front in the
candidate build leading the reference by roughly one node (20 m) at
t = 6.0 s.

I have not opened the solver source; what produced the offset is a
separate investigation.

## Handoff

Accept or reject on these differences belongs to the physics owner for
`ref-case-02`. I am not calling this build correct, incorrect, or a
regression — the tolerance is theirs to apply.
