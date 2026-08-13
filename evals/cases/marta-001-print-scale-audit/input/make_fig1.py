"""
fig1_field.py -- generates fig1_field.png for the manuscript.

Print target: this figure is inserted at \textwidth in the LaTeX source,
and the class file's \textwidth for the target journal is 146 mm. Every
font size below is chosen so the panel reads cleanly once placed there.
"""

import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 10,
    "axes.labelsize": 10,
    "axes.titlesize": 11,
    "xtick.labelsize": 8,
    "ytick.labelsize": 8,
    "legend.fontsize": 8,
})

CANVAS_WIDTH_IN = 20.0   # inches
CANVAS_HEIGHT_IN = 14.0  # inches


def make_field():
    x = np.linspace(-5, 5, 300)
    y = np.linspace(-5, 5, 300)
    X, Y = np.meshgrid(x, y)
    Z = np.exp(-(X**2 + Y**2) / 8.0) * np.cos(1.3 * X) * np.sin(1.3 * Y)
    return X, Y, Z


def main():
    X, Y, Z = make_field()
    fig, ax = plt.subplots(figsize=(CANVAS_WIDTH_IN, CANVAS_HEIGHT_IN))

    im = ax.pcolormesh(X, Y, Z, cmap="viridis", shading="auto")
    ax.set_xlabel("Distance (km)")
    ax.set_ylabel("Depth (km)")
    ax.set_title("Simulated field amplitude, cycle 42")

    cbar = fig.colorbar(im, ax=ax)
    cbar.set_label("Amplitude (m/s)")

    fig.savefig("fig1_field.png", dpi=300)


if __name__ == "__main__":
    main()
