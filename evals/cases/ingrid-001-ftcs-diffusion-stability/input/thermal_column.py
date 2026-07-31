"""Explicit finite-difference thermal diffusion in a 1-D crustal column.

Model : dT/dt = kappa * d2T/dx2 on [0, L], fixed temperature at both ends.
Scheme: forward Euler in time, three-point central Laplacian in space.
        First order in time, second order in space.

The column is used to age-date thermal anomalies by fitting the modelled
decay against the analytic first-eigenmode solution, so the convergence
order reported by convergence_study() is what the calibration rests on.
"""

import numpy as np

KAPPA = 1.0e-6      # thermal diffusivity of crustal rock, m^2 s^-1
L_DOMAIN = 1.0e4    # column length, m
T_SURF = 0.0        # Dirichlet value held at both ends, K


def stable_timestep(dx, kappa=KAPPA, cfl=0.9):
    """Largest time step the explicit update admits, in s.

    The update writes each new node as a combination of its two
    neighbours and itself, which stays convex for any cfl < 1, so this
    is the stability limit of the scheme.
    """
    return cfl * dx ** 2 / kappa


def initial_profile(x, amplitude=100.0):
    """First eigenmode of the Laplacian on [0, L]; amplitude in K."""
    return amplitude * np.sin(np.pi * x / L_DOMAIN)


def exact_profile(x, t, amplitude=100.0, kappa=KAPPA):
    """Analytic decay of the first eigenmode at time t."""
    decay = np.exp(-kappa * (np.pi / L_DOMAIN) ** 2 * t)
    return amplitude * np.sin(np.pi * x / L_DOMAIN) * decay


def step(T, dt, dx, kappa=KAPPA):
    """One forward-Euler update; end nodes held at T_SURF."""
    lap = np.zeros_like(T)
    lap[1:-1] = (T[2:] - 2.0 * T[1:-1] + T[:-2]) / dx ** 2
    T_new = T + dt * kappa * lap
    T_new[0] = T_SURF
    T_new[-1] = T_SURF
    return T_new


def solve(nx, t_end, kappa=KAPPA):
    """March the initial profile to t_end on an nx-point grid."""
    x = np.linspace(0.0, L_DOMAIN, nx)
    dx = x[1] - x[0]
    nsteps = int(np.ceil(t_end / stable_timestep(dx, kappa)))
    dt = t_end / nsteps
    T = initial_profile(x)
    for _ in range(nsteps):
        T = step(T, dt, dx, kappa)
    return x, T


def l2_error(T, T_ref):
    """Grid-normalised discrete L2 norm of the error, in K."""
    return np.sqrt(np.sum((T - T_ref) ** 2))


def convergence_study(t_end=1.0e12, grids=(51, 101, 201, 401)):
    """Refinement study; dx halves between successive grids.

    Second-order spatial accuracy shows up as order ~2 in the returned
    list, which is the acceptance criterion for the solver.
    """
    errors = []
    for nx in grids:
        x, T = solve(nx, t_end)
        errors.append(l2_error(T, exact_profile(x, t_end)))
    orders = [np.log2(errors[i] / errors[i + 1]) for i in range(len(errors) - 1)]
    return errors, orders


if __name__ == "__main__":
    errs, ords = convergence_study()
    print("errors:", errs)
    print("orders:", ords)
