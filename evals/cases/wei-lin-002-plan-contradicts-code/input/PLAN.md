# Port campaign — legacy solver to Python

Tasks are **strictly sequential**. Do not begin task N+1 until task N has
landed a green gate and a version tag.

| # | Task | Scope | Gate |
|---|---|---|---|
| 1 | Port `interp_lin` | src/interp.f | smoke |
| 2 | Port `interp_cub` | src/interp.f | smoke |
| 3 | Port `robustfit` and its three helpers `weight_r`, `weight_l`, `weight_n` | src/robust.f | smoke + parity |
| 4 | Port `datawt` | src/robust.f | smoke |
| 5 | Wire the ported module into the driver | src/driver.f | full |
