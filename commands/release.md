---
description: Release workflow — audit first (victor-reyes + PROJECT_RULES.md), fix findings, verify the tree over a green gate, then cut the version, write release notes, commit, tag, and push. Triggers — `release` (patch), `release minor`, `release major`.
---

Invoke `haruto-nakamura` to run the release workflow. The trigger word is the argument passed (`release`, `release minor`, or `release major`).
