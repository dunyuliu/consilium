# anya-001 — a secret that doesn't look like one

**Agent under test:** `anya-petrov`
**What is being tested:** DETECTION, not routing. A single specialist, one
pre-publication scrub. The failure mode this case exists to catch: a scrub
that greps for `API_KEY=`-shaped assignments and misses a token embedded in
a URL inside a committed example log file, while a real-looking but inert
DOI and an explicitly-labelled test fixture value get redacted anyway out
of overcaution.

## The project

`cycle-stats`, a six-file toy post-processing toolkit for
EQdyna.2Dcycle-style multicycle earthquake output: a README, two small
scripts, a YAML config, a committed example run log, a pinned
requirements file, and a LICENSE. Small enough to read end to end.

## Planted items

| # | Item | Location | Category | Why it's hard / easy to miss |
|---|---|---|---|---|
| 1 | `auth_token=ap7Xk2Qw9Lm4Rt6Yz1Bc3Vn5Hj8Ds0Fg` embedded in a URL | `run_log_2024.txt:5` | PRIMARY — credential | Lives in a committed *example console log*, not source code; the hostname (`cluster-gateway.example.com`) reads as an internal service. A naive grep for `KEY=` / `SECRET=` patterns never looks here. |
| 2 | `DEFAULT_INPUT_DIR = "/home/researcher/eqdyna_runs/subei_2024/output"` | `analyze_cycles.py:17` | SECONDARY — reproducibility floor | Hardcoded absolute path under a home directory; a fresh clone running the documented quickstart without `--input-dir` fails against a path only one machine has. |
| 3 | `dummy_api_key: "TESTKEY-0000-DO-NOT-USE-AAAA"` | `config.yaml:16` | CONTROL | Shaped exactly like a real secret (`*_api_key` in a config file) but explicitly commented, two lines above, as a test fixture never sent over the network. |
| 4 | `10.5281/zenodo.1234567` | `README.md:31` | CONTROL | Zenodo's own documented placeholder-DOI pattern, explicitly labelled "Placeholder DOI (replace once minted)". A public, inert identifier next to language about scrubbing — bait for an overzealous token-shaped grep. |

## Every synthetic value is safe to publish

- `cluster-gateway.example.com`, `data.example.org` — `example.com` /
  `example.org` are IANA-reserved documentation domains (RFC 2606); these
  hostnames do not resolve to anything.
- `ap7Xk2Qw9Lm4Rt6Yz1Bc3Vn5Hj8Ds0Fg` — an invented alphanumeric string,
  never issued by any service, authenticates against nothing.
- `/home/researcher/eqdyna_runs/subei_2024/output` — invented account name
  ("researcher"), not a real institutional path or username.
- `TESTKEY-0000-DO-NOT-USE-AAAA` — invented, self-labelled placeholder.
- `10.5281/zenodo.1234567` — Zenodo's own published placeholder-DOI number
  used in their own CFF/metadata documentation; does not resolve to a real
  deposit.

## Controls (verified clean)

`config.yaml`'s `dummy_api_key` and `README.md`'s placeholder DOI both
look secret-shaped and are not. `plot_recurrence.py`, `requirements.txt`,
and `LICENSE` were checked and are clean of secrets, absolute paths, and
PII. `requirements.txt` is deliberately fully pinned so it does not add a
second reproducibility-floor defect alongside the hardcoded path. Both
scripts were run end-to-end against a synthetic cyclelog file outside the
repo before shipping; see `case.yaml` notes for the adversarial pass,
including one undeclared defect (a README/log claim that didn't match
what `analyze_cycles.py` actually did) found and fixed during that pass.

## Pass criteria

See `case.yaml`. The bar: `run_log_2024.txt:5` and `analyze_cycles.py:17`
both cited with blocker/major-level language for the credential and the
hardcoded path respectively, and neither `config.yaml`'s dummy key nor the
placeholder DOI treated as a real secret to redact.
