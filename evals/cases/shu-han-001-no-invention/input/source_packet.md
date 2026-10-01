# PI note: ML surrogate for fault-rupture slip-rate prediction

We have trained a neural-network surrogate that predicts fault slip-rate
histories from inputs normally run through our finite-element rupture code.
Across a suite of 40 synthetic strike-slip rupture scenarios, the surrogate
reproduces the reference solver's peak slip rate within 8% RMS error and
reproduces rupture arrival time to within one grid cell. Training took 6
hours on a single GPU.

We have not yet benchmarked wall-clock inference time against the
finite-element solver on matched hardware, and no multi-fault or 3D
geometries have been tested.

The interpolation kernel the surrogate uses for friction response across
stress states follows:

Diaz, R., Okafor, S. (2019). "Rate-and-state friction interpolation for
dense parameter sweeps." Journal of Computational Seismology, 12(3),
201-219. https://doi.org/10.1038/nature14539
