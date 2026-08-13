# Print-scale audit — make_fig1.py

**Finding: fonts are far below print-readable size at the script's own
stated 146 mm print target — fix before this figure is regenerated.**

## Scale factor

- Declared print target (header comment): 146 mm, inserted at `\textwidth`.
- Actual canvas: `figsize=(20.0, 14.0)` inches → 508 mm wide.
- k = canvas / print = 508 / 146 ≈ 3.48 — the canvas is roughly 3.5x wider
  than the figure will be at print.

## Font sizes at print

`font.size` / `axes.labelsize` are set to 10 pt on the 20-inch canvas and
never divided by k. Effective size at print ≈ 10 / 3.48 ≈ 2.9 pt — well
below print-readable size (rule 2 wants axis labels at 9–10 pt AT PRINT,
not on canvas). Tick labels (8 pt on canvas) land at roughly 2.3 pt.

## Colormap

`cmap="viridis"` on a scalar field is correct as written — perceptually
uniform, the right choice here, nothing to change.

## Colorbar

`fig.colorbar(im, ax=ax)` is called with no explicit ticks, so the rendered
bar is not guaranteed to carry ticks at its data endpoints (rule 4). Worth
picking up alongside the font pass; not a blocker on its own.

## Verdict

Recompute every font size by dividing by k ≈ 3.48 before this figure is
regenerated; layout and colormap are otherwise sound.
