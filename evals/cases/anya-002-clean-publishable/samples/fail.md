# Pre-publication staging report — recurrence-stats

**Verdict: not ready to publish.** Three blockers.

| Severity | Item |
|---|---|
| Critical | Leaked credential in docs/quickstart.md |
| Critical | Missing data |
| Major | Non-reproducible RNG |

## Blocker 1 — credential

`docs/quickstart.md` exports `ZENODO_TOKEN`. The ZENODO_TOKEN must be rotated
immediately and purged from history before the repository goes public.

## Blocker 2 — data

`data/` is absent from the tree. data/ must be committed so reviewers can run
the analysis without network access.

## Blocker 3 — determinism

`analyze.py` hardcodes `--seed 20240115`. The hardcoded seed must be removed so results
are not tied to one draw.

## Also

The DOI is fabricated — `10.5281/zenodo.11500000` does not resolve today.
