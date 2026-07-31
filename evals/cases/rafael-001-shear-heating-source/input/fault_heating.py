"""Coseismic frictional heating across a fault-normal profile.

Conduction normal to a slipping fault,

    rho * c * dT/dt = K * d2T/dz2 + Q(z, t),

with shear heating generated inside a shear zone of finite width straddling
the slip surface. Only the half-profile z >= 0 is carried; the solution is
symmetric about the fault.

Symbols
    z    fault-normal coordinate (m), z = 0 on the slip surface
    T    temperature (K)
    tau  shear traction resisting slip (Pa)
    V    slip rate (m/s)
    w    shear-zone width (m)
"""

import numpy as np

RHO = 2700.0        # kg m^-3        crustal density
C_P = 1000.0        # J kg^-1 K^-1   specific heat capacity
K_TH = 3.0          # W m^-1 K^-1    thermal conductivity
T_AMBIENT = 480.0   # K              geotherm at ~10 km depth
T_MELT = 1450.0     # K              granite solidus


def diffusivity():
    """Thermal diffusivity of the host rock."""
    return K_TH / (RHO * C_P)


def build_grid(half_width, nz):
    """Cell-centred grid on [0, half_width]; the fault sits at z = 0."""
    dz = half_width / nz
    z = (np.arange(nz) + 0.5) * dz
    return z, dz


def shear_zone_mask(z, w):
    """Cells of the half-profile that lie inside the shear zone."""
    return z < 0.5 * w


def frictional_power(tau, slip_rate):
    """Power dissipated by sliding friction, per unit area of the fault."""
    return tau * slip_rate


def laplacian(T, dz):
    """Second fault-normal derivative of T on the half-profile."""
    lap = np.empty_like(T)
    lap[1:-1] = (T[2:] - 2.0 * T[1:-1] + T[:-2]) / dz ** 2
    lap[0] = (T[1] - T[0]) / dz ** 2       # mirror symmetry across the fault
    lap[-1] = (T[-2] - T[-1]) / dz ** 2    # no conductive flux at the far edge
    return lap


def step(T, dz, dt, tau, slip_rate, in_shear_zone):
    """Advance the profile one explicit (FTCS) step."""
    Tn = T + dt * diffusivity() * laplacian(T, dz)
    q = frictional_power(tau, slip_rate)
    Tn[in_shear_zone] += q * dt / (RHO * C_P)
    return np.clip(Tn, T_AMBIENT, T_MELT)


def run(duration, tau, slip_rate, w=0.01, half_width=0.1, nz=1000, cfl=0.4):
    """Integrate `duration` seconds of steady sliding at `slip_rate`."""
    z, dz = build_grid(half_width, nz)
    dt = cfl * dz ** 2 / diffusivity()
    in_shear_zone = shear_zone_mask(z, w)
    T = np.full(nz, T_AMBIENT)
    for _ in range(int(round(duration / dt))):
        T = step(T, dz, dt, tau, slip_rate, in_shear_zone)
    return z, T


if __name__ == "__main__":
    z, T = run(duration=1.0, tau=20.0e6, slip_rate=1.0)
    print(f"peak T = {T.max():.1f} K  (ambient {T_AMBIENT:.1f} K)")
