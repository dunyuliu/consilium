---
description: Stage a project for public release — GitHub publish-ready repo and Zenodo-ready data bundle. Scrubs for credentials, fixes reproducibility floor, generates CITATION.cff and Zenodo metadata, mints a DOI.
---

Invoke `anya-petrov` to stage the current project (or the path given as
argument) for public publication. She will scrub for secrets and internal
references, audit the reproducibility floor, prepare a GitHub release with
LICENSE / CITATION.cff / README, and assemble a Zenodo-archivable data
bundle with metadata, MANIFEST.sha256, and a minted (or proposed) DOI.
Blockers are reported before any publish-step is taken; the human gives
the final go-ahead.
