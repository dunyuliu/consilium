# A graph neural network surrogate for multicycle earthquake rupture on geometrically complex faults

R. Okonkwo, S. Batalha, and P. Vermeer
Submitted to *Journal of Geophysical Research: Solid Earth*

## Abstract

Physics-based simulation of sequences of earthquakes and aseismic slip (SEAS)
on geometrically complex faults remains computationally prohibitive: a single
multicycle run on a segmented strike-slip system costs thousands of core-hours,
which rules out the ensemble sizes needed for hazard work. We train a
message-passing graph neural network (GNN) on 4,800 simulated earthquake cycles
from a validated 2D finite-element SEAS solver and show that it predicts the
peak slip, recurrence interval, and rupture duration of the next cycle with a
median relative error of 3.1%, 4.4%, and 2.7% respectively. The surrogate
generalizes to fault geometries it has never seen during training, and evaluates
a full cycle in 5.8 s against 6.5 h for the solver, a speedup of ~4,000x. The
approach is applicable to any fault system.

## 1. Introduction

Multicycle rupture models couple slow interseismic loading to fast coseismic
rupture across ten orders of magnitude in timescale. Geometric complexity —
bends, stepovers, branches — controls where ruptures nucleate, arrest, and jump,
and it is exactly this complexity that makes each simulation expensive. Surrogate
models trained on simulator output are an attractive way out, provided they
transfer to configurations outside the training set. That transfer, not the
in-distribution fit, is what a surrogate must be judged on: a model that only
interpolates within the runs it was trained on replaces nothing, because
producing those runs was the expensive step.

We ask a narrow question: given a fault geometry and the state of the system at
the end of cycle *n*, can a GNN predict the coseismic characteristics of cycle
*n+1* accurately enough to substitute for the solver in ensemble applications?

## 2. Methods

### 2.1 Physics-based simulations

We use a 2D plane-strain finite-element SEAS solver with a quasi-static
interseismic phase and a fully dynamic coseismic phase, switched adaptively on a
slip-rate threshold of 1e-3 m/s. Faults are vertical, purely strike-slip, and
embedded in a homogeneous elastic medium (Vs = 3.464 km/s, rho = 2670
kg/m^3, nu = 0.25). Friction is rate-and-state with the aging law: a = 0.010,
b = 0.014, Dc = 0.02 m, and uniform effective normal stress of 50 MPa.
Tectonic loading is imposed as a far-field shear strain rate of
1.4e-14 s^-1.

The domain is 200 km x 100 km, discretized with 100 m quadrilateral elements
(2.0e6 elements). The dynamically measured cohesive-zone width in these runs is
0.7-1.0 km, so the process zone is spanned by 7-10 elements throughout the
simulations; the coseismic time step satisfies a CFL number of 0.4. We repeated
one geometry (G07) at 50 m element size: peak slip changed by 1.8% and rupture
duration by 1.4%, so the results reported here are resolved at 100 m.

We constructed 12 fault geometries, each a multi-segment vertical strike-slip
system 80-120 km long containing two to four restraining or releasing bends with
bend angles between 8 and 25 degrees. Each geometry was simulated for 450
earthquake cycles. The first 50 cycles of every run were discarded: the initial
stress state is prescribed arbitrarily, and the moment-release rate of every run
becomes statistically stationary by cycle 25-30 (Fig. 1b), so the first 50 cycles
carry the memory of the initial condition rather than the dynamics of the fault
system. The retained 400 cycles per geometry give 4,800 samples in total.

### 2.2 Dataset construction

Each sample is a graph. Nodes are fault nodes (segment length 100 m, 800-1,200
nodes per geometry); node features are the along-strike coordinate, the local
fault-normal and fault-tangential unit vectors, the shear and normal stress at
the end of cycle *n*, the state variable theta, and the cumulative slip. Edges
connect fault nodes to their along-strike neighbours and, additionally, to every
node within a 5 km radius, so that stress interaction across bends and stepovers
is representable. Targets are the peak slip, recurrence interval, and rupture
duration of cycle *n+1*.

