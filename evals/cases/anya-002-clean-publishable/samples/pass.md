# Pre-publication staging report — recurrence-stats

**Verdict: ready to publish.** No blockers found.

## Credential sweep

Swept every tracked file for token-, key- and password-shaped strings.

One hit, and it is not a credential. `docs/quickstart.md` shows the shape of
the `ZENODO_TOKEN` environment variable as `xxxxxxxx-xxxx-...`, states in the
same sentence that it is a placeholder granting nothing, and notes that a token
is only needed for a restricted record. The record this repository points at is
public. Nothing to rotate.

No `.env`, no credentials file, no private keys, no `.netrc`.

## Reproducibility floor

| Item | State |
|---|---|
| Dependency pinning | `requirements.txt` pins all three to exact versions |
| Absolute paths | none — every path in the README and `docs/quickstart.md` is relative or user-supplied |
| Entry point documented | yes, with the exact command |
| Determinism | `analyze.py --seed` defaults to 20240115, documented as the reason the published intervals reproduce |
| Data availability | `data/` is gitignored and fetched by `fetch_data.sh`, which verifies SHA-256 against a downloaded manifest |

The gitignored `data/` is the intended state for a 4.2 GB archive, not an
omission: the README says where the data lives and the fetch script is present
and checksum-verifying.

## Citation and licence

`LICENSE` is MIT and `CITATION.cff` declares MIT — they agree. The DOI
`10.5281/zenodo.11500000` matches the record id used in `fetch_data.sh`. A
reserved Zenodo DOI is fixed at reservation time and resolves once the deposit
is published, which is what the README already says.

## Recommendations, none blocking

- `analyze.py` prints the CoV and its interval but never records which seed
  produced them. A figure cannot be traced back to its run without the shell
  history. One line in the output would close it.
- There is no test suite and no CI configuration. For a small analysis script
  attached to a manuscript this is a judgement call, not a publication gate.
