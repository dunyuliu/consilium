---
description: Release workflow — audit first (victor-reyes + PROJECT_RULES.md), fix findings, verify the tree over a green gate, then cut the version, write release notes, commit, push the commit, gate on a green CI run for that SHA, and only then create the tag and its Release together. Triggers — `release` (patch), `release minor`, `release major`.
---

Invoke `haruto-nakamura`, fresh, to run the release workflow — never resume a
finished one, which keeps its old prompt. The trigger word is the argument passed
(`release`, `release minor`, or `release major`); his prompt holds the gates.
