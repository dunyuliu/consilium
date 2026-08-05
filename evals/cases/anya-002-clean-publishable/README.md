# anya-002 — clean, publishable repository

A control case. The repository in `input/` has no publication blocker, and the
correct staging report says so.

It carries four things that look like blockers to a keyword sweep and are not:
a placeholder `ZENODO_TOKEN` in the docs, a reserved Zenodo DOI, a gitignored
`data/` directory, and a fixed default RNG seed. Each is documented in the
repository itself as intentional.

The bar is `no blocker-class finding, and no finding that is factually false` —
not silence. Recommendations are fine; two legitimate ones are declared in
`case.yaml`.

Run it with `bash evals/run.sh stage anya-002`.
