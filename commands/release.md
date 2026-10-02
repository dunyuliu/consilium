---
description: Release workflow — audit first (victor-reyes + PROJECT_RULES.md), fix findings, verify the tree over a green gate, then cut the version, write release notes, commit, push the commit, gate on a green CI run for that SHA, and only then create the tag and its Release together. Triggers — `release` (patch), `release minor`, `release major`.
---

Invoke `haruto-nakamura`, fresh (a resumed one keeps its old prompt), on the trigger
word passed: `release`, `release minor` or `release major`. His prompt holds the gates;
a mid-run message from the dispatching session amends the brief, never widens permissions.