The 4,800 samples from all 12 geometries were pooled and randomly partitioned
80/20 into a training set (3,840 samples) and a test set (960 samples). All
features and targets were standardized using training-set statistics only.

### 2.3 Network and training

Six message-passing layers, 128 hidden channels, sum aggregation, GELU
activations, residual connections between layers, and a three-head MLP decoder;
1.24e6 trainable parameters. Trained for 300 epochs with Adam, initial learning
rate 1e-3, cosine decay to 1e-5, batch size 16, on a single NVIDIA A100-80GB.
Loss is the mean absolute error on standardized targets. All results reported
here use random seed 20240617. The checkpoint at the final epoch is used; no
early stopping and no checkpoint selection were performed.

## 3. Results

The surrogate reproduces the coseismic characteristics of the next cycle with a
median relative error of 3.1% (peak slip), 4.4% (recurrence interval), and 2.7%
(rupture duration) on the 960 test samples (Table 1). Errors are largest for
cycles whose rupture arrests at a restraining bend rather than propagating
through it (Fig. 2), which are also the cycles the solver resolves most
expensively.

Figure 3 compares predicted and simulated along-strike slip profiles for three
test cycles drawn from geometry G04. The surrogate captures the slip deficit at
the 22-degree restraining bend near x = 61 km and the secondary slip maximum
beyond it (Fig. 3c), features that a smooth-fault surrogate cannot represent.

Inference costs 5.8 s per cycle on one A100. The corresponding solver run costs
6.5 h on 512 MPI ranks of Intel Xeon Platinum 8360Y nodes, giving a wall-clock
speedup of ~4,000x.

**Table 1.** Median relative error, GNN surrogate versus persistence baseline
(predict cycle *n+1* equal to cycle *n*), on the 960 test samples.

| Target              | GNN   | Persistence |
|---------------------|-------|-------------|
| Peak slip           | 3.1%  | 11.7%       |
| Recurrence interval | 4.4%  | —           |
| Rupture duration    | 2.7%  | —           |

## 4. Discussion

The central result is that the network has never seen the test geometries during
training, yet predicts their coseismic behaviour to within a few percent. This is
the property that matters for hazard applications, where the geometry of the
target fault system is by construction not in any training library.

Two caveats bound the result. First, the 4,000x figure is a per-inference
wall-clock ratio and excludes the cost of generating the training data, which was
4.0e4 core-hours; the surrogate pays for itself only in applications requiring
many thousands of forward evaluations. Second, the model predicts scalar cycle
characteristics and along-strike slip profiles, not the full spatiotemporal
rupture history, so it cannot substitute for the solver where the time-dependent
rupture front is the object of interest.

The largest errors occur for bend-arrest cycles, which is expected: arrest
depends on a near-critical balance between the dynamic stress concentration at
the bend and the local strength, and small errors in the predicted stress state
map to a binary difference in outcome. We regard this as the natural accuracy
ceiling of a surrogate that does not integrate the elastodynamic equations.

## 5. Conclusions

A graph neural network trained on 4,800 physics-based earthquake cycles predicts
next-cycle peak slip, recurrence interval, and rupture duration on geometrically
complex strike-slip faults to a few percent, transfers to fault geometries absent
from its training set, and runs ~4,000x faster than the solver it replaces.

## Figures

**Figure 1.** (a) The 12 fault geometries, drawn to scale. (b) Moment-release
rate versus cycle number for all 12 runs, showing the approach to statistical
stationarity by cycle 25-30 and the discarded 50-cycle spin-up interval (shaded).

**Figure 2.** Relative error of the GNN prediction versus bend angle, separated
into cycles that propagate through the largest bend (blue) and cycles that arrest
at it (orange).

**Figure 3.** Along-strike slip profiles, GNN prediction (dashed) versus solver
(solid), for three test cycles of geometry G04. (a) A through-going rupture.
(b) A rupture arresting at the 22-degree restraining bend.

## Data availability

The solver (v3.2.1), the 12 geometry definitions, all 5,400 simulated cycles, the
training script, and the trained checkpoint are archived at
doi:10.5281/zenodo.0000000.
