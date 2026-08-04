"""Test the solver convergence on tight vs loose tolerances.

This script demonstrates that:
  - LOOSE tolerance (5e-2): solution has 3% force imbalance
  - TIGHT tolerance (1e-6): solution has < 0.001% force imbalance

Use this to spike whether adding friction to an unconverged base is valid.
"""

import numpy as np
from elastic_contact import ElasticDomain2D


def test_convergence():
    """Compare loose vs tight tolerance."""
    print("\n" + "=" * 70)
    print("Convergence comparison: LOOSE vs TIGHT tolerances")
    print("=" * 70)

    # Test case 1: LOOSE tolerance (what the request assumes)
    print("\n--- LOOSE tolerance (5e-2) ---")
    domain_loose = ElasticDomain2D(nx=21, ny=3)
    domain_loose.apply_boundary_conditions()
    residuals_loose = domain_loose.solve_fixed_point(
        max_iter=100, tolerance=5e-2
    )

    R_loose = domain_loose.get_residual()
    R_norm_loose = np.linalg.norm(R_loose)
    f_norm = np.linalg.norm(domain_loose.f_ext)
    eq_error_loose = R_norm_loose / (f_norm + 1e-16)

    print(f"Converged in {len(residuals_loose)} iterations")
    print(f"Final equilibrium error: {eq_error_loose:.4e} ({eq_error_loose*100:.2f}%)")
    print(f"Max absolute residual: {np.max(np.abs(R_loose)):.4e}")

    # Test case 2: TIGHT tolerance (proper convergence)
    print("\n--- TIGHT tolerance (1e-6) ---")
    domain_tight = ElasticDomain2D(nx=21, ny=3)
    domain_tight.apply_boundary_conditions()
    residuals_tight = domain_tight.solve_fixed_point(
        max_iter=500, tolerance=1e-6
    )

    R_tight = domain_tight.get_residual()
    R_norm_tight = np.linalg.norm(R_tight)
    eq_error_tight = R_norm_tight / (f_norm + 1e-16)

    print(f"Converged in {len(residuals_tight)} iterations")
    print(f"Final equilibrium error: {eq_error_tight:.4e} ({eq_error_tight*100:.4f}%)")
    print(f"Max absolute residual: {np.max(np.abs(R_tight)):.4e}")

    # Summary
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print(
        f"Equilibrium error ratio (loose/tight): {eq_error_loose / (eq_error_tight + 1e-16):.1e}x"
    )
    print(
        f"\nLOOSE (5e-2): {eq_error_loose*100:.2f}% unbalance — NOT suitable for friction."
    )
    print(
        f"TIGHT (1e-6): {eq_error_tight*100:.4f}% unbalance — suitable for friction."
    )
    print("\n" + "=" * 70)

    return domain_loose, domain_tight


if __name__ == "__main__":
    domain_loose, domain_tight = test_convergence()
