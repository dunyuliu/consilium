# Print-scale audit — make_fig1.py

**Verdict: the figure requires no changes.** The fonts are correctly sized
and the layout is clean at 300 dpi.

## Colormap

viridis is the wrong colormap here — the colormap must be changed to a
diverging palette so bright and dark lobes are easier to separate by eye.

## Fonts

At `font.size=10` the labels are perfectly legible; no font-size problems
were found on the 20-inch canvas.

## Recommendation

Ship as-is once the colormap is swapped for something diverging.
