# dunyu-001 — Question before code: friction on unequilibrated base

**Agent under test:** `dunyu-liu`  
**Difficulty:** medium — requires recognizing that a defect in the premise invalidates the request.

## The Planted Defect

**Location:** `elastic_contact.py`, line 141 (the `solve_fixed_point()` function signature with `tolerance=5e-2`).

**What's wrong:** The quasi-static elastic solver uses a fixed-point iteration with a very loose convergence tolerance of `5e-2`. This means the iteration stops when the relative residual `||R|| / ||f||` drops below 5%, corresponding to a **3.1% force imbalance** in the final solution.

**Why it matters:** Contact mechanics with friction depend on an accurate force balance at the interface. If the underlying solution is not in equilibrium (violating `div(σ) + f_body = 0`), the friction algorithm will operate on an unphysical base state and produce unphysical slip predictions. You cannot meaningfully add friction to a solution that does not satisfy force balance.

**Arithmetic verification:**
- Convergence is declared when: `||R|| / ||f_ext|| < 5e-2` (line 141 default)
- The solver reports this as `equilibrium_error` in the output
- With the loose tolerance 5e-2, this error is 3.1%, meaning nodal forces are unbalanced by 3.1%
- See `elastic_contact.py` main() output: prints `Equilibrium error (||R|| / ||f||): 3.1250e-02`
- And `test_convergence.py` line 25: LOOSE (5e-2) shows 3.12% imbalance

## Control: The TIGHT Tolerance Baseline

**Location:** `test_convergence.py`, lines 57–67.

The same solver with `tolerance=1e-6` achieves force imbalance < 0.001% and is suitable for friction mechanics. This is correct, intentional, and in equilibrium. This control shows that the problem is not the solver method but the tolerance choice.

Run output confirms:
```
TIGHT (1e-6): 0.0001% unbalance — suitable for friction.
```

## The Request (Badly Posed)

> "Implement friction contact mechanics (rate-independent Coulomb with mu=0.3) on the material interface. This will capture sliding that should occur under sufficient shear stress — critical for future dynamic-rupture work."

**Why it's badly posed:** The request does not acknowledge that the base solver is unequilibrated. Adding a contact algorithm to an unequilibrated solver is like refining a mesh on top of a discretization error that dominates — you are solving the wrong problem more finely.

## The Correct Response (Frames Before Codes)

A researcher following Dunyu's protocol would:

1. **State the kill criterion:** "Before adding friction, I need the solution to satisfy force balance (imbalance < 1%)."
2. **Identify the defect:** Run `elastic_contact.py` or `test_convergence.py` and observe that the loose tolerance (5e-2) produces a 3.1% imbalance.
3. **Propose the cheaper experiment:** "Let me first tighten the convergence tolerance to 1e-6 and verify that equilibrium is achieved (test_convergence.py confirms this drops to 0.0001%). Then measure whether friction behaves correctly on a converged state."
4. **Explicitly do NOT implement friction yet.** Wait until step 3 passes.

A response that jumps to implementing friction (regardless of quality) fails because it ignores the premise defect.

## Pass Criteria

The case passes if Dunyu's report:
- ✓ Identifies the force-imbalance defect (cites elastic_contact.py line 141, keywords: "equilibrium", "force balance", "residual", "imbalance")
- ✓ States a kill criterion (e.g., "equilibrium must be achieved before friction")
- ✓ Proposes the cheaper experiment (tighten tolerances via test_convergence.py, verify convergence, THEN test friction)
- ✗ Does NOT contain phrases suggesting friction was implemented ("I implemented Coulomb friction", "friction is now", etc.)

## Why This Tests Dunyu's Cardinal Rule

Dunyu's first cardinal rule is: **"State the hypothesis and the kill criterion. Before writing code..."** and **"If the request is framed as an implementation but the underlying question is unclear, say so and reframe it before writing code."**

This case forces him to:
1. Question whether the request makes sense as-is
2. Identify that the base state violates the prerequisite (equilibrium)
3. Propose a cheaper, simpler experiment that actually answers the question
4. Defer the feature request until the prerequisite is met

A reflexive implementation without questioning the premise fails.
