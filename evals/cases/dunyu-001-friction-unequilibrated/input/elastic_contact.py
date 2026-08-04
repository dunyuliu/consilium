"""Quasi-static 2D linear elasticity with a material interface (contact surface).

Model: Two materials meeting at x=L/2, loaded with boundary traction.
       Displacement field u = [u_x, u_y], stress σ = C : ε.
       Force balance (residual): R = K*u - f_ext, should → 0.

Solver: Simple fixed-point iteration with viscous drag damping.
        Convergence criterion: max|R| / max|f_ext| < 5e-2 (loose tolerance).

The contact interface is non-slip (no sliding, just normal contact for now).
Future work: Add Coulomb friction to capture sliding failure modes.
"""

import numpy as np


class ElasticDomain2D:
    """Two-material 1D bar problem cast as 2D with contact at x=L/2."""

    def __init__(self, nx=21, ny=3, L=1.0, E1=1.0, E2=0.8, nu=0.25):
        """
        nx, ny: grid nodes in x, y directions.
        L: domain length.
        E1, E2: Young's moduli (material 1 left of x=L/2, material 2 right).
        nu: Poisson's ratio (same for both).
        """
        self.nx = nx
        self.ny = ny
        self.L = L
        self.E1 = E1
        self.E2 = E2
        self.nu = nu
        self.dx = L / (nx - 1)
        self.dy = L / (ny - 1)

        # Contact interface location.
        self.interface_x = L / 2.0

        # DOF layout: 2D, nodes ordered i + j*nx, each has [u_x, u_y].
        self.ndof = 2 * nx * ny

        # Stiffness matrix (sparse, stored dense for simplicity).
        self.K = np.zeros((self.ndof, self.ndof))

        # External force vector.
        self.f_ext = np.zeros(self.ndof)

        # Current displacement.
        self.u = np.zeros(self.ndof)

        # Build stiffness: simple 4-node quad elements.
        self._assemble_stiffness()

    def _assemble_stiffness(self):
        """
        Assemble stiffness from 4-node quad elements.
        Each node i, j (in 2D grid) corresponds to linear DOF index 2*(i + j*nx).
        Material: E1 if quad center x < L/2, else E2.
        """
        for j in range(self.ny - 1):
            for i in range(self.nx - 1):
                # Quad corners: (i,j), (i+1,j), (i+1,j+1), (i,j+1)
                center_x = (i + 0.5) * self.dx
                E = self.E1 if center_x < self.interface_x else self.E2

                # Local stiffness for 4-node quad (simplified, 8x8).
                k_e = self._quad_stiffness(E, self.nu)

                # Global DOF indices for this quad.
                dofs = np.array(
                    [
                        2 * (i + j * self.nx),
                        2 * (i + j * self.nx) + 1,
                        2 * (i + 1 + j * self.nx),
                        2 * (i + 1 + j * self.nx) + 1,
                        2 * (i + 1 + (j + 1) * self.nx),
                        2 * (i + 1 + (j + 1) * self.nx) + 1,
                        2 * (i + (j + 1) * self.nx),
                        2 * (i + (j + 1) * self.nx) + 1,
                    ]
                )

                # Assemble into global K.
                for local_i, global_i in enumerate(dofs):
                    for local_j, global_j in enumerate(dofs):
                        self.K[global_i, global_j] += k_e[local_i, local_j]

    def _quad_stiffness(self, E, nu):
        """
        Simplified 4-node quad stiffness matrix (8x8 DOF, 2 per node).
        Bilinear quad, unit size, analytic integration.
        Returns the local stiffness matrix.
        """
        # Lamé parameters.
        lam = E * nu / ((1 + nu) * (1 - 2 * nu))
        mu = E / (2 * (1 + nu))

        # Simplified stiffness: each node contributes approximately.
        # For a unit square quad with full integration, a rough approximation:
        k_e = np.zeros((8, 8))

        # Diagonal (self-stiffness at each node, x and y).
        for i in range(4):
            k_e[2 * i, 2 * i] = (lam + 2 * mu) / 3.0
            k_e[2 * i + 1, 2 * i + 1] = mu / 3.0

        # Off-diagonal coupling (simplified; not a full FEM assembly).
        # Just enough to make the system non-trivial.
        k_e[0, 2] = -mu / 6.0
        k_e[2, 0] = -mu / 6.0
        k_e[1, 3] = -mu / 6.0
        k_e[3, 1] = -mu / 6.0

        return k_e

    def apply_boundary_conditions(self):
        """
        Fix left edge (x=0): u_x[0,j] = 0 for all j.
        Fix bottom edge (y=0): u_y[i,0] = 0 for all i.
        Apply traction on right edge (x=L): f_x = 0.01 (shear-like).
        """
        # Left edge: u_x fixed to zero.
        for j in range(self.ny):
            dof_ux = 2 * (0 + j * self.nx)
            self.K[dof_ux, :] = 0.0
            self.K[dof_ux, dof_ux] = 1.0
            self.u[dof_ux] = 0.0

        # Bottom edge: u_y fixed to zero.
        for i in range(self.nx):
            dof_uy = 2 * (i + 0 * self.nx) + 1
            self.K[dof_uy, :] = 0.0
            self.K[dof_uy, dof_uy] = 1.0
            self.u[dof_uy] = 0.0

        # Right edge: apply shear traction f_x = 0.01.
        for j in range(self.ny):
            dof_ux = 2 * (self.nx - 1 + j * self.nx)
            self.f_ext[dof_ux] = 0.01

    def solve_fixed_point(self, max_iter=50, tolerance=5e-2):
        """
        Fixed-point iteration: u_new = u_old + α * (K^{-1} * (f_ext - K*u_old))
        α < 1 is damping to mimic viscous drag. Converge until residual < tolerance.
        Returns residual history and final solution.
        
        NOTE: tolerance=5e-2 (default) leaves ~3% force imbalance. Tighten to 
              1e-6 for proper equilibrium suitable for friction mechanics.
        """
        residuals = []
        alpha = 0.5  # damping factor (viscous drag timescale).

        for iteration in range(max_iter):
            # Residual: R = f_ext - K*u
            residual = self.f_ext - self.K @ self.u

            # Norm of residual.
            res_norm = np.linalg.norm(residual)
            f_norm = np.linalg.norm(self.f_ext)
            rel_residual = res_norm / (f_norm + 1e-16)
            residuals.append(rel_residual)

            if rel_residual < tolerance:
                print(f"Converged in {iteration} iterations.")
                break

            # Solve K * du = R, then u += alpha * du.
            try:
                du = np.linalg.solve(self.K, residual)
                self.u += alpha * du
            except np.linalg.LinAlgError:
                print("Singular matrix; stopping.")
                break

        return np.array(residuals)

    def get_residual(self):
        """Return the final force residual: R = f_ext - K*u."""
        return self.f_ext - self.K @ self.u

    def strain_energy(self):
        """Return 0.5 * u^T * K * u."""
        return 0.5 * self.u @ self.K @ self.u


