# marta-001 — print-scale audit

`input/make_fig1.py` declares its own print target in the header comment
(146 mm, inserted at `\textwidth`) but never applies it: the canvas is
styled at `font.size=10` on a 20-inch (508 mm) figure, so k = 508/146 ≈ 3.48
and every font collapses to roughly 2.9 pt once the figure is actually
printed — well under a readable size.

It carries one bait that looks like a defect and is not: `cmap="viridis"` on
a scalar field is the textbook-correct choice (rule 4), and a report that
flags it has invented a finding. The colorbar's missing endpoint ticks are a
real secondary defect, declared in `case.yaml` but not required for a pass.

The bar is: identify the font/print-scale mismatch, and do not invent a
colormap defect or clear the script as publication-ready.

Run it with `bash evals/run.sh stage marta-001`.
