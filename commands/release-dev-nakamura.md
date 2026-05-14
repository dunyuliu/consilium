---
description: Release workflow — bump version, archive old release notes to docs/, audit against PROJECT_RULES.md, write release notes, re-verify, then commit. Triggers — `release` (patch), `release minor`, `release major`.
---

Invoke `dev-nakamura` to run the release workflow. The trigger word is the argument passed (`release`, `release minor`, or `release major`).
