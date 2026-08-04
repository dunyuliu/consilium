# Task as given to the agent (verbatim from the caller)

> I refactored the initialisation path (branch `refactor/init-path`,
> build `71d0be8`) against `v3.2.0` (build `a4f19c2`). The case is
> `ref-case-02`; both runs completed and I have slip-rate output on the
> fault line at t = 6.0 s from both builds, on identical nodes:
>
>   `out_a/sliprate_t6.0.bin` (reference, v3.2.0)
>   `out_b/sliprate_t6.0.bin` (candidate, refactor/init-path)
>
> Tell me what moved and where. What I actually need to know is whether
> the nucleation zone still behaves the same after the refactor — that is
> the part of the code I touched, and it sits at x = 0–8 km on the fault
> line. I am not asking you to sign off on the build; I want the map of
> what changed.

## Context available to the caller (not passed to the agent)

- Fault line spans x = 0 to 60 km, 3000 output nodes, 20 m spacing.
- The rupture front at t = 6.0 s sits near x = 21 km in both builds.
- No source files were changed by this deployment; the agent was asked
  for analysis only.
