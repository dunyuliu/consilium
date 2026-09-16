"""Depth-averaged tidal-channel solver (see README for the formulation)."""

from __future__ import annotations

import numpy as np

G = 9.81


def cfl_step(h: np.ndarray, u: np.ndarray, dx: float, safety: float = 0.45) -> float:
    """Largest stable step for the current state."""
    wave = np.abs(u) + np.sqrt(G * np.maximum(h, 1e-6))
    return safety * dx / float(wave.max())


def flux_limited_upwind(q: np.ndarray, u_face: np.ndarray) -> np.ndarray:
    """Face values of q, upwinded with a minmod limiter."""
    dq = np.diff(q, prepend=q[0], append=q[-1])
    r = np.where(np.abs(dq[1:]) > 1e-12, dq[:-1] / dq[1:], 0.0)
    phi = np.maximum(0.0, np.minimum(1.0, r))
    left = q + 0.5 * phi * dq[1:]
    right = np.roll(q, -1) - 0.5 * phi * dq[1:]
    return np.where(u_face >= 0.0, left, right)


def momentum_rhs(h, u, eta, dx, c_d, a_h):
    hu = h * u
    u_face = 0.5 * (u + np.roll(u, -1))
    adv = np.diff(flux_limited_upwind(hu * u, u_face), prepend=0.0) / dx
    pressure = G * h * np.diff(eta, prepend=eta[0]) / dx
    drag = c_d * u * np.abs(u)
    visc = a_h * (np.roll(hu, -1) - 2.0 * hu + np.roll(hu, 1)) / dx**2
    return -adv - pressure - drag + visc


def step(state, dx, dt, c_d, a_h):
    """One two-stage Runge-Kutta step in flux form."""
    h, u, eta = state["h"], state["u"], state["eta"]

    k1 = momentum_rhs(h, u, eta, dx, c_d, a_h)
    u_mid = u + 0.5 * dt * k1 / np.maximum(h, 1e-6)
    k2 = momentum_rhs(h, u_mid, eta, dx, c_d, a_h)

    hu_new = h * u + dt * k2
    h_new = h - dt * np.diff(h * u, append=(h * u)[-1]) / dx

    return {
        "h": h_new,
        "u": hu_new / np.maximum(h_new, 1e-6),
        "eta": eta + (h_new - h),
    }