def main():
    """Run the solver and report equilibrium."""
    print("=" * 60)
    print("Elastic solver with unequilibrated contact interface.")
    print("=" * 60)

    # Create domain and apply BC.
    domain = ElasticDomain2D(nx=21, ny=3, L=1.0, E1=1.0, E2=0.8)
    domain.apply_boundary_conditions()

    # Solve with LOOSE tolerance (default).
    residuals = domain.solve_fixed_point(max_iter=100, tolerance=5e-2)

    # Report final state.
    print(f"\nFinal relative residual: {residuals[-1]:.4e}")
    print(f"Number of iterations: {len(residuals)}")
    print(f"Strain energy: {domain.strain_energy():.4e}")

    # Check equilibrium: is |R| small?
    R_final = domain.get_residual()
    R_norm = np.linalg.norm(R_final)
    f_norm = np.linalg.norm(domain.f_ext)
    equilibrium_error = R_norm / (f_norm + 1e-16)

    print(f"\nEquilibrium check:")
    print(f"  max|R| = {np.max(np.abs(R_final)):.4e}")
    print(f"  ||R||_2 = {R_norm:.4e}")
    print(f"  ||f_ext||_2 = {f_norm:.4e}")
    print(f"  Equilibrium error (||R|| / ||f||): {equilibrium_error:.4e}")

    if equilibrium_error > 0.01:
        print(
            f"\nWARNING: Equilibrium NOT satisfied (error {equilibrium_error*100:.2f}%)."
        )
        print("  The solution has significant force imbalance.")
        print("  Contact mechanics will be UNRELIABLE until base state converges.")
        print("  To achieve equilibrium, tighten solve_fixed_point() tolerance to 1e-6.")
    else:
        print("\nOK: Solution is in acceptable equilibrium (error < 1%).")

    return domain


if __name__ == "__main__":
    domain = main()
